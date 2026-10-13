"""Host-only helper extraction regression, resource and failure qualification."""
import ctypes as C,hashlib,json,os,struct,subprocess,sys,time,copy
from pathlib import Path
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[3];WORK=HERE.parent/'.work/renderer-helper'
def sha(data):return hashlib.sha256(data).hexdigest()
class Range(C.Structure):_fields_=[('buffer',C.c_uint16),('access',C.c_uint16),('offset',C.c_uint32),('bytes',C.c_uint32)]
class Resources(C.Structure):_fields_=[(n,C.c_uint16) for n in ['player_bitmap_base','traffic_bitmap_base','sign_bitmap_base','traffic_matrix_base','player_mirror_matrix','sign_matrix']]
class Bindings(C.Structure):_fields_=[('struct_bytes',C.c_uint16),('schema',C.c_uint16),('session',C.c_uint32),('asset',Range),('output',Range*3),('track_identity',C.c_uint32),('asset_checksum',C.c_uint32),('resources',Resources)]
class Opponent(C.Structure):_fields_=[('station',C.c_int32),('lateral_q8',C.c_int32),('heading_turn16',C.c_int16),('active',C.c_uint16)]
class State(C.Structure):_fields_=[('struct_bytes',C.c_uint16),('schema',C.c_uint16),('session',C.c_uint32),('request_generation',C.c_uint32),('simulation_tick',C.c_uint32),('player_station',C.c_int32),('player_lateral_q8',C.c_int32),('phase',C.c_uint16),('steering',C.c_int16),('flags',C.c_uint16),('presentation_profile',C.c_uint16),('reference_crash_remaining',C.c_uint16),('reference_invulnerable',C.c_uint16),('opponents',Opponent*6)]
class Completion(C.Structure):_fields_=[('struct_bytes',C.c_uint16),('schema',C.c_uint16),('result',C.c_int32),('service_result',C.c_int32),('session',C.c_uint32),('request_generation',C.c_uint32),('simulation_tick',C.c_uint32),('output_bytes',C.c_uint32*3),('bands',C.c_uint16),('cars',C.c_uint16),('signs',C.c_uint16),('reason',C.c_uint16),('ready',C.c_uint16),('reserved',C.c_uint16)]
class ActorScratch(C.Structure):_fields_=[(n,C.c_int32) for n in ['bitmap','matrix','scale','xx','translation','x','y']]
class Context(C.Structure):_fields_=[('struct_bytes',C.c_uint32),('bound',C.c_uint32),('bindings',Bindings),('snapshot',State),('cars',ActorScratch*6),('signs',ActorScratch*2),('order',C.c_int32*6),('distance',C.c_int32*6)]
class View(C.Structure):_fields_=[('struct_bytes',C.c_uint32),('lease',C.c_uint32),('data',C.POINTER(C.c_uint8)),('bytes',C.c_uint32),('access',C.c_uint32)]
Acquire=C.CFUNCTYPE(C.c_int32,C.c_void_p,C.c_uint16,C.c_uint16,C.c_uint32,C.c_uint32,C.POINTER(View))
Release=C.CFUNCTYPE(C.c_int32,C.c_void_p,C.c_uint32)
class Host(C.Structure):_fields_=[('struct_bytes',C.c_uint32),('major',C.c_uint16),('minor',C.c_uint16),('caps',C.c_uint32),('context',C.c_void_p),('acquire',Acquire),('release',Release),('fb',C.c_void_p),('row',C.c_void_p),('end',C.c_void_p)]
for type_,size in [(Range,12),(Resources,12),(Bindings,76),(State,108),(Completion,48),(Context,464)]:assert C.sizeof(type_)==size
assert Completion.ready.offset==44 and State.opponents.offset==36

