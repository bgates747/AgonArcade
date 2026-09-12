"""Task-local pavement experiment: isolated builds, headless checks, explicit review."""
from pathlib import Path
import argparse
import hashlib
import json
import os
import shutil
import subprocess
import sys
import tempfile
import time

TASK=Path(__file__).resolve().parent
REPO=TASK.parents[3]
MAIN=REPO/'rally'
WORK=TASK/'.work'
STATE=WORK/'active.json'
sys.path.insert(0,str(TASK.parent))
import run_timing

def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def fingerprint():
    files=[MAIN/'Makefile',MAIN/'bin/rally.bin']
    for name in ('src','include','tests','tools'):
        files.extend(p for p in (MAIN/name).rglob('*') if p.is_file() and '__pycache__' not in p.parts)
    return {str(p.relative_to(MAIN)):digest(p) for p in files}

def save(state):
    STATE.write_text(json.dumps(state,indent=2)+'\n')

def check_mainline(state):
    if fingerprint()!=state['mainline']:
        raise RuntimeError('Mainline differs from the experiment snapshot; stop and inspect.')

def build():
    WORK.mkdir(exist_ok=True)
    run=Path(tempfile.mkdtemp(prefix='build-',dir=WORK))
    state={'run':str(run),'mainline':fingerprint(),'variants':{}}
    # Snapshot both variants before any build, so they share the same inputs.
    for variant in ('full','pavement'):
        root=run/variant;root.mkdir()
        shutil.copy2(MAIN/'Makefile',root/'Makefile')
        for name in ('src','include','tests','tools'):
            shutil.copytree(MAIN/name,root/name,ignore=shutil.ignore_patterns('__pycache__'))
        state['variants'][variant]={'root':str(root)}
    root=Path(state['variants']['pavement']['root'])
    shutil.copy2(TASK/'pavement.hpp',root/'include/pavement.hpp')
    shutil.copy2(TASK/'test_pavement.cpp',root/'tests/test_pavement.cpp')
    source=root/'src/main.cpp';text=source.read_text()
    for old,new in (('#include "road.hpp"','#include "road.hpp"\n#include "pavement.hpp"'),
                    ('rally::Road road;','rally::PavementRoad road;')):
        if text.count(old)!=1: raise RuntimeError(f'Injection anchor changed: {old}')
        text=text.replace(old,new)
    source.write_text(text)
    with (root/'Makefile').open('a') as file:
        file.write('\n.PHONY: pavement-test\ntest: pavement-test\npavement-test:\n'
                   '\tmkdir -p obj\n'
                   '\tg++ -std=c++17 -Wall -Wextra -Werror -fsanitize=address,undefined -g -Iinclude tests/test_pavement.cpp -o obj/test_pavement\n'
                   '\t./obj/test_pavement\n')
    for variant,info in state['variants'].items():
        root=Path(info['root'])
        print('Building isolated',variant,flush=True)
        subprocess.run([sys.executable,str(root/'tools/build_linux.py')],check=True)
        info['binary_sha256']=digest(root/'bin/rally.bin')
        info['binary_bytes']=(root/'bin/rally.bin').stat().st_size
        info['linux_build']=(root/'bin/linux-build.txt').read_text()
    check_mainline(state);save(state)
    print('Built both variants; mainline sources and binary unchanged.',flush=True)

