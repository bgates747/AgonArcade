"""Post-UART sink benchmark; default throttled eZ80, task-local source copies."""
from pathlib import Path
import signal,re
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
    includes=old[:old.index('namespace {')]+'#include <ez80f92.h>\n'
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

def run_case(s,output,track,variant,number,mode):
    root=Path(s['variants'][variant]['root']);profile=output/f'{track}-{number:02d}-{variant}-{mode}'
    subprocess.run([sys.executable,str(root/'tools/prepare_emulator.py'),'--profile',str(profile),'--track',track],check=True,stdout=subprocess.DEVNULL)
    (profile/'vdp_rally_sink.so').symlink_to(WORK/'vdp_rally_sink.so')
    (profile/'.bespoke-vdp-profile').write_text('vdp_rally_sink.so\n')
    report=profile/'sdcard/rally/unpaced.csv'
    env=os.environ.copy()
    for name in ('BASH_ENV','DYLD_INSERT_LIBRARIES','LD_PRELOAD'):env.pop(name,None)
    env.update(SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy',RALLY_STOCK_VDP=str(Path.home()/'Agon/fab-agon-emulator/firmware/vdp_platform.so'),RALLY_SINK_DIR=str(report.parent),RALLY_SINK_MODE=mode)
    start=time.monotonic();load=os.getloadavg()
    with (profile/'run.log').open('w') as log:
        command=['./fab-agon-emulator','--renderer','sw']
        cycle_mode=globals().get('CYCLE_MODE',False)
        if cycle_mode:
            command+=['-d']
            for address in s['variants'][variant]['breakpoints']:command+=['-b',str(address)]
        process=subprocess.Popen(command,cwd=profile,env=env,stdout=log,stderr=subprocess.STDOUT,start_new_session=True,stdin=subprocess.PIPE if cycle_mode else subprocess.DEVNULL)
        if cycle_mode:
            process.stdin.write(b'state\ncontinue\nstate\ncontinue\n');process.stdin.flush()
        try:
            while time.monotonic()-start<180:
                if report.exists() and report.read_text().endswith('# complete\n'):break
                if process.poll() is not None:raise RuntimeError('Emulator stopped: '+str(profile))
                time.sleep(.2)
            else:raise RuntimeError('No completed batch: '+str(profile))
            row={k:int(v) for k,v in next(csv.DictReader(io.StringIO(report.read_text()))).items()}
            assert row['frames']==64 and row['cars']==384 and row['completed']==1,row
            sink=json.loads((report.parent/'sink.json').read_text())
            commands=subprocess.check_output(['ps','-axo','pgid=,command='],text=True)
            actual=[line.strip() for line in commands.splitlines() if line.strip().split(None,1)[0]==str(process.pid)]
            assert any('--vdp' in line for line in actual),actual
            assert not any(t in ('-u','--unlimited_cpu','--unlimited-cpu') for line in actual for t in shlex.split(line)),actual
        finally:
            os.killpg(process.pid,signal.SIGTERM)
            try:process.wait(timeout=5)
            except subprocess.TimeoutExpired:os.killpg(process.pid,signal.SIGKILL);process.wait()
    shutil.copy2(report,output/(profile.name+'.csv'))
    r={'track':track,'variant':variant,'mode':mode,'case':profile.name,'data':row,'sink':sink,'actual_process_commands':actual,'cpu':'default 18.432 MHz; UART timing unchanged','load_before':load,'load_after':os.getloadavg(),'wall_seconds_with_startup':time.monotonic()-start}
    r['frame_ms']=row['submit_ticks']*1000/120/64;r['fps']=1000/r['frame_ms']
    if cycle_mode:
        counts=[int(n) for n in re.findall(r'Cycles since last break: (\d+)',(profile/'run.log').read_text())]
        assert len(counts)==2,counts
        r['batch_cpu_cycles']=counts[1];r['frame_ms']=counts[1]/18432000*1000/64;r['fps']=1000/r['frame_ms']
        shutil.copy2(profile/'run.log',output/(profile.name+'-debugger.txt'))
    print(profile.name,f"{r['fps']:.2f} cycles/s, {r['frame_ms']:.2f} ms",flush=True)
    return r

def bench(s):
    check(s)
    subprocess.run(['clang++','-std=c++17','-O2','-Wall','-Wextra','-Werror','-dynamiclib','-pthread',str(TASK/'proxy.cpp'),'-o',str(WORK/'vdp_rally_sink.so')],check=True)
    base=TASK/'.emulator';base.mkdir(exist_ok=True)
    output=Path(tempfile.mkdtemp(prefix='batch-',dir=base));runtime=Path.home()/'Agon/fab-agon-emulator'
    m={'headless':True,'clock_hz':120,'variants':s['variants'],'mainline':s['mainline'],'runtime':{str(p):sha(p) for p in (runtime/'fab-agon-emulator',runtime/'firmware/vdp_platform.so',runtime/'firmware/mos_platform.bin',WORK/'vdp_rally_sink.so')},'runs':[]}
    print('Evidence:',output,flush=True)
    for track in ('oval','fuji'):
        for variant in VARIANTS:
            for number,mode in enumerate(('count','sink','sink'),1):
                r=run_case(s,output,track,variant,number,mode);m['runs'].append(r)
                (output/'manifest.json').write_text(json.dumps(m,indent=2)+'\n')
            group=m['runs'][-3:]
            for key in ('bytes','fnv1a64'):assert len({r['sink'][key] for r in group})==1,(key,group)
            for key in ('pose_hash','road_bytes','cars'):assert len({r['data'][key] for r in group})==1,key
    for name,digest in m['runtime'].items():assert sha(Path(name))==digest,name
    check(s);results=TASK/('cycle-results' if globals().get('CYCLE_MODE',False) else 'results');results.mkdir(exist_ok=True)
    for path in [output/'manifest.json',*output.glob('*.csv'),*output.glob('*-debugger.txt')]:shutil.copy2(path,results/path.name)
    for variant,info in s['variants'].items():shutil.copy2(info['build_log'],results/(variant+'-build.txt'))
    s['results']=str(output);save(s)

if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('action',choices=('build','bench'));args=parser.parse_args()
    if args.action=='build':build()
    else:bench(json.loads(STATE.read_text()))
