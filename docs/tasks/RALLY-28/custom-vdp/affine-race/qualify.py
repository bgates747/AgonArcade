"""Actual generated-C full replay; independent draw/cache/ownership checks."""
from pathlib import Path
import argparse,ctypes as C,hashlib,json,os,struct,subprocess,sys
HERE=Path(__file__).resolve().parent
RACE=HERE.parent/'full-race'
WORK=HERE/'.work/host'
sys.path.insert(0,str(RACE))
from host_reference import independent,snapshot,BASE,Traffic,specification
from host_replay import SpriteRuntime
from span_check import SpanRuntime
ORDER=('rebuild','cached-affine','prepared-bitmap','additive')
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()

def decode(data,matrices,images):
    at=0;selected=None;matrix_id=65535;clip=[0,24,319,223]
    draws=[];writes=creates=0;used=set()
    while at<len(data):
        if data[at:at+6]==bytes.fromhex('1700a0ffff07'):
            assert at+6==len(data);at+=6
        elif data[at]==24:
            l,b,r,t=struct.unpack_from('<4h',data,at+1);clip=[l,t,r,b];at+=9
        elif data[at:at+2]==b'\x19\4':at+=6
        elif data[at:at+3]==bytes.fromhex('1700a0'):
            key,op=struct.unpack_from('<HB',data,at+3);at+=6
            if op==32:
                operation=data[at];at+=1
                if operation==0:matrices[key]=[256,0,0,0,256,0]
                else:
                    assert operation==11 and data[at]==200
                    matrices[key]=list(struct.unpack_from('<6h',data,at+1));at+=13;writes+=1
            else:
                assert op==40
                flags,mid,bmp=struct.unpack_from('<BHH',data,at);at+=5
                assert flags==5 and 50710<=key<50718
                assert key not in used,'Replacing an already queued image in the same frame'
                assert 64005<=bmp<64035 or 64120<=bmp<64128
                images[key]=(bmp-64000,matrices[mid][:]);creates+=1
        elif data[at:at+4]==bytes.fromhex('17009601'):
            matrix_id=struct.unpack_from('<H',data,at+4)[0];at+=6
        elif data[at:at+3]==bytes.fromhex('171b00'):
            selected=data[at+3];at+=4
        elif data[at:at+3]==bytes.fromhex('171b20'):
            selected=struct.unpack_from('<H',data,at+3)[0];at+=5
        elif data[at:at+3]==bytes.fromhex('171b03'):
            x,y=struct.unpack_from('<hh',data,at+3);at+=7
            if selected>=50710:
                assert matrix_id==65535 and selected not in used
                used.add(selected);bmp,coeff=images[selected]
                width=64 if bmp>=120 else 102
                minx=min(int(coeff[2]/256),int((coeff[2]+coeff[0]*width)/256))
                x-=minx
            else:bmp=selected;coeff=matrices[matrix_id]
            draws.append(dict(bitmap_id=bmp,matrix_q8=coeff[:],x=x,y=y,clip=clip[:]))
        else:raise AssertionError((at,data[at:at+20].hex()))
    return draws,writes,creates

