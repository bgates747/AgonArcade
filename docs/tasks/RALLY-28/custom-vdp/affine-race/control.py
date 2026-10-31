"""Stage/run full-race variants through the established silent Oryx guard."""
from pathlib import Path
import argparse
import hashlib
import json
import os
import shutil
import signal
import subprocess
import sys
import time

HERE = Path(__file__).resolve().parent
THROUGHPUT = HERE.parent / 'throughput'
sys.path.insert(0, str(THROUGHPUT))
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()


def stage(campaign, cases, registry='FIXTURES.json'):
    import stage as tool
    fixtures = json.loads((HERE/registry).read_text())
    staging = HERE
    if registry != 'FIXTURES.json':
        staging = HERE/'.work'/('stage-'+campaign)
        staging.mkdir(parents=True, exist_ok=False)
        selected = {name:{**info, 'directory':str((HERE/info['directory']).resolve())} for name,info in fixtures.items()}
        (staging/'FIXTURES.json').write_text(json.dumps(selected,indent=2)+'\n')
    tool.HERE = staging
    tool.stage(campaign, cases)
    receipt_path = HERE / ('PROFILES-' + campaign + '.json')
    if staging != HERE:
        shutil.copyfile(staging/receipt_path.name, receipt_path)
    entries = json.loads(receipt_path.read_text())
    for case, info in entries.items():
        profile = Path(info['profile'])
        app = profile / 'sdcard/rally25'
        # The runtime seed contains the old tape application. This guest has
        # its own complete file set; remove only unused files in our new app.
        allowed = set(fixtures[case]['files'])
        for p in app.iterdir():
            if p.is_file() and p.name not in allowed:
                p.unlink()
        pins = {n: h for n, h in info['input_sha256'].items() if (profile/n).exists()}
        assert all(sha(profile/n) == h for n, h in pins.items())
        (profile / '.runtime.sha256').write_text(''.join(h + '  ' + n + '\n' for n, h in pins.items()))
        info['input_sha256'] = pins
    receipt_path.write_text(json.dumps(entries, indent=2) + '\n')


def stop(proc, profile):
    if proc and proc.poll() is None:
        for child in Path('/proc').glob('[0-9]*'):
            try:
                if (os.getpgid(int(child.name)) == proc.pid and
                    (child/'exe').resolve() == (profile/'flexe-agon-emulator.bin').resolve()):
                    os.kill(int(child.name), signal.SIGTERM)
            except OSError:
                pass
        try:
            proc.wait(timeout=10)
        except subprocess.TimeoutExpired:
            os.killpg(proc.pid, signal.SIGKILL)
            proc.wait()


