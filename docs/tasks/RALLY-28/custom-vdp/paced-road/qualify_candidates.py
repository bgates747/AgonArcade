"""Actual generated simulation/helper replay and independent road-command checks."""
from pathlib import Path
import argparse
import ctypes as C
import hashlib
import json
import os
import struct
import subprocess
import sys
from build_candidates import VARIANTS, WORK, HERE, CONTROL

ROOT = HERE.parents[4]
BASE = ROOT/'docs/tasks/RALLY-25'
sys.path.insert(0,str(BASE/'generated-state'))
sys.path.insert(0,str(BASE/'reference'))
from adapter import Interface, installation
from host import Runtime
from model import Traffic, contact


def asset_image():
    data=(CONTROL/'fixture/assets.vdu').read_bytes();at=0;result=bytearray()
    while at<len(data):
        assert data[at:at+5]==b'\x17\0\xa0\x7c\xc4'
        op=data[at+5];at+=6
        if op==2:result.clear()
        elif op==0:
            n=struct.unpack_from('<H',data,at)[0];at+=2;result+=data[at:at+n];at+=n
        else:assert op==14 and at==len(data),'Unexpected asset operation'
    assert len(result)==149518
    return bytes(result)


def specification(directory):
    s=object.__new__(Interface);s.directory=directory
    s.interface=json.loads((directory/'interface.json').read_text())
    s.root=json.loads((directory/'root.json').read_text())
    s.backends=json.loads((directory/'backends.json').read_text())
    s.entries={e['name']:e['logical_id'] for e in s.interface['entries']}
    s.globals={g['name']:g for g in s.interface['globals']}
    s.arrays={a['name']:a for a in s.interface['arrays']};s.bindings={}
    s.images=installation((directory/'common-install.bin').read_bytes())
    return s


class NativeRuntime(Runtime):
    def __init__(self,spec,library):
        super().__init__(spec,library)
        self.store(self.root_id,8,struct.pack('<I',7))
        self.install(50300,asset_image(),1)
        for key,n in ((50301,20480),(50302,2048),(50303,256),(50304,48)):self.install(key,bytes(n))
    def invoke(self,name=None,**kwargs):
        if hasattr(self,'root_id') and name:self.store(50304,44,b'\0\0')
        return super().invoke(name,**kwargs)


def decode(data):
    """Decode ordinary road lists into canonical top/bottom material endpoints."""
    at=0;shapes=[];rects=[]
    while at<len(data):
        if data[at:at+6]==b'\x17\0\xa0\xff\xff\7':
            assert at+6==len(data);return shapes,rects
        assert data[at:at+2]==b'\x12\0',(at,data[at:at+8].hex())
        colour=data[at+2];at+=3;plots=[]
        while at<len(data) and data[at]==25:
            op,x,y=struct.unpack_from('<Bhh',data,at+1);plots.append((op,x,y));at+=6
        if len(plots)==2:
            assert [p[0] for p in plots]==[4,101];rects.append((colour,plots));continue
        assert len(plots)==4 and [p[0] for p in plots[:2]]==[4,4]
        ops=[p[0] for p in plots[2:]];assert ops in ([85,85],[221,221])
        tl,tr=plots[0],plots[1];bl,br=plots[2:] if ops[0]==85 else plots[:1:-1]
        assert tl[2]==tr[2] and bl[2]==br[2] and tl[2]<bl[2]
        assert tl[1]<=tr[1] and bl[1]<=br[1]
        shapes.append((colour,tl[2],bl[2],tl[1],tr[1],bl[1],br[1],ops[0]))
    raise AssertionError('Unterminated road list')


