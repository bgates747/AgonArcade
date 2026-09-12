"""Build isolated RALLY-18 live/lookup copies using the canonical Linux fallback."""
from pathlib import Path
import argparse,hashlib,json,shutil,subprocess,sys,tempfile,re
TASK=Path(__file__).resolve().parent;REPO=TASK.parents[2];MAIN=REPO/'rally';WORK=TASK/'.work';STATE=WORK/'builds.json'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def protect():
    state=json.loads((TASK/'checkpoint-inputs.json').read_text())
    for name,h in state['protected_game'].items():assert sha(REPO/name)==h,name
    for name,h in state['runtime'].items():assert sha(Path(name))==h,name
    assert sha(TASK.parent/'RALLY-18.md')==state['contract_sha256'],'Frozen contract changed'
def replace_function(s,name,body):
    pattern=re.search(r'^(?:unsigned|void) '+name+r'\([^\n]*\) \{',s,re.M);assert pattern,name
    a=pattern.start();pos=pattern.end();depth=1
    while depth:
        if s[pos]=='{':depth+=1
        if s[pos]=='}':depth-=1
        pos+=1
    return s[:a]+body+s[pos:]
def source(variant):
    s=(MAIN/'src/main.cpp').read_text()
    extra='#include <ez80f92.h>\n#include "section_road.hpp"\n#include "scene.hpp"\n#include "task_workload.hpp"\n'
    if variant=='lookup':extra+='#include "lookup_road.hpp"\n'
    extra+='extern "C" __attribute__((noinline)) void r18Begin(){asm volatile("nop");}\nextern "C" __attribute__((noinline)) void r18End(){asm volatile("nop\\nnop");}\n'
    s=s.replace('namespace {',extra+'namespace {\nuint32_t roadLoadTicks=0;\nbool perspective=false,measure=false,computeOnly=false,displayTiming=false,snapshot=false;\nunsigned snapshotPose=0;int snapshotLateral=0,snapshotSteering=0;\nvolatile rally::r18::SceneState scene{};\n',1)
    s=s.replace('rally::Road road;','rally::'+('LookupRoad' if variant=='lookup' else 'SectionRoad')+' road;')
    s=replace_function(s,'trafficMatrix','''void trafficMatrix(unsigned id,int xx,int scale,int translation) {
    rally::Stream command;
    command.byte(23);command.byte(0);command.byte(0xa0);command.word(id);command.byte(32);command.byte(0);
    command.byte(23);command.byte(0);command.byte(0xa0);command.word(id);command.byte(32);command.byte(11);command.byte(0xc8);
    command.word(xx);command.word(0);command.word(translation);command.word(0);command.word(scale);command.word(0);
    mos_puts((char*)command.data,command.size,0);
}''')
    s=replace_function(s,'drawTraffic','''unsigned drawTraffic(){
    for(unsigned i=0;i<scene.cars;++i){volatile const auto &c=scene.traffic[i];
        trafficMatrix(c.matrix,c.xx,c.scale,c.translation);vdp_select_bitmap(c.bitmap);
        vdp_adv_use_affine_matrix(1,c.matrix);vdp_draw_bitmap(c.x,c.y);
    }
    vdp_adv_use_affine_matrix(1,65535);return scene.cars;
}''')
    a=s.index('    int32_t p=',s.index('void drawScenery()'));b=s.index('\n    vdp_adv_use_affine_matrix',a)
    s=s[:a]+'''    int offset=scene.skyOffset;
    rally::SceneryUpdate update={scene.skyDelta,scene.skyLeft,scene.skyRight,scene.skyRepaint};
'''+s[b:]
    a=s.index('\n}\nint main(');s=s[:a]+'\n'+(TASK/'diagnostic.cpp.inc').read_text()+s[a:]
    a=s.index('        if(strcmp(argv[i],"fuji")');s=s[:a]+'''        if(strcmp(argv[i],"perspective")==0)perspective=true;
        else if(strcmp(argv[i],"measure")==0)measure=true;
        else if(strcmp(argv[i],"compute")==0)computeOnly=true;
        else if(strcmp(argv[i],"display")==0)displayTiming=true;
        else if(strcmp(argv[i],"snapshot")==0)snapshot=true;
        else if(strncmp(argv[i],"pose=",5)==0)snapshotPose=atoi(argv[i]+5);
        else if(strncmp(argv[i],"lateral=",8)==0)snapshotLateral=atoi(argv[i]+8);
        else if(strncmp(argv[i],"steering=",9)==0)snapshotSteering=atoi(argv[i]+9);
        else '''+s[a:].lstrip()
    s=s.replace('    road.init();','    road.init();'+('\n    uint32_t loadStart=rawClock();\n    if(!road.load(track==&rally::Fuji?"fuji.road":"oval.road")){printf("RALLY-18 road data invalid or unavailable.\\n");return 30;}\n    roadLoadTicks=rally::ticksSince(rawClock(),loadStart);' if variant=='lookup' else ''))
    s=s.replace('    loadScenery();','    loadScenery();\n    mos_puts((char*)rally::section::Startup,rally::section::StartupSize,0);')
    s=s.replace('    // Fence uploads','    if(measure||snapshot)return taskDiagnostic();\n    // Fence uploads',1)
    a=s.index('        if(detailTiming) {\n            road.project');b=s.index('        if (stream.overflow)',a)
    s=s[:a]+'''        prepareScene();
        if(detailTiming)geometryEnd=rawClock();
        road.emit(stream,false);
'''+s[b:]
    a=s.index('        vdp_select_bitmap(motion.view());');b=s.index('        char hud[41];',a);s=s[:a]+'        drawPlayer();\n'+s[b:]
    s=s.replace('    uint32_t previous=rawClock(),next=previous;', '    marker("play-ready.viz");\n    uint32_t previous=rawClock(),next=previous;')
    s=s.replace('    printf("Agon Rally: road prototype ended.\\n");', '\n    FILE *play=fopen("play-result.csv","w");\n    if(play){fprintf(play,"demo,steering,speed,lateral,position,frames\\n%u,%d,%ld,%ld,%ld,%lu\\n",unsigned(demoMode),motion.steering,(long)motion.speed,(long)motion.lateral,(long)motion.position,(unsigned long)submitted);fclose(play);}\n    marker("exit.viz");\n    printf("Agon Rally: road prototype ended.\\n");')
    if variant=='lookup':
        s=s.replace('rally::LookupRoad road;','rally::LookupRoad road __attribute__((no_destroy));')
        s=s.replace('int main(int argc, char **argv)', 'int gameMain(int argc, char **argv)')
        s+='\nint main(int argc,char **argv){int result=gameMain(argc,argv);road.~LookupRoad();return result;}\n'
    assert 'motion.cameraOffset()' not in s
    return s

