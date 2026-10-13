"""Isolated, pinned inputs for Rally host renderer preparation."""
from pathlib import Path
import hashlib,json,subprocess,sys
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[3]
WORK=HERE.parent/'.work/renderer-prep'
PIN='d250f43'
sys.path.insert(0,str(HERE.parent/'reference'))
from freeze import prepare as prepare_r22
def sha(data):return hashlib.sha256(data).hexdigest()
def dump(name,data):(HERE/name).write_text(json.dumps(data,indent=2)+'\n')
def stage():
    source,_=prepare_r22();dest=WORK/'experiment';dest.mkdir(parents=True,exist_ok=True)
    hashes={}
    for name in ['module.c','oracle.cpp','assets.cpp','test.py','unit.c']:
        relative='docs/tasks/RALLY-24/experiment/'+name
        data=subprocess.check_output(['git','-C',str(ROOT),'show',PIN+':'+relative])
        p=dest/name
        if p.exists():assert p.read_bytes()==data,'Frozen R24 input changed'
        else:p.write_bytes(data)
        hashes[relative]=sha(data)
    return source,dest,hashes
