"""Native byte-offset record lookup, unsigned widening and floor boundary proof."""
import argparse,json,struct,subprocess,math
from native_run import GOLEM,execute
from probe_admission import update,CALL

def f32(value):return struct.unpack('<f',struct.pack('<f',value))[0]
def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');args=p.parse_args()
    subprocess.run([str(GOLEM/'.venv/bin/python'),str(GOLEM/'examples/native_elements/make_kernel.py')],check=True)
    indices=[0,1,21,22,31,32,65535,3]
    positions=[0,6399,6400,6401,3276799,3270400,65535,131071]
    values=[0,.9999,1.0,511.999847,32767.99,32768.99,65533.99,65534]
    poses=list(zip(indices,positions,map(f32,values)));expected=[];data=bytearray(b'G19A'+struct.pack('<H',len(poses)));previous=(0,0,0);product=0
    for index,position,value in poses:
        payload=struct.pack('<HHi f',index,0,position,value)
        wire=update(payload)+CALL;data+=struct.pack('<BHH',0,len(wire),0)+wire
        ok=index<32
        if ok:previous=(index+1,2*index+1,-index-1);product=previous[0]*previous[1]
        output=bytearray(96)
        struct.pack_into('<iiiHHii',output,0,*previous,math.floor(value),position//6400,index,math.floor(value))
        struct.pack_into('<H',output,80,int(ok));struct.pack_into('<f',output,92,float(product))
        expected.append(bytes(output))
    root,raw=execute('golem-elements',args.name,GOLEM/'examples/native_elements/kernel.golem',data)
    assert len(raw)==96*len(poses)
    results=[]
    for i,pose in enumerate(poses):
        actual=raw[96*i:96*(i+1)];want=expected[i]
        results.append({'input':pose,'pass':actual==want,'actual':actual.hex(),'expected':want.hex(),'different_offsets':[j for j in range(96) if actual[j]!=want[j]]})
    (root/'results.json').write_text(json.dumps({'pass':all(r['pass'] for r in results),'cases':results,'scope':__doc__,'notes':'Typed byte offsets cross 255 at records 21/22. Invalid indices retain the old record/product. Native interval floor is compared to exact C-style positive integer division, not a matching float model.'},indent=2)+'\n')
    assert all(r['pass'] for r in results),results
    print('Native element lookup and unsigned floor:',len(results),'cases pass')
if __name__=='__main__':main()
