"""Rally host-only adapter/stub for accepted R25-G0/root-v1.

Interface objects are a normalized internal representation, NOT a proposed
Golem manifest format. A delivered manifest parser awaits Golem's schema.
No production entry/buffer IDs are assigned here. No transport is implemented.
"""
from dataclasses import dataclass
import struct

NAMES=('InitRace','Tick120','Render30','ResetRace','StopRace')
HEADER=112
class Rejected(ValueError):pass
class RuntimeRejected(Rejected):pass

def read(root,offset,fmt='H'):return struct.unpack_from('<'+fmt,root,offset)[0]
def write(root,offset,value,fmt='H'):struct.pack_into('<'+fmt,root,offset,value)

@dataclass(frozen=True)
class Binding:
    role:int
    buffer:int=0
    offset:int=0
    length:int=0
    access:int=0
    def encoded(self):
        if self.role not in range(1,5):raise Rejected('descriptor role')
        if self.buffer==0:
            if self.offset or self.length or self.access:raise Rejected('unbound descriptor')
        elif not (0<self.buffer<=65535 and 0<=self.offset<=4294967295 and 0<self.length<=4294967295
                  and self.offset+self.length<=4294967295 and self.access==(3 if self.role==2 else 1)):
            raise Rejected('bound descriptor shape/access')
        return struct.pack('<HHIIHH',self.role,self.buffer,self.offset,self.length,self.access,0)

@dataclass(frozen=True)
class Interface:
    root_bytes:int
    entries:dict
    bindings:tuple
    def validate(self):
        if not HEADER<=self.root_bytes<=65535:raise Rejected('root bytes')
        if not set(NAMES)<=set(self.entries) or len(self.entries)>65535:raise Rejected('logical entries')
        if len(set(self.entries.values()))!=len(self.entries) or any(not 0<=v<65535 for v in self.entries.values()):raise Rejected('entry IDs')
        if tuple(b.role for b in self.bindings)!=(1,2,3,4):raise Rejected('descriptor order')
        for b in self.bindings:b.encoded()
    def initial(self,session):
        self.validate()
        if not 0<session<=4294967295:raise Rejected('session')
        root=bytearray(self.root_bytes)
        for off,value,fmt in [(0,0x4752,'H'),(2,1,'H'),(4,112,'H'),(6,self.root_bytes,'H'),(8,session,'I'),
                              (24,65535,'H'),(26,4,'H'),(36,len(self.entries),'H'),(38,self.root_bytes-112,'H'),(44,0x52323530,'I')]:
            write(root,off,value,fmt)
        for i,b in enumerate(self.bindings):root[48+i*16:64+i*16]=b.encoded()
        return root

def metadata_status(root,interface):
    """Declared admission only. Does not inspect live target buffers."""
    interface.validate()
    if len(root)<HEADER:raise RuntimeRejected('physically short root; no safe diagnostics')
    if read(root,0)!=0x4752:return 1
    if read(root,2)!=1:return 2
    if (read(root,4)!=112 or read(root,6)!=interface.root_bytes or read(root,26)!=4
            or read(root,36)!=len(interface.entries) or read(root,38)!=interface.root_bytes-112):return 3
    if read(root,8,'I')==0:return 4
    if any(root[48+i*16:64+i*16]!=b.encoded() for i,b in enumerate(interface.bindings)):return 5
    if read(root,30) or read(root,40,'I') or read(root,44,'I')!=0x52323530:return 6
    if read(root,28) not in interface.entries.values():return 7
    return 0

def stub_invoke(root,interface,name,source,actual_lengths=None):
    """HOST STUB ONLY: emulate envelope, call supplied fake scalar source.

    actual_lengths=None models declared-only stock admission. A dict models
    native range admission, not real buffer leases or target concurrency.
    Runtime errors raise without synthesizing SDK numeric return codes.
    Source returns its language status and can have earlier effects on failure.
    """
    if name not in interface.entries:raise RuntimeRejected('unknown SDK entry; root untouched')
    if len(root)!=interface.root_bytes:raise RuntimeRejected('actual root length; root untouched')
    write(root,28,interface.entries[name])
    status=metadata_status(root,interface)
    if not status and actual_lengths is not None:
        for b in interface.bindings:
            if b.buffer and (b.buffer not in actual_lengths or b.offset+b.length>actual_lengths[b.buffer]):status=8;break
    write(root,12,status)
    if status:return
    write(root,14,0)
    language_status=source(root)
    write(root,14,language_status)
    if not language_status:
        write(root,20,(read(root,20,'I')+1)&4294967295,'I')
        write(root,24,interface.entries[name]);write(root,32,read(root,8,'I'),'I')

def require_success(root,interface,name,session,prior_generation,runtime_result):
    """Transport owner supplies observed result, or None if unavailable.

    Never infer transport completion from an old root runtime_result value.
    Buffered callers without an SDK result must explicitly use their separately
    observed completion policy; None is not converted to success here.
    """
    if runtime_result is None:raise RuntimeRejected('completion result unavailable')
    if runtime_result!=0:raise RuntimeRejected('runtime/transport failed')
    if name not in interface.entries or len(root)!=interface.root_bytes:raise Rejected('interface/length')
    if metadata_status(root,interface):raise Rejected('metadata')
    if read(root,12) or read(root,14):raise Rejected('interface/language failure')
    if (read(root,8,'I')!=session or read(root,32,'I')!=session
            or read(root,24)!=interface.entries[name] or read(root,28)!=interface.entries[name]
            or read(root,20,'I')!=(prior_generation+1)&4294967295):raise Rejected('stale/wrong success marker')
    return read(root,20,'I')
