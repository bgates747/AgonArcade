"""Freeze protocol/first-frame expectations from an already-qualified capture."""
from pathlib import Path
import hashlib,importlib.util,json,struct
HERE=Path(__file__).resolve().parent;CONTROL=HERE.parent.parent/'round-trips'
spec=importlib.util.spec_from_file_location('startup_raw_reference',CONTROL/'raw_audit.py')
raw=importlib.util.module_from_spec(spec);spec.loader.exec_module(raw);raw.COMPACT=True
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()

def write(path,data):
    if path.exists():assert path.read_bytes()==data,path
    else:path.write_bytes(data)

def main():
    old=HERE.parents[2]/'prepared-bitmap-set/prepared-benchmark'
    saved=old/'evidence/prace900ab01/compact'
    freeze=json.loads((old/'PARTIAL-RESULTS-FREEZE.json').read_text())
    for name in ('mos-to-vdp.bin','vdp-to-mos.bin','result.json'):
        path=saved/name;assert sha(path)==freeze['files'][str(path.relative_to(old))],name
    reference=json.loads((HERE/'EXPECTED-FINAL-1.json').read_text())
    meta=json.loads((HERE/'fixture/expected.json').read_text())
    assert (meta['frames'],meta['expected_render_requests'],meta['expected_native_generation'],meta['expected_native_world_ticks'])==(1,3,8,4)
    schedule=raw.specs(1,34836,1,reference)
    assert len(schedule)==226
    packets,_=raw.native_packets((saved/'vdp-to-mos.bin').read_bytes())
    raw.replies_match(packets[:20],schedule[:20])
    positions=raw.raw_requests((saved/'mos-to-vdp.bin').read_bytes(),schedule[:20])
    start,stop=positions[17]['stop'],positions[19]['stop']
    frame=(saved/'mos-to-vdp.bin').read_bytes()[start:stop]
    assert frame.count(b'\x17\0\xc3')==1 and frame.count(b'\x17\0\xa0\x0d\0\1')==4
    write(HERE/'EXPECTED-FIRST-FRAME.bin',frame)
    rows=[dict(token=r['token'],operation=r['operation'],fields_hex=r['fields'].hex(),
               expected_reply_kind=r['kind'],expected_value=r['value'],label=r['label'],phase=r['phase'],frame=r['frame']) for r in schedule]
    result=dict(schema=1,scope='Startup plus one frame and cleanup, timing excluded; no new target measurement',
        expected_native_reply_count=226,expected_main_frame_replies=2,expected_physics_ticks=4,
        expected_first_frame_wire_bytes=len(frame),expected_first_frame_wire_sha256=sha(HERE/'EXPECTED-FIRST-FRAME.bin'),
        prior_qualified_witness=str(saved),prior_files={n:sha(saved/n) for n in ('mos-to-vdp.bin','vdp-to-mos.bin','result.json')},
        first20native_replies_match_existing_witness=True,only_STACK_INFO_values_unspecified=True,
        expected_generation=8,expected_render_request=3,expected_player_station=3248240,expected_player_phase=240,
        runtime_not_selected=True,requests=rows)
    write(HERE/'EXPECTED-PROTOCOL.json',(json.dumps(result,indent=2)+'\n').encode())
    print('PASS:226predicted replies; first20match qualified capture; first-frame wire',len(frame),'bytes.')

if __name__=='__main__':main()
