"""Build isolated target actual-physics fixture and host wire/reference tools."""
from pathlib import Path
import hashlib,json,os,re,shutil,subprocess
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[4];WORK=HERE/'.work';SDK=Path('/Agon/agondev')
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
def run(cmd,**kw):subprocess.run(cmd,check=True,**kw)
def build():
    WORK.mkdir(exist_ok=True);inc=WORK/'include';inc.mkdir(exist_ok=True)
    shutil.copyfile(ROOT/'rally-game/src/main.cpp',inc/'product_main.cpp')
    target=WORK/'target';(target/'src').mkdir(parents=True,exist_ok=True)
    for p in (HERE/'src').iterdir():
        if p.name not in ('host.cpp','cpu.cpp','sink.cpp'):shutil.copyfile(p,target/'src'/p.name)
    shutil.copyfile(ROOT/'rally-game/src/timing_prt.asm',target/'src/timing_prt.asm')
    # Preserve idle timer reload/control as well as routing; vector is restored
    # with the public MOS API and independently checked by its return value.
    p=target/'src/timing_prt.asm';s=p.read_text().replace('    in0 a,(0x92)\n    ld (saved_iss),a','    in0 a,(0x83)\n    ld (saved_ctl),a\n    in0 a,(0x84)\n    ld (saved_low),a\n    in0 a,(0x85)\n    ld (saved_high),a\n    in0 a,(0x92)\n    ld (saved_iss),a',1)
    s=s.replace('_timing_release:\n','_timing_release:\n    ld a,(saved_low)\n    out0 (0x84),a\n    ld a,(saved_high)\n    out0 (0x85),a\n    ld a,(saved_ctl)\n    and 0x7e\n    out0 (0x83),a\n',1).replace('saved_iss: .db 0','saved_iss: .db 0\nsaved_ctl: .db 0\nsaved_low: .db 0\nsaved_high: .db 0')
    p.write_text(s)
    flags=f'-I{inc} -I{ROOT}/rally-game/include -I{ROOT}/rally-production/include'
    (target/'Makefile').write_text('NAME=capacity\nLDHAS_ARG_PROCESSING=0\nLDHAS_EXIT_HANDLER=0\ninclude /Agon/agondev/release/config/makefile.inc\n'+f'CXXFLAGS += -std=c++17 -fno-exceptions -fno-rtti -Wall -Wextra -Werror {flags}\n')
    env=dict(os.environ,PATH=str(SDK/'release/bin')+':'+os.environ['PATH']);run(['make','-C',str(target)],env=env)
    mapping=(target/'bin/capacity.map').read_text()
    for section in ('init_array','ctors','dtors','fini_array'):
        m=re.search(r'^\.'+section+r'\s+0x[0-9a-f]+\s+(0x[0-9a-f]+)',mapping,re.M);assert m and int(m[1],16)==0,section
    hostinc=WORK/'hostinclude';hostinc.mkdir(exist_ok=True)
    if not (hostinc/'agon').exists():(hostinc/'agon').symlink_to(SDK/'release/include/agon',target_is_directory=True)
    prefix=WORK/'hostprefix.hpp';prefix.write_text('#include <stdint.h>\n#include <stdio.h>\n#include <stdlib.h>\n#include <stdbool.h>\ntypedef uint32_t uint24_t;\ntypedef int32_t int24_t;\n#pragma pack(push,1)\n#include <agon/vdp.h>\n#pragma pack(pop)\n')
    names=set(re.findall(r'\b(vdp_\w+)\s*\(', (inc/'product_main.cpp').read_text()));names.add('vdp_vdu')
    sources=[SDK/'src/lib/libvdp'/(n+'.c') for n in sorted(names) if (SDK/'src/lib/libvdp'/(n+'.c')).exists()]
    cpu=WORK/'cpu';(cpu/'src').mkdir(parents=True,exist_ok=True)
    for name in ('workload.hpp','scene_workload.hpp'):shutil.copyfile(HERE/'src'/name,cpu/'src'/name)
    shutil.copyfile(HERE/'src/sink.cpp',cpu/'src/sink.cpp');shutil.copyfile(HERE/'src/cpu.cpp',cpu/'src/main.cpp');shutil.copyfile(target/'src/timing_prt.asm',cpu/'src/timing_prt.asm')
    for source in sources:shutil.copyfile(source,cpu/'src'/source.name)
    (cpu/'Makefile').write_text('NAME=wirecpu\nLDHAS_ARG_PROCESSING=0\nLDHAS_EXIT_HANDLER=0\ninclude /Agon/agondev/release/config/makefile.inc\n'+f'CFLAGS += {flags} -Dmos_puts=census_puts -Dputch=census_putch\nCXXFLAGS += {flags} -Dmos_puts=census_puts -Dputch=census_putch -std=c++17 -fno-exceptions -fno-rtti -Wall -Wextra -Werror\n')
    run(['make','-C',str(cpu)],env=env)
    base=['c++','-std=c++17','-ffunction-sections','-fdata-sections','-Wl,--gc-sections','-include',str(prefix),'-I'+str(hostinc),*flags.split()]
    for mode,extra in [('ordinary',['-O2']),('sanitized',['-O1','-g','-fsanitize=address,undefined','-fno-omit-frame-pointer'])]:
        run(base+extra+[str(HERE/'src/host.cpp'),*map(str,sources),'-o',str(WORK/('host-'+mode))])
    inputs=[HERE/'build.py',*sorted((HERE/'src').iterdir()),ROOT/'rally-game/src/main.cpp',ROOT/'rally-game/src/timing_prt.asm',*sorted((ROOT/'rally-game/include').glob('*.hpp')),*sorted((ROOT/'rally-production/include').glob('*.hpp')),*sources,SDK/'release/include/agon/vdp.h',SDK/'release/include/agon/mos.h']
    receipt={'inputs':{str(p):sha(p) for p in inputs},'cpu_binary':sha(cpu/'bin/wirecpu.bin'),'target_binary':sha(target/'bin/capacity.bin'),'target_bytes':(target/'bin/capacity.bin').stat().st_size,'host_sdk_sources':[str(p) for p in sources],'target_generated_timer':sha(target/'src/timing_prt.asm')}
    (WORK/'build.json').write_text(json.dumps(receipt,indent=2)+'\n');print(json.dumps({k:v for k,v in receipt.items() if k!='inputs'},indent=2))
if __name__=='__main__':build()
