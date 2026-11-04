"""Later FIFO-owned staging only. Preparation is not authority to invoke this."""
import argparse
import hashlib
import json
import socket
import subprocess
import tarfile
from pathlib import Path
from common import HERE, ROOT, profile, frozen_inputs, check_profile


def candidate_payloads(archive_path, info):
    """Validate the complete closed archive before any target writes."""
    with tarfile.open(archive_path) as archive:
        members = archive.getmembers()
        expected = set(info['input_sha256']) | {'.runtime.sha256'}
        assert len(members) == len(expected) and {m.name for m in members} == expected
        data = {}
        for m in members:
            assert m.isfile() and not Path(m.name).is_absolute() and '..' not in Path(m.name).parts
            payload = archive.extractfile(m).read()
            wanted = info['runtime_manifest_sha256'] if m.name == '.runtime.sha256' else info['input_sha256'][m.name]
            assert hashlib.sha256(payload).hexdigest() == wanted, m.name
            data[m.name] = payload
    return data


def stage(lease):
    assert socket.gethostname() == 'oryx-linuxlite'
    assert len(lease) == 32 and all(c in '0123456789abcdef' for c in lease)
    frozen_inputs()
    info = profile()
    target = Path(info['profile'])
    assert target.parent == ROOT / '.emulator'
    assert not target.exists(), 'Preserve previous profile, including partial staging'
    assert not (HERE / 'STAGED.json').exists()
    data = candidate_payloads(HERE / '.work/CANDIDATE.tar.gz', info)
    subprocess.run(['ssh', '-o', 'BatchMode=yes', 'raspberrypi',
        '/Agon/mystuff/agon-dev-env/.venv/bin/python /Agon/mystuff/agon-dev-env/cross-agent/vdplet-rollout/oryx_lease.py assert-owner --owner rally --lease ' + lease],
        check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    target.mkdir(parents=True)
    for name, payload in data.items():
        p = target / name
        p.parent.mkdir(parents=True, exist_ok=True)
        p.write_bytes(payload)
    for name in ('flexe-agon-emulator', 'flexe-agon-emulator.bin'):
        (target / name).chmod(0o755)
    check_profile(target, info['input_sha256'])
    subprocess.run(['bash', '-n', str(target / 'flexe-agon-emulator')], check=True)
    (HERE / 'STAGED.json').write_text(json.dumps(dict(profile=str(target), input_sha256=info['input_sha256'],
        stopped=True, target_executed=False, stage_lease=lease), indent=2) + '\n')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--lease', required=True)
    stage(parser.parse_args().lease)
