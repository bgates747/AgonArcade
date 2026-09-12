"""Native immutable scalar literal pooling, signed zeros and nested conversions."""
import argparse,json,math,struct
from native_run import execute,GOLEM
from profile import TASK
from probe_admission import update,CALL
from probe_floor import cases

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');a=p.parse_args()
    signed=[struct.unpack('<f',struct.pack('<I',b))[0] for b in cases()]
    signed=[x for x in signed if abs(x)<=8388607]
    positive=[0,.25,.75,1.25,255.75,256,65535.5,65536,8388607.5,8388608,16777214,16777215]
    values=[(x,positive[i%len(positive)]) for i,x in enumerate(signed)]
    assert len(values)<=512
    data=bytearray(b'G19A'+struct.pack('<H',len(values)));wanted=[]
    for i,(x,y) in enumerate(values):
        wire=update(struct.pack('<2f',x,y))+CALL;data+=struct.pack('<BHH',0,len(wire),0)+wire
        floor=x if x==0 else float(math.floor(x))
        trunc=math.copysign(float(math.trunc(x)),x)
        rounded=math.copysign(float(math.floor(abs(x)+.5)),x)
        record=bytearray(96)
        struct.pack_into('<3fiHhHHf',record,0,floor,trunc,rounded,math.floor(y),511,-128,3*(i+1),65535,x)
        struct.pack_into('<4f',record,28,0.0,-0.0,1.5,1.5)
        wanted.append(bytes(record))
    source=(GOLEM/'examples/native_quantization/shared_literals.golem').read_text()
    outputs=[]
    for variant,directive in [('isolated',''),('word','SharedWordScratch();\n'),('scalar','SharedScalarScratch();\n')]:
        path=TASK/'.work/shared-literal-source'/a.name/variant;path.mkdir(parents=True,exist_ok=False)
        kernel=path/'kernel.golem';kernel.write_text(source.replace('SharedScalarScratch();\n',directive,1))
        root,raw=execute('golem-shared-literals',a.name+'-'+variant,kernel,data,timeout=240)
        results=[{'index':i,'input':[x,y],'pass':raw[96*i:96*(i+1)]==want,
                  'actual_hex':raw[96*i:96*(i+1)].hex(),'expected_hex':want.hex()}
                 for i,((x,y),want) in enumerate(zip(values,wanted))]
        report={'scope':__doc__,'variant':variant,'cases':len(values),'bytes':len(raw),
                'pass':raw==b''.join(wanted),'results':results}
        (root/'results.json').write_text(json.dumps(report,indent=2)+'\n')
        assert report['pass'],[r for r in results if not r['pass']][:3]
        outputs.append(raw)
    assert outputs[0]==outputs[1]==outputs[2]
    print('Isolated/word/scalar conversions match:',len(values),'complete records each')

if __name__=='__main__':main()
