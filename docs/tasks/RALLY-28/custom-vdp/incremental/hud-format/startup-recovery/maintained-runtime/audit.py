"""New-runtime admission plus unchanged original full functional/raw gate."""
from pathlib import Path
import argparse
import json
from common import HERE, FULL, HUD, BACKEND, profile, load, sha


def audit(directory):
    directory = Path(directory)
    result_file = directory / 'qualification.json'
    assert not result_file.exists(), 'Preserve the original qualification'
    info = profile()
    raw = load('maintained_identity', HUD.parent / 'round-trips/raw_audit.py')
    receipt = json.loads((directory / 'run.json').read_text())
    assert raw.identities(receipt['runtime_identities']) == info['input_sha256'], 'New cohort runtime mismatch'
    assert info['input_sha256']['flexe-vdp.so'] == BACKEND
    checked = load('unchanged_full_functional_gate', FULL / 'audit.py').audit(directory)
    result = dict(functional_pass=True, scope='One maintained086 cached fixture; no comparison',
                  frames=checked['frames'], physics_ticks=checked['physics_ticks'], warm_frames=2,
                  native_replies=checked['native_replies'], backend_sha256=BACKEND,
                  full_audit_sha256=sha(directory / 'full-audit.json'),
                  observer=checked['observer'], nominal_mos_fps=checked['nominal_mos_fps'],
                  nominal_prt_fps=checked['nominal_prt_fps'], clocks_calibrated=False,
                  timing_qualified=False, old_stall_cause_or_repair_claim=False,
                  cache_gain_or_old_runtime_comparison=False, visual_or_hardware_claim=False)
    result_file.write_text(json.dumps(result, indent=2) + '\n')
    return result


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('directory')
    print(json.dumps(audit(parser.parse_args().directory), indent=2))
