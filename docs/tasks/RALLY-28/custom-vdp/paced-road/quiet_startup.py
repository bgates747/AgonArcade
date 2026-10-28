"""Blank the startup-only status line in human review copies, preserving tape bytes."""
from pathlib import Path
import argparse
import hashlib
import json
import shutil

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[4]
STATUS = b'30-Hz target / foreground fixture\r\n'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()


def blank_status(fixture):
    artwork = fixture / 'artwork.vdu'
    metadata = fixture / 'expected.json'
    data = artwork.read_bytes()
    expected = json.loads(metadata.read_text())
    assert expected['files']['artwork.vdu'] == sha(artwork), 'Artwork pin mismatch'
    assert data.count(STATUS) == 1, 'Expected exactly one original startup status line'
    # Spaces keep the external-stream length and cursor movement unchanged.
    # Both pages already have a blank third row after the initial clear.
    quiet = data.replace(STATUS, b' ' * (len(STATUS) - 2) + b'\r\n', 1)
    assert len(quiet) == len(data) and STATUS not in quiet
    artwork.write_bytes(quiet)
    expected['files']['artwork.vdu'] = sha(artwork)
    metadata.write_text(json.dumps(expected, indent=2) + '\n')


def patch_profiles(names):
    profiles = [ROOT / '.emulator' / name for name in names]
    # Refuse a running review profile; unrelated project sessions are untouched.
    for process in Path('/proc').glob('[0-9]*'):
        try:
            cwd = (process / 'cwd').resolve()
            command = (process / 'cmdline').read_bytes()
        except (OSError, RuntimeError):
            continue
        for profile in profiles:
            assert cwd != profile and str(profile).encode() not in command, f'Profile is running: {profile}'
    snapshots = {}
    for profile in profiles:
        assert profile.parent == ROOT / '.emulator' and profile.name.startswith('rally28-')
        pins = {n: h for h, n in (line.split('  ', 1) for line in
                                (profile / '.runtime.sha256').read_text().splitlines())}
        assert all(sha(profile / n) == h for n, h in pins.items()), f'Profile pin mismatch: {profile}'
        assert (profile / 'sdcard/rally25/artwork.vdu').read_bytes().count(STATUS) == 1
        snapshots[profile.name] = pins
    result = {}
    for profile in profiles:
        pins = snapshots[profile.name]
        before_files = {str(p.relative_to(profile)): sha(p) for p in profile.rglob('*') if p.is_file()}
        backup = HERE / '.work/review-startup-backup' / profile.name
        assert not backup.exists(), f'Backup already exists: {backup}'
        for name in ('sdcard/rally25/artwork.vdu', 'sdcard/rally25/expected.json', '.runtime.sha256'):
            target = backup / name
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(profile / name, target)
        blank_status(profile / 'sdcard/rally25')
        actual = {n: sha(profile / n) for n in pins}
        (profile / '.runtime.sha256').write_text(''.join(h + '  ' + n + '\n' for n, h in actual.items()))
        after_files = {str(p.relative_to(profile)): sha(p) for p in profile.rglob('*') if p.is_file()}
        changes = sorted(n for n in before_files if before_files[n] != after_files[n])
        assert set(before_files) == set(after_files)
        assert set(changes) == {'sdcard/rally25/artwork.vdu', 'sdcard/rally25/expected.json', '.runtime.sha256'}
        assert all(sha(profile / n) == h for n, h in actual.items())
        result[profile.name] = dict(profile=str(profile), changed_files=changes,
            before_sha256=pins, after_sha256=actual, original_backup=str(backup),
            artwork_bytes=(profile / 'sdcard/rally25/artwork.vdu').stat().st_size,
            script_and_driver_unchanged=True, existing_outputs_unchanged=True,
            emulator_launched=False)
    (HERE / 'REVIEW-STARTUP.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(dict(profiles=len(result), startup_status_blanked=True, emulator_launched=False)))


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('profiles', nargs='+')
    patch_profiles(parser.parse_args().profiles)
