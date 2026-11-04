"""Real custody-file tests with synthetic checkout replies; no SSH or emulator."""
from pathlib import Path
import json
import stat
import subprocess
import tarfile
import tempfile
from prepare import HERE, ORIGINAL, ROOT, canonical, sha
import review_custody as custody


def refuses(call):
    try:
        call()
    except ValueError:
        return True
    raise AssertionError('Invalid custody was admitted')


def check():
    info = json.loads((HERE / 'PROFILE.json').read_text())
    target = Path(info['local_stopped_profile'])
    first = json.loads((ORIGINAL / 'PROFILE.json').read_text())
    assert len(info['input_sha256']) == 24
    assert not (target / custody.FILENAME).exists() and not (target / 'last-run').exists()
    assert all(sha(target / n) == h for n, h in info['input_sha256'].items())
    assert sha(target / '.runtime.sha256') == info['runtime_manifest_sha256']
    assert {n for n, h in first['input_sha256'].items() if info['input_sha256'][n] != h} == {
        'flexe-agon-emulator', 'sdcard/rally25/review.txt'}
    assert info['input_sha256']['review_custody.py'] == sha(HERE / 'review_custody.py')
    test_results = {}
    with tempfile.TemporaryDirectory(prefix='custody-test-', dir=HERE / '.work') as temporary:
        profile = Path(temporary).resolve()
        original = dict(owner='rally', profile=str(profile), lease='0' * 32, generation=1)
        test_results['missing_file'] = refuses(lambda: custody.check(profile, lambda _: original))
        custody.save(profile, original)
        assert stat.S_IMODE((profile / custody.FILENAME).stat().st_mode) == 0o600
        assert custody.check(profile, lambda token: original) == original
        test_results['matching_owner_profile_uuid'] = True
        for field, value in [('owner', 'golem'), ('profile', str(profile / 'other')), ('lease', 'invalid')]:
            changed = dict(original, **{field: value})
            test_results['stored_wrong_' + field] = refuses(lambda: custody.save(profile, changed))
            assert json.loads((profile / custody.FILENAME).read_text()) == original
            (profile / custody.FILENAME).write_text(json.dumps(changed))
            test_results['file_wrong_' + field] = refuses(lambda: custody.check(profile, lambda _: original))
            custody.save(profile, original)
        for field, value in [('owner', 'golem'), ('profile', str(profile / 'other')), ('lease', '1' * 32)]:
            changed = dict(original, **{field: value})
            test_results['live_wrong_' + field] = refuses(lambda: custody.check(profile, lambda _: changed))
        def stale(_):
            raise ValueError('custody is stale or its live ownership cannot be verified')
        test_results['stale_checkout'] = refuses(lambda: custody.check(profile, stale))
    assert all(test_results.values())
    wrapper = (target / 'flexe-agon-emulator').read_text()
    assert 'RALLY_ORYX_LEASE' not in wrapper and 'review_custody.py" check' in wrapper
    assert wrapper.index('review_custody.py" check') < wrapper.index('run_root=')
    assert 'export SDL_AUDIODRIVER=dummy' in wrapper
    assert 'export SDL_VIDEODRIVER=dummy' not in wrapper
    subprocess.run(['bash', '-n', str(target / 'flexe-agon-emulator')], check=True)
    tool = canonical()
    tool.name_flexe_profile(target)
    tool.verify_profile_executables(target / 'flexe-agon-emulator', target / 'flexe-agon-emulator.bin')
    guide = (target / 'sdcard/rally25/review.txt').read_text().splitlines()
    assert len(guide) == 20 and max(map(len, guide)) <= 39
    assert 'Type DIR; close and report in Golem.' in guide
    assert 'If stuck, close and report in Golem.' in guide
    with tarfile.open(HERE / '.work/PROFILE.tar.gz') as bundle:
        members = bundle.getmembers()
        assert len(members) == 25
        assert not any(custody.FILENAME in m.name for m in members)
        for m in members:
            assert m.isfile() and bundle.extractfile(m).read() == (target / m.name).read_bytes()
    subprocess.run(['git', 'check-ignore', '-q', str(target / custody.FILENAME)], cwd=ROOT, check=True)
    # Preserve the entire original preparation and its inherited proof.
    frozen = json.loads((ORIGINAL / 'READINESS-FREEZE.json').read_text())
    for base, entries in [(ORIGINAL, frozen['files']), (ROOT, frozen['project_dependencies'])]:
        for n, h in entries.items():
            assert sha(base / n) == h, n
    proof = dict(passed=True, profile_inputs=24, archive_members=25,
        custody_tests=test_results, custody_mode='0600', custody_ignored=True,
        custody_in_archive=False, custody_populated=False, wrapper_invoked=False,
        canonical_preflight=True, instruction_report_destination='Golem',
        original_preparation_preserved=True, game_runtime_changed=False,
        ssh_invocations=0, emulator_processes=0)
    (HERE / 'DEVICE-FREE-CHECK.json').write_text(json.dumps(proof, indent=2) + '\n')
    print(json.dumps(proof, indent=2))


if __name__ == '__main__':
    check()
