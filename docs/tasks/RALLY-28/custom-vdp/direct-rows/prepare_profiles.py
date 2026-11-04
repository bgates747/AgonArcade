"""Prepare fresh local stopped silent profiles; no emulator or remote access."""
from pathlib import Path
import hashlib
import importlib.util
import json
import shutil
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[4]
SEED = HERE.parent / 'incremental/hud-format/startup-recovery/maintained-runtime/.work/stopped-profile'
OWNER = Path('/Agon/mystuff/agon-vdplet/build/vdpl018-wolf-rows-r01/repair')
EXPECTED = {'firmware.bin':'a50eb23acf6b3edfb44d3c1bb44858a213be696d68c06a696da7767170ac6f9a',
            'firmware.elf':'50e569cff77883e062603317441a30a90e7057e188a792005d2589f1a6c92785'}
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
ORDER = ['bitmap60', 'rows60', 'bitmap900a', 'rows900a', 'rows900b', 'bitmap900b']


def main():
    assert all(sha(OWNER/name) == digest for name, digest in EXPECTED.items())
    spec = importlib.util.spec_from_file_location('rows_profile_preflight',
                  Path('/Agon/mystuff/agon-dev-env/scripts/flexe_profile.py'))
    helper = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(helper)
    old = dict(line.split('  ', 1)[::-1] for line in (SEED / '.runtime.sha256').read_text().splitlines())
    assert all(sha(SEED/name) == digest for name, digest in old.items())
    runtime_names = [n for n in old if not n.startswith('sdcard/rally25/')]
    fixtures = json.loads((HERE / 'FIXTURES.json').read_text())
    result = {}
    for case in ORDER:
        kind = case.rstrip('ab')
        target = ROOT / '.emulator' / ('rally28-hz60-rows01-' + case)
        assert not target.exists(), target
        target.mkdir(parents=True)
        for name in runtime_names:
            dest = target / name
            dest.parent.mkdir(parents=True, exist_ok=True)
            source = OWNER / ('firmware.bin' if name == 'esp32-firmware.bin' else 'firmware.elf') if name in (
                      'esp32-firmware.bin', 'esp32-firmware.elf') else SEED/name
            shutil.copyfile(source, dest)
        app = target / 'sdcard/rally25'
        app.mkdir(parents=True)
        for name, digest in fixtures[kind].items():
            source = HERE / 'fixtures' / kind / name
            assert sha(source) == digest
            shutil.copyfile(source, app/name)
        for name in ('flexe-agon-emulator', 'flexe-agon-emulator.bin'):
            (target / name).chmod(0o755)
        helper.verify_profile_executables(target/'flexe-agon-emulator', target/'flexe-agon-emulator.bin')
        subprocess.run(['bash', '-n', str(target/'flexe-agon-emulator')], check=True)
        pins = {str(p.relative_to(target)):sha(p) for p in sorted(target.rglob('*')) if p.is_file()}
        (target/'.runtime.sha256').write_text(''.join(h+'  '+n+'\n' for n,h in pins.items()))
        result[case] = dict(profile=str(target).replace('/Agon/mystuff/', '/home/smith/Agon/mystuff/', 1),
                            local_profile=str(target), input_sha256=pins,
                            runtime_manifest_sha256=sha(target/'.runtime.sha256'), stopped=True,
                            video_driver='dummy', audio_driver='dummy', frames=60 if '60' in case else 900)
    (HERE/'PROFILES-rows01.json').write_text(json.dumps(result, indent=2)+'\n')
    print('Six stopped profiles prepared; no emulator started.')


if __name__ == '__main__':
    main()