def clone(value):return type(value).from_buffer_copy(bytes(value))
def convert(raw):
    s=State(C.sizeof(State),1);s.session=struct.unpack_from('<I',raw,8)[0]
    s.request_generation,s.simulation_tick=struct.unpack_from('<II',raw,12)
    s.player_station,s.phase,s.steering,s.player_lateral_q8,s.flags,s.reference_crash_remaining,s.reference_invulnerable=struct.unpack_from('<iHhiHHH',raw,20)
    s.presentation_profile=int(bool(s.reference_crash_remaining or s.reference_invulnerable))
    for i in range(6):
        station,lateral,heading,active,reserved=struct.unpack_from('<iihBB',raw,40+i*12);assert reserved==0
        s.opponents[i]=Opponent(station,lateral,heading,active)
    return s
class Harness:
    def __init__(self,lib,track='fuji',shift=0):
        self.lib=lib;self.buffers={};self.live={};self.next=1;self.peak=0;self.acquires=self.releases=0
        self.fail_acquire=self.fail_release=0;self.keep_failed_lease=False;self.limit=3
        asset=(WORK/f'{track}.r24').read_bytes()
        self.b=Bindings(C.sizeof(Bindings),1,7);self.b.asset=Range(101+shift,1,3,len(asset))
        self.b.resources=Resources(0,5,120,63970,63984,63930)
        self.b.track_identity=struct.unpack_from('<I',asset,12)[0];self.b.asset_checksum=struct.unpack_from('<I',asset,24)[0]
        self.set(self.b.asset.buffer,b'abc'+asset+b'last!')
        for i,cap in enumerate([20480,2048,256]):
            self.b.output[i]=Range(102+i+shift,2,9,cap);self.set(102+i+shift,b'\xcc'*(9+cap+11))
        self.ctx=Context(C.sizeof(Context));self.c=Completion(C.sizeof(Completion),1)
        self.acquire_cb=Acquire(self.acquire);self.release_cb=Release(self.release)
        self.host=Host(C.sizeof(Host),1,0,1,None,self.acquire_cb,self.release_cb,None,None,None)
        # A real generated root lease is represented as one already-live slot.
        self.root=(C.c_uint8*126)();self.live[0]=(C.addressof(self.root),126,3)
    def set(self,id,data):self.buffers[id]=(C.c_uint8*len(data)).from_buffer_copy(data)
    def acquire(self,context,id,access,offset,length,out):
        self.acquires+=1
        if self.acquires==self.fail_acquire:return 2
        if id not in self.buffers:return 2
        data=self.buffers[id]
        if offset>len(data) or length>len(data)-offset:return 3
        pointer=C.addressof(data)+offset
        if any(pointer<p+n and p<pointer+length and ((mode|access)&2) for p,n,mode in self.live.values()):return 7
        if len(self.live)>=self.limit:return 13
        lease=self.next;self.next+=1;self.live[lease]=(pointer,length,access);self.peak=max(self.peak,len(self.live))
        out.contents.lease=lease;out.contents.data=C.cast(pointer,C.POINTER(C.c_uint8));out.contents.bytes=length;out.contents.access=access
        return 0
    def release(self,context,lease):
        self.releases+=1
        if lease not in self.live:return 8
        if self.releases==self.fail_release:
            if not self.keep_failed_lease:del self.live[lease]
            return 8
        del self.live[lease];return 0
    def reset_faults(self):self.acquires=self.releases=0;self.fail_acquire=self.fail_release=0
    def bind(self):return self.lib.rally_render_bind_v1(C.byref(self.host),C.byref(self.ctx),C.byref(self.b),C.byref(self.c))
    def prepare(self,s):return self.lib.rally_render_prepare_v1(C.byref(self.host),C.byref(self.ctx),C.byref(s),C.byref(self.c))
    def stop(self):return self.lib.rally_render_stop_v1(C.byref(self.ctx),C.byref(self.c))
    def output(self):return [bytes(self.buffers[r.buffer])[r.offset:r.offset+self.c.output_bytes[i]] for i,r in enumerate(self.b.output)]
    def canaries(self):
        for r in self.b.output:
            data=bytes(self.buffers[r.buffer]);assert data[:r.offset]==b'\xcc'*r.offset and data[r.offset+r.bytes:]==b'\xcc'*(len(data)-r.offset-r.bytes)
    def clean(self):assert set(self.live)=={0},self.live

