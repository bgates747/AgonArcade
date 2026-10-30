"""Independent full-race UART/state/clock/guard audit; launches nothing.

No builder, reference runner or result verifier is imported. The multiplexed
return decoder is copied as a pure function from the prior independent audit.
All requests and response expectations are reconstructed directly from the
frozen public protocol, native ABI and actual guest ordering.
"""
from pathlib import Path
import argparse
import csv
import hashlib
import json
import struct
import sys
import traceback

HERE = Path(__file__).resolve().parent
FIRMWARE = '8da2ebfdfa3b5b00f4a1929ad4885c838845b160f570259792ef370b69d4f473'
MODE8 = bytes.fromhex('16081700c0001701011a0c')
RUNTIME = ('flexe-agon-emulator.bin', 'mos_platform.bin', 'mos_platform.map',
           'flexe-vdp.so', 'esp32-firmware.bin', 'esp32-firmware.elf')
SEEN = {}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def read(path):
    path = Path(path)
    data = path.read_bytes()
    name = str(path.relative_to(HERE)) if path.is_relative_to(HERE) else str(path)
    SEEN[name] = sha(data)
    return data


def load(path):
    return json.loads(read(path))


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


def request(operation, token, fields):
    body = struct.pack('<BBHBB', 1, operation, token, 1, 0) + fields
    return b'\x17\0\xd8' + struct.pack('<H', len(body)) + body


def specs(frames, module_bytes, handle, reference, *, main_hold=None,
          coverage_frames=0, coverage_hold=False):
    """Independent exact request/response schedule, including both warm pages."""
    output = []

    def add(operation, fields, value, label, phase='setup', frame=None):
        token = len(output) + 1
        output.append(dict(token=token, operation=operation, fields=fields,
                           wire=request(operation, token, fields),
                           kind={1: 2, 2: 3, 3: 3, 4: 4, 5: 4}[operation],
                           value=value, label=label, phase=phase, frame=frame))

    def run(entry, phase='setup', frame=None):
        add(2, struct.pack('<HHH', handle, entry, 9), 0, 'RUN ' + str(entry), phase, frame)

    def word(buffer, offset, value, label, phase='setup', frame=None):
        add(5, struct.pack('<HI', buffer, offset), value, label, phase, frame)

    def render(index, world, generation, phase, frame):
        run(15, phase, frame)
        word(50304, 44, 1, 'published ready', phase, frame)
        word(50304, 16, index, 'published request', phase, frame)
        word(50304, 20, world, 'published physics tick', phase, frame)
        word(1, 20, generation, 'generated state', phase, frame)
        word(1, 20, generation, 'post-swap generation fence', phase, frame)

    add(1, struct.pack('<HIH', 50305, module_bytes, 0), handle, 'LOAD')
    run(13)
    word(1, 198, 3246800 & 65535, 'initial player station low')
    word(1, 200, 3246800 >> 16, 'initial player station high')
    word(1, 304, 6800, 'initial render phase')
    render(1, 0, 2, 'warm', 1)
    render(2, 0, 3, 'warm', 2)
    add(4, struct.pack('<H', 17), None, 'initial stack INFO17')
    for frame in range(1, (main_hold if main_hold is not None else frames) + 1):
        render(frame + 2, frame * 4, frame * 5 + 3, 'main', frame)
    if main_hold is not None:
        return output
    add(4, struct.pack('<H', 17), None, 'final stack INFO17', 'final')
    for key, data in reference.items():
        data = bytes.fromhex(data)
        for offset in range(0, len(data), 2):
            word(int(key), offset, int.from_bytes(data[offset:offset + 2], 'little'),
                 'final state ' + key + ':' + str(offset), 'final')
    if coverage_frames:
        # The frozen guest uses three byte-addressed READ16 calls. The pinned
        # protocol permits offset13; it does not impose word alignment.
        word(50303, 2, None, 'player bitmap anchor', 'coverage setup')
        word(50303, 8, None, 'player matrix anchor', 'coverage setup')
        word(50303, 13, None, 'player x anchor', 'coverage setup')
        for frame in range(coverage_frames):
            render(frames + 3 + frame, frames * 4, frames * 5 + 4 + frame,
                   'coverage', frame)
    if not coverage_hold:
        run(16, 'teardown')
        add(3, struct.pack('<H', handle), 0, 'UNLOAD', 'teardown')
    return output


def raw_requests(tx, expected):
    """Find only validated monotonic protocol packets, skipping asset bytes.

    Requiring the entire expected header/operation/fields makes an embedded
    accidental selector insufficient. Each next token must occur exactly once
    after the preceding packet; ambiguity is a failure, not a chosen match.
    """
    cursor, output = 0, []
    for row in expected:
        matches = []
        start = tx.find(row['wire'], cursor)
        while start >= 0:
            matches.append(start)
            start = tx.find(row['wire'], start + 1)
        assert len(matches) == 1, ('Request occurrence', row['token'], row['label'], matches)
        start = matches[0]
        stop = start + len(row['wire'])
        output.append(dict(row, start=start, stop=stop))
        cursor = stop
    return output


def replies_match(packets, expected):
    assert len(packets) == len(expected), ('Native reply count', len(packets), len(expected))
    for raw, row in zip(packets, expected):
        magic, version, kind, token, value = struct.unpack('<4sBBHH', raw)
        assert (magic, version, kind, token) == (b'VDPL', 1, row['kind'], row['token']), row['label']
        if row['value'] is not None:
            assert value == row['value'], (row['token'], row['label'], value, row['value'])
        if row['label'] == 'player bitmap anchor':
            assert value & 255 == 0 and value >> 8 <= 4
        elif row['label'] == 'player matrix anchor':
            assert value in (63984, 65535)
        row['response_value'] = value


