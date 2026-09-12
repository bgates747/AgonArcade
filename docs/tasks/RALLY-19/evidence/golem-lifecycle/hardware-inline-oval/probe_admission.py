"""Exercise full 80-byte Rally state admission on unmodified stock VDP.

Trusted transport is ordered update then call; cut raw writes are never followed
by a trigger, and receive an explicit idle timeout before diagnostic polling.
"""
from pathlib import Path
import argparse, hashlib, json, os, shutil, signal, struct, subprocess, time
from profile import prepare, TASK
from capture import runtime_identity
GOLEM=Path('/home/smith/Agon/mystuff/golem-rally19')
CALL=bytes([23,0,160,208,7,1])
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def put(data,offset,width,value):data[offset:offset+width]=(value%(1<<(8*width))).to_bytes(width,'little')
def update(data,count=None,buffer=1000,offset=0):
    return bytes([23,0,160])+struct.pack('<H',buffer)+bytes([5,0xc2])+struct.pack('<HH',offset,len(data) if count is None else count)+data
def state(sequence,track,position=65535):
    out=bytearray(80)
    for offset,width,value in [(0,2,1),(2,2,80),(4,2,sequence),(6,2,track),(8,4,position),(12,2,7999),(14,2,-21),(16,4,-38400),(20,2,300),(22,2,2),(72,2,7),(74,2,25),(76,2,sequence),(78,2,0x5a19)]:put(out,offset,width,value)
    for i in range(6):put(out,24+8*i,4,position);put(out,28+8*i,2,-90)
    return out

