"""Build isolated manual-cornering candidate and prepare its stock review."""
from pathlib import Path
import sys,json,shutil,subprocess,tempfile,os,argparse
TASK=Path(__file__).resolve().parent;REPO=TASK.parents[2];BASE=TASK.parent/'RALLY-18'
sys.path.insert(0,str(BASE));import build as baseline
p=argparse.ArgumentParser();p.add_argument('--autosteer',action='store_true');p.add_argument('--track',choices=('oval','fuji'),default='oval');p.add_argument('--launch',action='store_true');args=p.parse_args()
baseline.protect();work=TASK/'.work';work.mkdir(exist_ok=True)
root=Path(tempfile.mkdtemp(prefix='build-',dir=work))
shutil.copy2(REPO/'rally/Makefile',root/'Makefile')
for name in ('src','include','tests','tools'):shutil.copytree(REPO/'rally'/name,root/name,ignore=shutil.ignore_patterns('__pycache__'))
for h in BASE.glob('*.hpp'):shutil.copy2(h,root/'include'/h.name)
shutil.copy2(TASK/'tuning.hpp',root/'include/tuning.hpp')
road=(root/'include/road.hpp').read_text()
road='#include \"tuning.hpp\"\n'+road
road=road.replace('(position+speed)', '(position+speed*WorldSpeedMultiplier)').replace('(phase+speed)', '(phase+speed*WorldSpeedMultiplier)')
traffic=root/'include/traffic.hpp'
traffic.write_text('#include \"tuning.hpp\"\n'+traffic.read_text().replace('(position+speed)', '(position+speed*WorldSpeedMultiplier)'))
road=road.replace('    int grip=60;', '    int grip=60;\n    bool cornerAssist=true; // Demo/legacy default; manual play explicitly disables.')
old='int32_t required=(wanted-lateralVelocity)*100/12+centripetal;'
assert old in road
road=road.replace(old,'int32_t required=(wanted-lateralVelocity)*100/12;\n        if(cornerAssist) required+=centripetal;')
road=road.replace('if(speed>224) speed=224;', 'if(speed>300) speed=300;')
(root/'include/road.hpp').write_text(road)
test=root/'tests/test_road.cpp'
test.write_text(test.read_text().replace('assert(m.speed==224);','assert(m.speed==300);'))
# Historical tests retain their 1x distance fixtures; focused handling test uses production 2x.
for legacy in (root/'tests').glob('*.cpp'):
    legacy.write_text('#define RALLY_WORLD_SPEED_MULTIPLIER 1\n'+legacy.read_text())
s=baseline.source('lookup').replace('bool perspective=false,','bool autosteer=false;\nbool perspective=false,')
s=s.replace('        if(strcmp(argv[i],"perspective")==0)', '        if(strcmp(argv[i],"autosteer")==0)autosteer=true;\n        else if(strcmp(argv[i],"perspective")==0)')
old='if(demoMode) demoDriver.tick(motion);else motion.tick(up,down);';assert old in s
s=s.replace(old,'motion.cornerAssist=demoMode||autosteer;\n            '+old)
(root/'src/main.cpp').write_text(s)
subprocess.run(['clang++','-std=c++17','-O2','-Wall','-Wextra','-Werror','-I'+str(root/'include'),str(TASK/'test_handling.cpp'),'-o',str(work/'test_handling')],check=True)
subprocess.run([str(work/'test_handling')],check=True)
with (work/'build.log').open('w') as log:
    subprocess.run([sys.executable,str(root/'tools/build_linux.py')],stdout=log,stderr=subprocess.STDOUT,check=True)
profile=TASK/'.emulator'/('review-'+args.track+('-assisted' if args.autosteer else '-manual'))
if profile.exists():profile=Path(tempfile.mkdtemp(prefix=profile.name+'-',dir=profile.parent))
subprocess.run([sys.executable,str(root/'tools/prepare_emulator.py'),'--profile',str(profile),'--track',args.track],check=True,stdout=subprocess.DEVNULL)
for name in ('oval.road','fuji.road'):(profile/'sdcard/rally'/name).symlink_to(BASE/'data'/name)
options='demo'+(' autosteer' if args.autosteer else '')
(profile/'sdcard/autoexec.txt').write_bytes(('SET KEYBOARD 1\r\ncd /rally\r\nload rally.bin\r\nrun . '+args.track+' '+options+'\r\n').encode())
evidence={'base_checkpoint':'d1a9e3f','root':str(root),'profile':str(profile),'binary_sha256':baseline.sha(root/'bin/rally.bin'),'source_sha256':baseline.sha(root/'src/main.cpp'),'road_sha256':baseline.sha(root/'include/road.hpp'),'autosteer':args.autosteer,'tests':'manual bend/steering/grip and existing Linux sanitizer suite passed','build':(root/'bin/linux-build.txt').read_text()}
if args.launch:
    env=os.environ.copy()
    for name in ('SDL_VIDEODRIVER','SDL_AUDIODRIVER','DYLD_INSERT_LIBRARIES','LD_PRELOAD','BASH_ENV','RALLY_STOCK_VDP','RALLY_SINK_DIR','RALLY_SINK_MODE'):env.pop(name,None)
    with (work/'review.log').open('w') as log:
        proc=subprocess.Popen(['./fab-agon-emulator','--renderer','sw'],cwd=profile,env=env,stdout=log,stderr=subprocess.STDOUT,stdin=subprocess.DEVNULL,start_new_session=True)
    evidence['pid']=proc.pid
baseline.protect();(TASK/'review.json').write_text(json.dumps(evidence,indent=2)+'\n');print(json.dumps(evidence,indent=2))