def backend(directory):
    stats = load(directory / 'stats.json')
    assert stats['failed'] is False and stats['keys'] == 0
    assert not any(stats[n] for n in ('unhandled', 'unregistered', 'unmapped'))
    tx, rx, delivered = (read(directory / name) for name in
                         ('mos-to-vdp.bin', 'vdp-to-mos.bin', 'vdp-to-mos-delivered.bin'))
    assert rx == delivered
    assert (stats['uart_rx'], stats['uart_tx'], stats['uart_delivered']) == (len(tx), len(rx), len(delivered))
    packets, generic = native_packets(rx)
    return tx, packets, generic


def identities(value):
    return {line.split('  ', 1)[1]: line.split('  ', 1)[0]
            for line in value.strip().splitlines() if line.strip()}


def fixture_inputs(info, profile):
    fixture = HERE / info['directory']
    found = profile['input_sha256']
    for name, wanted in info['files'].items():
        assert sha(read(fixture / name)) == wanted, (fixture, name)
        assert found['sdcard/rally25/' + name] == wanted, (name, 'staged identity')
    frozen_guest = load(HERE / 'GUEST-BUILD.json')['files']['probe.bin']
    assert info['files']['probe.bin'] == frozen_guest
    assert profile['stopped'] and profile['sound_driver'] == 'dummy'
    assert found['esp32-firmware.bin'] == FIRMWARE
    config = read(fixture / 'config.bin')
    magic, schema, frames, module_bytes, flags, reserved = struct.unpack('<4sHHIHH', config)
    assert (magic, schema, flags, reserved) == (b'R28F', 1, 0, 0)
    meta = load(fixture / 'expected.json')
    assert meta['frames'] == frames and meta['module_bytes'] == module_bytes
    module_wire = read(fixture / 'module.vdu')
    prefix = b'\x17\0\xa0' + struct.pack('<H', 50305)
    assert module_wire[:14] == prefix + b'\2' + prefix + b'\0' + struct.pack('<H', module_bytes)
    image = module_wire[14:]
    assert len(image) == module_bytes and sha(image) == info['module_sha256'] == meta['module_sha256']
    assert image[:4] == b'VDPL' and struct.unpack_from('<I', image, 8)[0] == len(image)
    assert sha(read(fixture / 'motion.bin')) == '5ca7f145e3160618dc1708b3624741dcd1ccb7fc61db41fda8482881b50ed3e9'
    return fixture, meta, {name: found[name] for name in RUNTIME}


def selected_evidence(relative):
    """Resolve a receipt's relative raw directory without following symlinks."""
    assert isinstance(relative, str) and relative
    path = Path(relative)
    assert not path.is_absolute() and path.parts[0] == 'evidence', relative
    assert '..' not in path.parts and str(path) == relative, relative
    current = HERE
    for part in path.parts:
        current = current / part
        assert not current.is_symlink(), ('Symlink in evidence path', relative)
    assert current.is_dir() and current.resolve().is_relative_to((HERE / 'evidence').resolve()), relative
    return current


def locate(campaign, case, entry=None):
    if entry is not None and 'evidence_directory' in entry:
        return selected_evidence(entry['evidence_directory'])
    paths = [HERE / 'evidence' / campaign / case, HERE / 'captures/evidence' / campaign / case]
    paths = [p for p in paths if p.exists()]
    assert len(paths) == 1, ('Unique raw directory', campaign, case, paths)
    return paths[0]


def ppm(path, scene=False):
    data = read(path)
    parts = data.split(b'\n', 3)
    assert parts[:3] == [b'P6', b'320 240', b'255']
    assert len(parts[3]) == 320 * 240 * 3
    colours = len({parts[3][i:i + 3] for i in range(0, len(parts[3]), 3)})
    assert colours > (8 if scene else 1), ('Blank capture', path, colours)
    return dict(sha256=sha(data), colours=colours)


def session(name, require_complete=True, allow_external_boost_tail=False):
    data = load(HERE / ('SESSION-' + name + '.json'))
    assert data['boost_restored']
    if require_complete:
        assert data['error'] is None
    assert data['video_driver'] == data['audio_driver'] == 'dummy'
    assert data['thermal_stop_celsius'] == 95 and data['boost_during_session'] == '0'
    assert not data['owned_emulator_processes_after'] and data['original_boost'] == data['final_boost']
    assert data['max_temperature_celsius'] < 95
    assert data['samples']
    external_boost_tail = None
    if allow_external_boost_tail:
        assert not require_complete and data['error'] is not None
        assert data['error'].startswith('SessionAbort(')
        assert data['monitor_abort_reason'] == 'Boost changed or thermal stop reached'
        assert len(data['samples']) > 1
        assert all(s['boost'] == '0' for s in data['samples'][:-1])
        assert data['samples'][-1]['boost'] == '1'
        assert all(max(s['temperatures_celsius'].values()) < 95 for s in data['samples'])
        assert all(a['elapsed_seconds'] < b['elapsed_seconds']
                   for a, b in zip(data['samples'], data['samples'][1:]))
        external_boost_tail = dict(first_changed_boost_sample_seconds=data['samples'][-1]['elapsed_seconds'],
                                   preceding_samples_all_boost_zero=True,
                                   sole_final_sample_boost='1', thermal_stop_not_reached=True,
                                   successful_prefix_requires_separate_serial_case_validation=True)
    else:
        assert all(s['boost'] == '0' for s in data['samples'])
    return dict(name=name, campaigns=data['campaigns'], completed=data['completed'],
                host_boot_id=data['host_boot_id'], original_boost=data['original_boost'],
                final_boost=data['final_boost'], boost_restored=True,
                maximum_celsius=data['max_temperature_celsius'], thermal_stop_celsius=95,
                video_driver='dummy', audio_driver='dummy', owned_emulators_stopped=True,
                source_session_error=data['error'], whole_session_complete=data['error'] is None,
                whole_session_required_complete=require_complete,
                external_boost_abort_tail=external_boost_tail)


