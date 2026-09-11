"""Deploy only rally.bin to the mounted AGON card; never edit autoexec.txt."""
from pathlib import Path
import os
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
CARD = Path('/media/smith/AGON')
binary = ROOT / 'bin/rally.bin'
if not binary.is_file():
    raise SystemExit('Build first: make -C rally')
if not CARD.is_mount() or CARD.is_symlink():
    raise SystemExit(f'Expected mounted card at {CARD}')
label = subprocess.check_output(
    ['findmnt', '-n', '-o', 'LABEL', '--target', str(CARD)], text=True).strip()
if label != 'AGON':
    raise SystemExit(f'Expected volume AGON, found {label!r}')
destination = CARD / 'mystuff/arcade/rally'
if destination.resolve() != destination:
    raise SystemExit('Refusing a redirected deployment directory')
destination.mkdir(parents=True, exist_ok=True)
target = destination / 'rally.bin'
if target.is_symlink():
    raise SystemExit('Refusing a symlinked binary target')
fd, name = tempfile.mkstemp(prefix='rally-', suffix='.tmp', dir=destination)
try:
    with os.fdopen(fd, 'wb') as output, binary.open('rb') as source:
        shutil.copyfileobj(source, output)
        output.flush()
        os.fsync(output.fileno())
    os.replace(name, target)
    os.sync()
finally:
    Path(name).unlink(missing_ok=True)
print(f'Deployed {binary.stat().st_size:,} bytes to {target}')
print('autoexec.txt untouched.')
