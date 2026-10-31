"""Actual checked/native C parity and publication/failure ownership checks."""
from pathlib import Path
import argparse,ctypes as C,hashlib,json,os,struct,subprocess,sys
HERE=Path(__file__).resolve().parent
CUSTOM=HERE.parents[1];RACE=CUSTOM/'full-race';WORK=HERE/'.work/host'
sys.path.insert(0,str(RACE))
from host_reference import SpriteRuntime,specification,snapshot,independent,BASE,Traffic
from host import Host

class FaultRuntime(SpriteRuntime):
    pub_fault=None
    def acquire(self,context,id,access,offset,n,out):
        fault=self.pub_fault if id==50304 and access==1 else None
        if fault in ('missing','busy','capacity'):return {'missing':2,'busy':7,'capacity':13}[fault]
        rc=super().acquire(context,id,access,offset,n,out)
        if not rc and fault=='short':out.contents.bytes=47
        if not rc and fault=='null':out.contents.data=C.POINTER(C.c_uint8)()
        if not rc and fault=='corrupt':C.memset(self.pointer(50304)+44,0,2)
        return rc
    def release(self,context,lease):
        fault=self.pub_fault=='release' and lease in self.live and self.live[lease][0]==self.pointer(50304)
        rc=super().release(context,lease)
        return 8 if fault else rc

def worker(mode):
    package=HERE/'.work/package'
    old=SpriteRuntime(specification(package),WORK/('original-'+mode+'.so'))
    new=FaultRuntime(specification(package),WORK/('checked-'+mode+'.so'))
    for r in (old,new):assert r.invoke('InitRace')==0
    commands=hashlib.sha256();pixels=hashlib.sha256()
    def compare():
        assert snapshot(old)==snapshot(new)
        assert old.data(50304)==new.data(50304)
        for key in (50301,50302,50303,50700,*range(50710,50718)):
            assert old.data(key)==new.data(key),key
            (pixels if key>=50700 else commands).update(new.data(key))
    for _ in range(2):
        assert old.invoke('Render30')==new.invoke('Render30')==0;compare()
    fixture=RACE/'fixtures/additive';meta=json.loads((fixture/'expected.json').read_text())
    motion=(fixture/'motion.bin').read_bytes();lanes=struct.pack('<6i',*meta['fixed_display_lanes'])
    tables=json.loads((BASE/'reference/tables.json').read_text());model=Traffic(tables,'circuit',3276800,1,99);player=3246800
    for car,gap in zip(model.cars,[0,3199,3200,6400,18000,80000]):
        car.active=1;car.progress=player+gap;car.position=car.progress%model.lap;car.lateral=0
    for tick in range(1,3601):
        record=(model.pace.record+1)%6 if model.pace.remaining==0 else model.pace.record
        player+=tables['records'][record][1]*2;model.advance(player,tick)
        assert old.invoke('Tick120')==new.invoke('Tick120')==0
        assert snapshot(old)==snapshot(new);independent(new,model,player,tick)
        if tick%4:continue
        row=motion[(tick//4-1)*24:tick//4*24]
        for r in (old,new):r.store(4,0,row);r.store(5,0,lanes)
        for car,pos,lat in zip(model.cars,struct.unpack('<6I',row),meta['fixed_display_lanes']):car.position=pos;car.lateral=lat
        assert old.invoke('Render30')==new.invoke('Render30')==0;compare()
    assert snapshot(new)==json.loads((RACE/'EXPECTED-FINAL-900.json').read_text())
    # Invoke the exact checker independently against corrupt publication fields.
    f=new.lib.host_publication;f.argtypes=[C.POINTER(Host),C.POINTER(C.c_uint8),C.c_uint32,C.c_uint32];f.restype=C.c_int32
    root=new.data(1);done=new.data(50304);gen=struct.unpack_from('<I',root,20)[0];req=struct.unpack_from('<I',root,296)[0]
    def check(data):return f(C.byref(new.host),(C.c_uint8*len(data)).from_buffer_copy(data),gen,req)
    assert check(root)==0
    faults=[]
    for offset in (20,24,32,292,296):
        b=bytearray(root);b[offset]^=1;assert check(b)!=0;faults.append('root-'+str(offset))
    for offset in (0,2,4,8,12,16,20,44,46):
        b=bytearray(done);b[offset]^=1;new.store(50304,0,bytes(b))
        assert check(root)!=0;faults.append('completion-'+str(offset));new.store(50304,0,done)
    for fault in ('missing','busy','capacity','short','null','release'):
        new.pub_fault=fault;assert check(root)!=0;assert not new.live
        faults.append('checker-'+fault)
    new.pub_fault=None
    # Failures in the actual entry must propagate rather than return DONE0.
    # No draw/swap is consumed by this host model after a failed entry.
    for fault in ('missing','busy','capacity','short','null','release','corrupt'):
        new.pub_fault=fault;assert new.invoke('Render30')!=0;assert not new.live
        faults.append('entry-'+fault)
    new.pub_fault=None
    for r in (old,new):
        assert r.invoke('StopRace')==r.invoke(operation=3)==0
        r.canaries();assert not r.live and r.grants==r.releases
    result=dict(passed=True,mode=mode,frames=900,physics_ticks=3600,warm_renders=2,
        original_module_state_and_all_output_buffers_exact=True,independent_world_each_tick=True,
        all_failure_cases=faults,failure_case_count=len(faults),max_leases=max(old.peak,new.peak),
        leases_balanced=True,canaries=True,command_buffers_sha256=commands.hexdigest(),pixel_buffers_sha256=pixels.hexdigest())
    (HERE/('HOST-'+mode+'.json')).write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))

def main():
    WORK.mkdir(parents=True,exist_ok=True);package=HERE/'.work/package'
    for mode in ('ordinary','sanitized'):
        for name in ('original','checked'):
            extra='\nvoid host_actor(unsigned slot,int32_t *out){memcpy(out,slot<6?&renderer.cars[slot]:&renderer.signs[slot-6],28);}\n'
            if name=='checked':extra+='int32_t host_publication(const vdplet_host_v1*h,const uint8_t*r,uint32_t g,uint32_t q){return r28_check_publication(h,r,g,q);}\n'
            source=WORK/(name+'-exports.c');source.write_text('#include "'+str(package/('native.c' if name=='original' else 'checked.c'))+'"\n'+extra)
            flags=[] if mode=='ordinary' else ['-fsanitize=address,undefined','-fno-omit-frame-pointer']
            subprocess.run(['cc','-shared','-fPIC','-O1','-fno-builtin','-ffp-contract=off',*flags,
                '-I'+str(CUSTOM/'paced-road/control/sdk/include'),'-I'+str(package),str(source),'-o',str(WORK/(name+'-'+mode+'.so'))],check=True)
        env=dict(os.environ)
        if mode=='sanitized':env.update(LD_PRELOAD=subprocess.check_output(['cc','-print-file-name=libasan.so'],text=True).strip(),ASAN_OPTIONS='detect_leaks=0:halt_on_error=1',UBSAN_OPTIONS='halt_on_error=1')
        subprocess.run([sys.executable,__file__,'--worker',mode],env=env,check=True)
    a=json.loads((HERE/'HOST-ordinary.json').read_text());b=json.loads((HERE/'HOST-sanitized.json').read_text())
    assert {k:v for k,v in a.items() if k!='mode'}=={k:v for k,v in b.items() if k!='mode'}

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--worker');a=p.parse_args()
    worker(a.worker) if a.worker else main()
