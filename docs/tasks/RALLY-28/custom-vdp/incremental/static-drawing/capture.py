"""Separate scene-hold tapes for actual30/31-frame page-parity snapshots.

These are diagnostics, excluded from benchmark timing. The pinned driver and
timed900-frame fixtures remain unchanged. A unique ordered INFO17 reply announces
that the selected moving frame is displayed; the guest then sends/draws nothing
during its hold. Full-suite cleanup qualification belongs to the900-frame runs.
"""
from pathlib import Path
import hashlib
import importlib.util
import json
import shutil
import struct

HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location('static_tape_builder', HERE / 'build.py')
tape_builder = importlib.util.module_from_spec(spec)
spec.loader.exec_module(tape_builder)
MARKER_TOKEN = 60000
HOLD_CLOCK_CHANGES = 12000


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def marker_record():
    payload = struct.pack('<BBHBBH', 1, 4, MARKER_TOKEN, 1, 0, 17)
    wire = b'\x17\0\xd8' + struct.pack('<H', len(payload)) + payload
    # kind4 INFO value, accept arbitrary16-bit stack watermark, retain record.
    return b'\x02' + struct.pack('<HBBHHH', MARKER_TOKEN, 4, 2, 0, 65535, len(wire)) + wire


def derive(source, frames):
    assert frames in (30, 31)
    tape = (source / 'script.bin').read_bytes()
    meta = json.loads((source / 'expected.json').read_text())
    rows = tape_builder.raw_records(tape)
    loop_begin = [i for i, (row, _) in enumerate(rows) if row['opcode'] == 9]
    loop_end = [i for i, (row, _) in enumerate(rows) if row['opcode'] == 10]
    assert len(loop_begin) == len(loop_end) == 1
    begin, end = loop_begin[0], loop_end[0]
    assert rows[begin][0]['value'] == 900 and begin < end
    stop_token = next(check['token'] for check in meta['checks'] if check['label'] == 'StopRace')
    stop_at = next(i for i, (row, _) in enumerate(rows)
                   if row['opcode'] == 2 and row['token'] == stop_token)
    assert stop_at > end + 2
    # Keep the original requested-entry update, ready clear and checked invoke.
    tail_start = stop_at - 2
    assert rows[tail_start][0]['opcode'] == rows[tail_start + 1][0]['opcode'] == 1
    root_update = tape_builder.body(tape, rows[tail_start][0])
    assert root_update == bytes.fromhex('17 00 a0 01 00 05 c2 1c 00 02 00 10 00')
    prefix = bytearray()
    for i, (_, raw) in enumerate(rows[:end + 1]):
        prefix += b'\x09' + struct.pack('<H', frames) if i == begin else raw
    marker = marker_record()
    hold = b'\x03' + struct.pack('<H', HOLD_CLOCK_CHANGES)
    result = bytes(prefix) + marker + hold + b''.join(raw for _, raw in rows[tail_start:])
    parsed = tape_builder.records(result)
    marker_at = [row for row in parsed if row['opcode'] == 2 and row['token'] == MARKER_TOKEN]
    assert len(marker_at) == 1 and not marker_at[0]['loop']
    marker_index = parsed.index(marker_at[0])
    assert parsed[marker_index - 1]['opcode'] == 10
    assert parsed[marker_index + 1]['opcode'] == 3
    assert parsed[marker_index + 1]['value'] == HOLD_CLOCK_CHANGES
    # All loop records, including checks/fence/mark and opcode13 motion, retain
    # their exact bytes. Only REPEAT's iteration count changes.
    assert [raw for row, raw in rows if row['loop']] == [
        raw for row, raw in tape_builder.raw_records(result) if row['loop']]
    old_checks = {check['token']: check for check in meta['checks']}
    marker_check = dict(token=MARKER_TOKEN, kind=4, value=None,
                        label='Scene displayed: ordered INFO17 capture marker',
                        flags=2, repeats=1, loop=False)
    checks = []
    for row in parsed:
        if row['opcode'] != 2:
            continue
        check = dict(marker_check if row['token'] == MARKER_TOKEN else old_checks[row['token']])
        check.update(loop=row['loop'], repeats=frames if row['loop'] else 1)
        checks.append(check)
    motion = (source / 'motion.bin').read_bytes()
    positions = list(struct.unpack_from('<6I', motion, (frames - 1) * 24))
    for name in ('player_final_station', 'final_scripted_positions'):
        meta.pop(name, None)
    meta.update(frames=frames, physics_ticks=frames * 4, tick_samples=frames + 1,
                checks=checks, reply_bytes=sum(check['repeats'] * 10 for check in checks if not check['flags'] & 4),
                candidate='Diagnostic scene hold after completed moving frame' + str(frames),
                diagnostic_hold=True, diagnostic_not_benchmark=True,
                comparison_scope='Same selected scene, actual displayed30/31-frame parity, no benchmark timing claim',
                timing_scope='Excluded: deliberate long hold and possible capture interruption;900-frame fixtures own timing/cleanup evidence',
                scene_capture_frame=frames, scene_capture_page_parity=frames & 1,
                diagnostic_scripted_positions=positions,
                capture_marker=dict(token=MARKER_TOKEN, kind=4, native_operation='INFO17',
                                    raw_packet_prefix_hex=(b'VDPL' + struct.pack('<BBH', 1, 4, MARKER_TOKEN)).hex(),
                                    original_final_frame_post_swap_fence_retained=True),
                hold_observed_mos_lowbyte_changes=HOLD_CLOCK_CHANGES,
                hold_units='Opcode3 counts observed sysvar_time lowbyte changes; mode136 normally60changes/s, despite120nominal MOS units/s',
                hold_sends_or_drawing=False,
                cleanup_after_hold='Original requested-entry/ready update, StopRace/UNLOAD checks, bitmap cleanup, END;900-frame final-world queries omitted',
                interrupted_capture_is_not_cleanup_acceptance=True)
    info = dict(frames=frames, physics_ticks=frames * 4, page_parity=frames & 1,
                source_script_sha256=sha(source / 'script.bin'),
                original_per_frame_tape_records_exact=True,
                initial_setup_and_first_timer_mark_unchanged=True,
                no_extra_page_swap=True, motion_table_and_driver_unchanged=True,
                marker_token=MARKER_TOKEN, marker_record_offset=marker_at[0]['offset'],
                marker_raw_packet_prefix_hex=meta['capture_marker']['raw_packet_prefix_hex'],
                hold_observed_clock_changes=HOLD_CLOCK_CHANGES,
                expected_reply_bytes_if_allowed_to_finish=meta['reply_bytes'],
                expected_timer_samples_if_allowed_to_finish=frames + 1,
                cleanup_tail_records_byte_identical=True,
                no_full_final_world_qualification=True,
                benchmark_timing_excluded=True)
    return result, meta, info


