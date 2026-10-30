"""Independent raw UART/tape/reply audit; imports no builder or verifier.

This reconstructs the bytes emitted by the immutable eZ80 tape driver, checks
every raw native reply (including the suppressed checks), and audits separate
interrupted scene holds. It launches nothing and only writes RAW-AUDIT.json.
"""
from pathlib import Path
import argparse
import hashlib
import json
import struct

HERE = Path(__file__).resolve().parent
MODULE = '310779643769adde8413b93ea282115990dfebfe873e3395ac5545ac9d506702'
CONTROL_WIRE = '370d42da5e5f05c6824e65862e5f1d5cec531e8f473deaa15cbb0014d8a88f45'
TITLE = b'RALLY / GOLEM NATIVE DEMO\r\nFuji - centerline / no damage\r\n'
PAINT_HEAD = b'\x1a\x1f\0\0' + TITLE + b'\x12\0\x10'
RECT_SKY = bytes.fromhex('19040000180019653f016700')
RECT_BOTTOM = bytes.fromhex('19040000e00019653f01ef00')
RECT_MOVING = bytes.fromhex('19040000640019653f016700')
PLAYFIELD = bytes.fromhex('180000df003f011800190400001800')
CALLS = b''.join(b'\x17\0\xa0' + struct.pack('<H', i) + b'\1' for i in (50301, 50302, 50303))
OLD_PAINT = PAINT_HEAD + RECT_SKY + RECT_BOTTOM + PLAYFIELD + CALLS
NEW_PAINT = b'\x1a\x12\0\x10' + RECT_MOVING + PLAYFIELD + CALLS
SETUP = (PAINT_HEAD + RECT_SKY + RECT_BOTTOM + b'\x17\0\xc3') * 2
MODE8 = bytes.fromhex('16081700c0001701011a0c')
SEEN = {}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def read(path):
    path = Path(path)
    data = path.read_bytes()
    SEEN[str(path.relative_to(HERE)) if path.is_relative_to(HERE) else str(path)] = sha(data)
    return data


def load(path):
    return json.loads(read(path))


def tape(data):
    """Decode independent driver records, including review opcode13."""
    at, loop, result = 0, False, []
    while at < len(data):
        start = at
        op = data[at]
        at += 1
        row = dict(op=op, loop=loop)
        if op in (1, 3, 9, 12):
            n = int.from_bytes(data[at:at + 2], 'little')
            at += 2
            row['count'] = n
            if op == 1:
                row['body'] = data[at:at + n]
                at += n
            elif op == 9:
                assert not loop
                loop = True
        elif op == 2:
            token, kind, flags, expected, patch, n = struct.unpack_from('<HBBHHH', data, at)
            at += 10
            row.update(token=token, kind=kind, flags=flags, expected=expected, patch=patch,
                       body=data[at:at + n])
            at += n
        elif op == 4:
            patch, n = struct.unpack_from('<HH', data, at)
            at += 4
            row.update(patch=patch, body=data[at:at + n])
            at += n
        elif op == 6:
            n = int.from_bytes(data[at:at + 3], 'little')
            end = data.index(0, at + 3)
            row.update(count=n, filename=data[at + 3:end].decode())
            at = end + 1
        elif op == 10:
            assert loop
            loop = False
        elif op == 0:
            assert at == len(data) and not loop
        else:
            assert op in (5, 11, 13), (start, op)
        assert at <= len(data)
        row['raw'] = data[start:at]
        result.append(row)
    assert result[-1]['op'] == 0
    return result


def expanded(rows):
    begin = next(i for i, row in enumerate(rows) if row['op'] == 9)
    end = next(i for i, row in enumerate(rows) if row['op'] == 10)
    assert sum(row['op'] == 9 for row in rows) == sum(row['op'] == 10 for row in rows) == 1
    output = [dict(row, frame=None) for row in rows[:begin]]
    output += [dict(row, frame=frame) for frame in range(1, rows[begin]['count'] + 1)
               for row in rows[begin + 1:end]]
    output += [dict(row, frame=None) for row in rows[end + 1:]]
    return output, rows[begin]['count']


