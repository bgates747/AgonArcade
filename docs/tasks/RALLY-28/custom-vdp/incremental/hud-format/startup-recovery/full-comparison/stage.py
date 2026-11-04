"""Stage exactly four fresh stopped ABBA profiles from qualified smoke runtimes."""
from pathlib import Path
import hashlib
import importlib.util
import json
import shutil
import socket
import subprocess

HERE=Path(__file__).resolve().parent
HUD=HERE.parent.parent
CUSTOM=HUD.parents[1]
ROOT=CUSTOM.parents[3]
ROLES={'control1':'control','cached1':'cached','cached2':'cached','control2':'control'}
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()


def stage():
    assert socket.gethostname()=='oryx-linuxlite'
    assert not (HERE/'PROFILES.json').exists()
    sources=json.loads((HERE.parent/'hud-smoke/PROFILES.json').read_text())
    fixtures=json.loads((HERE/'FIXTURES.json').read_text())
    targets={case:ROOT/'.emulator'/('rally28-hz60-hud900abba01-'+case) for case in ROLES}
    assert all(not p.exists() for p in targets.values())
    for role,info in sources.items():
        source=Path(info['profile']);assert all(sha(source/n)==h for n,h in info['input_sha256'].items())
        assert all(sha(HUD/fixtures[role]['directory']/n)==h for n,h in fixtures[role]['files'].items())
    spec=importlib.util.spec_from_file_location('canonical_flexe',ROOT.parent/'agon-dev-env/scripts/flexe_profile.py')
    naming=importlib.util.module_from_spec(spec);spec.loader.exec_module(naming)
    result={}
    for case,profile in targets.items():
        role=ROLES[case];source=Path(sources[role]['profile']);profile.mkdir(parents=True)
        for name in sources[role]['input_sha256']:
            target=profile/name;target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(source/name,target)
        for name in fixtures[role]['files']:
            shutil.copyfile(HUD/fixtures[role]['directory']/name,profile/'sdcard/rally25'/name)
        for name in ('flexe-agon-emulator','flexe-agon-emulator.bin'):(profile/name).chmod(0o755)
        naming.name_flexe_profile(profile)
        subprocess.run(['bash','-n',str(profile/'flexe-agon-emulator')],check=True)
        pins={str(p.relative_to(profile)):sha(p) for p in sorted(profile.rglob('*')) if p.is_file()}
        (profile/'.runtime.sha256').write_text(''.join(h+'  '+n+'\n' for n,h in pins.items()))
        subprocess.run(['sha256sum','--check','--status','.runtime.sha256'],cwd=profile,check=True)
        assert all(pins['sdcard/rally25/'+n]==h for n,h in fixtures[role]['files'].items())
        result[case]=dict(role=role,profile=str(profile),input_sha256=pins,stopped=True,
            video_driver='dummy',audio_driver='dummy',engine='jit',canonical_naming_called=True,
            observer_output=str(profile/'last-run/sender-progress.jsonl'),target_executed=False,power_settings_changed=False)
    for case,info in result.items():
        changes=[n for n,h in result['control1']['input_sha256'].items() if h!=info['input_sha256'][n]]
        assert set(changes)==({'sdcard/rally25/probe.bin','sdcard/rally25/expected.json'} if info['role']=='cached' else set())
    (HERE/'PROFILES.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(dict(passed=True,order=list(ROLES),profiles=4,emulator_executed=False,power_settings_changed=False),indent=2))


if __name__=='__main__':stage()
