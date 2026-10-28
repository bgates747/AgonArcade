"""Small phase-owned MOS tape/wire encoder; no historical builder dependency.

The protocol and bytes match the existing native-demo encoder. Keeping these
definitions local makes phase tools independent of other working source trees.
"""
import struct

word=lambda n:struct.pack('<H',n)
command=lambda key,op:b'\x17\0\xa0'+word(key)+bytes([op])
update=lambda key,offset,data:command(key,5)+b'\xc2'+word(offset)+word(len(data))+data
call=lambda key:command(key,1)


def write(key,data):
    out=bytearray(command(key,2))
    for start in range(0,len(data),60000):
        part=data[start:start+60000];out+=command(key,0)+word(len(part))+part
    if len(data)>60000:out+=command(key,14)
    return bytes(out)


class Tape:
    def __init__(self):
        self.data=bytearray();self.token=0;self.checks=[]
        self.multiplier=1;self.marks=0;self.in_loop=False
    def send(self,data):
        for start in range(0,len(data),60000):
            part=data[start:start+60000];self.data+=b'\1'+word(len(part))+part
    def patch(self,data,offset):
        self.data+=bytes([4])+word(offset)+word(len(data))+data
    def tx(self,op,fields,kind,value,label,handle=False,capture=False,flags=0):
        self.token+=1
        body=struct.pack('<BBHBB',1,op,self.token,1,0)+fields
        wire=b'\x17\0\xd8'+word(len(body))+body
        flags|=1 if capture else 2 if value is None else 0
        self.data+=b'\2'+struct.pack('<HBBHHH',self.token,kind,flags,value or 0,11 if handle else 65535,len(wire))+wire
        self.checks.append(dict(token=self.token,kind=kind,value=value,label=label,
                               flags=flags,repeats=self.multiplier,loop=self.in_loop))
    def read(self,key,offset,value,label,flags=0):
        self.tx(5,struct.pack('<HI',key,offset),4,value,label,flags=flags)
    def mark(self):self.data+=b'\5';self.marks+=self.multiplier
    def external(self,name,data,out):
        (out/name).write_bytes(data)
        self.data+=b'\6'+len(data).to_bytes(3,'little')+name.encode()+b'\0'
    def repeat(self,n):
        self.data+=b'\11'+word(n);self.multiplier=n;self.in_loop=True
    def endrepeat(self):self.data+=b'\12';self.multiplier=1;self.in_loop=False