def build(variants):
    protect();WORK.mkdir(exist_ok=True)
    state=json.loads(STATE.read_text()) if STATE.exists() else {'checkpoint':'182a1d0','variants':{}}
    run=Path(tempfile.mkdtemp(prefix='build-',dir=WORK))
    for variant in variants:
        root=run/variant;root.mkdir();shutil.copy2(MAIN/'Makefile',root/'Makefile')
        for name in ('src','include','tests','tools'):shutil.copytree(MAIN/name,root/name,ignore=shutil.ignore_patterns('__pycache__'))
        for p in TASK.glob('*.hpp'):shutil.copy2(p,root/'include'/p.name)
        (root/'src/main.cpp').write_text(source(variant))
        print('Building',variant,flush=True);log=run/(variant+'-build.txt')
        with log.open('w') as f:r=subprocess.run([sys.executable,str(root/'tools/build_linux.py')],stdout=f,stderr=subprocess.STDOUT)
        if r.returncode:print(log.read_text()[-6500:]);raise RuntimeError('Build failed')
        info={'root':str(root),'sha256':sha(root/'bin/rally.bin'),'source_sha256':sha(root/'src/main.cpp'),'bytes':(root/'bin/rally.bin').stat().st_size,'build_evidence':(root/'bin/linux-build.txt').read_text(),'log':str(log)}
        remote=re.search(r'Build directory: (.+)',info['build_evidence'])[1]
        mapping=subprocess.check_output(['ssh','agon-linux','cat '+remote+'/bin/rally.map'],text=True)
        (root/'bin/rally.map').write_text(mapping)
        info['breakpoints']=[int(re.search(r'(0x[0-9a-f]+)\s+_'+n+r'\s*$',mapping,re.M)[1],16) for n in ('r18Begin','r18End')]
        state['variants'][variant]=info;protect();STATE.write_text(json.dumps(state,indent=2)+'\n')
        print(variant,info['bytes'],'bytes;',info['breakpoints'],flush=True)
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('variants',nargs='*',choices=('live','lookup'));a=p.parse_args();build(a.variants or ('live','lookup'))
