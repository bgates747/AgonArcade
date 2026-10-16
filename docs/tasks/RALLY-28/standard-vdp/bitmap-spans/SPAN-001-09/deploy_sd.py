"""Deploy only the Rally road-test subtree on an explicitly identified card.

No startup writes, emulator launch, physical invocation, flash or unmount.
Existing Rally road fixtures/results are backed up to the host workspace.
"""
from pathlib import Path
import argparse
import datetime
import hashlib
import json
import os
import shutil
import subprocess
import zipfile

HERE = Path(__file__).resolve().parent
RELATIVE = Path('test/arcade/rally/r28-road')
ORDER = ['physics', 'polygons-cpu', 'bitmap-arithmetic-cpu', 'bitmap-lookup-cpu',
         'polygons-sparse-cpu', 'empty-live', 'polygons-sparse-live',
         'polygons-live', 'bitmap-arithmetic-live', 'bitmap-lookup-live']


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def deploy(mount, uuid):
    mount = mount.resolve(strict=True)
    filesystem = json.loads(subprocess.check_output(
        ['findmnt', '-J', '-T', str(mount), '-o', 'TARGET,SOURCE,FSTYPE,UUID,OPTIONS'], text=True))['filesystems'][0]
    assert Path(filesystem['target']).resolve() == mount
    assert filesystem['uuid'].upper() == uuid.upper() and filesystem['fstype'] == 'vfat'
    assert 'rw' in filesystem['options'].split(',')
    startup = mount / 'autoexec.txt'
    original = startup.read_bytes()
    startup_hash = hashlib.sha256(original).hexdigest()
    manifest = json.loads((HERE / 'PACKAGE.json').read_text())
    jobs = {job['id']: job for job in manifest['jobs']}
    assert set(jobs) == set(ORDER) and not manifest['startup_files_included']
    dest = mount / RELATIVE
    assert dest.resolve().is_relative_to(mount) and dest != mount
    stamp = datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ')
    backup = HERE / '.work' / ('sd-before-' + stamp)
    backup.mkdir(parents=True, exist_ok=False)
    (backup / 'startup-before.bin').write_bytes(original)  # Host-side preservation only.
    if dest.exists():
        assert dest.is_dir() and not dest.is_symlink()
        shutil.copytree(dest, backup / 'r28-road')
    with zipfile.ZipFile(HERE / 'PORTABLE.zip') as archive:
        assert set(archive.namelist()) == set(manifest['files'])
        for name, expected in manifest['files'].items():
            relative = Path(name)
            assert not relative.is_absolute() and '..' not in relative.parts
            assert relative.name.lower() != 'autoexec.txt'
            assert hashlib.sha256(archive.read(name)).hexdigest() == expected
        # Replace only our established fixture, after preserving its old results.
        if dest.exists():
            shutil.rmtree(dest)
        dest.mkdir(parents=True)
        for name in manifest['files']:
            target = dest / name
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(archive.read(name))
    suite = ''.join('EXEC /' + str(RELATIVE / (case + '.txt')) + '\r\n' for case in ORDER)
    (dest / 'suite.txt').write_bytes(suite.encode('ascii'))
    (dest / 'PACKAGE.json').write_bytes((HERE / 'PACKAGE.json').read_bytes())
    text = '''RALLY-28 OLIMEX ROAD/PHYSICS TESTS

Ten frozen finite cases. Mainboard Legacy rendering, mode 8 (320x240).
Requires the supplied NON-STOCK diagnostic VDP for fenced live timing.
Image: vdp_rally_benchmark.bin
VDP SHA256: {firmware}
Install/verify that image separately from the Pi before live tests.
No VDP/MOS/P4 firmware was flashed by SD deployment. Existing EMOS retained.
autoexec.txt was not edited. Reset does not invoke this suite.

MANUAL INVOCATION (positive visible MOS CLI required):
EMOS LEGACY --keep-display
VDU 22 8
Wait at least one whole second after the monitor has switched, then:
EXEC /test/arcade/rally/r28-road/suite.txt

The master command file explicitly invokes each independently reusable case.
It is a simple MOS command chain, NOT the Pi coordinator's result-gated chain.
A stalled program blocks this chain. There is no automatic reset/retry/resume.
If execution fails or the prompt is not responsive, stop and preserve evidence.
Do not apply the interactive emulator's five-minute timeout as a hardware reset.
Each appliance restores its single-buffered entry mode; double-buffer entry
is refused. Manual mode preselection means mode 8 is that entry mode.

First five cases: physics and CPU preparation; no animated road is expected.
Sixth: empty timing control. Last four: road drawing on deterministic Fuji poses.
Each CPU case: 1024 frames. Drawing cases: 128 frames. Empty: 32 frames.
Physics: 8192 actual numerical ticks/four scenarios, independently checkable.
Previous emulation suggests roughly 20-45 seconds per CPU/physics workload;
physical elapsed times remain unqualified. Live Flexe cases stalled, so no
reliable physical whole-suite duration or timeout is claimed.

Results are CREATE-NEW in each case directory: summary.txt, frames.csv, done.txt;
physics additionally state.csv, phases.csv, lifecycle.txt, physics-done.txt.
PASS requires complete planned counts, restored state and no failure in the
saved summary plus independent verification after retrieval. A done file alone
does not establish a pass. Terminal results identify the running candidate.
Do not rerun into old outputs. Preserve/collect them, then redeploy fresh cases.

INDIVIDUAL CASES (same explicit mode preselection/settling):
{commands}

This directory contains all binaries, configuration, Fuji coefficient data,
individual MOS commands, master commands and the exact diagnostic VDP image.
No game assets, startup modifications, physical runner or MOS upgrade required
by this package. The Pi live coordinator remains unqualified/not ready.
'''.format(firmware=manifest['firmware_sha256'], commands='\n'.join(
        'EXEC /' + str(RELATIVE / (case + '.txt')) for case in ORDER))
    (dest / 'readme.txt').write_bytes(text.replace('\n', '\r\n').encode('ascii'))
    for p in dest.rglob('*'):
        if p.is_file():
            with p.open('rb') as f:
                os.fsync(f.fileno())
    os.sync()
    # One deployment readback; no redundant comparison campaign.
    observed = {str(p.relative_to(dest)): sha(p) for p in dest.rglob('*') if p.is_file()}
    for name, expected in manifest['files'].items():
        assert observed[name] == expected, name
    assert startup.read_bytes() == original and sha(startup) == startup_hash
    receipt = dict(status='sd-deployed-not-invoked-firmware-not-flashed', utc=stamp,
                   filesystem=filesystem, sd_directory='/' + str(RELATIVE),
                   host_directory=str(dest), jobs=ORDER, files=observed,
                   archive_sha256=sha(HERE / 'PORTABLE.zip'),
                   firmware_sha256=manifest['firmware_sha256'],
                   autoexec_before_sha256=startup_hash, autoexec_after_sha256=sha(startup),
                   startup_unchanged=True, host_backup=str(backup), writes_flushed=True,
                   mounted=True, physical_run=False, flashed=False)
    (HERE / 'HARDWARE-DEPLOYMENT.json').write_text(json.dumps(receipt, indent=2) + '\n')
    (HERE / 'HARDWARE-README.txt').write_bytes((dest / 'readme.txt').read_bytes())
    print(json.dumps(receipt, indent=2))


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--mount', required=True, type=Path)
    parser.add_argument('--uuid', required=True)
    args = parser.parse_args()
    deploy(args.mount, args.uuid)
