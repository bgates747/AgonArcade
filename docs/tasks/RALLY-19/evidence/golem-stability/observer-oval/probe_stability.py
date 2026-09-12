"""Headless deterministic replay with stock-call/finite-value/allocation observation.

Untimed diagnostic; no rendering-performance or physical-hardware claims.
"""
import argparse,csv,json,os,shutil,signal,struct,subprocess,time
from pathlib import Path
from profile import TASK,prepare
from capture import runtime_identity
from native_run import sha
from measure_swap_overhead import no_emulators

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--build',required=True)
    p.add_argument('--track',choices=['oval','fuji'],required=True);p.add_argument('--frames',type=int,default=18064);a=p.parse_args()
    assert 1<=a.frames<=60000;no_emulators()
    work=TASK/'.work/stability'/a.build;build=json.loads((work/'manifest.json').read_text())
    for path,digest in {**build['source_hashes'],**build['outputs']}.items():assert sha(Path(path))==digest,path
    root=TASK/'evidence/golem-stability'/a.name;root.mkdir(parents=True,exist_ok=False)
    sources=[TASK/'stability_probe_linux.cpp',TASK/'memory_probe_linux.cpp',Path(__file__)]
    for source in sources:shutil.copy2(source,root/source.name)
    library=root/'stability-probe.so'
    command=['g++','-std=c++17','-O2','-Wall','-Wextra','-Werror','-shared','-fPIC','-I'+str(Path.home()/'.local/include'),str(root/'stability_probe_linux.cpp'),'-ldl','-o',str(library)]
    with (root/'observer-build.txt').open('w') as log:subprocess.run(command,check=True,stdout=log,stderr=subprocess.STDOUT)
    env={k:v for k,v in os.environ.items() if not k.startswith(('RALLY_','R19_','DYLD_')) and k not in ('LD_PRELOAD','BASH_ENV','SDL_VIDEO_DRIVER')}
    env.update(ASAN_OPTIONS='detect_leaks=1:halt_on_error=1',UBSAN_OPTIONS='halt_on_error=1:print_stacktrace=1')
    with (root/'expected.dat').open('wb') as out,(root/'host-sanitizers.txt').open('w') as err:
        subprocess.run([str(work/'host'),str(int(a.track=='fuji')),str(a.frames)],check=True,stdout=out,stderr=err,env=env)
    assert (root/'expected.dat').stat().st_size==80*a.frames
    clear=(work/(a.track+'.clr')).read_bytes();assert len(clear)%6==0
    ids=[]
    for i in range(0,len(clear),6):
        assert clear[i:i+3]==bytes([23,0,160]) and clear[i+5]==2
        ids.append(int.from_bytes(clear[i+3:i+5],'little'))
    assert len(ids)==len(set(ids)) and len(ids) in [836,853]
    (root/'owned.txt').write_text(''.join(str(i)+'\n' for i in sorted(set(ids+[63984]))))
    profile=prepare(TASK/'.emulator'/('stability-'+a.name),work/'bin/rally.bin',f'{a.track} golem measure frames={a.frames}')
    app=profile/'sdcard/rally'
    for t in ['oval','fuji']:
        for ext in ['.vdp','.clr']:(app/(t+ext)).symlink_to(work/(t+ext))
    before=runtime_identity(profile)
    env.update(SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy',LD_PRELOAD=str(library),
        R19_VDP_MODULE=str(profile/'firmware/vdp_platform.so'),R19_MEMORY_PHASE=str(app/'memory.phase'),R19_MEMORY_REPORT=str(root/'memory.csv'),
        R19_STABILITY_IDS=str(root/'owned.txt'),R19_STABILITY_OUTPUT=str(root/'calls.csv'))
    launch=['./fab-agon-emulator','--renderer','sw'];started=time.monotonic()
    manifest={'scope':__doc__,'headless':True,'build':build,'track':a.track,'frames':a.frames,'observer_command':command,
        'observer_sources':{str(s):sha(s) for s in sources},'observer_sha256':sha(library),'runtime_before':before,'command':launch,'completed':False}
    (root/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    with (root/'emulator.log').open('w') as log:
        proc=subprocess.Popen(launch,cwd=profile,env=env,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
        try:
            progress=time.monotonic()
            while time.monotonic()-started<180+a.frames/20:
                if (app/'start.snk').exists() and not (app/'go.snk').exists():
                    manifest['actual_command']=(Path('/proc')/str(proc.pid)/'cmdline').read_bytes().decode().split('\0')[:-1]
                    assert not any(s in manifest['actual_command'] for s in ['-u','--unlimited_cpu'])
                    manifest['go_ns']=time.monotonic_ns();(app/'go.snk').touch()
                if (app/'done.snk').exists() and not (app/'stop.snk').exists() and (root/'memory.csv').exists():
                    if any(line.startswith('100,') for line in (root/'memory.csv').read_text().splitlines()):
                        manifest['done_ns']=time.monotonic_ns();(app/'stop.snk').touch()
                if (app/'replay-exit.snk').exists() and (root/'memory.csv').exists() and any(line.startswith('200,') for line in (root/'memory.csv').read_text().splitlines()):
                    manifest['completed']=True;break
                if proc.poll() is not None:raise RuntimeError('Emulator exited before finite replay report')
                if time.monotonic()-progress>30:
                    count=sum(1 for _ in (root/'calls.csv').open())-1 if (root/'calls.csv').exists() else 0
                    print(a.name,count,'/',a.frames,'jobs',flush=True);progress=time.monotonic()
                time.sleep(.03)
            assert manifest['completed'],'Replay timed out; failed evidence retained'
        finally:
            if proc.poll() is None:
                os.killpg(proc.pid,signal.SIGTERM)
                try:proc.wait(timeout=5)
                except subprocess.TimeoutExpired:os.killpg(proc.pid,signal.SIGKILL);proc.wait()
            manifest.update(returncode=proc.returncode,host_seconds=time.monotonic()-started,runtime_after=runtime_identity(profile))
            (root/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    for k,v in before.items():assert manifest['runtime_after'][k]==v
    for name in ['replay-summary.csv','replay-readback.dat','replay-exit.snk']:shutil.copy2(app/name,root/name)
    expected=(root/'expected.dat').read_bytes();calls=list(csv.DictReader((root/'calls.csv').open()));assert len(calls)==a.frames,len(calls)
    for i,row in enumerate(calls):
        assert int(row['call'])==i
        assert [int(row[k]) for k in ['valid','wrap','count','last','error','expected']]==[1,1,(i+1)%65536,i,0,i+1],(i,row)
        assert bytes.fromhex(row['active_hex'])==expected[i*80:(i+1)*80],('state differs',i,row['active_hex'],expected[i*80:(i+1)*80].hex())
        assert int(row['nonfinite'])==int(row['read_errors'])==0 and int(row['matrices'])>0,(i,row)
    readback=(root/'replay-readback.dat').read_bytes();assert len(readback)==92
    assert list(struct.unpack('<6H',readback[:12]))==[int(calls[-1][k]) for k in ['valid','wrap','count','last','error','expected']]
    assert readback[12:]==expected[-80:]
    summary=(root/'replay-summary.csv').read_text();assert summary.endswith('# complete\n')
    data=next(csv.DictReader(summary.splitlines()[:2]));assert int(data['frames'])==a.frames and int(data['scene_bytes'])==97*a.frames and int(data['cleanup'])==1
    report={'pass':True,'scope':__doc__,'frames':a.frames,'track':a.track,'guest_ticks':int(data['ticks']),
        'long_duration_pass':int(data['ticks'])>=72000,'all_active_payloads_exact':True,'guest_final_readback_exact':True,
        'nonfinite':0,'read_errors':0,'memory_ranges':{key:[min(int(r[key]) for r in calls),max(int(r[key]) for r in calls)] for key in ['matrices','live_allocs','live_bytes']},
        'remaining':'Audit steady-state allocation history, lifecycle/malformed inputs and coverage before R19-11 acceptance.'}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report),flush=True)
if __name__=='__main__':main()
