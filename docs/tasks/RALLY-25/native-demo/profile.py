"""Prepare an isolated, stopped Rally Flexe profile from explicit artifacts."""
from pathlib import Path
import argparse,hashlib,importlib.util,json,shutil
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[3]

def prepare(fixture,firmware,elf,name='rally25-native-demo',runtime=None):
    fixture=Path(fixture).resolve();firmware=Path(firmware).resolve();elf=Path(elf).resolve()
    golem=ROOT.parent/'golem'
    runtime=Path(runtime).resolve() if runtime else golem/'docs/tasks/GOLEM-021/emulator/build'
    setup=HERE/'.work/setup_emulator.py'
    if not setup.exists():setup=ROOT.parent/'agon-dev-env/scripts/setup_emulator.py'
    spec=importlib.util.spec_from_file_location('canonical_emulator',setup);m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
    profile=ROOT/'.emulator'/name
    sd=m.link_shared_runtime(profile,golem/'.emulator/runtime/fab-1.2.5')
    modern=(runtime/'flexe-agon-emulator').exists()
    frontend='flexe-agon-emulator' if modern else 'fab-agon-emulator'
    m.replace_symlink(profile/'fab-agon-emulator.bin',runtime/'flexe-agon-emulator' if modern else runtime/'fab-source/target/release/fab-agon-emulator')
    for dest,source in [('flexe-vdp.so',runtime/'flexe-vdp.so'),('esp32-firmware.bin',firmware),('esp32-firmware.elf',elf)]:shutil.copyfile(source,profile/dest)
    app=sd/'rally25';app.mkdir(exist_ok=True)
    for p in fixture.iterdir():
        if p.is_file() and p.suffix!='.log' and p.name!='verified.json':shutil.copyfile(p,app/p.name)
    for n in ('replies.log','ticks.log','prt.log','clock.log','failure.log'):(app/n).unlink(missing_ok=True)
    (sd/'autoexec.txt').write_bytes(b'SET KEYBOARD 1\r\ncd /rally25\r\nload probe.bin\r\nrun .\r\n')
    (profile/'.bespoke-vdp-profile').write_text('flexe-vdp.so\n');m.write_profile_launcher(profile,strict_bespoke=True)
    launch=profile/'fab-agon-emulator';s=launch.read_text()
    env='''
rm -f -- "$profile_dir/sdcard/rally25/replies.log" "$profile_dir/sdcard/rally25/ticks.log" "$profile_dir/sdcard/rally25/prt.log" "$profile_dir/sdcard/rally25/clock.log" "$profile_dir/sdcard/rally25/failure.log"
export AGON_FLEXE_FIRMWARE="$profile_dir/esp32-firmware.bin"
export AGON_FLEXE_ELF="$profile_dir/esp32-firmware.elf"
export AGON_FLEXE_ENGINE="${AGON_FLEXE_ENGINE:-jit}"
export AGON_FLEXE_ARTIFACTS="$profile_dir/last-run"
mkdir -p "$AGON_FLEXE_ARTIFACTS"
'''
    assert s.count('\nvdp_name=')==1;s=s.replace('\nvdp_name=',env+'\nvdp_name=',1);launch.write_text(s)
    if modern:
        # Author's Flexe naming overrides canonical Fab filenames for this runtime.
        s=s.replace('fab-agon-emulator.bin','flexe-agon-emulator.bin')
        launch.write_text(s)
        launch.rename(profile/'flexe-agon-emulator')
        (profile/'fab-agon-emulator.bin').rename(profile/'flexe-agon-emulator.bin')
    files=['fab-agon-emulator','fab-agon-emulator.bin','mos_platform.bin','mos_platform.map','flexe-vdp.so','esp32-firmware.bin','esp32-firmware.elf','sdcard/autoexec.txt']
    files=[n.replace('fab-agon-emulator',frontend) for n in files]
    files+=['sdcard/rally25/'+p.name for p in app.iterdir() if p.is_file() and p.suffix!='.log' and p.name!='verified.json']
    (profile/'.runtime.sha256').write_text(''.join(hashlib.sha256((profile/n).read_bytes()).hexdigest()+'  '+n+'\n' for n in files))
    print('Prepared stopped profile:',profile)
    return profile
if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--fixture',required=True);p.add_argument('--firmware',required=True);p.add_argument('--elf',required=True);p.add_argument('--name',default='rally25-native-demo');p.add_argument('--runtime');a=p.parse_args()
    prepare(a.fixture,a.firmware,a.elf,a.name,a.runtime)
