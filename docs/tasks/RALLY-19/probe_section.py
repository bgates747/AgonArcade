"""Native full-band selection/corner readback. Drawing pixels are qualified separately."""
import argparse,json,struct,subprocess
from native_run import execute,sha
from profile import TASK
from build_section_kernel import build
from probe_admission import update,CALL

def queries(track):
    fixed=json.loads((TASK/'fixtures.json').read_text())['cases']+json.loads((TASK/'fixtures-bends.json').read_text())['cases']
    result={(p['player']['position'],p['player']['phase']) for p in fixed if p['track']==track}
    lap=(90 if track=='oval' else 512)*6400
    result|={(pos,phase) for pos in [0,1,1599,1600,6399,6400,lap-1] for phase in [0,1,3999,4000,4001,7999]}
    if track=='fuji':result|={(pos,phase) for pos in [287*6400-1,287*6400,287*6400+1] for phase in [0,3999,4000,7999]}
    return sorted(result)

def reference(track,cases):
    executable=TASK/'.work/section_reference'
    subprocess.run(['g++','-std=c++17','-O2','-Wall','-Wextra','-Werror','-I',str(TASK/'.work/oracle/include'),str(TASK/'section_reference.cpp'),'-o',str(executable)],check=True)
    output=subprocess.check_output([str(executable),track,str(TASK.parent/'RALLY-18/data'/(track+'.road'))],input=''.join(f'{pos} {phase}\n' for pos,phase in cases).encode())
    return [tuple(map(int,line.split())) for line in output.decode().splitlines()]

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--track',choices=['oval','fuji'],default='oval');p.add_argument('--packed',action='store_true');a=p.parse_args()
    builder=build
    if a.packed:
        from build_packed_section import build as builder
    source=builder(a.track,TASK/'.work/section-source');cases=queries(a.track);wanted=reference(a.track,cases)
    data=bytearray(b'G19A'+struct.pack('<H',len(cases)))
    for pos,phase in cases:
        wire=update(struct.pack('<iH',pos,phase))+CALL;data+=struct.pack('<BHH',0,len(wire),0)+wire
    root,raw=execute('golem-section',a.name,source,data)
    assert len(raw)==len(cases)*96 and len(wanted)==len(cases)
    results=[]
    for i,((pos,phase),want) in enumerate(zip(cases,wanted)):
        top,bottom=struct.unpack_from('<2H',raw,i*96+32);cxTop,cxBottom=struct.unpack_from('<2h',raw,i*96+28)
        painted=struct.unpack_from('<H',raw,i*96+56)[0];flags=struct.unpack_from('<5H',raw,i*96+80)
        actual=(top,bottom,cxTop,cxBottom,painted)
        passed=actual[:2]==want[:2] and actual[4]==want[4] and max(abs(actual[j]-want[j]) for j in [2,3])<=1 and flags==(1,1,1,1,1)
        results.append({'position':pos,'phase':phase,'actual':actual,'oracle':want,'flags':flags,'pass':passed})
    report={'pass':all(r['pass'] for r in results),'track':a.track,'packed':a.packed,'scope':__doc__,'reference_sha256':sha(TASK/'section_reference.cpp'),'cases':len(results),'results':results}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n')
    assert report['pass'],[r for r in results if not r['pass']][:8]
    print('Full band native selection/corners pass:',a.track,len(results))
if __name__=='__main__':main()
