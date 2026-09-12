"""Build a snapshot on the configured agon-linux host, preserving its checkout."""
from pathlib import Path
import hashlib
import shlex
import subprocess
import tarfile
import tempfile

ROOT = Path(__file__).resolve().parents[1]
HOST = 'agon-linux'
SSH = ['ssh', '-o', 'BatchMode=yes', '-o', 'ConnectTimeout=10', HOST]


def remote(command):
    return subprocess.check_output(SSH + [command], text=True).strip()


with tempfile.TemporaryDirectory(prefix='rally-build-') as temporary:
    archive = Path(temporary) / 'source.tar.gz'
    with tarfile.open(archive, 'w:gz') as output:
        for name in ('Makefile', 'src', 'include', 'tests'):
            output.add(ROOT / name, arcname=name)
    directory = remote('mktemp -d /home/smith/Agon/mystuff/rally-mac-build.XXXXXX')
    if not directory.startswith('/home/smith/Agon/mystuff/rally-mac-build.') or any(
            character not in '/._-' and not character.isalnum() for character in directory):
        raise SystemExit(f'Unexpected remote build directory: {directory!r}')
    subprocess.run(['scp', '-q', str(archive), f'{HOST}:{directory}/source.tar.gz'], check=True)
    command = (f'cd {shlex.quote(directory)} && tar xzf source.tar.gz && '
               'export PATH=/home/smith/Agon/agondev/release/bin:$PATH && '
               'make && make test')
    subprocess.run(SSH + [command], check=True)
    expected = remote(f'sha256sum {shlex.quote(directory)}/bin/rally.bin').split()[0]
    binary = Path(temporary) / 'rally.bin'
    subprocess.run(['scp', '-q', f'{HOST}:{directory}/bin/rally.bin', str(binary)], check=True)
    if hashlib.sha256(binary.read_bytes()).hexdigest() != expected:
        raise SystemExit('Downloaded binary checksum mismatch')
    destination = ROOT / 'bin'
    destination.mkdir(exist_ok=True)
    staged = destination / 'rally.bin.download'
    staged.write_bytes(binary.read_bytes())
    staged.replace(destination / 'rally.bin')
    (destination / 'linux-build.txt').write_text(
        f'Host: {HOST}\nBuild directory: {directory}\n'
        f'Source archive SHA256: {hashlib.sha256(archive.read_bytes()).hexdigest()}\n'
        f'Binary SHA256: {expected}\n')
    print(f'Built and verified {destination / "rally.bin"} ({binary.stat().st_size} bytes)')
    print(f'Remote build evidence retained at {HOST}:{directory}')
