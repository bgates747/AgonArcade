"""Reconstruct completed-frame timing and the exact authorized UART changes."""
from pathlib import Path
import hashlib
import json
import struct

HERE = Path(__file__).resolve().parent
sha = lambda data: hashlib.sha256(data).hexdigest()


def clock(path):
    b = path.read_bytes()
    assert len(b) == 902 * 3
    return [int.from_bytes(b[i:i+3], 'little') for i in range(0, len(b), 3)]


def report():
    from build import OLD_PAINT, NEW_PAINT, SETUP_PAYLOAD
    registry = json.loads((HERE / 'FIXTURES.json').read_text())
    source = HERE / registry['control']['directory']
    meta = json.loads((source / 'expected.json').read_text())
    motion = (source / 'motion.bin').read_bytes()
    lanes = struct.pack('<6i', *meta['fixed_display_lanes'])
    mh = bytes([23, 0, 160, 4, 0, 5, 194, 0, 0, 24, 0])
    lh = bytes([23, 0, 160, 5, 0, 5, 194, 0, 0, 24, 0])
    reference = json.loads((HERE / 'CONTROL-FINAL.json').read_text())
    streams, rows, pins = {}, [], []
    for campaign in ('staticab01', 'staticba01'):
        runs = json.loads((HERE / ('CAMPAIGN-' + campaign + '.json')).read_text())
        profiles = json.loads((HERE / ('PROFILES-' + campaign + '.json')).read_text())
        for case, r in runs.items():
            assert r['passed'] and r['full_final_state_exact'] and r['input_hashes_preserved']
            assert (r['frames'], r['physics_ticks'], r['retained_replies']) == (900, 3600, 2913)
            d = HERE / 'evidence' / campaign / case
            receipt = json.loads((d / 'run.json').read_text())
            assert receipt['result']['final_buffers'] == reference
            mos, prt = clock(d / 'ticks.bin'), clock(d / 'prt.bin')
            mt, pt = (mos[900] - mos[0]) & 0xffffff, (prt[900] - prt[0]) & 0xffffff
            assert mt > 0 and pt > 0
            assert abs(900 * 120 / mt - r['nominal_mos_fps']) < 1e-10
            assert abs(900 * 1000 / pt - r['prt']['nominal_fps_at_18432000_hz']) < 1e-10
            wire = (d / 'mos-to-vdp.bin').read_bytes()
            start = wire.index(mh + motion[:24] + lh + lanes) - 24
            size = 347 if case == 'control' else 274
            stream = wire[start:start + size * 900]
            assert len(stream) == size * 900
            for i in range(900):
                frame = stream[i*size:(i+1)*size]
                assert frame[24:94] == mh + motion[24*i:24*i+24] + lh + lanes
                assert frame.count(OLD_PAINT if case == 'control' else NEW_PAINT) == 1
            if case == 'static':
                assert wire[:start].count(SETUP_PAYLOAD) == 1
            streams[(campaign, case)] = stream
            pins.append({n: h for n, h in profiles[case]['input_sha256'].items()
                         if n not in ('sdcard/rally25/script.bin', 'sdcard/rally25/expected.json')})
            zero_mos = [i for i in range(1, 901) if mos[i] == mos[i-1]]
            rows.append(dict(campaign=campaign, case=case, frames=900, physics_ticks=3600,
                             nominal_mos_units=mt, nominal_mos_seconds=mt/120,
                             nominal_mos_fps=900*120/mt,
                             nominal_prt_ticks=pt, nominal_prt_seconds=pt/1000,
                             nominal_prt_fps=900*1000/pt,
                             host_seconds_including_startup=r['host_seconds_including_startup'],
                             timed_uart_bytes=len(stream), timed_uart_sha256=sha(stream),
                             zero_single_frame_mos_intervals=zero_mos,
                             final_state_exact=True, clean_mos_return=r['clean_mos_return']))
    control = streams[('staticab01', 'control')]
    assert sha(control) == '370d42da5e5f05c6824e65862e5f1d5cec531e8f473deaa15cbb0014d8a88f45'
    assert control == streams[('staticba01', 'control')]
    modified = bytearray()
    for i in range(900):
        frame = control[347*i:347*(i+1)]
        assert frame.count(OLD_PAINT) == 1
        modified += frame.replace(OLD_PAINT, NEW_PAINT, 1)
    assert bytes(modified) == streams[('staticab01', 'static')] == streams[('staticba01', 'static')]
    assert all(p == pins[0] for p in pins)
    pooled = {}
    for case in ('control', 'static'):
        rs = [r for r in rows if r['case'] == case]
        assert len(rs) == 2
        ms, ps = sum(r['nominal_mos_seconds'] for r in rs), sum(r['nominal_prt_seconds'] for r in rs)
        pooled[case] = dict(frames=1800, nominal_mos_seconds=ms,
                            nominal_mos_fps=1800/ms, nominal_mos_ms_per_frame=ms/1.8,
                            nominal_prt_seconds=ps, nominal_prt_fps=1800/ps)
    pairs = []
    for campaign in ('staticab01', 'staticba01'):
        pair = {r['case']: r for r in rows if r['campaign'] == campaign}
        pairs.append(dict(campaign=campaign,
                          nominal_mos_gain_percent=100*(pair['static']['nominal_mos_fps']/pair['control']['nominal_mos_fps']-1),
                          nominal_prt_gain_percent=100*(pair['static']['nominal_prt_fps']/pair['control']['nominal_prt_fps']-1)))
    session = json.loads((HERE / 'SESSION-staticsession01.json').read_text())
    assert session['error'] is None and session['boost_restored']
    assert not session['owned_emulator_processes_after']
    a, b = pooled['control'], pooled['static']
    result = dict(task='INC-001-04', checkpoint='aab566d', rows=rows, pooled=pooled, pairs=pairs,
                  nominal_mos_gain_percent=100*(b['nominal_mos_fps']/a['nominal_mos_fps']-1),
                  nominal_prt_gain_percent=100*(b['nominal_prt_fps']/a['nominal_prt_fps']-1),
                  nominal_mos_ms_saved_per_frame=a['nominal_mos_ms_per_frame']-b['nominal_mos_ms_per_frame'],
                  wire=dict(control_bytes_per_frame=347, candidate_bytes_per_frame=274,
                            saved_per_frame=73, total_saved_timed_bytes=73*900,
                            extra_setup_bytes=len(SETUP_PAYLOAD),
                            only_authorized_paint_change=True, all900_motion_packets_exact=True,
                            candidate_timed_sha256=sha(bytes(modified))),
                  same_native_module_driver_assets_motion_runtime=True,
                  full_final_worlds_exact=True, hardware_tested=False,
                  human_visual_review_pending=True, bitmap_caching=False,
                  clocks='MOS nominal120units/s, PRT nominal18.432MHz instruction clock; not calibrated physical FPS. Host durations include startup/teardown.',
                  session={k: session[k] for k in ('host_boot_id', 'original_boost', 'final_boost', 'boost_restored', 'max_temperature_celsius', 'elapsed_host_seconds')})
    audit = json.loads((HERE / 'RAW-AUDIT.json').read_text())
    page = json.loads((HERE / 'PAGE-PROOF.json').read_text())
    capture = json.loads((HERE / 'CAPTURE-RESULTS.json').read_text())
    assert audit['passed'] and page['passed']
    assert abs(audit['nominal_mos_gain_percent'] - result['nominal_mos_gain_percent']) < 1e-10
    assert abs(audit['nominal_prt_gain_percent'] - result['nominal_prt_gain_percent']) < 1e-10
    assert all(p['exact'] and not p['changed_pixels'] for p in capture['pairs'])
    result.update(candidate_promoted=False,
                  evidence_sha256={name: sha((HERE/name).read_bytes()) for name in
                                   ('RAW-AUDIT.json', 'STATIC-REVIEW.json', 'PAGE-PROOF.json', 'CAPTURE-RESULTS.json')},
                  human_review_profile=json.loads((HERE/'PROFILES-staticreview01.json').read_text())['static']['profile'])
    (HERE / 'RESULTS.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(result, indent=2))
    return result


if __name__ == '__main__':
    report()
