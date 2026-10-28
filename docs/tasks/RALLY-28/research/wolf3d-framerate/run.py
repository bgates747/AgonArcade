"""Finite headless Wolf3D gameplay observation; no application instrumentation."""
from pathlib import Path
import hashlib
import json
import math
import os
import signal
import socket
import struct
import subprocess
import time

HERE = Path(__file__).resolve().parent
BOOST = Path('/sys/devices/system/cpu/cpufreq/boost')
PREFIX = b'\x81\x0aW3DR\x01\x01\x3d\x57'
POSE = b'\x17\x00\xa0\x01\x00\x4a\x02'


def temperatures():
    return {str(p): int(p.read_text()) / 1000 for p in Path('/sys/class/thermal').glob('thermal_zone*/temp')}


def boost(value):
    subprocess.run(['sudo', '-n', 'tee', str(BOOST)], input=value + '\n', text=True,
        stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)
    assert BOOST.read_text().strip() == value


def main():
    assert socket.gethostname() == 'oryx-linuxlite'
    config = json.loads((HERE / 'PROFILE.json').read_text())
    profile = Path(config['profile'])
    assert not (profile / 'last-run').exists(), 'Preserve previous attempts; stage a fresh profile'
    assert all(hashlib.sha256((profile / n).read_bytes()).hexdigest() == h
        for n, h in config['inputs_sha256'].items())
    report_path = HERE / 'RUN.json'
    assert not report_path.exists()
    state = dict(profile=str(profile), original_boost=BOOST.read_text().strip(),
        host_boot_id=Path('/proc/sys/kernel/random/boot_id').read_text().strip(),
        video_driver='dummy', audio_driver='dummy', windows=[], samples=[], keys=[],
        observations=[], error=None, ended=False, clock='host CLOCK_MONOTONIC',
        capture_flush_seconds=.25, measured_window_seconds=30,
        original_source_modified=False, game_pacing_modified=False)
    report_path.write_text(json.dumps(state, indent=2) + '\n')
    process = None
    tails = {}
    buffers = {'vdp-to-mos-delivered.bin': bytearray(), 'mos-to-vdp.bin': bytearray()}
    sequences = []
    parse_at = 0
    changed = False
    started = time.monotonic()
    last_heartbeat = 0
    right_since = None
    window_start = None
    baseline = None
    last_enter = -10
    release_enter = None
    key_path = profile / 'key-events.txt'
    artifact = profile / 'last-run'
    handles = {}

    def key(scancode, down):
        with key_path.open('a') as output:
            output.write(str(scancode) + ' ' + str(int(down)) + '\n')
        state['keys'].append(dict(host_seconds=time.monotonic() - started, scancode=scancode, down=down))

    def interrupted(signum, frame):
        raise RuntimeError('Interrupted by signal ' + str(signum))

    handlers = {s: signal.signal(s, interrupted) for s in (signal.SIGINT, signal.SIGTERM, signal.SIGHUP)}
    try:
        changed = True
        boost('0')
        env = os.environ.copy()
        env.update(SDL_VIDEODRIVER='dummy', SDL_AUDIODRIVER='dummy',
            LD_PRELOAD=str(profile / 'input.so'), WOLF_KEY_EVENTS=str(key_path))
        artifact.mkdir()
        with (artifact / 'frontend.txt').open('w') as log:
            process = subprocess.Popen(['./flexe-agon-emulator', '--renderer', 'sw'], cwd=profile,
                env=env, stdout=log, stderr=subprocess.STDOUT, start_new_session=True)
            while len(state['windows']) < 2:
                now = time.monotonic()
                elapsed = now - started
                if process.poll() is not None:
                    raise RuntimeError('Frontend exited ' + str(process.returncode))
                if elapsed > 240:
                    raise TimeoutError('No two complete gameplay windows within 240 seconds')
                if BOOST.read_text().strip() != '0':
                    raise RuntimeError('CPU boost changed during unattended run')
                for name in buffers:
                    path = artifact / name
                    if path.exists():
                        if name not in handles: handles[name] = path.open('rb')
                        buffers[name].extend(handles[name].read())
                data = buffers['vdp-to-mos-delivered.bin']
                new = []
                while True:
                    at = data.find(PREFIX, parse_at)
                    if at < 0:
                        parse_at = max(parse_at, len(data) - len(PREFIX))
                        break
                    if at + 12 > len(data):
                        parse_at = at
                        break
                    sequence = struct.unpack_from('<H', data, at + 10)[0]
                    if sequences:
                        assert sequence == (sequences[-1] + 1) & 65535, 'Completion sequence discontinuity'
                    sequences.append(sequence)
                    new.append(sequence)
                    parse_at = at + 12
                if new:
                    state['observations'].append(dict(host_seconds=elapsed, sequences=new,
                        completion_count=len(sequences), outbound_bytes=len(buffers['mos-to-vdp.bin'])))
                if release_enter is not None and now >= release_enter:
                    key(40, False)
                    release_enter = None
                if not sequences:
                    if elapsed >= 6 and elapsed - last_enter >= 2 and release_enter is None:
                        key(40, True)
                        release_enter = now + .12
                        last_enter = elapsed
                elif right_since is None and release_enter is None:
                    key(79, True)
                    right_since = now
                    print('Gameplay started; holding Right; warming up', flush=True)
                if right_since is not None and now - right_since >= 4:
                    if window_start is None:
                        window_start = now
                        baseline = len(sequences)
                    elif now - window_start >= 30:
                        count = len(sequences) - baseline
                        seconds = now - window_start
                        result = dict(completed_frames=count, host_seconds=seconds,
                            completed_fps=count / seconds, first_count=baseline,
                            last_count=len(sequences), start_since_launch=window_start - started,
                            end_since_launch=elapsed)
                        state['windows'].append(result)
                        print('Window', len(state['windows']), count, 'frames;', round(count / seconds, 3), 'FPS', flush=True)
                        window_start = now
                        baseline = len(sequences)
                if elapsed - last_heartbeat >= 15:
                    sample = dict(host_seconds=elapsed, temperatures_celsius=temperatures(),
                        completions=len(sequences), outbound_bytes=len(buffers['mos-to-vdp.bin']),
                        boost=BOOST.read_text().strip())
                    state['samples'].append(sample)
                    print('Elapsed', round(elapsed), 'seconds;', sample, flush=True)
                    report_path.write_text(json.dumps(state, indent=2) + '\n')
                    last_heartbeat = elapsed
                if max(temperatures().values(), default=0) >= 95:
                    raise RuntimeError('Temperature stop reached')
                time.sleep(.025)
            key(79, False)
            # Preserve the final game scene in the adapter's normal shutdown snapshot.
            time.sleep(.35)
            state['ended'] = True
    except BaseException as exc:
        state['error'] = repr(exc)
        raise
    finally:
        for stream in handles.values(): stream.close()
        if process and process.poll() is None:
            for p in Path('/proc').glob('[0-9]*'):
                try:
                    if os.getpgid(int(p.name)) == process.pid and (p / 'exe').resolve() == (profile / 'flexe-agon-emulator.bin').resolve():
                        os.kill(int(p.name), signal.SIGTERM)
                except (OSError, RuntimeError):
                    pass
            try: process.wait(timeout=10)
            except subprocess.TimeoutExpired:
                os.killpg(process.pid, signal.SIGKILL)
                process.wait()
        if process:
            assert process.poll() is not None
            state['process_exit'] = process.returncode
        if changed: boost(state['original_boost'])
        state['final_boost'] = BOOST.read_text().strip()
        state['boost_restored'] = state['final_boost'] == state['original_boost']
        state['elapsed_host_seconds'] = time.monotonic() - started
        state['all_input_hashes_preserved'] = all(hashlib.sha256((profile / n).read_bytes()).hexdigest() == h
            for n, h in config['inputs_sha256'].items())
        state['sequences_observed'] = len(sequences)
        state['consecutive_completion_sequences'] = True
        state['max_sampled_temperature'] = max((v for s in state['samples'] for v in s['temperatures_celsius'].values()), default=None)
        stats = artifact / 'stats.json'
        if stats.exists(): state['backend_stats'] = json.loads(stats.read_text())
        report_path.write_text(json.dumps(state, indent=2) + '\n')
        for s, handler in handlers.items(): signal.signal(s, handler)
        print('Run saved; boost restored:', state['boost_restored'], flush=True)
    assert state['error'] is None and state['process_exit'] == 0
    assert state['all_input_hashes_preserved'] and state['boost_restored']
    assert not any(state['backend_stats'][k] for k in ('failed', 'unhandled', 'unregistered', 'unmapped'))
    frames = sum(w['completed_frames'] for w in state['windows'])
    seconds = sum(w['host_seconds'] for w in state['windows'])
    print('Completed renderer FPS:', frames / seconds, '; frames:', frames, '; seconds:', seconds)


if __name__ == '__main__':
    main()
