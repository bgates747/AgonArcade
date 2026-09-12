"""Native stock positive32 division/conversion, scalar abs and full-width order.

Full96-byte readback also verifies sentinel neighbours and untouched storage.
Diagnostic values include signed endpoints and genuine0xffff low words; no
rendering or R19-08 completion is claimed by this primitive qualification.
"""
import argparse,itertools,json,math,struct
from native_run import execute,GOLEM
from probe_admission import update,CALL,put

def signed16(x):return (x+32768)%65536-32768
def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('name')
    parser.add_argument('--offset',type=int,default=0);parser.add_argument('--limit',type=int,default=288);args=parser.parse_args()
    assert args.offset>=0 and 0<args.limit<=512
    integers=[-2147483648,-2147483647,-16777215,-65536,-65535,-32768,-256,-255,-1,
              0,1,127,128,255,256,32767,32768,65534,65535,65536,65537,16777215,2147483646,2147483647]
    positions=sorted({n+d for n in [0,576000,1152000,3276800,6553599] for d in [-2,-1,0,1,2] if 0<=n+d<=6553599})
    absolute=[0,0x80000000,1,0x80000001]
    positive=[]
    for n in [0,1,32768,65535,576000,3276800,6553599,8388607,16777215]:
        bits=struct.unpack('<I',struct.pack('<f',n))[0]
        for b in [bits-1,bits,bits+1]:
            if b<0:continue
            value=struct.unpack('<f',struct.pack('<I',b))[0]
            if 0<=value<=16777215:
                positive.append(b);absolute.extend([b,b|0x80000000])
    cases=[];wire_records=[]
    for i,(a,b) in enumerate(itertools.product(integers,repeat=2)):
        x=positions[i%len(positions)];absBits=absolute[i%len(absolute)];positiveBits=positive[i%len(positive)]
        source=bytearray(80)
        for offset,width,value in [(0,4,x),(4,4,a),(8,4,b),(12,4,absBits),(16,4,positiveBits),
                                    (20,2,a),(22,2,b),(24,2,a),(26,2,b),(28,1,a),(29,1,b),
                                    (30,2,a),(32,2,b),(34,4,a),(38,4,b)]:put(source,offset,width,value)
        result=bytearray(96);qf,rf=divmod(x,3276800);qo,ro=divmod(x,576000);qh,rh=divmod(rf,100)
        floor=math.floor(struct.unpack('<f',struct.pack('<I',positiveBits))[0])
        for offset,width,value in [(0,2,qf),(2,2,42330),(4,4,rf),(8,2,qo),(10,2,qh),(12,2,rh),
                                    (14,2,int(a<b)),(16,2,int(signed16(a)<signed16(b))),
                                    (18,2,int(a%65536<b%65536)),(20,2,int(a%256<b%256)),
                                    (22,2,int(signed16(a)<signed16(b))),(24,2,int(a<b)),(26,2,21930),
                                    (28,4,absBits&0x7fffffff),(32,4,floor),(36,4,ro),(42,2,65535)]:put(result,offset,width,value)
        wire=update(source)+CALL;assert len(wire)==97
        wire_records.append(struct.pack('<BHH',0,len(wire),0)+wire)
        cases.append({'index':i,'a':a,'b':b,'x':x,'absolute_input_bits':absBits,
                      'positive_input_bits':positiveBits,'expected_hex':result.hex()})
    cases=cases[args.offset:args.offset+args.limit];assert cases
    encoded=b'G19A'+struct.pack('<H',len(cases))+b''.join(wire_records[args.offset:args.offset+args.limit])
    root,actual=execute('golem-vehicle-math',args.name,GOLEM/'examples/native_vehicle_math/kernel.golem',encoded,timeout=300)
    assert len(actual)==len(cases)*96
    for i,case in enumerate(cases):
        value=actual[i*96:(i+1)*96];case['actual_hex']=value.hex();case['pass']=value.hex()==case['expected_hex']
    report={'scope':__doc__,'cases':len(cases),'pass':all(c['pass'] for c in cases),
            'signed_pairs':'Selected slice of Cartesian product of24 signed/byte-boundary operands',
            'offset':args.offset,'total_pairs':len(integers)**2,
            'division_inputs':positions,'results':cases}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n')
    assert report['pass'],[c for c in cases if not c['pass']][:3]
    print('Native vehicle math passes:',len(cases),'full readback records')

if __name__=='__main__':main()
