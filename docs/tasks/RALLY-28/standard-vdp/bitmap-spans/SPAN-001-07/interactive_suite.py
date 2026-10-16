"""Stage/run a HUMAN-LAUNCHED, visible, silent Flexe comparison suite.

Preparation never launches emulation. Each case gets a fresh isolated profile
and the exact portable inputs. Historical benchmark profiles remain untouched.
"""
from pathlib import Path
import argparse
import hashlib
import importlib.util
import json
import os
import signal
import subprocess
import sys
import time
import zipfile

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[5]
PACKAGE = HERE.parent / 'SPAN-001-09'
APP = Path('sdcard/test/arcade/rally28/road')
ORDER = ['physics', 'polygons-cpu', 'bitmap-arithmetic-cpu', 'bitmap-lookup-cpu',
         'polygons-sparse-cpu', 'empty-live', 'polygons-sparse-live',
         'polygons-live', 'bitmap-arithmetic-live', 'bitmap-lookup-live']


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write_json(path, value):
    temp = path.with_suffix('.tmp')
    with temp.open('w') as f:
        json.dump(value, f, indent=2)
        f.write('\n')
        f.flush()
        os.fsync(f.fileno())
    temp.replace(path)


def prepare(name):
    assert name.startswith('rally28-road-suite-') and Path(name).name == name
    suite = ROOT / '.emulator' / name
    assert not suite.exists(), 'Use a fresh suite name; existing outputs are preserved.'
    manifest = json.loads((PACKAGE / 'PACKAGE.json').read_text())
    jobs = {j['id']: j for j in manifest['jobs']}
    assert set(jobs) == set(ORDER)
    spec = importlib.util.spec_from_file_location('profiles', HERE / 'profiles.py')
    factory = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(factory)
    suite.mkdir()
    staged = []
    with zipfile.ZipFile(PACKAGE / 'PORTABLE.zip') as z:
        assert set(z.namelist()) == set(manifest['files'])
        for member, expected in manifest['files'].items():
            assert hashlib.sha256(z.read(member)).hexdigest() == expected, member
        for index, case in enumerate(ORDER, 1):
            job = jobs[case]
            profile = factory.prepare(name + '-' + case, job.get('variant', 0),
                                      job.get('live', 0), job.get('diagnostic', 0),
                                      job.get('frames', 1), 'flexe')
            identity = json.loads((profile / 'identity.json').read_text())
            for p in (profile / APP).iterdir():
                assert p.is_file()
                p.unlink()  # Only initial placeholder inputs in this fresh profile.
            for filename, expected in job['inputs'].items():
                assert Path(filename).name == filename
                target = profile / APP / filename
                target.write_bytes(z.read(case + '/' + filename))
                assert sha(target) == expected
            (profile / 'esp32-firmware.bin').write_bytes(z.read('vdp_rally_benchmark.bin'))
            assert sha(profile / 'esp32-firmware.bin') == manifest['firmware_sha256']
            (profile / 'sdcard/autoexec.txt').write_bytes(
                ('SET KEYBOARD 1\r\nCD /test/arcade/rally28/road\r\nLOAD ' +
                 job['binary'] + '\r\nRUN .\r\n').encode())
            names = [n for n in identity['files'] if not n.startswith(str(APP) + '/')]
            names += [str(p.relative_to(profile)) for p in (profile / APP).iterdir()]
            identity['files'] = {n: sha(profile / n) for n in names}
            identity['kind'] = job['kind']
            write_json(profile / 'identity.json', identity)
            (profile / '.runtime.sha256').write_text(''.join(
                h + '  ' + n + '\n' for n, h in identity['files'].items()))
            staged.append(dict(index=index, job=job, profile=str(profile),
                               timeout_seconds=180 if job['kind'] == 'physics' else 300))
    write_json(suite / 'suite.json', dict(schema=1, status='staged-not-run',
               archive_sha256=sha(PACKAGE / 'PORTABLE.zip'), cases=staged,
               firmware_sha256=manifest['firmware_sha256']))
    launcher = suite / 'run-suite.sh'
    # Paths are resolved by Python; no interpolated shell command text.
    launcher.write_text('''#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
exec ../../.venv/bin/python ../../docs/tasks/RALLY-28/standard-vdp/bitmap-spans/SPAN-001-07/interactive_suite.py --run "$PWD"
''')
    launcher.chmod(0o755)
    print(suite)
    return suite


def validate(suite):
    manifest = json.loads((suite / 'suite.json').read_text())
    assert [c['job']['id'] for c in manifest['cases']] == ORDER
    for case in manifest['cases']:
        p = Path(case['profile'])
        assert p.parent == ROOT / '.emulator' and p.name.startswith(suite.name + '-')
        identity = json.loads((p / 'identity.json').read_text())
        assert identity['backend'] == 'flexe'
        assert not (p / 'fab-agon-emulator').exists()
        for name, expected in identity['files'].items():
            assert sha(p / name) == expected, name
        for name, expected in case['job']['inputs'].items():
            assert sha(p / APP / name) == expected
        assert sha(p / 'esp32-firmware.bin') == manifest['firmware_sha256']
        assert 'export SDL_AUDIODRIVER=dummy' in (p / 'flexe-agon-emulator').read_text()
        assert not any((p / APP / n).exists() for n in ('started.txt', 'done.txt', 'summary.txt'))
    return manifest


def stop(proc):
    if proc.poll() is None:
        os.killpg(proc.pid, signal.SIGTERM)
        try:
            proc.wait(timeout=5)
        except subprocess.TimeoutExpired:
            os.killpg(proc.pid, signal.SIGKILL)
            proc.wait()