def bench(state):
    base=TASK/'.emulator';base.mkdir(exist_ok=True)
    output=Path(tempfile.mkdtemp(prefix='timing-',dir=base))
    runtime=Path.home()/'Agon/fab-agon-emulator'
    manifest={'variants':state['variants'],'mainline':state['mainline'],'runs':[],
              'headless':True,'clock_hz':120,'target_hz':60,
              'runtime':{str(p):digest(p) for p in
                         (runtime/'fab-agon-emulator',runtime/'firmware/vdp_platform.so',runtime/'firmware/mos_platform.bin')},
              'experiment_sources':{p.name:digest(p) for p in (TASK/'pavement.hpp',TASK/'test_pavement.cpp',Path(__file__))}}
    print('Timing evidence:',output,flush=True)
    for track in ('oval','fuji'):
        runs=[]
        for number,variant in enumerate(('full','pavement','pavement','full'),1):
            run_timing.ROOT=Path(state['variants'][variant]['root'])
            result=run_timing.run_case(output,f'{track}-{number:02d}-{variant}',track,'full',True,True)
            result.update(track=track,variant=variant)
            runs.append(result);manifest['runs'].append(result)
            (output/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
        if len({r['metadata']['pose_hash'] for r in runs})!=1: raise RuntimeError('Pose mismatch')
        for variant in ('full','pavement'):
            if len({r['metadata']['road_bytes'] for r in runs if r['variant']==variant})!=1:
                raise RuntimeError('Unstable command bytes')
    check_mainline(state)
    results=TASK/'results';results.mkdir(exist_ok=True)
    for p in [output/'manifest.json',*output.glob('*.csv')]: shutil.copy2(p,results/p.name)
    state['timing']=str(output);save(state)

def prepare(state,profile,track='oval'):
    root=Path(state['variants']['pavement']['root'])
    subprocess.run([sys.executable,str(root/'tools/prepare_emulator.py'),
                    '--profile',str(profile),'--track',track,'--fence','--fixed-bands'],check=True,stdout=subprocess.DEVNULL)

def capture(state):
    from PIL import Image
    base=TASK/'.emulator';base.mkdir(exist_ok=True)
    output=Path(tempfile.mkdtemp(prefix='capture-',dir=base))
    home=Path.home();library=output/'capture.dylib'
    subprocess.run(['clang','-dynamiclib',f'-I{home}/.local/include',f'-L{home}/.local/lib',
                    '-lSDL3',str(TASK.parent/'capture_macos.c'),'-o',str(library)],check=True)
    startup=output/'capture-env.sh';startup.write_text('export DYLD_INSERT_LIBRARIES="$RALLY_CAPTURE_LIBRARY"\n')
    results=TASK/'results/visuals';results.mkdir(parents=True,exist_ok=True)
    for track in ('oval','fuji'):
        profile=output/track;prepare(state,profile,track)
        env=os.environ.copy()
        for key in ('DYLD_INSERT_LIBRARIES','LD_PRELOAD'): env.pop(key,None)
        env.update(SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy',BASH_ENV=str(startup),
                   RALLY_CAPTURE_LIBRARY=str(library),RALLY_CAPTURE_DIR=str(profile),RALLY_TEST_KEYS='1')
        with (profile/'capture.log').open('w') as log:
            result=subprocess.run(['./fab-agon-emulator','--renderer','sw'],cwd=profile,env=env,
                                  stdout=log,stderr=subprocess.STDOUT,timeout=45)
        captures=list(profile.glob('frame-*.bmp'))
        if len(captures)!=4: raise RuntimeError(f'{track}: missing captures')
        for p in captures: Image.open(p).save(results/f'{track}-{p.stem}.png')
        print(track,'four captures; requested-quit exit',result.returncode,flush=True)
    check_mainline(state);state['captures']=str(output);save(state)

def review(state):
    check_mainline(state)
    profile=TASK/'.emulator/review';prepare(state,profile)
    env=os.environ.copy()
    for key in ('SDL_VIDEODRIVER','SDL_VIDEO_DRIVER','SDL_AUDIODRIVER','BASH_ENV','DYLD_INSERT_LIBRARIES',
                'LD_PRELOAD','RALLY_CAPTURE_LIBRARY','RALLY_CAPTURE_DIR','RALLY_TEST_KEYS'): env.pop(key,None)
    with (profile/'review.log').open('w') as log:
        process=subprocess.Popen(['./fab-agon-emulator'],cwd=profile,env=env,
                                 stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
    time.sleep(3)
    if process.poll() is not None: raise RuntimeError('Review emulator exited; inspect review.log')
    state['review']={'profile':str(profile),'pid':process.pid};save(state)
    print('Pavement review emulator running:',process.pid,flush=True)

if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action',choices=('build','bench','capture','review'))
    args=parser.parse_args()
    if args.action=='build': build()
    else:
        state=json.loads(STATE.read_text());check_mainline(state)
        for info in state['variants'].values():
            if digest(Path(info['root'])/'bin/rally.bin')!=info['binary_sha256']:
                raise RuntimeError('Experiment binary identity changed')
        {'bench':bench,'capture':capture,'review':review}[args.action](state)
