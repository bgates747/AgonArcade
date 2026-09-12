"""Serial real-rendering measurements against the immutable accepted oracle.

Normal CPU/UART, no sink, no per-frame GP. Native swap observation was qualified
separately; raw guest intervals and post-batch admission state remain distinct.
"""
import argparse,csv,io,json,os,signal,subprocess,time
from pathlib import Path
from profile import TASK,prepare
from capture import runtime_identity
from native_run import sha
from measure_swap_overhead import no_emulators

def rows(path):return [{k:int(v) for k,v in r.items()} for r in csv.DictReader(io.StringIO(path.read_text().split('# complete')[0]))]
def memory(pid):
    result={}
    for line in (Path('/proc')/str(pid)/'status').read_text().splitlines():
        key=line.split(':',1)[0]
        if key in ['VmRSS','VmHWM','VmSize','VmPeak']:result[key+'_kB']=int(line.split()[1])
    return result

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--build',required=True)
    p.add_argument('--phase',choices=['smoke','bridge','abba'],required=True);a=p.parse_args()
    no_emulators();work=TASK/'.work/render-work'/a.build;build=json.loads((work/'manifest.json').read_text())
    for path,digest in {**build['source_hashes'],**build['outputs']}.items():assert sha(Path(path))==digest,path
    root=TASK/'evidence/golem-render-work'/a.name;root.mkdir(parents=True,exist_ok=False)
    home=Path.home();library=root/'swap-probe.so';source=TASK/'swap_probe_linux.cpp'
    qualified=json.loads((TASK/'evidence/golem-swap-overhead/initial/results.json').read_text())
    assert qualified['pass'] and qualified['observer_source_sha256']==sha(source)
    command=['g++','-std=c++17','-O2','-Wall','-Wextra','-Werror','-shared','-fPIC',
             '-I'+str(home/'.local/include'),'-L'+str(home/'.local/lib'),'-Wl,-rpath,'+str(home/'.local/lib'),
             str(source),'-lSDL3','-ldl','-o',str(library)]
    with (root/'build.txt').open('w') as log:subprocess.run(command,check=True,stdout=log,stderr=subprocess.STDOUT)
    assert sha(library)==qualified['library_sha256'],'Use the qualified observer binary'
    original=TASK/'.work/oracle/bin/rally.bin'
    assert sha(original)=='03322954c8c4fe29d90eaa0706c9169b242cdd264ea3b7b287cece58a6469d79'
    variants=['golem'] if a.phase=='smoke' else ['stock','oracle','oracle','stock'] if a.phase=='bridge' else ['stock','golem','golem','stock']
    planned=[]
    for track in (['oval'] if a.phase=='smoke' else ['oval','fuji']):
        for index,variant in enumerate(variants):
            name=f'{track}-{index}-{variant}';output=root/name;output.mkdir()
            binary=original if variant=='stock' else work/'bin/rally.bin'
            args=track+' measure' if variant=='stock' else f'{track} {variant} measure'
            profile=prepare(TASK/'.emulator'/('render-work-'+a.name+'-'+name),binary,args);app=profile/'sdcard/rally'
            if variant!='stock':
                for t in ['oval','fuji']:
                    for ext in ['.vdp','.clr']:(app/(t+ext)).symlink_to(work/(t+ext))
            planned.append((track,index,variant,output,profile,runtime_identity(profile)))
    runs=[]
    baseline=json.loads((TASK/'evidence/baseline/manifest.json').read_text())
    for track,index,variant,output,profile,before in planned:
        no_emulators();app=profile/'sdcard/rally';begin=time.monotonic()
        env={k:v for k,v in os.environ.items() if not k.startswith(('RALLY_','R19_','DYLD_')) and k not in ('LD_PRELOAD','BASH_ENV','SDL_VIDEO_DRIVER')}
        env.update(SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy',LD_PRELOAD=str(library),
                   R19_VDP_MODULE=str(profile/'firmware/vdp_platform.so'),R19_SWAP_COUNT='68',
                   R19_SWAP_STOP=str(output/'flush'),R19_SWAP_OUTPUT=str(output/'swaps.csv'))
        launch=['./fab-agon-emulator','--renderer','sw']
        manifest={'scope':__doc__,'headless':True,'track':track,'variant':variant,'index':index,
                  'command':launch,'runtime_before':before,'build':build,'runner_sha256':sha(Path(__file__)),
                  'observer_sha256':sha(library),'completed':False,'load_before':os.getloadavg()}
        print('START',output.name,flush=True)
        with (output/'emulator.log').open('w') as log:
            proc=subprocess.Popen(launch,cwd=profile,env=env,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
            try:
                while time.monotonic()-begin<180:
                    if (app/'start.snk').exists() and not (app/'go.snk').exists():
                        actual=(Path('/proc')/str(proc.pid)/'cmdline').read_bytes().decode().split('\0')[:-1]
                        assert Path(actual[0]).name=='fab-agon-emulator' and not any(t in actual for t in ['-u','--unlimited_cpu','--unlimited-cpu'])
                        manifest.update(actual_command=actual,warmed_process_memory=memory(proc.pid),go_wall_ns=time.monotonic_ns())
                        (app/'go.snk').touch()
                    if (app/'done.snk').exists() and not (app/'stop.snk').exists():
                        manifest.update(submitted_process_memory=memory(proc.pid),done_wall_ns=time.monotonic_ns());(app/'stop.snk').touch()
                    result=app/('measurement.csv' if variant=='stock' else 'render-summary.csv')
                    done=variant=='stock' or (app/'render-exit.snk').exists()
                    if done and result.exists() and result.read_text().endswith('# complete\n'):
                        (output/'flush').touch(exist_ok=True)
                        swaps=output/'swaps.csv'
                        if swaps.exists() and swaps.read_text().endswith('# complete\n'):
                            manifest.update(completed=True,finished_process_memory=memory(proc.pid));break
                    if proc.poll() is not None:raise RuntimeError('Emulator exited before finite rendering report')
                    time.sleep(.01)
                assert manifest['completed'],'Timed out; retain failed run'
            finally:
                if proc.poll() is None:
                    os.killpg(proc.pid,signal.SIGTERM)
                    try:proc.wait(timeout=5)
                    except subprocess.TimeoutExpired:os.killpg(proc.pid,signal.SIGKILL);proc.wait()
                manifest.update(returncode=proc.returncode,wall_seconds_with_startup=time.monotonic()-begin,load_after=os.getloadavg())
                (output/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
        after=runtime_identity(profile);assert all(after.get(k)==v for k,v in before.items())
        files=['measurement.csv','scene.csv'] if variant=='stock' else ['render-summary.csv','render-rows.csv','render-exit.snk']+(['scene.csv'] if variant=='oracle' else [])
        for name in files:(output/name).write_bytes((app/name).read_bytes())
        expected=next(r['data'] for r in baseline['runs'] if r['track']==track and r['mode']=='submit')
        data=rows(output/('measurement.csv' if variant=='stock' else 'render-summary.csv'))[0]
        assert data['frames']==64
        intervals=[]
        if variant=='stock':
            assert data['completed']==1 and data['pose_hash']==expected['pose_hash'] and data['road_bytes']==expected['road_bytes'] and data['cars']==384
            batch=data['submit_ticks']
        else:
            detail=rows(output/'render-rows.csv');assert [r['pose'] for r in detail]==list(range(64))
            assert data['oracle']==int(variant=='oracle') and data['hash']==expected['pose_hash'] and detail[-1]['hash']==data['hash']
            batch=data['batch_ticks']
            intervals=[detail[i+1]['start_ticks']-r['start_ticks'] if i<63 else batch-r['start_ticks'] for i,r in enumerate(detail)]
            assert all(n>=0 for n in intervals)
            if variant=='oracle':assert sum(r['road_bytes'] for r in detail)==expected['road_bytes']
            else:
                assert [data[k] for k in ['valid','wrap','count','last','error','expected']]==[1,1,66,65,0,66]
                assert data['host_scene_bytes']==64*97 and all(r['road_bytes']==0 for r in detail)
        events=rows(output/'swaps.csv');observed={k:[r for r in events if r['kind']==k] for k in [0,1]}
        assert len(events)==136
        for records in observed.values():
            assert [r['ordinal'] for r in records]==list(range(68))
            assert all(x['end_ns']<=y['begin_ns'] for x,y in zip(records,records[1:]))
        for c,v in zip(observed[0],observed[1]):assert c['begin_ns']<=v['begin_ns']<=v['end_ns']<=c['end_ns']
        run={'track':track,'index':index,'variant':variant,'data':data,'batch_ticks':batch,'guest_frame_ticks':intervals,
             'visible_intervals_ms':[(observed[1][i]['end_ns']-observed[1][i-1]['end_ns'])/1e6 for i in range(5,68)],
             'canvas_intervals_ms':[(observed[0][i]['end_ns']-observed[0][i-1]['end_ns'])/1e6 for i in range(5,68)],
             'runtime_inputs_unchanged':True,'observer_events':136}
        runs.append(run);(root/'partial.json').write_text(json.dumps({'scope':__doc__,'phase':a.phase,'runs':runs},indent=2)+'\n')
        print('DONE',output.name,'batch ticks',batch,flush=True)
    if a.phase=='bridge':
        for track in ['oval','fuji']:
            images=[(root/f'{track}-{i}-{v}'/'scene.csv').read_bytes() for i,v in enumerate(variants)]
            assert all(x==images[0] for x in images),'Final oracle diagnostic geometry changed'
    report={'scope':__doc__,'phase':a.phase,'pass':True,'runs':runs,'clock_hz':120,'cpu_hz':18432000,
            'build':build,'remaining':'Audit distributions, CPU bounds, byte reduction, startup/memory and unchanged oracle bridge before accepting R19-10.'}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n');print('Real rendering evidence collected:',a.phase,len(runs),'runs')

if __name__=='__main__':main()