def run_one(profile, timeout=300):
    from verify import verify
    profile = Path(profile)
    app, artifact = profile/'sdcard/rally25', profile/'last-run'
    assert Path('/sys/devices/system/cpu/cpufreq/boost').read_text().strip() == '0'
    assert not artifact.exists(), 'Preserve previous runs; stage a fresh profile'
    assert not (app/'result.json').exists() and not (app/'failure.txt').exists()
    artifact.mkdir()
    env = os.environ.copy()
    env.update(SDL_VIDEODRIVER='dummy', SDL_AUDIODRIVER='dummy')
    started = time.monotonic()
    progress_at, previous_sizes = started, None
    proc, error, result = None, None, None
    try:
        with (artifact/'frontend.log').open('w') as log:
            proc = subprocess.Popen(['./flexe-agon-emulator', '--renderer', 'sw'],
                                    cwd=profile, env=env, stdout=log,
                                    stderr=subprocess.STDOUT, start_new_session=True)
            while time.monotonic()-started < timeout:
                sizes = tuple((artifact/n).stat().st_size if (artifact/n).exists() else 0
                              for n in ('mos-to-vdp.bin', 'vdp-to-mos.bin'))
                if sizes != previous_sizes:
                    progress_at, previous_sizes = time.monotonic(), sizes
                elif time.monotonic()-progress_at > 60:
                    raise TimeoutError('UART streams unchanged for60 host seconds; preserve and retry fresh identical inputs')
                if (app/'failure.txt').exists():
                    raise RuntimeError((app/'failure.txt').read_text())
                if (app/'result.json').exists():
                    try:
                        json.loads((app/'result.json').read_text())
                    except json.JSONDecodeError:
                        time.sleep(.1)
                        continue
                    time.sleep(.5)
                    result = verify(app)
                    break
                if proc.poll() is not None:
                    raise RuntimeError('Frontend exited ' + str(proc.returncode))
                time.sleep(.1)
            if result is None:
                raise TimeoutError('No complete full-race result in ' + str(timeout) + ' host seconds')
    except BaseException as exc:
        error = repr(exc)
        raise
    finally:
        stop(proc, profile)
        stats = json.loads((artifact/'stats.json').read_text()) if (artifact/'stats.json').exists() else None
        receipt = dict(error=error, host_seconds=round(time.monotonic()-started, 3),
                       process_exit=proc.returncode if proc else None, result=result,
                       backend_stats=stats, runtime_identities=(profile/'.runtime.sha256').read_text(),
                       video_driver='dummy', audio_driver='dummy')
        (artifact/'run.json').write_text(json.dumps(receipt, indent=2) + '\n')
    assert proc.returncode == 0 and stats
    assert not any(stats.get(k) for k in ('failed', 'unhandled', 'unregistered', 'unmapped'))
    wire = (artifact/'mos-to-vdp.bin').read_bytes()
    done = wire.rfind(b'FULL RACE DONE')
    assert done >= 0 and wire.find(b'/rally25 *', done) > done, 'Clean MOS prompt missing'
    return receipt


def run_campaign(campaign):
    entries = json.loads((HERE/('PROFILES-'+campaign+'.json')).read_text())
    summary = {}
    for index, (case, info) in enumerate(entries.items(), 1):
        profile = Path(info['profile'])
        assert all(sha(profile/n) == h for n, h in info['input_sha256'].items())
        dest = HERE/'evidence'/campaign/case
        dest.mkdir(parents=True, exist_ok=False)
        print(f'[{index}/{len(entries)}] {campaign} {case}: video=dummy audio=dummy boost=0', flush=True)
        entry = {}
        try:
            receipt = run_one(profile)
            entry = dict(passed=True, **{k: receipt[k] for k in ('host_seconds', 'process_exit', 'backend_stats', 'result')})
            assert all(sha(profile/n) == h for n, h in info['input_sha256'].items())
            entry['input_hashes_preserved'] = True
            print(case, 'PASS', round(receipt['result']['nominal_mos_fps'], 3), 'nominal MOS FPS', flush=True)
        except BaseException as exc:
            entry = dict(passed=False, error=repr(exc))
            raise
        finally:
            artifacts = profile/'last-run'
            if artifacts.exists():
                for p in artifacts.iterdir():
                    if p.is_file():
                        shutil.copyfile(p, dest/(p.with_suffix('.txt').name if p.suffix == '.log' else p.name))
            app = profile/'sdcard/rally25'
            for name in ('result.json', 'state.bin', 'ticks.bin', 'prt.bin', 'replies.bin',
                         'stages.csv', 'player.csv', 'failure.txt', 'verified.json', 'coverage.json', 'capture.ready'):
                if (app/name).exists():
                    shutil.copyfile(app/name, dest/name)
            summary[case] = entry
            (HERE/('CAMPAIGN-'+campaign+'.json')).write_text(json.dumps(summary, indent=2) + '\n')


if __name__ == '__main__':
    p = argparse.ArgumentParser()
    p.add_argument('action', choices=['stage', 'session'])
    p.add_argument('name')
    p.add_argument('items', nargs='+')
    p.add_argument('--registry', default='FIXTURES.json')
    a = p.parse_args()
    if a.action == 'stage':
        stage(a.name, a.items, a.registry)
    else:
        import oryx_session
        oryx_session.HERE = HERE
        oryx_session.run_campaign = run_campaign
        oryx_session.session(a.name, a.items, [])
