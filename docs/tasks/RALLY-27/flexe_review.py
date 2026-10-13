"""Isolated Flexe setup and bounded headless rendering check."""
from pathlib import Path
import argparse,hashlib,importlib.util,json,os,shutil,signal,subprocess,time,tempfile
ROOT=Path(__file__).resolve().parents[3]
TASK=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def prepare(name,binary,args):
    assert name.startswith('rally27-') and Path(name).name==name
    profile=ROOT/'.emulator'/name
    assert not profile.exists(),'Preserve earlier profiles; choose a fresh name'
    helper=ROOT/'docs/tasks/RALLY-24/flexe/.work/setup_emulator.py'
    spec=importlib.util.spec_from_file_location('setup',helper);m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
    # Reuse verified MOS assets only; never stage the old Fab executable.
    assets=ROOT.parent/'golem/.emulator/runtime/fab-1.2.5'
    m.verify_latest_mos(assets/'firmware/mos_platform.bin',assets/'firmware/mos_platform.map')
    sd=profile/'sdcard';sd.mkdir(parents=True)
    for n in ['mos_platform.bin','mos_platform.map']:m.replace_symlink(profile/n,assets/'firmware'/n)
    m.sync_shared_bin(assets/'sdcard/bin',sd/'bin')
    m.write_mos_identity(profile)
    runtime=ROOT.parent/'flexe-agon-emulator/build'
    m.replace_symlink(profile/'flexe-agon-emulator.bin',runtime/'flexe-agon-emulator')
    shutil.copyfile(runtime/'flexe-vdp.so',profile/'flexe-vdp.so')
    # Frozen, previously boot-qualified ESP32 image; no VDPlet is loaded/called.
    fw=ROOT.parent/'agon-mos/.emulator'
    for name in ['esp32-firmware.bin','esp32-firmware.elf']:shutil.copyfile(fw/name,profile/name)
    dest=sd/'rally';dest.mkdir();shutil.copyfile(binary,dest/'rally.bin')
    assert '\n' not in args and '\r' not in args
    (sd/'autoexec.txt').write_bytes(('SET KEYBOARD 1\r\nCD /rally\r\nLOAD rally.bin\r\nRUN . '+args+'\r\n').encode())
    (profile/'.bespoke-vdp-profile').write_text('flexe-vdp.so\n')
    # Adapt the canonical guarded wrapper without installing a Fab-named entry.
    with tempfile.TemporaryDirectory() as tmp:
        m.write_profile_launcher(Path(tmp),strict_bespoke=True)
        s=(Path(tmp)/'fab-agon-emulator').read_text()
    s=s.replace('fab-agon-emulator','flexe-agon-emulator').replace('fab_bin','flexe_bin').replace('fab-bespoke','flexe-bespoke').replace('FSIM','Flexe')
    launch=profile/'flexe-agon-emulator' 
    env='''
export AGON_FLEXE_FIRMWARE="$profile_dir/esp32-firmware.bin"
export AGON_FLEXE_ELF="$profile_dir/esp32-firmware.elf"
export AGON_FLEXE_ENGINE="jit"
export AGON_FLEXE_ARTIFACTS="$profile_dir/last-run"
mkdir -p "$AGON_FLEXE_ARTIFACTS"
'''
    assert s.count('\nvdp_name=')==1;launch.write_text(s.replace('\nvdp_name=',env+'\nvdp_name=',1))
    launch.chmod(0o755)
    names=['flexe-agon-emulator','flexe-agon-emulator.bin','mos_platform.bin','mos_platform.map','flexe-vdp.so','esp32-firmware.bin','esp32-firmware.elf','sdcard/rally/rally.bin','sdcard/autoexec.txt']
    (profile/'.runtime.sha256').write_text(''.join(sha(profile/n)+'  '+n+'\n' for n in names))
    (profile/'identity.json').write_text(json.dumps({n:sha(profile/n) for n in names},indent=2)+'\n')
    return profile

def run(profile,seconds,keyboard_check=False):
    art=profile/'last-run';art.mkdir(exist_ok=True)
    env=dict(os.environ,SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy')
    if keyboard_check:
        actions=art/'actions.txt'
        actions.write_text('capture 600\nkey 660 space down\nkey 690 space up\nkey 780 space down\nkey 810 space up\ncapture 1200\nquit 1260\n')
        lib=TASK/'.work/visual-capture.so'
        env.update(LD_PRELOAD=str(lib),RALLY_VISUAL_DIR=str(art),RALLY_VISUAL_LOG=str(art/'keys.log'),RALLY_VISUAL_CONFIG=str(actions))
    started=time.monotonic()
    with (art/'frontend.log').open('w') as log:
        p=subprocess.Popen(['./flexe-agon-emulator','--renderer','sw','-z'],cwd=profile,env=env,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
        try:
            p.wait(timeout=seconds)
        except subprocess.TimeoutExpired:
            for proc in Path('/proc').glob('[0-9]*'):
                try:
                    if os.getpgid(int(proc.name))==p.pid and (proc/'exe').resolve()==(profile/'flexe-agon-emulator.bin').resolve():os.kill(int(proc.name),signal.SIGTERM)
                except OSError:pass
            try:p.wait(timeout=15)
            except subprocess.TimeoutExpired:os.killpg(p.pid,signal.SIGKILL);p.wait()
    stats=json.loads((art/'stats.json').read_text())
    result={'seconds':time.monotonic()-started,'exit':p.returncode,'stats':stats}
    (art/'result.json').write_text(json.dumps(result,indent=2)+'\n')
    assert p.returncode==0 and not any(stats.get(k) for k in ['failed','unhandled','unregistered','unmapped']),result
    assert (art/'final.ppm').stat().st_size>100000
    print(json.dumps(result))
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('name');p.add_argument('binary',type=Path);p.add_argument('--args',default='');p.add_argument('--seconds',type=float,default=0);p.add_argument('--keyboard-check',action='store_true');a=p.parse_args()
    profile=prepare(a.name,a.binary,a.args);print(profile,flush=True)
    if a.seconds:run(profile,a.seconds,a.keyboard_check)
