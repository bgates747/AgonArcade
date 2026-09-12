"""RALLY-15 isolated builds, native headless checks, timing and review launch."""
from pathlib import Path
import argparse
import fcntl
import hashlib
import json
import os
import shutil
import subprocess
import sys
import tempfile
import time
import run_timing

TASK=Path(__file__).resolve().parent
REPO=TASK.parents[2]
MAIN=REPO/'rally'
WORK=TASK/'.work'
STATE=WORK/'active.json'

def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def fingerprint():
    files=[MAIN/'Makefile',MAIN/'bin/rally.bin']
    for name in ('src','include','tests','tools','assets'):
        files.extend(p for p in (MAIN/name).rglob('*') if p.is_file() and '__pycache__' not in p.parts)
    return {str(p.relative_to(MAIN)):digest(p) for p in files}

def save(state):
    STATE.write_text(json.dumps(state,indent=2)+'\n')

def check_mainline(state):
    if fingerprint()!=state['mainline']:
        raise RuntimeError('Mainline differs from the experiment snapshot; stop and inspect.')
    checkpoint=json.loads((TASK/'checkpoint.json').read_text())
    if state['mainline']['bin/rally.bin']!=checkpoint['mainline_binary_sha256']:
        raise RuntimeError('Experiment control does not match the frozen binary')
    if digest(TASK.parent/'RALLY-15.md')!=checkpoint['contract_sha256']:
        raise RuntimeError('Frozen contract changed')

def sources(variant):
    names=['section_protocol.hpp','protocol.py'] if variant!='full' else []
    if variant=='sections': names+=['section_road.hpp','section_phase.hpp','test_sections.cpp']
    if variant=='probe': names+=['probe.cpp']
    return {name:digest(TASK/name) for name in names}

def check_variant(info,variant):
    if digest(Path(info['root'])/'bin/rally.bin')!=info['binary_sha256']:
        raise RuntimeError(f'{variant}: binary changed')
    if sources(variant)!=info['sources']:
        raise RuntimeError(f'{variant}: task sources changed; rebuild before testing/review')

def replace_once(text,old,new):
    if text.count(old)!=1: raise RuntimeError(f'Injection anchor changed: {old}')
    return text.replace(old,new)

def build(variants):
    WORK.mkdir(exist_ok=True)
    state=json.loads(STATE.read_text()) if STATE.exists() else {'mainline':fingerprint(),'variants':{}}
    check_mainline(state)
    run=Path(tempfile.mkdtemp(prefix='build-',dir=WORK))
    for variant in variants:
        root=run/variant;root.mkdir()
        shutil.copy2(MAIN/'Makefile',root/'Makefile')
        for name in ('src','include','tests','tools'):
            shutil.copytree(MAIN/name,root/name,ignore=shutil.ignore_patterns('__pycache__'))
        identity=sources(variant)
        if variant!='full': shutil.copy2(TASK/'section_protocol.hpp',root/'include/section_protocol.hpp')
        if variant=='probe': shutil.copy2(TASK/'probe.cpp',root/'src/main.cpp')
        if variant=='sections':
            for name in ('section_road.hpp','section_phase.hpp'):shutil.copy2(TASK/name,root/'include'/name)
            shutil.copy2(TASK/'test_sections.cpp',root/'tests/test_sections.cpp')
            source=root/'src/main.cpp';text=source.read_text()
            for old,new in (
                ('#include "road.hpp"','#include "road.hpp"\n#include "section_road.hpp"'),
                ('rally::Road road;','rally::SectionRoad road;'),
                ('int(road.centers[y]/256)','road.centerAt(y)'),
                ('    loadScenery();','    loadScenery();\n    mos_puts((char *)rally::section::Startup,rally::section::StartupSize,0);')):
                text=replace_once(text,old,new)
            source.write_text(text)
            with (root/'Makefile').open('a') as file:
                file.write('\n.PHONY: sections-test\ntest: sections-test\nsections-test:\n'
                    '\tmkdir -p obj\n'
                    '\tg++ -std=c++17 -Wall -Wextra -Werror -fsanitize=address,undefined -g -Iinclude tests/test_sections.cpp -o obj/test_sections\n'
                    '\t./obj/test_sections\n')
        print('Building isolated',variant,flush=True)
        log=run/f'{variant}-build.log'
        with log.open('w') as output:
            result=subprocess.run([sys.executable,str(root/'tools/build_linux.py')],stdout=output,stderr=subprocess.STDOUT)
        if result.returncode:
            print(log.read_text()[-12000:]);raise RuntimeError(f'{variant} build failed: {log}')
        check_mainline(state)
        info={'root':str(root),'sources':identity,'binary_sha256':digest(root/'bin/rally.bin'),
              'binary_bytes':(root/'bin/rally.bin').stat().st_size,'build_log':str(log),
              'linux_build':(root/'bin/linux-build.txt').read_text()}
        if variant=='full' and info['binary_sha256']!=state['mainline']['bin/rally.bin']:
            raise RuntimeError('Rebuilt control differs from the frozen mainline binary')
        state['variants'][variant]=info;save(state)
        print(variant,info['binary_bytes'],'bytes; SHA256',info['binary_sha256'],flush=True)

