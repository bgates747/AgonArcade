"""Unpaced batch benchmark; default throttled eZ80, task-local source copies."""
from pathlib import Path
import argparse,csv,hashlib,io,json,os,shlex,shutil,subprocess,sys,tempfile,time
TASK=Path(__file__).resolve().parent
REPO=TASK.parents[2]
MAIN=REPO/'rally'
WORK=TASK/'.work'
STATE=WORK/'active.json'
VARIANTS=('full','pavement','sections')
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def fingerprint():
    names=subprocess.check_output(['git','-C',str(REPO),'ls-files','-z','rally']).decode().split('\0')
    return {n:sha(REPO/n) for n in names if n}|{'rally/bin/rally.bin':sha(MAIN/'bin/rally.bin')}
def save(s):STATE.write_text(json.dumps(s,indent=2)+'\n')
def check(s):
    assert fingerprint()==s['mainline'],'Mainline changed'
    for v,info in s['variants'].items():assert sha(Path(info['root'])/'bin/rally.bin')==info['sha256'],v

def source(variant):
    old=(MAIN/'src/main.cpp').read_text()
    includes=old[:old.index('namespace {')]
    kind={'full':'Road','pavement':'PavementRoad','sections':'SectionRoad'}[variant]
    if variant!='full':includes+='#include "'+('pavement.hpp' if variant=='pavement' else 'section_road.hpp')+'"\n'
    helpers=old[old.index('rally::SceneryHistory sceneryHistory;'):old.index('int main(')]
    helpers=helpers.replace('uint8_t heldKeys[16];\n','')
    helpers=helpers.replace('bool key(int code) { return heldKeys[(code-1)/8] & (1<<((code-1)%8)); }\n','')
    if variant=='sections':helpers=helpers.replace('int(road.centers[y]/256)','road.centerAt(y)')
    startup=old[old.index('    if (vdp_mode(136)<0)'):old.index('    // Fence uploads')]
    if variant=='sections':startup+='    mos_puts((char *)rally::section::Startup,rally::section::StartupSize,0);\n'
    batch=(TASK/'batch.cpp.inc').read_text().replace('    /* STARTUP */',startup)
    hot=batch[batch.index('bool renderPose('):batch.index('\n}\n}\nint main')]
    for token in ('rawClock','completeBatch','waitForVDP','tickDue','sleep','next='):
        assert token not in hot,token
    result=includes+'namespace {\nrally::Motion motion;\nrally::'+kind+' road;\nrally::Traffic traffic;\n'+helpers+batch
    assert 'next=now+4' not in result and 'FrameTiming' not in result
    return result

def build():
    WORK.mkdir(exist_ok=True)
    run=Path(tempfile.mkdtemp(prefix='build-',dir=WORK))
    state={'head':subprocess.check_output(['git','-C',str(REPO),'rev-parse','HEAD'],text=True).strip(),
           'mainline':fingerprint(),'variants':{},'task_sources':{p.name:sha(p) for p in TASK.iterdir() if p.is_file()}}
    for variant in VARIANTS:
        root=run/variant;root.mkdir()
        shutil.copy2(MAIN/'Makefile',root/'Makefile')
        for name in ('src','include','tests','tools'):shutil.copytree(MAIN/name,root/name,ignore=shutil.ignore_patterns('__pycache__'))
        (root/'src/main.cpp').write_text(source(variant))
        for path in TASK.glob('*.hpp'):shutil.copy2(path,root/'include'/path.name)
        test='test_sections.cpp' if variant=='sections' else 'test_pavement.cpp' if variant=='pavement' else None
        if test:
            shutil.copy2(TASK/test,root/'tests'/test)
            with (root/'Makefile').open('a') as f:
                f.write('\n.PHONY: experiment-test\ntest: experiment-test\nexperiment-test:\n\tmkdir -p obj\n'
                    '\tg++ -std=c++17 -Wall -Wextra -Werror -fsanitize=address,undefined -g -Iinclude tests/'+test+' -o obj/test_experiment\n\t./obj/test_experiment\n')
        print('Building',variant,flush=True)
        log=run/(variant+'-build.txt')
        with log.open('w') as f:result=subprocess.run([sys.executable,str(root/'tools/build_linux.py')],stdout=f,stderr=subprocess.STDOUT)
        if result.returncode:print(log.read_text()[-8000:]);raise RuntimeError('Build failed')
        state['variants'][variant]={'root':str(root),'sha256':sha(root/'bin/rally.bin'),
            'bytes':(root/'bin/rally.bin').stat().st_size,'source_sha256':sha(root/'src/main.cpp'),
            'build_evidence':(root/'bin/linux-build.txt').read_text(),'build_log':str(log)}
        check(state);save(state)
        print(variant,state['variants'][variant]['bytes'],'bytes',flush=True)

