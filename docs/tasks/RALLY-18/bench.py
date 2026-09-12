"""RALLY-18 matched headless computation, wire-sink and completed-render cases."""
import build as b
from pathlib import Path
import argparse,csv,gzip,io,json,os,re,shlex,shutil,signal,subprocess,sys,tempfile,time
TASK=b.TASK;WORK=b.WORK

def prepare(info,profile,track,options):
    subprocess.run([sys.executable,str(Path(info['root'])/'tools/prepare_emulator.py'),'--profile',str(profile),'--track',track],check=True,stdout=subprocess.DEVNULL)
    for name in ('oval.road','fuji.road'):
        p=TASK/'data'/name
        if p.exists():(profile/'sdcard/rally'/name).symlink_to(p)
    (profile/'sdcard/autoexec.txt').write_bytes(('SET KEYBOARD 1\r\ncd /rally\r\nload rally.bin\r\nrun . '+track+' '+options+'\r\n').encode())

def run(info,output,track,variant,perspective,mode,number):
    name=f'{track}-{variant}-'+('perspective' if perspective else 'control')+f'-{mode}-{number}'
    profile=output/name;options='measure'+(' perspective' if perspective else '')+(' compute' if mode=='compute' else ' display' if mode=='display' else '')
    prepare(info,profile,track,options)
    (profile/'vdp_rally_sink.so').symlink_to(WORK/'vdp_rally_sink.so');(profile/'.bespoke-vdp-profile').write_text('vdp_rally_sink.so\n')
    app=profile/'sdcard/rally';report=app/'measurement.csv'
    env=os.environ.copy()
    for key in ('BASH_ENV','DYLD_INSERT_LIBRARIES','LD_PRELOAD'):env.pop(key,None)
    env.update(SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy',RALLY_STOCK_VDP=str(Path.home()/'Agon/fab-agon-emulator/firmware/vdp_platform.so'),RALLY_SINK_DIR=str(app),RALLY_SINK_MODE='count' if mode=='display' else 'sink')
    command=['./fab-agon-emulator','--renderer','sw'];debug=mode!='display'
    if debug:
        command+=['-d']
        for address in info['breakpoints']:command+=['-b',str(address)]
    start=time.monotonic();load=os.getloadavg()
    with (profile/'run.log').open('w') as log:
        p=subprocess.Popen(command,cwd=profile,env=env,stdin=subprocess.PIPE if debug else subprocess.DEVNULL,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
        if debug:p.stdin.write(b'state\ncontinue\nstate\ncontinue\n');p.stdin.flush()
        try:
            while time.monotonic()-start<240:
                if report.exists() and report.read_text().endswith('# complete\n'):break
                if p.poll() is not None:raise RuntimeError('Emulator stopped '+str(profile))
                time.sleep(.2)
            else:raise RuntimeError('No report '+str(profile))
            row={k:int(v) for k,v in next(csv.DictReader(io.StringIO(report.read_text()))).items()}
            sink=json.loads((app/'sink.json').read_text());assert row['frames']==64 and row['cars']==384 and row['completed']==1,row
            if mode=='compute':assert sink['bytes']==0 and row['road_bytes']==0
            ps=subprocess.check_output(['ps','-axo','pgid=,command='],text=True)
            actual=[line.strip() for line in ps.splitlines() if line.strip().split(None,1)[0]==str(p.pid)]
            assert any('--vdp' in c for c in actual)
            assert not any(t in ('-u','--unlimited_cpu','--unlimited-cpu') for c in actual for t in shlex.split(c))
        finally:
            os.killpg(p.pid,signal.SIGTERM)
            try:p.wait(timeout=5)
            except subprocess.TimeoutExpired:os.killpg(p.pid,signal.SIGKILL);p.wait()
    r={'case':name,'track':track,'variant':variant,'perspective':perspective,'mode':mode,'data':row,'sink':sink,'actual_process_commands':actual,'load_before':load,'load_after':os.getloadavg(),'wall_seconds_with_startup':time.monotonic()-start}
    if debug:
        counts=[int(n) for n in re.findall(r'Cycles since last break: (\d+)',(profile/'run.log').read_text())];assert len(counts)==2,counts
        r['batch_cpu_cycles']=counts[1];r['ms']=counts[1]/18432000*1000/64
    else:r['ms']=row['complete_ticks']*1000/120/64
    r['fps']=1000/r['ms'];r['budget_multiple']=r['ms']/(1000/60)
    for file in ('measurement.csv','sink.json','scene.csv'):shutil.copy2(app/file,output/(name+'-'+file))
    with gzip.open(output/(name+'-run.txt.gz'),'wb') as f:f.write((profile/'run.log').read_bytes())
    print(name,f"{r['fps']:.2f} {'completed FPS' if mode=='display' else 'FPS equivalent'}, {r['ms']:.2f} ms",flush=True)
    return r

def bench(variants,modes,repeat,tracks,perspective):
    b.protect();s=json.loads(b.STATE.read_text());WORK.mkdir(exist_ok=True)
    subprocess.run(['clang++','-std=c++17','-O2','-Wall','-Wextra','-Werror','-dynamiclib','-pthread',str(TASK/'proxy.cpp'),'-o',str(WORK/'vdp_rally_sink.so')],check=True)
    base=TASK/'.emulator';base.mkdir(exist_ok=True);output=Path(tempfile.mkdtemp(prefix='bench-',dir=base))
    sources={p.name:b.sha(p) for p in TASK.iterdir() if p.is_file()};data={p.name:b.sha(p) for p in (TASK/'data').glob('*.road')} if (TASK/'data').exists() else {}
    m={'headless':True,'cpu_hz':18432000,'clock_hz':120,'variants':s['variants'],'sources':sources,'data':data,'checkpoint':'182a1d0','runs':[]}
    print('Evidence:',output,flush=True)
    cases=[(v,False) for v in variants]+([('lookup',True)] if perspective and 'lookup' in variants else [])
    for track in tracks:
        for mode in modes:
            for number in range(1,repeat+1):
                for variant,angle in cases if number%2 else reversed(cases):
                    info=s['variants'][variant];assert b.sha(Path(info['root'])/'bin/rally.bin')==info['sha256']
                    r=run(info,output,track,variant,angle,mode,number);m['runs'].append(r)
                    (output/'manifest.json').write_text(json.dumps(m,indent=2)+'\n')
            group=[r for r in m['runs'] if r['track']==track and r['mode']==mode]
            assert len({r['data']['pose_hash'] for r in group})==1
            for variant,angle in cases:
                rr=[r for r in group if r['variant']==variant and r['perspective']==angle]
                for key in ('bytes','fnv1a64'):assert len({r['sink'][key] for r in rr})==1,(key,rr)
    b.protect();destination=TASK/'results'/output.name;destination.mkdir(parents=True)
    for p in output.iterdir():
        if p.is_file():shutil.copy2(p,destination/p.name)
    for v in variants:
        info=s['variants'][v];shutil.copy2(info['log'],destination/(v+'-build.txt'));shutil.copy2(Path(info['root'])/'bin/rally.map',destination/(v+'.map'))
    (WORK/'latest-results.json').write_text(json.dumps({'results':str(destination),'profiles':str(output)},indent=2)+'\n')
    print('Saved:',destination)
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--variants',nargs='+',choices=('live','lookup'),default=['live','lookup']);p.add_argument('--modes',nargs='+',choices=('compute','wire','display'),default=['compute','wire','display']);p.add_argument('--repeat',type=int,default=2);p.add_argument('--tracks',nargs='+',choices=('oval','fuji'),default=['oval','fuji']);p.add_argument('--perspective',action='store_true');a=p.parse_args();bench(a.variants,a.modes,a.repeat,a.tracks,a.perspective)
