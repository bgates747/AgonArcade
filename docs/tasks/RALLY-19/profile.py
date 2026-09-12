"""Create an isolated, stock-VDP headless-test profile; never launch a GUI."""
from pathlib import Path
import argparse,subprocess,sys
TASK=Path(__file__).resolve().parent
RUNTIME=Path.home()/'Agon/mystuff/AgonJukebox/.emulator/runtime/fab-1.2.4'
def prepare(profile,binary,options='oval demo',data=None):
    profile=profile.resolve()
    if not profile.is_relative_to(TASK/'.emulator'):raise ValueError('Keep R19 profiles inside its ignored .emulator tree')
    if profile.exists():raise ValueError('Use a fresh profile; stale guest reports are not evidence')
    setup=Path.home()/'Agon/mystuff/agon-dev-env/scripts/setup_emulator.py'
    subprocess.run([sys.executable,str(setup),'everyday','--everyday-profile',str(profile),'--emulator',str(RUNTIME)],check=True,stdout=subprocess.DEVNULL)
    app=profile/'sdcard/rally';app.mkdir()
    (app/'rally.bin').symlink_to(binary.resolve())
    for p in (data or TASK.parent/'RALLY-18/data').glob('*.road'):(app/p.name).symlink_to(p.resolve())
    (profile/'sdcard/autoexec.txt').write_bytes(('SET KEYBOARD 1\r\ncd /rally\r\nload rally.bin\r\nrun . '+options+'\r\n').encode())
    return profile
if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--options',default='oval demo');a=p.parse_args()
    print(prepare(TASK/'.emulator'/a.name,TASK/'.work/oracle/bin/rally.bin',a.options))
