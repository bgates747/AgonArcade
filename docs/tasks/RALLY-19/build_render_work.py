"""Build an unwrapped, real-UART benchmark from the qualified Golem frontend.

Only diagnostics and their entry guard change. Real game and bootstrap bytes stay intact.
"""
import argparse,json,shutil,subprocess
from pathlib import Path
from profile import TASK
from native_run import sha
from frontend_bridge import verify

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--frontend',required=True)
    p.add_argument('--inline-qualified',action='store_true');a=p.parse_args()
    base=TASK/'.work/frontend'/a.frontend;qualified,selected,bridge=verify(base,allow_inline=a.inline_qualified)
    work=TASK/'.work/render-work'/a.name;(work/'src').mkdir(parents=True,exist_ok=False)
    shutil.copytree(base/'include',work/'include');shutil.copy2(base/'Makefile',work/'Makefile')
    for name in ['render_work.hpp','render_readback.hpp']:shutil.copy2(TASK/name,work/'include'/name)
    source=(TASK/'frontend.cpp').read_text()
    replacements=[('int taskDiagnostic(){','#include "render_work.hpp"\nint taskDiagnostic(){\n    if(measure)return r19RenderBenchmark();'),
                  ('perspective || measure || computeOnly || displayTiming || snapshot ||','perspective || computeOnly || displayTiming || snapshot ||'),
                  ('    const bool detailTiming=profiling && !lightTiming;','    if(!measure)return 84;\n    const bool detailTiming=profiling && !lightTiming;'),
                  ('int gameMain(int argc, char **argv) {','int gameMain(int argc, char **argv) {\n    r19ApplicationStart=rawClock();')]
    for old,new in replacements:assert source.count(old)==1;source=source.replace(old,new)
    (work/'src/main.cpp').write_text(source)
    for track in ['oval','fuji']:
        for ext in ['.vdp','.clr','.road']:shutil.copy2(base/(track+ext),work/(track+ext))
    before={str(p):sha(p) for p in [Path(__file__),TASK/'frontend_bridge.py',TASK/'frontend.cpp',TASK/'render_work.hpp',TASK/'render_readback.hpp',work/'src/main.cpp',*sorted((work/'include').glob('*.hpp'))]}
    with (work/'build.txt').open('w') as log:subprocess.run(['make','-C',str(work)],check=True,stdout=log,stderr=subprocess.STDOUT)
    assert before=={str(p):sha(Path(p)) for p in before}
    mapping=(work/'bin/rally.map').read_text();assert '__wrap__' not in mapping and '_r19BatchBegin' in mapping and '_r19BatchEnd' in mapping
    outputs=[work/'bin/rally.bin',work/'bin/rally.map',*[work/(t+e) for t in ['oval','fuji'] for e in ['.vdp','.clr','.road']]]
    report={'scope':__doc__,'source_hashes':before,'outputs':{str(p):sha(p) for p in outputs},
            'qualified_frontend':qualified['build'],'selected_frontend':selected,'bridge':bridge,'work':str(work),'remaining':'Native bridge/acceptance and real-rendering ABBA; no performance pass yet.'}
    (work/'manifest.json').write_text(json.dumps(report,indent=2)+'\n');print(work)

if __name__=='__main__':main()
