"""Create a project-owned profile with the canonical Agon setup tool."""
from pathlib import Path
import argparse
import platform
import subprocess
import sys
ROOT = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--runtime', type=Path, help='Official Fab runtime checkout')
parser.add_argument('--profile', type=Path, default=ROOT / '.emulator')
parser.add_argument('--fence', action='store_true', help='Wait for a stock poll after each swap')
parser.add_argument('--fixed-bands', action='store_true', help='Use the RALLY-10 precomputed band table')
parser.add_argument('--bench', action='store_true', help='Run a 20-second timing sample then return to MOS')
parser.add_argument('--track', choices=('oval','fuji'), default='oval')
parser.add_argument('--workload', choices=('full','nosky','notraffic','mirror','light'),
                    help='Run the fixed-pose diagnostic fixture')
args = parser.parse_args()
binary = ROOT / 'bin/rally.bin'
if not binary.is_file():
    raise SystemExit('Run make first.')
profile = args.profile.expanduser().resolve()
canonical = Path.home() / 'Agon/mystuff/agon-dev-env/scripts/setup_emulator.py'
runtime = args.runtime or (Path.home() / ('Agon/fab-agon-emulator'
    if platform.system() == 'Darwin' else
    'Agon/mystuff/AgonJukebox/.emulator/runtime/fab-1.2.4'))
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
options=[args.track]
if args.fence: options.append('fence')
if args.fixed_bands: options.append('fixedbands')
if args.bench: options.append('bench')
if args.workload:
    options.append('fixture')
    if args.workload!='full': options.append(args.workload)
autoexec.write_bytes(('SET KEYBOARD 1\r\ncd /rally\r\nload rally.bin\r\nrun . '
                      +' '.join(options)+'\r\n').encode())
print(f'Agon Rally profile ready: {profile}')
