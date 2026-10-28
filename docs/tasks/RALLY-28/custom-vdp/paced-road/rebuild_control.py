"""Rebuild the frozen native control without changing compiler/SDK/runtime pins."""
from pathlib import Path
import hashlib
import json
import subprocess
import sys

HERE = Path(__file__).resolve().parent
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()

if __name__ == '__main__':
    control = json.loads((HERE/'CONTROL.json').read_text())
    for name, digest in control['immutable_files'].items():
        assert sha(HERE/name) == digest, name
    out = HERE/'.work/native-rebuild'
    command = [sys.executable, HERE/'control/sdk/tools/build_module.py',
               HERE/'control/package/native.c', '--name', 'rally-render',
               '--build-id', '0x474c3731', '--output', out, '--text-limit', '32768',
               '--data-limit', '4096', '--stack-limit', '2048', '--image-limit', '65536']
    subprocess.run([str(x) for x in command], check=True, stdout=subprocess.PIPE,
                   stderr=subprocess.STDOUT, text=True)
    original = HERE/'control/package'
    compared = {}
    for name in ('rally-render.vdpl', 'rally-render.elf', 'rally-render.upload.elf'):
        assert sha(out/name) == sha(original/name), name
        compared[name] = sha(out/name)
    result = dict(byte_identical=True, compared=compared, generated_c_changed=False,
                  helper_changed=False, sdk_revision='9fbb21d', compiler=control['native_toolchain_version'],
                  resources=json.loads((out/'rally-render.json').read_text())['module'])
    (HERE/'TARGET-REBUILD.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:v for k,v in result.items() if k!='resources'},indent=2))