def completed_run(campaign, case, info, profile, coverage=False, campaign_entry=None):
    directory = locate(campaign, case, campaign_entry)
    fixture, meta, runtime = fixture_inputs(info, profile)
    frames = meta['frames']
    result = load(directory / 'result.json')
    assert not (directory / 'failure.txt').exists()
    assert result['valid'] and result['frames'] == frames and result['physics_ticks'] == frames * 4
    assert result['warm_frames'] == 2 and result['request'] == frames + 2 and result['generation'] == 5 * frames + 3
    assert result['race_view'] and not result['damage_enabled']
    assert all(result[k] for k in ('timer_restored', 'unloaded', 'post_swap_fenced', 'clean_text_exit'))
    tx, packets, generic = backend(directory)
    assert packets
    first = struct.unpack('<4sBBHH', packets[0])
    assert first[:4] == (b'VDPL', 1, 2, 1) and first[4]
    handle = first[4]
    reference = load(HERE / ('EXPECTED-FINAL-' + str(frames) + '.json'))
    schedule = specs(frames, meta['module_bytes'], handle, reference,
                     coverage_frames=272 if coverage else 0)
    replies_match(packets, schedule)
    locations = raw_requests(tx, schedule)
    transcript = read(directory / 'replies.bin')
    assert transcript == b''.join(packets)
    wanted_count = 6 * frames + 224 + (3 + 272 * 6 if coverage else 0)
    assert len(packets) == result['retained_replies'] == wanted_count
    assert len(transcript) == result['transcript_bytes'] == 10 * wanted_count <= 100000
    before = next(r for r in locations if r['label'] == 'initial stack INFO17')
    final_fence = next(r for r in locations if r['phase'] == 'main' and r['frame'] == frames and r['label'] == 'post-swap generation fence')
    timed = tx[before['stop']:final_fence['stop']]
    assert len(timed) == result['timed_wire_bytes'], ('Complete timed UART length', case, len(timed), result['timed_wire_bytes'])
    # All timed bytes must be framed by the actual INFO18 and the last swap
    # fence; no parser-derived SEND approximation is used.
    frame_streams = []
    start = before['stop']
    for frame in range(1, frames + 1):
        fence = next(r for r in locations if r['phase'] == 'main' and r['frame'] == frame and r['label'] == 'post-swap generation fence')
        part = tx[start:fence['stop']]
        assert part.count(b'\x17\0\xc3') == 1
        assert part.count(b'\x17\0\xa0\x0d\0\1') == 4
        frame_streams.append(part)
        start = fence['stop']
    assert b''.join(frame_streams) == timed
    state = read(directory / 'state.bin')
    expected_state = b''.join(bytes.fromhex(reference[str(b['id'])]) for b in meta['state_buffers'])
    assert state == expected_state
    final_reads = [r for r in locations if r['label'].startswith('final state ')]
    assert len(final_reads) == 203
    reconstructed = {key:bytearray() for key in reference}
    for row in final_reads:
        buffer, offset = struct.unpack('<HI', row['fields'])
        assert len(reconstructed[str(buffer)]) == offset
        reconstructed[str(buffer)] += struct.pack('<H', row['response_value'])
    assert {key:bytes(value).hex() for key,value in reconstructed.items()} == reference
    samples = []
    for name in ('ticks.bin', 'prt.bin'):
        data = read(directory / name)
        assert len(data) == 4 * (frames + 1)
        values = list(struct.unpack('<' + 'I' * (frames + 1), data))
        deltas = [(b-a) & 0xffffff for a,b in zip(values, values[1:])]
        elapsed = (values[-1]-values[0]) & 0xffffff
        assert elapsed > 0 and sum(deltas) == elapsed
        samples.append((elapsed, deltas))
    (mos, md), (prt, pd) = samples
    assert (mos, prt) == (result['elapsed_mos_ticks'], result['prt_ticks'])
    stages = list(csv.DictReader(read(directory / 'stages.csv').decode().splitlines()))
    assert len(stages) == 1 and int(stages[0]['wire_bytes']) == len(timed)
    assert int(stages[0]['loop_prt_ms']) == prt
    player = list(csv.DictReader(read(directory / 'player.csv').decode().splitlines()))
    assert len(player) == 1
    root = bytes.fromhex(reference['1'])
    assert int(player[0]['station']) == struct.unpack_from('<I', root, 198)[0]
    assert int(player[0]['phase']) == struct.unpack_from('<H', root, 304)[0]
    assert int(player[0]['rules_ticks']) == frames * 4
    assert int(player[0]['remaining']) == 85 * 120 - 4 * frames
    assert int(player[0]['lateral']) == int(player[0]['steering']) == 0
    assert result['footer_calls'] == result['input_polls'] == frames
    assert result['hud_bytes'] and result['sky_repair_calls']
    if frames == 900:
        assert {key:result[key] for key in ('scroll_calls','repaint_calls','sky_repair_calls','audio_changes','finish_frames')} == dict(scroll_calls=382,repaint_calls=382,sky_repair_calls=900,audio_changes=24,finish_frames=16)
        assert int(player[0]['score']) == 756 and int(player[0]['rank']) == 6 and int(player[0]['laps']) == 0
    receipt = load(directory / 'run.json')
    assert receipt['error'] is None and receipt['process_exit'] == 0
    assert receipt['video_driver'] == receipt['audio_driver'] == 'dummy'
    assert identities(receipt['runtime_identities']) == profile['input_sha256']
    # Actual large setup streams must follow successful early module admission.
    assert tx.count(read(fixture / 'module.vdu')) == 1
    for name in ('assets.vdu','artwork.vdu','presentation.vdu','common.vdu','native.vdu'):
        payload = read(fixture / name)
        assert tx.count(payload) == 1 and tx.index(payload) >= locations[0]['stop'], name
    after_unload = tx[locations[-1]['stop']:]
    assert MODE8 in after_unload
    done = after_unload.find(b'RALLY-28 FULL RACE DONE: logs saved.')
    assert done > after_unload.find(MODE8) and after_unload.find(b'/rally25 *', done) > done
    assert b'VDPL UNLOAD status=0' in read(directory / 'esp32-uart0.txt')
    coverage_result = None
    if coverage:
        coverage_result = load(directory / 'coverage.json')
        assert coverage_result == dict(schema=1,separate_from_throughput=True,frames=272,explosion_frames=150,blink_hidden_frames=60,recovery_transitions=1,camera_frozen=True,native_physics_ticks=0,healthy=True)
    row = dict(campaign=campaign, case=case,
               evidence_directory=str(directory.relative_to(HERE)),
               selected_attempt=campaign_entry.get('selected_attempt') if campaign_entry else None,
               frames=frames, native_physics_ticks=frames*4,
               raw_native_replies=len(packets), generic_return_packets=generic,
               every_request_response_exact=True, retained_equals_all_raw_native=True,
               timed_uart_bytes=len(timed), timed_uart_sha256=sha(timed),
               frame_uart_min_max=[min(map(len,frame_streams)),max(map(len,frame_streams))],
               timed_window='After outgoing INFO token18 through outgoing final post-swap fence, inclusive; guest timestamps follow completed replies',
               final_state_sha256=sha(state), full_final_root_and_arrays_exact=True,
               raw_final_state_reads=203, nominal_mos_units=mos, nominal_mos_fps=frames*120/mos,
               nominal_prt_ticks=prt, nominal_prt_fps=frames*1000/prt,
               zero_mos_interval_frames=[i for i,d in enumerate(md,1) if not d],
               zero_prt_interval_frames=[i for i,d in enumerate(pd,1) if not d],
               stack_info_before=before['response_value'],
               stack_info_after=next(r['response_value'] for r in locations if r['label']=='final stack INFO17'),
               timer_vector_restore_guest_check=True, native_stop_unload_zero=True,
               mode8_MOS_prompt_after_cleanup=True, backend_zero_errors=True,
               final_MOS_ppm=ppm(directory/'final.ppm'), coverage=coverage_result,
               timing_excluded=coverage)
    return row, timed, frame_streams, runtime