def native_packets(data):
    """Decode the entire multiplexed return stream, not a magic-byte search."""
    at, output, generic = 0, [], 0
    while at < len(data):
        assert at + 2 <= len(data)
        channel, size = data[at:at + 2]
        assert channel >= 128, (at, channel)
        end = at + 2 + size
        assert end <= len(data), (at, size, len(data))
        payload = data[at + 2:end]
        if payload.startswith(b'VDPL'):
            assert channel == 0x81 and size == 10
            assert payload[4] == 1
            output.append(payload)
        at = end
        generic += 1
    return output, generic


def request(body):
    assert body[:3] == b'\x17\0\xd8'
    n = int.from_bytes(body[3:5], 'little')
    assert len(body) == n + 5 and n >= 6
    version, operation, token, reply, reserved = struct.unpack_from('<BBHBB', body, 5)
    assert version == 1 and reply == 1 and reserved == 0
    return operation, token, body[11:]


def module_resources(image):
    values = struct.unpack_from('<4sHHIIHHIIIIIIIIIII', image)
    assert values[:4] == (b'VDPL', 1, 64, len(image))
    assert values[4:8] == (0x32505345, 1, 0, 1)
    text_limit, data_limit, stack_limit, build_id, offset, size = values[8:14]
    assert (text_limit, data_limit, stack_limit, build_id) == (32768, 4096, 2048, 0x52385332)
    assert offset == 64 and offset + size == len(image) and len(image) <= 65536
    elf = image[offset:offset + size]
    assert elf[:7] == b'\x7fELF\1\1\1'
    section_at = struct.unpack_from('<I', elf, 32)[0]
    section_size, count, names_index = struct.unpack_from('<HHH', elf, 46)
    assert section_size == 40
    names_at, names_size = struct.unpack_from('<II', elf, section_at + names_index * 40 + 16)
    names = elf[names_at:names_at + names_size]
    sections = {}
    for index in range(count):
        fields = struct.unpack_from('<10I', elf, section_at + index * 40)
        name_at = fields[0]
        name = names[name_at:names.index(0, name_at)].decode()
        sections[name] = fields[5]
    resident_text = (sections['.text'] + 3) & ~3
    resident_data = sum((sections.get(name, 0) + 3) & ~3
                        for name in ('.rodata', '.data', '.bss', '.data.rel.ro'))
    assert (resident_text, resident_data) == (31844, 1004)
    assert resident_text <= text_limit and resident_data <= data_limit
    return dict(package_bytes=len(image), resident_text_bytes=resident_text,
                resident_data_bytes=resident_data, declared_text_limit=text_limit,
                declared_data_limit=data_limit, declared_stack_limit=stack_limit,
                image_limit=65536, build_id=f'{build_id:08x}',
                admitted_by_actual_LOAD=True, stack_exhaustive_qualification=False)


def reconstruct(fixture, rows, replies, stop_at_hold=False):
    assert replies
    magic, version, kind, token, handle = struct.unpack('<4sBBHH', replies[0])
    assert (magic, version, kind, token) == (b'VDPL', 1, 2, 1) and handle
    motion = read(fixture / 'motion.bin')
    assert len(motion) == 900 * 24
    lanes = struct.pack('<6i', -9216, 0, 9216, -9216, 0, 9216)
    motion_head = bytes.fromhex('1700a0040005c200001800')
    lane_head = bytes.fromhex('1700a0050005c200001800')
    wire, checks, frame_wires = bytearray(), [], {}
    index, retained = 0, bytearray()
    for row in rows:
        if stop_at_hold and row['op'] == 3 and row['count'] == 12000:
            break
        body = b''
        if row['op'] in (1, 2, 4):
            body = bytearray(row['body'])
            if row['op'] == 4 or (row['op'] == 2 and row['patch'] != 65535):
                struct.pack_into('<H', body, row['patch'], handle)
            body = bytes(body)
        elif row['op'] == 6:
            body = read(fixture / row['filename'])
            assert len(body) == row['count']
        elif row['op'] == 13:
            frame = row['frame']
            assert frame is not None
            body = motion_head + motion[(frame - 1) * 24:frame * 24] + lane_head + lanes
        if row['op'] == 2:
            operation, req_token, fields = request(body)
            assert req_token == row['token']
            assert {1: 2, 2: 3, 3: 3, 4: 4, 5: 4}[operation] == row['kind']
            packet = replies[index]
            p_magic, p_version, p_kind, p_token, value = struct.unpack('<4sBBHH', packet)
            assert (p_magic, p_version, p_kind, p_token) == (b'VDPL', 1, row['kind'], row['token'])
            flags, frame = row['flags'], row['frame']
            wanted = (frame * 4 if flags & 8 else frame if flags & 16 else
                      frame * 5 + 1 if flags & 32 else row['expected'])
            if flags & 1:
                assert value == handle and value
            elif not flags & 2:
                assert value == wanted, (row['token'], frame, value, wanted)
            if not flags & 4:
                retained += packet
            checks.append(dict(row, value=value, request=body, operation=operation,
                               fields=fields, response=packet, relative_tx_offset=len(wire)))
            index += 1
        wire += body
        if row['frame'] is not None:
            frame_wires.setdefault(row['frame'], bytearray()).extend(body)
    assert index == len(replies), (index, len(replies))
    return bytes(wire), checks, bytes(retained), {k: bytes(v) for k, v in frame_wires.items()}


