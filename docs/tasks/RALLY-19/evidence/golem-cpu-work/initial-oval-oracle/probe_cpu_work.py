"""Run finite CPU-only scene construction and validate intercepted command counts.

Optional debugger cycles cover construction plus sink/marker overhead, excluding
fixture physics, real UART transmission and VDP drawing. Not frame latency.
"""
import argparse,csv,io,json,os,re,signal,subprocess,time
from pathlib import Path
from profile import TASK,prepare
from capture import runtime_identity
from native_run import sha
from measure_swap_overhead import no_emulators

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--build',required=True)
    p.add_argument('--track',choices=['oval','fuji'],required=True);p.add_argument('--renderer',choices=['oracle','golem'],required=True)
    p.add_argument('--cycles',action='store_true');a=p.parse_args()
    no_emulators();work=TASK/'.work/cpu-work'/a.build;build=json.loads((work/'manifest.json').read_text())
    for path,digest in {**build['source_hashes'],**build['outputs']}.items():assert sha(Path(path))==digest,path
    root=TASK/'evidence/golem-cpu-work'/a.name;root.mkdir(parents=True,exist_ok=False)
    profile=prepare(TASK/'.emulator'/('cpu-work-'+a.name),work/'bin/rally.bin',f'{a.track} {a.renderer} measure compute')
    app=profile/'sdcard/rally'
    for track in ['oval','fuji']:
        for ext in ['.vdp','.clr']:(app/(track+ext)).symlink_to(work/(track+ext))
    before=runtime_identity(profile)
    env={k:v for k,v in os.environ.items() if not k.startswith(('RALLY_','R19_','DYLD_'))
         and k not in ('LD_PRELOAD','BASH_ENV','SDL_VIDEO_DRIVER')}
    env.update(SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy')
    launch=['./fab-agon-emulator','--renderer','sw']
    if a.cycles:
        mapping=(work/'bin/rally.map').read_text();launch+=['-d']
        for name in ['r19WorkBegin','r19WorkEnd']:
            address=int(re.search(r'(0x[0-9a-f]+)\s+_'+name+r'\s*$',mapping,re.M)[1],16)
            launch+=['-b',str(address)]
    manifest={'scope':__doc__,'track':a.track,'renderer':a.renderer,'debugger':a.cycles,'headless':True,
              'command':launch,'build':build,'runtime_before':before,'completed':False,'runner_sha256':sha(Path(__file__))}
    begin=time.monotonic()
    with (root/'emulator.log').open('w') as log:
        proc=subprocess.Popen(launch,cwd=profile,env=env,stdout=log,stderr=subprocess.STDOUT,
                              stdin=subprocess.PIPE if a.cycles else subprocess.DEVNULL,start_new_session=True)
        if a.cycles:proc.stdin.write(b'state\ncontinue\n'*128);proc.stdin.flush()
        try:
            while time.monotonic()-begin<120:
                if (app/'cpu-exit.snk').exists():manifest['completed']=True;break
                if proc.poll() is not None:raise RuntimeError('Emulator exited before CPU diagnostic report')
                time.sleep(.01)
            assert manifest['completed'],'Timed out; preserve failed profile/log'
        finally:
            if proc.poll() is None:
                os.killpg(proc.pid,signal.SIGTERM)
                try:proc.wait(timeout=5)
                except subprocess.TimeoutExpired:os.killpg(proc.pid,signal.SIGKILL);proc.wait()
            manifest.update(returncode=proc.returncode,wall_seconds_with_startup=time.monotonic()-begin)
            (root/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    after=runtime_identity(profile);assert all(after.get(k)==v for k,v in before.items())
    (root/'cpu-work.csv').write_bytes((app/'cpu-work.csv').read_bytes())
    raw=(root/'cpu-work.csv').read_text();assert raw.endswith('# complete\n')
    rows=[{k:int(v) for k,v in row.items()} for row in csv.DictReader(io.StringIO(raw.split('# complete')[0]))]
    assert [r['pose'] for r in rows]==list(range(64))
    baseline=json.loads((TASK/'evidence/baseline/manifest.json').read_text())
    want_hash=next(r['data']['pose_hash'] for r in baseline['runs'] if r['track']==a.track)
    assert rows[-1]['hash']==want_hash
    expected=[117]*64
    if a.renderer=='oracle':
        expected=[int(r['total_bytes']) for r in csv.DictReader((TASK/'evidence/baseline'/(a.track+'-bytes.csv')).read_text().splitlines())]
    assert [r['bytes'] for r in rows]==expected,'Not all native command construction agrees with independent accounting'
    assert all(r['calls']>0 for r in rows)
    if a.renderer=='golem':assert all(r['calls']==4 for r in rows),rows[:2]
    counts=[]
    if a.cycles:
        breaks=[int(v) for v in re.findall(r'Cycles since last break: (\d+)',(root/'emulator.log').read_text())]
        assert len(breaks)==128,len(breaks);counts=breaks[1::2]
    report={'scope':__doc__,'pass':True,'track':a.track,'renderer':a.renderer,'poses':64,'real_warmup_frames':2,
            'CPU_only_frames_not_rendered':64,'bytes_constructed':sum(expected),'per_pose':rows,'cycles':counts,
            'runtime_inputs_unchanged':True,'remaining':'Bound sink/marker overhead; matching real-rendering unpaced ABBA and frozen performance audit.'}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n')
    print('CPU construction/count probe passes:',a.track,a.renderer,'bytes',sum(expected),'cycle samples',len(counts))

if __name__=='__main__':main()