def excluded_raw(directory):
    """Retain failed evidence identities without converting it into timing data."""
    hashes = {path.name: sha(read(path)) for path in sorted(directory.iterdir()) if path.is_file()}
    output = dict(evidence_directory=str(directory.relative_to(HERE)),
                  raw_file_sha256=hashes, qualified_for_timing=False)
    for name, field in (('mos-to-vdp.bin', 'outbound_bytes'), ('vdp-to-mos.bin', 'inbound_bytes')):
        if (directory / name).exists():
            output[field] = len(read(directory / name))
    if (directory / 'vdp-to-mos.bin').exists():
        try:
            packets, generic = native_packets(read(directory / 'vdp-to-mos.bin'))
            decoded = [dict(zip(('kind', 'token', 'value'), struct.unpack('<4sBBHH', packet)[2:]))
                       for packet in packets]
            output.update(multiplexed_packets_complete=True, generic_return_packets=generic,
                          native_reply_count=len(packets), last_native_reply=decoded[-1] if decoded else None,
                          native_error_callbacks=[row for row in decoded if row['kind'] == 5])
        except AssertionError as error:
            output.update(multiplexed_packets_complete=False, prefix_decode_error=repr(error))
    if (directory / 'run.json').exists():
        output['original_error'] = load(directory / 'run.json').get('error')
    return output


def startup_attempt(directory, info, profile, entry):
    """Independently establish a retryable failure before the timed window."""
    fixture, meta, runtime = fixture_inputs(info, profile)
    assert entry['passed'] is False and entry['error'].startswith('TimeoutError(')
    assert not entry.get('session_abort') and not entry.get('interrupted')
    assert not (directory / 'failure.txt').exists() and not (directory / 'result.json').exists()
    receipt = load(directory / 'run.json')
    assert receipt['error'] == entry['error'] and receipt['process_exit'] == 0
    assert receipt['video_driver'] == receipt['audio_driver'] == 'dummy'
    assert identities(receipt['runtime_identities']) == profile['input_sha256']
    tx, packets, generic = backend(directory)
    assert len(packets) < 18, ('A timed-window reply occurred in a failed startup attempt', directory)
    handle = struct.unpack('<4sBBHH', packets[0])[-1] if packets else 1
    assert handle > 0
    reference = load(HERE / ('EXPECTED-FINAL-' + str(meta['frames']) + '.json'))
    schedule = specs(meta['frames'], meta['module_bytes'], handle, reference)
    prefix = schedule[:len(packets)]
    replies_match(packets, prefix)
    requests = raw_requests(tx, prefix)
    # The next request may be awaiting a callback, including initial INFO18.
    # No completed callback may reach INFO18 and no main-frame request may exist.
    pending = schedule[len(packets)]
    cursor = requests[-1]['stop'] if requests else 0
    pending_at = tx.find(pending['wire'], cursor)
    if pending_at >= 0:
        assert tx.find(pending['wire'], pending_at + 1) < 0
    assert all(tx.find(row['wire'], cursor) < 0 for row in schedule[18:24]), 'Main race requests in failed startup'
    reported = entry['retry_classification']
    assert reported['retry_allowed'] and not reported['main_window_started']
    assert reported['initial_stack_info_token'] == 18
    assert reported['outbound_bytes'] == len(tx)
    assert reported['inbound_bytes'] == len(read(directory / 'vdp-to-mos.bin'))
    output = excluded_raw(directory)
    output.update(valid_startup_callback_prefix=True, native_reply_count=len(packets),
                  generic_return_packets=generic, callback_tokens=[row['token'] for row in prefix],
                  pending_request_token=pending['token'] if pending_at >= 0 else None,
                  initial_INFO18_reply_absent=True, timed_window_not_started=True,
                  no_main_frame_request=True, exact_frozen_inputs=True,
                  no_guest_or_backend_error=True)
    return output, runtime


