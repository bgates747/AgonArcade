"""Narrow complete60-frame raw gate, also reusable after host release."""
from pathlib import Path
import hashlib
import importlib.util
import json
import struct

HERE = Path(__file__).resolve().parent
sha = lambda p: hashlib.sha256(Path(p).read_bytes()).hexdigest()


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def audit(directory):
    directory = Path(directory)
    target = directory/'smoke-audit.json'
    assert not target.exists(), 'Preserve the original smoke audit'
    frozen = json.loads((HERE/'EXPECTED-PROTOCOL.json').read_text())
    raw = load('smoke_raw', HERE.parent.parent.parent/'round-trips/raw_audit.py')
    schedule = []
    for row in frozen['requests']:
        fields = bytes.fromhex(row['fields_hex'])
        schedule.append(dict(token=row['token'], operation=row['operation'], fields=fields,
                             wire=raw.request(row['operation'], row['token'], fields),
                             kind=row['expected_reply_kind'], value=row['expected_value'],
                             label=row['label'], phase=row['phase'], frame=row['frame']))
    wire, packets, generic = raw.backend(directory)
    raw.replies_match(packets, schedule)
    offsets = raw.raw_requests(wire, schedule)
    timed = wire[offsets[17]['stop']:offsets[137]['stop']]
    assert timed == (HERE/'EXPECTED-TIMED-WIRE.bin').read_bytes()
    assert b''.join(packets) == (directory/'replies.bin').read_bytes()
    checked = load('smoke_result', HERE/'verify.py').verify(directory)
    assert checked['timed_wire_bytes'] == 18317
    done = wire.rfind(b'FULL RACE DONE')
    assert done >= 0 and wire.find(b'/rally25 *', done) > done
    receipt = json.loads((directory/'run.json').read_text())
    assert receipt['error'] is None and receipt['process_exit'] == 0
    image = raw.ppm(directory/'final.ppm')
    reader = json.loads((directory/'observer-reader.json').read_text())
    assert reader['reader_exit'] == 0
    observer = json.loads(reader['stdout'])
    assert observer['schema_valid'] and observer['finalized']
    result = dict(passed=True, frames=60, physics_ticks=240, warm_frames=2,
                  native_replies=len(packets), multiplexed_packets=generic,
                  final_state_exact=True, every_native_request_reply_checked=True,
                  timed_wire_bytes=len(timed), expected_wire_exact=True,
                  state_sha256=sha(directory/'state.bin'), player_sha256=sha(directory/'player.csv'),
                  timed_wire_sha256=hashlib.sha256(timed).hexdigest(),
                  MOS_image=image, race_image_captured=False, observer=observer,
                  timing_excluded=True, new_game_fps=None,
                  runtime_or_bounded_anchor_values={str(row['token']):dict(label=row['label'],value=row['response_value'])
                                                   for row in schedule if row['value'] is None},
                  native_reply_values=[struct.unpack('<4sBBHH', packet)[4] for packet in packets])
    target.write_text(json.dumps(result, indent=2)+'\n')
    return result
