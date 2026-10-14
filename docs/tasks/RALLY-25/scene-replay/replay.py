"""Deterministic actual-source simulation to helper replay and integration faults."""
import ctypes as C,hashlib,json,struct,sys,time
from pathlib import Path
from pipeline import Pipeline,Proof,Presentation,H,HERE
REFERENCE=HERE.parent/'reference';sys.path.insert(0,str(REFERENCE))
from model import Traffic,contact
LAP=3276800;START=LAP-30000;DISTANCES=[0,3199,3200,6400,18000,80000]
def sha(data):return hashlib.sha256(data).hexdigest()

def seed(p,table):
    model=Traffic(table,'circuit',LAP,1,99)
    for i,c in enumerate(model.cars):
        c.progress=START+DISTANCES[i];c.position=c.progress%LAP
        for name,value in [('active',1),('progress',c.progress),('position',c.position),('lateral',c.lateral),('contacts',0)]:
            a=p.spec.arrays[name];data=bytearray(p.r.data(a['buffer']));p.spec.array_put({a['buffer']:data},name,i,value);p.r.store(a['buffer'],0,bytes(data))
    return model

def reference_packet(model,player,tick,request,phase,session=7):
    raw=bytearray(112);struct.pack_into('<4sHHIIIiHhiHHHH',raw,0,b'R24S',1,112,session,request,tick,player%LAP,phase,0,0,3,0,0,0)
    for i,c in enumerate(model.cars):
        if c.active:struct.pack_into('<iihBB',raw,40+12*i,c.position,c.lateral,model.pace.heading,1,0)
    return bytes(raw)

def state_check(p,model,tick):
    root,arrays=p.r.snapshot();s=p.spec
    for name,value in [('worldTick',tick),('routeRecord',model.pace.record),('routeRemaining',model.pace.remaining),('routeHeading',model.pace.heading),('routeLateral',model.pace.lateral)]:assert s.get(root,name)==value,(tick,name)
    for i,c in enumerate(model.cars):
        for name,value in [('active',c.active),('progress',c.progress),('position',c.position),('lateral',c.lateral)]:assert s.array_get(arrays,name,i)==value,(tick,name,i)
    return root,arrays