def remap(data,resources):
    """Independent ordinary-command decoder; change only resource operands."""
    out=bytearray(data);at=0
    matrices={63970+i:resources.traffic_matrix_base+i for i in range(6)}|{63984:resources.player_mirror_matrix,63930:resources.sign_matrix}
    bitmaps={i:resources.player_bitmap_base+i for i in range(5)}|{5+i:resources.traffic_bitmap_base+i for i in range(30)}|{120+i:resources.sign_bitmap_base+i for i in range(8)}
    while at<len(data):
        if data[at]==18:at+=3
        elif data[at]==25:at+=6
        elif data[at]==24:at+=9
        elif data[at:at+3]==bytes([23,27,0]):out[at+3]=bitmaps[data[at+3]];at+=4
        elif data[at:at+3]==bytes([23,27,3]):at+=7
        elif data[at:at+4]==bytes([23,0,150,1]):
            old=struct.unpack_from('<H',data,at+4)[0];struct.pack_into('<H',out,at+4,matrices.get(old,old));at+=6
        elif data[at:at+3]==bytes([23,0,160]):
            old=struct.unpack_from('<H',data,at+3)[0];struct.pack_into('<H',out,at+3,matrices.get(old,old));op=data[at+5]
            if op==7:at+=6
            else:
                assert op==32
                at+=7 if data[at+6]==0 else 20
        else:raise AssertionError(('unknown command',at,data[at:at+12].hex()))
    assert at==len(data);return bytes(out)

