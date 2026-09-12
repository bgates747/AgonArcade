"""Full-scene stock-VDP malformed transport, sequence wrap and owned lifecycle."""
import argparse,csv,json,os,shutil,signal,struct,subprocess,time
from pathlib import Path
from profile import TASK,prepare
from capture import runtime_identity
from native_run import sha
from probe_admission import cases,CALL
from measure_swap_overhead import no_emulators

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--build',required=True)
    p.add_argument('--track',choices=['oval','fuji'],required=True);a=p.parse_args();no_emulators()
    work=TASK/'.work/lifecycle'/a.build;build=json.loads((work/'manifest.json').read_text())
    for path,digest in {**build['source_hashes'],**build['outputs']}.items():assert sha(Path(path))==digest,path
    root=TASK/'evidence/golem-lifecycle'/a.name;root.mkdir(parents=True,exist_ok=False)
    events,encoded=cases(int(a.track=='fuji'));(root/'cases.json').write_text(json.dumps(events,indent=2)+'\n')
    for name in ['stability_probe_linux.cpp','memory_probe_linux.cpp','probe_admission.py','probe_lifecycle.py']:shutil.copy2(TASK/name,root/name)
    library=root/'observer.so';command=['g++','-std=c++17','-O2','-Wall','-Wextra','-Werror','-shared','-fPIC','-I'+str(Path.home()/'.local/include'),str(root/'stability_probe_linux.cpp'),'-ldl','-o',str(library)]
    with (root/'build.txt').open('w') as log:subprocess.run(command,check=True,stdout=log,stderr=subprocess.STDOUT)
    clear=(work/(a.track+'.clr')).read_bytes();assert len(clear)%6==0
    ids=[]
    for i in range(0,len(clear),6):
        assert clear[i:i+3]==bytes([23,0,160]) and clear[i+5]==2;ids.append(int.from_bytes(clear[i+3:i+5],'little'))
    assert len(ids)==len(set(ids)) and len(ids) in [836,853]
    (root/'owned.txt').write_text(''.join(str(i)+'\n' for i in sorted(set(ids+[63984]))))
    profile=prepare(TASK/'.emulator'/('lifecycle-'+a.name),work/'bin/rally.bin',a.track+' golem measure');app=profile/'sdcard/rally'
    for t in ['oval','fuji']:
        for ext in ['.vdp','.clr']:(app/(t+ext)).symlink_to(work/(t+ext))
    (app/'cases.dat').write_bytes(encoded);(app/'owned.dat').write_bytes(struct.pack('<'+'H'*len(ids),*ids))
    before=runtime_identity(profile)
    env={k:v for k,v in os.environ.items() if not k.startswith(('RALLY_','R19_','DYLD_')) and k not in ('LD_PRELOAD','BASH_ENV','SDL_VIDEO_DRIVER')}
    env.update(SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy',LD_PRELOAD=str(library),R19_VDP_MODULE=str(profile/'firmware/vdp_platform.so'),
        R19_MEMORY_PHASE=str(app/'memory.phase'),R19_MEMORY_REPORT=str(root/'memory.csv'),R19_STABILITY_IDS=str(root/'owned.txt'),R19_STABILITY_OUTPUT=str(root/'calls.csv'))
    launch=['./fab-agon-emulator','--renderer','sw'];start=time.monotonic()
    manifest={'scope':__doc__,'headless':True,'build':build,'track':a.track,'runtime_before':before,'command':launch,'observer_command':command,'observer_sha256':sha(library),'source_sha256':sha(Path(__file__)),'completed':False}
    with (root/'emulator.log').open('w') as log:
        proc=subprocess.Popen(launch,cwd=profile,env=env,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
        try:
            progress=time.monotonic()
            while time.monotonic()-start<900:
                if (root/'memory.csv').exists():
                    for line in (root/'memory.csv').read_text().splitlines():
                        if line.count(',')!=5:continue
                        phase=int(line.split(',')[0]);(app/f'ack-{phase}.snk').touch(exist_ok=True)
                if (app/'lifecycle-exit.snk').exists():manifest['completed']=True;break
                if proc.poll() is not None:raise RuntimeError('Emulator exited before lifecycle report')
                if time.monotonic()-progress>30:
                    size=(app/'lifecycle-events.dat').stat().st_size if (app/'lifecycle-events.dat').exists() else 0
                    print(a.name,'event bytes',size,'elapsed',round(time.monotonic()-start),flush=True);progress=time.monotonic()
                time.sleep(.02)
            assert manifest['completed'],'Lifecycle timeout; failed evidence retained'
        finally:
            if proc.poll() is None:
                os.killpg(proc.pid,signal.SIGTERM)
                try:proc.wait(timeout=5)
                except subprocess.TimeoutExpired:os.killpg(proc.pid,signal.SIGKILL);proc.wait()
            manifest.update(returncode=proc.returncode,host_seconds=time.monotonic()-start,runtime_after=runtime_identity(profile))
            (root/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
            for name in ['lifecycle-events.dat','ownership.dat','lifecycle-summary.csv','lifecycle-exit.snk']:
                if (app/name).exists():shutil.copy2(app/name,root/name)
    for k,v in before.items():assert manifest['runtime_after'][k]==v
    raw=(root/'lifecycle-events.dat').read_bytes();assert len(raw)==394*len(events),(len(raw),len(events))
    previous=None;geometry=[]
    for i,event in enumerate(events):
        row=raw[i*394:(i+1)*394];assert row[:96]==bytes.fromhex(event['expected']),(i,event['name'],row[:96].hex(),event['expected'])
        if not event['accepted'] and not event['kind'] and previous is not None:assert row[96:]==previous[96:],('Rejected/non-trigger event changed retained history or geometry',i,event['name'])
        if event['kind']:assert row[96:]==raw[96:394],('reload did not reset geometry/history',i)
        assert all(__import__('math').isfinite(v[0]) for v in struct.iter_unpack('<f',row[154:286]))
        geometry.append({'event':i,'name':event['name'],'accepted':event['accepted'],'retained_sha256':__import__('hashlib').sha256(row[96:]).hexdigest()});previous=row
    (root/'geometry.json').write_text(json.dumps(geometry,indent=2)+'\n')
    life=(root/'ownership.dat').read_bytes();assert life==(bytes([0x55,0xaa])*len(ids)+bytes([0x34,0x12]))*3
    calls_=list(csv.DictReader((root/'calls.csv').open()));expectedCalls=[e for e in events if bytes.fromhex(e['wire']).endswith(CALL)]
    assert len(calls_)==len(expectedCalls)+12,(len(calls_),len(expectedCalls))
    for i,(row,event) in enumerate(zip(calls_,expectedCalls)):
        assert bytes.fromhex(row['active_hex'])==bytes.fromhex(event['expected'])[:80],i
        assert [int(row[k]) for k in ['valid','wrap','count','last','error','expected']]==list(struct.unpack('<6H',bytes.fromhex(event['expected'])[80:92])),i
    for row in calls_:assert int(row['read_errors'])==int(row['nonfinite'])==0,row
    for cycle in range(3):
        for i,row in enumerate(calls_[len(expectedCalls)+cycle*4:len(expectedCalls)+(cycle+1)*4]):
            assert [int(row[k]) for k in ['valid','wrap','count','last','error','expected']]==[1,1,i+1,i,0,i+1]
    memory={int(row[0]):list(map(int,row[1:])) for row in csv.reader((root/'memory.csv').open())}
    assert set(memory)=={100,200,201,202,300,301,302,400},memory
    assert memory[200][:2]==memory[201][:2]==memory[202][:2],('cleanup growth',memory)
    assert memory[300][:2]==memory[301][:2]==memory[302][:2],('reload growth',memory)
    data=next(csv.DictReader((root/'lifecycle-summary.csv').read_text().splitlines()[:2]))
    assert int(data['cases'])==len(events) and int(data['accepted'])==sum(e['accepted'] for e in events) and int(data['reloads'])==1 and int(data['owned_ids'])==len(ids)
    report={'pass':True,'scope':__doc__,'track':a.track,'events':len(events),'accepted':sum(e['accepted'] for e in events),'observed_calls':len(calls_),
        'all_96_byte_readbacks_exact':True,'rejected_geometry_and_history_unchanged':True,'sequence_wrap':True,'nonfinite':0,
        'owned_ids':len(ids),'cleanup_cycles':3,'foreign_canary_preserved':True,'memory':memory,
        'remaining':'Final qualification audit and normal frontend exit on checked build; no hardware acceptance.'}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report),flush=True)
if __name__=='__main__':main()
