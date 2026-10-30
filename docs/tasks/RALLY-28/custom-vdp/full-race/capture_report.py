"""Audit qualified race/effect captures and create lossless PNG previews.

Uses only Python's standard library. Capture profiles stop during an ordered
post-swap hold; they establish scene evidence, not frame rate or cleanup.
"""
from pathlib import Path
import argparse
import binascii
import hashlib
import json
import struct
import zlib

HERE = Path(__file__).resolve().parent
WIDTH, HEIGHT = 320, 240
REGIONS = {'hud': (0, 23), 'panorama': (24, 103), 'road_and_actors': (104, 223), 'footer': (224, 239)}


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def png(rgb):
    assert len(rgb) == WIDTH * HEIGHT * 3
    def chunk(kind, data):
        return (struct.pack('>I', len(data)) + kind + data
                + struct.pack('>I', binascii.crc32(kind + data) & 0xffffffff))
    stride = WIDTH * 3
    raw = b''.join(b'\0' + rgb[y * stride:(y + 1) * stride] for y in range(HEIGHT))
    return (b'\x89PNG\r\n\x1a\n'
            + chunk(b'IHDR', struct.pack('>2I5B', WIDTH, HEIGHT, 8, 2, 0, 0, 0))
            + chunk(b'IDAT', zlib.compress(raw, 9)) + chunk(b'IEND', b''))


def read_ppm(path):
    data = path.read_bytes()
    header = b'P6\n320 240\n255\n'
    assert data.startswith(header) and len(data) == len(header) + WIDTH * HEIGHT * 3, ('Capture dimensions/format', path)
    return data[len(header):]


def region_summary(rgb):
    result = {}
    for name, (top, bottom) in REGIONS.items():
        body = rgb[top * WIDTH * 3:(bottom + 1) * WIDTH * 3]
        colours = len({body[offset:offset + 3] for offset in range(0, len(body), 3)})
        result[name] = dict(rows=[top, bottom], colours=colours,
                            sha256=hashlib.sha256(body).hexdigest())
        # An entirely flat region would contradict these actual race scenes.
        # This is a missing-drawing check, not a visual acceptance threshold.
        assert colours >= 2, ('Unexpected empty/flat race region', name, colours)
    return result


def differences(a, b):
    assert len(a) == len(b) == WIDTH * HEIGHT * 3
    regions = {}
    for name, (top, bottom) in REGIONS.items():
        start, stop = top * WIDTH * 3, (bottom + 1) * WIDTH * 3
        changed = sum(a[offset:offset + 3] != b[offset:offset + 3] for offset in range(start, stop, 3))
        pixels = (bottom - top + 1) * WIDTH
        regions[name] = dict(changed_pixels=changed, pixels=pixels,
                             agreement_percent=100 * (pixels - changed) / pixels)
    total = sum(value['changed_pixels'] for value in regions.values())
    return dict(changed_pixels=total, pixels=WIDTH * HEIGHT,
                agreement_percent=100 * (WIDTH * HEIGHT - total) / (WIDTH * HEIGHT),
                exact=total == 0, regions=regions)


