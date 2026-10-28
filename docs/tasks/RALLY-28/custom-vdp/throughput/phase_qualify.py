"""Host proof for native phase state preservation, bounds and resident ordering."""
from pathlib import Path
import argparse
import ctypes as C
import hashlib
import json
import os
import struct
import subprocess
import sys
from phase_build import HERE,PACED,CONTROL,WORK,PRIVATE,HEADER,ROW,TAIL,records
sys.path.insert(0,str(PACED))
from qualify_candidates import NativeRuntime,specification,Traffic,contact,BASE
from host import Request
from phase_verify import decode
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()


def private(runtime,op):
    assert not runtime.live
    request=Request(C.sizeof(Request),2,PRIVATE+op,runtime.argument_id,0,2)
    rc=runtime.lib.vdplet_entry(C.byref(runtime.host),C.byref(request))
    assert not runtime.live
    runtime.canaries()
    return rc


def ordered_tail(meta,tape):
    tail=bytes.fromhex(meta['phase_tail_hex']);patches=meta['phase_handle_patch_offsets']
    assert len(patches)==7
    spans=[]
    for op,at in enumerate(patches,1):
        start=at-11
        assert tail[start:start+5]==b'\x17\0\xd8\x0c\0'
        assert struct.unpack_from('<BBHBBHHH',tail,start+5)==(1,2,0,0,0,0,PRIVATE+op,9)
        spans.append((start,start+17))
    assert spans[0][0]==0
    call=lambda key:b'\x17\0\xa0'+struct.pack('<H',key)+b'\1'
    flush=b'\x17\0\xca'
    between=[tail[a[1]:b[0]] for a,b in zip(spans,spans[1:])]
    assert between[0].startswith(b'\x1a\x1f\0\0RALLY / GOLEM NATIVE DEMO') and between[0].endswith(flush)
    assert between[1:4]==[call(key)+flush for key in (50301,50302,50303)]
    assert between[4]==b'' # Bounded empty-marker overhead control.
    assert between[5]==b'\x17\0\xc3'+flush
    assert tail[spans[-1][1]:]==b'\x17\0\xa0\xff\xff\7'
    parsed=records(tape)
    sites=[i for i,r in enumerate(parsed) if r['loop'] and r['opcode']==1 and
           tape[r['payload_offset']:r['payload_offset']+r['payload_bytes']]==call(TAIL)]
    assert len(sites)==1
    acknowledged=parsed[sites[0]+1];stamp=parsed[sites[0]+2]
    assert acknowledged['opcode']==2 and acknowledged['flags']==20
    body=tape[acknowledged['payload_offset']:acknowledged['payload_offset']+acknowledged['payload_bytes']]
    assert body[:3]==b'\x17\0\xd8' and body[6]==5 and struct.unpack_from('<HI',body,11)==(50305,10)
    assert stamp['opcode']==5 and stamp['loop']
    return dict(seven_silent_private_markers=True,resident_order='clear+flush / road+flush / actors+flush / player+flush / empty / swap+flush',
                no_uart_replies_inside_tail=True,quad_path_closed_before_road_end_marker=True,
                swap_submitted_then_worker_flush_before_final_marker=True,
                record_commit_acknowledged_before_foreground_timestamp=True)


