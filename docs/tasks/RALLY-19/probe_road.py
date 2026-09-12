"""Native complete road merge, material parity and projected endpoint readback."""
import argparse,json,struct,subprocess
from native_run import execute,GOLEM,sha
from profile import TASK
from build_road_kernel import build
from probe_admission import update,CALL
from probe_section import queries
from road_bounds import proof

def reference(track,cases):
    executable=TASK/'.work/road_reference'
    subprocess.run(['g++','-std=c++17','-O2','-Wall','-Wextra','-Werror','-I',str(TASK/'.work/oracle/include'),str(TASK/'road_reference.cpp'),'-o',str(executable)],check=True)
    lines=subprocess.check_output([str(executable),track,str(TASK.parent/'RALLY-18/data'/(track+'.road'))],input=''.join(f'{pos} {phase}\n' for pos,phase in cases).encode()).decode().splitlines()
    result=[]
    for line in lines:
        values=list(map(int,line.split()));count=values[0];assert len(values)==1+(count+1)*4
        result.append([tuple(values[1+4*i:5+4*i]) for i in range(count+1)])
    return result

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--track',choices=['oval','fuji'],default='oval');a=p.parse_args()
    source=build(a.track,TASK/'.work/road-source'/a.name)
    witness=proof()['tracks'][a.track]['witness']
    cases=sorted(set(queries(a.track))|{(witness['position'],witness['phase']),(witness['position'],witness['phase']+4000)})
    wanted=reference(a.track,cases)
    loader=TASK/'.work/road-probe-loader'/a.name;loader.mkdir(parents=True,exist_ok=False)
    text=(GOLEM/'examples/native_admission/main.cpp').read_text();old='!collect(output, 1102, 4))';assert text.count(old)==1
    (loader/'main.cpp').write_text(text.replace(old,'!collect(output, 1102, 4) || !collect(output, 1600, 198))'))
    (loader/'Makefile').write_text((GOLEM/'examples/native_admission/Makefile').read_text())
    data=bytearray(b'G19A'+struct.pack('<H',len(cases)))
    for pos,phase in cases:
        wire=update(struct.pack('<iH',pos,phase))+CALL;data+=struct.pack('<BHH',0,len(wire),0)+wire
    root,raw=execute('golem-road',a.name,source,data,loader=loader,timeout=240)
    assert len(raw)==len(cases)*294 and len(wanted)==len(cases)
    results=[]
    for i,(case,want) in enumerate(zip(cases,wanted)):
        count,active=struct.unpack_from('<2H',raw,i*294+60);flags=struct.unpack_from('<5H',raw,i*294+80)
        entries=[struct.unpack_from('<HhH',raw,i*294+96+6*j) for j in range(min(count,32)+1)]
        rows=count==len(want)-1 and [r[0] for r in entries]==[r[0] for r in want]
        paint=rows and [r[2] for r in entries[:-1]]==[r[2] for r in want[:-1]]
        error=max(abs(x[1]-y[1]) for x,y in zip(entries,want)) if rows else None
        passed=rows and paint and error<=1 and active==0 and flags==(1,1,1,1,1)
        results.append({'pose':case,'band_count':count,'active':active,'flags':flags,'actual':entries,'oracle':want,'rows_pass':rows,'materials_pass':paint,'max_rounded_centre_error':error,'pass':passed})
    report={'scope':__doc__,'track':a.track,'cases':len(cases),'reference_sha256':sha(TASK/'road_reference.cpp'),'pass':all(r['pass'] for r in results),'results':results}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n');assert report['pass'],[r for r in results if not r['pass']][:2]
    print('Full road native merge/projection pass:',a.track,len(cases),'cases;',sum(r['band_count'] for r in results),'bands')
if __name__=='__main__':main()
