"""INC-001-04: retain static pixels on both pages; frozen module and driver.

This file deliberately has its own tape parser. Opcode13 belongs to the
accepted motion driver; the older immutable parsers predate it.
"""
from pathlib import Path
import hashlib
import json
import shutil
import struct
import zipfile

HERE = Path(__file__).resolve().parent
INC = HERE.parent
SOURCE = INC / 'wide-fill/fixtures/byte'
MODULE_SHA256 = '310779643769adde8413b93ea282115990dfebfe873e3395ac5545ac9d506702'
TITLE = b'RALLY / GOLEM NATIVE DEMO\r\nFuji - centerline / no damage\r\n'
RESET = b'\x1a'
TITLE_PAINT = RESET + b'\x1f\0\0' + TITLE
GCOL = b'\x12\0\x10'
SWAP = b'\x17\0\xc3'


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def rect(top, bottom):
    return b'\x19\x04' + struct.pack('<hh', 0, top) + b'\x19\x65' + struct.pack('<hh', 319, bottom)


PLAYFIELD = b'\x18' + struct.pack('<4h', 0, 223, 319, 24) + b'\x19\x04' + struct.pack('<hh', 0, 24)
OUTPUT_CALLS = b''.join(b'\x17\0\xa0' + struct.pack('<H', key) + b'\x01' for key in (50301, 50302, 50303))
OLD_PAINT = TITLE_PAINT + GCOL + rect(24, 103) + rect(224, 239) + PLAYFIELD + OUTPUT_CALLS
NEW_PAINT = RESET + GCOL + rect(100, 103) + PLAYFIELD + OUTPUT_CALLS
SETUP_PAGE = TITLE_PAINT + GCOL + rect(24, 103) + rect(224, 239) + SWAP
SETUP_PAYLOAD = SETUP_PAGE * 2
assert (len(TITLE), len(OLD_PAINT), len(NEW_PAINT), len(SETUP_PAYLOAD)) == (58, 122, 49, 184)


def records(data):
    """Decode all accepted driver opcodes, retaining absolute record offsets."""
    at, loop, result = 0, False, []
    while at < len(data):
        start = at
        op = data[at]
        at += 1
        row = dict(offset=start, opcode=op, loop=loop)
        if op == 0:
            assert at == len(data), 'Trailing data after END'
            result.append(row)
            return result
        if op in (1, 3, 9, 12):
            assert at + 2 <= len(data)
            count = int.from_bytes(data[at:at + 2], 'little')
            at += 2
            row['value'] = count
            if op == 1:
                row.update(payload_offset=at, payload_bytes=count)
                at += count
            elif op == 9:
                assert not loop
                loop = True
        elif op == 2:
            token, kind, flags, value, patch, count = struct.unpack_from('<HBBHHH', data, at)
            at += 10
            row.update(token=token, kind=kind, flags=flags, value=value,
                       handle_patch=patch, payload_offset=at, payload_bytes=count)
            at += count
        elif op == 4:
            patch, count = struct.unpack_from('<HH', data, at)
            at += 4
            row.update(handle_patch=patch, payload_offset=at, payload_bytes=count)
            at += count
        elif op == 6:
            count = int.from_bytes(data[at:at + 3], 'little')
            at += 3
            end = data.index(0, at)
            row.update(filename=data[at:end].decode(), payload_bytes=count)
            at = end + 1
        elif op == 10:
            assert loop
            loop = False
        elif op not in (5, 11, 13):
            raise AssertionError(('Unknown tape opcode', start, op))
        assert at <= len(data)
        result.append(row)
    raise AssertionError('Missing END')


def raw_records(tape):
    rows = records(tape)
    return [(row, tape[row['offset']:rows[i + 1]['offset'] if i + 1 < len(rows) else len(tape)])
            for i, row in enumerate(rows)]


def send(payload):
    assert len(payload) <= 65535
    return b'\x01' + struct.pack('<H', len(payload)) + payload


def body(tape, row):
    at = row['payload_offset']
    return tape[at:at + row['payload_bytes']]