def bench(state):
    base=TASK/'.emulator';base.mkdir(exist_ok=True)
    output=Path(tempfile.mkdtemp(prefix='timing-',dir=base))
    runtime=Path.home()/'Agon/fab-agon-emulator'
    for variant in ('full','sections'):check_variant(state['variants'][variant],variant)
    manifest={'variants':state['variants'],'mainline':state['mainline'],'runs':[],
              'headless':True,'clock_hz':120,'target_hz':60,'renderer':'sw',
              'runtime':{str(p):digest(p) for p in
                         (runtime/'fab-agon-emulator',runtime/'firmware/vdp_platform.so',runtime/'firmware/mos_platform.bin')},
              'harness':{p.name:digest(p) for p in (Path(__file__),TASK/'run_timing.py')}}
    print('Timing evidence:',output,flush=True)
    for track in ('oval','fuji'):
        runs=[]
        for number,variant in enumerate(('full','sections','sections','full'),1):
            run_timing.ROOT=Path(state['variants'][variant]['root'])
            result=run_timing.run_case(output,f'{track}-{number:02d}-{variant}',track,'full',True,True)
            result.update(track=track,variant=variant)
            runs.append(result);manifest['runs'].append(result)
            (output/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
        if len({r['metadata']['pose_hash'] for r in runs})!=1:raise RuntimeError('Pose mismatch')
        for variant in ('full','sections'):
            if len({r['metadata']['road_bytes'] for r in runs if r['variant']==variant})!=1:
                raise RuntimeError('Unstable command bytes')
    check_mainline(state)
    results=TASK/'results';results.mkdir(exist_ok=True)
    for p in [output/'manifest.json',*output.glob('*.csv')]:shutil.copy2(p,results/p.name)
    state['timing']=str(output);save(state)

def prepare(state,profile,variant='sections',track='oval'):
    info=state['variants'][variant];check_variant(info,variant)
    root=Path(info['root'])
    subprocess.run([sys.executable,str(root/'tools/prepare_emulator.py'),
        '--profile',str(profile),'--track',track,'--fence','--fixed-bands'],check=True,stdout=subprocess.DEVNULL)

def demo(state):
    # Separate ordinary gameplay sample: physics is active, poses/traffic move,
    # so these runs are not a controlled renderer A/B comparison.
    check_variant(state['variants']['sections'],'sections')
    base=TASK/'.emulator';base.mkdir(exist_ok=True)
    output=Path(tempfile.mkdtemp(prefix='demo-timing-',dir=base))
    run_timing.ROOT=Path(state['variants']['sections']['root'])
    records=[]
    for track in ('oval','fuji'):
        result=run_timing.run_case(output,track,track,None,True,True)
        result['track']=track
        frames=result['metadata']['submitted']
        ticks=result['metadata']['run_ticks']+result['metadata']['drain_ticks']
        result.update(fps=frames*120/ticks,frame_ms=ticks*1000/120/frames,
                      budget_multiple=ticks/2/frames)
        records.append(result)
    results=TASK/'results/demo';results.mkdir(exist_ok=True)
    (results/'manifest.json').write_text(json.dumps({'runs':records,'binary':state['variants']['sections'],
        'headless':True,'capture_interposer':False,'workload':'ordinary 20-second demo with physics'},indent=2)+'\n')
    for path in output.glob('*.csv'):shutil.copy2(path,results/path.name)
    check_mainline(state);state['demo_timing']=str(output);save(state)

def capture_environment(output,fast=False):
    home=Path.home();library=output/'capture.dylib'
    source=TASK/'capture_macos.c'
    if fast:
        # Probe is static: capture once after startup and leave the functional
        # key sequence out. This instrumentation never participates in timings.
        source=output/'probe-capture.c'
        text=(TASK/'capture_macos.c').read_text()
        text=text.replace('(frame == 600 || frame == 720 || frame == 840 || frame == 900)','(frame == 300)')
        text=text.replace('frame == 920','frame == 320')
        source.write_text(text)
    subprocess.run(['clang','-dynamiclib',f'-I{home}/.local/include',f'-L{home}/.local/lib',
                    '-lSDL3',str(source),'-o',str(library)],check=True)
    startup=output/'capture-env.sh';startup.write_text('export DYLD_INSERT_LIBRARIES="$RALLY_CAPTURE_LIBRARY"\n')
    env=os.environ.copy()
    for key in ('DYLD_INSERT_LIBRARIES','LD_PRELOAD','RALLY_TEST_KEYS'):env.pop(key,None)
    env.update(SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy',BASH_ENV=str(startup),
               RALLY_CAPTURE_LIBRARY=str(library))
    return env

def capture(state,probe=False):
    from PIL import Image
    base=TASK/'.emulator';base.mkdir(exist_ok=True)
    output=Path(tempfile.mkdtemp(prefix='probe-' if probe else 'capture-',dir=base))
    env=capture_environment(output,probe)
    results=TASK/'results'/('probe' if probe else 'visuals');results.mkdir(parents=True,exist_ok=True)
    records=[]
    for label in (('resident','direct') if probe else ('oval','fuji')):
        profile=output/label
        prepare(state,profile,'probe' if probe else 'sections','oval' if probe else label)
        if probe:
            (profile/'sdcard/autoexec.txt').write_bytes(('SET KEYBOARD 1\r\ncd /rally\r\nload rally.bin\r\nrun . '+label+'\r\n').encode())
        else: env['RALLY_TEST_KEYS']='1'
        env['RALLY_CAPTURE_DIR']=str(profile)
        with (profile/'capture.log').open('w') as log:
            result=subprocess.run(['./fab-agon-emulator','--renderer','sw'],cwd=profile,env=env,
                                  stdout=log,stderr=subprocess.STDOUT,timeout=45)
        captures=sorted(profile.glob('frame-*.bmp'))
        if len(captures)!=(1 if probe else 4):raise RuntimeError(f'{label}: missing captures: {profile}')
        for p in captures:Image.open(p).save(results/f'{label}-{p.stem}.png')
        record={'label':label,'profile':str(profile),'requested_quit_returncode':result.returncode}
        if probe:
            report=(profile/'sdcard/rally/probe.txt').read_text()
            if 'acknowledged=1' not in report:raise RuntimeError(f'{label}: VDP did not acknowledge probe')
            record['report']=report
        records.append(record)
        print(label,'captures complete; requested-quit exit',result.returncode,flush=True)
    (results/'manifest.json').write_text(json.dumps({'runs':records,'binary':state['variants']['probe' if probe else 'sections'],
        'capture_source_sha256':digest(TASK/'capture_macos.c')},indent=2)+'\n')
    check_mainline(state);state['probe' if probe else 'captures']=str(output);save(state)

def review(state):
    check_mainline(state)
    profile=TASK/'.emulator/review';prepare(state,profile)
    env=os.environ.copy()
    for key in ('SDL_VIDEODRIVER','SDL_VIDEO_DRIVER','SDL_AUDIODRIVER','BASH_ENV','DYLD_INSERT_LIBRARIES',
                'LD_PRELOAD','RALLY_CAPTURE_LIBRARY','RALLY_CAPTURE_DIR','RALLY_TEST_KEYS'):env.pop(key,None)
    with (profile/'review.log').open('w') as log:
        process=subprocess.Popen(['./fab-agon-emulator'],cwd=profile,env=env,
                                 stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
    time.sleep(3)
    if process.poll() is not None:raise RuntimeError('Review emulator exited; inspect review.log')
    state['review']={'profile':str(profile),'pid':process.pid};save(state)
    print('Full-road VDP section review emulator running:',process.pid,flush=True)

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action',choices=('build','bench','demo','probe','capture','review'))
    parser.add_argument('--variants',nargs='+',choices=('full','probe','sections'),default=('full','sections'))
    args=parser.parse_args()
    if args.action=='build':build(args.variants)
    else:
        state=json.loads(STATE.read_text());check_mainline(state)
        if args.action=='probe':capture(state,True)
        else:{'bench':bench,'demo':demo,'capture':capture,'review':review}[args.action](state)

if __name__=='__main__':
    WORK.mkdir(exist_ok=True)
    with (WORK/'experiment.lock').open('w') as lock:
        try:fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
        except BlockingIOError:raise SystemExit('Another RALLY-15 action is running; run actions serially.')
        main()
