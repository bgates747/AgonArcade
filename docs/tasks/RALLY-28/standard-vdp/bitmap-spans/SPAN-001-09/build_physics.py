from pathlib import Path
import shutil,re,subprocess,os,json,hashlib
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[5];W=HERE/'.work/physics';(W/'src').mkdir(parents=True,exist_ok=True);inc=W/'include';inc.mkdir(exist_ok=True)
cap=ROOT/'docs/tasks/RALLY-28/standard-vdp/capacity'
body=(cap/'src/main.cpp').read_text().replace('int main()','int physics_body()').replace('"done.txt"','"physics-done.txt"')
body=body.replace('    if(!rounds || rounds>1000 || !timing_claim())return 3;', '    if(!rounds || rounds>1000 || !writeFile(\"started.txt\",\"start\\n\") || !timing_claim())return 3;').replace('    mos_puts(\"CAP_END\",7,0);','    mos_puts(\"CAP_END\",7,0);writeFile(\"ended.txt\",\"end\\n\");')
body=body.replace('#include "workload.hpp"','#include "workload.hpp"\n#include "mode_lifecycle.hpp"')
road=(HERE.parent/'SPAN-001-07/src/main.cpp').read_text();a=road.index('struct ModeIO {');b=road.index('void prefix(',a)
mode=road[a:b].replace('sv[','physics_sv[').replace('clock()','getsysvar_time()')
# Main numerical body is unchanged; lifecycle is outside its CAP_BEGIN/END bracket.
body+='\nvolatile uint8_t *physics_sv;\n'+mode+'''\nint main(){const char*names[]={"summary.txt","state.csv","phases.csv","lifecycle.txt","done.txt","physics-done.txt","started.txt","ended.txt"};for(auto name:names){uint8_t f=mos_fopen(name,1);if(f){mos_fclose(f);return 22;}}physics_sv=mos_sysvars();ModeIO io;test_appliance::ModeSession<ModeIO> lifecycle(io);if(!lifecycle.begin({8,320,240,64}))return 20;puts("Rally actual physics capacity / mainboard /8192ticks");int result=physics_body();bool restored=lifecycle.restore();writeFile("lifecycle.txt",restored?"restored=1\\n":"restored=0\\n");if(!result&&restored)writeFile("done.txt","complete\\n");return result?result:restored?0:21;}\n'''
(W/'src/main.cpp').write_text(body)
for name in ('workload.hpp','physics_product.cpp'):shutil.copyfile(ROOT/'docs/tasks/RALLY-28/standard-vdp/candidates/evidence/generated'/name,inc/name)
shutil.copyfile(HERE.parent/'SPAN-001-07/src/mode_lifecycle.hpp',inc/'mode_lifecycle.hpp')
shutil.copyfile(HERE.parent/'SPAN-001-07/.work/src/timing_prt.asm',W/'src/timing_prt.asm')
(W/'Makefile').write_text('NAME=physics\nLDHAS_ARG_PROCESSING=0\nLDHAS_EXIT_HANDLER=0\ninclude /Agon/agondev/release/config/makefile.inc\nCXXFLAGS += -std=c++17 -fno-exceptions -fno-rtti -Wall -Wextra -Werror -Wno-unused-function -I'+str(ROOT/'rally-game/include')+' -I'+str(ROOT/'rally-production/include')+'\n')
subprocess.run(['make','-C',str(W)],check=True,env=dict(os.environ,PATH='/Agon/agondev/release/bin:'+os.environ['PATH']))
b=W/'bin/physics.bin';(HERE/'PHYSICS-BUILD.json').write_text(json.dumps({'sha256':hashlib.sha256(b.read_bytes()).hexdigest(),'bytes':b.stat().st_size,'workload':'same8192normal numerical ticks; new lifecycle wrapper'},indent=2)+'\n')