def bounds():
    asset=asset_image()
    off,n=struct.unpack_from('<II',asset,40)
    coeff=asset[off:off+n];assert len(coeff)%12==0
    rows=[struct.unpack_from('<hhihh',coeff,i) for i in range(0,len(coeff),12)]
    aa=4*max(abs(x[0]) for x in rows)+max(abs(x[1]) for x in rows)
    bb=max(abs(x[2]) for x in rows)+max(abs(x[3]) for x in rows)+max(abs(x[4]) for x in rows)
    centre_q8=aa+bb*128//16
    centre=(centre_q8+128)//256+1
    numerator=centre*50+128*106
    assert numerator<2147483648
    tables=[]
    for i in range(10):
        off,n=struct.unpack_from('<II',asset,40+i*16);tables.append(asset[off:off+n])
    curve_counts=[]
    for (off,) in struct.iter_unpack('<H',tables[2]):
        stop=tables[3].index(223,off);curve_counts.append(stop-off+1)
    stripe_counts=[]
    for (off,) in struct.iter_unpack('<H',tables[5]):
        stop=tables[6].index(224,off);stripe_counts.append(stop-off+1)
    depths=[struct.unpack_from('<i',tables[7],q*4)[0] for q in range(8,129)]
    assert all(a>=b for a,b in zip(depths,depths[1:]))
    segment_bands=1+((max(depths)+16383)>>14)-(min(depths)>>14)
    output_bound=(max(max(curve_counts),segment_bands)+max(stripe_counts))*9*27+400
    assert output_bound<=20480
    result=dict(frozen_fuji_coefficients=len(rows),q_range=[8,128],material_u_range=[-106,106],
        fraction_q12_range=[0,4095],squared_fraction_q12_range=[0,4094],
        conservative_abs_aa=aa,conservative_abs_bb=bb,conservative_abs_centre_q8=centre_q8,
        conservative_abs_centre_pixel=centre,conservative_abs_endpoint_numerator=numerator,
        signed32_safe=True,int16_plot_coordinates_safe=centre+128*106//50<32768,
        maximum_legacy_curve_bands=max(curve_counts),maximum_stripe_bands=max(stripe_counts),
        conservative_segment_band_count=segment_bands,conservative_maximum_road_bytes=output_bound,road_capacity=20480,
        rounding='(centre*50+(y-96)*u)/50, signed truncation toward zero after translation')
    (HERE/'BOUNDS.json').write_text(json.dumps(result,indent=2)+'\n')
    return asset


