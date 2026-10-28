"""Create one new Oryx Wolf3D profile from copies of existing pinned artifacts."""
from pathlib import Path
import hashlib
import json
import runpy
import shlex
import shutil
import socket
import subprocess
import tarfile

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[4]
PROFILE = ROOT.parent / 'Wolf3dOrig/.emulator/fps01'


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def stage():
    assert socket.gethostname() == 'oryx-linuxlite'
    original = ROOT / '.emulator/rally25-native-review01'
    old_pins = dict((name, digest) for digest, name in
        (line.split('  ', 1) for line in (original / '.runtime.sha256').read_text().splitlines()))
    assert all(sha(original / name) == digest for name, digest in old_pins.items())
    payload = HERE / '.work/payload'
    payload.mkdir(parents=True, exist_ok=False)
    with tarfile.open(HERE / '.work/payload.tar.gz') as archive:
        for member in archive.getmembers():
            assert member.isfile() and not Path(member.name).is_absolute() and '..' not in Path(member.name).parts
        archive.extractall(payload, filter='data')
    expected = json.loads((HERE / 'INPUTS.json').read_text())
    assert all(sha(payload / n) == h for n, h in expected['payload_sha256'].items())
    PROFILE.mkdir(parents=True, exist_ok=False)
    for source, destination in [('flexe-agon-emulator.bin', 'fab-agon-emulator.bin'),
        ('flexe-vdp.so', 'flexe-vdp.so'), ('mos_platform.bin', 'mos_platform.bin'),
        ('mos_platform.map', 'mos_platform.map'), ('.mos-release', '.mos-release'),
        ('.mos-release.sha256', '.mos-release.sha256')]:
        shutil.copyfile(original / source, PROFILE / destination)
    (PROFILE / 'fab-agon-emulator.bin').chmod(0o755)
    for n in ('esp32-firmware.bin', 'esp32-firmware.elf'):
        shutil.copyfile(payload / n, PROFILE / n)
    shutil.copytree(payload / 'app', PROFILE / 'sdcard/wolf3d')
    (PROFILE / 'sdcard/autoexec.txt').write_bytes(
        b'SET KEYBOARD 1\r\ncd /wolf3d\r\nload wolf3d.bin\r\nrun\r\n')
    (PROFILE / '.bespoke-vdp-profile').write_text('flexe-vdp.so\n')
    (PROFILE / '.runtime.sha256').write_text(''.join(
        sha(PROFILE / n) + '  ' + n + '\n' for n in ('fab-agon-emulator.bin', 'flexe-vdp.so')))
    canonical = runpy.run_path(str(ROOT.parent / 'agon-dev-env/scripts/setup_emulator.py'))
    canonical['write_profile_launcher'](PROFILE, strict_bespoke=True)
    wrapper = PROFILE / 'fab-agon-emulator'
    text = wrapper.read_text().replace('FSIM', 'Wolf3D benchmark')
    text = text.replace('set -euo pipefail\n',
        'set -euo pipefail\nexport SDL_VIDEODRIVER=dummy\nexport SDL_AUDIODRIVER=dummy\n')
    anchor = 'vdp_name='
    offset = text.index(anchor)
    text = text[:offset] + '''if [[ "$(< /sys/devices/system/cpu/cpufreq/boost)" != 0 ]]; then
    echo 'Wolf3D unattended benchmark requires CPU boost disabled' >&2
    exit 1
fi
export AGON_FLEXE_FIRMWARE="$profile_dir/esp32-firmware.bin"
export AGON_FLEXE_ELF="$profile_dir/esp32-firmware.elf"
export AGON_FLEXE_ENGINE=jit
export AGON_FLEXE_ARTIFACTS="$profile_dir/last-run"
mkdir -p "$AGON_FLEXE_ARTIFACTS"
''' + text[offset:]
    wrapper.write_text(text)
    runpy.run_path(str(ROOT.parent / 'agon-dev-env/scripts/flexe_profile.py'))['name_flexe_profile'](PROFILE)
    flags = shlex.split(subprocess.check_output(['pkg-config', '--cflags', '--libs', 'sdl3'], text=True))
    subprocess.run(['cc', '-shared', '-fPIC', '-O2', str(HERE / 'input.c'), '-o',
        str(PROFILE / 'input.so'), *flags, '-ldl'], check=True)
    (PROFILE / 'key-events.txt').write_text('')
    files = {str(p.relative_to(PROFILE)): sha(p) for p in PROFILE.rglob('*')
        if p.is_file() and p.name not in ('.runtime.sha256', 'key-events.txt')}
    (PROFILE / '.runtime.sha256').write_text(''.join(h + '  ' + n + '\n' for n, h in files.items()))
    subprocess.run(['bash', '-n', str(PROFILE / 'flexe-agon-emulator')], check=True)
    result = dict(profile=str(PROFILE), inputs_sha256=files, staged=True,
        emulator_launched=False, video_driver='dummy', audio_driver='dummy',
        source_inputs_sha256=expected['source_file_sha256'],
        isolated_state_change=expected['isolated_state_change'])
    (HERE / 'PROFILE.json').write_text(json.dumps(result, indent=2) + '\n')
    print('Staged stopped profile', PROFILE)


if __name__ == '__main__':
    stage()