def pins(profile, fixture, prior_pins):
    found = profile['input_sha256']
    for name in ('flexe-agon-emulator.bin', 'mos_platform.bin', 'mos_platform.map',
                 'flexe-vdp.so', 'esp32-firmware.bin', 'esp32-firmware.elf'):
        assert found[name] == prior_pins[name], name
    for file in fixture.iterdir():
        if file.is_file():
            assert found['sdcard/rally25/' + file.name] == sha(read(file)), file.name
    assert profile['stopped'] and profile['sound_driver'] == 'dummy'
    return {name: digest for name, digest in found.items()
            if name not in ('sdcard/rally25/script.bin', 'sdcard/rally25/expected.json')}


def verify_backend(directory):
    stats = load(directory / 'stats.json')
    assert stats['failed'] is False and stats['keys'] == 0
    assert all(stats[name] == 0 for name in ('unhandled', 'unregistered', 'unmapped'))
    tx, rx, delivered = (read(directory / name) for name in
                         ('mos-to-vdp.bin', 'vdp-to-mos.bin', 'vdp-to-mos-delivered.bin'))
    assert delivered == rx
    assert (stats['uart_rx'], stats['uart_tx'], stats['uart_delivered']) == (len(tx), len(rx), len(delivered))
    return tx, rx


def ppm(path, scene=False):
    data = read(path)
    # Pinned frontend emits a plain P6 header followed by RGB888 bytes.
    parts = data.split(b'\n', 3)
    assert parts[:3] == [b'P6', b'320 240', b'255'], parts[:3]
    assert len(parts[3]) == 320 * 240 * 3
    colours = {parts[3][i:i + 3] for i in range(0, len(parts[3]), 3)}
    assert len(colours) > (8 if scene else 1), 'Capture is unexpectedly blank'
    return sha(data)


def mark_samples(path):
    data = read(path)
    assert len(data) == 902 * 3
    return [int.from_bytes(data[i:i + 3], 'little') for i in range(0, len(data), 3)]