def campaign_attempts(campaign, registry, profiles, receipt, *, selected_cases=None,
                      allow_interrupted_tail=False):
    """Audit original and retry profiles, every failure, and the selected winner."""
    path = HERE / ('ATTEMPTS-' + campaign + '.json')
    if not path.exists():
        assert not any('evidence_directory' in entry for entry in receipt.values()), 'Missing retry registry'
        return None, []
    data = load(path)
    assert data['schema'] == 1 and data['campaign'] == campaign
    assert data['max_attempts_per_case'] == 3
    ordered = data['ordered_cases']
    assert len(ordered) == len(set(ordered)) and set(ordered) <= set(registry)
    assert list(profiles) == ordered
    assert list(receipt) == ordered[:len(receipt)]
    if selected_cases is None:
        assert ordered == list(receipt)
    else:
        assert list(receipt) == list(selected_cases)
    assert data['initial_profiles_receipt'] == 'PROFILES-' + campaign + '-INITIAL.json'
    initial_path = HERE / data['initial_profiles_receipt']
    assert sha(read(initial_path)) == data['initial_profiles_sha256']
    initial = load(initial_path)
    assert list(initial) == ordered and list(data['selected']) == list(receipt)
    assert list(data['attempts']) == ordered[:len(data['attempts'])]
    tail_cases = list(data['attempts'])[len(receipt):]
    assert set(data['selected']) == set(receipt)
    if allow_interrupted_tail:
        assert len(tail_cases) == 1 and len(receipt) < len(ordered)
    else:
        assert not tail_cases and len(receipt) == len(ordered)
    output, runtimes, used_profiles = {}, [], set()
    for case, winner in receipt.items():
        attempts = data['attempts'][case]
        assert 1 <= len(attempts) <= 3
        assert winner['attempts'] == attempts and winner['selected_attempt'] == len(attempts)
        assert winner['evidence_directory'] == profiles[case]['evidence_directory']
        assert profiles[case]['selected_attempt'] == winner['selected_attempt']
        selected = data['selected'][case]
        assert selected == {key: winner[key] for key in
            ('attempt', 'profile', 'profile_campaign', 'evidence_directory')}
        winning_directory = selected_evidence(winner['evidence_directory'])
        winning_tx = read(winning_directory / 'mos-to-vdp.bin')
        rows = []
        for number, entry in enumerate(attempts, 1):
            assert entry['attempt'] == number and entry['input_hashes_preserved'] and entry['boost_after'] == '0'
            assert entry['profile'] not in used_profiles
            used_profiles.add(entry['profile'])
            assert entry['profiles_receipt'] == 'PROFILES-' + entry['profile_campaign'] + '.json'
            if number == 1:
                assert entry['profile_campaign'] == campaign
                attempt_profile = initial[case]
            else:
                assert entry['profile_campaign'].startswith(campaign + 'r')
                attempt_profiles = load(HERE / entry['profiles_receipt'])
                assert list(attempt_profiles) == [case]
                attempt_profile = attempt_profiles[case]
            assert attempt_profile['profile'] == entry['profile']
            directory = selected_evidence(entry['evidence_directory'])
            assert directory == HERE / 'evidence' / campaign / (case + '-attempt' + str(number))
            assert load(directory / 'ATTEMPT.json') == entry
            if number < len(attempts):
                row, runtime = startup_attempt(directory, registry[case], attempt_profile, entry)
                failed_tx = read(directory / 'mos-to-vdp.bin')
                winning_prefix = winning_tx[:len(failed_tx)]
                assert len(failed_tx) < len(winning_tx)
                assert failed_tx == winning_prefix, ('Failed startup bytes differ from selected winner',
                                                     campaign, case, number, len(failed_tx))
                row.update(outbound_exact_prefix_of_selected_winner=True,
                           compared_startup_bytes=len(failed_tx),
                           failed_startup_sha256=sha(failed_tx),
                           winning_startup_prefix_sha256=sha(winning_prefix),
                           winning_complete_outbound_sha256=sha(winning_tx),
                           winning_evidence_directory=winner['evidence_directory'])
                runtimes.append(runtime)
                rows.append(dict(attempt=number, profile=entry['profile'], selected=False,
                                 original_error=entry['error'], independent_startup_check=row))
            else:
                assert entry['passed'] and entry['profile'] == profiles[case]['profile']
                actual = load(directory / 'run.json')
                assert actual['error'] is None and actual['process_exit'] == entry['process_exit'] == 0
                assert actual['backend_stats'] == entry['backend_stats'] and actual['result'] == entry['result']
                rows.append(dict(attempt=number, profile=entry['profile'], selected=True,
                                 evidence_directory=entry['evidence_directory']))
        output[case] = rows
    interrupted_tail = None
    if tail_cases:
        case = tail_cases[0]
        tail = data['attempts'][case]
        assert len(tail) == 1
        entry = tail[0]
        assert entry['attempt'] == 1 and entry['passed'] is False and entry['session_abort'] is True
        assert entry['error'] == 'Boost changed; retries prohibited' and entry['boost_after'] == '1'
        assert entry['input_hashes_preserved'] and entry['profile_campaign'] == campaign
        assert entry['profiles_receipt'] == 'PROFILES-' + campaign + '.json'
        assert entry['profile'] == initial[case]['profile'] and entry['profile'] not in used_profiles
        directory = selected_evidence(entry['evidence_directory'])
        assert directory == HERE / 'evidence' / campaign / (case + '-attempt1')
        assert load(directory / 'ATTEMPT.json') == entry
        assert not (directory / 'result.json').exists()
        actual = load(directory / 'run.json')
        assert actual['error'].startswith('SessionAbort(')
        assert identities(actual['runtime_identities']) == initial[case]['input_sha256']
        assert actual['video_driver'] == actual['audio_driver'] == 'dummy'
        _, _, tail_runtime = fixture_inputs(registry[case], initial[case])
        runtimes.append(tail_runtime)
        interrupted_tail = dict(case=case, attempt=1, profile=entry['profile'],
                                source_error=entry['error'], boost_after='1',
                                follows_all_selected_cases_in_serial_source_order=True,
                                excluded_from_timing=True, raw=excluded_raw(directory))
    return dict(campaign=campaign, registry=path.name,
                original_ordered_cases=ordered, selected_cases=list(receipt),
                original_campaign_complete=len(receipt) == len(ordered),
                interrupted_tail=interrupted_tail,
                bounded_maximum_attempts=3, attempts=output,
                every_selected_profile_fresh_and_unique=True,
                all_failed_attempts_excluded_from_timing=True), runtimes