def run_case(s,output,track,variant,number):
    root=Path(s['variants'][variant]['root']);profile=output/f'{track}-{number:02d}-{variant}'
    subprocess.run([sys.executable,str(root/'tools/prepare_emulator.py'),'--profile',str(profile),'--track',track],check=True,stdout=subprocess.DEVNULL)
    report=profile/'sdcard/rally/unpaced.csv'
    env=os.environ.copy()
    for name in ('BASH_ENV','DYLD_INSERT_LIBRARIES','LD_PRELOAD'):env.pop(name,None)
    env.update(SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy')
    command=['./fab-agon-emulator','--renderer','sw']
    start=time.monotonic();load=os.getloadavg()
    with (profile/'run.log').open('w') as log:
        process=subprocess.Popen(command,cwd=profile,env=env,stdout=log,stderr=subprocess.STDOUT)
        try:
            while time.monotonic()-start<120:
                if report.exists() and report.read_text().endswith('# complete\n'):break
                if process.poll() is not None:raise RuntimeError('Emulator stopped before report: '+str(profile))
                time.sleep(.2)
            else:raise RuntimeError('No completed batch: '+str(profile))
            row={k:int(v) for k,v in next(csv.DictReader(io.StringIO(report.read_text()))).items()}
            assert row['frames']==64 and row['cars']==384 and row['completed']==1,row
            assert row['total_ticks']==row['submit_ticks']+row['drain_ticks']
            actual_command=subprocess.check_output(['ps','-p',str(process.pid),'-o','command='],text=True).strip()
            tokens=shlex.split(actual_command)
            assert tokens and 'fab-agon-emulator.bin' in tokens[0],actual_command
            assert not any(t in tokens for t in ('-u','--unlimited_cpu','--unlimited-cpu')),actual_command
            previous=TASK.parent/('RALLY-10/pavement/results/manifest.json' if variant=='pavement' else 'RALLY-15/results/manifest.json')
            prior=json.loads(previous.read_text())
            expected=next(r['metadata'] for r in prior['runs'] if r['track']==track and r['variant']==variant)
            for key in ('pose_hash','road_bytes'):assert row[key]==expected[key],(key,row,expected)

        finally:
            process.terminate()
            try:process.wait(timeout=5)
            except subprocess.TimeoutExpired:process.kill();process.wait()
    shutil.copy2(report,output/(profile.name+'.csv'))
    r={'track':track,'variant':variant,'case':profile.name,'data':row,'command':command,'actual_process_command':actual_command,
       'cpu':'default 18.432 MHz; no unlimited flag or clock override','load_before':load,'load_after':os.getloadavg(),
       'wall_seconds_with_startup':time.monotonic()-start}
    r['frame_ms']=row['total_ticks']*1000/120/64;r['fps']=1000/r['frame_ms']
    print(profile.name,f"{r['fps']:.2f} FPS, {r['frame_ms']:.2f} ms; drain {row['drain_ticks']} ticks",flush=True)
    return r

def bench(s):
    check(s)
    base=TASK/'.emulator';base.mkdir(exist_ok=True)
    output=Path(tempfile.mkdtemp(prefix='batch-',dir=base));runtime=Path.home()/'Agon/fab-agon-emulator'
    m={'harness_sha256':sha(Path(__file__)),'headless':True,'clock_hz':120,'target_hz':60,'variants':s['variants'],'task_sources':s['task_sources'],
       'runtime':{str(p):sha(p) for p in (runtime/'fab-agon-emulator',runtime/'firmware/vdp_platform.so',runtime/'firmware/mos_platform.bin')},'runs':[]}
    print('Evidence:',output,flush=True)
    for track in ('oval','fuji'):
        for number,variant in enumerate((*VARIANTS,*reversed(VARIANTS)),1):
            r=run_case(s,output,track,variant,number);m['runs'].append(r)
            (output/'manifest.json').write_text(json.dumps(m,indent=2)+'\n')
        group=[r for r in m['runs'] if r['track']==track]
        assert len({r['data']['pose_hash'] for r in group})==1
        for variant in VARIANTS:assert len({r['data']['road_bytes'] for r in group if r['variant']==variant})==1
    check(s);results=TASK/'results';results.mkdir(exist_ok=True)
    for path in [output/'manifest.json',*output.glob('*.csv')]:shutil.copy2(path,results/path.name)
    for variant,info in s['variants'].items():shutil.copy2(info['build_log'],results/(variant+'-build.txt'))
    s['results']=str(output);save(s)

if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('action',choices=('build','bench'));args=parser.parse_args()
    if args.action=='build':build()
    else:bench(json.loads(STATE.read_text()))
