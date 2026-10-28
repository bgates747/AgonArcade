"""Copy existing playable Wolf artifacts; never build or mutate that project."""
from pathlib import Path
import hashlib
import json
import shutil
import struct
import tarfile

HERE = Path(__file__).resolve().parent
PROJECT = Path('/Agon/mystuff/Wolf3dOrig')
VDP = Path('/Agon/mystuff/agon-vdp-wolf3d')


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def prepare():
    work = HERE / '.work/payload'
    work.mkdir(parents=True, exist_ok=False)
    deployed = PROJECT / 'agonport/emulator/sdcard/mystuff/Wolf3dOrig'
    sources = {'app/wolf3d.bin': deployed / 'wolf3d.bin',
        'esp32-firmware.bin': VDP / '.pio/build/esp32dev/firmware.bin',
        'esp32-firmware.elf': VDP / '.pio/build/esp32dev/firmware.elf'}
    assert sha(sources['app/wolf3d.bin']) == '4cd70b101282370da113b47b3fadea8309307804747613c886562a25ede91e73'
    assert sha(sources['esp32-firmware.bin']) == sha(PROJECT / 'tgt/vdpwolf.bin')
    for name in ('hud.agnb', 'sfx.agnb', 'shell.agnb'):
        sources['app/' + name] = deployed / name
    for source in sorted((deployed / 'level_00').iterdir()):
        if source.is_file(): sources['app/level_00/' + source.name] = source
    original = {}
    for name, source in sources.items():
        target = work / name
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(source, target)
        original[str(source)] = sha(source)
    state = work / 'app/level_00/state_medium.w3l'
    before = state.read_bytes()
    assert struct.unpack_from('<iiH', before, 16) == (0x198000, 0x2f8000, 0)
    after = bytearray(before)
    struct.pack_into('<iiH', after, 16, 0x1d8000, 0x398000, 0)
    assert [i for i in range(len(before)) if before[i] != after[i]] == [18, 22]
    state.write_bytes(after)
    manifest = dict(source_file_sha256=original,
        payload_sha256={str(p.relative_to(work)): sha(p) for p in work.rglob('*') if p.is_file()},
        application='Previously deployed 105122-byte playable reference, before intermission candidate',
        isolated_state_change=dict(file='app/level_00/state_medium.w3l', offsets=[18, 22],
            before_pose=[25.5, 47.5, 0], after_pose=[29.5, 57.5, 0]),
        source_project_modified=False, firmware_built=False)
    (HERE / 'INPUTS.json').write_text(json.dumps(manifest, indent=2) + '\n')
    with tarfile.open(HERE / '.work/payload.tar.gz', 'w:gz') as archive:
        for p in sorted(work.rglob('*')):
            if p.is_file(): archive.add(p, arcname=str(p.relative_to(work)))
    print('Prepared', len(sources), 'existing files; isolated normal E1L1 spawn; originals preserved')


if __name__ == '__main__':
    prepare()
