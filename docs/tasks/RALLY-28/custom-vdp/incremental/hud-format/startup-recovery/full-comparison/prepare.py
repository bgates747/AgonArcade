"""Freeze exact existing900-frame guests and saved-qualified protocol/wire."""
from pathlib import Path
import hashlib
import importlib.util
import json
import shutil

HERE = Path(__file__).resolve().parent
HUD = HERE.parent.parent
CUSTOM = HUD.parents[1]
sha = lambda p: hashlib.sha256(Path(p).read_bytes()).hexdigest()


def main():
    registry = json.loads((HUD/'FIXTURES.json').read_text())
    for case, info in registry.items():
        for name, wanted in info['files'].items():
            assert sha(HUD/info['directory']/name) == wanted, (case, name)
    changes = [n for n, h in registry['control']['files'].items() if h != registry['cached']['files'][n]]
    assert set(changes) == {'probe.bin', 'expected.json'}
    references = {}
    for mode in ('ordinary', 'sanitized', 'development'):
        p = HUD/f'HOST-{mode}.json'
        report = json.loads(p.read_text())
        assert report['passed'] and report['comparisons'] == 12932
        assert report['exact_emitted_bytes_and_both_page_cells']
        for name, wanted in report['input_sha256'].items():
            assert sha(name) == wanted, name
        references[mode] = sha(p)
    for mode in ('ordinary', 'sanitized'):
        report = json.loads((HERE/f'HOST-{mode}-900.json').read_text())
        assert report['valid'] and report['final_buffers'] == json.loads((HUD/'EXPECTED-FINAL-900.json').read_text())
    control = HUD.parent/'round-trips'
    spec = importlib.util.spec_from_file_location('smoke_raw_reference', control/'raw_audit.py')
    raw = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(raw)
    raw.COMPACT = True
    reference = json.loads((HUD/'EXPECTED-FINAL-900.json').read_text())
    schedule = raw.specs(900, 34836, 1, reference)
    assert len(schedule) == 2024
    prior = CUSTOM/'prepared-bitmap-set/prepared-benchmark'
    saved = prior/'evidence/prace900ab01/compact'
    freeze = json.loads((prior/'PARTIAL-RESULTS-FREEZE.json').read_text())
    for name in ('mos-to-vdp.bin', 'vdp-to-mos.bin', 'result.json'):
        assert sha(saved/name) == freeze['files'][str((saved/name).relative_to(prior))]
    old_inputs = json.loads((prior/'PROFILES-prace900ab01.json').read_text())['compact']['input_sha256']
    for name, wanted in registry['control']['files'].items():
        if name != 'expected.json':
            assert old_inputs['sdcard/rally25/'+name] == wanted, name
    packets, _ = raw.native_packets((saved/'vdp-to-mos.bin').read_bytes())
    raw.replies_match(packets, schedule)
    positions = raw.raw_requests((saved/'mos-to-vdp.bin').read_bytes(), schedule)
    wire = (saved/'mos-to-vdp.bin').read_bytes()[positions[17]['stop']:positions[1817]['stop']]
    assert len(wire) == 291568 and wire.count(b'\x17\0\xc3') == 900
    assert wire.count(b'\x17\0\xa0\x0d\0\1') == 3600
    assert wire == (HERE/'EXPECTED-TIMED-WIRE.bin').read_bytes()
    rows = [dict(token=r['token'], operation=r['operation'], fields_hex=r['fields'].hex(),
                 expected_reply_kind=r['kind'], expected_value=r['value'], label=r['label'],
                 phase=r['phase'], frame=r['frame']) for r in schedule]
    prediction = dict(frames=900, physics_ticks=3600, warm_frames=2, expected_native_replies=2024,
                      expected_timed_bytes=len(wire), expected_timed_sha256=sha(HERE/'EXPECTED-TIMED-WIRE.bin'),
                      requests=rows, source_capture=str(saved),
                      source_raw_sha256={n: sha(saved/n) for n in ('mos-to-vdp.bin', 'vdp-to-mos.bin', 'result.json')})
    assert prediction == json.loads((HERE/'EXPECTED-PROTOCOL.json').read_text())
    shutil.copyfile(HUD/'EXPECTED-FINAL-900.json', HERE/'EXPECTED-FINAL-900.json')
    (HERE/'FIXTURES.json').write_text(json.dumps(registry, indent=2)+'\n')
    report = dict(passed=True, application_differences=changes, expected_wire_delta=0,
                  expected_timed_bytes=291568, expected_native_replies=2024,
                  expected_final_sha256=sha(HERE/'EXPECTED-FINAL-900.json'),
                  prior_complete900_reply_schedule_matches=True,
                  current_host_presentation_references=references,
                  actual_checked_c_ordinary_and_sanitized_match=True,
                  guests_rebuilt=False, cache_source_changed=False, emulator_executed=False)
    (HERE/'PREPARATION.json').write_text(json.dumps(report, indent=2)+'\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