def worker(mode):
    builds=json.loads((HERE/'BUILD.json').read_text())
    runtimes={}
    for name in ORDER:
        package=HERE/builds[name]['package']
        typ=SpriteRuntime if name=='additive' else SpanRuntime
        runtime=typ(specification(package),WORK/(name+'-'+mode+'.so'))
        assert runtime.invoke('InitRace')==0
        if name in ('cached-affine','prepared-bitmap'):
            runtime.lib.host_counts.argtypes=[C.POINTER(C.c_uint)]
        runtimes[name]=runtime
    traces=[json.loads(x) for x in (HERE.parent/'affine-offline/OBSERVED-DRAWS.jsonl').read_text().splitlines()]
    plans={}
    for r in traces:
        if r['kind']!='player':plans.setdefault((r['phase'],r['frame'],r['warm_index']),[]).append(r)
    matrices={n:{} for n in ORDER};images={n:{} for n in ORDER}
    counters={n:dict(draws=0,matrix_writes=0,generations=0) for n in ORDER}
    oracle_matrices={n:{} for n in ORDER};oracle_images={n:{} for n in ORDER}
    for n in ORDER:matrices[n][65535]=[256,0,0,0,256,0]
    render_index=0;max_actor_bytes={n:0 for n in ORDER};road_hash=hashlib.sha256()
    expected_final=json.loads((RACE/'EXPECTED-FINAL-900.json').read_text())
    def render(phase,frame=0,warm=0):
        nonlocal render_index
        render_index+=1
        expected=plans[phase,frame,warm]
        if frame==1:
            for n in ORDER:
                counters[n]=dict(draws=0,matrix_writes=0,generations=0)
                oracle_matrices[n]={};oracle_images[n]={}
        outputs={}
        for name,runtime in runtimes.items():
            assert runtime.invoke('Render30')==0,(name,phase,frame)
            done=runtime.data(50304);lengths=struct.unpack_from('<III',done,24)
            assert struct.unpack_from('<H',done,44)[0]==1
            outputs[name]=[runtime.data(k)[:n] for k,n in zip((50301,50302,50303),lengths)]
            max_actor_bytes[name]=max(max_actor_bytes[name],lengths[1])
            if name=='additive':continue
            draws,writes,creates=decode(outputs[name][1],matrices[name],images[name])
            assert draws==[{k:r[k] for k in ('bitmap_id','matrix_q8','x','y','clip')} for r in expected],(name,phase,frame)
            counters[name]['draws']+=len(draws);counters[name]['matrix_writes']+=writes;counters[name]['generations']+=creates
            wanted_writes=wanted_creates=0;signslot=0
            for r in expected:
                mid=r['matrix_id'];coeff=r['matrix_q8'];sign=r['kind']=='sign'
                slot=6+signslot if sign else mid-63970
                if sign:signslot+=1
                image=(r['bitmap_id'],tuple(coeff))
                miss=oracle_images[name].get(slot)!=image
                if name=='rebuild' or ((name=='cached-affine' or miss) and oracle_matrices[name].get(mid)!=coeff):
                    wanted_writes+=1;oracle_matrices[name][mid]=coeff[:]
                if name=='prepared-bitmap' and miss:
                    wanted_creates+=1;oracle_images[name][slot]=image
            assert (writes,creates)==(wanted_writes,wanted_creates),(name,phase,frame,writes,wanted_writes,creates,wanted_creates)
            if name=='prepared-bitmap':
                # Every current draw has an immutable distinct slot until its
                # frame fence. Its image key includes original view and mirror.
                assert len(images[name])<=8
        for n,r in runtimes.items():
            assert snapshot(r)==snapshot(runtimes['rebuild']),(n,phase,frame,'full state')
            assert outputs[n][0]==outputs['rebuild'][0] and outputs[n][2]==outputs['rebuild'][2],(n,'road/player')
            assert r.data(50700)==runtimes['rebuild'].data(50700)
        road_hash.update(outputs['rebuild'][0]);road_hash.update(runtimes['rebuild'].data(50700))
    render('warm',warm=1);render('warm',warm=2)
    fixture=RACE/'fixtures/span-native';metadata=json.loads((fixture/'expected.json').read_text())
    motion=(fixture/'motion.bin').read_bytes();lanes=struct.pack('<6i',*metadata['fixed_display_lanes'])
    tables=json.loads((BASE/'reference/tables.json').read_text());model=Traffic(tables,'circuit',3276800,1,99);player=3246800
    for car,gap in zip(model.cars,[0,3199,3200,6400,18000,80000]):
        car.active=1;car.progress=player+gap;car.position=car.progress%model.lap;car.lateral=0
    for tick in range(1,3601):
        record=(model.pace.record+1)%6 if model.pace.remaining==0 else model.pace.record
        player+=tables['records'][record][1]*2;model.advance(player,tick)
        for name,runtime in runtimes.items():
            assert runtime.invoke('Tick120')==0
            assert snapshot(runtime)==snapshot(runtimes['rebuild'])
        independent(runtimes['rebuild'],model,player,tick)
        if tick%4:continue
        frame=tick//4;row=motion[(frame-1)*24:frame*24]
        for runtime in runtimes.values():runtime.store(4,0,row);runtime.store(5,0,lanes)
        for car,pos,lat in zip(model.cars,struct.unpack('<6I',row),metadata['fixed_display_lanes']):car.position=pos;car.lateral=lat
        render('measured',frame)
    stats={}
    for name,runtime in runtimes.items():
        assert snapshot(runtime)==expected_final
        if name in ('cached-affine','prepared-bitmap'):
            a=(C.c_uint*7)();runtime.lib.host_counts(a)
            counts=list(a);c=counters[name]
            assert counts[0]==c['draws'] and counts[2]==c['matrix_writes'] and counts[4]==c['generations']
            assert counts[1]+counts[2]==(counts[4] if name=='prepared-bitmap' else counts[0])
            if name=='prepared-bitmap':assert counts[3]+counts[4]==counts[0]
            stats[name]=dict(draws=counts[0],matrix_hits=counts[1],matrix_misses=counts[2],bitmap_hits=counts[3],
                bitmap_misses=counts[4],generated_pixels=counts[5],logical_peak_retained_pixels=counts[6])
        assert runtime.invoke('StopRace')==0 and runtime.invoke(operation=3)==0
        runtime.canaries();assert runtime.grants==runtime.releases and not runtime.live
    result=dict(passed=True,mode=mode,frames=900,physics_ticks=3600,warm_frames=2,full_final_state_exact=True,
        original_actor_plans_exact=True,road_pixels_and_player_commands_exact=True,cache_oracles_exact=True,
        cold_first_timed_frame=True,cache_counts=stats,max_actor_command_bytes=max_actor_bytes,
        road_sha256=road_hash.hexdigest(),four_lease_limit=max(r.peak for r in runtimes.values()),
        target_cache_counts_are_host_replay_not_target_telemetry=True)
    (HERE/('HOST-'+mode+'.json')).write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))

