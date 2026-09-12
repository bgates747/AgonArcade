"""Reproduce the reviewed RALLY-13/RALLY-18 oracle locally without SSH or GUI."""
from pathlib import Path
import hashlib,json,shutil,subprocess,sys
TASK=Path(__file__).resolve().parent;REPO=TASK.parents[2];BASE=TASK.parent/'RALLY-18';HANDLING=TASK.parent/'RALLY-13'
sys.path.insert(0,str(BASE));import build as baseline
ROOT=TASK/'.work/oracle'
EXPECTED='03322954c8c4fe29d90eaa0706c9169b242cdd264ea3b7b287cece58a6469d79'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def generate():
    ROOT.mkdir(parents=True,exist_ok=False)
    shutil.copy2(REPO/'rally/Makefile',ROOT/'Makefile')
    for name in ('src','include','tests'):
        shutil.copytree(REPO/'rally'/name,ROOT/name)
    for h in BASE.glob('*.hpp'):shutil.copy2(h,ROOT/'include'/h.name)
    shutil.copy2(HANDLING/'tuning.hpp',ROOT/'include/tuning.hpp')
    road=ROOT/'include/road.hpp'
    s='#include "tuning.hpp"\n'+road.read_text()
    s=s.replace('(position+speed)','(position+speed*WorldSpeedMultiplier)').replace('(phase+speed)','(phase+speed*WorldSpeedMultiplier)')
    s=s.replace('    int grip=60;','    int grip=60;\n    bool cornerAssist=true; // Demo/legacy default; manual play explicitly disables.')
    old='int32_t required=(wanted-lateralVelocity)*100/12+centripetal;';assert old in s
    s=s.replace(old,'int32_t required=(wanted-lateralVelocity)*100/12;\n        if(cornerAssist) required+=centripetal;')
    road.write_text(s.replace('if(speed>224) speed=224;','if(speed>300) speed=300;'))
    p=ROOT/'include/traffic.hpp';p.write_text('#include "tuning.hpp"\n'+p.read_text().replace('(position+speed)','(position+speed*WorldSpeedMultiplier)'))
    p=ROOT/'tests/test_road.cpp';p.write_text(p.read_text().replace('assert(m.speed==224);','assert(m.speed==300);'))
    for p in (ROOT/'tests').glob('*.cpp'):p.write_text('#define RALLY_WORLD_SPEED_MULTIPLIER 1\n'+p.read_text())
    s=baseline.source('lookup').replace('bool perspective=false,','bool autosteer=false;\nbool perspective=false,')
    s=s.replace('        if(strcmp(argv[i],"perspective")==0)','        if(strcmp(argv[i],"autosteer")==0)autosteer=true;\n        else if(strcmp(argv[i],"perspective")==0)')
    old='if(demoMode) demoDriver.tick(motion);else motion.tick(up,down);';assert old in s
    (ROOT/'src/main.cpp').write_text(s.replace(old,'motion.cornerAssist=demoMode||autosteer;\n            '+old))
if __name__=='__main__':
    if not ROOT.exists():generate()
    archive=Path('/home/smith/Agon/mystuff/rally-mac-build.yVdOx4')
    inputs=[ROOT/'Makefile',*sorted((ROOT/'src').glob('*')), *sorted((ROOT/'include').glob('*')), *sorted((ROOT/'tests').glob('*'))]
    for p in inputs:
        q=archive/p.relative_to(ROOT)
        if q.is_file() and sha(p)!=sha(q):raise RuntimeError(f'Oracle source differs from reviewed build: {p}')
    evidence=TASK/'evidence';evidence.mkdir(exist_ok=True)
    with (evidence/'oracle-build-tests.txt').open('w') as log:
        subprocess.run(['make','-B'],cwd=ROOT,stdout=log,stderr=subprocess.STDOUT,check=True)
        subprocess.run(['make','test'],cwd=ROOT,stdout=log,stderr=subprocess.STDOUT,check=True)
        subprocess.run(['g++','-std=c++17','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-g','-I'+str(ROOT/'include'),str(HANDLING/'test_handling.cpp'),'-o',str(ROOT/'obj/test_handling')],stdout=log,stderr=subprocess.STDOUT,check=True)
        subprocess.run([str(ROOT/'obj/test_handling')],stdout=log,stderr=subprocess.STDOUT,check=True)
    assert sha(ROOT/'bin/rally.bin')==EXPECTED,'Reviewed binary mismatch'
    runtime=Path.home()/'Agon/mystuff/AgonJukebox/.emulator/runtime/fab-1.2.4'
    manifest={'oracle_commit':'949f6186853ab99f257906e95786593a7a2e098f','binary_sha256':EXPECTED,'binary_bytes':(ROOT/'bin/rally.bin').stat().st_size,'generated_inputs':{str(p.relative_to(ROOT)):sha(p) for p in inputs},'data':{p.name:sha(p) for p in (BASE/'data').glob('*.road')},'runtime':{str(p):sha(p) for p in (runtime/'fab-agon-emulator',runtime/'firmware/vdp_platform.so',runtime/'firmware/mos_platform.bin')},'tools':{name:subprocess.check_output([name,'--version'],text=True).splitlines()[0] for name in ('g++','ez80-none-elf-clang','uv')},'python':sys.version,'test_log':'oracle-build-tests.txt'}
    (evidence/'foundation.json').write_text(json.dumps(manifest,indent=2)+'\n')
    print('Reviewed oracle reproduced byte-for-byte:',EXPECTED)
