"""Prepare isolated native control fixtures; never rebuild or edit old controls."""
from pathlib import Path
import hashlib
import json
import struct
import sys
import zipfile

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[4]
PRIOR = HERE.parent / 'paced-road'
sys.path.insert(0, str(PRIOR))
from freeze_control import records

sha = lambda p: hashlib.sha256(Path(p).read_bytes()).hexdigest()


def unpace(tape):
    parsed = records(tape)
    out = bytearray()
    removed = 0
    for i, record in enumerate(parsed):
        stop = parsed[i + 1]['offset'] if i + 1 < len(parsed) else len(tape)
        if record['opcode'] == 11:
            assert record['loop'], 'Only the foreground frame deadline may be removed'
            removed += 1
        else:
            out += tape[record['offset']:stop]
    assert removed == 1
    # No draw, physics, reply, mark, swap or lifecycle byte is changed.
    original = [tape[r['offset']:(parsed[i + 1]['offset'] if i + 1 < len(parsed) else len(tape))]
                for i, r in enumerate(parsed) if r['opcode'] != 11]
    changed = records(out)
    rebuilt = [bytes(out[r['offset']:(changed[i + 1]['offset'] if i + 1 < len(changed) else len(out))])
               for i, r in enumerate(changed)]
    assert original == rebuilt
    return bytes(out)


def completion_fence(tape, meta, root):
    """Order a checked reply after drawing/swap, before each foreground mark."""
    assert not meta['paced']
    parsed = records(tape)
    marks = [i for i, r in enumerate(parsed) if r['opcode'] == 5 and r['loop']]
    assert len(marks) == 1
    index = marks[0]
    previous = parsed[index - 1]
    assert previous['opcode'] == 1
    start = previous['payload_offset']
    assert tape[start:start + previous['payload_bytes']] == b'\x17\0\xc3'
    token = max(c['token'] for c in meta['checks']) + 1
    assert token <= 65535
    body = struct.pack('<BBHBBHI', 1, 5, token, 1, 0, root, 20)
    wire = b'\x17\0\xd8' + struct.pack('<H', len(body)) + body
    assert len(wire) == 17
    added = b'\2' + struct.pack('<HBBHHH', token, 4, 36, 0, 65535, len(wire)) + wire
    offset = parsed[index]['offset']
    changed = tape[:offset] + added + tape[offset:]
    checks = meta['checks']
    at = max(i for i, c in enumerate(checks) if c.get('loop')) + 1
    checks.insert(at, dict(token=token, kind=4, value=0,
        label='post-swap generation fence = frame*5+1', flags=36,
        repeats=meta['frames'], loop=True))
    assert sum(c['repeats'] * 10 for c in checks if not c['flags'] & 4) == meta['reply_bytes']
    new = records(changed)
    # Prove insertion only, at the swap -> check -> mark boundary.
    assert len(new) == len(parsed) + 1
    without = bytearray()
    for i, r in enumerate(new):
        stop = new[i + 1]['offset'] if i + 1 < len(new) else len(changed)
        if i == index:
            assert r['opcode'] == 2 and r['token'] == token
        else:
            without += changed[r['offset']:stop]
    assert bytes(without) == tape
    meta.update(completion_fenced=True, fence_outbound_bytes_per_frame=17,
                fence_reply_payload_bytes_per_frame=10,
                fence_scope='Ordered native READ16 after controller swap and prior drawing; excludes physical scanout',
                timing_scope='Completion-fenced unpaced fixture; extra checked-reply/transport overhead included. '
                             'MOS/PRT nominal clocks; no physical scanout or hardware-capacity claim.')
    return changed


def prepare():
    package = json.loads((PRIOR / 'CANDIDATES-PACKAGE.json').read_text())
    archive = PRIOR / 'CANDIDATES.zip'
    assert sha(archive) == package['sha256'], 'Frozen candidate archive changed'
    report = {}
    with zipfile.ZipFile(archive) as source:
        for name in ('control', 'float-quad-layered'):
            for paced in (True, False):
                key = name + ('-paced' if paced else '-unpaced')
                output = HERE / '.work/fixtures' / key
                output.mkdir(parents=True, exist_ok=True)
                for member in source.namelist():
                    prefix = 'fixtures/' + name + '/'
                    if not member.startswith(prefix):
                        continue
                    relative = Path(member[len(prefix):])
                    assert len(relative.parts) == 1 and relative.name != '..'
                    data = source.read(member)
                    assert hashlib.sha256(data).hexdigest() == package['member_sha256'][member]
                    (output / relative).write_bytes(data)
                meta = json.loads((output / 'expected.json').read_text())
                if not paced:
                    tape = unpace((output / 'script.bin').read_bytes())
                    (output / 'script.bin').write_bytes(tape)
                meta.update(candidate=key, paced=paced,
                    foreground_deadline_mos_units=[3, 3, 4] if paced else None,
                    swap_retained=True, physics_steps_per_frame=4,
                    timing_scope='Finite native Fuji fixture; transport/checks/render/swap submission included. '
                                 'MOS nominal120units/s; no separate scanout-completion or hardware-capacity claim.')
                meta['files'] = {p.name: sha(p) for p in sorted(output.iterdir())
                                 if p.is_file() and p.name != 'expected.json'}
                (output / 'expected.json').write_text(json.dumps(meta, indent=2) + '\n')
                assert meta['frames'] == 900 and meta['physics_ticks'] == 3600
                report[key] = dict(directory=str(output.relative_to(HERE)),
                    files={p.name: sha(p) for p in sorted(output.iterdir()) if p.is_file()},
                    module_sha256=meta['module_sha256'], foreground_paced=paced,
                    only_runtime_tape_change=None if paced else 'Removed single opcode11 foreground deadline',
                    physics_and_drawing_records_unchanged=True, emulator_launched=False)
    (HERE / 'FIXTURES.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(dict(fixtures=len(report), frozen_archive_unchanged=True, emulator_launched=False)))
    return report


if __name__ == '__main__':
    prepare()
