"""Actual simulation/helper joined by explicit host-only D2 marshaling/owner model."""
import ctypes as C,importlib.util,struct,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent;BASE=HERE.parent
sys.path.insert(0,str(BASE/'generated-state'))
from adapter import Interface
from host import Runtime

def helper_types():
    spec=importlib.util.spec_from_file_location('accepted_render_types',BASE/'renderer-helper/verify.py')
    m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m);return m
H=helper_types()
class Layout(C.Structure):
    _fields_=[('struct_bytes',C.c_uint32),('root',C.c_uint16),('root_bytes',C.c_uint16),('tick_entry',C.c_uint16),('entry_count',C.c_uint16),
              ('tick_offset',C.c_uint32),('heading_offset',C.c_uint32),('player_offset',C.c_uint32),('lateral_offset',C.c_uint32),('lap',C.c_uint32),('active',H.Range),('position',H.Range),('lateral',H.Range)]
class Proof(C.Structure):_fields_=[('session',C.c_uint32),('tick',C.c_uint32),('success_generation',C.c_uint32),('observed_runtime',C.c_int32),('request',C.c_uint32)]
class Presentation(C.Structure):_fields_=[('phase',C.c_uint16),('steering',C.c_int16),('flags',C.c_uint16),('reserved',C.c_uint16)]
class Map(C.Structure):_fields_=[('root',H.Range),('argument',H.Range),('completion',H.Range),('bindings',H.Bindings),('entries',C.c_uint16*5),('entry_count',C.c_uint16),('globals_bytes',C.c_uint16),('descriptors',C.c_uint8*64)]
class Module(C.Structure):_fields_=[('renderer',H.Context),('map',Map)]
class Observation(C.Structure):_fields_=[('before_generation',C.c_uint32),('session',C.c_uint32),('request',C.c_uint32),('tick',C.c_uint32),('entry',C.c_uint16),('runtime_result',C.c_int32),('attempted',C.c_int)]
Copy=C.CFUNCTYPE(C.c_int32,C.c_void_p,C.POINTER(C.c_uint8),C.c_void_p,C.c_uint32)
assert C.sizeof(Layout)==68 and C.sizeof(Proof)==20 and C.sizeof(Presentation)==8 and C.sizeof(Map)==192 and C.sizeof(Module)==656

def layout(spec):
    s=Layout(C.sizeof(Layout),spec.interface['state_buffer'],spec.root['root_bytes'],spec.entries['Tick120'],len(spec.entries))
    for attr,field,type_ in [('tick_offset','worldTick','uint32'),('heading_offset','routeHeading','sint32'),('player_offset','playerStation','uint32'),('lateral_offset','playerLateral','sint32')]:
        g=spec.globals[field];assert g['type']==type_ and g['bytes']==4;setattr(s,attr,g['offset'])
    for attr,type_,size in [('active','uint16',12),('position','uint32',24),('lateral','sint32',24)]:
        a=spec.arrays[attr];assert a['type']==type_ and a['count']==6 and a['lower']==0 and a['upper']==5 and a['bytes']==size
        setattr(s,attr,H.Range(a['buffer'],1,a['offset'],a['bytes']))
    s.lap=3276800;return s

class Services(Runtime):
    def __init__(self,*args):
        self.reject_publish=False;self.reject_release=False;self.hold_release=False;self.publish_id=0;self.cleanup_leases=0
        super().__init__(*args)
    def acquire(self,context,id,access,offset,n,out):
        if self.reject_publish and id==self.publish_id:return 2
        return super().acquire(context,id,access,offset,n,out)
    def release(self,context,lease):
        if self.reject_release and lease in self.live and self.live[lease][0]==self.pointer(self.publish_id):
            self.reject_release=False
            if not self.hold_release:super().release(context,lease)
            return 8
        return super().release(context,lease)
    def entry_cleanup(self):
        self.cleanup_leases+=len(self.live);self.live.clear() # explicit host SDK-entry cleanup model