def cases(track):
    events=[];active=bytes(80);valid=wrap=count=last=error=expected=0;result=0.0
    def event(name,wire=b'',kind=0,wait=0,accept=None,reject=False,reset=False,set_expected=None):
        nonlocal active,valid,wrap,count,last,error,expected,result
        if reset:active=bytes(80);valid=wrap=count=last=error=expected=0;result=0.0
        if set_expected is not None:expected=set_expected
        if accept is not None:
            active=bytes(accept);valid=1;last=int.from_bytes(active[4:6],'little');count=(count+1)%65536;expected=(last+1)%65535;wrap=int(last!=65534);error=0;result=float(int.from_bytes(active[8:12],'little',signed=True)*2)
        if reject:valid=0;error=1
        want=active+struct.pack('<6Hf',valid,wrap,count,last,error,expected,result)
        events.append({'name':name,'kind':kind,'wait_ticks':wait,'wire':wire.hex(),'expected':want.hex(),'accepted':accept is not None})
    event('bootstrap')
    first=state(0,track);event('valid_signed_boundaries_and_low_word_ffff',update(first)+CALL,accept=first)
    event('duplicate_sequence',update(first)+CALL,reject=True)
    gap=state(2,track);event('sequence_gap',update(gap)+CALL,reject=True)
    lap=576000 if track==0 else 3276800
    edge=state(expected,track,lap-1)
    for offset,width,value in [(14,2,21),(16,4,38400),(74,2,200)]:put(edge,offset,width,value)
    for i in range(6):put(edge,28+8*i,2,90)
    event('valid_upper_track_and_signed_bounds',update(edge)+CALL,accept=edge)
    tests=[('version',0,2,[0,2,65535]),('length',2,2,[0,79,81,65535]),('sequence',4,2,[65535]),('track',6,2,[1-track,2,65535]),('position',8,4,[-1,lap,2147483647,-2147483648]),('phase',12,2,[8000,65535]),('steering',14,2,[-22,22,-32768,32767]),('lateral',16,4,[-38401,38401,-2147483648,2147483647]),('speed',20,2,[301,65535]),('surface',22,2,[3,65535]),('flags',72,2,[8,65535]),('grip',74,2,[24,201,65535]),('sequence_copy',76,2,[expected+1,65535]),('seal',78,2,[0,0x5a18,65535])]
    for i in range(6):tests += [(f'car{i}_position',24+8*i,4,[-1,lap]),(f'car{i}_lane',28+8*i,2,[-91,91]),(f'car{i}_reserved',30+8*i,2,[1,65535])]
    for name,offset,width,values in tests:
        for value in values:
            bad=state(expected,track);put(bad,offset,width,value)
            event(f'bad_{name}_{value}',update(bad)+CALL,reject=True)
    # Genuine 0xffff bytes in otherwise valid signed/unsigned positions.
    ones=state(expected,track,131071)
    for offset,width in [(14,2),(16,4)]+[(28+8*i,2) for i in range(6)]:put(ones,offset,width,-1)
    event('valid_minus_one_and_ffff_low_words',update(ones)+CALL,accept=ones)
    for length in range(80):
        short=state(expected,track)[:length]
        event(f'declared_short_{length}',update(short)+CALL,reject=True)
    # No trigger after an interrupted count-80 payload. The stock command's
    # documented byte timeout is 200 ms; leave 500 ms idle before polling.
    for length in [0,1,10,40,79]:
        event(f'raw_cut_{length}_idle_500ms',update(state(expected,track)[:length],count=80),wait=60)
        recovered=state(expected,track)
        event(f'recovery_after_cut_{length}',update(recovered)+CALL,accept=recovered)
    for length in range(1,11):
        event(f'raw_header_cut_{length}_idle_2000ms',update(state(expected,track))[:length],wait=240)
        recovered=state(expected,track)
        event(f'recovery_after_header_cut_{length}',update(recovered)+CALL,accept=recovered)
    for length in range(1,6):
        event(f'raw_trigger_cut_{length}_idle_2000ms',update(state(expected,track))+CALL[:length],wait=240)
        recovered=state(expected,track)
        event(f'recovery_after_trigger_cut_{length}',update(recovered)+CALL,accept=recovered)
    event('repeat_trigger_without_state',CALL,reject=True)
    full=state(expected,track)
    event('complete_staging_without_trigger',update(full))
    event('delayed_single_trigger',CALL,accept=full)
    event('repeat_delayed_trigger',CALL,reject=True)
    # Diagnostic-only seed avoids 65,534 frames before checking modulo wrap.
    event('seed_expected_65534',update(struct.pack('<H',65534),buffer=1003),set_expected=65534)
    final=state(65534,track);event('accept_sequence_65534',update(final)+CALL,accept=final)
    zero=state(0,track);event('accept_sequence_zero_after_wrap',update(zero)+CALL,accept=zero)
    event('reload_resets_state',kind=1,reset=True)
    zero=state(0,track);event('first_frame_after_reload',update(zero)+CALL,accept=zero)
    encoded=bytearray(b'G19A'+struct.pack('<H',len(events)))
    for e in events:
        raw=bytes.fromhex(e['wire']);encoded+=struct.pack('<BHH',e['kind'],len(raw),e['wait_ticks'])+raw
    return events,encoded

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--track',choices=['oval','fuji'],default='oval');args=p.parse_args()
    track=int(args.track=='fuji');events,encoded=cases(track)
    root=TASK/'evidence/golem-admission'/args.name;root.mkdir(parents=True,exist_ok=False)
    build=GOLEM/'build/native-admission'/args.name;(build/'src').mkdir(parents=True,exist_ok=False)
    source=GOLEM/'examples/native_admission'
    for a,b in [('main.cpp','src/main.cpp'),('Makefile','Makefile')]:shutil.copy2(source/a,build/b)
    (build/'admission.golem').write_text((TASK/'admission.golem').read_text().replace('Set(loadedTrack,0);',f'Set(loadedTrack,{track});'))
    (root/'cases.json').write_text(json.dumps(events,indent=2)+'\n')
    with (root/'build.txt').open('w') as log:
        subprocess.run(['make','-C',str(GOLEM/'src')],check=True,stdout=log,stderr=subprocess.STDOUT)
        subprocess.run([str(GOLEM/'build/golemc'),'--hosted',str(build/'admission.golem'),str(build/'program.bin')],check=True,stdout=log,stderr=subprocess.STDOUT)
        subprocess.run(['make','-C',str(build)],check=True,stdout=log,stderr=subprocess.STDOUT)
    profile=prepare(TASK/'.emulator'/('admission-'+args.name),build/'bin/probe.bin','')
    app=profile/'sdcard/rally';(app/'program.bin').symlink_to(build/'program.bin');(app/'cases.dat').write_bytes(encoded)
    files=[source/'main.cpp',GOLEM/'src/hosted.hpp',GOLEM/'src/golemc.cpp',GOLEM/'build/golemc',build/'admission.golem',build/'program.bin',build/'bin/probe.bin']
    (root/'identity.json').write_text(json.dumps({str(f.relative_to(GOLEM)):sha(f) for f in files},indent=2)+'\n')
    for f in [source/'main.cpp',build/'admission.golem',build/'program.bin.map']:shutil.copy2(f,root/f.name)
    before=runtime_identity(profile)
    env={k:v for k,v in os.environ.items() if not k.startswith(('RALLY_','DYLD_')) and k not in ('LD_PRELOAD','BASH_ENV')}
    env.update(SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy')
    command=['./fab-agon-emulator','--renderer','sw'];started=time.monotonic()
    with (root/'emulator.log').open('w') as log:
        proc=subprocess.Popen(command,cwd=profile,env=env,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
        try:
            while not (app/'exit.txt').exists():
                if proc.poll() is not None:raise RuntimeError('emulator exited before guest completion')
                if time.monotonic()-started>180:raise TimeoutError('native admission')
                time.sleep(.02)
        finally:
            if proc.poll() is None:
                os.killpg(proc.pid,signal.SIGTERM)
                try:proc.wait(timeout=5)
                except subprocess.TimeoutExpired:os.killpg(proc.pid,signal.SIGKILL);proc.wait()
    after=runtime_identity(profile)
    for name in ['results.dat','exit.txt']:
        if (app/name).exists():shutil.copy2(app/name,root/('guest-'+name))
    (root/'manifest.json').write_text(json.dumps({'command':command,'runtime_before':before,'runtime_after':after,'scope':__doc__,'host_seconds':time.monotonic()-started},indent=2)+'\n')
    assert all(after[k]==v for k,v in before.items())
    assert (root/'guest-exit.txt').read_text().strip()=='0',(root/'guest-exit.txt').read_text()
    raw=(root/'guest-results.dat').read_bytes();assert len(raw)==96*len(events),(len(raw),len(events))
    results=[]
    for i,e in enumerate(events):
        got=raw[96*i:96*(i+1)];want=bytes.fromhex(e['expected'])
        results.append({'name':e['name'],'pass':got==want,'different_offsets':[j for j in range(96) if got[j]!=want[j]],'actual':got.hex()})
    passed=all(r['pass'] for r in results)
    (root/'results.json').write_text(json.dumps({'pass':passed,'track':args.track,'cases':len(results),'accepted':sum(e['accepted'] for e in events),'results':results,'limitations':['GP observes parser/buffer progress, not raster completion.','The finite render proof multiplies admitted progress by two; this is not the complete Rally renderer.','500 ms payload / 2000 ms header/trigger idle is diagnostic recovery, not transactional UART.','Wrap is seeded through a diagnostic write to expectedSequence.']},indent=2)+'\n')
    assert passed,[r for r in results if not r['pass']][:5]
    print('Native full-state admission:',args.track,len(results),'cases pass')
if __name__=='__main__':main()
