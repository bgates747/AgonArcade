"""Separate counted diagnostic of the finite256-call group used for timing.

The per-invocation counter is present only here, not in the timing construction.
"""
import argparse,json,struct
from profile import TASK
from build_section_kernel import build
from native_run import execute
from probe_admission import update
from probe_section import reference

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--track',choices=['oval','fuji'],default='oval');a=p.parse_args()
    source=build(a.track,TASK/'.work/section-repeat-source'/a.name)
    s=source.read_text().replace('Program section(2000) {','Program section(2000) {\n    AddU16(invocations,1);')
    source.write_text(s+'\nField invocations(output,58,u16);\nProgram benchmark(2100) { Repeat(256) { Call(section); }; };\n')
    lap=(90 if a.track=='oval' else 512)*6400
    cases=[(0,0),(6399,3999),(6400,4000),(lap-1,7999)];wanted=reference(a.track,cases)
    data=bytearray(b'G19A'+struct.pack('<H',len(cases)))
    for pos,phase in cases:
        wire=update(struct.pack('<iH',pos,phase))+bytes([23,0,160,52,8,1]);data+=struct.pack('<BHH',0,len(wire),0)+wire
    root,raw=execute('golem-section-repeat',a.name,source,data);assert len(raw)==96*len(cases)
    results=[]
    for i,(case,want) in enumerate(zip(cases,wanted)):
        centre=struct.unpack_from('<2h',raw,i*96+28);rows=struct.unpack_from('<2H',raw,i*96+32)
        paint,count=struct.unpack_from('<2H',raw,i*96+56)
        actual=(*rows,*centre,paint)
        results.append({'pose':case,'oracle':want,'actual':actual,'invocations':count,'pass':count==256*(i+1) and actual==want})
    report={'scope':__doc__,'pass':all(r['pass'] for r in results),'results':results}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n');assert report['pass'],results
    print('Counted section groups pass:',a.track,'1024 invocations, four poses')
if __name__=='__main__':main()
