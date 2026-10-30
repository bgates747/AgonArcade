"""Separate complete-race capture/effect fixtures; never alter timed inputs.

Capture requests use the already frozen common guest's post-swap fence/hold hook.
These profiles are deliberately interrupted after capture.ready; their timings
are excluded. The separate coverage60 case completes and qualifies cleanup.
"""
from pathlib import Path
import hashlib
import json
import struct

HERE = Path(__file__).resolve().parent
FIXTURE_ROOT = HERE / 'captures/fixtures'
PROBE_SHA = '33116db786ef08033a3c5aa3404a7d5ed8411013af9b70ac27051ddd1ade53e9'
SPECIFICATIONS = [
    ('baseline300', 'baseline', 900, 0, 300),
    ('additive300', 'additive', 900, 0, 300),
    ('additive301', 'additive', 900, 0, 301),
    ('crash60', 'additive', 60, 1, 60),
    ('blink160', 'additive', 60, 1, 160),
]


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def write(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists():
        assert path.read_bytes() == data, ('Preserve earlier diagnostic input', path)
    else:
        path.write_bytes(data)


def save(name, value):
    write(HERE / name, (json.dumps(value, indent=2) + '\n').encode())


def expected_ready(frames, stage, frame):
    if stage == 0:
        generation, request, ticks = 3 + frame * 5, frame + 2, frame * 4
    else:
        generation = 3 + frames * 5 + frame + 1
        request, ticks = frames + 2 + frame + 1, frames * 4
    return dict(schema=1, timing_excluded=True, stage=stage, frame=frame,
                generation=generation, request=request, physics_ticks=ticks,
                post_swap_fenced=True)


def derive(registry, case, source_name, frames, stage=None, capture_frame=None):
    source_info = registry[source_name]
    source = HERE / source_info['directory']
    assert all(sha(source / name) == wanted for name, wanted in source_info['files'].items())
    assert source_info['files']['probe.bin'] == PROBE_SHA
    target = FIXTURE_ROOT / case
    for name in source_info['files']:
        if name != 'expected.json':
            data = (source / name).read_bytes()
            if name == 'config.bin':
                assert len(data) == 16 and data[:4] == b'R28F'
                data = data[:6] + struct.pack('<H', frames) + data[8:]
            write(target / name, data)
    metadata = json.loads((source / 'expected.json').read_text())
    reference_name = 'EXPECTED-FINAL-' + str(frames) + '.json'
    reference = json.loads((HERE / reference_name).read_text())
    root = bytes.fromhex(reference['1'])
    metadata.update(candidate=case, source_renderer=source_name, diagnostic=True,
        frames=frames, physics_ticks=frames * 4,
        player_final_station=struct.unpack_from('<I', root, 198)[0],
        final_scripted_positions=list(struct.unpack('<6I', bytes.fromhex(reference['4']))),
        expected_render_requests=frames + 2,
        expected_native_generation=frames * 5 + 3,
        expected_native_world_ticks=frames * 4,
        expected_final_buffers_file=reference_name,
        alias_of=None, alias_reason=None,
        timing_excluded=True,
        timing_scope='Separate correctness/visual diagnostic; excluded from the renderer throughput comparison')
    coverage = stage == 1 or case == 'coverage60'
    if coverage:
        write(target / 'coverage.req', b'coverage\n')
    metadata.update(coverage=coverage, coverage_diagnostic=coverage,
        coverage_frames=272 if coverage else 0,
        expected_coverage=(dict(schema=1, separate_from_throughput=True, frames=272,
            explosion_frames=150, blink_hidden_frames=60, recovery_transitions=1,
            camera_frozen=True, native_physics_ticks=0, healthy=True) if coverage else None),
        expected_retained_replies=6 * frames + 224 + (3 + 272 * 6 if coverage else 0))
    capture = None
    if stage is not None:
        assert stage in (0, 1)
        assert 1 <= capture_frame <= frames if stage == 0 else 0 <= capture_frame < 272
        write(target / 'capture.req', struct.pack('<HH', stage, capture_frame))
        capture = dict(stage=stage, frame=capture_frame)
        metadata.update(capture=capture, expected_capture_ready=expected_ready(frames, stage, capture_frame),
                        capture_hold_mos_units=24000, deliberate_stop_during_hold=True)
    metadata['files'] = {path.name: sha(path) for path in sorted(target.iterdir())
                         if path.is_file() and path.name != 'expected.json'}
    write(target / 'expected.json', (json.dumps(metadata, indent=2) + '\n').encode())
    files = {path.name: sha(path) for path in sorted(target.iterdir()) if path.is_file()}
    changes = [name for name, wanted in source_info['files'].items() if files[name] != wanted]
    additions = sorted(set(files) - set(source_info['files']))
    assert changes == (['expected.json'] if frames == 900 else ['config.bin', 'expected.json'])
    assert additions == sorted((['capture.req'] if stage is not None else []) + (['coverage.req'] if coverage else []))
    for name, wanted in source_info['files'].items():
        if name not in ('config.bin', 'expected.json'):
            assert files[name] == wanted
    return dict(directory=str(target.relative_to(HERE)), files=files,
        source_renderer=source_name, source_registry='FIXTURES.json',
        module_sha256=source_info['module_sha256'], diagnostic=True, foreground_paced=False,
        frames=frames, physics_ticks=frames * 4, coverage=coverage, capture=capture,
        expected_capture_ready=metadata.get('expected_capture_ready'),
        changed_source_files=changes, added_request_files=additions,
        timing_excluded=True, expected_retained_replies=metadata['expected_retained_replies'])


def build():
    normal_registry = HERE / 'FIXTURES.json'
    before = sha(normal_registry)
    registry = json.loads(normal_registry.read_text())
    captures = {case: derive(registry, case, renderer, frames, stage, frame)
                for case, renderer, frames, stage, frame in SPECIFICATIONS}
    coverage = {'coverage60': derive(registry, 'coverage60', 'additive', 60)}
    assert sha(normal_registry) == before
    for entry in registry.values():
        assert all(sha(HERE / entry['directory'] / name) == wanted
                   for name, wanted in entry['files'].items())
    assert len({entry['files']['probe.bin'] for entry in [*captures.values(), *coverage.values()]}) == 1
    save('CAPTURE-FIXTURES.json', captures)
    save('COVERAGE-FIXTURES.json', coverage)
    save('CAPTURE-BUILD-PROOF.json', dict(schema=1, normal_registry_sha256=before,
        normal_registry_and_all17_input_sets_unchanged=True,
        source_probe_sha256=PROBE_SHA, builder_sha256=sha(Path(__file__)),
        source_capture_hook_sha256=sha(HERE / 'guest/main.cpp'),
        captures=list(captures), complete_coverage=list(coverage),
        request_format='capture.req4B little endian <HH(stage,frame); coverage.req presence only',
        capture_post_swap_fenced=True, capture_hold_mos_units=24000,
        capture_profiles_deliberately_interrupted=True,
        normal_timing_and_diagnostic_timing_not_pooled=True,
        final_reference_sha256={str(frames): sha(HERE / ('EXPECTED-FINAL-' + str(frames) + '.json'))
                                for frames in (60, 900)},
        emulator_launched=False))
    print('Prepared five post-fence capture clones and one complete272-frame coverage diagnostic.')


if __name__ == '__main__':
    build()
