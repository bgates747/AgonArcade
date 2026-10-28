"""Stage fresh stopped Oryx profiles using pinned runtime and explicit fixtures."""
import argparse
import importlib.util
import json
from pathlib import Path
import shutil
import subprocess
from fixtures import HERE, ROOT, PRIOR, sha


def stage(campaign, cases, quiet=False):
    assert campaign.isalnum()
    source = ROOT / '.emulator/rally25-native-review01'
    pins = {name: digest for digest, name in
            (line.split('  ', 1) for line in (source / '.runtime.sha256').read_text().splitlines())}
    expected = json.loads((PRIOR / 'ORYX-INPUTS.json').read_text())['verified_files']
    assert pins == expected and all(sha(source / name) == digest for name, digest in pins.items()), 'Runtime pin mismatch'
    all_cases = json.loads((HERE / 'FIXTURES.json').read_text())
    assert set(cases) <= set(all_cases)
    # No partial profile creation when any input is absent or changed.
    for name in cases:
        fixture = HERE / all_cases[name]['directory']
        assert all(sha(fixture / n) == h for n, h in all_cases[name]['files'].items()), name
        assert not (ROOT / '.emulator' / ('rally28-hz60-' + campaign + '-' + name)).exists()
    canonical = ROOT.parent / 'agon-dev-env/scripts/flexe_profile.py'
    spec = importlib.util.spec_from_file_location('canonical_flexe', canonical)
    naming = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(naming)
    result = {}
    for name in cases:
        profile = ROOT / '.emulator' / ('rally28-hz60-' + campaign + '-' + name)
        profile.mkdir(parents=True)
        for path in pins:
            target = profile / path
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(source / path, target)
        for path in ('.mos-release', '.mos-release.sha256', '.bespoke-vdp-profile'):
            shutil.copyfile(source / path, profile / path)
        fixture = HERE / all_cases[name]['directory']
        app = profile / 'sdcard/rally25'
        for n in all_cases[name]['files']:
            shutil.copyfile(fixture / n, app / n)
        if quiet:
            import sys
            sys.path.insert(0, str(PRIOR))
            from quiet_startup import blank_status
            blank_status(app)
        launcher = profile / 'flexe-agon-emulator'
        text = launcher.read_text().replace('FSIM', 'Rally-28 throughput')
        assert 'export SDL_AUDIODRIVER=dummy' in text
        launcher.write_text(text)
        launcher.chmod(0o755)
        (profile / 'flexe-agon-emulator.bin').chmod(0o755)
        naming.name_flexe_profile(profile)
        subprocess.run(['bash', '-n', str(launcher)], check=True)
        # Include any additional fixture file, not only the old profile's list.
        paths = list(pins)
        paths += ['sdcard/rally25/' + n for n in all_cases[name]['files']
                  if 'sdcard/rally25/' + n not in paths]
        actual = {n: sha(profile / n) for n in paths}
        (profile / '.runtime.sha256').write_text(''.join(h + '  ' + n + '\n' for n, h in actual.items()))
        result[name] = dict(profile=str(profile), input_sha256=actual, stopped=True,
                            sound_driver='dummy', startup_status_blanked=quiet,
                            power_settings_changed=False)
    (HERE / ('PROFILES-' + campaign + '.json')).write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(dict(profiles=len(result), campaign=campaign, emulator_launched=False)))


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--campaign', required=True)
    parser.add_argument('--cases', nargs='+', required=True)
    parser.add_argument('--quiet', action='store_true')
    options = parser.parse_args()
    stage(options.campaign, options.cases, options.quiet)
