"""Prepare a fresh stopped Flexe profile with an official stock VDP image."""
from pathlib import Path
import argparse,hashlib,importlib.util,json,shutil,tempfile
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[4]
STOCK_SHA='b807beef35823b13a0a056f11b7464cd1b1c6356dce0e4098b78ebe059ded35f'
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
def prepare(name,kind,binary,firmware,runtime,mos_runtime):
    assert name.startswith('rally28-') and Path(name).name==name
    assert kind in ('key','poll') and sha(firmware)==STOCK_SHA,'Use the exact official VDP 2.16.0 release binary'
    profile=ROOT/'.emulator'/name
    assert not profile.exists(),'Preserve earlier runs; choose a fresh profile name'
    helper=ROOT.parent/'agon-dev-env/scripts/setup_emulator.py'
    if not helper.exists():helper=HERE/'.work/setup_emulator.py'
    spec=importlib.util.spec_from_file_location('setup',helper)
    setup=importlib.util.module_from_spec(spec);spec.loader.exec_module(setup)
    setup.verify_latest_mos(mos_runtime/'firmware/mos_platform.bin',mos_runtime/'firmware/mos_platform.map')
    sd=profile/'sdcard';sd.mkdir(parents=True)
    for n in ('mos_platform.bin','mos_platform.map'):shutil.copyfile(mos_runtime/'firmware'/n,profile/n)
    setup.sync_shared_bin(mos_runtime/'sdcard/bin',sd/'bin');setup.write_mos_identity(profile)
    for n in ('flexe-agon-emulator','flexe-vdp.so'):shutil.copyfile(runtime/n,profile/(n+'.bin' if n=='flexe-agon-emulator' else n))
    (profile/'flexe-agon-emulator.bin').chmod(0o755)
    shutil.copyfile(firmware,profile/'esp32-firmware.bin')
    app=sd/'test/arcade/rally28'/kind;app.mkdir(parents=True);shutil.copyfile(binary,app/'probe.bin')
    (sd/'autoexec.txt').write_bytes(f'SET KEYBOARD 1\r\nCD /test/arcade/rally28/{kind}\r\nLOAD probe.bin\r\nRUN .\r\n'.encode())
    (profile/'.bespoke-vdp-profile').write_text('flexe-vdp.so\n')
    with tempfile.TemporaryDirectory() as tmp:
        setup.write_profile_launcher(Path(tmp),strict_bespoke=True)
        launch=(Path(tmp)/'fab-agon-emulator').read_text()
    launch=launch.replace('fab-agon-emulator','flexe-agon-emulator').replace('fab_bin','flexe_bin')
    # This probe makes no sound. Human video review may select a real video backend.
    # Every launch also forces dummy audio; unattended run.py forces dummy video too.
    extra='''
export SDL_AUDIODRIVER=dummy
export AGON_FLEXE_FIRMWARE="$profile_dir/esp32-firmware.bin"
unset AGON_FLEXE_ELF
export AGON_FLEXE_ENGINE=jit
export AGON_FLEXE_ARTIFACTS="$profile_dir/last-run"
mkdir -p "$AGON_FLEXE_ARTIFACTS"
'''
    assert launch.count('\nvdp_name=')==1
    launch=launch.replace('\nvdp_name=',extra+'\nvdp_name=',1)
    (profile/'flexe-agon-emulator').write_text(launch);(profile/'flexe-agon-emulator').chmod(0o755)
    names=['flexe-agon-emulator','flexe-agon-emulator.bin','flexe-vdp.so','esp32-firmware.bin','mos_platform.bin','mos_platform.map','sdcard/autoexec.txt',str((app/'probe.bin').relative_to(profile))]
    identity={n:sha(profile/n) for n in names}
    (profile/'.runtime.sha256').write_text(''.join(h+'  '+n+'\n' for n,h in identity.items()))
    (profile/'identity.json').write_text(json.dumps({'kind':kind,'files':identity,'setup_helper_sha256':sha(helper),'stock_release':'https://github.com/AgonPlatform/agon-vdp/releases/tag/v2.16.0'},indent=2)+'\n')
    print('Prepared stopped profile:',profile)
    return profile
if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--name',required=True);p.add_argument('--kind',choices=['key','poll'],required=True)
    p.add_argument('--binary',type=Path,required=True);p.add_argument('--firmware',type=Path,required=True)
    p.add_argument('--runtime',type=Path,default=ROOT.parent/'flexe-agon-emulator/build')
    p.add_argument('--mos-runtime',type=Path,default=ROOT.parent/'golem/.emulator/runtime/fab-1.2.5')
    a=p.parse_args();prepare(a.name,a.kind,a.binary,a.firmware,a.runtime,a.mos_runtime)
