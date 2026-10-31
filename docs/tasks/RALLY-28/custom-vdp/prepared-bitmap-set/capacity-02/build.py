"""Build a setup-only guest; retain every byte of the qualified native module."""
from pathlib import Path
import hashlib
import json
import os
import re
import shutil
import struct
import subprocess

HERE=Path(__file__).resolve().parent
CONTROL=HERE.parents[1]/'incremental/round-trips'
ROOT=HERE.parents[5]
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()


def build():
    frozen=json.loads((HERE/'RECIPE-FREEZE.json').read_text())
    for n,h in frozen['files'].items():assert sha(HERE/n)==h,n
    assert sha(CONTROL/'guest/probe.bin')==frozen['baseline_guest_sha256']
    assert sha(CONTROL/'target/rally-render.vdpl')==frozen['baseline_module_sha256']
    work=HERE/'.work/guest'
    for base in ('src','include'):
        for p in (CONTROL/'guest'/base).iterdir():
            dst=work/base/p.name;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,dst)
    p=work/'include/native.hpp'
    text=p.read_text();assert text.count('transcript[100000]')==1
    p.write_text(text.replace('transcript[100000]','transcript[240000]'))
    p=work/'src/main.cpp'
    text=p.read_text();text=text[:text.index('int main(){')]
    text+='''#include "capacity.hpp"
int main(){
    clearOutputs();
    const char *extra[]={"memory.csv","pixels.csv","state-before.bin","state-after.bin","failure-detail.csv"};
    for(auto name:extra)mos_del(name);
    prepareRace();
    if(!fs::setup())goto failed;
    font(Font);engine.start(send);warmLower();paint();warmLower();paint();
    if(!fs::healthy)goto failed;
    capacity::memoryLog=fopen("memory.csv","wb");capacity::pixelLog=fopen("pixels.csv","wb");
    if(!capacity::memoryLog||!capacity::pixelLog){fs::fail("Capacity output open");goto failed;}
    fprintf(capacity::memoryLog,"stage,id,internal,largest_internal,free_psram,buffers,mos_ticks,prt_ticks\\r\\n");
    fprintf(capacity::pixelLog,"id,x,y,expected,actual,kind\\r\\n");
    capacity::execute();
failed:
    if(fs::pending){printf("RALLY CAPACITY callback timeout; reset required.\\n");for(;;){}}
    if(fs::handle)capacity::cleanup();
    engine.stop(send);fs::stop();if(!fs::pending){releaseGraphics();restoreText();}
    if(!capacity::save())fs::fail("Capacity result output");
    if(fs::healthy){printf("RALLY CAPACITY DONE: logs saved.\\n");return 0;}
    FILE *f=fopen("failure.txt","wb");if(f){fprintf(f,"%s\\n",fs::failure);fclose(f);}
    printf("RALLY CAPACITY FAILED: %s\\n",fs::failure);return 1;
}
'''
    p.write_text(text)
    for n in ('capacity.hpp','recipe-pins.hpp','protocol.hpp'):shutil.copyfile(HERE/n,work/'include'/n)
    recipe=json.loads((HERE/'recipe.json').read_text())
    details=[]
    for e in recipe['entries']:
        if e['detailed']:
            for x,y,colour in e['detailed_probes'][1:]:details.append((e['id'],x,y,colour))
    (work/'include/capacity-details.hpp').write_text('#pragma once\nnamespace capacity_details {\nstruct Point {uint16_t id;uint8_t x,y,colour;};\nconstexpr Point Points[]={\n'+''.join('{%u,%u,%u,%u},\n'%p for p in details)+'};\n}\n')
    make='''NAME=probe
LDHAS_ARG_PROCESSING=0
LDHAS_EXIT_HANDLER=0
include /Agon/agondev/release/config/makefile.inc
CFLAGS += -I{game} -I{production}
CXXFLAGS += -std=c++17 -fno-exceptions -fno-rtti -Wall -Wextra -Werror -Wno-unused-function -Wno-unused-variable -Wno-misleading-indentation
'''.format(game=ROOT/'rally-game/include',production=ROOT/'rally-production/include')
    (work/'Makefile').write_text(make)
    env=dict(os.environ,PATH='/Agon/agondev/release/bin:'+os.environ['PATH'])
    run=subprocess.run(['make','-C',str(work),'-j2'],env=env,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
    (HERE/'BUILD.txt').write_text(run.stdout)
    assert run.returncode==0,run.stdout
    mapping=(work/'bin/probe.map').read_text();sections={}
    for n in ('init_array','ctors','dtors','fini_array'):
        m=re.search(r'^\.'+n+r'\s+0x[0-9a-f]+\s+(0x[0-9a-f]+)',mapping,re.M);assert m and int(m[1],16)==0,n
    for m in re.finditer(r'^\.(text|rodata|data|bss)\s+(0x[0-9a-f]+)\s+(0x[0-9a-f]+)',mapping,re.M):
        name,start,n=m[1],int(m[2],16),int(m[3],16);assert 0x40000<=start and start+n<=0xa0000,(name,start,n)
        sections[name]=dict(start=start,bytes=n,end=start+n)
    for base in ('src','include','bin'):
        for p in (work/base).iterdir():
            if base=='bin' and p.name not in ('probe.bin','probe.map'):continue
            dst=HERE/'guest'/base/p.name;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,dst)
    registry={}
    original=CONTROL/'fixtures-smoke60/compact'
    for case,count in [('small',1),('full',901)]:
        dst=HERE/'fixtures'/case;dst.mkdir(parents=True,exist_ok=True)
        for p in original.iterdir():
            if p.name in ('expected.json','probe.bin'):continue
            shutil.copyfile(p,dst/p.name)
        shutil.copyfile(work/'bin/probe.bin',dst/'probe.bin')
        for n in ('index.bin','index.vdu','plan.bin','generation.vdu'):shutil.copyfile(HERE/n,dst/n)
        (dst/'capacity.cfg').write_bytes(b'R3CP'+struct.pack('<HH',count,1))
        meta=dict(schema=1,kind='prepared_capacity',requested=count,table_sha256=sha(HERE/'index.bin'),
            recipe_freeze_sha256=sha(HERE/'RECIPE-FREEZE.json'),module_sha256=frozen['baseline_module_sha256'],
            guest_sha256=sha(dst/'probe.bin'),fps_measured=False)
        meta['files']={p.name:sha(p) for p in dst.iterdir() if p.name!='expected.json'}
        (dst/'expected.json').write_text(json.dumps(meta,indent=2)+'\n')
        registry[case]=dict(directory=str(dst.relative_to(HERE)),files={p.name:sha(p) for p in dst.iterdir()},
            module_sha256=frozen['baseline_module_sha256'],diagnostic=False,foreground_paced=False)
    (HERE/'FIXTURES.json').write_text(json.dumps(registry,indent=2)+'\n')
    result=dict(schema=1,guest_sha256=sha(work/'bin/probe.bin'),module_sha256=frozen['baseline_module_sha256'],
        sections=sections,source_sha256={str(p.relative_to(HERE/'guest')):sha(p) for p in (HERE/'guest').rglob('*') if p.is_file()},
        detailed_extra_points=len(details),native_module_changed=False,capacity_only=True,no_emulator_launched=True)
    (HERE/'BUILD.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))


if __name__=='__main__':build()
