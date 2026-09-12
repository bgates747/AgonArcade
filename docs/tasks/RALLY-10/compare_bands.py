"""Headless ABBA comparison of greedy and precomputed road-band construction."""
from pathlib import Path
import hashlib
import json
import platform
import tempfile
from run_timing import ROOT, run_case

base=ROOT/'.emulator/benchmarks'
base.mkdir(parents=True,exist_ok=True)
out=Path(tempfile.mkdtemp(prefix='bands-',dir=base))
runtime=Path.home()/'Agon/fab-agon-emulator'
files=[ROOT/'bin/rally.bin',ROOT/'src/main.cpp',ROOT/'include/road.hpp',
       ROOT/'include/band_table.hpp',ROOT/'include/workload.hpp',
       runtime/'fab-agon-emulator',runtime/'firmware/vdp_platform.so',runtime/'firmware/mos_platform.bin']
manifest={'host':platform.platform(),'headless':True,'renderer':'sw',
          'identities':{str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in files},'runs':[]}
print(f'Evidence: {out}',flush=True)
for track in ('oval','fuji'):
    runs=[]
    for index,fixed in enumerate((False,True,True,False),1):
        label=f'{track}-{index:02d}-'+('fixed' if fixed else 'greedy')
        result=run_case(out,label,track,'full',True,fixed)
        result['track']=track
        runs.append(result);manifest['runs'].append(result)
        (out/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    if len({r['metadata']['pose_hash'] for r in runs})!=1:
        raise RuntimeError('Different poses within track')
    for fixed in (0,1):
        if len({r['metadata']['road_bytes'] for r in runs if r['metadata']['fixed_bands']==fixed})!=1:
            raise RuntimeError('Unstable road bytes within band mode')
print('Band comparison invariants passed.',flush=True)