def segment_rows(asset,station):
    depth_offset=struct.unpack_from('<I',asset,40+7*16)[0]
    local=station%6400;fraction=(local//100)*256+(local%100)*256//100
    keys=[(fraction+struct.unpack_from('<i',asset,depth_offset+(y-96)*4)[0])>>14 for y in range(104,225)]
    return {104+i for i in range(1,120) if keys[i]!=keys[i-1]}


def replay(mode,only=None):
    asset=bounds();tables=json.loads((BASE/'reference/tables.json').read_text())
    summary={};baseline_states=[];baseline_outputs=[];render_samples={}
    selected={1,8,30,60,120,240,450,600,750,900}
    chosen={'control',*only} if only else set(VARIANTS)
    for name,flags in VARIANTS.items():
        if name not in chosen:continue
        directory=WORK/name/'package';s=specification(directory)
        r=NativeRuntime(s,WORK/name/('host-sanitized.so' if mode=='sanitized' else 'host.so'))
        assert r.invoke('InitRace')==0
        model=Traffic(tables,'circuit',3276800,1,99);player=3246800
        for car,gap in zip(model.cars,[0,3199,3200,6400,18000,80000]):
            car.active=1;car.progress=player+gap;car.position=car.progress%model.lap;car.lateral=0
        maximum_road=0;band_total=0;shape_total=0;fill_total=0;road_total=0;max_endpoint_delta=0;aligned_splits=0
        digest=hashlib.sha256();samples=[]
        for tick in range(1,3601):
            speed=tables['records'][(model.pace.record+1)%6 if model.pace.remaining==0 else model.pace.record][1]
            player+=speed*2;model.advance(player,tick)
            assert r.invoke('Tick120')==0,(name,tick)
            root,arrays=r.snapshot()
            expected=dict(worldTick=tick,playerStation=player%model.lap,playerUnwrapped=player,renderPhase=player%8000,
                routeRecord=model.pace.record,routeRemaining=model.pace.remaining,routeHeading=model.pace.heading,routeLateral=model.pace.lateral)
            for field,value in expected.items():assert s.get(root,field)==value,(name,tick,field)
            hits=[]
            for i,car in enumerate(model.cars):
                hit=int(contact(car.position,car.lateral,player%model.lap,0,model.lap));hits.append(hit)
                for field,value in [('active',car.active),('position',car.position),('progress',car.progress),('lateral',car.lateral),('contacts',hit)]:
                    assert s.array_get(arrays,field,i)==value,(name,tick,field,i)
            assert s.get(root,'contactAny')==bool(any(hits))
            if tick%4:continue
            frame=tick//4;assert r.invoke('Render30')==0,(name,frame)
            root,arrays=r.snapshot();done=r.data(50304)
            assert struct.unpack_from('<HHiiIII',done)==(48,1,0,0,7,frame,tick)
            assert struct.unpack_from('<H',done,44)[0]==1
            assert struct.unpack_from('<I',root,20)[0]==1+frame*5
            lengths=struct.unpack_from('<III',done,24);bands,cars,signs=struct.unpack_from('<HHH',done,36)
            outputs=[r.data(key)[:n] for key,n in zip((50301,50302,50303),lengths)]
            state=bytes(root)+b''.join(bytes(arrays[k]) for k in sorted(arrays))
            digest.update(state)
            shapes,rects=decode(outputs[0]);pairs={(a[1],a[2]) for a in shapes}
            assert len(pairs)==bands and sorted(pairs)[0][0]==104 and sorted(pairs)[-1][1]==224
            assert all(a[1]==b[0] for a,b in zip(sorted(pairs),sorted(pairs)[1:]))
            if name=='control':baseline_states.append(state);baseline_outputs.append(outputs)
            else:
                assert state==baseline_states[frame-1],(name,frame,'simulation state changed')
                assert outputs[1:]==baseline_outputs[frame-1][1:],(name,frame,'actors/player changed')
                old_shapes,old_rects=decode(baseline_outputs[frame-1][0]);assert rects==old_rects
                if flags[3]:
                    required=segment_rows(asset,player%model.lap)
                    assert required<={y for pair in pairs for y in pair}
                    aligned_splits+=len(required)
                else:
                    assert pairs=={(a[1],a[2]) for a in old_shapes}
                    if not flags[2]:
                        assert len(shapes)==len(old_shapes)
                        for a,b in zip(shapes,old_shapes):
                            assert a[:3]==b[:3]
                            max_endpoint_delta=max(max_endpoint_delta,max(abs(x-y) for x,y in zip(a[3:7],b[3:7])))
                    if name=='float-tri-layered':assert outputs[0]==baseline_outputs[frame-1][0]
            maximum_road=max(maximum_road,lengths[0]);road_total+=lengths[0]
            band_total+=bands;shape_total+=len(shapes);fill_total+=sum(1 if a[-1]==221 else 2 for a in shapes)
            if frame in selected:samples.append(dict(frame=frame,road_hex=outputs[0].hex()))
        final=json.loads((BASE/'native-demo/SOURCE-RESULTS.json').read_text())
        for a in s.arrays.values():
            if a['access']==3:assert bytes(arrays[a['buffer']]).hex()==final['final_arrays'][a['name']]
        assert r.invoke('StopRace')==0 and r.invoke(operation=3)==0
        assert not r.live and r.grants==r.releases and r.peak<=3
        r.canaries()
        summary[name]=dict(frames=900,ticks=3600,state_digest=digest.hexdigest(),maximum_road_bytes=maximum_road,
            average_road_bytes=road_total/900,average_bands=band_total/900,average_material_shapes=shape_total/900,
            average_polygon_fills=fill_total/900,maximum_endpoint_delta_pixels=max_endpoint_delta,
            segment_boundaries_verified=aligned_splits,peak_leases=r.peak,balanced_leases=True,
            unchanged_actor_player_commands=True,independent_world_model_pass=True)
        render_samples[name]=samples
        print(name,'PASS',round(road_total/900,2),'road bytes/frame',flush=True)
    dest=HERE/('HOST-'+mode+'.json')
    if only:
        original=json.loads(dest.read_text());original.update(summary);summary=original
    dest.write_text(json.dumps(summary,indent=2)+'\n')
    if mode=='ordinary':
        dest=HERE/'.work/render-samples.json'
        if only:
            original=json.loads(dest.read_text());original.update(render_samples);render_samples=original
        dest.write_text(json.dumps(render_samples)+'\n')


def qualify(replay_only=False,only=None):
    for name in (() if replay_only else (only or VARIANTS)):
        for mode,flags in [('ordinary',[]),('sanitized',['-fsanitize=address,undefined','-fno-omit-frame-pointer'])]:
            out=WORK/name/('host-sanitized.so' if mode=='sanitized' else 'host.so')
            subprocess.run(['cc','-shared','-fPIC','-O1','-fno-builtin','-ffp-contract=off',*flags,
                '-I'+str(CONTROL/'sdk/include'),str(WORK/name/'package/native.c'),'-o',str(out)],check=True)
    for mode in ('ordinary','sanitized'):
        env=os.environ.copy()
        if mode=='sanitized':
            env['LD_PRELOAD']=subprocess.check_output(['cc','-print-file-name=libasan.so'],text=True).strip()
            env['ASAN_OPTIONS']='detect_leaks=0:halt_on_error=1';env['UBSAN_OPTIONS']='halt_on_error=1'
        subprocess.run([sys.executable,__file__,'--worker',mode,*(['--only',*only] if only else [])],check=True,env=env)


if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--worker',choices=['ordinary','sanitized']);p.add_argument('--replay-only',action='store_true');p.add_argument('--only',nargs='+',choices=list(VARIANTS));a=p.parse_args()
    replay(a.worker,a.only) if a.worker else qualify(a.replay_only,a.only)
