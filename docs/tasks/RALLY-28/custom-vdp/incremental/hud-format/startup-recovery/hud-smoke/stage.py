"""Create only two fresh stopped profiles from the qualified common runtime."""
from pathlib import Path
import hashlib
import importlib.util
import json
import shutil
import socket
import subprocess

HERE = Path(__file__).resolve().parent
HUD = HERE.parent.parent
CUSTOM = HUD.parents[1]
ROOT = CUSTOM.parents[3]
INTEGRATION = HERE.parent/'observer-integration'
sha = lambda p: hashlib.sha256(Path(p).read_bytes()).hexdigest()


def stage():
    assert socket.gethostname() == 'oryx-linuxlite'
    assert not (HERE/'PROFILES.json').exists()
    source_info = json.loads((INTEGRATION/'PROFILE.json').read_text())
    source = Path(source_info['profile'])
    assert all(sha(source/n) == h for n, h in source_info['input_sha256'].items())
    assert sha(source/'flexe-agon-emulator.bin') == '7e7d0e1bc89af72bde7ffbd6c06446aaefda4d1803f89eb1faf3167307ee1e01'
    registry = json.loads((HERE/'FIXTURES.json').read_text())
    targets = {case:ROOT/'.emulator'/('rally28-hz60-hudsmoke02-'+case) for case in ('control','cached')}
    assert all(not p.exists() for p in targets.values())
    for case, item in registry.items():
        assert all(sha(HUD/item['directory']/n) == h for n, h in item['files'].items())
    spec = importlib.util.spec_from_file_location('canonical_flexe', ROOT.parent/'agon-dev-env/scripts/flexe_profile.py')
    naming = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(naming)
    result = {}
    for case, profile in targets.items():
        profile.mkdir(parents=True)
        for name in source_info['input_sha256']:
            target = profile/name
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(source/name, target)
        for name in registry[case]['files']:
            shutil.copyfile(HUD/registry[case]['directory']/name, profile/'sdcard/rally25'/name)
        for name in ('flexe-agon-emulator','flexe-agon-emulator.bin'):
            (profile/name).chmod(0o755)
        naming.name_flexe_profile(profile)
        subprocess.run(['bash','-n',str(profile/'flexe-agon-emulator')],check=True)
        pins = {str(p.relative_to(profile)):sha(p) for p in sorted(profile.rglob('*')) if p.is_file()}
        (profile/'.runtime.sha256').write_text(''.join(h+'  '+n+'\n' for n,h in pins.items()))
        subprocess.run(['sha256sum','--check','--status','.runtime.sha256'],cwd=profile,check=True)
        assert all(pins['sdcard/rally25/'+n] == h for n,h in registry[case]['files'].items())
        assert not (profile/'last-run').exists()
        result[case] = dict(profile=str(profile),input_sha256=pins,stopped=True,
                            video_driver='dummy',audio_driver='dummy',engine='jit',
                            observer_output=str(profile/'last-run/sender-progress.jsonl'),
                            canonical_naming_called=True,target_executed=False,power_settings_changed=False)
    differences = [n for n,h in result['control']['input_sha256'].items()
                   if h != result['cached']['input_sha256'][n]]
    assert set(differences) == {'sdcard/rally25/probe.bin','sdcard/rally25/expected.json'}
    (HERE/'PROFILES.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(dict(passed=True,profiles=list(targets),
                         differences=differences,emulator_executed=False,power_settings_changed=False),indent=2))


if __name__ == '__main__':
    stage()
