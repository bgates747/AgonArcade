"""Verify preserved qualification identities without compiling or launching."""
import hashlib
import json
from pathlib import Path
import subprocess
import zipfile

HERE = Path(__file__).resolve().parent
ROOT = next(p for p in HERE.parents if (p / '.git').exists())


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read(name):
    return json.loads((HERE / name).read_text())


def check_sources(mapping, base):
    for name, expected in mapping.items():
        assert sha(base / name) == expected, (base, name)


def verify():
    head = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT, text=True).strip()
    origin = subprocess.check_output(['git', 'rev-parse', 'origin/main'], cwd=ROOT, text=True).strip()
    assert head == origin and head.startswith('32a7cb4')
    allowed = {'AGENTS.md', 'TODO.md', 'docs/2026-10-28-rally-throughput.md',
               'docs/tasks/RALLY-28.md', 'docs/tasks/RALLY-28/research/RENDERER-COST-FINDINGS.md',
               'docs/tasks/RALLY-28/custom-vdp/incremental/PLAN.md'}
    changed = subprocess.check_output(['git', 'diff', '--name-only', 'HEAD'], cwd=ROOT, text=True).splitlines()
    assert set(changed) <= allowed, changed

    fixtures = read('FIXTURES.json')
    for case in fixtures.values():
        check_sources(case['files'], HERE / case['directory'])
        if 'host_expected' in case:
            assert sha(HERE / case['host_expected']) == case['host_expected_sha256']
    build = read('BUILD-candidate-clipfix.json')
    check_sources(build['files'], Path(build['fixture']))
    check_sources(build['helper_files'], Path(build['package']))
    assert sha(Path(build['module']['package'])) == build['module']['sha256']
    for mode in ('ordinary', 'sanitized'):
        host = read('host_clipfix_' + mode + '.json')
        check_sources(host['sources'], HERE)
        check_sources(host['package_sources'], Path(host['candidate_package']))
        assert host['replay']['independent_world_pass'] and host['failures']['passed']
        unit = read('sampler_unit-' + mode + '.json')
        check_sources(unit['sources'], HERE)
        assert unit['passed']
    for name in ('phase_LITE-PROOF.json', 'phase_EQUIVALENCE.json'):
        check_sources(read(name)['source_files'], HERE)

    archives = {}
    for name in ('PACKAGE.json', 'DIAGNOSTICS.json'):
        manifest = read(name)
        archive = HERE / manifest['archive']
        assert sha(archive) == manifest['sha256']
        with zipfile.ZipFile(archive) as z:
            assert set(z.namelist()) == set(manifest['members'])
            for member, expected in manifest['members'].items():
                assert hashlib.sha256(z.read(member)).hexdigest() == expected, member
        archives[archive.name] = {'sha256': sha(archive), 'members': len(manifest['members'])}

    results = read('RESULTS.json')
    assert len(results['rows']) == 4
    for campaign in ('sprcab01', 'sprcba01'):
        for case, run in read('CAMPAIGN-' + campaign + '.json').items():
            assert run['passed'] and run['input_hashes_preserved'] and run['final_world_exact']
            assert (run['frames'], run['physics_ticks'], run['retained_replies']) == (900, 3600, 2913)
    actor_runs = read('CAMPAIGN-spractor01.json')
    for run in actor_runs.values():
        assert run['passed'] and run['full_final_state_matches_independent_host']
        assert (run['frames'], run['physics_ticks'], run['retained_reply_records']) == (128, 512, 1373)
    sessions = {}
    for path in sorted(HERE.glob('SESSION-*.json')):
        session = json.loads(path.read_text())
        assert session['video_driver'] == session['audio_driver'] == 'dummy'
        assert session['boost_restored'] and session['final_boost'] == session['original_boost']
        assert not session['owned_emulator_processes_after']
        sessions[path.name] = {k: session[k] for k in
                               ('error', 'max_temperature_celsius', 'original_boost', 'final_boost')}

    snapshots = [HERE / 'evidence' / campaign / case / 'final.ppm'
                 for campaign in ('sprcab01', 'sprcba01')
                 for case in ('clipfix-affine', 'clipfix-additive')]
    assert len({sha(p) for p in snapshots}) == 1
    evidence = {str(p.relative_to(HERE)): sha(p) for p in sorted((HERE / 'evidence').rglob('*')) if p.is_file()}
    files = {p.name: sha(p) for p in sorted(HERE.iterdir())
             if p.is_file() and p.name != 'VERIFICATION.json'}
    report = {'checkpoint': head, 'origin_main_matches': True, 'tracked_changes_within_released_documentation': True,
              'registered_fixtures_verified': len(fixtures), 'qualified_headline_runs': 4,
              'qualified_headline_frames': 3600, 'qualified_headline_ticks': 14400,
              'qualified_headline_retained_replies': 11652, 'qualified_actor_runs': 2,
              'qualified_actor_frames': 256, 'qualified_actor_ticks': 1024,
              'qualified_actor_retained_replies': 2746, 'qualified_snapshots_sha256': sha(snapshots[0]),
              'archives': archives, 'sessions': sessions, 'files': files, 'raw_evidence': evidence,
              'hardware_tested': False, 'author_motion_review_pending': True,
              'new_implementation_committed': False}
    (HERE / 'VERIFICATION.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps({'verified': True, 'fixtures': len(fixtures), 'archives': archives,
                      'raw_evidence_files': len(evidence), 'snapshot_sha256': sha(snapshots[0])}, indent=2))


if __name__ == '__main__':
    verify()
