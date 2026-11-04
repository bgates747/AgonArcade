"""Audit a successful startup capture against the frozen one-frame protocol."""
from pathlib import Path
import argparse
import hashlib
import importlib.util
import json

HERE = Path(__file__).resolve().parent


def module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    value = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(value)
    return value


def audit(directory):
    directory = Path(directory)
    output = directory/'startup-audit.json'
    assert not output.exists(), 'Preserve the original audit'
    frozen = json.loads((HERE/'EXPECTED-PROTOCOL.json').read_text())
    raw = module('startup_protocol', HERE.parent.parent/'round-trips/raw_audit.py')
    expected = []
    for row in frozen['requests']:
        fields = bytes.fromhex(row['fields_hex'])
        expected.append(dict(token=row['token'], operation=row['operation'], fields=fields,
                             wire=raw.request(row['operation'], row['token'], fields),
                             kind=row['expected_reply_kind'], value=row['expected_value'],
                             label=row['label'], phase=row['phase'], frame=row['frame']))
    tx, packets, generic = raw.backend(directory)
    raw.replies_match(packets, expected)
    positions = raw.raw_requests(tx, expected)
    frame = tx[positions[17]['stop']:positions[19]['stop']]
    assert frame == (HERE/'EXPECTED-FIRST-FRAME.bin').read_bytes()
    assert b''.join(packets) == (directory/'replies.bin').read_bytes()
    verifier = module('startup_result', HERE/'verify.py')
    checked = verifier.verify(directory)
    assert checked['timed_wire_bytes'] == len(frame) == 311
    assert checked['timing_excluded']
    result = dict(passed=True, scope='Startup, two warm pages, one frame and normal exit',
                  native_replies=len(packets), multiplexed_packets=generic,
                  every_native_request_and_reply_checked=True,
                  complete_final_state_and_cleanup_checked=True,
                  first_frame_wire_bytes=len(frame), first_frame_wire_exact=True,
                  new_game_fps=None, qualified_for_performance=False,
                  sha256={name: hashlib.sha256((directory/name).read_bytes()).hexdigest()
                          for name in ('mos-to-vdp.bin', 'vdp-to-mos.bin',
                                       'vdp-to-mos-delivered.bin', 'replies.bin',
                                       'state.bin', 'result.json', 'stats.json')})
    output.write_text(json.dumps(result, indent=2)+'\n')
    return result


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('directory')
    print(json.dumps(audit(parser.parse_args().directory), indent=2))
