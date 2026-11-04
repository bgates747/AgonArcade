"""Offline Pi assembly from retained artifacts; never invoke an emulator."""
from pathlib import Path
import json
import shutil
import subprocess
import tarfile
from common import HERE, FULL, HUD, ROOT, BACKEND, FRONTEND, PROFILE_NAME, sha, load

FLEXE = ROOT.parent / 'flexe-agon-emulator'


def member(archive, name, target, expected=None):
    with tarfile.open(archive) as source:
        item = source.getmember(name)
        assert item.isfile()
        data = source.extractfile(item).read()
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes(data)
    if expected is not None:
        assert sha(target) == expected, name
    return dict(archive=str(archive), archive_sha256=sha(archive), member=name,
                bytes=len(data), sha256=sha(target))


def prepare():
    assert not (HERE / 'PROFILE.json').exists(), 'Preserve preparation'
    target = HERE / '.work/stopped-profile'
    assert not target.exists()
    old = json.loads((FULL / 'PROFILES.json').read_text())['cached1']
    pins = dict(old['input_sha256'])
    pins['flexe-vdp.so'] = BACKEND
    target.mkdir(parents=True)
    origins = {}
    for name in ('artwork.vdu', 'assets.vdu', 'common.vdu', 'config.bin', 'expected.json',
                 'module.vdu', 'motion.bin', 'native.vdu', 'presentation.vdu', 'probe.bin', 'run.txt'):
        source = HUD / 'fixtures/cached' / name
        dest = target / 'sdcard/rally25' / name
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(source, dest)
        origins['sdcard/rally25/' + name] = str(source.relative_to(ROOT))
    local_runtime = ROOT / '.emulator/rally28-affine-pi-full01'
    sources = {
        'mos_platform.bin': local_runtime / 'mos_platform.bin',
        'mos_platform.map': local_runtime / 'mos_platform.map',
        '.mos-release': local_runtime / '.mos-release',
        '.mos-release.sha256': local_runtime / '.mos-release.sha256',
        '.bespoke-vdp-profile': local_runtime / '.bespoke-vdp-profile',
        'esp32-firmware.bin': ROOT / 'docs/tasks/RALLY-28/custom-vdp/paced-road/control/fixture/vdp_rally.bin',
        'esp32-firmware.elf': ROOT.parent / 'golem/docs/tasks/GOLEM-044/app/build/runtime-inputs/firmware.elf',
        'flexe-agon-emulator': HERE.parent / 'observer-integration/STAGED-LAUNCHER.sh',
    }
    for name, source in sources.items():
        shutil.copyfile(source, target / name)
        origins[name] = dict(source=str(source), sha256=sha(source))
    # Reconstruct the original isolated profile boot file from its recorded
    # producer, then require its exact old hash. No existing autoexec is edited.
    (target / 'sdcard/autoexec.txt').write_bytes(b'SET KEYBOARD 1\r\ncd /rally25\r\nload probe.bin\r\nrun .\r\n')
    origins['sdcard/autoexec.txt'] = 'Exact original bytes from RALLY-25/native-demo/profile.py, verified by old pin'
    frontend_archive = FLEXE / 'build/fx114/preparation-r02.tar'
    backend_archive = FLEXE / 'build/fx119/preparation-r03-complete.tar'
    origins['flexe-agon-emulator.bin'] = member(frontend_archive, 'candidate-r02/flexe-agon-emulator', target / 'flexe-agon-emulator.bin', FRONTEND)
    origins['flexe-vdp.so'] = member(backend_archive, 'fx119/baseline-r01/flexe-vdp.so', target / 'flexe-vdp.so', BACKEND)
    evidence = HERE / 'producer-evidence'
    for name in ['fx119/baseline-r01/receipt.json', 'fx119/baseline-r01/dependency-closure.json',
                 'source-closure-r02/closure-manifest.json']:
        member(backend_archive, name, evidence / Path(name).name)
    member(backend_archive, 'fx119/baseline-r01/libxtensa-emu-lib.a', HERE / '.work/libxtensa-emu-lib.a',
           '93af5e6655c90d43b919bf78bb6fdcb7908cff6ce7d8133442c869ce1fae9df9')
    for name in ('flexe-agon-emulator', 'flexe-agon-emulator.bin'):
        (target / name).chmod(0o755)
    for name, expected in pins.items():
        assert sha(target / name) == expected, name
    naming = load('canonical_flexe', ROOT.parent / 'agon-dev-env/scripts/flexe_profile.py')
    naming.name_flexe_profile(target)
    assert all(sha(target / n) == h for n, h in pins.items())
    (target / '.runtime.sha256').write_text(''.join(h + '  ' + n + '\n' for n, h in pins.items()))
    subprocess.run(['bash', '-n', str(target / 'flexe-agon-emulator')], check=True)
    subprocess.run(['sha256sum', '--check', '--status', '.runtime.sha256'], cwd=target, check=True)
    with tarfile.open(HERE / '.work/CANDIDATE.tar.gz', 'w:gz') as archive:
        for p in sorted(target.rglob('*')):
            if p.is_file():
                archive.add(p, arcname=str(p.relative_to(target)), recursive=False)
    record = dict(profile='/home/smith/Agon/mystuff/AgonArcade/.emulator/' + PROFILE_NAME,
                  local_prepared_profile='.work/stopped-profile', role='cached',
                  input_sha256=pins, runtime_manifest_sha256=sha(target / '.runtime.sha256'),
                  changed_input_files=[n for n in pins if pins[n] != old['input_sha256'][n]],
                  old_profile=old['profile'], old_backend=old['input_sha256']['flexe-vdp.so'],
                  new_backend=BACKEND, frames=900, physics_ticks=3600, warm_frames=2,
                  video_driver='dummy', audio_driver='dummy', engine='jit',
                  canonical_naming_called=True, prepared_locally_stopped=True,
                  deployed=False, target_executed=False,
                  observer_output='/home/smith/Agon/mystuff/AgonArcade/.emulator/' + PROFILE_NAME + '/last-run/sender-progress.jsonl')
    assert record['changed_input_files'] == ['flexe-vdp.so']
    (HERE / 'PROFILE.json').write_text(json.dumps(record, indent=2) + '\n')
    (HERE / 'ORIGINS.json').write_text(json.dumps(origins, indent=2) + '\n')
    print(json.dumps(record, indent=2))


if __name__ == '__main__':
    prepare()