def failures(lib,raw):
    s=convert(raw);checks=0
    for field,value in [('struct_bytes',75),('schema',2),('session',0)]:
        h=Harness(lib);assert h.bind()==0;setattr(h.b,field,value)
        assert h.bind()==1 and not h.ctx.bound and not h.c.ready;h.clean();checks+=1
    for member,value in [('access',2),('offset',4294967295)]:
        h=Harness(lib);setattr(h.b.asset,member,value);assert h.bind()==1 and not h.ctx.bound;h.clean();checks+=1
    for member,value in [('access',1),('buffer',0)]:
        h=Harness(lib);setattr(h.b.output[0],member,value);assert h.bind()==1 and not h.ctx.bound;h.clean();checks+=1
    for member,value in [('player_bitmap_base',253),('traffic_bitmap_base',0),('traffic_matrix_base',65534),('sign_matrix',63970)]:
        h=Harness(lib);setattr(h.b.resources,member,value);assert h.bind()==1 and not h.ctx.bound;h.clean();checks+=1
    for member in ['track_identity','asset_checksum']:
        h=Harness(lib);setattr(h.b,member,getattr(h.b,member)^1);assert h.bind()==4 and not h.ctx.bound;h.clean();checks+=1
    h=Harness(lib);h.b.asset.bytes-=1;assert h.bind()==4 and not h.ctx.bound;h.clean();checks+=1
    for offset,value in [('struct_bytes',107),('schema',2),('session',8),('player_station',-1),('player_station',3276800),
                         ('player_lateral_q8',38401),('phase',8000),('steering',22),('flags',8),('presentation_profile',2),('reference_crash_remaining',151)]:
        h=Harness(lib);assert h.bind()==0 and h.prepare(s)==0 and h.c.ready==1
        bad=clone(s);setattr(bad,offset,value)
        assert h.prepare(bad)==1 and h.c.ready==0 and h.c.result==1;h.clean();h.canaries();checks+=1
    for member,value in [('station',3276800),('lateral_q8',14261),('heading_turn16',1921),('active',2)]:
        h=Harness(lib);assert h.bind()==0;bad=clone(s);bad.opponents[0].active=1;setattr(bad.opponents[0],member,value)
        assert h.prepare(bad)==1 and not h.c.ready;h.clean();checks+=1
    h=Harness(lib);assert h.bind()==0;bad=clone(s);bad.presentation_profile=0;bad.reference_crash_remaining=1
    assert h.prepare(bad)==1;checks+=1
    for mode,number in [('acquire',i) for i in range(1,8)]+[('release',i) for i in range(1,8)]:
        h=Harness(lib);assert h.bind()==0 and h.prepare(s)==0 and h.c.ready==1
        h.reset_faults();setattr(h,'fail_'+mode,number)
        assert h.prepare(s)!=0 and not h.c.ready and h.c.service_result!=0,(mode,number)
        if mode=='release':assert not h.ctx.bound
        h.clean();h.canaries();checks+=1
    # A callback that refuses to release is reported, never falsely "cleaned".
    h=Harness(lib);assert h.bind()==0;h.reset_faults();h.fail_release=1;h.keep_failed_lease=True
    assert h.prepare(s)==8 and not h.c.ready and not h.ctx.bound and len(h.live)>1
    h.live={0:h.live[0]} # simulated runtime entry cleanup, outside helper
    checks+=1
    for mode,number in [('acquire',i) for i in range(1,5)]+[('release',i) for i in range(1,5)]:
        h=Harness(lib);setattr(h,'fail_'+mode,number);assert h.bind()!=0 and not h.ctx.bound and not h.c.ready;h.clean();checks+=1
    for index in range(3):
        for cap in [1,5,6,15]:
            h=Harness(lib);h.b.output[index].bytes=cap;assert h.bind()==0;h.c.ready=1
            assert h.prepare(s)==3 and not h.c.ready;h.clean()
            r=h.b.output[index];assert bytes(h.buffers[r.buffer])[r.offset+cap:]==b'\xcc'*(len(h.buffers[r.buffer])-r.offset-cap)
            checks+=1
    # Cross-ID aliases, asset aliases, native-object aliases, corrupted asset/rebind.
    h=Harness(lib);h.buffers[h.b.output[1].buffer]=h.buffers[h.b.output[0].buffer]
    assert h.bind()!=0 and not h.ctx.bound;h.clean();checks+=1
    h=Harness(lib);h.b.output[0].buffer=h.b.asset.buffer;h.b.output[0].offset=3
    assert h.bind()!=0 and not h.ctx.bound;h.clean();checks+=1
    h=Harness(lib);r=h.b.output[0];r.bytes=84;h.buffers[r.buffer]=(C.c_uint8*84).from_address(C.addressof(h.ctx));r.offset=0
    assert h.bind()!=0 and not h.ctx.bound;h.clean();checks+=1
    h=Harness(lib);h.buffers[h.b.asset.buffer][-6]^=1
    assert h.bind()==4 and not h.ctx.bound;h.clean();checks+=1
    h=Harness(lib);assert h.bind()==0 and h.stop()==0 and h.prepare(s)==12 and not h.c.ready
    assert h.bind()==0 and h.prepare(s)==0;h.clean();checks+=1
    h=Harness(lib);assert h.bind()==0;h.b.schema=2;assert h.bind()==1 and not h.ctx.bound;checks+=1
    # Two unreleased generated base views violate the intended peak3 contract.
    h=Harness(lib);assert h.bind()==0;arg=(C.c_uint8*2)();h.live[-1]=(C.addressof(arg),2,1)
    assert h.prepare(s)==13 and not h.c.ready;assert set(h.live)=={0,-1};checks+=1
    h=Harness(lib);assert h.bind()==0
    for generation in [4294967295,0,1]:
        copy_s=clone(s);copy_s.request_generation=generation;copy_s.simulation_tick=generation
        assert h.prepare(copy_s)==0 and h.c.request_generation==generation and h.c.simulation_tick==generation
        assert h.c.ready==1;checks+=1
    # Admission failures that cannot safely touch completion remain failures
    # even if that malformed completion still contains an old ready bit.
    h=Harness(lib);assert h.bind()==0 and h.prepare(s)==0
    h.c.struct_bytes=47;before=bytes(h.c)
    assert h.prepare(s)==1 and bytes(h.c)==before;h.clean();checks+=1
    # Invalid ABI clears valid completion and performs no acquisition.
    h=Harness(lib);assert h.bind()==0 and h.prepare(s)==0;h.reset_faults();h.host.major=2
    assert h.prepare(s)==5 and not h.c.ready and h.acquires==0;h.clean();checks+=1
    # Retained output must not overwrite the native state object during entry.
    h=Harness(lib);assert h.bind()==0
    descriptor=h.ctx.bindings.output[0];descriptor.offset=0;descriptor.bytes=108
    h.b.output[0]=descriptor;h.buffers[descriptor.buffer]=(C.c_uint8*108).from_address(C.addressof(s))
    before=bytes(s);assert h.prepare(s)!=0 and not h.c.ready and bytes(s)==before;h.clean();checks+=1
    # Two descriptors may share one allocation if their bounded ranges do not.
    h=Harness(lib);combined=sum(r.bytes for r in h.b.output)+36;h.set(700,b'\xcc'*combined)
    offset=9
    for i in range(3):
        h.b.output[i]=Range(700,2,offset,h.b.output[i].bytes);offset+=h.b.output[i].bytes+9
    assert h.bind()==0 and h.prepare(s)==0 and h.c.ready;h.clean();checks+=1
    return checks