def full_run(campaign, case, profile, final_reference, prior_pins):
    directory = HERE / 'evidence' / campaign / case
    fixture = HERE / 'fixtures' / case
    rows, frames = expanded(tape(read(fixture / 'script.bin')))
    assert frames == 900
    assert sum(row['op'] == 5 for row in rows) == 902
    setup_rows = [i for i, row in enumerate(rows) if row['op'] == 1 and row['body'] == SETUP]
    if case == 'static':
        assert len(setup_rows) == 1
        setup_index = setup_rows[0]
        assert rows[setup_index + 1]['op'] == 2 and rows[setup_index + 1]['token'] == 3
        assert rows[setup_index + 2]['op'] == 5 and rows[setup_index + 2]['frame'] is None
        assert next(row for row in rows[setup_index + 3:] if row['frame'] is not None)['frame'] == 1
    else:
        assert not setup_rows
    tx, rx = verify_backend(directory)
    packets, generic = native_packets(rx)
    assert len(packets) == 5613
    expected, checks, retained, per_frame = reconstruct(fixture, rows, packets)
    assert tx.count(expected) == 1, 'Expanded full tape is not exact in actual TX'
    start = tx.index(expected)
    suffix = tx[start + len(expected):]
    assert MODE8 in suffix
    assert b'RALLY-25 DONE: logs saved.\r\n/rally25 *' in suffix
    assert read(directory / 'replies.bin') == retained and len(retained) == 29130
    assert sum(bool(c['flags'] & 4) for c in checks) == 2700
    reference = {key: bytes.fromhex(value) for key, value in final_reference.items()}
    final = {key: {} for key in reference}
    for check in checks:
        if check['operation'] == 5 and check['frame'] is None:
            buffer, offset = struct.unpack('<HI', check['fields'])
            key = str(buffer)
            if key in reference and offset < len(reference[key]):
                value = struct.pack('<H', check['value'])
                assert value == reference[key][offset:offset + 2]
                assert offset not in final[key] or final[key][offset] == value
                final[key][offset] = value
    for key, data in reference.items():
        assert sorted(final[key]) == list(range(0, len(data), 2)), key
        assert b''.join(final[key][offset] for offset in sorted(final[key])) == data
    assert [(check['token'], check['value']) for check in checks[-2:]] == [(217, 0), (218, 0)]
    assert b'VDPL UNLOAD status=0' in read(directory / 'esp32-uart0.txt')
    receipt = load(directory / 'run.json')
    assert receipt['error'] is None and receipt['process_exit'] == 0
    assert receipt['result']['final_buffers'] == final_reference
    identities = {line.split('  ', 1)[1]: line.split('  ', 1)[0]
                  for line in receipt['runtime_identities'].splitlines()}
    assert identities == profile['input_sha256']
    assert not (directory / 'failure.bin').exists() and not (directory / 'failure.log').exists()
    clocks = struct.unpack('<4sBBHHIBB', read(directory / 'clock.bin'))
    assert clocks == (b'R25T', 1, 0, 72, 256, 18432000, 1, 1)
    mos, prt = mark_samples(directory / 'ticks.bin'), mark_samples(directory / 'prt.bin')
    mt, pt = (mos[900] - mos[0]) & 0xffffff, (prt[900] - prt[0]) & 0xffffff
    assert mt > 0 and pt > 0
    md = [(mos[i] - mos[i - 1]) & 0xffffff for i in range(1, 901)]
    pd = [(prt[i] - prt[i - 1]) & 0xffffff for i in range(1, 901)]
    assert sum(md) == mt and sum(pd) == pt
    size = 347 if case == 'control' else 274
    assert list(per_frame) == list(range(1, 901)) and all(len(v) == size for v in per_frame.values())
    stream = b''.join(per_frame.values())
    assert stream in expected and stream in tx
    paint = OLD_PAINT if case == 'control' else NEW_PAINT
    assert all(part.count(paint) == 1 for part in per_frame.values())
    if case == 'control':
        assert sha(stream) == CONTROL_WIRE and SETUP not in expected
    else:
        assert expected.count(SETUP) == 1
        assert sha(b''.join(part.replace(NEW_PAINT, OLD_PAINT, 1) for part in per_frame.values())) == CONTROL_WIRE
    before = next(c for c in checks if c['token'] == 3)
    after = next(c for c in checks if c['token'] == 9)
    row = dict(campaign=campaign, case=case, frames=900, physics_ticks=3600,
               all_raw_native_replies=len(packets), generic_return_packets=generic,
               retained_replies=len(retained) // 10, suppressed_checks=2700,
               raw_requests_match_every_response=True, full_expanded_tx_exact=True,
               full_final_root_and5arrays_exact=True, timer_vector_restored=True,
               setup_two_swaps_before_checked_INFO17_and_initial_mark=case == 'static',
               full_final_header_interface_and_language_status_zero=True,
               clean_mode8_MOS_exit=True, backend_zero_errors=True,
               nominal_mos_units=mt, nominal_mos_fps=900 * 120 / mt,
               nominal_prt_ticks=pt, nominal_prt_fps=900 * 1000 / pt,
               per_frame_mos_delta_min_max=[min(md), max(md)],
               per_frame_prt_delta_min_max=[min(pd), max(pd)],
               zero_mos_interval_frames=[i for i, d in enumerate(md, 1) if not d],
               zero_mos_interval_evidence=[dict(frame=i, mos_before=mos[i - 1], mos_after=mos[i],
                                               prt_before=prt[i - 1], prt_after=prt[i], prt_delta=pd[i - 1])
                                           for i, d in enumerate(md, 1) if not d],
               window_sample_indices=[0, 900], teardown_sample_excluded=901,
               timed_uart_bytes=len(stream), timed_uart_sha256=sha(stream),
               stack_minfree_before=before['value'], stack_minfree_after=after['value'],
               info17_request_response_hex=[dict(token=c['token'], request=c['request'].hex(),
                                               response=c['response'].hex()) for c in (before, after)],
               final_MOS_ppm_sha256=ppm(directory / 'final.ppm'))
    first = tape(read(fixture / 'script.bin'))[0]['body']
    assert sha(first[14:]) == MODULE
    row['module_resources'] = module_resources(first[14:])
    return row, stream, expected, pins(profile, fixture, prior_pins)


