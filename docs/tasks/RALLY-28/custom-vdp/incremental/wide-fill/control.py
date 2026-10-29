"""Reuse the qualified moving-pattern runner and guarded Oryx session unchanged."""
from pathlib import Path
import argparse,hashlib,importlib.util,json,shutil
HERE=Path(__file__).resolve().parent
PRIOR=HERE.parent/'sprites/motion-comparison'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()

def runner():
    source=PRIOR/'control.py'
    spec=importlib.util.spec_from_file_location('accepted_motion_runner',source)
    module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
    module.HERE=HERE
    reference=HERE/'CONTROL-FINAL.json'
    if not reference.exists():shutil.copyfile(PRIOR/'CONTROL-FINAL.json',reference)
    assert sha(reference)==sha(PRIOR/'CONTROL-FINAL.json')
    (HERE/'REUSED-RUNNER.json').write_text(json.dumps(dict(source=str(source),sha256=sha(source),
        copied_final_reference_sha256=sha(reference),implementation_unchanged=True),indent=2)+'\n')
    return module

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('action',choices=['stage','session']);p.add_argument('name');p.add_argument('items',nargs='+');a=p.parse_args()
    module=runner()
    if a.action=='stage':module.stage(a.name,a.items)
    else:module.session(a.name,a.items)