class Pipeline:
    def __init__(self,simlib,renderlib,directory,asset,relocated=False):
        self.spec=Interface(directory);self.r=Services(self.spec,simlib);self.lib=C.CDLL(str(renderlib));self.layout=layout(self.spec)
        self.lib.scene_marshal.argtypes=[C.POINTER(H.Host),C.POINTER(Layout),C.POINTER(Proof),C.POINTER(Presentation),C.POINTER(H.State)]
        self.lib.scene_marshal.restype=C.c_int32
        self.lib.model_init_root.argtypes=[C.c_void_p,C.POINTER(Map),C.c_uint32]
        self.lib.model_clear_ready.argtypes=[C.POINTER(H.Host),C.POINTER(Map)];self.lib.model_clear_ready.restype=C.c_int32
        self.lib.model_dispatch.argtypes=[C.POINTER(H.Host),C.POINTER(Module),C.c_uint16,C.POINTER(H.State),C.c_uint16,Copy,C.c_void_p];self.lib.model_dispatch.restype=C.c_int32
        self.lib.model_can_draw.argtypes=[C.POINTER(Map),C.c_void_p,C.c_uint32,C.POINTER(H.Completion),C.POINTER(Observation)];self.lib.model_can_draw.restype=C.c_int
        self.host=C.cast(C.byref(self.r.host),C.POINTER(H.Host));self.session=7;self.source_rc=0;self.source_generation=0;self.last_render_tick=0;self.copy_failure=False
        self.module=Module();self.module.renderer.struct_bytes=C.sizeof(H.Context);m=self.module.map;base=52000 if relocated else 50000
        m.root=H.Range(base,2,0,128);m.argument=H.Range(base+1,1,0,2);m.completion=H.Range(base+2,2,0,48)
        m.bindings=H.Bindings(C.sizeof(H.Bindings),1,self.session);b=m.bindings;b.asset=H.Range(base+3,1,0,len(asset))
        b.track_identity=struct.unpack_from('<I',asset,12)[0];b.asset_checksum=struct.unpack_from('<I',asset,24)[0]
        b.resources=H.Resources(40,50,100,60010,60100,60001) if relocated else H.Resources(0,5,120,63970,63984,63930)
        for i,cap in enumerate([20480,2048,256]):b.output[i]=H.Range(base+4+i,2,0,cap)
        m.entries[:]=[4,2,0,5,1] if relocated else [0,1,2,3,4];m.entry_count=6;m.globals_bytes=16
        for i in range(4):m.descriptors[i*16]=i+1
        ids=[base+i for i in range(7)];assert not set(ids)&(set(self.r.buffers)|set(self.spec.backends['native_owned'])|set(self.spec.backends['buffered_owned']))
        self.r.install(base,b'\x00'*128);self.lib.model_init_root(self.r.pointer(base),C.byref(m),self.session)
        self.r.install(base+1,struct.pack('<H',base),1);self.r.install(base+2,bytes(H.Completion(48,1)))
        self.r.install(base+3,asset,1)
        for output in b.output:self.r.install(output.buffer,b'\xcc'*output.bytes)
        self.r.publish_id=base+2;self.r.store(self.r.root_id,8,struct.pack('<I',self.session));self.copy_cb=Copy(self.copy)
        self.observation=Observation();self.last_proof=Proof();self.last_present=Presentation();self.last_state=H.State()
        assert self.lifecycle(0)==0
    def copy(self,context,target,source,n):C.memmove(target,source,n);return 3 if self.copy_failure else 0
    def completion(self):return H.Completion.from_buffer_copy(self.r.data(self.module.map.completion.buffer))
    def model_root(self):return self.r.data(self.module.map.root.buffer)
    def source_tick(self,player,lateral):
        self.r.put('playerStation',player);self.r.put('playerLateral',lateral)
        self.source_rc=self.r.invoke('Tick120');self.r.store(self.r.root_id,16,struct.pack('<i',self.source_rc))
        if not self.source_rc:
            self.source_generation=(self.source_generation+1)&0xffffffff
            assert struct.unpack_from('<I',self.r.data(self.r.root_id),20)[0]==self.source_generation
        return self.source_rc
    def clear_ready(self):return self.lib.model_clear_ready(self.host,C.byref(self.module.map))
    def lifecycle(self,logical):
        state=H.State(C.sizeof(H.State),1);state.session=self.session
        rc=self.clear_ready()
        if not rc:rc=self.lib.model_dispatch(self.host,C.byref(self.module),self.module.map.entries[logical],C.byref(state),0,self.copy_cb,None)
        self.r.entry_cleanup();self.r.store(self.module.map.root.buffer,16,struct.pack('<i',rc))
        return rc
    def render(self,request,phase,proof=None,present=None):
        tick=self.spec.get(self.r.data(self.r.root_id),'worldTick');p=proof or Proof(self.session,tick,self.source_generation,self.source_rc,request)
        v=present or Presentation(phase,0,3,0);state=H.State();m=self.module.map
        before=struct.unpack_from('<I',self.model_root(),20)[0]
        self.observation=Observation(before,p.session,p.request,p.tick,m.entries[2],0,0)
        rc=self.clear_ready()
        if not rc and (p.tick!=self.last_render_tick+4 or p.tick%4):rc=1
        if not rc:rc=self.lib.scene_marshal(self.host,C.byref(self.layout),C.byref(p),C.byref(v),C.byref(state))
        if not rc:
            self.observation.attempted=1;rc=self.lib.model_dispatch(self.host,C.byref(self.module),m.entries[2],C.byref(state),0,self.copy_cb,None)
        self.r.entry_cleanup();self.r.store(m.root.buffer,16,struct.pack('<i',rc));self.observation.runtime_result=rc
        self.last_proof=Proof.from_buffer_copy(bytes(p));self.last_present=Presentation.from_buffer_copy(bytes(v));self.last_state=H.State.from_buffer_copy(bytes(state))
        if not rc:self.last_render_tick=p.tick
        return rc,state
    def can_draw(self):
        m=self.module.map;c=self.completion();rroot=self.model_root();state=H.State()
        if self.lib.scene_marshal(self.host,C.byref(self.layout),C.byref(self.last_proof),C.byref(self.last_present),C.byref(state)):return False
        if bytes(state)!=bytes(self.last_state):return False
        return bool(self.lib.model_can_draw(C.byref(m),self.r.pointer(m.root.buffer),len(rroot),C.byref(c),C.byref(self.observation)))
    def commands(self):
        assert self.can_draw();c=self.completion();outputs=[self.r.data(r.buffer)[r.offset:r.offset+c.output_bytes[i]] for i,r in enumerate(self.module.map.bindings.output)]
        return struct.pack('<6I',*c.output_bytes,c.bands,c.cars,c.signs)+b''.join(outputs)
