"""Stock-runtime baseline: finite compute-only cycles and unpaced submit batches.
No capture library, VDP proxy, custom firmware or CPU unthrottling is loaded.
"""
from pathlib import Path
import csv,io,json,os,re,signal,subprocess,time
from profile import TASK,prepare
ROOT=TASK/'.work/oracle'
OUT=TASK/'evidence/baseline'
def run(track,mode,index):
    name=f'{track}-{index:02d}-{mode}'
    pdir=TASK/'.emulator'/('baseline-'+name)
    options=track+' measure'+(' compute' if mode=='compute' else '')
    prepare(pdir,ROOT/'bin/rally.bin',options)
    app=pdir/'sdcard/rally';report=app/'measurement.csv'
    env=os.environ.copy()
    for key in list(env):
        if key.startswith(('RALLY_','DYLD_')) or key in ('LD_PRELOAD','BASH_ENV','SDL_VIDEO_DRIVER'):env.pop(key,None)
    env.update(SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy')
    command=['./fab-agon-emulator','--renderer','sw']
    if mode=='compute':
        mapping=(ROOT/'bin/rally.map').read_text()
        command+=['-d']
        for n in ('r18Begin','r18End'):
            command+=['-b',str(int(re.search(r'(0x[0-9a-f]+)\s+_'+n+r'\s*$',mapping,re.M)[1],16))]
    begin=time.monotonic();load=os.getloadavg();external={}
    with (OUT/(name+'.log')).open('w') as log:
        proc=subprocess.Popen(command,cwd=pdir,env=env,stdout=log,stderr=subprocess.STDOUT,stdin=subprocess.PIPE if mode=='compute' else subprocess.DEVNULL,start_new_session=True)
        if mode=='compute':proc.stdin.write(b'state\ncontinue\nstate\ncontinue\n');proc.stdin.flush()
        try:
            while time.monotonic()-begin<120:
                if (app/'start.snk').exists() and not (app/'go.snk').exists():
                    external['start_wall']=time.monotonic();(app/'go.snk').touch()
                if (app/'done.snk').exists() and not (app/'stop.snk').exists():
                    external['done_wall']=time.monotonic();(app/'stop.snk').touch()
                if report.exists() and report.read_text().endswith('# complete\n'):break
                if proc.poll() is not None:raise RuntimeError(f'{name}: emulator exited')
                time.sleep(.01)
            else:raise RuntimeError(f'{name}: timed out')
        finally:
            if proc.poll() is None:
                os.killpg(proc.pid,signal.SIGTERM)
                try:proc.wait(timeout=5)
                except subprocess.TimeoutExpired:os.killpg(proc.pid,signal.SIGKILL);proc.wait()
    row={k:int(v) for k,v in next(csv.DictReader(io.StringIO(report.read_text()))).items()}
    assert row['frames']==64 and row['cars']==384 and row['completed']==1,row
    result={'case':name,'track':track,'mode':mode,'data':row,'load_before':load,'load_after':os.getloadavg(),'command':command,'external_batch_seconds':external['done_wall']-external['start_wall'],'timing_scope':'compute: guest instruction cycles; submit: raw-clock unpaced batch including UART-empty wait, no per-frame or timed post-swap poll'}
    if mode=='compute':
        counts=[int(v) for v in re.findall(r'Cycles since last break: (\d+)',(OUT/(name+'.log')).read_text())]
        assert len(counts)==2,counts
        result['cpu_cycles']=counts[1];result['ms_per_frame']=counts[1]/18432000*1000/64
        assert row['road_bytes']==0
    else:result['ms_per_frame']=row['submit_ticks']/120*1000/64
    (OUT/(name+'.csv')).write_bytes(report.read_bytes())
    print(name,result['ms_per_frame'],'ms/frame',flush=True)
    return result
if __name__=='__main__':
    OUT.mkdir(exist_ok=False)
    manifest={'oracle_binary':'03322954c8c4fe29d90eaa0706c9169b242cdd264ea3b7b287cece58a6469d79','cpu_hz':18432000,'clock_hz':120,'runs':[]}
    for track in ('oval','fuji'):
        for index,mode in enumerate(('compute','submit','submit','compute'),1):
            manifest['runs'].append(run(track,mode,index))
            (OUT/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    assert all(len({r['data']['pose_hash'] for r in manifest['runs'] if r['track']==track})==1 for track in ('oval','fuji'))
