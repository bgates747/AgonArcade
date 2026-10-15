"""Build isolated standard candidates without changing products or earlier fixtures."""
from pathlib import Path
import hashlib,json,os,re,shutil,subprocess
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[4];WORK=HERE/'.work';SDK=Path('/Agon/agondev')
CAP=HERE.parent/'capacity';DATA=HERE/'evidence/data'
VARIANTS={'dense':(0,0),'lookup':(1,0),'lookup-buffer':(1,1),'coarse':(2,0),'coarse-buffer':(2,1)}
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
def run(cmd,**kw):subprocess.run(list(map(str,cmd)),check=True,**kw)
def generate():
    inc=WORK/'include';inc.mkdir(parents=True,exist_ok=True)
    widths=[-106,106,-90,90,-86,-84,84,86,-2,2]
    rows=[[(-1 if (y-96)*w<0 else 1)*(abs((y-96)*w)//50) for w in widths] for y in range(103,225)]
    text='#pragma once\n#include <stdint.h>\nnamespace rally::r28 {\nstatic const int16_t EdgeOffset[122][10]={\n'
    text+=''.join('{'+','.join(map(str,row))+'},\n' for row in rows)+'};\nstatic const uint8_t DistanceQ[1037]={\n'
    text+=','.join(str(8000//z) for z in range(64,1101))+'\n};\n}\n'
    (inc/'projection_tables.hpp').write_text(text)
    for name in ('projection.hpp','shared_scene.hpp','buffered.hpp'):shutil.copyfile(HERE/name,inc/name)
    original=(ROOT/'rally-game/src/main.cpp').read_text()
    trimmed=re.sub(r'int gameMain\(.*?\n}\nint main', 'int gameMain(int,char **){return 0;}\nint main',original,flags=re.S)
    assert trimmed!=original and original[original.index('void tick()'):original.index('void finishLine()')]==trimmed[trimmed.index('void tick()'):trimmed.index('void finishLine()')]
    (inc/'physics_product.cpp').write_text(trimmed)
    replacement='''#if CANDIDATE==0
rally::DirectRoad road;
#else
alignas(rally::r28::SharedRoad) uint8_t roadStorage[sizeof(rally::r28::SharedRoad)];
rally::r28::SharedRoad &road=*reinterpret_cast<rally::r28::SharedRoad *>(roadStorage);
#endif'''
    product='#include "shared_scene.hpp"\n#include "buffered.hpp"\n'+trimmed.replace('rally::DirectRoad road;',replacement)
    product=product.replace('Billboards billboards;','#if CANDIDATE==0\nBillboards billboards;\n#else\nrally::r28::SharedSigns billboards;\n#endif')
    product=product.replace('rally::game::prepareGameScene(motion,traffic,raceTraffic,road,sceneryHistory,scene,false);','#if CANDIDATE==0\nrally::game::prepareGameScene(motion,traffic,raceTraffic,road,sceneryHistory,scene,false);\n#else\nrally::r28::prepareScene(motion,traffic,raceTraffic,road,sceneryHistory,scene,false);\n#endif')
    finish='''void finishLine() {
    const int32_t distance=rally::Traffic::ahead(0,motion.position,selected->length*100)/100;
    if(distance<64 || distance>1000)return;
    const int y=rally::r28::SharedRoad::depthRow(distance);if(y<104 || y>223)return;
    int height=(y-96)/16;if(height<1)height=1;
    for(int row=0;row<2;++row) {
        const int yy=y+row*height;if(yy>223)break;
        const int centre=road.centerAt(yy),half=rally::r28::EdgeOffset[yy-103][3],span=half*2;
        const int step=span/12,remainder=span-step*12;int edges[13],credit=0;edges[0]=centre-half;
        for(int i=1;i<=12;++i){credit+=remainder;edges[i]=edges[i-1]+step;if(credit>=12){++edges[i];credit-=12;}}
        int bottom=yy+height-1;if(bottom>223)bottom=223;
        for(int i=0;i<12;++i)stream.rect(edges[i],yy,edges[i+1]-1,bottom,((i+row)&1)?15:0);
    }
    flush();
}'''
    pattern=r'void finishLine\(\) \{[\s\S]*?\n\}\nvoid drawPlayer'
    old=re.search(pattern,product)[0].removesuffix('\nvoid drawPlayer')
    product=product.replace(old,'#if CANDIDATE==0\n'+old+'\n#else\n'+finish+'\n#endif')
    # AgonDev can fold the conditional panorama call while materializing y=0
    # with flag-clobbering SBC HL,HL. Keep that zero in a separate unconditional
    # helper; one x argument needs only PUSH after the signed comparison.
    begin=product.index('void drawScenery() {');end=product.index('void resetMotion()',begin)
    old_scenery=product[begin:end]
    helper='__attribute__((noinline)) void panoramaDraw(int x){vdp_draw_bitmap(x,0);}'
    shared_scenery=re.sub(r'vdp_draw_bitmap\(([^,]+),0\)',r'panoramaDraw(\1)',old_scenery)
    assert shared_scenery!=old_scenery
    product=product[:begin]+'#if CANDIDATE==0\n'+old_scenery+'#else\n'+helper+'\n'+shared_scenery+'#endif\n'+product[end:]
    (inc/'product_main.cpp').write_text(product)
    workload=(CAP/'src/workload.hpp').read_text().replace('"product_main.cpp"','"physics_product.cpp"');(inc/'workload.hpp').write_text(workload)
    scene=(CAP/'src/scene_workload.hpp').read_text().replace('road.emitTo(stream,send);','\n#if BUFFERED\nrally::r28::emitBuffered(road,stream,send);\n#else\nroad.emitTo(stream,send);\n#endif\n')
    (inc/'scene_workload.hpp').write_text(scene)
    return inc

def build(build_host=True):
    data=WORK/'data';data.mkdir(parents=True,exist_ok=True)
    for source in DATA.glob('*.road'):shutil.copyfile(source,data/source.name)
    inc=generate();flags=f'-I{inc} -I{ROOT}/rally-game/include -I{ROOT}/rally-production/include'
    original=(ROOT/'rally-game/src/main.cpp').read_text();names=set(re.findall(r'\b(vdp_\w+)\s*\(',original));names.add('vdp_vdu')
    sdk=[SDK/'src/lib/libvdp'/(n+'.c') for n in sorted(names) if (SDK/'src/lib/libvdp'/(n+'.c')).exists()]
    env=dict(os.environ,PATH=str(SDK/'release/bin')+':'+os.environ['PATH']);results={}
    for name,(candidate,buffered) in VARIANTS.items():
        d=WORK/name;(d/'src').mkdir(parents=True,exist_ok=True)
        for source in (HERE/'src').iterdir():
            if source.name=='host.cpp':continue
            shutil.copyfile(source,d/'src'/('main.cpp' if source.name=='driver.cpp' else source.name))
        shutil.copyfile(CAP/'evidence/timing_prt.asm',d/'src/timing_prt.asm')
        for source in sdk:shutil.copyfile(source,d/'src'/source.name)
        defs=f'-DCANDIDATE={candidate} -DBUFFERED={buffered} -Dmos_puts=fixture_puts -Dputch=fixture_putch'
        (d/'Makefile').write_text('NAME=candidate\nLDHAS_ARG_PROCESSING=0\nLDHAS_EXIT_HANDLER=0\ninclude /Agon/agondev/release/config/makefile.inc\n'+f'CFLAGS += {flags} {defs} -ffunction-sections -fdata-sections\nCXXFLAGS += {flags} {defs} -ffunction-sections -fdata-sections -std=c++17 -fno-exceptions -fno-rtti -Wall -Wextra -Werror -Wno-unused-function\nLINKERFLAGS := --gc-sections $(LINKERFLAGS)\n')
        run(['make','-C',d],env=env)
        mapping=(d/'bin/candidate.map').read_text()
        for section in ('init_array','ctors','dtors','fini_array'):
            m=re.search(r'^\.'+section+r'\s+0x[0-9a-f]+\s+(0x[0-9a-f]+)',mapping,re.M)
            assert m and int(m[1],16)==0,(name,section)
        results[name]={'sha256':sha(d/'bin/candidate.bin'),'bytes':(d/'bin/candidate.bin').stat().st_size}
    # Host SDK structs need byte packing, matching AgonDev; system C++ structs do not.
    hostinc=WORK/'hostinclude';hostinc.mkdir(exist_ok=True)
    if not (hostinc/'agon').exists():(hostinc/'agon').symlink_to(SDK/'release/include/agon',target_is_directory=True)
    prefix=WORK/'hostprefix.hpp';prefix.write_text('#include <stdint.h>\n#include <stdio.h>\n#include <stdlib.h>\n#include <stdbool.h>\ntypedef uint32_t uint24_t;\ntypedef int32_t int24_t;\n#pragma pack(push,1)\n#include <agon/vdp.h>\n#pragma pack(pop)\n')
    # Derive the full-frame host serializer from the preserved census harness.
    host=(CAP/'src/host.cpp').read_text().replace('#include "workload.hpp"','#include <new>\n#define main unused_product_main\n#include "product_main.cpp"\n#undef main')
    a=host.index('    if(std::string(argv[1])=="physics")');b=host.index('    assert(std::string(argv[1])=="wire")',a);host=host[:a]+host[b:]
    host=host.replace('assert(argc==2);','assert(argc==3);\n#if CANDIDATE>0\nnew(roadStorage) rally::r28::SharedRoad();road.coarse=CANDIDATE==2;road.track=&rally::Fuji;assert(road.load((std::string(argv[2])+"/fuji.road").c_str()));\n#endif')
    host=host.replace('part="setup";capacity::setupScene();','part="setup";capacity::setupScene();\n#if BUFFERED\nrally::r28::templates(send);\n#endif')
    host=host.replace('rally::game::prepareGameScene(motion,traffic,raceTraffic,road,sceneryHistory,scene,false);','#if CANDIDATE==0\nrally::game::prepareGameScene(motion,traffic,raceTraffic,road,sceneryHistory,scene,false);\n#else\nrally::r28::prepareScene(motion,traffic,raceTraffic,road,sceneryHistory,scene,false);\n#endif\n')
    # Preprocessor directives must begin their own lines.
    host=host.replace('capacity::advanceScene();#if','capacity::advanceScene();\n#if')
    (WORK/'host.cpp').write_text(host)
    base=['c++','-std=c++17','-ffunction-sections','-fdata-sections','-Wl,--gc-sections','-include',prefix,'-I'+str(hostinc),*flags.split()]
    if build_host:
        for name,(candidate,buffered) in VARIANTS.items():
            for mode,options in [('ordinary',['-O2']),('sanitized',['-O1','-g','-fsanitize=address,undefined','-fno-omit-frame-pointer'])]:
                run([*base,*options,f'-DCANDIDATE={candidate}',f'-DBUFFERED={buffered}',WORK/'host.cpp',*sdk,'-o',WORK/('host-'+name+'-'+mode)])
        for mode,options in [('ordinary',['-O2']),('sanitized',['-O1','-g','-fsanitize=address,undefined','-fno-omit-frame-pointer'])]:
            run(['c++','-std=c++17',*options,*flags.split(),HERE/'host_checks.cpp','-o',WORK/('checks-'+mode)])
    inputs=[HERE/'build.py',*sorted(HERE.glob('*.hpp')),*sorted((HERE/'src').iterdir()),HERE/'host_checks.cpp',ROOT/'rally-game/src/main.cpp',*sorted((ROOT/'rally-game/include').glob('*.hpp')),*sorted((ROOT/'rally-production/include').glob('*.hpp')),*sdk,*sorted(inc.glob('*'))]
    receipt={'variants':results,'inputs':{str(p):sha(p) for p in inputs},'tables':{p.name:sha(p) for p in DATA.glob('*.road')}}
    (WORK/'build.json').write_text(json.dumps(receipt,indent=2)+'\n');print(json.dumps(results,indent=2))
if __name__=='__main__':
    import argparse
    p=argparse.ArgumentParser();p.add_argument('--targets-only',action='store_true');a=p.parse_args();build(build_host=not a.targets_only)
