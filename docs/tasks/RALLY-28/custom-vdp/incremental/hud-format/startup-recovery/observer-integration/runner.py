"""Prepared single observed startup run. Execution requires separate selection."""
from pathlib import Path
import argparse
import hashlib
import importlib.util
import json
import os
import shutil
import signal
import socket
import subprocess
import sys

HERE = Path(__file__).resolve().parent
START = HERE.parent
HUD = START.parent
CUSTOM = HUD.parents[1]
ROOT = CUSTOM.parents[3]
sha = lambda p: hashlib.sha256(Path(p).read_bytes()).hexdigest()


def load_module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    result = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(result)
    return result


def stop(proc, profile):
    """Original normal TERM path, bounded10s plus3s forced-cleanup wait."""
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
            proc.wait(timeout=3)


def run_campaign(campaign):
    assert campaign == 'startobs01'
    profile_info = json.loads((HERE/'PROFILE.json').read_text())
    profile = Path(profile_info['profile'])
    assert all(sha(profile/n) == h for n, h in profile_info['input_sha256'].items())
    assert not (profile/'last-run').exists()
    dest = HERE/'evidence/startobs01/control'
    dest.mkdir(parents=True, exist_ok=False)
    base = load_module('original_hud_control', HUD/'control.py')
    sys.path.insert(0, str(START))  # The distinct one-frame verifier, not HUD60/900.
    base.stop = stop
    entry = dict(functional_pass=False, new_game_fps=None, timing_excluded=True)
    try:
        # Original60s UART guard.287s work ceiling leaves10+3s quit within300s.
        receipt = base.run_one(profile, timeout=287)
        entry.update(functional_pass=True, host_seconds=receipt['host_seconds'])
    except BaseException as error:
        entry['error'] = repr(error)
        raise
    finally:
        artifact = profile/'last-run'
        if artifact.exists():
            try:
                reader = subprocess.run([sys.executable, str(HERE/'vendor/read_record.py'),
                                         str(artifact/'sender-progress.jsonl')],
                                        text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                                        timeout=5)
                observation = dict(reader_exit=reader.returncode, stdout=reader.stdout,
                                   stderr=reader.stderr)
            except (OSError, subprocess.TimeoutExpired) as error:
                observation = dict(reader_exit=None, reader_error=repr(error))
            observation.update(functional_pass=entry['functional_pass'],
                               reader_exit_zero_means='Finalized valid schema only; not functional pass')
            (artifact/'observer-reader.json').write_text(json.dumps(observation, indent=2)+'\n')
            for p in artifact.iterdir():
                if p.is_file():
                    shutil.copyfile(p, dest/(p.with_suffix('.txt').name if p.suffix == '.log' else p.name))
        app = profile/'sdcard/rally25'
        for name in ('expected.json', 'result.json', 'state.bin', 'ticks.bin', 'prt.bin',
                     'replies.bin', 'stages.csv', 'player.csv', 'failure.txt', 'verified.json'):
            if (app/name).exists():
                shutil.copyfile(app/name, dest/name)
        (HERE/'CAMPAIGN-startobs01.json').write_text(json.dumps(entry, indent=2)+'\n')
    # Raw/state audits are offline after retrieval/release, not while holding FIFO.
    assert all(sha(profile/n) == h for n, h in profile_info['input_sha256'].items())
    print('Original startup/one-frame guest checks PASS; timing excluded; retrieve/release before audit.', flush=True)


def main():
    assert socket.gethostname() == 'oryx-linuxlite'
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--lease', required=True)
    args = parser.parse_args()
    os.environ['RALLY_ORYX_LEASE'] = args.lease
    frozen = json.loads((HERE/'TARGET-READINESS.json').read_text())
    for name, wanted in frozen['files'].items():
        assert sha(HERE/name) == wanted, name
    for name, wanted in frozen['project_dependencies'].items():
        assert sha(ROOT/name) == wanted, name
    info = json.loads((HERE/'PROFILE.json').read_text())
    assert info['observer_output'] == str(Path(info['profile'])/'last-run/sender-progress.jsonl')
    # The unchanged session supervisor owns95C/boost restoration/owned teardown.
    (HERE/'PROFILES-startobs01.json').write_text(json.dumps({'control': info}, indent=2)+'\n')
    sys.path.insert(0, str(CUSTOM/'throughput'))
    supervisor = load_module('startup_oryx_session', CUSTOM/'throughput/oryx_session.py')
    supervisor.HERE = HERE
    supervisor.run_campaign = run_campaign
    supervisor.session('startobs01', ['startobs01'], [])


if __name__ == '__main__':
    main()
