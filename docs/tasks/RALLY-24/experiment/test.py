#!/usr/bin/env python3
"""Local mock-host validation and independent current-game stream comparisons."""
import ctypes as C
import os
import json
import hashlib
import time
import random
import statistics
import struct
import subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[3]
WORK=HERE/'.work'
MODULES=Path(os.environ.get('R24_MODULE_DIR',WORK))
def u16(b,o=0): return struct.unpack_from('<H',b,o)[0]
def u32(b,o=0): return struct.unpack_from('<I',b,o)[0]
class View(C.Structure):
    _fields_=[('struct_bytes',C.c_uint32),('lease',C.c_uint32),('data',C.POINTER(C.c_uint8)),('bytes',C.c_uint32),('access',C.c_uint32)]
Acquire=C.CFUNCTYPE(C.c_int32,C.c_void_p,C.c_uint16,C.c_uint16,C.c_uint32,C.c_uint32,C.POINTER(View))
Release=C.CFUNCTYPE(C.c_int32,C.c_void_p,C.c_uint32)
class Host(C.Structure):
    _fields_=[('struct_bytes',C.c_uint32),('major',C.c_uint16),('minor',C.c_uint16),('caps',C.c_uint32),('context',C.c_void_p),('acquire',Acquire),('release',Release),('fb',C.c_void_p),('row',C.c_void_p),('end',C.c_void_p)]
class Request(C.Structure):
    _fields_=[('struct_bytes',C.c_uint32),('op',C.c_uint16),('entry',C.c_uint16),('args',C.c_uint16),('reserved',C.c_uint16),('bytes',C.c_uint32)]
class Bench:
    def __init__(self,variant,track):
        self.lib=C.CDLL(str(MODULES/f'module-{variant}.so'));self.entry=self.lib.vdplet_entry
        self.entry.argtypes=[C.POINTER(Host),C.POINTER(Request)];self.entry.restype=C.c_int32
        self.data={};self.live={};self.peak=0;self.next=1;self.fail_id=None;self.fail_access=None
        asset=(WORK/f'{track}.r24').read_bytes()
        config=struct.pack('<4sHHI6HII',b'R24A',1,32,7,*range(31002,31008),u32(asset,12),0)
        for id,b in ((31001,config),(31002,bytes(112)),(31003,asset),(31004,bytes(32)),(31005,bytes(20480)),(31006,bytes(2048)),(31007,bytes(256))):self.set(id,b)
        self.acquire_cb=Acquire(self.acquire);self.release_cb=Release(self.release)
        self.host=Host(C.sizeof(Host),1,0,1,None,self.acquire_cb,self.release_cb,None,None,None)
        assert self.call(0,op=1)==0
        assert self.call(0)==0
    def set(self,id,b):self.data[id]=(C.c_uint8*len(b)).from_buffer_copy(b)
    def acquire(self,ctx,id,access,offset,length,out):
        if id==self.fail_id and (self.fail_access is None or access==self.fail_access):return 2
        if id not in self.data:return 2
        b=self.data[id];length=len(b)-offset if length==0xffffffff else length
        if offset>len(b) or length>len(b)-offset:return 3
        ptr=C.addressof(b)+offset
        for start,n,mode in self.live.values():
            if ptr<start+n and start<ptr+length and (mode==2 or access==2):return 7
        if len(self.live)>=4:return 13
        lease=self.next;self.next+=1;self.live[lease]=(ptr,length,access);self.peak=max(self.peak,len(self.live))
        out.contents.lease=lease;out.contents.data=C.cast(ptr,C.POINTER(C.c_uint8));out.contents.bytes=length;out.contents.access=access
        return 0
    def release(self,ctx,lease):
        if lease not in self.live:return 8
        del self.live[lease];return 0
    def call(self,entry=1,op=2):
        r=Request(C.sizeof(Request),op,entry,31001,0,32)
        code=self.entry(C.byref(self.host),C.byref(r));assert not self.live, self.live
        return code
    def render(self,s):
        self.set(31002,s)
        # The resident wrapper clears this before RUN, including pre-entry errors.
        self.data[31004][0]=0
        return self.call()
    def output(self):
        status=bytes(self.data[31004]);return [bytes(self.data[31005+i])[:u16(status,12+i*2)] for i in range(3)]
def states(lap):
    rng=random.Random(240012);seq=0
    positions={0,1,lap-1,lap-6400,lap-6800,lap-100000}
    for p in range(0,lap,6400):positions.update((p,max(0,p-1),min(lap-1,p+6399)))
    cases=[(p,phase) for p in sorted(positions) for phase in (0,3999,4000,7999)]
    cases += [(rng.randrange(lap),rng.randrange(8000)) for _ in range(500)]
    for pos,phase in cases:
        seq+=1;s=bytearray(112);struct.pack_into('<4sHHIIIiHhiHHHH',s,0,b'R24S',1,112,7,seq,seq*4,pos,phase,seq%43-21,rng.choice((-38400,-23040,-1,0,1,23040,38400)),seq%8,seq%151 if seq%9==0 else 0,seq%121 if seq%7==0 else 0,0)
        for i in range(6):
            if seq%7>i:
                z=rng.choice((6399,6400,6499,110000,110099,110100,7000,10000,20000,50000))
                struct.pack_into('<iihBB',s,40+i*12,(pos+z)%lap,rng.randint(-14260,14260),rng.randint(-1920,1920),1,0)
        yield bytes(s)
