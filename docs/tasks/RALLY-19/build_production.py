"""Build the requested hardware game without diagnostics, reports or fences.

Extract unchanged art upload, input/physics and HUD from the checked frontend.
Keep the research frontend and its historical qualification artifacts intact.
"""
import argparse,json,shutil,subprocess
from pathlib import Path
from profile import TASK
from native_run import sha
from frontend_bridge import verify

def function(source,signature):
    start=source.index(signature);brace=source.index('{',start);depth=1;end=brace+1
    while depth:
        depth+=(source[end]=='{')-(source[end]=='}');end+=1
    return source[start:end]

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--frontend',default='checked-cleanup')
    p.add_argument('--inline-qualified',action='store_true');a=p.parse_args()
    base=TASK/'.work/frontend'/a.frontend;_,parent,bridge=verify(base,allow_inline=a.inline_qualified)
    work=TASK/'.work/production'/a.name;(work/'src').mkdir(parents=True,exist_ok=False)
    shutil.copytree(base/'include',work/'include');shutil.copy2(base/'Makefile',work/'Makefile')
    original=(base/'src/main.cpp').read_text()
    art=original[original.index('    // Upload only the five'):original.index('    if(oracleRenderer)mos_puts')]
    controls=original[original.index('        bool anyKey=false;'):original.index('\n        }\n        uint32_t physicsEnd=')]
    hud=original[original.index('        else if(demoMode) {'):original.index('        if(oracleRenderer)sceneryHistory.swapped();',original.index('        else if(demoMode) {'))]
    hud=hud.replace('        else if(demoMode) {','        if(demoMode) {',1)
    source='''// Hardware production build: gameplay clock only; no measurement or logs.
#include "road.hpp"
#include "car.hpp"
#include "traffic.hpp"
#include "scenery_data.hpp"
#include "demo.hpp"
#include "pacing.hpp"
#include "golem_renderer.hpp"
#include <agon/mos.h>
#include <agon/vdp.h>
#include <stdio.h>
#include <string.h>
namespace {
rally::Motion motion; rally::Traffic traffic; rally::DemoDriver demoDriver;
rally::r19::GolemRenderer golemRenderer;
bool demoMode=true,demoInputArmed=false,escapeArmed=true,autosteer=false;
constexpr unsigned CarWidth=102,CarHeight=77;
uint8_t carUpload[CarWidth*CarHeight],heldKeys[16];
bool key(int code){return heldKeys[(code-1)/8]&(1<<((code-1)%8));}
'''
    for signature in ['uint32_t rawClock()','void loadScenery()','void text(']:source+=function(original,signature)+'\n'
    source+='''bool cleanup(){
    vdp_mode(0);vdp_set_logical_coordinates();vdp_cursor_enable(true);
    bool ok=golemRenderer.unload();
    for(unsigned bitmap=0;bitmap<35;++bitmap)vdp_adv_clear_buffer(64000+bitmap);
    vdp_adv_clear_buffer(64100);vdp_adv_clear_buffer(63984);
    return ok;
}
}
int main(int argc,char**argv){
    const rally::TrackDef*track=&rally::TriOval;
    for(int i=1;i<argc;++i){
        if(strcmp(argv[i],"oval")==0)track=&rally::TriOval;
        else if(strcmp(argv[i],"fuji")==0)track=&rally::Fuji;
        else if(strcmp(argv[i],"demo")==0)demoMode=true;
        else if(strcmp(argv[i],"race")==0)demoMode=false;
        else if(strcmp(argv[i],"autosteer")==0)autosteer=true;
        else {printf("Usage: rally [oval|fuji] [demo|race] [autosteer]\\n");return 1;}
    }
    motion.track=track;traffic.init(0,track->length*100);
    if(vdp_mode(136)<0)return 1;
    vdp_set_pixel_coordinates();vdp_reset_sprites();vdp_cursor_enable(false);
'''+art+'''
    if(!golemRenderer.load(track==&rally::Fuji)){
        cleanup();printf("Golem scene data could not be loaded.\\n");return 31;
    }
    vdp_set_text_colour(15);vdp_set_text_bg_colour(0);
    uint32_t previous=rawClock(),next=previous;
    bool stateInvalid=false;
    for(;;){
        uint32_t now=rawClock();
        if(!rally::tickDue(now,next))continue;
        next=now+4;
        for(unsigned i=0;i<16;++i)heldKeys[i]=vdp_getKeyMap(i);
        uint32_t elapsed=rally::ticksSince(now,previous);previous=now;
'''+controls+'''
        if(!golemRenderer.prepare(motion,traffic,demoMode,autosteer)){stateInvalid=true;break;}
        golemRenderer.submit();
        char hud[41];
'''+hud+'''
    }
    bool cleaned=cleanup();
    if(stateInvalid)printf("Scene state rejected.\\n");
    if(!cleaned)printf("Scene cleanup could not be loaded.\\n");
    return stateInvalid||!cleaned?1:0;
}
'''
    for forbidden in ['waitForVDP','marker(','fopen(','profiling','benchmark','TimingCapacity','startupTicks','r18Begin']:
        assert forbidden not in source,forbidden
    (work/'src/main.cpp').write_text(source)
    renderer=(work/'include/golem_renderer.hpp').read_text()
    for old,new in [('    uint32_t sceneBytes=0,frames=0;\n',''),(';sceneBytes=frames=0;',';'),(';sceneBytes+=sizeof(packet_);++frames;',';')]:
        assert renderer.count(old)==1,old;renderer=renderer.replace(old,new)
    assert 'sceneBytes' not in renderer and 'frames' not in renderer
    (work/'include/golem_renderer.hpp').write_text(renderer)
    for track in ['oval','fuji']:
        for ext in ['.vdp','.clr']:shutil.copy2(base/(track+ext),work/(track+ext))
    with (work/'build.txt').open('w') as log:subprocess.run(['make','-C',str(work)],check=True,stdout=log,stderr=subprocess.STDOUT)
    binary=(work/'bin/rally.bin').read_bytes()
    for forbidden in [b'.csv',b'.viz',b'.snk',b'TIMING FIXTURE',b'profile',b'measurement']:
        assert forbidden not in binary,forbidden
    assert b'PRESS ANY KEY TO RACE' in binary
    files=[Path(__file__),work/'src/main.cpp',*sorted((work/'include').glob('*.hpp'))]
    outputs=[work/'bin/rally.bin',*[work/(t+e) for t in ['oval','fuji'] for e in ['.vdp','.clr']]]
    report={'scope':__doc__,'bridge':bridge,'parent':parent,'work':str(work),'source_hashes':{str(f):sha(f) for f in files},'outputs':{str(f):sha(f) for f in outputs},'defaults':'oval demo','fencing':False,'logging':False,'performance_counters':False,'gameplay_clock':'unchanged30Hz deadline and120Hz physics'}
    (work/'manifest.json').write_text(json.dumps(report,indent=2)+'\n');print(work)
if __name__=='__main__':main()
