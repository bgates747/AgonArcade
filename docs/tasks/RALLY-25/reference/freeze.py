"""Preserve exact pre-R27 inputs without changing any product or compiler tree."""
from pathlib import Path
import hashlib,json,re,subprocess
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[3]
PIN='19d54c9ede0a671cf84e5a017e4180d522188082'
WORK=HERE.parent/'.work/reference'
def sha(b):return hashlib.sha256(b).hexdigest()
def blob(name):return subprocess.check_output(['git','-C',str(ROOT),'show',PIN+':'+name])
def prepare():
    paths=subprocess.check_output(['git','-C',str(ROOT),'ls-tree','-r','--name-only',PIN,'rally-game/include','rally-production/include'],text=True).splitlines()
    paths+=['rally-game/src/main.cpp','rally-game/Makefile','rally-game/assets/routes-proof.json','rally-game/tools/generate_routes.py','rally-production/fuji.road','rally-production/oval.road']
    source=WORK/'r22';source.mkdir(parents=True,exist_ok=True)
    hashes={}
    for name in paths:
        data=blob(name);p=source/name;p.parent.mkdir(parents=True,exist_ok=True)
        if p.exists():assert p.read_bytes()==data,'Frozen input changed: '+name
        else:p.write_bytes(data)
        hashes[name]=sha(data)
    baseline='4be88dd1c8efbb6f7cddbdce1b98ee8805572f47550cda5d8c0ef3207189395b'
    archive=ROOT/'.research-cache/rally22/builds'/baseline
    assert sha((archive/'rally.bin').read_bytes())==baseline
    build=json.loads((archive/'build.json').read_text())
    assert build['sha256']==baseline
    for name,h in build['inputs'].items():assert sha((archive/'source'/name).read_bytes())==h,name
    # Record honest source correspondence, including any historical difference.
    compared={n:hashes[n]==h for n,h in build['inputs'].items() if n in hashes}
    assert all(compared.values()),'R22 archive/source pin differs'
    route=(source/'rally-game/include/routes_data.hpp').read_text()
    records=[list(map(int,m)) for m in re.findall(r'\{(\d+),(\d+),(-?\d+),(-?\d+)\}',route)]
    sine=list(map(int,re.search(r'RouteSine\[257\]=\{(.*?)\};',route,re.S)[1].replace('\n','').strip(',').split(',')))
    track=(source/'rally-production/include/track.hpp').read_text()
    tracks={}
    for name in ['Fuji','TriOval']:
        body=re.search(name+r'Points\[\d+\] = \{(.*?)\};',track,re.S)[1]
        points=[list(map(int,m)) for m in re.findall(r'\{(-?\d+),(-?\d+),(-?\d+),(-?\d+)\}',body)]
        length=int(re.search(r'TrackDef '+name+r' = \{[^,]+,[^,]+,(\d+),',track)[1])*100
        tracks[name]={'lap_hundredths':length,'points':points}
    data={'schema':1,'source_commit':PIN,'records':records,'sine':sine,'half_excursion_q8':5044,'tracks':tracks}
    out=HERE/'tables.json';encoded=(json.dumps(data,indent=2)+'\n').encode()
    if out.exists():assert out.read_bytes()==encoded,'Published table fixture differs'
    else:out.write_bytes(encoded)
    direct=ROOT/'.research-cache/rally22/builds/7f1620ed8139ee779e7d50e333ef572aeaf612a154e41ec574e63a57da760293/rally.bin'
    assert sha(direct.read_bytes())==direct.parent.name
    receipt={'schema':1,'r22_source_commit':PIN,'r22_binary_sha256':baseline,'r22_build_manifest_sha256':sha((archive/'build.json').read_bytes()),'r22_archive_inputs_verified':len(build['inputs']),'r22_pin_correspondence':compared,'r22_sources':hashes,'r27_baseline_binary_sha256':sha(direct.read_bytes()),'r24_renderer_source_sha256':sha((ROOT/'docs/tasks/RALLY-24/experiment/module.c').read_bytes()),'tables_sha256':sha(encoded),'release_build_performed':False}
    p=HERE/'inputs.json';text=json.dumps(receipt,indent=2)+'\n'
    if p.exists():assert json.loads(p.read_text())==receipt,'Frozen receipt changed'
    else:p.write_text(text)
    return source,data
if __name__=='__main__':
    source,data=prepare();print('Verified pinned R22 source/binary lineage, R27 baseline and table export')
