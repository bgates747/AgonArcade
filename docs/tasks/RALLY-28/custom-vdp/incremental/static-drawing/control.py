"""Reuse the accepted motion runner and silent/thermal supervisor unchanged."""
from pathlib import Path
import argparse
import hashlib
import importlib.util
import json
import shutil

HERE = Path(__file__).resolve().parent
PRIOR = HERE.parent / 'sprites/motion-comparison'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()


def runner():
    source = PRIOR / 'control.py'
    assert sha(source) == 'fdcb090a9228bcc2f3a209551681ef4d34d21ed3e746575ac44301a2fe8e52f2'
    spec = importlib.util.spec_from_file_location('accepted_motion_runner', source)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    module.HERE = HERE
    reference = HERE / 'CONTROL-FINAL.json'
    if not reference.exists():
        shutil.copyfile(PRIOR / 'CONTROL-FINAL.json', reference)
    assert sha(reference) == sha(PRIOR / 'CONTROL-FINAL.json')
    (HERE / 'REUSED-RUNNER.json').write_text(json.dumps(dict(
        source=str(source), sha256=sha(source), implementation_unchanged=True,
        copied_final_reference_sha256=sha(reference)), indent=2) + '\n')
    return module


if __name__ == '__main__':
    p = argparse.ArgumentParser()
    p.add_argument('action', choices=['stage', 'session'])
    p.add_argument('name')
    p.add_argument('items', nargs='+')
    a = p.parse_args()
    module = runner()
    if a.action == 'stage':
        module.stage(a.name, a.items)
    else:
        module.session(a.name, a.items)
