"""Create a project-owned profile with the canonical Agon setup tool."""
import argparse
from pathlib import Path
import subprocess
import sys
ROOT = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--demo', action='store_true')
args = parser.parse_args()
binary = ROOT / 'bin/defender.bin'
if not binary.is_file():
    raise SystemExit('Run make first.')
profile = ROOT / '.emulator'
canonical = Path.home() / 'Agon/mystuff/agon-dev-env/scripts/setup_emulator.py'
runtime = Path.home() / 'Agon/mystuff/AgonJukebox/.emulator/runtime/fab-1.2.4'
subprocess.run([sys.executable, str(canonical), 'everyday', '--everyday-profile',
                str(profile), '--emulator', str(runtime)], check=True)
app = profile / 'sdcard/defender'
app.mkdir(exist_ok=True)
target = app / binary.name
if target.is_symlink():
    target.unlink()
elif target.exists():
    raise SystemExit(f'Refusing to replace a real file: {target}')
target.symlink_to(binary)
autoexec = profile / 'sdcard/autoexec.txt'
if autoexec.is_symlink():
    raise SystemExit('Refusing to overwrite a symlinked startup.')
run = 'run . demo' if args.demo else 'run'
autoexec.write_bytes(f'SET KEYBOARD 1\r\ncd /defender\r\nload defender.bin\r\n{run}\r\n'.encode())
print(f'Agon Defender profile ready: {profile}')
