"""Index and recheck the completed final-asset qualifications without rerunning them.

The underlying independent auditors own numeric/image/raw-record comparisons.
This audit binds their results, source/evidence hashes and production files to
one delivery. Native performance success is not physical performance acceptance.
"""
import json
from pathlib import Path
from profile import TASK
from native_run import sha
from frontend_bridge import verify


def main():
    output = TASK / 'evidence/final/qualification.json'
    output.parent.mkdir(parents=True, exist_ok=False)
    indexed = {}
    verified = {}

    def digest(path):
        path = Path(path).resolve()
        if path not in verified:
            verified[path] = sha(path)
        return verified[path]

    def read(relative):
        path = TASK / relative
        indexed[relative] = digest(path)
        return json.loads(path.read_text())

    def hashes(values, base=TASK):
        for name, expected in values.items():
            assert digest(base / name) == expected, name

    frozen = read('evidence/hardware-production/inline-candidate/frozen-qualification.json')
    assert frozen['pass'] and frozen['frozen_cases'] == 66
    assert frozen['qualifier_sha256'] == digest(TASK / 'qualify_inline_candidate.py')
    assert all(r['geometry']['pass'] and r['pixels']['pass'] for r in frozen['results'])
    hashes(frozen['evidence'])

    front = read('evidence/golem-frontend/hardware-inline-qualification.json')
    assert front['pass'] and front['native_runs'] == 12 and front['host_state_records'] == 638
    assert front['accepted_input_physics_and_HUD_source_unchanged']
    assert front['audit_sha256'] == digest(TASK / 'qualify_inline_frontend.py')
    _, _, bridge = verify(Path(front['build']['work']), allow_inline=True)

    replay = read('evidence/golem-stability/hardware-inline-audit/qualification.json')
    assert replay['pass'] and {r['track'] for r in replay['runs']} == {'oval', 'fuji'}
    for r in replay['runs']:
        assert r['guest_seconds'] >= 600 and r['wall_seconds_including_final_readback'] >= 600
        assert r['frames'] == 18064 and r['all_payloads_exact']
        assert r['missing_duplicate_or_protocol_errors'] == r['nonfinite'] == 0
        assert r['after_cleanup'] == [26, 174986]
    hashes(replay['evidence'])

    for track in ['oval', 'fuji']:
        life = read(f'evidence/golem-lifecycle/hardware-inline-{track}/results.json')
        assert life['pass'] and life['events'] == 210 and life['accepted'] == 27
        assert life['all_96_byte_readbacks_exact'] and life['rejected_geometry_and_history_unchanged']
        assert life['sequence_wrap'] and life['nonfinite'] == 0
        assert life['cleanup_cycles'] == 3 and life['foreign_canary_preserved']
        for case in ['missing-vdp', 'corrupt-vdp', 'missing-clr', 'corrupt-clr']:
            fail = read(f'evidence/golem-failure/hardware-inline-{track}-{case}/results.json')
            assert fail['pass'] and fail['game_return'] == 31

    loader = read('evidence/golem-loader/hardware-inline/results.json')
    assert loader['pass'] and 'loader cases=834:' in loader['result']
    golem = TASK.parents[3] / 'golem-rally19'
    host_path = golem / 'docs/evidence/rally19-hardware-inline/hosted-tests.json'
    host = json.loads(host_path.read_text())
    assert len([k for k in host if k not in ['design_cases', 'source_hashes']]) == 14
    hashes(host['source_hashes'], golem)

    performance = read('evidence/golem-performance/hardware-inline/qualification.json')
    assert performance['pass'] and all(performance['checks'].values())
    assert performance['audit_sha256'] == digest(TASK / 'qualify_inline_performance.py')
    hashes(performance['evidence'])

    production = read('.work/production/hardware-inline/manifest.json')
    hashes(production['source_hashes'])
    hashes(production['outputs'])
    assert production['defaults'] == 'oval demo'
    assert not any(production[k] for k in ['fencing', 'logging', 'performance_counters'])
    rebuilt = read('evidence/hardware-production/inline-candidate/production-rebuild.json')
    assert rebuilt['pass']
    for name in rebuilt['unchanged_files']:
        assert (Path(rebuilt['source']) / name).read_bytes() == (Path(rebuilt['deployed_parent']) / name).read_bytes()
    physical = read('evidence/hardware-production/official-inline-restore/acceptance.json')
    assert physical['capture_closed']
    hashes(physical['evidence_sha256'])

    report = {
        'pass': True,
        'scope': __doc__,
        'native_frozen_criteria_pass': True,
        'physical_startup': physical['accepted_scope'],
        'physical_performance_accepted': False,
        'physical_limits': physical['not_established'],
        'compiler_host_report_sha256': digest(host_path),
        'compiler_source_sha256': host['source_hashes'],
        'qualifications_sha256': indexed,
        'rechecked_files': len(verified),
        'source_bridge': bridge,
        'production_sha256': physical['production_sha256'],
        'auditor_sha256': sha(Path(__file__)),
    }
    output.write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps({k: report[k] for k in ['pass', 'native_frozen_criteria_pass',
                                          'physical_performance_accepted', 'rechecked_files']}, indent=2))


if __name__ == '__main__':
    main()
