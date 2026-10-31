"""Independently decode every installed key and the actual generation wire."""
from pathlib import Path
import hashlib
import json
import struct

HERE=Path(__file__).resolve().parent


def check():
    freeze=json.loads((HERE/'RECIPE-FREEZE.json').read_text())
    for n,h in freeze['files'].items():assert hashlib.sha256((HERE/n).read_bytes()).hexdigest()==h,n
    recipe=json.loads((HERE/'recipe.json').read_text())
    policy=json.loads((HERE.parent/'preparation/FINDINGS.json').read_text())['policies']['two-pixel-stock-model']
    table=(HERE/'index.bin').read_bytes();wire=(HERE/'generation.vdu').read_bytes();plan=(HERE/'plan.bin').read_bytes()
    directories={}
    for i in range(68):
        source,family,flags,first,count,m,w,h,reserved=struct.unpack_from('<HBBHHIBBH',table,64+16*i)
        assert not reserved and flags<4 and m==1152+126*family
        directories[source,flags&1]=(family,first,count,m,w,h)
    total=0
    for i,e in enumerate(recipe['entries']):
        id,w,h,ax,ay=struct.unpack_from('<HBBhh',table,3420+8*i)
        assert (id,w,h,ax,ay)==tuple(e[k] for k in ('id','width','height','anchor_x','anchor_y'))
        a=wire[48*i:48*i+48]
        assert a[:6]==bytes([23,0,160,id&255,id>>8,2])
        assert a[6:13]==bytes([23,0,160,51998&255,51998>>8,32,0])
        assert a[13:21]==bytes([23,0,160,51998&255,51998>>8,32,11,200])
        s=2*e['q'];assert struct.unpack_from('<6h',a,21)==(-s if e['mirror'] else s,0,101*s if e['mirror'] else 0,0,s,0)
        assert a[33:40]==bytes([23,0,160,id&255,id>>8,40,3])
        assert struct.unpack_from('<4H',a,40)==(51998,64000+e['source'],w,h)
        assert struct.unpack_from('<HHH',plan,16*i)==(id,e['source'],s)
        total+=w*h
    # Every originally admitted full-domain request maps to its frozen selected
    # representative within the correct source/reflection directory.
    lookups=0
    for (source,mirror),(family,first,count,m,w,h) in directories.items():
        mapping={int(q):int(v) for q,v in policy['q_maps'][str(family)].items()}
        last=-1
        for q in range(126):
            slot=table[m+q]
            if q not in mapping:assert slot==255;continue
            assert 0<=slot<count
            e=recipe['entries'][first+slot]
            assert e['source']==source and e['mirror']==mirror and e['q']==mapping[q]
            assert slot>=last;last=slot;lookups+=1
    assert total==2211975 and lookups==6927
    assert len({e['id'] for e in recipe['entries']})==901
    # Previous protected inputs and archives remain exact; checks do not rebuild.
    control=HERE.parents[1]/'incremental/round-trips'
    frozen=json.loads((control/'FROZEN-INPUTS.json').read_text())
    # This report's exact schema is admitted explicitly by its producer.
    for n,h in frozen.items():
        assert isinstance(h,str) and hashlib.sha256((control/n).read_bytes()).hexdigest()==h,n
    protected=json.loads((control/'PROTECTED.json').read_text())
    for n,h in protected.items():assert hashlib.sha256(Path(n).read_bytes()).hexdigest()==h,n
    result=dict(passed=True,decoded_generation_commands=901,full_domain_lookups=lookups,
        packed_table_bytes=len(table),pixel_bytes=total,exact_recipe_pins=True,
        protected_control_inputs=len(frozen),protected_archives_and_sources=len(protected),
        target_capacity_not_measured=True,no_emulator_launched=True)
    (HERE/'HOST-CHECK.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))


if __name__=='__main__':check()
