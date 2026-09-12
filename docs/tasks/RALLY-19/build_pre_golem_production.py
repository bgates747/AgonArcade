"""Strip diagnostics from the exact latest pre-Golem oracle; retain its renderer and controls."""
import json, shutil, subprocess
from pathlib import Path
from profile import TASK
from native_run import sha
from build_production import function

def main():
    base=TASK/'.work/oracle'
    assert sha(base/'bin/rally.bin')=='03322954c8c4fe29d90eaa0706c9169b242cdd264ea3b7b287cece58a6469d79'
    work=TASK/'.work/production/pre-golem-oval'
    (work/'src').mkdir(parents=True,exist_ok=False)
    shutil.copytree(base/'include',work/'include');shutil.copy2(base/'Makefile',work/'Makefile')
    original=(base/'src/main.cpp').read_text()
    functions=['uint32_t rawClock()', 'void trafficMatrix(', 'unsigned drawTraffic()', 'void loadScenery()', 'void drawScenery()', 'void text(', 'void prepareScene()', 'void drawPlayer()']
    art=original[original.index('    // Upload only the five'):original.index('    if(measure||snapshot)')]
    controls=original[original.index('        bool anyKey=false;'):original.index('\n        }\n        uint32_t physicsEnd=')]
    hud=original[original.index('        else if(demoMode) {'):original.index('        ++submitted;')]
    hud=hud.replace('        else if(demoMode) {','        if(demoMode) {',1)
    source='''// Production pre-Golem renderer, derived from accepted949f618.
#include "road.hpp"
#include "car.hpp"
#include "traffic.hpp"
#include "scenery.hpp"
#include "demo.hpp"
#include "pacing.hpp"
#include "scene.hpp"
#include "lookup_road.hpp"
#include <agon/mos.h>
#include <agon/vdp.h>
#include <stdio.h>
#include <string.h>
namespace {
bool autosteer=false,perspective=false;
volatile rally::r18::SceneState scene{};
rally::Motion motion;
rally::LookupRoad road __attribute__((no_destroy));
rally::Traffic traffic;
rally::DemoDriver demoDriver;
bool demoMode=true,demoInputArmed=false,escapeArmed=true;
rally::SceneryHistory sceneryHistory;
rally::Stream stream;
constexpr unsigned CarWidth=102,CarHeight=77;
uint8_t carUpload[CarWidth*CarHeight],heldKeys[16];
bool key(int code){return heldKeys[(code-1)/8]&(1<<((code-1)%8));}
'''
    for name in functions:source+=function(original,name)+'\n'
    source+='''}
int gameMain(int argc,char**argv){
    const rally::TrackDef*track=&rally::TriOval;
    for(int i=1;i<argc;++i){
        if(strcmp(argv[i],"oval")==0)track=&rally::TriOval;
        else if(strcmp(argv[i],"fuji")==0)track=&rally::Fuji;
        else if(strcmp(argv[i],"demo")==0)demoMode=true;
        else if(strcmp(argv[i],"race")==0)demoMode=false;
        else if(strcmp(argv[i],"autosteer")==0)autosteer=true;
        else if(strcmp(argv[i],"perspective")==0)perspective=true;
        else {printf("Usage: rally [oval|fuji] [demo|race] [autosteer] [perspective]\\n");return 1;}
    }
    motion.track=road.track=track;road.init();
    if(!road.load(track==&rally::Fuji?"fuji.road":"oval.road")){
        printf("Road data invalid or unavailable.\\n");return 30;
    }
    traffic.init(motion.position,track->length*100);
    if(vdp_mode(136)<0)return 1;
    vdp_set_pixel_coordinates();vdp_reset_sprites();vdp_cursor_enable(false);
'''+art+'''
    uint32_t previous=rawClock(),next=previous;
    for(;;){
        uint32_t now=rawClock();
        if(!rally::tickDue(now,next))continue;
        next=now+4;
        for(unsigned i=0;i<16;++i)heldKeys[i]=vdp_getKeyMap(i);
        uint32_t elapsed=rally::ticksSince(now,previous);previous=now;
'''+controls+'''
        prepareScene();road.emit(stream,false);
        if(stream.overflow)break;
        drawScenery();mos_puts((char*)stream.data,stream.size,0);
        drawTraffic();drawPlayer();
        char hud[41];
'''+hud+'''
    }
    vdp_mode(0);vdp_set_logical_coordinates();vdp_cursor_enable(true);
    return 0;
}
int main(int argc,char**argv){int result=gameMain(argc,argv);road.~LookupRoad();return result;}
'''
    for forbidden in ['waitForVDP','marker(','.csv','.viz','.snk','r18Begin','r18End','profiling','benchmark','submitted','TimingCapacity']:
        assert forbidden not in source,forbidden
    (work/'src/main.cpp').write_text(source)
    for name in functions:assert function(source,name)==function(original,name),name
    for track in ['oval','fuji']:shutil.copy2(TASK.parent/'RALLY-18/data'/(track+'.road'),work/(track+'.road'))
    with (work/'build.txt').open('w') as log:subprocess.run(['make','-C',str(work)],check=True,stdout=log,stderr=subprocess.STDOUT)
    binary=(work/'bin/rally.bin').read_bytes()
    for forbidden in [b'.csv',b'.viz',b'.snk',b'TIMING FIXTURE',b'Timing saved:',b'Golem']:
        assert forbidden not in binary,forbidden
    assert b'PRESS ANY KEY TO RACE' in binary
    report={'base_commit':'949f6186853ab99f257906e95786593a7a2e098f','base_binary_sha256':sha(base/'bin/rally.bin'),
        'renderer_functions_exact':functions,'headers_exact':all(p.read_bytes()==(base/'include'/p.name).read_bytes() for p in (work/'include').glob('*.hpp')),
        'controls_and_art_extracted_exact':True,'fencing':False,'logging':False,'performance_counters':False,'defaults':'oval demo',
        'source_hashes':{str(p):sha(p) for p in [Path(__file__),base/'src/main.cpp',work/'src/main.cpp',*sorted((work/'include').glob('*.hpp'))]},
        'outputs':{str(p):sha(p) for p in [work/'bin/rally.bin',work/'oval.road',work/'fuji.road']}}
    (work/'manifest.json').write_text(json.dumps(report,indent=2)+'\n');print(work);print('Binary',len(binary),sha(work/'bin/rally.bin'))
if __name__=='__main__':main()
