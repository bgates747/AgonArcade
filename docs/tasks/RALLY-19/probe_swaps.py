"""Qualify native swap observation against the exact accepted 64-pose workload.

This initial probe tests event identity/order; it is not an offload benchmark.
"""
import argparse,csv,io,json,os,signal,subprocess,time
from pathlib import Path
from profile import TASK,prepare
from capture import runtime_identity
from native_run import sha

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name')
    p.add_argument('--track',choices=['oval','fuji'],default='oval');a=p.parse_args()
    root=TASK/'evidence/golem-swap-observer'/a.name;root.mkdir(parents=True,exist_ok=False)
    source=TASK/'swap_probe_linux.cpp';library=root/'swap-probe.so';home=Path.home()
    command=['g++','-std=c++17','-O2','-Wall','-Wextra','-Werror','-shared','-fPIC',
             '-I'+str(home/'.local/include'),'-L'+str(home/'.local/lib'),
             '-Wl,-rpath,'+str(home/'.local/lib'),str(source),'-lSDL3','-ldl','-o',str(library)]
    with (root/'build.txt').open('w') as log:subprocess.run(command,check=True,stdout=log,stderr=subprocess.STDOUT)
    binary=TASK/'.work/oracle/bin/rally.bin'
    assert sha(binary)=='03322954c8c4fe29d90eaa0706c9169b242cdd264ea3b7b287cece58a6469d79'
    profile=prepare(TASK/'.emulator'/('swaps-'+a.name),binary,a.track+' measure');app=profile/'sdcard/rally'
    before=runtime_identity(profile)
    env={k:v for k,v in os.environ.items() if not k.startswith(('RALLY_','R19_','DYLD_'))
         and k not in ('LD_PRELOAD','BASH_ENV','SDL_VIDEO_DRIVER')}
    env.update(SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy',LD_PRELOAD=str(library),
               R19_VDP_MODULE=str(profile/'firmware/vdp_platform.so'),R19_SWAP_COUNT='68',
               R19_SWAP_STOP=str(root/'flush'),R19_SWAP_OUTPUT=str(root/'swaps.csv'))
    launch=['./fab-agon-emulator','--renderer','sw'];begin=time.monotonic()
    manifest={'scope':__doc__,'headless':True,'track':a.track,'command':launch,'build_command':command,
              'source_sha256':sha(source),'probe_sha256':sha(Path(__file__)),'library_sha256':sha(library),
              'runtime_before':before,'completed':False}
    with (root/'emulator.log').open('w') as log:
        proc=subprocess.Popen(launch,cwd=profile,env=env,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
        try:
            while time.monotonic()-begin<90:
                if (app/'start.snk').exists() and not (app/'go.snk').exists():(app/'go.snk').touch()
                if (app/'done.snk').exists() and not (app/'stop.snk').exists():(app/'stop.snk').touch()
                result=app/'measurement.csv'
                if result.exists() and result.read_text().endswith('# complete\n'):
                    (root/'flush').touch(exist_ok=True)
                    output=root/'swaps.csv'
                    if output.exists() and output.read_text().endswith('# complete\n'):
                        manifest['completed']=True;break
                if proc.poll() is not None:raise RuntimeError('Native emulator exited before evidence')
                time.sleep(.01)
            assert manifest['completed'],'Timed out; retain partial logs/profile'
        finally:
            if proc.poll() is None:
                os.killpg(proc.pid,signal.SIGTERM)
                try:proc.wait(timeout=5)
                except subprocess.TimeoutExpired:os.killpg(proc.pid,signal.SIGKILL);proc.wait()
            manifest['returncode']=proc.returncode;manifest['wall_seconds_with_startup']=time.monotonic()-begin
            (root/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    after=runtime_identity(profile);assert all(after.get(k)==v for k,v in before.items())
    rows=[{k:int(v) for k,v in row.items()} for row in csv.DictReader(io.StringIO((root/'swaps.csv').read_text().split('# complete')[0]))]
    variants={kind:[r for r in rows if r['kind']==kind] for kind in [0,1]}
    # Mode136 clears both pages by swapping once internally (vdu.h vdu_mode).
    # taskDiagnostic then explicitly swaps once, warms twice and draws64 poses.
    assert len(rows)==136 and all(len(r)==68 for r in variants.values()),{k:len(v) for k,v in variants.items()}
    for kind,records in variants.items():
        assert [r['ordinal'] for r in records]==list(range(68))
        assert all(r['begin_ns']<=r['end_ns'] for r in records)
        assert all(x['end_ns']<=y['begin_ns'] for x,y in zip(records,records[1:]))
    for c,v in zip(variants[0],variants[1]):assert c['begin_ns']<=v['begin_ns']<=v['end_ns']<=c['end_ns']
    measurement=(app/'measurement.csv').read_bytes();(root/'measurement.csv').write_bytes(measurement)
    data={k:int(v) for k,v in next(csv.DictReader(io.StringIO(measurement.decode()))).items()}
    assert data['frames']==64 and data['cars']==384 and data['completed']==1
    report={'scope':__doc__,'pass':True,'swaps':68,'mode_initialization_swap':1,'startup_swap':1,'warmup_swaps':2,'workload_swaps':64,
            'events':136,'strict_nesting_and_sequence':True,'measurement':data,
            'runtime_inputs_unchanged':True,'swaps_sha256':sha(root/'swaps.csv'),
            'remaining':'Observer overhead/disabled comparison, true scene-work CPU spans and candidate ABBA. No performance pass yet.'}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))

if __name__=='__main__':main()