def worker(library,label):
    started=time.monotonic();lib=C.CDLL(str(library))
    lib.rally_render_bind_v1.argtypes=[C.POINTER(Host),C.POINTER(Context),C.POINTER(Bindings),C.POINTER(Completion)]
    lib.rally_render_prepare_v1.argtypes=[C.POINTER(Host),C.POINTER(Context),C.POINTER(State),C.POINTER(Completion)]
    lib.rally_render_stop_v1.argtypes=[C.POINTER(Context),C.POINTER(Completion)]
    for name in ('bind','prepare','stop'):getattr(lib,'rally_render_'+name+'_v1').restype=C.c_int32
    cases=json.loads((HERE.parent/'renderer-prep/scene-cases.json').read_text())['cases'];rows=[];first=None
    for track in ('fuji','oval'):
        h=Harness(lib,track);assert h.bind()==0;selected=[x for x in cases if x['track']==track]
        for case in selected:
            raw=bytes.fromhex(case['state_hex']);s=convert(raw);first=first or raw
            assert h.prepare(s)==0 and h.c.ready==1,(track,case['label'],h.c.result,h.c.reason)
            assert [sha(x) for x in h.output()]==case['output_sha256'],(track,case['label'])
            assert [h.c.bands,h.c.cars,h.c.signs]==case['counts']
            assert (h.c.session,h.c.request_generation,h.c.simulation_tick)==(s.session,s.request_generation,s.simulation_tick)
            h.clean();h.canaries()
        # Generated buffer IDs and resource IDs are independent of kernel logic.
        sample=next(x for x in selected if x['counts'][1]>=2);s=convert(bytes.fromhex(sample['state_hex']));assert h.prepare(s)==0;old=h.output()
        relocated=Harness(lib,track,500);relocated.b.resources=Resources(40,50,100,60010,60100,60001)
        assert relocated.bind()==0 and relocated.prepare(s)==0
        assert relocated.output()==[remap(x,relocated.b.resources) for x in old];relocated.clean();relocated.canaries()
        # Multiple independent contexts remain valid across interleaved calls.
        assert h.prepare(s)==0 and h.output()==old
        rows.append(dict(track=track,scenes=len(selected),peak_including_root=h.peak,relocated_resource_case=True,independent_context_case=True))
    failure_case=next(x for x in cases if x['track']=='fuji' and x['label'].startswith('boundary:') and x['counts'][1]>=2)
    n=failures(lib,bytes.fromhex(failure_case['state_hex']))
    result=dict(scope='host C helper/SDK-service mock; no compiler glue, target, pixels or cadence qualification',label=label,rows=rows,failure_lifecycle_metadata_cases=n,
                asan_ubsan=label=='sanitized',duration_seconds=round(time.monotonic()-started,3),library_sha256=sha(library.read_bytes()))
    (HERE/(label+'-results.json')).write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))