def fault_checks(simlib,renderlib,directory,asset,relocated):
    checks=[];table=json.loads((REFERENCE/'tables.json').read_text())
    def make():
        p=Pipeline(simlib,renderlib,directory,asset,relocated);seed(p,table)
        for _ in range(4):assert not p.source_tick(START%LAP,0)
        return p
    def fail(name,mutate=None,code=None,proof=None,present=None):
        p=make();before=struct.unpack_from('<I',p.model_root(),20)[0]
        if mutate:mutate(p)
        rc,_=p.render(1,0,proof=proof(p) if proof else None,present=present)
        assert rc!=0 and (code is None or rc==code),(name,rc,code)
        assert not p.can_draw() and struct.unpack_from('<I',p.model_root(),20)[0]==before,name
        checks.append(dict(name=name,result=rc,resident_ready=p.completion().ready,entry_cleanup_leases=p.r.cleanup_leases))
        return p
    fail('stale-source-generation',proof=lambda p:Proof(7,4,p.source_generation-1,0,1),code=1)
    fail('stale-source-tick',proof=lambda p:Proof(7,0,p.source_generation,0,1),code=1)
    fail('wrong-source-session',proof=lambda p:Proof(8,4,p.source_generation,0,1),code=1)
    fail('observed-source-failure',proof=lambda p:Proof(7,4,p.source_generation,3,1),code=1)
    for offset,value in [(12,8),(14,5),(16,3),(24,65535),(32,8)]:
        fail('source-status-or-success-'+str(offset),lambda p,o=offset,v=value:p.r.store(p.r.root_id,o,v.to_bytes(4 if o in (16,32) else 2,'little')),code=1)
    fail('invalid-mapped-offset',lambda p:setattr(p.layout,'tick_offset',p.layout.root_bytes),code=3)
    fail('missing-source-array',lambda p:setattr(p.r,'fault',(p.layout.active.buffer,'missing')),code=2)
    fail('short-source-array',lambda p:setattr(p.r,'fault',(p.layout.position.buffer,'short')),code=3)
    fail('long-source-array',lambda p:setattr(p.r,'fault',(p.layout.lateral.buffer,'long')),code=3)
    fail('invalid-presentation',present=Presentation(8000,0,3,0),code=1)
    fail('helper-output-capacity',lambda p:setattr(p.module.renderer.bindings.output[0],'bytes',1),code=3)
    fail('completion-copy-after-ready',lambda p:setattr(p,'copy_failure',True),code=3)
    # Clear ready occurs before injected publication acquisition/release failure.
    for mode in ('acquire','release','refused-release'):
        p=make();before=struct.unpack_from('<I',p.model_root(),20)[0]
        original_clear=p.clear_ready
        def clear(p=p,mode=mode):
            rc=original_clear()
            if mode=='acquire':p.r.reject_publish=True
            else:p.r.reject_release=True;p.r.hold_release=mode=='refused-release'
            return rc
        p.clear_ready=clear;rc,_=p.render(1,0)
        p.r.reject_publish=False
        assert rc in (2,8) and not p.can_draw() and struct.unpack_from('<I',p.model_root(),20)[0]==before,mode
        if mode!='acquire':assert p.completion().ready==1
        if mode=='refused-release':assert p.r.cleanup_leases==1
        checks.append(dict(name='publication-'+mode,result=rc,resident_ready=p.completion().ready,entry_cleanup_leases=p.r.cleanup_leases))
    p=make();rc,state=p.render(1,0);assert not rc and p.can_draw()
    # Resident metadata mismatch, model-root failure, and next physics work invalidate old output.
    for offset,n in [(12,4),(16,4),(20,4),(44,2)]:
        id=p.module.map.completion.buffer;old=p.r.data(id);p.r.store(id,offset,b'\xff'*n);assert not p.can_draw();p.r.store(id,0,old)
        checks.append(dict(name='resident-completion-mismatch-'+str(offset),result='draw rejected'))
    rootid=p.module.map.root.buffer;old=p.r.data(rootid);p.r.store(rootid,20,b'\xff'*4);assert not p.can_draw();p.r.store(rootid,0,old)
    checks.append(dict(name='modeled-render-success-generation-mismatch',result='draw rejected'))
    assert not p.source_tick(START%LAP,0) and not p.can_draw()
    rc,_=p.render(2,0);assert rc==1 and not p.can_draw();checks.append(dict(name='one-tick-early-render',result=rc))
    for _ in range(3):assert not p.source_tick(START%LAP,0)
    assert not p.render(2,0)[0] and p.can_draw();assert not p.lifecycle(4) and not p.can_draw()
    for _ in range(4):assert not p.source_tick(START%LAP,0)
    assert p.render(3,0)[0]==12 and not p.can_draw();assert not p.lifecycle(3)
    assert not p.render(3,0)[0] and p.can_draw();checks.append(dict(name='stop-render-reject-reset-rebind',result='pass'))
    p=Pipeline(simlib,renderlib,directory,asset,relocated);seed(p,table)
    p.source_generation=0xfffffffd;p.r.store(p.r.root_id,20,struct.pack('<I',p.source_generation));p.r.store(p.module.map.root.buffer,20,b'\xff'*4)
    for _ in range(4):assert not p.source_tick(START%LAP,0)
    assert p.source_generation==1 and not p.render(0xffffffff,0)[0] and p.can_draw()
    assert struct.unpack_from('<I',p.model_root(),20)[0]==0
    for _ in range(4):assert not p.source_tick(START%LAP,0)
    assert not p.render(0,0)[0] and p.can_draw();checks.append(dict(name='source-render-generation-and-request-wrap',result='pass'))
    p=make();assert not p.render(1,0)[0] and p.can_draw();p.r.put('worldTick',0xffffffff)
    assert p.source_tick(START%LAP,0)==1;rc,_=p.render(2,0);assert rc and not p.can_draw();checks.append(dict(name='actual-source-arithmetic-failure',result=rc))
    # Invalid enum rejects; inactive stale coordinates/headings are canonicalized to zero.
    p=make();a=p.spec.arrays['active'];data=bytearray(p.r.data(a['buffer']));p.spec.array_put({a['buffer']:data},'active',0,2);p.r.store(a['buffer'],0,bytes(data))
    assert p.render(1,0)[0]==1 and not p.can_draw();checks.append(dict(name='invalid-active-enum',result=1))
    p=make();a=p.spec.arrays['active'];data=bytearray(p.r.data(a['buffer']));p.spec.array_put({a['buffer']:data},'active',0,0);p.r.store(a['buffer'],0,bytes(data))
    a=p.spec.arrays['position'];p.r.store(a['buffer'],0,b'\xff'*4)
    rc,state=p.render(1,0);assert not rc and not any(bytes(state.opponents[0])) and p.can_draw();checks.append(dict(name='inactive-slot-canonicalization',result='pass'))
    return checks

