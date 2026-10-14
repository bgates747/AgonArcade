"""Bounded ctypes SDK services for actual generated C, including persistent storage."""
import ctypes as C
import struct
from adapter import installation
class View(C.Structure):_fields_=[('struct_bytes',C.c_uint32),('lease',C.c_uint32),('data',C.POINTER(C.c_uint8)),('bytes',C.c_uint32),('access',C.c_uint32)]
Acquire=C.CFUNCTYPE(C.c_int32,C.c_void_p,C.c_uint16,C.c_uint16,C.c_uint32,C.c_uint32,C.POINTER(View))
Release=C.CFUNCTYPE(C.c_int32,C.c_void_p,C.c_uint32)
class Host(C.Structure):_fields_=[('struct_bytes',C.c_uint32),('major',C.c_uint16),('minor',C.c_uint16),('caps',C.c_uint32),('context',C.c_void_p),('acquire',Acquire),('release',Release),('fb',C.c_void_p),('row',C.c_void_p),('end',C.c_void_p)]
class Request(C.Structure):_fields_=[('struct_bytes',C.c_uint32),('operation',C.c_uint16),('entry_id',C.c_uint16),('argument_buffer',C.c_uint16),('reserved',C.c_uint16),('argument_bytes',C.c_uint32)]
class Runtime:
    def __init__(self,spec,library):
        self.spec=spec;self.lib=C.CDLL(str(library));self.lib.vdplet_entry.argtypes=[C.POINTER(Host),C.POINTER(Request)];self.lib.vdplet_entry.restype=C.c_int32
        self.buffers={};self.sizes={};self.permissions={};self.live={};self.next=0;self.peak=0;self.calls=0;self.fault=None;self.acquires=0;self.grants=0;self.releases=0
        for id,data in spec.images.items():self.install(id,data)
        self.root_id=spec.interface['state_buffer'];self.argument_id=spec.backends['native_arguments']
        self.install(self.argument_id,struct.pack('<H',self.root_id),1)
        for a in spec.arrays.values():self.permissions[a['buffer']]=a['access']
        for id,d in spec.bindings.items():self.install(id,b'\x00'*d['installed_min_bytes'],d['access'])
        self.acquire_cb=Acquire(self.acquire);self.release_cb=Release(self.release)
        self.host=Host(C.sizeof(Host),1,0,1,None,self.acquire_cb,self.release_cb,None,None,None)
        assert self.invoke(operation=1)==0
    def install(self,id,data,permission=3):
        assert not self.live
        allocation=(C.c_uint8*(len(data)+32))();C.memset(allocation,0xcc,len(allocation));C.memmove(C.addressof(allocation)+16,data,len(data))
        self.buffers[id]=allocation;self.sizes[id]=len(data);self.permissions[id]=permission
    def pointer(self,id):return C.addressof(self.buffers[id])+16
    def data(self,id):return C.string_at(self.pointer(id),self.sizes[id])
    def store(self,id,offset,data):
        assert not self.live and 0<=offset<=self.sizes[id]-len(data);C.memmove(self.pointer(id)+offset,data,len(data))
    def put(self,name,value):
        p=bytearray(self.data(self.root_id));self.spec.put(p,name,value);self.store(self.root_id,0,bytes(p))
    def snapshot(self):return bytearray(self.data(self.root_id)),{a['buffer']:bytearray(self.data(a['buffer'])) for a in self.spec.arrays.values()}
    def acquire(self,context,id,access,offset,n,out):
        self.acquires+=1
        if id not in self.buffers:return 2
        if access not in (1,2) or access&~self.permissions[id]:return 1
        size=self.sizes[id]
        if self.fault and id==self.fault[0]:
            mode=self.fault[1]
            if mode=='missing':return 2
            if mode=='busy':return 7
            if mode=='short':size-=1
            if mode=='long':size+=1
        if offset>size:return 3
        if n==0xffffffff:n=size-offset
        if n>size-offset:return 3
        if len(self.live)>=3:return 13
        p=self.pointer(id)+offset
        if any(p<other+length and other<p+n and ((access|mode)&2) for other,length,mode in self.live.values()):return 7
        self.next+=1;self.grants+=1;self.live[self.next]=(p,n,access);self.peak=max(self.peak,len(self.live))
        out.contents.lease=self.next;out.contents.data=C.cast(p,C.POINTER(C.c_uint8));out.contents.bytes=n;out.contents.access=access;return 0
    def release(self,context,lease):
        self.releases+=1
        if lease not in self.live:return 8
        del self.live[lease];return 0
    def invoke(self,name=None,operation=2,entry=None,argument_bytes=2):
        assert not self.live
        if entry is None:entry=self.spec.entries[name] if name is not None else 0
        if operation==2:self.store(self.root_id,28,struct.pack('<H',entry)) # named wrapper effect
        r=Request(C.sizeof(Request),operation,entry,self.argument_id,0,argument_bytes)
        rc=self.lib.vdplet_entry(C.byref(self.host),C.byref(r));assert not self.live,('leaked leases',self.live)
        self.calls+=1;self.canaries();return rc
    def canaries(self):
        for id,buffer in self.buffers.items():
            data=bytes(buffer);assert data[:16]==data[-16:]==b'\xcc'*16,('canary',id)
    def cleanup(self,kind):
        data=(self.spec.directory/(kind+'-cleanup.bin')).read_bytes();assert installation(data)=={}
        for at in range(0,len(data),6):
            id=struct.unpack_from('<H',data,at+3)[0]
            self.buffers.pop(id,None);self.sizes.pop(id,None);self.permissions.pop(id,None)
        # Reinstall only private native argument; root/arrays remain untouched.
        self.install(self.argument_id,struct.pack('<H',self.root_id),1)
