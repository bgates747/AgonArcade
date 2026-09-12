"""Stock native scalar truncation/half-away rounding with signed boundary values."""
import argparse,struct,math,json
from native_run import execute
from profile import TASK
from probe_admission import update,CALL

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');a=p.parse_args()
    source=TASK/'.work/rounding.golem'
    source.write_text('''Buffer input(1000,80); Field x(input,0,f32,-8388607,8388607);
Buffer output(1001,80); Field truncated(output,0,f32,-8388607,8388607); Field rounded(output,4,f32,-8388607,8388607);
Buffer status(1002,10); Buffer expected(1003,2); Matrix unused(1102,1,1);
Matrix source(1100,1,1); Matrix t(1101,1,1); Matrix r(1103,1,1);
Field tv(t,0,f32); Field rv(r,0,f32);
Program compute(2000) { MatLoad(source,x); MatTrunc(t,source); MatRoundAway(r,source); Copy(truncated,tv,4); Copy(rounded,rv,4); };
''')
    values=[0.,-0.,1e-30,-1e-30]
    for n in [0,1,2,153,32767,65535,1048575,2097151,4194303,8388606]:
        for v in [float(n),n+.5]:
            bits=struct.unpack('<I',struct.pack('<f',v))[0]
            for b in [bits-1,bits,bits+1] if bits else [bits,bits+1]:
                x=struct.unpack('<f',struct.pack('<I',b))[0]
                if x<=8388607:values.extend([x,-x])
    data=bytearray(b'G19A'+struct.pack('<H',len(values)))
    for x in values:
        wire=update(struct.pack('<f',x))+CALL;data+=struct.pack('<BHH',0,len(wire),0)+wire
    root,raw=execute('golem-rounding',a.name,source,data);assert len(raw)==len(values)*96
    results=[]
    for i,x in enumerate(values):
        actual=struct.unpack_from('<2f',raw,i*96);want=(math.trunc(x),math.copysign(math.floor(abs(x)+.5),x))
        results.append({'input':x,'actual':actual,'expected':want,'pass':actual==want and (math.copysign(1,actual[0])==math.copysign(1,x)) and (math.copysign(1,actual[1])==math.copysign(1,x))})
    report={'pass':all(r['pass'] for r in results),'scope':__doc__,'cases':len(results),'results':results}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n');assert report['pass'],[r for r in results if not r['pass']][:8]
    print('Native signed scalar quantization pass:',len(values))
if __name__=='__main__':main()
