"""Build only a private cached presenter; copy exact original control inputs."""
from pathlib import Path
import hashlib,json,os,re,shutil,subprocess,sys
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[5];CUSTOM=HERE.parents[1];CONTROL=HERE.parent/'round-trips'
sys.path.insert(0,str(CUSTOM/'full-race'))
from presentation_build import function
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()

def write(path,data):
    path.parent.mkdir(parents=True,exist_ok=True)
    if path.exists():assert path.read_bytes()==data,('Preserve prior file',str(path))
    else:path.write_bytes(data)

def main():
    preserved={}
    for name,digest in json.loads((CONTROL/'FROZEN-INPUTS.json').read_text()).items():
        assert sha(CONTROL/name)==digest,name;preserved[str(CONTROL/name)]=digest
    for name,digest in json.loads((CONTROL/'PROTECTED.json').read_text()).items():
        if name==str(ROOT/'rally-game/src/main.cpp'):continue # Explicitly released shared edit.
        assert sha(name)==digest,name;preserved[name]=digest
    old=(CONTROL/'guest/include/presentation-functions.inc').read_text()
    new=(ROOT/'rally-game/src/main.cpp').read_text()
    presentation=old
    for n in ('drawHud','bottom'):
        original=function(old,n);assert presentation.count(original)==1
        presentation=presentation.replace(original,function(new,n))
    work=HERE/'.work/guest'
    for path in (CONTROL/'guest').rglob('*'):
        if path.suffix not in ('.cpp','.hpp','.asm','.inc'):continue
        data=path.read_bytes();relative=path.relative_to(CONTROL/'guest')
        if relative.as_posix()=='src/main.cpp':
            text=data.decode();assert text.count('#include "hud.hpp"')==text.count('Hud hud;')==1
            data=text.replace('#include "hud.hpp"','#include "hud.hpp"\n#include "hud_format.hpp"').replace('Hud hud;','Hud hud;\nHudFormat hudFormat;').encode()
        if relative.as_posix()=='include/presentation-functions.inc':data=presentation.encode()
        write(work/relative,data)
    write(work/'include/hud_format.hpp',(ROOT/'rally-game/include/hud_format.hpp').read_bytes())
    write(work/'Makefile',(CONTROL/'.work/guest/Makefile').read_bytes())
    result=subprocess.run(['make','-C',str(work),'-j2'],env=dict(os.environ,PATH='/Agon/agondev/release/bin:'+os.environ['PATH']),
                          text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
    (HERE/'GUEST-BUILD.txt').write_text(result.stdout);assert result.returncode==0,result.stdout
    mapping=(work/'bin/probe.map').read_text();sections={}
    for n in ('init_array','ctors','dtors','fini_array'):
        m=re.search(r'^\.'+n+r'\s+0x[0-9a-f]+\s+(0x[0-9a-f]+)',mapping,re.M);assert m and int(m[1],16)==0,n
    for m in re.finditer(r'^\.(text|rodata|data|bss)\s+(0x[0-9a-f]+)\s+(0x[0-9a-f]+)',mapping,re.M):
        name,start,n=m[1],int(m[2],16),int(m[3],16);assert 0x40000<=start and start+n<=0xa0000
        sections[name]=dict(start=start,bytes=n,end=start+n)
    for p in work.rglob('*'):
        if p.is_file() and p.suffix in ('.cpp','.hpp','.asm','.inc'):write(HERE/'guest'/p.relative_to(work),p.read_bytes())
    for n in ('probe.bin','probe.map'):write(HERE/'guest'/n,(work/'bin'/n).read_bytes())
    assembly=HERE/'guest/probe.s'
    emit=json.loads((CUSTOM.parent/'research/phase-cost/assembly/EMISSION.json').read_text())['command']
    at=emit.index('-MD');emit=emit[:at]+['-S','src/main.cpp','-o',str(assembly)]
    subprocess.run(emit,cwd=work,check=True)
    guests={'control':sha(CONTROL/'guest/probe.bin'),'cached':sha(HERE/'guest/probe.bin')}
    for frames,source_dir,directory,registry in [(60,'fixtures-smoke60','fixtures-smoke60','SMOKE-FIXTURES.json'),(900,'fixtures','fixtures','FIXTURES.json')]:
        entries={}
        for case in ('control','cached'):
            source=CONTROL/source_dir/'compact';dest=HERE/directory/case
            for p in source.iterdir():
                if p.name=='expected.json':continue
                data=(HERE/'guest/probe.bin').read_bytes() if p.name=='probe.bin' and case=='cached' else p.read_bytes()
                write(dest/p.name,data)
            meta=json.loads((source/'expected.json').read_text())
            meta.update(candidate=case,common_guest=False,hud_format_cache=case=='cached')
            meta['files']={p.name:sha(p) for p in dest.iterdir() if p.name!='expected.json'}
            write(dest/'expected.json',(json.dumps(meta,indent=2)+'\n').encode())
            entries[case]=dict(directory=str(dest.relative_to(HERE)),files={p.name:sha(p) for p in dest.iterdir()},
                module_sha256=meta['module_sha256'],guest=case,diagnostic=False,foreground_paced=False)
        differences=[n for n,h in entries['control']['files'].items() if h!=entries['cached']['files'][n]]
        assert set(differences)=={'probe.bin','expected.json'},differences
        write(HERE/registry,(json.dumps(entries,indent=2)+'\n').encode())
    for n in ('EXPECTED-FINAL-60.json','EXPECTED-FINAL-900.json'):write(HERE/n,(CONTROL/n).read_bytes())
    report=dict(guests=guests,sections=sections,standard_game=json.loads((ROOT/'rally-game/bin/build.json').read_text()),
        input_sha256={str(p):sha(p) for p in [HERE/'build.py',ROOT/'rally-game/src/main.cpp',ROOT/'rally-game/include/hud_format.hpp',CONTROL/'target/rally-render.vdpl']},
        preserved_control_inputs=preserved,fixture_differences=['probe.bin','expected.json'],
        native_module_unchanged=True,firmware_unchanged=True,assembly_sha256=sha(assembly))
    write(HERE/'BUILD.json',(json.dumps(report,indent=2)+'\n').encode())
    print(json.dumps(dict(guests=guests,sections=sections,preserved_inputs=len(preserved)),indent=2))

if __name__=='__main__':main()
