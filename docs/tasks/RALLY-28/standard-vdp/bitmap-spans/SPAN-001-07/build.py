from pathlib import Path
import shutil,subprocess,os,json,hashlib,sys
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[5];sparse='--sparse' in sys.argv;WORK=HERE/('.work/sparse' if sparse else '.work');(WORK/'src').mkdir(parents=True,exist_ok=True);inc=WORK/'include';inc.mkdir(exist_ok=True)
for p in (HERE/'src').iterdir():shutil.copyfile(p,WORK/'src'/p.name)
shutil.copyfile(ROOT/'rally-game/src/timing_prt.asm',WORK/'src/timing_prt.asm')
p=WORK/'src/timing_prt.asm';s=p.read_text().replace('    in0 a,(0x92)\n    ld (saved_iss),a','    in0 a,(0x83)\n    ld (saved_ctl),a\n    in0 a,(0x84)\n    ld (saved_low),a\n    in0 a,(0x85)\n    ld (saved_high),a\n    in0 a,(0x92)\n    ld (saved_iss),a',1)
s=s.replace('_timing_release:\n','_timing_release:\n    ld a,(saved_low)\n    out0 (0x84),a\n    ld a,(saved_high)\n    out0 (0x85),a\n    ld a,(saved_ctl)\n    and 0x7e\n    out0 (0x83),a\n',1).replace('saved_iss: .db 0','saved_iss: .db 0\nsaved_ctl: .db 0\nsaved_low: .db 0\nsaved_high: .db 0');p.write_text(s)
for n in ('projection.hpp','projection_tables.hpp','buffered.hpp'):shutil.copyfile(HERE.parents[1]/'candidates/evidence/generated'/n,inc/n)
shutil.copyfile(HERE.parent/'SPAN-001-06/phase.hpp',inc/'phase.hpp');shutil.copyfile(HERE.parent/'SPAN-001-03/src/generated.hpp',inc/'generated.hpp')
(WORK/'Makefile').write_text('NAME=roadbench\nLDHAS_ARG_PROCESSING=0\nLDHAS_EXIT_HANDLER=0\ninclude /Agon/agondev/release/config/makefile.inc\nCXXFLAGS += -std=c++17 -fno-exceptions -fno-rtti -Wall -Wextra -Werror -I'+str(ROOT/'rally-production/include')+(' -DPOLYGON_SPARSE=1' if sparse else '')+'\n')
subprocess.run(['make','-C',str(WORK)],env=dict(os.environ,PATH='/Agon/agondev/release/bin:'+os.environ['PATH']),check=True)
b=WORK/'bin/roadbench.bin';(HERE/('SPARSE-BUILD.json' if sparse else 'BUILD.json')).write_text(json.dumps({'binary_sha256':hashlib.sha256(b.read_bytes()).hexdigest(),'bytes':b.stat().st_size,'polygon_sparse':sparse},indent=2)+'\n')
