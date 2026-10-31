"""Actual generated C plus independent packed lookup/anchor/order/lease checks."""
from pathlib import Path
import argparse
import ctypes as C
import hashlib
import importlib.util
import json
import os
import struct
import subprocess
import sys

HERE=Path(__file__).resolve().parent
CUSTOM=HERE.parents[1]
CONTROL=CUSTOM/'incremental/round-trips'
CAPACITY=HERE.parent/'capacity-02'
WORK=HERE/'.work/host'
sys.path.insert(0,str(CUSTOM/'full-race'))
from host_reference import SpriteRuntime,specification,snapshot,independent,BASE,Traffic
sys.path.insert(0,str(CUSTOM/'incremental/sprites'))
from host_replay import commands
spec=importlib.util.spec_from_file_location('roundtrip_qualification',CONTROL/'qualify.py')
previous=importlib.util.module_from_spec(spec);spec.loader.exec_module(previous)
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
RECIPE=json.loads((CAPACITY/'recipe.json').read_text())
POLICY=json.loads((CAPACITY.parent/'preparation/FINDINGS.json').read_text())['policies']['two-pixel-stock-model']
BY_KEY={(e['source'],e['mirror'],e['q']):e for e in RECIPE['entries']}


def selected(car,sign,top):
    source,matrix,scale,xx,translation,x,y=car
    family=10+source-120 if sign else 2*((source-5)%5)+(xx<0)
    q=int(POLICY['q_maps'][str(family)][str(scale//2)])
    e=BY_KEY[source,int(xx<0),q]
    px=x+(32 if sign else 51)*scale//256-e['anchor_x']
    py=y+(64 if sign else 70)*scale//256-e['anchor_y']
    left=max(0,px);up=max(104 if sign else top,py)
    right=min(319,px+e['width']);bottom=min(223,py+e['height'])
    return None if left>=right or up>=bottom else (e['id'],px,py,(left,bottom-1,right-1,up))


def serialize(draw,top):
    id,x,y,clip=draw;left,bottom,right,up=clip
    return (bytes([24])+struct.pack('<4h',left,bottom,right,up)
        +bytes([25,4])+struct.pack('<2h',left,up)
        +b'\x17\0\x96\1\xff\xff'+b'\x17\x1b\x20'+struct.pack('<H',id)
        +b'\x17\x1b\3'+struct.pack('<2h',x,y)
        +bytes([24])+struct.pack('<4h',0,223,319,top)
        +bytes([25,4])+struct.pack('<2h',0,top))


class PreparedRuntime(previous.FaultRuntime):
    table_fault=None
    def __init__(self,spec,lib):
        super().__init__(spec,lib)
        self.install(51999,(CAPACITY/'index.bin').read_bytes(),1)
        self.install(51996,bytes(32))
    def acquire(self,context,id,access,offset,n,out):
        if id==51999 and self.table_fault in ('missing','busy','capacity'):
            return {'missing':2,'busy':7,'capacity':13}[self.table_fault]
        rc=super().acquire(context,id,access,offset,n,out)
        if not rc and id==51999:
            if self.table_fault=='short':out.contents.bytes-=1
            if self.table_fault=='null':out.contents.data=C.POINTER(C.c_uint8)()
            if self.table_fault=='access':out.contents.access=0
        return rc
    def release(self,context,lease):
        failed=self.table_fault=='release' and lease in self.live and self.live[lease][0]==self.pointer(51999)
        rc=super().release(context,lease)
        return 8 if failed else rc


def worker(mode):
    old=SpriteRuntime(specification(CONTROL/'source'),WORK/('control-'+mode+'.so'))
    new=PreparedRuntime(specification(HERE/'source'),WORK/('prepared-'+mode+'.so'))
    emit=new.lib.host_emit
    emit.argtypes=[C.POINTER(C.c_uint8),C.POINTER(C.c_int32),C.c_int,C.c_int,C.POINTER(C.c_uint8),C.c_uint]
    emit.restype=C.c_int
    table=(C.c_uint8*10628).from_buffer_copy((CAPACITY/'index.bin').read_bytes())
    cases=0
    # Exhaustive key admission checks independent of the race trace, plus all
    # four screen edges and two normal clip tops for each selected image.
    for source in [*range(5,35),*range(120,128)]:
        sign=source>=120
        for mirror in ((0,) if sign else (0,1)):
            family=10+source-120 if sign else 2*((source-5)%5)+mirror
            for q in POLICY['q_maps'][str(family)]:
                scale=int(q)*2
                car=(source,0,scale,-scale if mirror else scale,101*scale if mirror else 0,
                     160-(32 if sign else 51)*scale//256,200-(64 if sign else 70)*scale//256)
                output=(C.c_uint8*256)(*([0xa5]*256));args=(C.c_int32*7)(*car)
                n=emit(table,args,sign,24,output,256);assert n>0
                expected=selected(car,sign,24)
                data=bytes(output[:n])+b'\x17\0\xa0\xff\xff\7'
                assert commands(data,True)==[expected]
                assert bytes(output[:n])==serialize(expected,24)
                assert bytes(output[n:])==bytes([0xa5])*(256-n);cases+=1
    assert cases==6927
    for e in RECIPE['entries']:
        sign=e['source']>=120;scale=e['q']*2
        for x,y,top in [(-80,180,24),(290,180,24),(100,60,88),(100,219,24)]:
            car=(e['source'],0,scale,-scale if e['mirror'] else scale,101*scale if e['mirror'] else 0,x,y)
            out=(C.c_uint8*256)();n=emit(table,(C.c_int32*7)(*car),sign,top,out,256);assert n>=0
            want=selected(car,sign,top)
            assert commands(bytes(out[:n])+b'\x17\0\xa0\xff\xff\7',True)==([] if want is None else [want]);cases+=1
            assert bytes(out[:n])==(b'' if want is None else serialize(want,top))
    assert old.invoke('InitRace')==new.invoke('InitRace')==0
    counts=[0]*8;digest=hashlib.sha256()
    def compare():
        assert snapshot(old)==snapshot(new)
        before,after=old.data(50304),new.data(50304)
        assert before[:24]==after[:24] and before[36:]==after[36:]
        lengths=struct.unpack_from('<III',after,24);oldlengths=struct.unpack_from('<III',before,24)
        for i in (0,2):assert new.data(50301+i)[:lengths[i]]==old.data(50301+i)[:oldlengths[i]]
        assert new.data(50700)==old.data(50700)
        cars,signs=struct.unpack_from('<HH',after,38)
        actors=new.actors();assert actors[:cars]==old.actors()[:cars] and actors[6:6+signs]==old.actors()[6:6+signs]
        c=s=0;expected=[];top=88 if struct.unpack_from('<H',new.data(1),308)[0]&2 else 24
        while c<cars or s<signs:
            sign=s<signs and (c==cars or actors[6+s][2]<=actors[c][2])
            row=actors[6+s] if sign else actors[c]
            if sign:s+=1
            else:c+=1
            counts[0]+=1;draw=selected(row,sign,top)
            if draw is None:counts[2]+=1
            else:counts[1]+=1;expected.append(draw)
        data=new.data(50302)[:lengths[1]]
        assert commands(data,True)==expected
        assert data==b''.join(serialize(d,top) for d in expected)+b'\x17\0\x96\1\xff\xff\x17\0\xa0\xff\xff\7'
        digest.update(data)
        for slot in range(8):assert new.data(50710+slot)==bytes([0xa5])*(7425 if slot<6 else 3844)
        assert not new.live and new.grants==new.releases
    for _ in range(2):assert old.invoke('Render30')==new.invoke('Render30')==0;compare()
    fixture=CONTROL/'fixtures/compact';meta=json.loads((fixture/'expected.json').read_text())
    motion=(fixture/'motion.bin').read_bytes();lanes=struct.pack('<6i',*meta['fixed_display_lanes'])
    tables=json.loads((BASE/'reference/tables.json').read_text());model=Traffic(tables,'circuit',3276800,1,99);player=3246800
    for car,gap in zip(model.cars,[0,3199,3200,6400,18000,80000]):car.active=1;car.progress=player+gap;car.position=car.progress%model.lap;car.lateral=0
    for tick in range(1,3601):
        record=(model.pace.record+1)%6 if model.pace.remaining==0 else model.pace.record
        player+=tables['records'][record][1]*2;model.advance(player,tick)
        assert old.invoke('Tick120')==new.invoke('Tick120')==0;assert snapshot(old)==snapshot(new);independent(new,model,player,tick)
        if tick%4:continue
        row=motion[(tick//4-1)*24:tick//4*24]
        for runtime in (old,new):runtime.store(4,0,row);runtime.store(5,0,lanes)
        for car,pos,lat in zip(model.cars,struct.unpack('<6I',row),meta['fixed_display_lanes']):car.position=pos;car.lateral=lat
        assert old.invoke('Render30')==new.invoke('Render30')==0;compare()
    assert snapshot(new)==json.loads((CUSTOM/'full-race/EXPECTED-FINAL-900.json').read_text())
    assert new.invoke('StopRace')==old.invoke('StopRace')==0
    assert struct.unpack('<8I',new.data(51996))==tuple(counts) and counts[3:]==[0]*5
    for runtime in (old,new):assert runtime.invoke(operation=3)==0;assert not runtime.live;runtime.canaries()
    faults=[]
    def fresh():return PreparedRuntime(specification(HERE/'source'),WORK/('prepared-'+mode+'.so'))
    for offset in (0,4,8,12,22,28,40,48,52,56,64,1152,3420):
        r=fresh();data=bytearray(r.data(51999));data[offset]^=1;r.store(51999,0,bytes(data))
        assert r.invoke('InitRace')!=0 and not r.live and r.grants==r.releases;faults.append('admission-byte-'+str(offset))
    for fault in ('missing','busy','capacity','short','null','access','release'):
        r=fresh();r.table_fault=fault
        assert r.invoke('InitRace')!=0 and not r.live and r.grants==r.releases;faults.append('bind-'+fault)
        r=fresh();assert r.invoke('InitRace')==0;r.table_fault=fault
        assert r.invoke('Render30')!=0 and not r.live and r.grants==r.releases;faults.append('render-'+fault)
    for fault in ('missing','busy','capacity','short','null','release','corrupt'):
        r=fresh();assert r.invoke('InitRace')==0;r.pub_fault=fault
        assert r.invoke('Render30')!=0 and not r.live and r.grants==r.releases;faults.append('publication-'+fault)
    # Explicit missing key after admission: ownership contract is intentionally
    # violated to prove no fallback is hidden in the hot lookup.
    r=fresh();assert r.invoke('InitRace')==0;r.store(51999,1152,bytes([255])*2268)
    assert r.invoke('Render30')!=0 and not r.live;faults.append('missing-key-no-fallback')
    r=fresh();assert r.invoke('InitRace')==0;del r.buffers[51996]
    assert r.invoke('StopRace')!=0 and not r.live;faults.append('counter-publication-missing')
    result=dict(passed=True,mode=mode,frames=900,physics_ticks=3600,warm_renders=2,
        full_domain_and_edge_cases=cases,independent_world_each_tick=True,road_player_and_plan_exact=True,
        independent_selected_anchor_clip_order=True,unused_sampler_buffers_unchanged=True,
        counters=counts,zero_timed_cache_generation_allocation_replacement_fallback=True,
        failure_cases=faults,failure_case_count=len(faults),maximum_scoped_leases=new.peak,
        balanced_leases=True,canaries=True,actor_commands_sha256=digest.hexdigest(),no_emulator_or_fps_claim=True)
    (HERE/('HOST-'+mode+'.json')).write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))


def main():
    WORK.mkdir(parents=True,exist_ok=True)
    for mode,flags in [('ordinary',[]),('sanitized',['-fsanitize=address,undefined','-fno-omit-frame-pointer'])]:
        for name,directory in [('control',CONTROL/'source'),('prepared',HERE/'source')]:
            extra='\nvoid host_actor(unsigned slot,int32_t *out){memcpy(out,slot<6?&renderer.cars[slot]:&renderer.signs[slot-6],28);}\n'
            if name=='prepared':extra+='''int host_emit(const uint8_t *p,const int32_t *r,int sign,int top,uint8_t *b,unsigned cap){
Assets a={0};a.prepared=p;Out o={b,0,cap,0};Car c;memcpy(&c,r,28);r28_sprite_emit(&o,&a,&c,sign,top,0);return o.error?-1:(int)o.n;}
'''
            path=WORK/(name+'-'+mode+'.c');path.write_text('#include "'+str(directory/'checked.c')+'"\n'+extra)
            subprocess.run(['cc','-shared','-fPIC','-O1','-fno-builtin','-ffp-contract=off',*flags,
                '-I'+str(CUSTOM/'paced-road/control/sdk/include'),'-I'+str(directory),str(path),'-o',str(WORK/(name+'-'+mode+'.so'))],check=True)
        env=dict(os.environ)
        if mode=='sanitized':env.update(LD_PRELOAD=subprocess.check_output(['cc','-print-file-name=libasan.so'],text=True).strip(),ASAN_OPTIONS='detect_leaks=0:halt_on_error=1',UBSAN_OPTIONS='halt_on_error=1')
        subprocess.run([sys.executable,__file__,'--worker',mode],env=env,check=True)
    a=json.loads((HERE/'HOST-ordinary.json').read_text());b=json.loads((HERE/'HOST-sanitized.json').read_text())
    assert {k:v for k,v in a.items() if k!='mode'}=={k:v for k,v in b.items() if k!='mode'}


if __name__=='__main__':
    parser=argparse.ArgumentParser();parser.add_argument('--worker');args=parser.parse_args()
    worker(args.worker) if args.worker else main()
