"""Prepare one new stopped observer profile on Oryx; never execute it."""
from pathlib import Path
import hashlib
import importlib.util
import json
import shutil
import socket
import subprocess

HERE = Path(__file__).resolve().parent
START = HERE.parent
HUD = START.parent
CUSTOM = HUD.parents[1]
ROOT = CUSTOM.parents[3]
PROFILE = ROOT/'.emulator/rally28-hz60-startobs01-control'
CANDIDATE = ROOT.parent/'flexe-agon-emulator/build/fx114/candidate-r02/flexe-agon-emulator'
FRONTEND = '7e7d0e1bc89af72bde7ffbd6c06446aaefda4d1803f89eb1faf3167307ee1e01'
sha = lambda p: hashlib.sha256(Path(p).read_bytes()).hexdigest()


def stage():
    assert socket.gethostname() == 'oryx-linuxlite'
    assert not PROFILE.exists(), 'Preserve every existing profile'
    assert not (HERE/'PROFILE.json').exists(), 'Preserve the original staging receipt'
    assert CANDIDATE.stat().st_size == 1954496 and sha(CANDIDATE) == FRONTEND
    application = json.loads((START/'APPLICATION-FREEZE.json').read_text())
    for name, wanted in application['files'].items():
        assert sha(START/name) == wanted, name
    for name, wanted in application['dependencies'].items():
        mapped = ROOT/Path(name).relative_to('/Agon/mystuff/AgonArcade')
        assert sha(mapped) == wanted, name
    old = json.loads((HUD/'PROFILES-hudsmoke01.json').read_text())['control']
    source = Path(old['profile'])
    assert all(sha(source/n) == h for n, h in old['input_sha256'].items())
    metadata = ('.mos-release', '.mos-release.sha256', '.bespoke-vdp-profile')
    assert all((source/n).is_file() for n in metadata)
    wrapper = (source/'flexe-agon-emulator').read_text()
    assert wrapper.count('export SDL_AUDIODRIVER=dummy') == 1
    wrapper = wrapper.replace('export SDL_AUDIODRIVER=dummy',
                              'export SDL_AUDIODRIVER=dummy\nexport SDL_VIDEODRIVER=dummy')
    anchor = 'profile_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"'
    assert wrapper.count(anchor) == 1
    wrapper = wrapper.replace(anchor, anchor+'\nexport FLEXE_UART_OBSERVER_OUTPUT="${profile_dir}/last-run/sender-progress.jsonl"\n'
                              'if [[ -e "$FLEXE_UART_OBSERVER_OUTPUT" ]]; then\n'
                              '    echo "Observer output exists; preserve this profile and stop" >&2\n'
                              '    exit 1\nfi')
    engine = 'export AGON_FLEXE_ENGINE="${AGON_FLEXE_ENGINE:-jit}"'
    assert wrapper.count(engine) == 1
    wrapper = wrapper.replace(engine, 'export AGON_FLEXE_ENGINE=jit')
    PROFILE.mkdir(parents=True)
    for name in ('mos_platform.bin', 'mos_platform.map', 'flexe-vdp.so',
                 'esp32-firmware.bin', 'esp32-firmware.elf', 'sdcard/autoexec.txt', *metadata):
        target = PROFILE/name
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(source/name, target)
    shutil.copyfile(CANDIDATE, PROFILE/'flexe-agon-emulator.bin')
    (PROFILE/'flexe-agon-emulator.bin').chmod(0o755)
    (PROFILE/'flexe-agon-emulator').write_text(wrapper)
    (PROFILE/'flexe-agon-emulator').chmod(0o755)
    for path in (START/'fixture').iterdir():
        target = PROFILE/'sdcard/rally25'/path.name
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(path, target)
    spec = importlib.util.spec_from_file_location('canonical_flexe', ROOT.parent/'agon-dev-env/scripts/flexe_profile.py')
    naming = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(naming)
    naming.name_flexe_profile(PROFILE)
    subprocess.run(['bash', '-n', str(PROFILE/'flexe-agon-emulator')], check=True)
    paths = [p for p in PROFILE.rglob('*') if p.is_file()]
    pins = {str(p.relative_to(PROFILE)): sha(p) for p in sorted(paths)}
    (PROFILE/'.runtime.sha256').write_text(''.join(h+'  '+n+'\n' for n, h in pins.items()))
    # Device-free file/launcher checks only: do not execute the frontend.
    subprocess.run(['sha256sum', '--check', '--status', '.runtime.sha256'], cwd=PROFILE, check=True)
    assert pins['flexe-vdp.so'] == old['input_sha256']['flexe-vdp.so']
    assert pins['esp32-firmware.bin'] == old['input_sha256']['esp32-firmware.bin']
    assert all(pins['sdcard/rally25/'+n] == h for n, h in
               json.loads((START/'PREPARATION.json').read_text())['files'].items())
    record = dict(profile=str(PROFILE), input_sha256=pins, stopped=True,
                  frontend_changed_from=old['input_sha256']['flexe-agon-emulator.bin'],
                  frontend_changed_to=FRONTEND, old_backend_firmware_unchanged=True,
                  video_driver='dummy', audio_driver='dummy', engine='jit',
                  observer_output=str(PROFILE/'last-run/sender-progress.jsonl'),
                  application_freeze_sha256=sha(START/'APPLICATION-FREEZE.json'),
                  canonical_naming_called=True, launcher_syntax_and_hash_checks=True,
                  original_profile_inputs_reverified=len(old['input_sha256']),
                  last_run_absent=not (PROFILE/'last-run').exists(),
                  target_executed=False, power_settings_changed=False)
    (HERE/'PROFILE.json').write_text(json.dumps(record, indent=2)+'\n')
    print(json.dumps({k: v for k, v in record.items() if k != 'input_sha256'}, indent=2))


if __name__ == '__main__':
    stage()
