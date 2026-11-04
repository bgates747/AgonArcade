"""ONE prospective process; requires later explicit selection and fresh custody."""
from pathlib import Path
import argparse
import json
import os
import socket
import subprocess
import sys
from common import HERE, FULL, HUD, CUSTOM, NAME, profile, frozen_inputs, check_profile, load


def campaign(name):
    assert name == NAME
    info = profile()
    selected = Path(info['profile'])
    check_profile(selected, info['input_sha256'])
    dest = HERE / 'evidence' / NAME / 'cached'
    dest.mkdir(parents=True, exist_ok=False)
    base = load('original_hud_control', HUD / 'control.py')
    base.stop = load('original_qualified_stop', HERE.parent / 'observer-integration/runner.py').stop
    preserve = load('original_preserve', HERE.parent / 'hud-smoke/runner.py').preserve
    conditions = load('original_conditions', FULL / 'conditions.py')
    # Original run_one dynamically imports this exact, unchanged verifier.
    sys.path.insert(0, str(FULL))
    gate = load('maintained_functional_gate', HERE / 'audit.py')
    entry = dict(passed=False, intended_processes=1, retry=False, frames_requested=900)
    try:
        (dest / 'host-before.json').write_text(json.dumps(conditions.snapshot('before-maint08601'), indent=2) + '\n')
        base.run_one(selected, timeout=287)
        artifact = selected / 'last-run'
        try:
            reader = subprocess.run([sys.executable, str(HERE.parent / 'observer-integration/vendor/read_record.py'),
                str(artifact / 'sender-progress.jsonl')], text=True, stdout=subprocess.PIPE,
                stderr=subprocess.PIPE, timeout=5)
            observed = dict(reader_exit=reader.returncode, stdout=reader.stdout, stderr=reader.stderr)
        except (OSError, subprocess.TimeoutExpired) as error:
            observed = dict(reader_exit=None, reader_error=repr(error))
        observed['reader_exit_zero_means'] = 'Finalized schema only'
        (artifact / 'observer-reader.json').write_text(json.dumps(observed, indent=2) + '\n')
        preserve(selected, dest)
        assert observed['reader_exit'] == 0, 'Missing/invalid/unfinalized observer'
        checked = gate.audit(dest)
        check_profile(selected, info['input_sha256'], require_stopped=False)
        entry.update(passed=True, functional_qualification=checked)
    except BaseException as error:
        entry['error'] = repr(error)
        raise
    finally:
        preserve(selected, dest)
        (dest / 'host-after.json').write_text(json.dumps(conditions.snapshot('after-maint08601'), indent=2) + '\n')
        (HERE / ('CAMPAIGN-' + NAME + '.json')).write_text(json.dumps(dict(cached=entry), indent=2) + '\n')


def main():
    assert socket.gethostname() == 'oryx-linuxlite'
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--lease', required=True)
    args = parser.parse_args()
    frozen_inputs()
    info = profile()
    assert (HERE / 'STAGED.json').exists(), 'Separate staging and target selection required'
    assert not (HERE / ('CAMPAIGN-' + NAME + '.json')).exists()
    assert not (HERE / ('PROFILES-' + NAME + '.json')).exists()
    assert not (HERE / 'evidence' / NAME).exists()
    check_profile(Path(info['profile']), info['input_sha256'])
    os.environ['RALLY_ORYX_LEASE'] = args.lease
    (HERE / ('PROFILES-' + NAME + '.json')).write_text(json.dumps(dict(cached=info), indent=2) + '\n')
    sys.path.insert(0, str(CUSTOM / 'throughput'))
    supervisor = load('original_oryx_supervisor', CUSTOM / 'throughput/oryx_session.py')
    supervisor.HERE = HERE
    supervisor.run_campaign = campaign
    supervisor.session(NAME, [NAME], [])


if __name__ == '__main__':
    main()
