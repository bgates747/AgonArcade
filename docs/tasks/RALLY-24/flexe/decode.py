"""Validate and decode fixture-local logs: python decode.py FIXTURE_DIRECTORY."""
from pathlib import Path
import argparse,json,struct,statistics,math

def distribution(v):
    s=sorted(v)
    return dict(median=statistics.median(s),p95=s[math.ceil(.95*len(s))-1],maximum=max(s),minimum=min(s))
def decode(directory):
    p=Path(directory);meta=json.loads((p/'expected.json').read_text())
    data=(p/'replies.log').read_bytes()
    assert len(data)==len(meta['checks'])*10,(len(data),len(meta['checks'])*10)
    if meta.get('kind')=='matrix':
        values=[]
        for i,c in enumerate(meta['checks']):
            magic,version,kind,token,value=struct.unpack_from('<4sBBHH',data,i*10)
            assert (magic,version,kind,token)==(b'VDPL',1,c['kind'],c['token'])
            values.append(value-65536 if value>=32768 else value)
        rows=[dict(**row,actual_signed_x=values[row['check']]) for row in meta['rows']]
        result=dict(kind='matrix',rows=rows,differences=sum(r['native_signed_x']!=r['actual_signed_x'] for r in rows))
        (p/'matrix.json').write_text(json.dumps(result,indent=2)+'\n')
        return result
    records=[[0]*8 for _ in range(meta['samples'])];stack={}
    for i,c in enumerate(meta['checks']):
        magic,version,kind,token,value=struct.unpack_from('<4sBBHH',data,i*10)
        assert (magic,version,kind,token)==(b'VDPL',1,c['kind'],c['token']),(i,c,value)
        assert c['value'] is None or value==c['value'],(i,c,value)
        if c['label'].startswith('metric:'):
            _,row,field,half=c['label'].split(':');records[int(row)][int(field)] |= value<<(int(half)*16)
        elif c['label'].startswith('stack-'):stack[c['label']]=value
    raw=(p/'ticks.log').read_bytes();assert len(raw)==meta['marks']*3
    ticks=[int.from_bytes(raw[i:i+3],'little') for i in range(0,len(raw),3)]
    after=meta['warmup_samples'];hz=meta['nominal_cpu_hz'];thz=meta['nominal_mos_tick_hz']
    valid=records[after:];durations=[((r[3]-r[2])&0xffffffff)*1000/hz for r in valid]
    submission=[((ticks[2+i*2]-ticks[1+i*2])&0xffffff)*1000/thz for i in range(after,meta['samples'])]
    elapsed=((ticks[-1]-ticks[0])&0xffffff)/thz
    result=dict(track=meta['track'],mode=meta['mode'],samples=meta['samples'],warmup_excluded=after,
        verified_command_hashes=meta['samples']*3 if meta['mode']!='replay' else 0,
        generation_nominal_ms=distribution([r[1]*1000/hz for r in valid]),
        generation_to_swap_return_nominal_ms=distribution(durations),
        ez80_frame_submission_nominal_ms=distribution(submission),
        batch_mos_ticks=(ticks[-1]-ticks[0])&0xffffff,batch_nominal_seconds=elapsed,
        diagnostic_batch_frames_per_nominal_second=meta['samples']/elapsed if elapsed else None,
        frames_over_33_333_nominal_ms=sum(v>1000/30 for v in durations),
        wire_bytes_per_frame=distribution(meta['frame_wire_bytes']),stack_watermark_bytes=stack,
        records=records,ticks=ticks,
        caveats=['Emulated CCOUNT and MOS ticks are not hardware time; hardware interpretation assumes CPU240MHz/MOS120Hz.',
                 'Replay omits eZ80 projection. No game physics, scrolling background, HUD or audio.',
                 'Per-frame hashes after timestamp, diagnostic native calls and final INFO reply add batch overhead.',
                 'Swap return is synchronized drawing/presentation boundary, not measured optical output.',
                 'Submission ticks quantized at one nominal MOS tick; no claimed microsecond eZ80 timing.'])
    (p/'timings.json').write_text(json.dumps(result,indent=2)+'\n')
    return result
if __name__=='__main__':
    a=argparse.ArgumentParser(description=__doc__);a.add_argument('directory',type=Path)
    print(json.dumps(decode(a.parse_args().directory),indent=2))
