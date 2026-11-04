"""Complete900-frame correctness/clock gate; callable and explicit CLI."""
from pathlib import Path
import argparse
import hashlib
import importlib.util
import json
import struct

HERE=Path(__file__).resolve().parent
HUD=HERE.parent.parent
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()


def load(name,path):
    spec=importlib.util.spec_from_file_location(name,path)
    module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
    return module


def audit(directory):
    directory=Path(directory);target=directory/'full-audit.json'
    assert not target.exists(),'Preserve the original full audit'
    prediction=json.loads((HERE/'EXPECTED-PROTOCOL.json').read_text())
    raw=load('full_raw_gate',HUD.parent/'round-trips/raw_audit.py')
    schedule=[]
    for row in prediction['requests']:
        fields=bytes.fromhex(row['fields_hex'])
        schedule.append(dict(token=row['token'],operation=row['operation'],fields=fields,
            wire=raw.request(row['operation'],row['token'],fields),kind=row['expected_reply_kind'],
            value=row['expected_value'],label=row['label'],phase=row['phase'],frame=row['frame']))
    wire,packets,generic=raw.backend(directory)
    raw.replies_match(packets,schedule);offsets=raw.raw_requests(wire,schedule)
    prefix=wire[:offsets[17]['stop']]
    timed=wire[offsets[17]['stop']:offsets[1817]['stop']]
    suffix=wire[offsets[1817]['stop']:]
    assert prefix==(HERE/'EXPECTED-SETUP-WIRE.bin').read_bytes()
    assert timed==(HERE/'EXPECTED-TIMED-WIRE.bin').read_bytes()
    assert suffix==(HERE/'EXPECTED-CLEANUP-WIRE.bin').read_bytes()
    assert b''.join(packets)==(directory/'replies.bin').read_bytes()
    checked=load('full_result_gate',HERE/'verify.py').verify(directory)
    assert checked['timed_wire_bytes']==291568
    phases=json.loads((HERE/'EXPECTED-PHASES.json').read_text())
    meta=json.loads((directory/'expected.json').read_text());blocks={}
    for name,old in phases['named_setup_streams'].items():
        data=(HUD/'fixtures'/meta['candidate']/name).read_bytes()
        assert hashlib.sha256(data).hexdigest()==old['sha256']
        assert prefix.count(data)==1,name
        blocks[name]=dict(bytes=len(data),offset=prefix.index(data),sha256=old['sha256'])
    receipt=json.loads((directory/'run.json').read_text())
    assert receipt['error'] is None and receipt['process_exit']==0
    done=wire.rfind(b'FULL RACE DONE');assert done>=0 and wire.find(b'/rally25 *',done)>done
    reader=json.loads((directory/'observer-reader.json').read_text());assert reader['reader_exit']==0
    observer=json.loads(reader['stdout']);assert observer['schema_valid'] and observer['finalized']
    result=dict(passed=True,frames=900,physics_ticks=3600,warm_frames=2,
        native_replies=len(packets),multiplexed_packets=generic,
        final_state_exact=True,every_native_request_reply_checked=True,
        timed_wire_bytes=len(timed),expected_whole_command_stream_exact=True,
        state_sha256=sha(directory/'state.bin'),player_sha256=sha(directory/'player.csv'),
        timed_wire_sha256=hashlib.sha256(timed).hexdigest(),whole_wire_sha256=hashlib.sha256(wire).hexdigest(),
        wire_phases=dict(setup_streams=blocks,named_setup_bytes=sum(x['bytes'] for x in blocks.values()),
                         prefix_bytes=len(prefix),timed_bytes=len(timed),suffix_bytes=len(suffix),total_bytes=len(wire)),
        nominal_mos_units=checked['nominal_mos_ticks'],nominal_mos_seconds=checked['nominal_mos_seconds'],
        nominal_mos_fps=checked['nominal_mos_fps'],prt_ticks=checked['nominal_prt_ticks'],
        nominal_prt_seconds=checked['nominal_prt_seconds'],nominal_prt_fps=checked['nominal_prt_fps'],
        host_process_seconds=receipt['host_seconds'],host_process_includes_setup_and_teardown=True,
        MOS_image=raw.ppm(directory/'final.ppm'),race_image_captured=False,observer=observer,
        runtime_INFO_values={str(row['token']):row['response_value'] for row in schedule
                             if row['operation']==4 and row['value'] is None},
        native_reply_values=[struct.unpack('<4sBBHH',packet)[4] for packet in packets],
        complete_frame_timing=True,physical_or_isolated_renderer_timing=False)
    target.write_text(json.dumps(result,indent=2)+'\n')
    return result


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('directory')
    print(json.dumps(audit(parser.parse_args().directory),indent=2))
