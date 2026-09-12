"""Build a separate UART-suppressed CPU diagnostic from the qualified frontend.

The real frontend and compiled VDP programs remain unchanged. Not a timing result.
"""
import argparse,json,shutil,subprocess
from pathlib import Path
from profile import TASK
from native_run import sha

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');a=p.parse_args()
    qualification=json.loads((TASK/'evidence/golem-frontend/qualification.json').read_text())
    assert qualification['pass'];original=qualification['build'];base=Path(original['work'])
    for path,digest in {**original['source_hashes'],**original['outputs']}.items():assert sha(Path(path))==digest,path
    work=TASK/'.work/cpu-work'/a.name;(work/'src').mkdir(parents=True,exist_ok=False)
    shutil.copytree(base/'include',work/'include');shutil.copy2(TASK/'cpu_work.hpp',work/'include/cpu_work.hpp')
    source=(TASK/'frontend.cpp').read_text()
    old='int taskDiagnostic(){';assert source.count(old)==1
    source=source.replace(old,'#include "cpu_work.hpp"\nint taskDiagnostic(){\n    if(computeOnly)return r19CpuBenchmark();')
    old='perspective || measure || computeOnly || displayTiming || snapshot ||';assert source.count(old)==1
    source=source.replace(old,'perspective || displayTiming || snapshot ||')
    # This binary is for the finite CPU diagnostic only. Reject ordinary play or
    # the old general measurement modes rather than accidentally shipping a sink.
    old='    const bool detailTiming=profiling && !lightTiming;';assert source.count(old)==1
    source=source.replace(old,'    if(!measure || !computeOnly)return 59;\n'+old)
    (work/'src/main.cpp').write_text(source)
    (work/'Makefile').write_text((base/'Makefile').read_text()+'\nLINKERLIBFLAGS += --wrap=_mos_puts\n')
    for track in ['oval','fuji']:
        for ext in ['.vdp','.clr','.road']:shutil.copy2(base/(track+ext),work/(track+ext))
    before={str(p):sha(p) for p in [Path(__file__),TASK/'cpu_work.hpp',TASK/'frontend.cpp',work/'src/main.cpp']}
    with (work/'build.txt').open('w') as log:subprocess.run(['make','-C',str(work)],check=True,stdout=log,stderr=subprocess.STDOUT)
    assert before=={str(p):sha(Path(p)) for p in before}
    mapping=(work/'bin/rally.map').read_text()
    for name in ['__wrap__mos_puts','_mos_puts','_r19WorkBegin','_r19WorkEnd']:assert name in mapping,name
    outputs=[work/'bin/rally.bin',work/'bin/rally.map',*[work/(t+e) for t in ['oval','fuji'] for e in ['.vdp','.clr','.road']]]
    report={'scope':__doc__,'source_hashes':before,'outputs':{str(p):sha(p) for p in outputs},
            'qualified_frontend':original,'work':str(work),'remaining':'Native byte-accounting and wrapper qualification; then scoped debugger cycle measurement.'}
    (work/'manifest.json').write_text(json.dumps(report,indent=2)+'\n');print(work)

if __name__=='__main__':main()
