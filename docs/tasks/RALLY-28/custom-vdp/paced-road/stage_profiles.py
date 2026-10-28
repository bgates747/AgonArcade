"""Clone pinned Oryx runtime into fresh, silent, stopped R28 variant profiles."""
from pathlib import Path
import argparse
import hashlib
import importlib.util
import json
import shutil
import subprocess
from quiet_startup import blank_status

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[4]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()


def stage(suffix, only=None, profile_name=None, hide_startup_status=False):
    assert suffix.isalnum(), 'Use a simple new campaign suffix'
    source=ROOT/'.emulator/rally25-native-review01'
    pins={n:h for h,n in (l.split('  ',1) for l in (source/'.runtime.sha256').read_text().splitlines())}
    expected=json.loads((HERE/'ORYX-INPUTS.json').read_text())['verified_files']
    assert pins==expected and all(sha(source/n)==h for n,h in pins.items()),'Reviewed runtime/input changed'
    canonical=ROOT.parent/'agon-dev-env/scripts/flexe_profile.py'
    spec=importlib.util.spec_from_file_location('canonical_flexe',canonical)
    naming=importlib.util.module_from_spec(spec);spec.loader.exec_module(naming)
    builds=json.loads((HERE/'CANDIDATE-BUILD.json').read_text());result={}
    if only:
        assert set(only)<=set(builds),'Unknown candidate'
        builds={n:b for n,b in builds.items() if n in only}
    if profile_name:
        assert len(builds)==1 and Path(profile_name).name==profile_name and profile_name.startswith('rally28-')
    # Validate every source before creating a partial runnable profile.
    for name,build in builds.items():
        fixture=HERE/'.work/candidates'/name/'fixture'
        for n,h in build['fixture_files'].items():
            if not (fixture/n).is_file():
                raise RuntimeError(f'Missing candidate input: {fixture/n}; transfer the complete fixture before staging')
            if sha(fixture/n)!=h:raise RuntimeError(f'Candidate input hash mismatch: {fixture/n}; transfer the pinned fixture')
    for name,build in builds.items():
        profile=ROOT/'.emulator'/(profile_name or ('rally28-native-'+name+'-'+suffix))
        if profile.exists():raise RuntimeError(f'Refusing to replace existing profile: {profile}; choose a fresh suffix')
        profile.mkdir(parents=True)
        for n,h in pins.items():
            p=profile/n;p.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(source/n,p)
        for n in ('.mos-release','.mos-release.sha256','.bespoke-vdp-profile'):
            shutil.copyfile(source/n,profile/n)
        fixture=HERE/'.work/candidates'/name/'fixture'
        for n,h in build['fixture_files'].items():
            assert sha(fixture/n)==h,n
            if n=='run.txt':continue # Existing profile's relative runner stays exact.
            shutil.copyfile(fixture/n,profile/'sdcard/rally25'/n)
        if hide_startup_status:
            blank_status(profile/'sdcard/rally25')
        launcher=profile/'flexe-agon-emulator'
        text=launcher.read_text().replace('FSIM','Rally-28')
        assert 'export SDL_AUDIODRIVER=dummy' in text
        launcher.write_text(text);launcher.chmod(0o755)
        (profile/'flexe-agon-emulator.bin').chmod(0o755)
        actual={n:sha(profile/n) for n in pins}
        (profile/'.runtime.sha256').write_text(''.join(h+'  '+n+'\n' for n,h in actual.items()))
        naming.name_flexe_profile(profile)
        subprocess.run(['bash','-n',str(launcher)],check=True)
        assert not (profile/'fab-agon-emulator').exists()
        changes=[n for n in pins if actual[n]!=pins[n]]
        allowed={'flexe-agon-emulator','sdcard/rally25/script.bin','sdcard/rally25/expected.json'}
        if hide_startup_status:allowed.add('sdcard/rally25/artwork.vdu')
        assert set(changes)<=allowed
        assert sha(profile/'sdcard/rally25/probe.bin')==pins['sdcard/rally25/probe.bin']
        result[name]=dict(profile=str(profile),input_sha256=actual,changed_files=changes,
                          stopped=True,audio_driver='dummy',power_settings_changed=False,
                          startup_status_blanked=hide_startup_status)
    (HERE/('PROFILES-'+suffix+'.json')).write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({'profiles':len(result),'suffix':suffix,'all_stopped':True},indent=2))


if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--suffix',required=True);p.add_argument('--only',nargs='+');p.add_argument('--profile-name');p.add_argument('--hide-startup-status',action='store_true');a=p.parse_args();stage(a.suffix,a.only,a.profile_name,a.hide_startup_status)
