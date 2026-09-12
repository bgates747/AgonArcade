"""Native signed floor at integer neighbours, tiny fractions and byte carries."""
import argparse,json,math,struct
from native_run import GOLEM,execute
from probe_admission import update,CALL

def cases():
    bits={0,1,0x007fffff,0x00800000}
    def raw(x):return struct.unpack('<I',struct.pack('<f',x))[0]
    for n in [0,1,2,127,128,255,256,1023,1024,4095,4096,32767,32768,65535,65536,8388607,8388608,16777214,16777215]:
        k=raw(n)
        for value in [k-1,k,k+1]:
            if 0<=value<=raw(16777215):bits.add(value)
    for n in [0,1,127,255,511,1023,4095]:
        for f in [1,2,15,63,127,255,1023,8191,8192,16383]:bits.add(raw(n+f/16384))
    return sorted(bits|{b|0x80000000 for b in bits})

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');a=p.parse_args()
    values=cases();assert 0<len(values)<=512
    data=bytearray(b'G19A'+struct.pack('<H',len(values)));wanted=[]
    for i,bits in enumerate(values):
        input_bytes=struct.pack('<I',bits);x=struct.unpack('<f',input_bytes)[0]
        floor=x if x==0 else float(math.floor(x));truncated=math.copysign(float(math.trunc(x)),x)
        wire=update(input_bytes)+CALL;data+=struct.pack('<BHH',0,len(wire),0)+wire
        record=bytearray(96);struct.pack_into('<2fIHH',record,0,floor,truncated,bits,65535,i+1);wanted.append(bytes(record))
    root,raw=execute('golem-floor',a.name,GOLEM/'examples/native_quantization/floor.golem',data,timeout=240)
    assert len(raw)==len(values)*96
    results=[{'index':i,'input_bits':f'{bits:08x}','expected_hex':want.hex(),'actual_hex':raw[96*i:96*(i+1)].hex(),
              'pass':raw[96*i:96*(i+1)]==want} for i,(bits,want) in enumerate(zip(values,wanted))]
    report={'scope':__doc__,'cases':len(values),'pass':all(r['pass'] for r in results),'results':results}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n');assert report['pass'],[r for r in results if not r['pass']][:3]
    print('Native signed floor passes:',len(values),'complete records')

if __name__=='__main__':main()
