"""Host qualification of actual presentation functions against stock-page model."""
from pathlib import Path
import hashlib
import json
import os
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[4]
WORK = HERE / '.work/presentation-host'


def run():
    WORK.mkdir(parents=True, exist_ok=True)
    # The accepted motion table is supplied as exact bytes, not recomputed.
    motion = HERE.parent / 'incremental/sprites/motion-comparison/fixtures/additive/motion.bin'
    include = HERE / '.work/presentation/include'
    source = HERE / 'guest/host_test.cpp'
    reports = {}
    for name, flags in [('ordinary', ['-O2']), ('sanitized', ['-O1', '-g', '-fsanitize=address,undefined', '-fno-omit-frame-pointer'])]:
        target = WORK / name
        command = ['c++', '-std=c++17', *flags, '-Wall', '-Wextra', '-Werror', '-Wno-unused-function', '-Wno-unused-variable',
                   '-I' + str(include), '-I' + str(ROOT / 'rally-game/include'), '-I' + str(ROOT / 'rally-production/include'),
                   str(source), '-o', str(target)]
        subprocess.run(command, check=True)
        env = dict(os.environ, ASAN_OPTIONS='detect_leaks=0:halt_on_error=1', UBSAN_OPTIONS='halt_on_error=1:print_stacktrace=1')
        result = subprocess.run([str(target), str(motion)], env=env, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if result.returncode:
            failure = dict(schema=1, qualification=name, returncode=result.returncode,
                           stdout=result.stdout, stderr=result.stderr,
                           source_sha256=hashlib.sha256(source.read_bytes()).hexdigest())
            destination = HERE / ('PRESENTATION-HOST-FAILURE-' + name + '.json')
            if not destination.exists():
                destination.write_text(json.dumps(failure, indent=2) + '\n')
            raise RuntimeError(result.stderr)
        value = json.loads(result.stdout)
        value.update(compiler_command=command, source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),
                     extracted_functions_sha256=hashlib.sha256((include / 'presentation-functions.inc').read_bytes()).hexdigest(),
                     motion_sha256=hashlib.sha256(motion.read_bytes()).hexdigest(), leak_sanitizer_disabled='ptrace environment; address/undefined checks active' if name == 'sanitized' else None)
        (HERE / ('PRESENTATION-HOST-' + name + '.json')).write_text(json.dumps(value, indent=2) + '\n')
        reports[name] = value
    print(json.dumps({name: {k:v for k,v in result.items() if k not in ('compiler_command',)} for name,result in reports.items()}, indent=2))


if __name__ == '__main__':
    run()