def capture_run(name, profile, prior_pins):
    directory = HERE / 'captures/evidence/staticcapture01' / name
    fixture = HERE / 'captures/fixtures' / name
    frames = int(name[-3:])
    rows, count = expanded(tape(read(fixture / 'script.bin')))
    assert count == frames and frames in (30, 31)
    tx, rx = verify_backend(directory)
    packets, generic = native_packets(rx)
    assert len(packets) == 3 + 6 * frames + 1
    expected, checks, retained, frame_wires = reconstruct(fixture, rows, packets, stop_at_hold=True)
    assert tx.endswith(expected), 'Hold must send no bytes after ordered capture marker'
    assert checks[-1]['token'] == 60000 and checks[-1]['operation'] == 4
    assert checks[-1]['response'].startswith(bytes.fromhex('5644504c010460ea'))
    assert checks[-2]['token'] == 219 and checks[-2]['frame'] == frames
    assert checks[-2]['value'] == frames * 5 + 1
    assert b'RALLY-25 DONE' not in tx and b'VDPL UNLOAD status=0' not in read(directory / 'esp32-uart0.txt')
    assert list(frame_wires) == list(range(1, frames + 1))
    size = 347 if name.startswith('control-') else 274
    assert all(len(v) == size for v in frame_wires.values())
    receipt = load(directory / 'capture.json')
    assert receipt['error'] is None and receipt['ordered_marker_seen']
    assert receipt['intentional_interruption_during_hold'] and receipt['timing_excluded']
    assert receipt['game_cleanup_validated'] is False
    return (dict(name=name, frames=frames, physics_ticks=frames * 4, page_parity=frames & 1,
                all_raw_native_replies=len(packets), generic_return_packets=generic,
                raw_requests_responses_and_completed_frame_fences_exact=True,
                marker60000_last=True, no_wire_after_marker=True,
                benchmark_timing_excluded=True, cleanup_not_claimed=True,
                scene_ppm_sha256=ppm(directory / 'final.ppm', scene=True)),
            pins(profile, fixture, prior_pins))


def session(path):
    value = load(path)
    assert value['error'] is None and value['boost_restored']
    assert value['video_driver'] == value['audio_driver'] == 'dummy'
    assert value['thermal_stop_celsius'] == 95
    assert value['boost_during_session'] == '0' and not value['owned_emulator_processes_after']
    assert value['original_boost'] == value['final_boost']
    assert value['max_temperature_celsius'] < 95
    assert all(sample['boost'] == '0' for sample in value['samples'])
    return {key: value[key] for key in ('host_boot_id', 'original_boost', 'final_boost',
            'boost_restored', 'max_temperature_celsius', 'elapsed_host_seconds')}


