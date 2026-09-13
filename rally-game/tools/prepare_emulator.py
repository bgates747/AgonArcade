"""Fresh isolated stock-Fab profile; copies only the selected binary/road inputs."""
import argparse
from pathlib import Path
import shutil
import subprocess

ROOT=Path(__file__).resolve().parents[2]
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('name')
p.add_argument('--binary',type=Path,default=ROOT/'rally-game/bin/rally.bin')
p.add_argument('--args',default='oval mute')
p.add_argument('--runtime',type=Path,default=ROOT.parent/'AgonJukebox/.emulator/runtime/fab-1.2.4')
args=p.parse_args()
assert args.name.startswith('rally22-') and args.name==Path(args.name).name
profile=ROOT/'.emulator'/args.name
assert not profile.exists(),'Use a fresh profile name to preserve previous evidence'
environment=ROOT.parent/'agon-dev-env'
subprocess.run([str(environment/'.venv/bin/python'),str(environment/'scripts/setup_emulator.py'),
    'everyday','--everyday-profile',str(profile),'--emulator',str(args.runtime)],check=True,cwd=environment)
target=profile/'sdcard/rally';target.mkdir()
shutil.copy2(args.binary,target/'rally.bin')
for name in ('oval.road','fuji.road'):shutil.copy2(ROOT/'rally-production'/name,target/name)
assert '\n' not in args.args and '\r' not in args.args
(profile/'sdcard/autoexec.txt').write_bytes(
    ('SET KEYBOARD 1\r\nCD /rally\r\nLOAD rally.bin\r\nRUN . '+args.args+'\r\n').encode('ascii'))
print(profile)
