"""Compare isolated/shared word conversions across repeats and nested calls."""
import argparse,json,math,struct
from native_run import execute,GOLEM
from profile import TASK
from probe_admission import update,CALL

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');a=p.parse_args()
    signed=[-32768,-32767.75,-1000.5,-1.25,-1,-.75,-.25,0,.25,.75,1,1.25,127.5,32766.75,32767]
    unsigned=[0,.25,.75,1,1.25,255.75,256,32767.5,32768,65533.75,65534]
    values=[(x,y) for x in signed for y in unsigned]
    data=bytearray(b'G19A'+struct.pack('<H',len(values)));want=bytearray()
    for i,(x,y) in enumerate(values):
        wire=update(struct.pack('<2f',x,y))+CALL;data+=struct.pack('<BHH',0,len(wire),0)+wire
        record=bytearray(96);struct.pack_into('<hHhHHH',record,0,math.floor(x),math.floor(y),math.floor(x),math.floor(y),3*(i+1),65535)
        want+=record
    roots=[];outputs=[]
    source=(GOLEM/'examples/native_vehicle_math/shared.golem').read_text()
    for variant in ['isolated','shared']:
        path=TASK/'.work/shared-scratch-source'/a.name/variant;path.mkdir(parents=True,exist_ok=False)
        kernel=path/'kernel.golem';kernel.write_text(source if variant=='shared' else source.replace('SharedWordScratch();\n','',1))
        root,raw=execute('golem-shared-scratch',a.name+'-'+variant,kernel,data,timeout=240)
        results=[{'index':i,'input':[x,y],'pass':raw[96*i:96*(i+1)]==want[96*i:96*(i+1)],
                  'actual_hex':raw[96*i:96*(i+1)].hex(),'expected_hex':want[96*i:96*(i+1)].hex()} for i,(x,y) in enumerate(values)]
        report={'scope':__doc__,'variant':variant,'cases':len(values),'bytes':len(raw),
                'pass':raw==want,'results':results}
        (root/'results.json').write_text(json.dumps(report,indent=2)+'\n');roots.append(str(root));outputs.append(raw)
        assert report['pass'],[r for r in results if not r['pass']][:3]
    assert outputs[0]==outputs[1]
    print('Isolated/shared nested word stores agree with all',len(values),'oracle records in each run:',roots)

if __name__=='__main__':main()