def run_case(case, env):
    p = Path(case['profile'])
    job = case['job']
    app = p / APP
    started = time.monotonic()
    begin = end = None
    done_seen = None
    last_status = started
    reason = 'timeout'
    print(f"\n[{case['index']}/10] {job['id']} — visible Flexe; sound disabled", flush=True)
    with (p / 'human-frontend.log').open('w') as log:
        proc = subprocess.Popen(['./flexe-agon-emulator'], cwd=p, env=env,
                                stdout=log, stderr=subprocess.STDOUT, start_new_session=True)
        try:
            while time.monotonic() - started < case['timeout_seconds']:
                now = time.monotonic()
                if Path('/sys/devices/system/cpu/cpufreq/boost').read_text().strip() != '0':
                    reason = 'boost-enabled'
                    break
                if begin is None and (app / 'started.txt').exists() and (app / 'started.txt').stat().st_size:
                    begin = now
                if end is None and (app / 'ended.txt').exists() and (app / 'ended.txt').stat().st_size:
                    end = now
                if (app / 'done.txt').exists() and (app / 'done.txt').read_bytes().endswith(b'\n'):
                    if done_seen is None:
                        done_seen = now
                    if now - done_seen >= 2:
                        reason = 'guest-files'
                        break
                if proc.poll() is not None:
                    reason = 'window-closed-or-frontend-exit'
                    break
                if now - last_status >= 15:
                    trace = p / 'last-run/vdp-to-mos-delivered.bin'
                    count = trace.read_bytes().count(bytes([128, 1, 232])) if trace.exists() else 0
                    progress = f", {count}/{job['frames']} frame replies" if job.get('live') else ''
                    print(f"  {int(now-started)}s elapsed{progress}", flush=True)
                    last_status = now
                time.sleep(.1)
        except KeyboardInterrupt:
            reason = 'author-cancelled'
        finally:
            stop(proc)
    passed = False
    error = None
    if reason == 'guest-files':
        try:
            sys.path.insert(0, str(PACKAGE))
            from verify_results import verify
            verify(app, job)
            passed = True
        except Exception as e:
            error = str(e) or type(e).__name__
    identity = json.loads((p / 'identity.json').read_text())
    unchanged = all(sha(p / n) == h for n, h in identity['files'].items())
    passed = passed and unchanged
    result = dict(case=job['id'], reason=reason, passed=passed, verification_error=error,
                  host_seconds=time.monotonic() - started,
                  host_window_seconds=end-begin if begin is not None and end is not None else None,
                  inputs_unchanged=unchanged, video_driver=env['SDL_VIDEODRIVER'],
                  audio_driver='dummy', author_launched=True)
    write_json(p / 'human-result.json', result)
    print('  ' + ('PASS' if passed else 'INCOMPLETE/FAILED') + ': ' + reason, flush=True)
    print('  Logs: ' + str(app), flush=True)
    return result


def run(suite):
    assert sys.stdin.isatty() and (os.environ.get('DISPLAY') or os.environ.get('WAYLAND_DISPLAY')), \
        'Launch run-suite.sh yourself in a local Oryx desktop terminal.'
    assert Path('/sys/devices/system/cpu/cpufreq/boost').read_text().strip() == '0', 'CPU boost must remain disabled.'
    assert not (suite / 'human-suite.json').exists(), 'This suite already ran; preserve its results and stage a fresh suite.'
    manifest = validate(suite)
    def interrupted(signum, frame):
        raise KeyboardInterrupt()
    for sig in (signal.SIGHUP, signal.SIGTERM):
        signal.signal(sig, interrupted)
    env = dict(os.environ, SDL_AUDIODRIVER='dummy',
               SDL_VIDEODRIVER='wayland' if os.environ.get('WAYLAND_DISPLAY') else 'x11')
    print('Ten exact-input cases. The first five measure CPU/physics and show text, not a road.')
    print('The empty control follows, then four road-drawing cases. Each opens its own window.')
    print('Stalled road cases stop after five minutes; a fresh emulator runs the next case.')
    print('Close a window or press Ctrl-C in this terminal to stop the whole suite. Sound is always disabled.', flush=True)
    results = []
    write_json(suite / 'human-suite.json', dict(status='running', results=results))
    try:
        for case in manifest['cases']:
            result = run_case(case, env)
            results.append(result)
            abort = result['reason'] in ('author-cancelled', 'window-closed-or-frontend-exit', 'boost-enabled') or not result['inputs_unchanged']
            write_json(suite / 'human-suite.json', dict(status='stopped' if abort else 'running', results=results))
            if abort:
                print('Suite stopped; no further emulator launched.', flush=True)
                break
        else:
            write_json(suite / 'human-suite.json', dict(status='finished', results=results))
    except KeyboardInterrupt:
        write_json(suite / 'human-suite.json', dict(status='stopped', results=results))
        print('Suite stopped between cases.', flush=True)
    print(f"\n{sum(r['passed'] for r in results)}/{len(results)} completed cases passed. Results: {suite / 'human-suite.json'}", flush=True)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('--prepare')
    group.add_argument('--check', type=Path)
    group.add_argument('--run', type=Path)
    args = parser.parse_args()
    if args.prepare:
        prepare(args.prepare)
    elif args.check:
        print(len(validate(args.check)['cases']), 'profiles/input sets verified; no emulator launched')
    else:
        run(args.run)