def replay(mode):
    report={};tables=json.loads((BASE/'reference/tables.json').read_text())
    frames=json.loads((HERE/'phase_BUILD.json').read_text())['control']['frames']
    for name in ('control','float-quad-layered'):
        package=WORK/name/'package';s=specification(package)
        r=NativeRuntime(s,WORK/name/('phase-'+mode+'.so'))
        plain=NativeRuntime(s,WORK/name/('baseline-'+mode+'.so'))
        r.install(50305,bytes(HEADER+frames*ROW));assert r.invoke('InitRace')==plain.invoke('InitRace')==0
        assert private(r,0)==0
        model=Traffic(tables,'circuit',3276800,1,99);player=3246800
        for car,gap in zip(model.cars,[0,3199,3200,6400,18000,80000]):
            car.active=1;car.progress=player+gap;car.position=car.progress%model.lap;car.lateral=0
        state_digest=hashlib.sha256();output_digest=hashlib.sha256()
        for tick in range(1,frames*4+1):
            speed=tables['records'][(model.pace.record+1)%6 if model.pace.remaining==0 else model.pace.record][1]
            player+=speed*2;model.advance(player,tick)
            assert r.invoke('Tick120')==plain.invoke('Tick120')==0
            root,arrays=r.snapshot()
            expected=dict(worldTick=tick,playerStation=player%model.lap,playerUnwrapped=player,renderPhase=player%8000,
                routeRecord=model.pace.record,routeRemaining=model.pace.remaining,routeHeading=model.pace.heading,routeLateral=model.pace.lateral)
            for field,value in expected.items():assert s.get(root,field)==value,(name,tick,field)
            hits=[]
            for i,car in enumerate(model.cars):
                hit=int(contact(car.position,car.lateral,player%model.lap,0,model.lap));hits.append(hit)
                for field,value in [('active',car.active),('position',car.position),('progress',car.progress),('lateral',car.lateral),('contacts',hit)]:
                    assert s.array_get(arrays,field,i)==value,(name,tick,field,i)
            assert s.get(root,'contactAny')==bool(any(hits))
            assert (root,arrays)==plain.snapshot()
            if tick%4:continue
            assert r.invoke('Render30')==plain.invoke('Render30')==0
            root,arrays=r.snapshot();assert (root,arrays)==plain.snapshot()
            done=r.data(50304);assert done==plain.data(50304)
            for key,n in zip((50301,50302,50303),struct.unpack_from('<III',done,24)):
                assert r.data(key)[:n]==plain.data(key)[:n]
                output_digest.update(r.data(key)[:n])
            state_digest.update(bytes(root)+b''.join(bytes(arrays[k]) for k in sorted(arrays)))
            for op in range(1,8):assert private(r,op)==0
            assert (root,arrays)==r.snapshot(),'Private markers modified authoritative state'
        assert private(r,8)==0
        decoded=decode(r.data(50305),frames)
        (HERE/'.work'/('phase-host-'+name+'-'+mode+'.bin')).write_bytes(r.data(50305))
        meta=json.loads((WORK/name/'fixture/expected.json').read_text())
        final={'1':bytes(root).hex(),**{str(a['buffer']):bytes(arrays[a['buffer']]).hex() for a in s.arrays.values() if a['access']==3}}
        assert r.invoke('StopRace')==plain.invoke('StopRace')==0
        assert r.invoke(operation=3)==plain.invoke(operation=3)==0
        assert r.grants==r.releases and r.peak<=3
        report[name]=dict(frames=frames,ticks=frames*4,independent_world_contact_pass=True,
            complete_state_and_output_match_uninstrumented_module=True,
            state_sha256=state_digest.hexdigest(),drawing_output_sha256=output_digest.hexdigest(),
            final_buffers=final,phase_frames=decoded['frames'],phase_clock='HOST STUB; protocol/state proof only, not timing',
            peak_leases=r.peak,balanced_leases=True,tail=ordered_tail(meta,(WORK/name/'fixture/script.bin').read_bytes()))
        # Failure tests each initialize a fresh module instance, resetting private state.
        failures={}
        for fault in ('missing','short','order','capacity','unsupported','argument'):
            q=NativeRuntime(s,WORK/name/('phase-'+mode+'.so'));assert q.invoke('InitRace')==0
            if fault!='missing':q.install(50305,bytes(HEADER+(1 if fault=='capacity' else frames)*ROW-(1 if fault=='short' else 0)))
            if fault in ('missing','short'):rc=private(q,0)
            elif fault=='unsupported':assert private(q,0)==0;rc=private(q,42)
            elif fault=='argument':
                request=Request(C.sizeof(Request),2,PRIVATE,q.argument_id,0,1)
                rc=q.lib.vdplet_entry(C.byref(q.host),C.byref(request))
            else:
                assert private(q,0)==0
                if fault=='order':rc=private(q,1)
                else:
                    for frame in range(2):
                        for _ in range(4):assert q.invoke('Tick120')==0
                        assert q.invoke('Render30')==0
                        for op in range(1,8):
                            rc=private(q,op)
                            if rc:break
                        if rc:break
            assert rc!=0 and not q.live,(fault,rc)
            q.canaries();assert q.grants==q.releases
            failures[fault]=rc
        report[name]['negative_cases']=failures
        print(name,mode,'PASS',frames,'frames, independent world/output and private protocol')
    (HERE/('phase_HOST-'+mode+'.json')).write_text(json.dumps(report,indent=2)+'\n')


def qualify():
    for name in ('control','float-quad-layered'):
        package=WORK/name/'package'
        plain=WORK/name/'baseline';plain.mkdir(exist_ok=True)
        for file in ('native.c','phase_clock.inc'):
            if file=='phase_clock.inc':continue
            (plain/file).write_bytes((CONTROL/'package'/file).read_bytes())
        import shutil
        shutil.copytree(CONTROL/'package/helper',plain/'helper',dirs_exist_ok=True)
        if name!='control':
            source=(package/'helper/render_core.inc').read_bytes()
            (plain/'helper/render_core.inc').write_bytes(source)
        for mode,flags in (('ordinary',[]),('sanitized',['-fsanitize=address,undefined','-fno-omit-frame-pointer'])):
            for kind,source in (('phase',package/'native.c'),('baseline',plain/'native.c')):
                subprocess.run(['cc','-shared','-fPIC','-O1','-fno-builtin','-ffp-contract=off',*flags,
                    '-I'+str(CONTROL/'sdk/include'),str(source),'-o',str(WORK/name/(kind+'-'+mode+'.so'))],check=True)
    for mode in ('ordinary','sanitized'):
        env=os.environ.copy()
        if mode=='sanitized':
            env['LD_PRELOAD']=subprocess.check_output(['cc','-print-file-name=libasan.so'],text=True).strip()
            env['ASAN_OPTIONS']='detect_leaks=0:halt_on_error=1';env['UBSAN_OPTIONS']='halt_on_error=1'
        subprocess.run([sys.executable,__file__,'--worker',mode],check=True,env=env)


if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--worker',choices=('ordinary','sanitized'));a=p.parse_args()
    replay(a.worker) if a.worker else qualify()
