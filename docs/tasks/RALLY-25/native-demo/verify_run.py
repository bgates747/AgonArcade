"""Verify guest receipts and reconstruct final native state without another run."""
from pathlib import Path
import argparse,hashlib,json,struct

def verify(directory):
    directory=Path(directory);meta=json.loads((directory/'expected.json').read_text())
    assert not (directory/'failure.log').exists(),'Guest failed; preserve failure.log'
    data=(directory/'replies.log').read_bytes();assert len(data)==meta['reply_bytes'],(len(data),meta['reply_bytes'])
    # A compact guest repeat block expands only its marked checks.
    pre=[];loop=[];post=[];seen_loop=False
    for check in meta['checks']:
        if check.get('loop',check['repeats']>1):loop.append(check);seen_loop=True
        elif seen_loop:post.append(check)
        else:pre.append(check)
    expected=pre+[{**c,'frame':frame} for frame in range(1,meta['frames']+1) for c in loop]+post
    at=0;observations=[];final={}
    for c in expected:
        if c['flags']&4:continue
        magic,version,kind,token,value=struct.unpack_from('<4sBBHH',data,at);at+=10
        assert (magic,version,kind,token)==(b'VDPL',1,c['kind'],c['token']),(c,'reply identity')
        flags=c['flags'];frame=c.get('frame')
        wanted=frame*4 if flags&8 else frame if flags&16 else frame*5+1 if flags&32 else c['value']
        if wanted is not None:assert value==wanted,(c,value,wanted)
        observations.append(dict(label=c['label'],frame=frame,value=value))
        if c['label'].startswith('final:'):
            _,key,offset=c['label'].split(':');final.setdefault(key,{})[int(offset)]=value
    assert at==len(data)
    ticks=(directory/'ticks.log').read_bytes();assert len(ticks)==meta['tick_samples']*3
    samples=[int.from_bytes(ticks[i:i+3],'little') for i in range(0,len(ticks),3)]
    tick_hz=meta.get('mos_tick_hz',120)
    elapsed_ticks=(samples[meta['frames']]-samples[0])&0xffffff
    duration=elapsed_ticks/tick_hz
    result=dict(scope=meta.get('timing_scope','MOS VBlank-derived elapsed fixture time including checks/drawing; nominal120 ticks/s in60-Hz mode; physical timing only for hardware-tagged runs'),
                frames=meta['frames'],physics_ticks=meta['physics_ticks'],mos_tick_hz=tick_hz,elapsed_mos_ticks=elapsed_ticks,elapsed_seconds=duration,
                observed_fps=meta['frames']/duration if duration else None,validated_reply_records=len(observations),
                guest_validates_suppressed_checks=True,reply_sha256=hashlib.sha256(data).hexdigest(),
                final_buffers={key:b''.join(struct.pack('<H',words[n]) for n in sorted(words)).hex() for key,words in final.items()},
                observations=observations)
    if meta.get('prt_instrumented'):
        clock=(directory/'clock.log').read_bytes()
        magic,schema,reserved,reload,divider,hz,borrowed,restored=struct.unpack('<4sBBHHIBB',clock)
        assert (magic,schema,reserved,reload,divider,hz)==(b'R25T',1,0,72,256,18432000)
        if borrowed:assert restored==1,'PRT previous vector was not restored'
        data=(directory/'prt.log').read_bytes();assert len(data)==meta['tick_samples']*3
        prt=[int.from_bytes(data[i:i+3],'little') for i in range(0,len(data),3)]
        deltas=[(prt[i+1]-prt[i])&0xffffff for i in range(len(prt)-1)]
        elapsed=(prt[meta['frames']]-prt[0])&0xffffff
        result['prt']={'samples':prt,'deltas':deltas,'elapsed_ticks':elapsed,'cycles_per_tick':18432,
                       'nominal_seconds_at_18432000_hz':elapsed/1000,
                       'nominal_fps_at_18432000_hz':meta['frames']*1000/elapsed if elapsed else None,
                       'timer_borrowed':bool(borrowed),'previous_vector_restored':bool(restored),
                       'clock_limit':meta.get('prt_clock_limit','nominal PRT IRQ ticks; emulator instruction-clock driven, interrupt coalescing possible; not calibrated physical/host wall-clock FPS')}
        if meta.get('require_prt_progress'):assert elapsed>0,'PRT did not progress'
        for delta in deltas[:meta['frames']]:
            if meta.get('minimum_prt_interval'):assert delta>=meta['minimum_prt_interval'],delta
    (directory/'verified.json').write_text(json.dumps(result,indent=2)+'\n')
    return result
if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('directory');a=p.parse_args();r=verify(a.directory)
    print(json.dumps({k:v for k,v in r.items() if k not in ('observations','final_buffers','prt')},indent=2))
