"""Compare exact held scene pixels and create lossless PNG previews, no rerun."""
from pathlib import Path
import binascii
import hashlib
import json
import struct
import zlib

HERE = Path(__file__).resolve().parent


def png(rgb):
    def chunk(kind, body):
        return struct.pack('>I', len(body)) + kind + body + struct.pack('>I', binascii.crc32(kind + body))
    raw = b''.join(b'\0' + rgb[y*960:(y+1)*960] for y in range(240))
    return (b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR', struct.pack('>2I5B', 320, 240, 8, 2, 0, 0, 0))
            + chunk(b'IDAT', zlib.compress(raw, 9)) + chunk(b'IEND', b''))


def report():
    root = HERE / 'captures/evidence/staticcapture01'
    campaign = json.loads((HERE / 'captures/CAMPAIGN-staticcapture01.json').read_text())
    session = json.loads((HERE / 'captures/SESSION-staticcapturesession01.json').read_text())
    assert session['error'] is None and session['boost_restored']
    assert not session['owned_emulator_processes_after']
    pairs = []
    for frame in (30, 31):
        scenes = []
        for case in ('control', 'static'):
            name = f'{case}-f{frame:03d}'
            run = campaign[name]
            assert run['error'] is None and run['ordered_marker_seen']
            assert run['intentional_interruption_during_hold'] and run['timing_excluded']
            assert run['input_hashes_unchanged'] and run['process_exit'] == 0
            scene = (root / name / 'final.ppm').read_bytes()
            assert scene[:15] == b'P6\n320 240\n255\n' and len(scene) == 230415
            scenes.append(scene)
        a, b = scenes
        changed = sum(a[i:i+3] != b[i:i+3] for i in range(15, len(a), 3))
        assert changed == 0, (frame, changed)
        output = HERE / 'captures' / f'scene-f{frame:03d}.png'
        output.write_bytes(png(b[15:]))
        pairs.append(dict(frame=frame, page_parity=frame%2, changed_pixels=changed,
                          pixels=76800, exact=True, scene_sha256=hashlib.sha256(b).hexdigest(),
                          preview=str(output.relative_to(HERE))))
    result = dict(actual_scene_snapshots=True, frames=[30, 31], pairs=pairs,
                  timing_excluded=True, intentional_hold_interruption=True,
                  cleanup_validated_by_capture=False,
                  cleanup_gate='Separate completed900-frame runs validate shutdown and MOS return',
                  human_visual_review_pending=True,
                  maximum_temperature_celsius=session['max_temperature_celsius'],
                  boost_restored=session['boost_restored'], owned_emulators_stopped=True)
    (HERE / 'CAPTURE-RESULTS.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    report()