def worker(simlib,renderlib,directory,outdir,label,relocated):
    started=time.monotonic();outdir.mkdir(parents=True,exist_ok=True)
    asset=(HERE.parent/'integration-harness/fuji/fuji.r24').read_bytes();table=json.loads((REFERENCE/'tables.json').read_text())
    p=Pipeline(simlib,renderlib,directory,asset,relocated);model=seed(p,table);player=START;frames=[];contacts=0;seams=0;previous=player%LAP;resets=0
    with (outdir/'commands.bin').open('wb') as commands,(outdir/'reference.bin').open('wb') as reference,(outdir/'states.bin').open('wb') as states,(outdir/'simulation.jsonl').open('w') as trace:
        for tick in range(1,3601):
            if tick==1801:
                for i,c in enumerate(model.cars):
                    if i%2:c.active=0
                a=p.spec.arrays['active'];data=bytearray(p.r.data(a['buffer']))
                for i,c in enumerate(model.cars):p.spec.array_put({a['buffer']:data},'active',i,c.active)
                p.r.store(a['buffer'],0,bytes(data))
            next_record=(model.pace.record+1)%6 if model.pace.remaining==0 else model.pace.record
            player+=table['records'][next_record][1]*2;model.advance(player,tick)
            assert p.source_tick(player%LAP,0)==0;root,arrays=state_check(p,model,tick)
            wanted=[int(c.active and contact(c.position,c.lateral,player%LAP,0,LAP)) for c in model.cars]
            assert [p.spec.array_get(arrays,'contacts',i) for i in range(6)]==wanted
            contacts+=int(any(wanted));seams+=int(player%LAP<previous);previous=player%LAP
            trace.write(json.dumps(dict(tick=tick,player=player%LAP,pace=[model.pace.record,model.pace.remaining,model.pace.heading,model.pace.lateral],cars=[[c.active,c.progress,c.position,c.lateral,wanted[i]] for i,c in enumerate(model.cars)]),separators=(',',':'))+'\n')
            if tick%4:continue
            frame=tick//4
            if frame==451:assert not p.lifecycle(3);resets+=1
            phase=player%8000;rc,state=p.render(frame,phase);assert not rc and p.can_draw(),(tick,rc)
            raw=reference_packet(model,player,tick,frame,phase)
            assert bytes(state)==bytes(H.convert(raw)),('typed mapping',tick)
            reference.write(raw);states.write(bytes(state));block=p.commands();commands.write(block)
            frames.append(dict(frame=frame,tick=tick,request=frame,player=player%LAP,phase=phase,state_sha256=sha(bytes(state)),reference_sha256=sha(raw),commands_sha256=sha(block)))
    assert not p.lifecycle(4) and not p.can_draw();p.r.canaries();assert not p.r.live and not p.r.cleanup_leases and p.r.grants==p.r.releases
    assert contacts>0 and seams>0 and len(frames)==900
    faults=fault_checks(simlib,renderlib,directory,asset,relocated)
    result=dict(label=label,relocated=relocated,simulation_ticks=3600,rendered_frames=900,simulated_seconds=30,wall_clock_pacing=False,contact_ticks=contacts,lap_seams=seams,renderer_rebinds=resets,
        peak_mock_views=p.r.peak,normal_cleanup_leases=p.r.cleanup_leases,granted_leases=p.r.grants,releases=p.r.releases,
        failures=faults,artifacts={name:dict(bytes=(outdir/name).stat().st_size,sha256=sha((outdir/name).read_bytes())) for name in ('commands.bin','reference.bin','states.bin','simulation.jsonl')},host_seconds=round(time.monotonic()-started,3))
    (outdir/'frames.json').write_text(json.dumps(frames,indent=2)+'\n');return result