def source_bounds():
    """Identity-check the actual accepted source and its qualified target image."""
    sprites = INC / 'sprites'
    manifest = json.loads((sprites / 'PACKAGE.json').read_text())
    archive = sprites / 'PORTABLE.zip'
    assert sha(archive) == manifest['sha256']
    with zipfile.ZipFile(archive) as saved:
        prefix = 'source/candidate/'
        names = ['helper/render_core.inc', 'helper/sprite.inc', 'helper/sprite_io.inc',
                 'helper/rally_render.c', 'native.c']
        sources = {}
        for name in names:
            member = prefix + name
            data = saved.read(member)
            assert hashlib.sha256(data).hexdigest() == manifest['members'][member]
            sources[name] = data.decode()
        image = saved.read('target/candidate/rally-render.vdpl')
        assert hashlib.sha256(image).hexdigest() == MODULE_SHA256
    core, sprite = sources['helper/render_core.inc'], sources['helper/sprite.inc']
    # These guards make a future code change fail this proof rather than silently
    # reusing today's y=100 boundary. Host replay separately checks every frame.
    required = [
        'z < 64 || z > 1100',
        'int q = 8000 / z, y = 96 + q',
        'scale = q * 2;',
        'y - 70 * scale / 256',
        'if (y < 104 || ground > 223)',
        'rect(o, 0, 224, 319, 239, 0);',
        'if (yy >= 104 && yy <= 223)',
        'if (bottom > 223)',
        'c - (mirror ? 50 : 51), 154)',
        '#define R28_SPAN_TOP 104',
        '#define R28_SPAN_HEIGHT 120',
        'word(o, R28_SPAN_TOP);',
    ]
    for text in required:
        assert text in core, ('Accepted source guard changed', text)
    assert 'void r28_sprite_emit' in sprite
    assert 'if(bottom>223)bottom=223;' in sprite
    assert 'top=r->y<cliptop?cliptop:r->y;' in sprite
    assert 'word(o,p.x);word(o,p.y);' in sprite
    assert 'byte(o,26)' not in core and 'byte(o,26)' not in sprite
    # All admitted integer depths, independent of this particular motion table.
    depths = list(range(64, 1101))
    rows = [(z, 8000 // z, 96 + 8000 // z - (70 * (2 * (8000 // z))) // 256) for z in depths]
    assert min(row[2] for row in rows) == 100
    assert min(row[1] for row in rows) == 7 and max(row[1] for row in rows) == 125
    return dict(archive_sha256=sha(archive), target_member='target/candidate/rally-render.vdpl',
                module_sha256=MODULE_SHA256,
                source_members={prefix + name: hashlib.sha256(text.encode()).hexdigest()
                                for name, text in sources.items()},
                admitted_integer_depths=len(depths), q_min=7, q_max=125,
                traffic_minimum_unclipped_top=100, traffic_clip_only_restricts=True,
                signs_minimum_top=104, normal_player_top=154,
                crash_effect_conservative_minimum_top=157,
                crash_effect_condition='Reference crash countdown0..150; actual deterministic fixture has no crash effect',
                finish_and_opaque_road_top=104, road_bottom=223,
                bottom_black_rectangle='Unchanged native command; outside active playfield and fully clipped',
                internal_viewport_reset=False,
                recurring_restore_y=[100, 103], invariant_sky_y=[24, 99],
                static_title_and_blank_third_row='Only existing two title lines are drawn; y16..23 remains the existing cleared blank row')


def derive(tape):
    old_rows = raw_records(tape)
    setup_at = [i for i, (row, _) in enumerate(old_rows)
                if row['opcode'] == 2 and row.get('token') == 3]
    paints = [i for i, (row, _) in enumerate(old_rows)
              if row['opcode'] == 1 and row['loop'] and body(tape, row) == OLD_PAINT]
    assert len(setup_at) == len(paints) == 1
    setup_at, paint_at = setup_at[0], paints[0]
    assert not old_rows[setup_at][0]['loop']
    assert old_rows[setup_at + 1][0]['opcode'] == 5
    assert old_rows[setup_at + 2][0]['opcode'] == 9
    query = body(tape, old_rows[setup_at][0])
    assert query == bytes.fromhex('17 00 d8 08 00 01 04 03 00 01 00 11 00')
    output = bytearray()
    for i, (_, raw) in enumerate(old_rows):
        if i == setup_at:
            output += send(SETUP_PAYLOAD)
        output += send(NEW_PAINT) if i == paint_at else raw
    result = bytes(output)
    new_rows = raw_records(result)
    assert len(new_rows) == len(old_rows) + 1
    assert new_rows[setup_at][0]['opcode'] == 1
    assert body(result, new_rows[setup_at][0]) == SETUP_PAYLOAD
    # Remove our insertion and replace our paint to reconstruct every old byte.
    reconstructed = bytearray()
    for i, (_, raw) in enumerate(new_rows):
        if i == setup_at:
            continue
        reconstructed += send(OLD_PAINT) if i == paint_at + 1 else raw
    assert bytes(reconstructed) == tape
    assert len(result) == len(tape) + 187 - 73
    assert sum(row['opcode'] == 5 for row, _ in new_rows) == 3
    assert [(row.get('value'), row['loop']) for row, _ in new_rows if row['opcode'] == 9] == [(900, False)]
    assert sum(row['opcode'] == 13 for row, _ in new_rows) == 1
    assert [raw for row, raw in old_rows if row['opcode'] == 2] == [raw for row, raw in new_rows if row['opcode'] == 2]
    return result, dict(setup_before_original_record=setup_at,
                        setup_offset=new_rows[setup_at][0]['offset'],
                        setup_payload_bytes=184, setup_tape_record_bytes=187,
                        setup_stock_swaps=2, setup_page_parity_unchanged=True,
                        setup_followed_by_existing_checked_info17=True,
                        original_initial_mark_offset=old_rows[setup_at + 1][0]['offset'],
                        candidate_initial_mark_offset=new_rows[setup_at + 2][0]['offset'],
                        original_paint_record=paint_at, candidate_paint_record=paint_at + 1,
                        old_paint_bytes=122, new_paint_bytes=49, recurring_uart_bytes_saved=73,
                        reconstructed_original_tape_exact=True, all_checked_transactions_byte_identical=True,
                        new_replies_or_marks=False, old_script_bytes=len(tape), new_script_bytes=len(result))


def build():
    assert not (HERE / 'BUILD-PROOF.json').exists(), 'Preserve prior outcomes'
    original = json.loads((INC / 'wide-fill/FIXTURES.json').read_text())['byte']
    assert all(sha(SOURCE / name) == digest for name, digest in original['files'].items())
    source_registry_sha = sha(INC / 'wide-fill/FIXTURES.json')
    bounds = source_bounds()
    tape = (SOURCE / 'script.bin').read_bytes()
    old_meta = json.loads((SOURCE / 'expected.json').read_text())
    first = records(tape)[0]
    first_body = body(tape, first)
    assert first['opcode'] == 1
    assert hashlib.sha256(first_body[14:]).hexdigest() == MODULE_SHA256
    assert int.from_bytes(first_body[12:14], 'little') == len(first_body) - 14
    candidate, patch = derive(tape)
    registry = {}
    for case in ('control', 'static'):
        output = HERE / 'fixtures' / case
        shutil.copytree(SOURCE, output)
        if case == 'static':
            (output / 'script.bin').write_bytes(candidate)
            meta = json.loads((output / 'expected.json').read_text())
            meta.update(candidate='INC-001-04 two-page static title/sky/lower strip; accepted additive sampler and byte fill unchanged',
                        comparison_scope='Tape-only static drawing: two setup swaps before first timer mark, y100..103 sky restoration, all generated module/physics/output commands unchanged',
                        outbound_uart_bytes_per_frame=274, static_drawing_change=patch,
                        static_scene_regions=dict(title='Existing two lines; blank third row preserved', invariant_sky=[24, 99],
                                                  lower_strip=[224, 239], recurring_sky=[100, 103]))
            meta['files']['script.bin'] = sha(output / 'script.bin')
            (output / 'expected.json').write_text(json.dumps(meta, indent=2) + '\n')
        registry[case] = dict(directory=str(output.relative_to(HERE)),
                              files={p.name: sha(p) for p in sorted(output.iterdir()) if p.is_file()},
                              module_sha256=MODULE_SHA256, diagnostic=False, foreground_paced=False)
    assert registry['control']['files'] == original['files']
    changed = [name for name, digest in registry['control']['files'].items()
               if registry['static']['files'][name] != digest]
    assert changed == ['expected.json', 'script.bin'], changed
    assert old_meta['frames'] == 900 and old_meta['physics_ticks'] == 3600
    assert old_meta['reply_bytes'] == 29130 and old_meta['tick_samples'] == 902
    assert source_registry_sha == sha(INC / 'wide-fill/FIXTURES.json')
    proof = dict(checkpoint='aab566d', source_fixture=str(SOURCE.relative_to(HERE.parent)),
                 source_files=original['files'], source_registry_sha256=source_registry_sha,
                 source_fixture_and_registry_unchanged=True, control_byte_exact=True,
                 changed_candidate_files=changed, module_sha256=MODULE_SHA256,
                 module_driver_artwork_motion_physics_generated_outputs_unchanged=True,
                 source_bounds=bounds, patch=patch,
                 frames=900, physics_ticks=3600, retained_replies=2913, timer_samples=902,
                 frame_uart_bytes=dict(control=347, static=274),
                 clear_pixel_writes_per_frame=dict(control=320 * (80 + 16), static=320 * 4,
                                                  removed=320 * (76 + 16)),
                 setup_pixel_clear_writes=2 * 320 * (80 + 16),
                 setup_fence='Existing token3 INFO17 checked reply follows two blocking stock controller swaps before initial mark; no new transaction/reply',
                 setup_fence_prior_qualification='../../throughput/COMPLETION-FENCE.json: pinned mode136 synchronous draw and blocking controller swap',
                 no_allocations_or_new_retained_buffers=True, no_compilation_or_firmware_sdk_change=True,
                 emulator_launched=False, measured_speedup=False)
    (HERE / 'FIXTURES.json').write_text(json.dumps(registry, indent=2) + '\n')
    (HERE / 'BUILD-PROOF.json').write_text(json.dumps(proof, indent=2) + '\n')
    print('Prepared exact control and static candidate: paint122→49B, frame347→274B; no emulator run')


if __name__ == '__main__':
    build()
