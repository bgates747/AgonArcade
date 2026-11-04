"""Independent native schedule, guest state and unchanged timed wire checks."""
from pathlib import Path
import hashlib
import importlib.util
import json
import struct

HERE = Path(__file__).resolve().parent
HUD = HERE.parent / 'incremental/hud-format'


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def audit(directory):
    directory = Path(directory)
    raw = load('rows_raw_gate', HUD.parent / 'round-trips/raw_audit.py')
    meta = json.loads((directory / 'expected.json').read_text())
    reference = json.loads((HERE / f"EXPECTED-FINAL-{meta['frames']}.json").read_text())
    raw.COMPACT = True
    old_schedule = raw.specs(meta['frames'], meta['module_bytes'], 1, reference)
    caps = dict(operation=4, token=1, fields=struct.pack('<H', 1), kind=4, value=287,
                label='row runtime capability admission', phase='setup', frame=None)
    caps['wire'] = raw.request(4, 1, caps['fields'])
    schedule = [caps]
    for row in old_schedule:
        item = {**row, 'token':row['token'] + 1}
        item['wire'] = raw.request(item['operation'], item['token'], item['fields'])
        schedule.append(item)
    wire, packets, generic = raw.backend(directory)
    raw.replies_match(packets, schedule)
    offsets = raw.raw_requests(wire, schedule)
    assert b''.join(packets) == (directory / 'replies.bin').read_bytes()
    timed_start = offsets[18]['stop']
    timed_end = offsets[18+meta['frames']*2]['stop']
    timed = wire[timed_start:timed_end]
    # Existing complete timed stream; the sole wire difference is token +1
    # from the new common startup capability query. No arbitrary bytes removed.
    old_file = (HUD / 'startup-recovery' / (
        'full-comparison/EXPECTED-TIMED-WIRE.bin' if meta['frames'] == 900
        else 'hud-smoke/EXPECTED-TIMED-WIRE.bin'))
    old_timed = old_file.read_bytes()
    old_main = [r for r in old_schedule if r['phase'] == 'main']
    old_offsets = raw.raw_requests(old_timed, old_main)
    expected = bytearray(old_timed)
    for row in old_offsets:
        expected[row['start']:row['stop']] = raw.request(row['operation'], row['token']+1, row['fields'])
    if meta['renderer']=='coarse':
        # Exact declared replacement: four resident Tick CALLs -> one direct
        # silent native entry17; no other bytes are normalized or discarded.
        old_tick=bytes([23,0,160,13,0,1])*4
        native_tick=bytes([23,0,216,12,0,1,2,0,0,0,0])+struct.pack('<HHH',1,17,9)
        assert expected.count(old_tick)==meta['frames']
        expected=expected.replace(old_tick,native_tick)
    assert timed == bytes(expected), 'Unexpected recurring command change' 
    expected_bytes=(291568 if meta['frames']==900 else 18317)-(7*meta['frames'] if meta['renderer']=='coarse' else 0)
    assert len(timed)==expected_bytes
    prefix = wire[:timed_start]
    for name in ('module.vdu', 'assets.vdu', 'artwork.vdu', 'presentation.vdu', 'common.vdu', 'native.vdu'):
        data = (directory / name).read_bytes()
        assert prefix.count(data) == 1, name
    assert prefix.find(bytes([22, 136])) < offsets[0]['start'] < offsets[1]['start']
    checked = load('rows_guest_gate', HERE / 'verify.py').verify(directory)
    done = wire.rfind(b'FULL RACE DONE')
    assert done >= 0 and wire.find(b'/rally25 *', done) > done
    result = dict(passed=True, renderer=meta['renderer'], **checked,
                  every_native_request_reply_exact=True, capability_subset_admitted=273,
                  actual_capabilities=287, actual_MODE_reply_before_callback='guest-enforced',
                  recurring_wire_exact_declared_variant=True,
                  coarse_tick_wire_saving=7*meta['frames'] if meta['renderer']=='coarse' else 0,
                  whole_wire_sha256=hashlib.sha256(wire).hexdigest(),
                  native_replies=len(packets), multiplexed_packets=generic)
    (directory / 'audit.json').write_text(json.dumps(result, indent=2)+'\n')
    return result