def compare(variant,track):
    bench=Bench(variant,track);lap=u32(bytes(bench.data[31003]),20)*100;cases=list(states(lap))
    reference=subprocess.run([str(WORK/'oracle'),str(ROOT/'rally-production'),track,variant],input=b''.join(cases),stdout=subprocess.PIPE,check=True).stdout
    at=0;max_lengths=[0]*3;min_bytes=99999;max_bytes=0;wire_bytes=[]
    for i,s in enumerate(cases):
        lengths=struct.unpack_from('<6I',reference,at);at+=24;expected=[]
        for n in lengths[:3]:expected.append(reference[at:at+n]);at+=n
        assert bench.render(s)==0,(variant,track,i,'module error')
        actual=bench.output()
        for j in range(3):
            if actual[j]!=expected[j]:
                (WORK/'failure-state.bin').write_bytes(s);(WORK/'expected.bin').write_bytes(expected[j]);(WORK/'actual.bin').write_bytes(actual[j])
                diff=next((k for k,(a,b) in enumerate(zip(actual[j],expected[j])) if a!=b),min(len(actual[j]),len(expected[j])))
                raise AssertionError((variant,track,i,j,diff,len(actual[j]),len(expected[j]),actual[j][max(0,diff-8):diff+8].hex(),expected[j][max(0,diff-8):diff+8].hex()))
            max_lengths[j]=max(max_lengths[j],len(actual[j]))
        assert struct.unpack_from('<3H',bytes(bench.data[31004]),18)==lengths[3:]
        assert bench.data[31004][0]==1
        n=sum(lengths[:3]);wire_bytes.append(n-18);min_bytes=min(min_bytes,n);max_bytes=max(max_bytes,n)
    assert at==len(reference)
    return {'variant':variant,'track':track,'poses':len(cases),'max_output_bytes':max_lengths,'peak_leases':bench.peak,'resident_command_bytes_range':[min_bytes,max_bytes], 'current_host_channel_bytes_median':statistics.median(wire_bytes) if variant=='A' else None, 'proposed_channel_bytes':147, 'median_channel_reduction_percent':round(100*(1-147/statistics.median(wire_bytes)),2) if variant=='A' else None}
def negative(variant):
    b=Bench(variant,'fuji');s=next(states(3276800));assert b.render(s)==0
    assert b.render(s)!=0 and b.data[31004][0]==0 # duplicate cannot draw previous frame
    checks=1
    for off,fmt,value in ((0,'I',0),(4,'H',2),(6,'H',111),(8,'I',8),(12,'I',0),(20,'i',-1),(20,'I',3276800),(24,'H',8000),(26,'h',22),(28,'i',38401),(32,'H',8),(34,'H',151),(36,'H',121),(38,'H',1),(44,'i',14261),(48,'h',1921),(50,'B',2),(51,'B',1)):
        assert b.call(0)==0;bad=bytearray(s);struct.pack_into('<'+fmt,bad,off,value)
        assert b.render(bad)!=0 and b.data[31004][0]==0,(off,value);checks+=1
    # Fail each buffer service stage; preserve no live leases, never publish partial output.
    for id in range(31001,31008):
        assert b.call(0)==0;b.fail_id=id;assert b.render(s)!=0 and b.data[31004][0]==0;b.fail_id=None;checks+=1
    # Corrupt output sizes and aliases: reject BIND; failed binding invalidates old session.
    for id in range(31002,31008):
        old=b.data[id];b.set(id,bytes(old)[:-1]);assert b.call(0)!=0;assert b.render(s)!=0;b.data[id]=old;assert b.call(0)==0;checks+=1
    old=b.data[31004];b.data[31004]=b.data[31001];assert b.call(0)!=0;b.data[31004]=old;assert b.call(0)==0;checks+=1
    old=b.data[31003];bad=bytearray(old);bad[-1]^=1;b.set(31003,bad);assert b.call(0)!=0;b.data[31003]=old;assert b.call(0)==0;checks+=1
    assert b.render(s)==0;assert b.call(0,op=3)==0;assert b.render(s)!=0;checks+=1
    return checks
if __name__=='__main__':
    started=time.monotonic()
    pins=json.loads((HERE.parent/'SOURCES.json').read_text())['sha256']
    for name,expected in pins.items():
        assert hashlib.sha256((ROOT/name).read_bytes()).hexdigest()==expected, f'Review changed reference: {name}'
    rows=[]
    for variant in ('A','B'):
        for track in ('fuji','oval'):rows.append(compare(variant,track))
        print(variant,'negative cases:',negative(variant),flush=True)
    result={'scope':'host command parity only; no physical DSP or pixel qualification','rows':rows,'duration_seconds':round(time.monotonic()-started,3),'negative_cases_per_variant':35}
    (WORK/('host-sanitizer-results.json' if os.environ.get('R24_MODULE_DIR') else 'host-results.json')).write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
