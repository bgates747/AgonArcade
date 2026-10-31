"""Separate setup guest and60-frame functional fixtures; no emulator launch."""
from pathlib import Path
import difflib
import hashlib
import json
import os
import re
import shlex
import shutil
import struct
import subprocess

HERE=Path(__file__).resolve().parent
CUSTOM=HERE.parents[1]
CONTROL=CUSTOM/'incremental/round-trips'
CAPACITY=HERE.parent/'capacity-02'
RUNTIME=HERE.parent/'runtime'
ROOT=HERE.parents[5]
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()


def change(text,old,new):
    assert text.count(old)==1,old[:100]
    return text.replace(old,new)


def build():
    for directory,manifest in [(CAPACITY,'READINESS-FREEZE.json'),(RUNTIME,'RUNTIME-FREEZE.json')]:
        for n,h in json.loads((directory/manifest).read_text())['files'].items():assert sha(directory/n)==h,n
    image=RUNTIME/'target/rally-prepared.vdpl'
    assert sha(image)=='f3a1f8d01a9cef835d165fc92747f28a00b0d2645592c106c6682de0dc6c055b'
    work=HERE/'.work/guest'
    for base in ('src','include'):
        for p in (CONTROL/'guest'/base).iterdir():
            dst=work/base/p.name;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,dst)
    p=work/'include/native.hpp';old=p.read_text();s=old
    s=change(s,'namespace fs {','namespace prepared_setup {void loaded();bool install();void finish();}\nnamespace fs {')
    s=change(s,'transcript[100000]','transcript[220000]')
    needle='handle=transaction(1,p,sizeof p,2);if(!handle){fail("Native LOAD");return false;}'
    s=change(s,needle,needle+'prepared_setup::loaded();if(!healthy)return false;')
    s=change(s,'    set32(Root,8,7);invoke(Init);return healthy;',
        '    if(!prepared_setup::install())return false;\n    set32(Root,8,7);invoke(Init);return healthy;')
    s=change(s,'if(installed&&!pending){mos_setkbvector(nullptr,0);',
        'if(installed&&!pending){prepared_setup::finish();mos_setkbvector(nullptr,0);')
    p.write_text(s)
    native_diff=''.join(difflib.unified_diff(old.splitlines(True),s.splitlines(True),fromfile='control/native.hpp',tofile='prepared/native.hpp'))
    p=work/'src/main.cpp';old=p.read_text();s=old
    s=change(s,'int main(){','#include "capacity.hpp"\n#include "setup.hpp"\nint main(){')
    s=change(s,'    clearOutputs();prepareRace();','    clearOutputs();prepared_setup::begin();prepareRace();')
    needle='    warmLower();paint();warmLower();paint();if(!fs::healthy)goto failed;'
    s=change(s,needle,needle+'\n    if(!prepared_setup::ready())goto failed;')
    s=change(s,'        times[0]=fs::now();prts[0]=fs::timer();',
        '        prepared_setup::steadyBegin();\n        times[0]=fs::now();prts[0]=fs::timer();')
    s=change(s,'        uint16_t stackAfter=fs::transaction(4,q,2,4);unsigned at=0;',
        '        prepared_setup::steadyEnd();\n        uint16_t stackAfter=fs::transaction(4,q,2,4);prepared_setup::raceEnd();if(!fs::healthy)goto failed;unsigned at=0;')
    p.write_text(s)
    main_diff=''.join(difflib.unified_diff(old.splitlines(True),s.splitlines(True),fromfile='control/main.cpp',tofile='prepared/main.cpp'))
    # Exact original timed-loop source, including its clock brackets, remains.
    start='        times[0]=fs::now();prts[0]=fs::timer();'
    end='        fs::reducedReads=false;'
    assert old[old.index(start):old.index(end)]==s[s.index(start):s.index(end)]
    for n in ('capacity.hpp','recipe-pins.hpp','protocol.hpp'):
        shutil.copyfile(CAPACITY/n,work/'include'/n)
    shutil.copyfile(CAPACITY/'guest/include/capacity-details.hpp',work/'include/capacity-details.hpp')
    shutil.copyfile(HERE/'setup.hpp',work/'include/setup.hpp')
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
    (HERE/'BUILD.txt').write_text(run.stdout);assert run.returncode==0,run.stdout
    sections={};mapping=(work/'bin/probe.map').read_text()
    for name in ('init_array','ctors','dtors','fini_array'):
        m=re.search(r'^\.'+name+r'\s+0x[0-9a-f]+\s+(0x[0-9a-f]+)',mapping,re.M);assert m and int(m[1],16)==0,name
    for m in re.finditer(r'^\.(text|rodata|data|bss)\s+(0x[0-9a-f]+)\s+(0x[0-9a-f]+)',mapping,re.M):
        name,start,n=m[1],int(m[2],16),int(m[3],16);assert 0x40000<=start and start+n<=0xa0000,(name,start,n)
        sections[name]=dict(start=start,bytes=n,end=start+n)
    for base in ('src','include','bin'):
        for p in (work/base).iterdir():
            if base=='bin' and p.name not in ('probe.bin','probe.map'):continue
            dst=HERE/'guest'/base/p.name;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,dst)
    (HERE/'SOURCE-DIFF.patch').write_text(native_diff+main_diff)
    # Compiler-derived transitive dependency closure, including SDK headers.
    compiler=Path('/Agon/agondev/release/bin/ez80-none-elf-clang')
    dependencies=work/'closure.d'
    subprocess.run([str(compiler),'-target','ez80-none-elf','-DAGONDEV','-nostdinc','-std=c++17',
        '-Oz','-fno-exceptions','-fno-rtti','-fno-threadsafe-statics',
        '-I'+str(work/'include'),'-I'+str(ROOT/'rally-game/include'),'-I'+str(ROOT/'rally-production/include'),
        '-isystem','/Agon/agondev/release/include','-isystem','/Agon/agondev/release/include/c++',
        '-M','-MF',str(dependencies),str(work/'src/main.cpp')],check=True)
    closure=shlex.split(dependencies.read_text().replace('\\\n',' ').split(':',1)[1])
    files={str(Path(n).resolve()):sha(Path(n)) for n in closure}
    for n in ('config/makefile.inc','config/linker.conf','lib/libagon.a','bin/ez80-none-elf-clang',
              'bin/ez80-none-elf-as','bin/ez80-none-elf-ld','bin/agondev-setname'):
        tool=Path('/Agon/agondev/release')/n;files[str(tool.resolve())]=sha(tool)
    (HERE/'SOURCE-CLOSURE.json').write_text(json.dumps(dict(files=files,
        local_assembly_sources={n:sha(work/'src'/n) for n in ('callback.asm','timing_prt.asm')},
        compiler_derived=True),indent=2)+'\n')
    original=CONTROL/'fixtures-smoke60/compact';registry={}
    for case in ('compact','prepared'):
        dst=HERE/'fixtures'/case;shutil.copytree(original,dst,dirs_exist_ok=True)
        if case=='prepared':
            shutil.copyfile(work/'bin/probe.bin',dst/'probe.bin')
            module=image.read_bytes();prefix=b'\x17\0\xa0'+struct.pack('<H',50305)
            (dst/'module.vdu').write_bytes(prefix+b'\2'+prefix+b'\0'+struct.pack('<H',len(module))+module)
            (dst/'config.bin').write_bytes(b'R28F'+struct.pack('<HHIHH',1,60,len(module),1,0))
            for n in ('index.bin','index.vdu','plan.bin','generation.vdu'):shutil.copyfile(CAPACITY/n,dst/n)
            (dst/'capacity.cfg').write_bytes(b'R3CP'+struct.pack('<HH',901,1))
            meta=json.loads((dst/'expected.json').read_text())
            meta.update(candidate='prepared',module_sha256=sha(image),module_bytes=len(module),
                prepared_set=True,setup_before_init=True,timing_excluded=True,
                common_guest=False,additive_sampler=False,prepared_bitmap_set=True,
                generated_simulation_source_sha256=meta['native_source_sha256'],
                native_source_sha256=sha(RUNTIME/'source/checked.c'),
                config_format='R28F,u16 schema1,u16 frames,u32 module bytes,u16 compact flag1,u16 reserved0',
                functional_only=True,expected_private_images=901,private_counter_buffer=51996,
                guest_sha256=sha(dst/'probe.bin'),recipe_freeze_sha256=sha(CAPACITY/'RECIPE-FREEZE.json'))
            meta['files']={p.name:sha(p) for p in dst.iterdir() if p.name!='expected.json'}
            (dst/'expected.json').write_text(json.dumps(meta,indent=2)+'\n')
        else:
            assert all(p.read_bytes()==(dst/p.name).read_bytes() for p in original.iterdir())
            assert set(p.name for p in original.iterdir())==set(p.name for p in dst.iterdir())
        registry[case]=dict(directory=str(dst.relative_to(HERE)),files={p.name:sha(p) for p in dst.iterdir()},
            module_sha256=sha(image) if case=='prepared' else '479fe1ac99bb2895af8a8b6cca49b90cb5c346a56a5f9e4020cab0b23c933918',
            diagnostic=False,foreground_paced=False,functional_only=True)
    (HERE/'FIXTURES.json').write_text(json.dumps(registry,indent=2)+'\n')
    # References are existing independently-qualified control worlds, unchanged.
    shutil.copyfile(CONTROL/'EXPECTED-FINAL-60.json',HERE/'EXPECTED-FINAL-60.json')
    result=dict(schema='rally.aff03.prepared-guest-build.v1',guest_sha256=sha(work/'bin/probe.bin'),sections=sections,
        native_package_sha256=sha(image),native_stack_audit_sha256=sha(RUNTIME/'STACK-AUDIT.json'),
        exact_control_fixture=True,exact_original_timed_loop_source=True,
        qualified_capacity_helpers_unchanged=True,
        source_sha256={str(p.relative_to(HERE/'guest')):sha(p) for p in (HERE/'guest').rglob('*') if p.is_file()},
        functional_frames=60,no_emulator_launched=True)
    (HERE/'BUILD.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(dict(guest=result['guest_sha256'],sections=sections,prepared_module=result['native_package_sha256'],control_byte_identical=True),indent=2))


if __name__=='__main__':build()
