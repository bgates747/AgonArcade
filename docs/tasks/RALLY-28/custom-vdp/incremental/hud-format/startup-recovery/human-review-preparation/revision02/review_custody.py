"""Profile-local human-launch admission; no emulator or reservation operations."""
from pathlib import Path
import argparse
import json
import os
import re
import subprocess
import tempfile

FILENAME = '.review-custody.json'


def validate(entry, profile):
    if not isinstance(entry, dict):
        raise ValueError('custody is not a checkout object')
    if entry.get('owner') != 'rally':
        raise ValueError('custody owner is not Rally')
    if entry.get('profile') != str(Path(profile).resolve()):
        raise ValueError('custody belongs to another profile')
    if not isinstance(entry.get('lease'), str) or not re.fullmatch('[0-9a-f]{32}', entry['lease']):
        raise ValueError('custody UUID is missing or invalid')
    return entry


def save(profile, entry):
    """Custodian supplies the freshly returned checkout; never archive this file."""
    profile = Path(profile).resolve()
    validate(entry, profile)
    descriptor, temporary = tempfile.mkstemp(prefix='.review-custody-', dir=profile)
    try:
        with os.fdopen(descriptor, 'w') as stream:
            json.dump(entry, stream, indent=2)
            stream.write('\n')
        os.replace(temporary, profile / FILENAME)
    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)


def live_checkout(lease):
    command = ('/Agon/mystuff/agon-dev-env/.venv/bin/python '
        '/Agon/mystuff/agon-dev-env/cross-agent/vdplet-rollout/oryx_lease.py '
        'assert-owner --owner rally --lease ' + lease)
    result = subprocess.run(['ssh', '-o', 'BatchMode=yes', 'raspberrypi', command],
        text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, timeout=10)
    if result.returncode:
        raise ValueError('custody is stale or its live ownership cannot be verified')
    return json.loads(result.stdout)


def check(profile, fetch=live_checkout):
    profile = Path(profile).resolve()
    source = profile / FILENAME
    if not source.is_file():
        raise ValueError('fresh Rally custodian checkout file is missing')
    stored = validate(json.loads(source.read_text()), profile)
    current = validate(fetch(stored['lease']), profile)
    if current['lease'] != stored['lease']:
        raise ValueError('custody UUID no longer matches the live checkout')
    return current


def main():
    import sys
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=['check', 'save'])
    args = parser.parse_args()
    profile = Path(__file__).resolve().parent
    try:
        if args.action == 'save':
            save(profile, json.load(sys.stdin))
        else:
            check(profile)
    except (OSError, ValueError, TypeError, subprocess.TimeoutExpired) as error:
        print('Review not launched: ' + str(error) + '. Contact Golem.', file=sys.stderr)
        return 1
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