def main():
    started=time.monotonic()
    WORK.mkdir(parents=True,exist_ok=True)
    for name in ['ordinary-results.json','sanitized-results.json','RESULTS.json']:(HERE/name).unlink(missing_ok=True)
    # Recreate private assets without rerunning/mutating a published handoff.
    sys.path.insert(0,str(HERE.parent/'reference'))
    from freeze import prepare
    frozen,_=prepare()
    exporter=subprocess.check_output(['git','-C',str(ROOT),'show','d250f43:docs/tasks/RALLY-24/experiment/assets.cpp'])
    assert sha(exporter)=='2c817ada698d5c06fe29a7ea0dfd819e89e19d6b8caf747b7f6fc705ab70ef99'
    (WORK/'assets.cpp').write_bytes(exporter)
    subprocess.run(['c++','-std=c++17','-O2','-I'+str(frozen/'rally-production/include'),'-I'+str(frozen/'rally-game/include'),str(WORK/'assets.cpp'),'-o',str(WORK/'assets')],check=True)
    subprocess.run([str(WORK/'assets'),str(frozen/'rally-production'),str(WORK)],check=True)
    assert (WORK/'asset_meta.h').read_bytes()==(HERE/'asset_meta.inc').read_bytes()
    rows=json.loads((HERE.parent/'renderer-prep/FIXTURE-RECEIPT.json').read_text())['rows']
    for row in rows:assert sha((WORK/(row['track']+'.r24')).read_bytes())==row['asset_sha256']
    for label,flags in [('ordinary',[]),('sanitized',['-g','-fsanitize=address,undefined','-fno-omit-frame-pointer'])]:
        library=WORK/(label+'.so')
        subprocess.run(['cc','-std=c11','-O2','-ffp-contract=off','-fno-builtin','-Wall','-Wextra','-Werror','-shared','-fPIC',*flags,
                        '-I'+str(ROOT.parent/'agon-vdplet/include'),str(HERE/'rally_render.c'),'-o',str(library)],check=True)
        env=os.environ.copy()
        if flags:
            env['LD_PRELOAD']=subprocess.check_output(['cc','-print-file-name=libasan.so'],text=True).strip()
            env['ASAN_OPTIONS']='detect_leaks=0';env['UBSAN_OPTIONS']='halt_on_error=1:print_stacktrace=1'
        subprocess.run([str(ROOT/'.venv/bin/python'),str(HERE/'verify.py'),'--worker',str(library),label],env=env,check=True)
    subprocess.run(['cc','-std=c11','-O2','-ffp-contract=off','-fno-builtin','-fstack-usage','-I'+str(ROOT.parent/'agon-vdplet/include'),
                    '-c',str(HERE/'rally_render.c'),'-o',str(WORK/'stack.o')],check=True)
    frames={line.split('\t')[0].rsplit(':',1)[-1]:int(line.split('\t')[1]) for line in (WORK/'stack.su').read_text().splitlines()}
    result=dict(schema=1,ordinary=json.loads((HERE/'ordinary-results.json').read_text()),sanitized=json.loads((HERE/'sanitized-results.json').read_text()),
        total_setup_execution_host_seconds=round(time.monotonic()-started,3),host_only_static_frames=frames,context_bytes=C.sizeof(Context),target_stack_admission='not measured/qualified; includes future generated callers and SDK callbacks',
        compiler=subprocess.check_output(['cc','--version'],text=True).splitlines()[0],fixtures_sha256=sha((HERE.parent/'renderer-prep/scene-cases.json').read_bytes()),asset_exporter_sha256=sha(exporter),
        sources={p.name:sha(p.read_bytes()) for p in [HERE/'rally_render.h',HERE/'rally_render.c',HERE/'render_core.inc',HERE/'asset_meta.inc',HERE/'verify.py']})
    (HERE/'RESULTS.json').write_text(json.dumps(result,indent=2)+'\n')
if __name__=='__main__':
    if len(sys.argv)==4 and sys.argv[1]=='--worker':worker(Path(sys.argv[2]),sys.argv[3])
    else:main()
