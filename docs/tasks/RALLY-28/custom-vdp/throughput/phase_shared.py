"""Phase schema and hash-checked runtime support; no builder or emulator import."""
from pathlib import Path
import hashlib
import importlib.util
import json
import sys

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[4]
PACED=HERE.parent/'paced-road'
CONTROL=PACED/'control'
WORK=HERE/'.work/phase-build'
LOG=50305
TAIL=50306
HEADER=32
ROW=52
PRIVATE=60000
SCHEMA=1


def support_module(name):
    """Load only the frozen support files; never reuse an unrelated import."""
    pins=json.loads((HERE/'RUNNER-PINS.json').read_text())
    assert set(pins)=={'run_headless.py','verify_run.py'}
    assert name+'.py' in pins
    support=HERE/'support'
    for filename,digest in pins.items():
        assert hashlib.sha256((support/filename).read_bytes()).hexdigest()==digest,'Runner source pin mismatch: '+filename
    spec=importlib.util.spec_from_file_location('_r28_phase_support_'+name,support/(name+'.py'))
    module=importlib.util.module_from_spec(spec)
    if name=='run_headless':
        # The unchanged runner uses a plain verify_run import. Bind its import
        # to the hash-checked snapshot, then restore any caller's module slot.
        verifier=support_module('verify_run')
        previous=sys.modules.get('verify_run')
        sys.modules['verify_run']=verifier
        try:spec.loader.exec_module(module)
        finally:
            if previous is None:sys.modules.pop('verify_run',None)
            else:sys.modules['verify_run']=previous
    else:spec.loader.exec_module(module)
    return module