def capture_run(campaign, case, info, profile):
    directory = locate(campaign, case)
    fixture, meta, runtime = fixture_inputs(info, profile)
    frames, capture = meta['frames'], meta['capture']
    stage, frame = capture['stage'], capture['frame']
    assert read(fixture/'capture.req') == struct.pack('<HH',stage,frame)
    assert meta['timing_excluded'] and meta['deliberate_stop_during_hold']
    ready = load(directory/'capture.ready')
    assert ready == meta['expected_capture_ready']
    tx, packets, generic = backend(directory)
    assert packets
    first = struct.unpack('<4sBBHH',packets[0])
    assert first[:4] == (b'VDPL',1,2,1) and first[4]
    reference = load(HERE/('EXPECTED-FINAL-'+str(frames)+'.json'))
    schedule = specs(frames,meta['module_bytes'],first[4],reference,
                     main_hold=frame if stage==0 else None,
                     coverage_frames=frame+1 if stage==1 else 0,
                     coverage_hold=stage==1)
    replies_match(packets,schedule)
    locations = raw_requests(tx,schedule)
    assert locations[-1]['label']=='post-swap generation fence'
    assert locations[-1]['response_value']==ready['generation']
    assert locations[-1]['stop']==len(tx), 'No VDP traffic is permitted during the capture hold'
    assert not any(r['operation']==3 for r in schedule)
    assert b'RALLY-28 FULL RACE DONE' not in tx
    assert b'VDPL UNLOAD status=0' not in read(directory/'esp32-uart0.txt')
    receipt = load(directory/'capture.json')
    assert receipt.get('error') is None
    assert receipt.get('timing_excluded') is True
    assert receipt.get('intentional_interruption_during_hold') is True
    assert receipt.get('game_cleanup_validated') is False
    if 'runtime_identities' in receipt:
        assert identities(receipt['runtime_identities'])==profile['input_sha256']
    else:
        raise AssertionError('Capture receipt must preserve actual runtime identities')
    return dict(campaign=campaign,case=case,stage=stage,frame=frame,
                native_physics_ticks=ready['physics_ticks'],generation=ready['generation'],
                raw_native_replies=len(packets),generic_return_packets=generic,
                all_raw_requests_responses_and_fences_exact=True,
                no_VDP_traffic_after_capture_ready=True,timing_excluded=True,
                deliberate_interruption=True,cleanup_not_claimed=True,
                scene_ppm=ppm(directory/'final.ppm',scene=True)),runtime


def comparison_runs(args, registry, order):
    """Audit logical orders while retaining each original campaign and guard."""
    selection = None
    source_sessions = None
    if args.comparison_selection:
        assert not args.campaigns
        assert Path(args.comparison_selection).name == args.comparison_selection
        selection = load(HERE / args.comparison_selection)
        assert selection['schema'] == 1
        plans = [selection['forward'], selection['reverse']]
        source_sessions = selection['source_sessions']
        for name, wanted_hash in selection['source_receipts'].items():
            assert Path(name).name == name and name.endswith('.json')
            assert not (HERE / name).is_symlink()
            assert sha(read(HERE / name)) == wanted_hash, ('Selected source receipt changed', name)
    else:
        assert len(args.campaigns) == 2 and args.sessions
        plans = [[dict(campaign=campaign, case=case) for case in cases]
                 for campaign, cases in zip(args.campaigns, (order, list(reversed(order))))]
    assert [row['case'] for row in plans[0]] == order
    assert [row['case'] for row in plans[1]] == list(reversed(order))
    assert len({(row['campaign'], row['case']) for plan in plans for row in plan}) == 34
    groups = {}
    for plan in plans:
        for row in plan:
            assert set(row) == {'campaign', 'case'} and row['campaign'].isalnum()
            groups.setdefault(row['campaign'], []).append(row['case'])
    if source_sessions is not None:
        assert set(source_sessions) == set(groups)
        names = list(dict.fromkeys(source_sessions.values()))
        assert not args.sessions or args.sessions == names
    else:
        names = args.sessions
    rows, streams, all_runtime, audits, cache = [], [], [], [], {}
    for campaign, cases in groups.items():
        profiles = load(HERE / ('PROFILES-' + campaign + '.json'))
        receipt = load(HERE / ('CAMPAIGN-' + campaign + '.json'))
        assert list(receipt) == cases
        partial = len(receipt) < len(profiles)
        assert not partial or selection is not None
        audit, runtimes = campaign_attempts(campaign, registry, profiles, receipt,
            selected_cases=cases if selection is not None else None,
            allow_interrupted_tail=partial)
        if audit is not None:
            audits.append(audit)
        all_runtime.extend(runtimes)
        cache[campaign] = (profiles, receipt)
        if selection is not None:
            required = {'CAMPAIGN-' + campaign + '.json', 'PROFILES-' + campaign + '.json',
                        'ATTEMPTS-' + campaign + '.json'}
            attempts = load(HERE / ('ATTEMPTS-' + campaign + '.json'))
            required.add(attempts['initial_profiles_receipt'])
            required.update(entry['profiles_receipt'] for attempts in attempts['attempts'].values()
                            for entry in attempts)
            assert required <= set(selection['source_receipts'])
    for direction, plan in zip(('forward', 'reverse'), plans):
        for index, chosen in enumerate(plan, 1):
            campaign, case = chosen['campaign'], chosen['case']
            profiles, receipt = cache[campaign]
            assert receipt[case]['passed'] and receipt[case]['input_hashes_preserved']
            if selection is not None:
                assert receipt[case]['boost_after'] == '0'
            row, stream, _, runtime = completed_run(campaign, case, registry[case], profiles[case],
                                                   campaign_entry=receipt[case])
            assert row['frames'] == 900
            row.update(logical_order=direction, logical_index=index)
            rows.append(row); streams.append(stream); all_runtime.append(runtime)
    assert len(rows) == 34 and all(stream == streams[0] for stream in streams)
    guards, retry_sessions = [], []
    for name in names:
        original = load(HERE / ('SESSION-' + name + '.json'))
        incomplete = original['error'] is not None
        assert not incomplete or selection is not None
        guard = session(name, require_complete=not incomplete, allow_external_boost_tail=incomplete)
        members = [campaign for campaign in groups
                   if ((source_sessions is None and campaign in guard['campaigns']) or
                       (source_sessions is not None and source_sessions[campaign] == name))]
        assert members == guard['campaigns']
        member_audits = [audit for audit in audits if audit['campaign'] in members]
        if incomplete:
            tails = [audit for audit in member_audits if audit['interrupted_tail'] is not None]
            assert len(tails) == 1 and tails[0]['campaign'] == members[-1]
            assert guard['completed'] == ['campaign:' + campaign for campaign in members[:-1]]
            assert all(audit['original_campaign_complete'] for audit in member_audits[:-1])
            guard['accepted_serial_prefix'] = dict(
                completed_runs=sum(len(groups[campaign]) for campaign in members),
                selected_cases_each_record_boost_after_zero=True,
                excluded_interrupted_case=tails[0]['interrupted_tail']['case'],
                later_boost_change_does_not_reclassify_prior_successes=True,
                evidence_limit='Ordered pinned controller and per-case boost-after reads, with two-second monitor samples; no continuous per-cycle boost trace')
        else:
            assert all('campaign:' + campaign in guard['completed'] for campaign in members)
        if selection is not None:
            assert {'SESSION-' + name + '.json', 'RETRY-SESSION-' + name + '.json'} <= set(selection['source_receipts'])
        retry = load(HERE / ('RETRY-SESSION-' + name + '.json'))
        assert retry['session'] == name and retry['campaigns'] == members
        assert retry['original_guard_unchanged'] and retry['thermal_stop_celsius'] == 95
        assert retry['original_run_one_reused'] and retry['max_attempts_per_case'] == 3
        assert retry['automatic_retry_only_before_info_token18'] and retry['sources_unchanged']
        for relative, wanted_hash in retry['source_pins'].items():
            assert Path(relative).name == relative and sha(read(HERE / relative)) == wanted_hash
        if 'derivation' in retry:
            assert sha(read(HERE / retry['derivation']['source'])) == retry['derivation']['sha256']
        owned = set(retry['dynamic_owned_profiles'])
        for audit in member_audits:
            assert all(row['profile'] in owned for attempts in audit['attempts'].values() for row in attempts)
            if audit['interrupted_tail'] is not None:
                assert audit['interrupted_tail']['profile'] in owned
        guards.append(guard)
        retry_sessions.append(dict(session=name, source_pins=retry['source_pins'],
            derivation=retry.get('derivation'), every_attempt_in_guard_ownership=True,
            original_95_degree_guard_preserved=True))
    assert len({guard['host_boot_id'] for guard in guards}) == 1
    return rows, streams, all_runtime, audits, guards, retry_sessions, selection, set(groups)


