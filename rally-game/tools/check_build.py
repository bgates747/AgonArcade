"""Reject unsafe CRT startup tables and accidental release instrumentation."""
import argparse
import hashlib
import json
import re
import shutil
from pathlib import Path

p = argparse.ArgumentParser()
p.add_argument('--flags', default='')
args = p.parse_args()
root = Path(__file__).resolve().parents[1]
mapping = (root/'bin/rally.map').read_text()
for name in ('init_array', 'ctors', 'dtors', 'fini_array'):
    match = re.search(r'^\.'+name+r'\s+0x[0-9a-f]+\s+(0x[0-9a-f]+)', mapping, re.M)
    assert match and int(match[1],16) == 0, f'Unsupported dynamic startup/finalizer table: {name}'
assert ('_emos_gateway_call' in mapping) == ('RALLY_HOST_TELEMETRY' in args.flags), 'Private gateway leaked across build variants'
data = (root/'bin/rally.bin').read_bytes()
for flag, sentinel in [('RALLY_CAPTURE', b'test fixture ready'),
                       ('RALLY_DEVELOPMENT', b'W%+03d G%03d%%'),
                       ('RALLY_HOST_TELEMETRY', b'Host telemetry unavailable.')]:
    assert (sentinel in data) == (flag in args.flags), f'Stale/mismatched build: {flag}'
manifest = {'flags':args.flags, 'bytes':len(data), 'sha256':hashlib.sha256(data).hexdigest(),
            'inputs':{}}
repo = root.parent
for source in sorted([*root.glob('src/*'), *root.glob('include/*'),
                      *root.glob('tools/*.py'),*root.glob('tests/*'),
                      *(f for f in root.glob('assets/**/*') if f.is_file()),
                      *repo.glob('rally-production/include/*'), root/'Makefile']):
    manifest['inputs'][str(source.relative_to(repo))] = hashlib.sha256(source.read_bytes()).hexdigest()
(root/'bin/build.json').write_text(json.dumps(manifest,indent=2)+'\n')
archive=repo/'.research-cache/rally22/builds'/manifest['sha256']
archive.mkdir(parents=True,exist_ok=True)
for name in manifest['inputs']:
    destination=archive/'source'/name;destination.parent.mkdir(parents=True,exist_ok=True)
    shutil.copy2(repo/name,destination)
for name in ('rally.bin','rally.map','build.json'):shutil.copy2(root/'bin'/name,archive/name)
print('Build identity, empty CRT tables and release/fixture separation passed')