def write_identical(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists():
        assert path.read_bytes() == data, ('Preserve previous capture report', path)
    else:
        path.write_bytes(data)


def qualifying_capture(run, fixture, evidence):
    assert run['error'] is None and run['process_exit'] == 0
    assert run['capture_ready'] == fixture['expected_capture_ready']
    assert run['video_driver'] == run['audio_driver'] == 'dummy'
    assert run['intentional_interruption_during_hold'] and run['timing_excluded']
    assert run['input_hashes_preserved'] and not run['game_cleanup_validated']
    assert not any(run['backend_stats'].get(key) for key in ('failed', 'unhandled', 'unregistered', 'unmapped'))
    for filename, wanted in fixture['files'].items():
        runtime_line = wanted + '  sdcard/rally25/' + filename
        assert runtime_line in run['runtime_identities'], ('Capture used different input', filename)
    ppm = evidence / 'final.ppm'
    assert sha(ppm) == run['scene_ppm_sha256']
    if (evidence / 'capture.ready').exists():
        assert json.loads((evidence / 'capture.ready').read_text()) == fixture['expected_capture_ready']
    read_ppm(ppm)


def report(campaigns, session_names):
    registry = json.loads((HERE / 'CAPTURE-FIXTURES.json').read_text())
    if isinstance(campaigns, str):
        campaigns = [campaigns]
    if isinstance(session_names, str):
        session_names = [session_names]
    assert campaigns and session_names and len(set(campaigns)) == len(campaigns)
    sessions = {}
    for name in session_names:
        path = HERE / ('SESSION-' + name + '.json')
        session = json.loads(path.read_text())
        assert session['boost_restored'] and not session['owned_emulator_processes_after']
        assert session['video_driver'] == session['audio_driver'] == 'dummy'
        sessions[name] = session
    candidates, excluded, source_receipts = {}, [], {}
    for campaign in campaigns:
        matches = [name for name, session in sessions.items() if campaign in session['campaigns']]
        assert len(matches) == 1, ('Campaign needs one original session receipt', campaign, matches)
        session_name = matches[0]
        session = sessions[session_name]
        campaign_path = HERE / ('CAPTURE-CAMPAIGN-' + campaign + '.json')
        runs = json.loads(campaign_path.read_text())
        profiles_path = HERE / ('PROFILES-' + campaign + '.json')
        profiles = json.loads(profiles_path.read_text())
        source_receipts[campaign] = dict(campaign_sha256=sha(campaign_path),
            session_sha256=sha(HERE / ('SESSION-' + session_name + '.json')),
            profiles_sha256=sha(profiles_path), session=session_name,
            source_session_error=session['error'])
        for name, run in runs.items():
            assert name in registry, ('Unexpected capture case', campaign, name)
            evidence = HERE / 'captures/evidence' / campaign / name
            try:
                qualifying_capture(run, registry[name], evidence)
            except (AssertionError, KeyError, OSError, ValueError) as error:
                excluded.append(dict(case=name, campaign=campaign, session=session_name,
                    error=run.get('error'), reason='Unqualified attempt: ' + repr(error)))
                continue
            if name in candidates:
                old = candidates[name]
                excluded.append(dict(case=name, campaign=old['campaign'], session=old['session'],
                    error=None, reason='Qualified success superseded by a later listed successful original campaign'))
            candidates[name] = dict(case=name, campaign=campaign, session=session_name,
                profile=profiles[name]['profile'], profile_receipt=profiles_path.name,
                session_receipt='SESSION-' + session_name + '.json',
                campaign_receipt=campaign_path.name,
                evidence_directory=str(evidence.relative_to(HERE)),
                source_session_error=session['error'],
                runtime_identities_sha256=hashlib.sha256(run['runtime_identities'].encode()).hexdigest(),
                run=run)
    assert set(candidates) == set(registry), ('Missing qualified captures', sorted(set(registry) - set(candidates)))
    selected = {name: {key: value for key, value in candidates[name].items() if key != 'run'}
                for name in registry}
    scenes, rgb = {}, {}
    for name, fixture in registry.items():
        source = candidates[name]
        ppm = HERE / source['evidence_directory'] / 'final.ppm'
        rgb[name] = read_ppm(ppm)
        preview = HERE / 'captures/previews' / source['campaign'] / (name + '.png')
        write_identical(preview, png(rgb[name]))
        stage, frame = fixture['capture']['stage'], fixture['capture']['frame']
        page = frame % 2 if stage == 0 else (fixture['frames'] + frame + 1) % 2
        scenes[name] = dict(capture=fixture['capture'], page_parity=page,
            width=WIDTH, height=HEIGHT, ppm_sha256=sha(ppm), png_sha256=sha(preview),
            preview=str(preview.relative_to(HERE)), ordered_post_swap_fence=True,
            expected_capture_ready=fixture['expected_capture_ready'],
            region_content=region_summary(rgb[name]))
    comparison = differences(rgb['baseline300'], rgb['additive300'])
    assert {scenes['additive300']['page_parity'], scenes['additive301']['page_parity']} == {0, 1}
    # Do not equate different motion states merely to assert page equality.
    result = dict(schema=2, campaigns=campaigns, sessions=session_names, passed=True,
        actual_scene_snapshots=True, scenes=scenes,
        selected=selected, excluded_attempts=excluded, source_receipts=source_receipts,
        selection_policy='Latest qualifying success per case in the explicitly listed original campaign order; raw receipts/evidence are never copied or modified',
        matched_baseline_additive_frame300=comparison,
        both_normal_page_parities_captured=True,
        effect_scenes=dict(explosion='crash60', invulnerability_blink='blink160'),
        pixel_difference_is_reported_not_a_new_author_acceptance_threshold=True,
        timing_excluded=True, intentional_hold_interruption=True,
        cleanup_validated_by_capture=False,
        cleanup_gate='Separate complete main/coverage runs qualify PRT restoration, UNLOAD and MOS exit',
        human_visual_review_pending=True, hardware_tested=False,
        maximum_temperature_celsius=max(session['max_temperature_celsius'] for session in sessions.values()),
        boost_restored=True, owned_emulators_stopped=True,
        fixture_registry_sha256=sha(HERE / 'CAPTURE-FIXTURES.json'), tool_sha256=sha(Path(__file__)))
    encoded = (json.dumps(result, indent=2) + '\n').encode()
    write_identical(HERE / ('CAPTURE-RESULTS-' + '-'.join(campaigns) + '.json'), encoded)
    write_identical(HERE / 'CAPTURE-RESULTS.json', encoded)
    print('Qualified five320x240 race/effect scenes; matched frame300 agreement:',
          round(comparison['agreement_percent'], 6), 'percent;', comparison['changed_pixels'], 'changed pixels.')
    return result


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--campaigns', '--campaign', nargs='+', required=True)
    parser.add_argument('--sessions', '--session', nargs='+', required=True)
    arguments = parser.parse_args()
    report(arguments.campaigns, arguments.sessions)
