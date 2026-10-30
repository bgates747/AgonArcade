"""Bounded silent scene captures; deliberately separate from completed runs."""
from pathlib import Path
import argparse
import hashlib
import json
import os
import shutil
import signal
import struct
import subprocess
import sys
import time

HERE = Path(__file__).resolve().parent
CAPTURES = HERE / 'captures'
THROUGHPUT = HERE.parents[1] / 'throughput'
sys.path.insert(0, str(THROUGHPUT))
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()


def stage(campaign):
    import stage as tool
    original = json.loads((HERE / 'CAPTURE-FIXTURES.json').read_text())
    entries = {}
    for name, info in original.items():
        directory = (HERE / info['directory']).resolve()
        assert directory.is_relative_to(CAPTURES.resolve())
        entries[name] = {**info, 'directory': str(directory.relative_to(CAPTURES.resolve()))}
    registry = CAPTURES / 'FIXTURES.json'
    assert not registry.exists(), 'Preserve previous capture staging'
    registry.write_text(json.dumps(entries, indent=2) + '\n')
    tool.HERE = CAPTURES
    tool.stage(campaign, list(entries))


def stop(proc, profile):
    if proc and proc.poll() is None:
        for child in Path('/proc').glob('[0-9]*'):
            try:
                if (os.getpgid(int(child.name)) == proc.pid and
                    (child / 'exe').resolve() == (profile / 'flexe-agon-emulator.bin').resolve()):
                    os.kill(int(child.name), signal.SIGTERM)
            except OSError:
                pass
        try:
            proc.wait(timeout=10)
        except subprocess.TimeoutExpired:
            os.killpg(proc.pid, signal.SIGKILL)
            proc.wait()


def run_campaign(campaign):
    assert Path('/sys/devices/system/cpu/cpufreq/boost').read_text().strip() == '0'
    entries = json.loads((CAPTURES / ('PROFILES-' + campaign + '.json')).read_text())
    summary = {}
    for name, info in entries.items():
        profile = Path(info['profile'])
        app, artifact = profile / 'sdcard/rally25', profile / 'last-run'
        assert not artifact.exists(), 'Preserve previous capture'
        assert all(sha(profile / n) == h for n, h in info['input_sha256'].items())
        artifact.mkdir()
        dest = CAPTURES / 'evidence' / campaign / name
        dest.mkdir(parents=True, exist_ok=False)
        meta = json.loads((app / 'expected.json').read_text())
        assert meta['diagnostic_hold'] and meta['diagnostic_not_benchmark']
        marker = b'VDPL\x01\x04' + struct.pack('<H', 60000)
        env = os.environ.copy()
        env.update(SDL_VIDEODRIVER='dummy', SDL_AUDIODRIVER='dummy')
        proc, error, seen = None, None, False
        started = time.monotonic()
        try:
            print('Capture', name, 'video=dummy audio=dummy boost=0', flush=True)
            with (artifact / 'frontend.log').open('w') as log:
                proc = subprocess.Popen(['./flexe-agon-emulator', '--renderer', 'sw'],
                                        cwd=profile, env=env, stdout=log,
                                        stderr=subprocess.STDOUT, start_new_session=True)
                while time.monotonic() - started < 90:
                    assert not (app / 'failure.log').exists(), 'Guest diagnostic failure'
                    assert proc.poll() is None, 'Frontend exited before capture marker'
                    wire = artifact / 'vdp-to-mos.bin'
                    data = wire.read_bytes() if wire.exists() else b''
                    if marker in data:
                        assert data.count(marker) == 1
                        seen = True
                        # Marker follows final swap/fence. Allow a published
                        # refresh before the pinned backend's shutdown snapshot.
                        time.sleep(.5)
                        break
                    time.sleep(.1)
                assert seen, 'No ordered capture marker within90 host seconds'
        except BaseException as exc:
            error = repr(exc)
            raise
        finally:
            stop(proc, profile)
            state = dict(error=error, ordered_marker_seen=seen,
                         intentional_interruption_during_hold=True,
                         game_cleanup_validated=False, timing_excluded=True,
                         frames=meta['frames'], physics_ticks=meta['physics_ticks'],
                         host_seconds=round(time.monotonic()-started, 3),
                         process_exit=proc.returncode if proc else None,
                         input_hashes_unchanged=all(sha(profile/n) == h for n, h in info['input_sha256'].items()))
            if error is None:
                stats = json.loads((artifact / 'stats.json').read_text())
                assert proc.returncode == 0 and (artifact / 'final.ppm').exists()
                assert not any(stats.get(k) for k in ('failed', 'unhandled', 'unregistered', 'unmapped'))
                state.update(backend_stats=stats, scene_ppm_sha256=sha(artifact / 'final.ppm'))
            (artifact / 'capture.json').write_text(json.dumps(state, indent=2) + '\n')
            for p in artifact.iterdir():
                if p.is_file():
                    shutil.copyfile(p, dest / (p.with_suffix('.txt').name if p.suffix == '.log' else p.name))
            summary[name] = state
            (CAPTURES / ('CAMPAIGN-' + campaign + '.json')).write_text(json.dumps(summary, indent=2) + '\n')
        assert error is None and summary[name]['input_hashes_unchanged']


if __name__ == '__main__':
    p = argparse.ArgumentParser()
    p.add_argument('action', choices=['stage', 'session'])
    p.add_argument('name')
    p.add_argument('campaign', nargs='?')
    a = p.parse_args()
    if a.action == 'stage':
        stage(a.name)
    else:
        assert a.campaign
        import oryx_session
        oryx_session.HERE = CAPTURES
        oryx_session.run_campaign = run_campaign
        oryx_session.session(a.name, [a.campaign], [])
