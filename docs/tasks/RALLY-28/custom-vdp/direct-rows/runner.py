"""Finite Oryx-only reuse of the existing guard and original thermal supervisor."""
from pathlib import Path
import argparse
import importlib.util
import json
import os
import shutil
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[4]
HUD = HERE.parent / 'incremental/hud-format'


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def campaign(name):
    control = load('rows_original_process_guard', HUD / 'control.py')
    # Keep the original unedited process watchdog/stop path, using our new
    # application verifier. The supervisor still owns boost/thermal restoration.
    sys.modules['verify'] = load('rows_application_verify', HERE / 'verify.py')
    audit = load('rows_target_audit', HERE / 'audit.py')
    cases = json.loads((HERE/'PROFILES-rows01.json').read_text())
    summary = {}
    for case, info in cases.items():
        profile = Path(info['profile'])
        assert all(audit.hashlib.sha256((profile/n).read_bytes()).hexdigest() == h
                   for n, h in info['input_sha256'].items())
        destination = HERE / 'evidence' / name / case
        destination.mkdir(parents=True, exist_ok=False)
        print(case, 'START both SDL dummy', flush=True)
        try:
            receipt = control.run_one(profile, timeout=287)
        finally:
            for source in (profile/'last-run', profile/'sdcard/rally25'):
                if not source.exists():
                    continue
                for p in source.iterdir():
                    if p.is_file():
                        shutil.copyfile(p, destination/p.name)
        result = audit.audit(destination)
        summary[case] = dict(receipt=receipt, audit=result)
        (HERE/'CAMPAIGN-rows01.json').write_text(json.dumps(summary, indent=2)+'\n')
        print(case, 'PASS', result['nominal_mos_fps'], 'MOS FPS',
              result['nominal_prt_fps'], 'PRT FPS', flush=True)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--lease', required=True)
    args = parser.parse_args()
    assert not (HERE/'SESSION-rows01.json').exists()
    os.environ['RALLY_ORYX_LEASE'] = args.lease
    sys.path.insert(0, str(HERE.parent/'throughput'))
    supervisor = load('rows_original_supervisor', HERE.parent/'throughput/oryx_session.py')
    supervisor.HERE = HERE
    supervisor.run_campaign = campaign
    supervisor.session('rows01', ['rows01'], [])