def main():
    WORK.mkdir(parents=True,exist_ok=True)
    for mode in ('ordinary','sanitized'):
        flags=[] if mode=='ordinary' else ['-fsanitize=address,undefined','-fno-omit-frame-pointer']
        for name in ORDER:
            p=HERE/'.work/packages'/name
            extra='\nvoid host_actor(unsigned n,int32_t *out){memcpy(out,n<6?&renderer.cars[n]:&renderer.signs[n-6],28);}\n'
            if name in ('cached-affine','prepared-bitmap'):extra+='void host_counts(unsigned *p){memcpy(p,r28_counts,sizeof r28_counts);}\n'
            source=WORK/(name+'.c');source.write_text('#include "native.c"\n'+extra)
            subprocess.run(['cc','-shared','-fPIC','-O1','-fno-builtin','-ffp-contract=off',*flags,
                '-I'+str(HERE.parent/'paced-road/control/sdk/include'),'-I'+str(p),str(source),'-o',str(WORK/(name+'-'+mode+'.so'))],check=True)
        env=dict(os.environ)
        if mode=='sanitized':
            env.update(LD_PRELOAD=subprocess.check_output(['cc','-print-file-name=libasan.so'],text=True).strip(),
                ASAN_OPTIONS='detect_leaks=0:halt_on_error=1',UBSAN_OPTIONS='halt_on_error=1')
        subprocess.run([sys.executable,__file__,'--worker',mode],env=env,check=True)
    a=json.loads((HERE/'HOST-ordinary.json').read_text());b=json.loads((HERE/'HOST-sanitized.json').read_text())
    assert {k:v for k,v in a.items() if k!='mode'}=={k:v for k,v in b.items() if k!='mode'}
    print('Both host qualifications agree.')

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--worker');a=p.parse_args()
    worker(a.worker) if a.worker else main()
