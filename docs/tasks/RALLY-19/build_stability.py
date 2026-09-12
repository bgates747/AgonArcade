"""Build test-only deterministic replay and sanitized host state oracle."""
import argparse,json,shutil,subprocess
from pathlib import Path
from profile import TASK
from native_run import sha
from frontend_bridge import verify

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--frontend',required=True)
    p.add_argument('--inline-qualified',action='store_true');a=p.parse_args()
    base=TASK/'.work/frontend'/a.frontend;qualified,selected,bridge=verify(base,allow_inline=a.inline_qualified)
    work=TASK/'.work/stability'/a.name;(work/'src').mkdir(parents=True,exist_ok=False)
    shutil.copytree(base/'include',work/'include');shutil.copy2(base/'Makefile',work/'Makefile')
    for name in ['stability_work.hpp','replay_inputs.hpp','render_readback.hpp']:shutil.copy2(TASK/name,work/'include'/name)
    source=(TASK/'frontend.cpp').read_text()
    start=source.index('        bool anyKey=false;');end=source.index('\n        }\n        uint32_t physicsEnd=',start)
    body=source[start:end]
    assert body.count('break;')==1
    step='#include "replay_inputs.hpp"\nbool replayStep(unsigned frame){\nif(replayInputs(frame))return true;\nconst auto*track=motion.track;\nconst uint32_t elapsed=4;\n'+body.replace('break;','return false;')+'\nreturn true;\n}\n'
    (work/'include/replay_step.hpp').write_text(step)
    replacements=[('int taskDiagnostic(){','#include "stability_work.hpp"\nint taskDiagnostic(){\nif(measure)return r19Stability();'),
        ('perspective || measure || computeOnly || displayTiming || snapshot ||','perspective || computeOnly || displayTiming || snapshot ||'),
        ('else if(strcmp(argv[i],"measure")==0)measure=true;','else if(strcmp(argv[i],"measure")==0)measure=true;\n        else if(strncmp(argv[i],"frames=",7)==0)replayFrames=atoi(argv[i]+7);'),
        ('    const bool detailTiming=profiling && !lightTiming;','    if(!measure||oracleRenderer||replayFrames<1||replayFrames>60000)return 115;\n    const bool detailTiming=profiling && !lightTiming;')]
    for old,new in replacements:assert source.count(old)==1;source=source.replace(old,new)
    (work/'src/main.cpp').write_text(source)
    host='''#include "frontend_state.hpp"
#include "demo.hpp"
#include "task_workload.hpp"
#include <cstdio>
#include <cstdlib>
rally::Motion motion; rally::Traffic traffic; rally::DemoDriver demoDriver;
bool demoMode=true,demoInputArmed=false,escapeArmed=true,autosteer=false;
uint8_t heldKeys[16]{};
bool key(int code){return heldKeys[(code-1)/8]&(1<<((code-1)%8));}
#include "replay_step.hpp"
int main(int argc,char**argv){
if(argc!=3)return 1;motion.track=atoi(argv[1])?&rally::Fuji:&rally::TriOval;
traffic.init(0,motion.track->length*100);
unsigned count=atoi(argv[2]);
for(unsigned i=0;i<count;++i){
if(!replayStep(i))return 2;
rally::r19::State state;uint8_t data[80];
if(!rally::r19::stateFromMotion(motion,traffic,i,demoMode,autosteer,state)||!rally::r19::encode(state,data,80))return 3;
if(fwrite(data,1,80,stdout)!=80)return 4;
}return 0;}
'''
    (work/'host.cpp').write_text(host)
    for track in ['oval','fuji']:
        for ext in ['.vdp','.clr','.road']:shutil.copy2(base/(track+ext),work/(track+ext))
    with (work/'build.txt').open('w') as log:
        subprocess.run(['make','-C',str(work)],check=True,stdout=log,stderr=subprocess.STDOUT)
        subprocess.run(['g++','-std=c++17','-O1','-g','-fsanitize=address,undefined','-fno-omit-frame-pointer','-I'+str(work/'include'),str(work/'host.cpp'),'-o',str(work/'host')],check=True,stdout=log,stderr=subprocess.STDOUT)
    files=[Path(__file__),TASK/'frontend_bridge.py',TASK/'frontend.cpp',*[TASK/n for n in ['replay_inputs.hpp','stability_work.hpp','render_readback.hpp']],work/'host.cpp',work/'src/main.cpp',*sorted((work/'include').glob('*.hpp'))]
    outputs=[work/'bin/rally.bin',work/'bin/rally.map',work/'host',*[work/(t+e) for t in ['oval','fuji'] for e in ['.vdp','.clr','.road']]]
    report={'scope':__doc__,'source_hashes':{str(f):sha(f) for f in files},'outputs':{str(f):sha(f) for f in outputs},'accepted_input_body_sha256':__import__('hashlib').sha256(body.encode()).hexdigest(),'work':str(work),'qualified_frontend':qualified['build'],'selected_frontend':selected,'bridge':bridge}
    (work/'manifest.json').write_text(json.dumps(report,indent=2)+'\n');print(work)
if __name__=='__main__':main()
