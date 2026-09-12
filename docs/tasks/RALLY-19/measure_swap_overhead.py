"""Serial normal-clock ABBA qualification of the native swap observer's overhead.

Both variants run the exact accepted oracle. This does not benchmark Golem.
"""
import argparse,csv,io,json,os,signal,statistics,subprocess,time
from pathlib import Path
from profile import TASK,prepare
from capture import runtime_identity
from native_run import sha

def integers(path):
    return [{k:int(v) for k,v in r.items()} for r in csv.DictReader(io.StringIO(path.read_text().split('# complete')[0]))]

def no_emulators():
    for p in Path('/proc').iterdir():
        if not p.name.isdigit():continue
        try:target=(p/'exe').resolve(strict=True)
        except (FileNotFoundError,PermissionError,ProcessLookupError):continue
        assert target.name!='fab-agon-emulator',f'Another emulator is active: {p.name}'

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');a=p.parse_args()
    root=TASK/'evidence/golem-swap-overhead'/a.name;root.mkdir(parents=True,exist_ok=False)
    home=Path.home();library=root/'swap-probe.so';source=TASK/'swap_probe_linux.cpp'
    command=['g++','-std=c++17','-O2','-Wall','-Wextra','-Werror','-shared','-fPIC',
             '-I'+str(home/'.local/include'),'-L'+str(home/'.local/lib'),
             '-Wl,-rpath,'+str(home/'.local/lib'),str(source),'-lSDL3','-ldl','-o',str(library)]
    with (root/'build.txt').open('w') as log:subprocess.run(command,check=True,stdout=log,stderr=subprocess.STDOUT)
    source_hash=sha(source);library_hash=sha(library)
    binary=TASK/'.work/oracle/bin/rally.bin'
    assert sha(binary)=='03322954c8c4fe29d90eaa0706c9169b242cdd264ea3b7b287cece58a6469d79'
    planned=[]
    # Prepare all profiles and compile the observer before any timing run.
    for track in ['oval','fuji']:
        for index,observed in enumerate([False,True,True,False]):
            name=f'{track}-{index}-'+('observed' if observed else 'plain')
            output=root/name;output.mkdir()
            profile=prepare(TASK/'.emulator'/('swap-overhead-'+a.name+'-'+name),binary,track+' measure')
            planned.append((track,index,observed,output,profile,runtime_identity(profile)))
    runs=[]
    for track,index,observed,output,profile,before in planned:
        no_emulators();app=profile/'sdcard/rally'
        env={k:v for k,v in os.environ.items() if not k.startswith(('RALLY_','R19_','DYLD_'))
             and k not in ('LD_PRELOAD','BASH_ENV','SDL_VIDEO_DRIVER')}
        env.update(SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy')
        if observed:
            env.update(LD_PRELOAD=str(library),R19_VDP_MODULE=str(profile/'firmware/vdp_platform.so'),
                       R19_SWAP_COUNT='68',R19_SWAP_STOP=str(output/'flush'),R19_SWAP_OUTPUT=str(output/'swaps.csv'))
        launch=['./fab-agon-emulator','--renderer','sw'];begin=time.monotonic()
        manifest={'scope':__doc__,'track':track,'index':index,'observed':observed,'headless':True,
                  'command':launch,'runtime_before':before,'completed':False,'load_before':os.getloadavg()}
        print('START',output.name,flush=True)
        with (output/'emulator.log').open('w') as log:
            proc=subprocess.Popen(launch,cwd=profile,env=env,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
            try:
                while time.monotonic()-begin<90:
                    if (app/'start.snk').exists() and not (app/'go.snk').exists():
                        actual=(Path('/proc')/str(proc.pid)/'cmdline').read_bytes().decode().split('\0')[:-1]
                        assert Path(actual[0]).name=='fab-agon-emulator'
                        assert not any(x in actual for x in ['-u','--unlimited_cpu','--unlimited-cpu'])
                        manifest['actual_command']=actual
                        manifest['go_wall_ns']=time.monotonic_ns();(app/'go.snk').touch()
                    if (app/'done.snk').exists() and not (app/'stop.snk').exists():
                        manifest['done_wall_ns']=time.monotonic_ns();(app/'stop.snk').touch()
                    result=app/'measurement.csv'
                    if result.exists() and result.read_text().endswith('# complete\n'):
                        if observed:(output/'flush').touch(exist_ok=True)
                        swaps=output/'swaps.csv'
                        if not observed or (swaps.exists() and swaps.read_text().endswith('# complete\n')):
                            manifest['completed']=True;break
                    if proc.poll() is not None:raise RuntimeError('Emulator exited before evidence')
                    time.sleep(.01)
                assert manifest['completed'],'Timed out; partial evidence retained'
            finally:
                if proc.poll() is None:
                    os.killpg(proc.pid,signal.SIGTERM)
                    try:proc.wait(timeout=5)
                    except subprocess.TimeoutExpired:os.killpg(proc.pid,signal.SIGKILL);proc.wait()
                manifest.update(returncode=proc.returncode,wall_seconds_with_startup=time.monotonic()-begin,load_after=os.getloadavg())
                (output/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
        after=runtime_identity(profile);assert all(after.get(k)==v for k,v in before.items())
        (output/'measurement.csv').write_bytes((app/'measurement.csv').read_bytes())
        data=integers(output/'measurement.csv')[0]
        assert data['frames']==64 and data['cars']==384 and data['completed']==1
        run={'track':track,'index':index,'observed':observed,'data':data,'runtime_inputs_unchanged':True}
        if observed:
            rows=integers(output/'swaps.csv');events={k:[r for r in rows if r['kind']==k] for k in [0,1]}
            assert len(rows)==136
            for records in events.values():
                assert [r['ordinal'] for r in records]==list(range(68))
                assert all(x['end_ns']<=y['begin_ns'] for x,y in zip(records,records[1:]))
            for c,v in zip(events[0],events[1]):assert c['begin_ns']<=v['begin_ns']<=v['end_ns']<=c['end_ns']
            # Omit the first measured transition, which contains a host marker
            # handshake. Keep all64 workload events and63 steady intervals.
            run['visible_intervals_ms']=[(events[1][i]['end_ns']-events[1][i-1]['end_ns'])/1e6 for i in range(5,68)]
            run['canvas_intervals_ms']=[(events[0][i]['end_ns']-events[0][i-1]['end_ns'])/1e6 for i in range(5,68)]
            run['observer_events']=136
        runs.append(run)
        (root/'partial.json').write_text(json.dumps({'scope':__doc__,'runs':runs},indent=2)+'\n')
        print('DONE',output.name,'submit_ticks',data['submit_ticks'],flush=True)
    summary=[]
    for track in ['oval','fuji']:
        subset=[r for r in runs if r['track']==track]
        assert len({r['data']['pose_hash'] for r in subset})==1
        assert len({r['data']['road_bytes'] for r in subset})==1
        means={v:statistics.mean(r['data']['submit_ticks'] for r in subset if r['observed']==v) for v in [False,True]}
        change=100*(means[True]/means[False]-1)
        summary.append({'track':track,'plain_mean_ticks':means[False],'observed_mean_ticks':means[True],
                        'observer_change_percent':change,'pass':abs(change)<=5})
    assert source_hash==sha(source) and library_hash==sha(library)
    report={'scope':__doc__,'pass':all(r['pass'] for r in summary),'summary':summary,'runs':runs,
            'observer_source_sha256':source_hash,'library_sha256':library_hash,'runner_sha256':sha(Path(__file__)),
            'clock_hz':120,'cpu_hz':18432000,'observer_effect_guard_percent':5,
            'limitations':'Eight serial64-pose oracle runs. Guest timing quantized at8.333ms; marker polling outside guest timed span. '
                          'Observed intervals are native viewport swaps, not SDL presents. This establishes no Golem speedup.'}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(summary,indent=2))
    assert report['pass'],'Observer overhead guard failed; retain evidence'

if __name__=='__main__':main()