def main(args):
    assert not (HERE/'RAW-AUDIT.json').exists(), 'Preserve prior audit results'
    registry = load(HERE/'FIXTURES.json')
    order = load(HERE/'VARIANTS.json')['order']
    assert len(order)==17 and set(registry)==set(order)
    prior = load(HERE.parent/'incremental/static-drawing/PROFILES-staticab01.json')['control']['input_sha256']
    expected_runtime = {name:prior[name] for name in RUNTIME}
    rows,streams,all_runtime,attempt_audits,sessions,retry_sessions,comparison_selection,comparison_campaigns = comparison_runs(args,registry,order)
    captures=[]
    capture_selection=None
    selection_sessions=[]
    selection_excluded=[]
    assert not (args.capture_campaign and args.capture_selection)
    if args.capture_selection:
        capture_selection=load(HERE/args.capture_selection)
        capture_registry=load(HERE/'CAPTURE-FIXTURES.json')
        selected=capture_selection['selected']
        assert set(selected)==set(capture_registry) and len(selected)==5
        for campaign,pinned in capture_selection.get('source_receipts',{}).items():
            assert sha(read(HERE/('CAPTURE-CAMPAIGN-'+campaign+'.json')))==pinned['campaign_sha256']
            assert sha(read(HERE/('PROFILES-'+campaign+'.json')))==pinned['profiles_sha256']
            assert sha(read(HERE/('SESSION-'+pinned['session']+'.json')))==pinned['session_sha256']
        for case,chosen in selected.items():
            assert chosen['case']==case
            campaign=chosen['campaign']
            assert chosen['profile_receipt']=='PROFILES-'+campaign+'.json'
            assert chosen['campaign_receipt']=='CAPTURE-CAMPAIGN-'+campaign+'.json'
            assert chosen['session_receipt']=='SESSION-'+chosen['session']+'.json'
            profiles=load(HERE/chosen['profile_receipt'])
            campaign_receipt=load(HERE/chosen['campaign_receipt'])
            guard=session(chosen['session'],require_complete=False)
            assert campaign in guard['campaigns']
            assert guard['source_session_error']==chosen['source_session_error']
            assert profiles[case]['profile']==chosen['profile']
            assert campaign_receipt[case]['error'] is None and campaign_receipt[case]['input_hashes_preserved']
            directory=locate(campaign,case)
            assert (HERE/chosen['evidence_directory']).resolve()==directory.resolve()
            receipt=load(directory/'capture.json')
            assert sha(receipt['runtime_identities'].encode())==chosen['runtime_identities_sha256']
            row,runtime=capture_run(campaign,case,capture_registry[case],profiles[case])
            row['guard_session']=chosen['session']
            row['source_session_error']=guard['source_session_error']
            captures.append(row);all_runtime.append(runtime)
            if not any(s['name']==guard['name'] for s in selection_sessions):
                selection_sessions.append(guard)
        for attempt in capture_selection.get('excluded_attempts',[]):
            directory=locate(attempt['campaign'],attempt['case'])
            original=load(directory/'capture.json')
            assert original['error']==attempt['error']
            raw_hashes={p.name:sha(read(p)) for p in sorted(directory.iterdir()) if p.is_file()}
            selection_excluded.append(dict(attempt,raw_file_sha256=raw_hashes,
                                           qualified_for_timing=False,selected_for_visual_evidence=False))
    if args.capture_campaign:
        capture_registry=load(HERE/'CAPTURE-FIXTURES.json')
        profiles=load(HERE/('PROFILES-'+args.capture_campaign+'.json'))
        receipt=load(HERE/('CAPTURE-CAMPAIGN-'+args.capture_campaign+'.json'))
        assert set(profiles)==set(capture_registry) and len(capture_registry)==5
        for case,info in capture_registry.items():
            row,runtime=capture_run(args.capture_campaign,case,info,profiles[case])
            assert receipt[case]['error'] is None and receipt[case]['input_hashes_preserved']
            captures.append(row);all_runtime.append(runtime)
    coverage=[]
    if args.coverage_campaign:
        coverage_registry=load(HERE/'COVERAGE-FIXTURES.json')
        profiles=load(HERE/('PROFILES-'+args.coverage_campaign+'.json'))
        receipt=load(HERE/('CAMPAIGN-'+args.coverage_campaign+'.json'))
        assert set(profiles)==set(coverage_registry)=={'coverage60'}
        row,stream,_,runtime=completed_run(args.coverage_campaign,'coverage60',coverage_registry['coverage60'],profiles['coverage60'],coverage=True,campaign_entry=receipt['coverage60'])
        assert receipt['coverage60']['passed'] and receipt['coverage60']['input_hashes_preserved']
        coverage.append(row);all_runtime.append(runtime)
    capture_session_names={s['name'] for s in selection_sessions}
    diagnostic_sessions=[session(name,require_complete=name not in capture_session_names)
                         for name in args.diagnostic_sessions]
    diagnostic_sessions.extend(s for s in selection_sessions
                               if not any(existing['name']==s['name'] for existing in diagnostic_sessions))
    for campaign in (args.capture_campaign,args.coverage_campaign):
        if campaign:
            assert any(campaign in s['campaigns'] and 'campaign:'+campaign in s['completed'] for s in diagnostic_sessions)
    assert all(runtime==expected_runtime for runtime in all_runtime)
    selected=comparison_campaigns | {x for x in (args.capture_campaign,args.coverage_campaign) if x}
    if capture_selection:
        selected.update(chosen['campaign'] for chosen in capture_selection['selected'].values())
    excluded=[]
    for path in sorted(HERE.glob('*CAMPAIGN-*.json')):
        if any(path.name.endswith('-'+name+'.json') for name in selected):
            continue
        data=load(path)
        failures={name:entry.get('error') for name,entry in data.items()
                  if isinstance(entry,dict) and (entry.get('passed') is False or entry.get('error'))}
        raw_failures={}
        excluded_campaign=path.stem.split('CAMPAIGN-',1)[1]
        for case in failures:
            directory=locate(excluded_campaign,case,data[case])
            raw_failures[case]=excluded_raw(directory)
        excluded.append(dict(path=path.name,selected_for_timing=False,
                             failures=failures,raw_failed_attempts=raw_failures))
    result=dict(schema=1,independent_of_builder_runner_and_verifier=True,
                whole_runs=rows,whole_run_count=34,variants=17,
                comparison_selection_sha256=sha(read(HERE/args.comparison_selection)) if comparison_selection else None,
                source_selection=args.comparison_selection,
                comparison_source_receipts=comparison_selection['source_receipts'] if comparison_selection else None,
                full_timed_ez80_UART_identical_across_all34=True,
                common_timed_uart_bytes=len(streams[0]),common_timed_uart_sha256=sha(streams[0]),
                captures=captures,completed_coverage=coverage,
                selected_capture_provenance='Original per-case receipts, which may precede a later failure in the same guarded session; no synthetic campaign copies' if capture_selection else None,
                excluded_capture_attempts=selection_excluded,
                bounded_retry_attempts=attempt_audits,retry_guard_sessions=retry_sessions,
                benchmark_sessions=sessions,diagnostic_sessions=diagnostic_sessions,
                frozen_runtime=expected_runtime,all_runtime_and_input_identities_exact=True,
                excluded_campaign_receipts=excluded,
                timing_limits='Nominal emulated MOS/PRT, ordered VDP command completion, no physical scanout/hardware claim. Captures/coverage excluded from throughput.',
                timer_restore_limit='Guest checks removed PRT vector identity and restores prior vector; raw samples/source pin, no independent peripheral-register snapshot.',
                raw_input_sha256=dict(sorted(SEEN.items())))
    (HERE/'RAW-AUDIT.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({key:result[key] for key in ('whole_run_count','variants','common_timed_uart_bytes','common_timed_uart_sha256','full_timed_ez80_UART_identical_across_all34')},indent=2))


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--campaigns',nargs='+',default=[],help='Legacy complete forward/reverse campaign names; omit with --comparison-selection')
    parser.add_argument('--sessions',nargs='+',default=[],help='Legacy benchmark guard sessions, or optional exact selector session list')
    parser.add_argument('--comparison-selection',help='Original per-case forward/reverse selections with pinned source receipts')
    parser.add_argument('--capture-campaign')
    parser.add_argument('--capture-selection',help='CAPTURE-RESULTS.json selected original successes across guarded campaigns')
    parser.add_argument('--coverage-campaign')
    parser.add_argument('--diagnostic-sessions',nargs='*',default=[])
    arguments=parser.parse_args()
    try:
        main(arguments)
    except BaseException as exc:
        number=1
        while (HERE/('RAW-AUDIT-FAILURE-'+str(number).zfill(3)+'.json')).exists():
            number+=1
        failure=dict(schema=1,error=repr(exc),traceback=traceback.format_exc(),
                     arguments=vars(arguments),raw_input_sha256=dict(sorted(SEEN.items())))
        (HERE/('RAW-AUDIT-FAILURE-'+str(number).zfill(3)+'.json')).write_text(json.dumps(failure,indent=2)+'\n')
        raise
