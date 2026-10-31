"""Isolated publication-checked module and one config-switched race guest."""
from pathlib import Path
import hashlib,json,os,re,shutil,struct,subprocess,sys

HERE=Path(__file__).resolve().parent
CUSTOM=HERE.parents[1]
RACE=CUSTOM/'full-race'
AFF=CUSTOM/'affine-race'
PACED=CUSTOM/'paced-road'
ROOT=CUSTOM.parents[3]
WORK=HERE/'.work'
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()

def write(path,data):
    path.parent.mkdir(parents=True,exist_ok=True)
    if path.exists():assert path.read_bytes()==data,('Preserve old input',str(path))
    else:path.write_bytes(data)

def save(path,obj):write(path,(json.dumps(obj,indent=2)+'\n').encode())

def module():
    old=json.loads((AFF/'BUILD.json').read_text())['additive']
    package=WORK/'package';src=AFF/old['package']
    for n,h in old['source_files'].items():
        assert sha(src/n)==h,n
        write(package/n,(src/n).read_bytes())
    original=(package/'native.c').read_text()
    assert sha(package/'native.c')=='94d92d109f9b3b93e8ddfea1427edcdeb9059a87636a6bacfd93d3c3894a1992'
    needle='__attribute__((visibility("default")))'
    assert original.count(needle)==1
    checked=original.replace(needle,'#include "publication.inc"\n'+needle)
    needle='uint8_t*state=view.data;put(state+12,0);'
    assert checked.count(needle)==1
    checked=checked.replace(needle,needle+'\nuint32_t r28_next_generation=get32(state+20)+1u,r28_next_request=get32(state+296)+1u;')
    needle='return h->buffer_release(h->context,view.lease);\n}'
    assert checked.count(needle)==1
    checked=checked.replace(needle,'if(r->entry_id==15){rc=r28_check_publication(h,state,r28_next_generation,r28_next_request);if(rc){int32_t rr=h->buffer_release(h->context,view.lease);return rr?rr:rc;}}\n'+needle)
    write(package/'checked.c',checked.encode())
    write(package/'publication.inc',(HERE/'publication.inc').read_bytes())
    out=HERE/'target'
    run=subprocess.run([sys.executable,str(PACED/'control/sdk/tools/build_module.py'),str(package/'checked.c'),
        '--name','rally-render','--build-id','0x52385231','--output',str(out),
        '--text-limit','32768','--data-limit','4096','--stack-limit','2048','--image-limit','65536'],
        text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
    (HERE/'MODULE-BUILD.txt').write_text(run.stdout)
    assert run.returncode==0,run.stdout
    return json.loads(run.stdout)['module']

def guest():
    work=WORK/'guest'
    for n in ('callback.asm','timing_prt.asm','main.cpp'):
        data=(RACE/'guest'/n).read_bytes()
        if n=='main.cpp':
            text=data.decode()
            # Set the compact policy only inside the timed loop; both warm
            # renders and optional effect coverage retain all diagnostics.
            needle='        times[0]=fs::now();prts[0]=fs::timer();'
            assert text.count(needle)==1
            text=text.replace(needle,'        fs::reducedReads=fs::compactConfigured;\n'+needle)
            needle='        timedSend=fs::sendMs;timedWait=fs::waitMs;timedWire=fs::wireBytes;'
            assert text.count(needle)==1
            text=text.replace(needle,'        fs::reducedReads=false;\n'+needle)
            data=text.encode()
        write(work/'src'/n,data)
    text=(RACE/'guest/native.hpp').read_text()
    text=text.replace('bool pending=false,','bool compactConfigured=false,reducedReads=false;\nbool pending=false,',1)
    needle='get16(b+12)||get16(b+14)'
    assert text.count(needle)==1
    text=text.replace(needle,'get16(b+12)>1||get16(b+14)')
    text=text.replace('frameCount=get16(b+6);','compactConfigured=get16(b+12)==1;frameCount=get16(b+6);',1)
    needle='++request;expect(Completion,44,1);expect(Completion,16,uint16_t(request));expect(Completion,20,uint16_t(world));expect(Root,20,uint16_t(generation));'
    assert text.count(needle)==1
    text=text.replace(needle,'++request;if(!reducedReads){expect(Completion,44,1);expect(Completion,16,uint16_t(request));expect(Completion,20,uint16_t(world));expect(Root,20,uint16_t(generation));}')
    write(work/'include/native.hpp',text.encode())
    for n,src in [('bindings.hpp',RACE/'bindings.hpp'),('presentation-functions.inc',RACE/'.work/presentation/include/presentation-functions.inc')]:
        write(work/'include'/n,src.read_bytes())
    make='''NAME=probe
LDHAS_ARG_PROCESSING=0
LDHAS_EXIT_HANDLER=0
include /Agon/agondev/release/config/makefile.inc
CFLAGS += -I{game} -I{production}
CXXFLAGS += -std=c++17 -fno-exceptions -fno-rtti -Wall -Wextra -Werror -Wno-unused-function -Wno-unused-variable -Wno-misleading-indentation
'''.format(game=ROOT/'rally-game/include',production=ROOT/'rally-production/include')
    write(work/'Makefile',make.encode())
    env=dict(os.environ,PATH='/Agon/agondev/release/bin:'+os.environ['PATH'])
    run=subprocess.run(['make','-C',str(work),'-j2'],env=env,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
    (HERE/'GUEST-BUILD.txt').write_text(run.stdout)
    assert run.returncode==0,run.stdout
    mapping=(work/'bin/probe.map').read_text();sections={}
    for n in ('init_array','ctors','dtors','fini_array'):
        m=re.search(r'^\.'+n+r'\s+0x[0-9a-f]+\s+(0x[0-9a-f]+)',mapping,re.M)
        assert m and int(m[1],16)==0,n
    for m in re.finditer(r'^\.(text|rodata|data|bss)\s+(0x[0-9a-f]+)\s+(0x[0-9a-f]+)',mapping,re.M):
        name,start,n=m[1],int(m[2],16),int(m[3],16)
        assert 0x40000<=start and start+n<=0xa0000,(name,start,n)
        sections[name]={'start':start,'bytes':n,'end':start+n}
    assert 'text' in sections and 'bss' in sections
    for n in ('probe.bin','probe.map'):write(HERE/'guest'/n,(work/'bin'/n).read_bytes())
    # Durable generated sources allow review without ignored build paths.
    for base in ('src','include'):
        for p in (work/base).iterdir():write(HERE/'guest'/base/p.name,p.read_bytes())
    return {'binary_sha256':sha(HERE/'guest/probe.bin'),'sections':sections,
            'source_sha256':{str(p.relative_to(work)):sha(p) for p in work.rglob('*') if p.is_file() and p.suffix in ('.cpp','.hpp','.asm','.inc')}}

def build():
    m=module();g=guest()
    result={}
    image=(HERE/'target/rally-render.vdpl').read_bytes()
    prefix=b'\x17\0\xa0'+struct.pack('<H',50305)
    for frames in (60,900):
        registry={}
        for name,flag in [('diagnostic',0),('compact',1)]:
            src=AFF/('fixtures' if frames==900 else 'fixtures-smoke60')/'additive'
            dst=HERE/('fixtures' if frames==900 else 'fixtures-smoke60')/name
            for p in src.iterdir():
                if p.name!='expected.json':write(dst/p.name,p.read_bytes() if p.name not in ('probe.bin','module.vdu','config.bin') else
                    {'probe.bin':(HERE/'guest/probe.bin').read_bytes(),'module.vdu':prefix+b'\2'+prefix+b'\0'+struct.pack('<H',len(image))+image,
                    'config.bin':b'R28F'+struct.pack('<HHIHH',1,frames,len(image),flag,0)}[p.name])
            meta=json.loads((src/'expected.json').read_text())
            meta.update(candidate=name,module_sha256=sha(HERE/'target/rally-render.vdpl'),module_bytes=len(image),
                diagnostic_reads_per_timed_frame=4 if not flag else 0,transactions_per_timed_frame=6 if not flag else 2,
                native_publication_checked=True,config_flags=flag)
            meta['files']={p.name:sha(p) for p in dst.iterdir() if p.name!='expected.json'}
            write(dst/'expected.json',(json.dumps(meta,indent=2)+'\n').encode())
            registry[name]=dict(directory=str(dst.relative_to(HERE)),files={p.name:sha(p) for p in dst.iterdir()},
                module_sha256=meta['module_sha256'],diagnostic=False,foreground_paced=False)
        differences=[n for n in registry['diagnostic']['files'] if registry['diagnostic']['files'][n]!=registry['compact']['files'][n]]
        assert set(differences)=={'config.bin','expected.json'},differences
        save(HERE/('FIXTURES.json' if frames==900 else 'SMOKE-FIXTURES.json'),registry)
    for p in (WORK/'package').rglob('*'):
        if p.is_file():write(HERE/'source'/p.relative_to(WORK/'package'),p.read_bytes())
    result.update(module=m,guest=g,baseline_checkpoint='fa7932d',
        original_native_sha256=sha(WORK/'package/native.c'),checked_native_sha256=sha(WORK/'package/checked.c'),
        publication_sha256=sha(HERE/'publication.inc'),common_module=True,common_guest=True,
        fixture_differences=['config.bin','expected.json'],original_firmware_unchanged=True)
    save(HERE/'BUILD.json',result)
    print(json.dumps({'module_sha256':m['sha256'],'module_bytes':len(image),'guest':g['binary_sha256']},indent=2))

if __name__=='__main__':build()
