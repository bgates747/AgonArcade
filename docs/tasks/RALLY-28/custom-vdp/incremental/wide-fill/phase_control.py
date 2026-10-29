"""Stage/run only the separate fill probe with the unchanged silent supervisor."""
import argparse
import hashlib
import importlib.util
import json
from pathlib import Path
import shutil
import sys

HERE = Path(__file__).resolve().parent
PHASE = HERE / 'phase'
THROUGHPUT = HERE.parents[1] / 'throughput'
sys.path.insert(0, str(THROUGHPUT))
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()


def run_campaign(name):
    pins = json.loads((THROUGHPUT / 'RUNNER-PINS.json').read_text())
    assert all(sha(THROUGHPUT / 'support' / n) == h for n, h in pins.items())
    sys.path.insert(0, str(THROUGHPUT / 'support'))
    from run_headless import run
    from phase_probe import verify
    entries = json.loads((PHASE / ('PROFILES-' + name + '.json')).read_text())
    assert set(entries) == {'fill'}
    info = entries['fill']
    profile = Path(info['profile'])
    app = profile / 'sdcard/rally25'
    assert not (profile / 'last-run').exists(), 'Preserve previous runs'
    assert all(sha(profile / n) == h for n, h in info['input_sha256'].items())
    dest = PHASE / 'evidence' / name
    dest.mkdir(parents=True, exist_ok=False)
    summary = {}
    try:
        receipt = run(profile, 180)
        result = verify(app)
        assert result['passed'] and result['sample_windows'] == 80
        assert result['physics_ticks'] == 0
        assert all(sha(profile / n) == h for n, h in info['input_sha256'].items())
        wire = (profile / 'last-run/mos-to-vdp.bin').read_bytes()
        done = wire.rfind(b'RALLY-25 DONE: logs saved.')
        assert done >= 0 and wire.find(b'/rally25 *', done) > done
        assert wire[done-5:done] == bytes([26, 12, 31, 0, 0])
        summary = dict(passed=True, sample_windows=80, physics_ticks=0,
                       isolated_raw_counter_only=True,
                       host_seconds_including_startup=receipt['host_seconds'],
                       process_exit=receipt['process_exit'],
                       backend_stats=receipt['backend_stats'],
                       clean_mos_return=True, inputs_unchanged=True,
                       result=result)
        print('fill probe PASS:', result['summaries'], flush=True)
    except BaseException as exc:
        summary = dict(passed=False, error=repr(exc))
        raise
    finally:
        artifacts = profile / 'last-run'
        if artifacts.exists():
            for p in artifacts.iterdir():
                if p.is_file():
                    shutil.copyfile(p, dest / (p.with_suffix('.txt').name if p.suffix == '.log' else p.name))
        for n in ('replies.log', 'ticks.log', 'prt.log', 'clock.log', 'failure.log', 'phase_verified.json'):
            p = app / n
            if p.exists():
                shutil.copyfile(p, dest / (p.stem + '.bin' if p.suffix == '.log' else p.name))
        (PHASE / ('CAMPAIGN-' + name + '.json')).write_text(json.dumps(summary, indent=2) + '\n')


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('action', choices=['stage', 'session'])
    parser.add_argument('name')
    parser.add_argument('campaign', nargs='?')
    args = parser.parse_args()
    if args.action == 'stage':
        import stage
        stage.HERE = PHASE
        stage.stage(args.name, ['fill'])
    else:
        assert args.campaign
        import oryx_session
        oryx_session.HERE = PHASE
        oryx_session.run_campaign = run_campaign
        oryx_session.session(args.name, [args.campaign], [])
