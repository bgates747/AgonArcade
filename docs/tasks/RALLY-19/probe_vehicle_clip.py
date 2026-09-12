"""Check every visible integer depth and rejection before native reciprocal."""
import argparse,json,struct
from native_run import execute,GOLEM
from probe_admission import update,CALL

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--offset',type=int,default=0)
    p.add_argument('--limit',type=int,default=384);a=p.parse_args()
    all_values=list(range(1102))+[32767,32768,65534,65535,0,64,1100,1101]
    assert a.offset>=0 and 0<a.limit<=512
    values=all_values[a.offset:a.offset+a.limit];assert values
    data=bytearray(b'G19A'+struct.pack('<H',len(values)))
    for depth in values:
        wire=update(struct.pack('<H',depth))+CALL;data+=struct.pack('<BHH',0,len(wire),0)+wire
    root,raw=execute('golem-vehicle-clip',a.name,GOLEM/'examples/native_vehicle_math/clip.golem',data,timeout=240)
    assert len(raw)==len(values)*96
    depth=64;q=125;count=0;results=[]
    for i,value in enumerate(values):
        visible=64<=value<=1100
        if visible:depth=value;q=8000//value;count+=1
        want=bytearray(96);struct.pack_into('<4H',want,0,depth,q,count,65535);struct.pack_into('<H',want,80,int(visible))
        actual=raw[i*96:(i+1)*96]
        results.append({'index':a.offset+i,'input_depth':value,'expected_hex':want.hex(),'actual_hex':actual.hex(),'pass':actual==want})
    report={'scope':__doc__,'offset':a.offset,'total_cases':len(all_values),'cases':len(values),
            'pass':all(r['pass'] for r in results),'results':results}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n');assert report['pass'],[r for r in results if not r['pass']][:3]
    print('Native clipped reciprocal passes:',len(values),'depths')

if __name__=='__main__':main()