def build():
    assert not (HERE / 'CAPTURE-FIXTURES.json').exists(), 'Preserve prior capture fixtures'
    fixture_registry = json.loads((HERE / 'FIXTURES.json').read_text())
    output = {}
    before = {case: item['files'] for case, item in fixture_registry.items()}
    for frames in (30, 31):
        for case in ('control', 'static'):
            item = fixture_registry[case]
            source = HERE / item['directory']
            assert all(sha(source / name) == digest for name, digest in item['files'].items())
            name = case + '-f' + str(frames).zfill(3)
            destination = HERE / 'captures/fixtures' / name
            shutil.copytree(source, destination)
            tape, meta, info = derive(source, frames)
            (destination / 'script.bin').write_bytes(tape)
            meta['diagnostic_source_case'] = case
            meta['files']['script.bin'] = sha(destination / 'script.bin')
            (destination / 'expected.json').write_text(json.dumps(meta, indent=2) + '\n')
            files = {path.name: sha(path) for path in sorted(destination.iterdir()) if path.is_file()}
            assert [key for key, digest in item['files'].items() if files[key] != digest] == ['expected.json', 'script.bin']
            output[name] = dict(directory=str(destination.relative_to(HERE)), files=files,
                                module_sha256=item['module_sha256'], diagnostic=True,
                                foreground_paced=False, capture=info)
    for case, files in before.items():
        assert all(sha(HERE / fixture_registry[case]['directory'] / name) == digest for name, digest in files.items())
    (HERE / 'CAPTURE-FIXTURES.json').write_text(json.dumps(output, indent=2) + '\n')
    print('Prepared four separate scene holds: control/static at completed30/31frames; benchmark fixtures unchanged')


if __name__ == '__main__':
    build()
