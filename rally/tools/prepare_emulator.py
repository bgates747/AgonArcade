"""Create a project-owned profile with the canonical Agon setup tool."""
from pathlib import Path
import subprocess
import sys
ROOT = Path(__file__).resolve().parents[1]
binary = ROOT / 'bin/rally.bin'
if not binary.is_file():
    raise SystemExit('Run make first.')
profile = ROOT / '.emulator'
canonical = Path.home() / 'Agon/mystuff/agon-dev-env/scripts/setup_emulator.py'
runtime = Path.home() / 'Agon/mystuff/AgonJukebox/.emulator/runtime/fab-1.2.4'
subprocess.run([sys.executable, str(canonical), 'everyday', '--everyday-profile',
                str(profile), '--emulator', str(runtime)], check=True)
app = profile / 'sdcard/rally'
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
autoexec.write_bytes(f'SET KEYBOARD 1\r\ncd /rally\r\nload rally.bin\r\nrun\r\n'.encode())
print(f'Agon Rally profile ready: {profile}')