def main():
    reference = load(HERE.parent / 'sprites/motion-comparison/CONTROL-FINAL.json')
    prior_pins = load(HERE.parent / 'wide-fill/PROFILES-wideab01.json')['byte']['input_sha256']
    rows, streams, full_wires, all_pins = [], {}, {}, []
    for campaign, order in [('staticab01', ['control', 'static']), ('staticba01', ['static', 'control'])]:
        profiles = load(HERE / ('PROFILES-' + campaign + '.json'))
        campaign_receipt = load(HERE / ('CAMPAIGN-' + campaign + '.json'))
        assert list(profiles) == order
        for case in order:
            row, stream, wire, pin = full_run(campaign, case, profiles[case], reference, prior_pins)
            saved = campaign_receipt[case]
            assert saved['passed'] and saved['full_final_state_exact'] and saved['input_hashes_preserved']
            assert abs(saved['nominal_mos_fps'] - row['nominal_mos_fps']) < 1e-10
            assert abs(saved['prt']['nominal_fps_at_18432000_hz'] - row['nominal_prt_fps']) < 1e-10
            rows.append(row); streams[(campaign, case)] = stream; full_wires[(campaign, case)] = wire
            all_pins.append(pin)
    assert streams[('staticab01', 'control')] == streams[('staticba01', 'control')]
    assert streams[('staticab01', 'static')] == streams[('staticba01', 'static')]
    for campaign in ('staticab01', 'staticba01'):
        normalized = full_wires[(campaign, 'static')].replace(SETUP, b'', 1).replace(NEW_PAINT, OLD_PAINT)
        assert normalized == full_wires[(campaign, 'control')]
    capture_profiles = load(HERE / 'captures/PROFILES-staticcapture01.json')
    captures = []
    for name in ('control-f030', 'static-f030', 'control-f031', 'static-f031'):
        row, pin = capture_run(name, capture_profiles[name], prior_pins)
        captures.append(row); all_pins.append(pin)
    assert all(pin == all_pins[0] for pin in all_pins)
    sessions = dict(benchmark=session(HERE / 'SESSION-staticsession01.json'),
                    captures=session(HERE / 'captures/SESSION-staticcapturesession01.json'))
    pooled = {}
    for case in ('control', 'static'):
        selected = [r for r in rows if r['case'] == case]
        mos, prt = sum(r['nominal_mos_units'] for r in selected), sum(r['nominal_prt_ticks'] for r in selected)
        pooled[case] = dict(frames=1800, nominal_mos_units=mos, nominal_mos_fps=1800 * 120 / mos,
                            nominal_prt_ticks=prt, nominal_prt_fps=1800 * 1000 / prt)
    pairs = []
    for campaign in ('staticab01', 'staticba01'):
        p = {r['case']: r for r in rows if r['campaign'] == campaign}
        pairs.append(dict(campaign=campaign, nominal_mos_gain_percent=100 * (p['static']['nominal_mos_fps'] / p['control']['nominal_mos_fps'] - 1),
                          nominal_prt_gain_percent=100 * (p['static']['nominal_prt_fps'] / p['control']['nominal_prt_fps'] - 1)))
    result = dict(schema=1, task='INC-001-04', passed=True,
        method='Independent driver-tape expansion, entire actual TX byte match, multiplexed return-packet decoder and all raw replies matched to actual requests; no build/report/verifier imports',
        rows=rows, captures=captures, pooled=pooled, pairs=pairs,
        nominal_mos_gain_percent=100 * (pooled['static']['nominal_mos_fps'] / pooled['control']['nominal_mos_fps'] - 1),
        nominal_prt_gain_percent=100 * (pooled['static']['nominal_prt_fps'] / pooled['control']['nominal_prt_fps'] - 1),
        only_authorized_setup_and_paint_TX_changes=True, full_final_states_exact=True,
        all22452_benchmark_native_replies_checked=True, all10800_suppressed_benchmark_checks_checked=True,
        captured_frame30_and31_ordered_before_hold=True, same_module_and_runtime=True,
        unchanged_inputs_and_runtime_manifest=all_pins[0], sessions=sessions,
        limits=['Nominal MOS120units/s and PRT1000IRQ ticks/s are separate emulator clocks, not calibrated physical timing.',
            'Ordered post-swap completion is fenced; physical scanout is not timestamped.',
            'Capture holds are interrupted diagnostics. They claim neither final world nor StopRace/UNLOAD/MOS cleanup acceptance.',
            'Scene PPM hashes/shape checked here; pixel comparison and human visual acceptance are separate.',
            'Saved runtime identity/guard receipts are audited; no remote live binary rehash or emulator run is performed.'],
        input_and_evidence_sha256=SEEN, audit_source_sha256=sha(Path(__file__).read_bytes()))
    (HERE / 'RAW-AUDIT.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(dict(passed=True, rows=len(rows), captures=len(captures), pooled=pooled, pairs=pairs), indent=2))


if __name__ == '__main__':
    argparse.ArgumentParser(description=__doc__).parse_args()
    main()
