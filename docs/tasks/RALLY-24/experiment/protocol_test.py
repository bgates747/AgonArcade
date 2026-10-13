"""Decode resident wrapper bytes independently and exercise native failure gates."""
import struct
from protocol import arguments,frame,wrappers,submit_parts
from test import Bench,u16,u32

def check_list(b):
    at=0
    while at<len(b):
        v=b[at]
        if v==18:at+=3
        elif v==25:at+=6
        elif v==24:at+=9
        elif v==23:
            if b[at+1]==27:
                at+=4 if b[at+2]==0 else 7
            elif b[at+2]==150:at+=6
            else:
                assert b[at+1:at+3]==b'\0\xa0';id=u16(b,at+3);op=b[at+5]
                if op==7:assert id==65535;return at+6
                if op==32:at+=7 if b[at+6]==0 else 20
                elif op==5:assert b[at+6]==194;at+=11+u16(b,at+9)
                elif op==1:assert id in (30008,30009);at+=6
                else:raise AssertionError((at,id,op))
        else:raise AssertionError((at,v))
    raise AssertionError('missing terminator')

def dispatch(b,bench,buffers,called):
    at=0
    while at<len(b):
        assert b[at:at+2]==b'\x17\0'
        if b[at+2]==216:
            n=u16(b,at+3);p=b[at+5:at+5+n];assert len(p)==12
            version,op,token,flags,reserved,handle,entry,args=struct.unpack('<BBHBBHHH',p)
            assert (version,op,token,flags,reserved,entry,args)==(1,2,0,0,0,1,31001)
            if handle==9:bench.call() # Any other handle simulates failure before entry.
            at+=5+n;continue
        assert b[at+2]==160;id=u16(b,at+3);op=b[at+5];at+=6
        if op==5:
            mode=b[at];offset=u16(b,at+1);at+=3
            if mode==2:bench.data[id][offset]=b[at];at+=1
            else:
                assert mode==194;n=u16(b,at);at+=2
                for i in range(n):bench.data[id][offset+i]=b[at+i]
                at+=n
        elif op==1:dispatch(buffers[id],bench,buffers,called)
        elif op==6:
            assert b[at]==34;check=u16(b,at+1);offset=u16(b,at+3)
            operand=u16(b,at+5);operand_offset=u16(b,at+7);at+=9
            # Actual firmware preserves 0xFFFFFF in each int32 operand.
            source=bench.data[check][offset]|0xffffff00
            value=bench.data[operand][operand_offset]|0xffffff00
            if source==value and source!=0xffffffff:
                data=bytes(bench.data[id]);used=check_list(data);called.append((id,used))
        else:raise AssertionError(op)

for variant in ('A','B'):
    bench=Bench(variant,'fuji');assert arguments(7,u32(bytes(bench.data[31003]),12))==bytes(bench.data[31001])
    s=frame(7,1,4,3270000,7999,-21,-38400,7,0,0,[(1000,100,1920),None])
    buffers=wrappers(9);called=[];parts=submit_parts(s);assert sum(map(len,parts))==147
    for part in parts:dispatch(part,bench,buffers,called)
    assert len(called)==3
    for output in bench.output():assert check_list(output+b'poisoned tail')==len(output)
    # Duplicate, invalid runtime handle and failures during each output stage.
    for bad_handle,fail in ((9,None),(99,None),(9,31005),(9,31006),(9,31007)):
        bench.data[31004][0]=1;bench.fail_id=fail;bench.fail_access=2
        called=[];current=s if bad_handle==9 and fail is None else frame(7,2,8,3270000,1,0,0)
        for part in submit_parts(current):dispatch(part,bench,wrappers(bad_handle),called)
        assert not called and bench.data[31004][0]==0
        bench.fail_id=None
    assert bench.call(0)==0
print('ABI serialization: 147 bytes; guarded calls/terminators/partial failures passed for A and B')
