"""Build full-art native lifecycle/malformed-input diagnostic from checked frontend."""
import argparse,json,shutil,subprocess
from pathlib import Path
from profile import TASK
from native_run import sha
from frontend_bridge import verify

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--frontend',required=True)
    p.add_argument('--inline-qualified',action='store_true');a=p.parse_args()
    base=TASK/'.work/frontend'/a.frontend;qualified,parent,bridge=verify(base,allow_inline=a.inline_qualified)
    work=TASK/'.work/lifecycle'/a.name;(work/'src').mkdir(parents=True,exist_ok=False)
    shutil.copytree(base/'include',work/'include');shutil.copy2(base/'Makefile',work/'Makefile')
    for name in ['lifecycle_work.hpp','render_readback.hpp','tagged_readback.hpp']:shutil.copy2(TASK/name,work/'include'/name)
    source=(TASK/'frontend.cpp').read_text()
    replacements=[('int taskDiagnostic(){','#include "lifecycle_work.hpp"\nint taskDiagnostic(){\nif(measure)return r19Lifecycle();'),
        ('perspective || measure || computeOnly || displayTiming || snapshot ||','perspective || computeOnly || displayTiming || snapshot ||'),
        ('    const bool detailTiming=profiling && !lightTiming;','    if(!measure||oracleRenderer)return 148;\n    const bool detailTiming=profiling && !lightTiming;')]
    for old,new in replacements:assert source.count(old)==1;source=source.replace(old,new)
    (work/'src/main.cpp').write_text(source)
    for t in ['oval','fuji']:
        for ext in ['.vdp','.clr','.road']:shutil.copy2(base/(t+ext),work/(t+ext))
    with (work/'build.txt').open('w') as log:subprocess.run(['make','-C',str(work)],check=True,stdout=log,stderr=subprocess.STDOUT)
    files=[Path(__file__),TASK/'frontend_bridge.py',TASK/'frontend.cpp',TASK/'lifecycle_work.hpp',TASK/'render_readback.hpp',TASK/'tagged_readback.hpp',work/'src/main.cpp',*sorted((work/'include').glob('*.hpp'))]
    outputs=[work/'bin/rally.bin',work/'bin/rally.map',*[work/(t+e) for t in ['oval','fuji'] for e in ['.vdp','.clr','.road']]]
    report={'scope':__doc__,'source_hashes':{str(f):sha(f) for f in files},'outputs':{str(f):sha(f) for f in outputs},'work':str(work),'parent':parent,'bridge':bridge}
    (work/'manifest.json').write_text(json.dumps(report,indent=2)+'\n');print(work)
if __name__=='__main__':main()
