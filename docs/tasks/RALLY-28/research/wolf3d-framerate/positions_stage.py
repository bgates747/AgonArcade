"""Copy the unchanged playable profile to the Author's two selected cells."""
from pathlib import Path
import hashlib
import json
import shlex
import shutil
import socket
import struct
import subprocess

HERE = Path(__file__).resolve().parent
CASES = {'center': (34, 33), 'south': (34, 36)}
sha = lambda p: hashlib.sha256(Path(p).read_bytes()).hexdigest()


def stage():
    assert socket.gethostname() == 'oryx-linuxlite'
    original = json.loads((HERE / 'PROFILE.json').read_text())
    source = Path(original['profile'])
    assert all(sha(source / n) == h for n, h in original['inputs_sha256'].items())
    output = HERE / 'positions'
    output.mkdir(exist_ok=False)
    result = {}
    for name, (x, y) in CASES.items():
        profile = source.parent / ('fps02-' + name)
        profile.mkdir(exist_ok=False)
        for filename in original['inputs_sha256']:
            target = profile / filename
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(source / filename, target)
            if filename in ('flexe-agon-emulator', 'flexe-agon-emulator.bin'): target.chmod(0o755)
        state = profile / 'sdcard/wolf3d/level_00/state_medium.w3l'
        before = state.read_bytes()
        offsets = [struct.unpack_from('<H', before, 26 + 2*i)[0] for i in range(7)]
        index = y * 64 + x
        assert before[offsets[6] + index] == 0
        assert not before[offsets[3] + index//8] & (1 << (index%8))
        after = bytearray(before)
        struct.pack_into('<iiH', after, 16, (x<<16) + 32768, (y<<16) + 32768, 0)
        changed = [i for i in range(len(before)) if before[i] != after[i]]
        assert all(16 <= i < 26 for i in changed)
        state.write_bytes(after)
        flags = shlex.split(subprocess.check_output(['pkg-config','--cflags','--libs','sdl3'],text=True))
        subprocess.run(['cc','-shared','-fPIC','-O2',str(HERE/'input-timed.c'),'-o',
            str(profile/'input.so'),*flags,'-ldl','-pthread'],check=True)
        (profile / 'key-events.txt').write_text('')
        pins = {n: sha(profile / n) for n in original['inputs_sha256']}
        differing = [n for n, h in pins.items() if original['inputs_sha256'][n] != h]
        assert set(differing) == {'sdcard/wolf3d/level_00/state_medium.w3l','input.so'}
        (profile/'.runtime.sha256').write_text(''.join(h+'  '+n+'\n' for n,h in pins.items()))
        config = dict(profile=str(profile), tile=[x,y], position=[x+.5,y+.5],
            inputs_sha256=pins, only_changed_files=differing, state_changed_offsets=changed,
            application_assets_firmware_runtime_unchanged=True,
            trace='Host timestamps on existing fputc UART trace; same SDL input model; no game changes',
            video_driver='dummy',audio_driver='dummy',emulator_launched=False)
        (output / ('PROFILE-'+name+'.json')).write_text(json.dumps(config,indent=2)+'\n')
        result[name]=config
    (output/'PROFILES.json').write_text(json.dumps(result,indent=2)+'\n')
    print('Two stopped profiles prepared; only spawn and host timing/input shim differ')


if __name__ == '__main__':
    stage()
