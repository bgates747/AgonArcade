"""Exercise new verifiers against immutable existing real UART/guest evidence."""
from pathlib import Path
import hashlib
import importlib.util
import json
import shutil
import struct
import sys

HERE=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()


def load(name,file):
    spec=importlib.util.spec_from_file_location(name,HERE/file)
    module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module);return module


def run():
    sys.path.insert(0,str(HERE));verify=load('functional_verify','verify.py')
    control=HERE.parents[1]/'incremental/round-trips';copy=HERE/'.work/check-control'
    shutil.copytree(control/'fixtures-smoke60/compact',copy,dirs_exist_ok=True)
    for p in (control/'evidence/rlyrtsmoke01/compact').iterdir():
        if p.is_file():shutil.copyfile(p,copy/p.name)
    result=verify.verify(copy)
    assert result['functional_only'] and 'nominal_mos_fps' not in result
    checks=['archived-actual-control60-accepted-functional-only']
    for name,file,offset in [('state','state.bin',0),('reply-token','replies.bin',6)]:
        p=copy/file;original=p.read_bytes();data=bytearray(original);data[offset]^=1;p.write_bytes(data)
        try:verify.verify(copy)
        except AssertionError:checks.append(name+'-corruption-rejected')
        else:raise AssertionError('Corruption accepted')
        p.write_bytes(original)
    raw=load('functional_raw','raw_audit.py');e=HERE.parent/'capacity-02/evidence/capacity02/small'
    oracle=raw.Oracle(e);oracle.add(1,struct.pack('<HIH',50305,34836,0),2);checks.append('raw-actual-load-kind2')
    oracle=raw.Oracle(e);oracle.at=226;oracle.word(51999,10627,3,5);checks.append('raw-actual-bounds-kind5-status3')
    oracle=raw.Oracle(e);oracle.at=226
    try:oracle.word(51999,10627,3,3)
    except AssertionError:checks.append('raw-wrong-done-kind3-rejected')
    else:raise AssertionError('Wrong kind accepted')
    output=dict(passed=True,checks=checks,archived_input_only=True,no_new_emulator_or_fps_result=True,
        source_sha256={n:sha(HERE/n) for n in ('local_checks.py','verify.py','prepared_checks.py','raw_audit.py')})
    (HERE/'LOCAL-CHECKS.json').write_text(json.dumps(output,indent=2)+'\n');print(json.dumps(output,indent=2))


if __name__=='__main__':run()
