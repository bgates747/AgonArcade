"""Decode separate native raw-cycle diagnostic receipts without changing clocks."""
from pathlib import Path
import argparse
import json
import statistics
import struct
from phase_shared import HERE,HEADER,ROW,SCHEMA,support_module
assert (HEADER,ROW,SCHEMA)==(32,52,1),'Unsupported phase record schema'

FIELDS=('frame','physics4_call_cycles','prepare_call_cycles','road_build_cycles',
        'actors_build_cycles','player_build_cycles','clear_begin','road_begin',
        'road_end','actors_end','player_end','swap_begin','swap_end')
SPANS=(('clear_title_dispatch_and_flush','clear_begin','road_begin'),
       ('road_dispatch_draw_and_flush','road_begin','road_end'),
       ('actors_dispatch_draw_and_flush','road_end','actors_end'),
       ('player_dispatch_draw_and_flush','actors_end','player_end'),
       ('empty_marker_control','player_end','swap_begin'),
       ('swap_dispatch_and_flush','swap_begin','swap_end'))


def decode(data,frames):
    assert len(data)==HEADER+frames*ROW
    magic,schema,row,capacity,count,error,source,minimum,maximum,core,reserved=struct.unpack_from('<4s6H4I',data)
    assert (magic,schema,row,capacity,count,error,source,reserved)==(b'P28C',1,ROW,frames,frames,0,1,0)
    assert 0<minimum<=maximum<0x80000000,'CCOUNT did not show bounded calibration progress'
    rows=[]
    for n in range(frames):
        r=dict(zip(FIELDS,struct.unpack_from('<13I',data,HEADER+n*ROW)))
        assert r['frame']==n+1
        assert all(0<r[k]<0x80000000 for k in FIELDS[1:6]),('Invalid local interval',r)
        assert r['prepare_call_cycles']>=sum(r[k] for k in FIELDS[3:6]),'Nested preparation intervals exceed parent'
        for label,start,end in SPANS:
            delta=(r[end]-r[start])&0xffffffff
            assert 0<delta<0x80000000,('CCOUNT nonprogress/wrap ambiguity',label,r)
            r[label]=delta
        rows.append(r)
    summary={k:dict(min=min(r[k] for r in rows),median=statistics.median(r[k] for r in rows),
                    mean=statistics.mean(r[k] for r in rows),max=max(r[k] for r in rows))
             for k in (*FIELDS[1:6],*(s[0] for s in SPANS))}
    return dict(frames=frames,raw_unit='per-core CCOUNT delta modulo2^32; uncalibrated',
        cpu_prid=core,back_to_back_read_delta=dict(min=minimum,max=maximum),
        summaries=summary,rows=rows,
        limitations=['Interrupt and scheduler time inside a bracket is included.',
            'Drawing brackets include resident command dispatch, native marker call overhead and stock flush.',
            'Swap interval ends after the ordered stock worker-drain fence; it is not a physical scanout timestamp.',
            'Do not convert using an assumed ESP32 MHz or subtract MOS/PRT/host timestamps.',
            'These separately instrumented runs are not headline uninstrumented throughput comparisons.'])


def verify(directory,standard_result=None):
    directory=Path(directory)
    meta=json.loads((directory/'expected.json').read_text())
    if standard_result is None:
        standard_result=support_module('verify_run').verify(directory)
    words={int(r['label'].split(':')[1]):r['value'] for r in standard_result['observations'] if r['label'].startswith('phase:')}
    assert sorted(words)==list(range(0,HEADER+meta['frames']*ROW,2))
    data=b''.join(struct.pack('<H',words[offset]) for offset in sorted(words))
    result=decode(data,meta['frames'])
    expected=json.loads((HERE/'phase_HOST-ordinary.json').read_text())
    candidate=meta['phase_candidate']
    assert standard_result['final_buffers']==expected[candidate]['final_buffers'],'Independent host state differs'
    result.update(candidate=candidate,full_final_state_matches_host=True,
        elapsed_mos_units=standard_result['elapsed_mos_ticks'],nominal_mos_seconds=standard_result['elapsed_seconds'],
        nominal_prt_seconds=standard_result['prt']['nominal_seconds_at_18432000_hz'])
    (directory/'phase-verified.json').write_text(json.dumps(result,indent=2)+'\n')
    return result


if __name__=='__main__':
    parser=argparse.ArgumentParser();parser.add_argument('directory');a=parser.parse_args()
    r=verify(a.directory);print(json.dumps({k:v for k,v in r.items() if k!='rows'},indent=2))
