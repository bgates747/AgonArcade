"""Verify preserved real Wolf3D completion captures and summarize host timing."""
from pathlib import Path
import hashlib
import json
import struct

HERE = Path(__file__).resolve().parent


def occurrences(data, prefix, length):
    offset = 0
    found = []
    while True:
        offset = data.find(prefix, offset)
        if offset < 0: return found
        assert offset + length <= len(data)
        found.append((offset, data[offset:offset + length]))
        offset += length


def analyze():
    run = json.loads((HERE / 'RUN.json').read_text())
    assert run['error'] is None and run['ended'] and run['process_exit'] == 0
    assert run['all_input_hashes_preserved'] and run['boost_restored']
    assert run['original_boost'] == run['final_boost'] == '1'
    assert not run['owned_emulators_after']
    assert run['video_driver'] == run['audio_driver'] == 'dummy'
    assert not any(run['backend_stats'][k] for k in ('failed', 'unhandled', 'unregistered', 'unmapped'))
    inputs = json.loads((HERE / 'INPUTS.json').read_text())
    assert all(hashlib.sha256(Path(n).read_bytes()).hexdigest() == h
        for n, h in inputs['source_file_sha256'].items()), 'Original Wolf input changed'
    incoming = (HERE / 'evidence/vdp-to-mos-delivered.bin').read_bytes()
    outgoing = (HERE / 'evidence/mos-to-vdp.bin').read_bytes()
    completions = occurrences(incoming, b'\x81\x0aW3DR\x01\x01\x3d\x57', 12)
    sequences = [struct.unpack_from('<H', record, 10)[0] for _, record in completions]
    assert sequences[0] == 1
    assert all(b == (a + 1) & 65535 for a, b in zip(sequences, sequences[1:]))
    assert b'\x81\x0aW3DR\x01\x02' not in incoming, 'Fizzle contaminates ordinary rendering'
    poses = occurrences(outgoing, b'\x17\0\xa0\x01\0\x4a\x02', 17)
    decoded = [struct.unpack_from('<iiH', record, 7) for _, record in poses]
    assert all((x, y) == (0x1d8000, 0x398000) for x, y, a in decoded)
    angles = [a for x, y, a in decoded]
    assert set(angles) == set(range(0, 360, 3))
    steps = {(a - b) % 360 for a, b in zip(angles, angles[1:])}
    assert steps <= {0, 3, 6, 9, 12}, steps
    gameplay = outgoing[poses[0][0]:]
    presentations = gameplay.count(b'\x17\0\xc3')
    requests = gameplay.count(b'\x17\0\xa0\x01\0\x4a\x07')
    assert presentations == requests == len(sequences)
    assert len(run['windows']) == 2
    assert all(w['host_seconds'] >= 30 and w['completed_frames'] > 0 for w in run['windows'])
    assert run['windows'][0]['last_count'] == run['windows'][1]['first_count']
    assert run['windows'][0]['end_since_launch'] == run['windows'][1]['start_since_launch']
    frames = sum(w['completed_frames'] for w in run['windows'])
    seconds = sum(w['host_seconds'] for w in run['windows'])
    result = dict(status='PASS', clock='Host CLOCK_MONOTONIC',
        measured_completed_frames=frames, measured_host_seconds=seconds,
        completed_renderer_fps=frames / seconds, windows=run['windows'],
        full_capture_render_completions=len(sequences), full_capture_presentation_commands=presentations,
        full_capture_render_requests=requests, consecutive_sequence_checks=True, fizzle_events=0,
        player_pose_updates=len(decoded), unique_angles=len(set(angles)),
        position_world_units=[29.5, 57.5], clockwise_angle_step_multiples=sorted(steps),
        active_viewport=[256, 160], display=[320, 240], difficulty='medium',
        simulation_and_render_submission_cap_nominal_hz=30,
        application_sha256=inputs['payload_sha256']['app/wolf3d.bin'],
        firmware_sha256=inputs['payload_sha256']['esp32-firmware.bin'],
        original_sources_preserved=True, profile_inputs_preserved=True,
        power=dict(boost_during_run=0, original_and_final_boost=1,
            max_sampled_temperature_celsius=run['max_sampled_temperature']),
        backend_errors=0, emulator_stopped=True, audio_video_drivers='dummy',
        limits=['30 Hz capped actual application; no unpaced maximum-capacity claim',
            'Stationary E1L1 original-start rotation with normal AI, textures, weapon and HUD; not a full-map traversal',
            '250 ms capture flush batches plus25 ms polling; report about0.1 FPS precision',
            'W3DR drains drawing; matching C3 proves presentation submission, not physical monitor scanout',
            'Host timing differs from nominal MOS/PRT timing in Rally reports; no direct cross-clock percentage',
            'Flexe preliminary estimate, not hardware performance'])
    (HERE / 'RESULTS.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps({k: result[k] for k in ('status', 'measured_completed_frames',
        'measured_host_seconds', 'completed_renderer_fps', 'full_capture_render_completions',
        'full_capture_presentation_commands', 'unique_angles')}, indent=2))


if __name__ == '__main__':
    analyze()
