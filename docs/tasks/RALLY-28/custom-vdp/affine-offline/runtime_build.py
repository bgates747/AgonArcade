"""Build an unmodified, privately exported Flexe runtime on the Pi5.

No other checkout is edited. First export comes from the recorded Git commit;
local unpublished source changes are deliberately excluded. This builder does
not launch an emulator, fetch dependencies or change host power settings.
"""
from pathlib import Path
import hashlib
import io
import json
import os
import platform
import subprocess
import tarfile
import time

HERE = Path(__file__).resolve().parent
SOURCE = HERE / '.work/flexe-source'
REPO = HERE.parents[5] / 'flexe-agon-emulator'
FRONTEND_PIN = 'a35b17d7dddb83d127ef4bb75f33a5808d9d8515'
CORE_PIN = 'fbda8e905ccff36a090e4e33b0ffc2337dd79c52'


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def prepare():
    """Create a private export from recorded commits, never live dirty files."""
    if SOURCE.exists():
        return
    SOURCE.mkdir(parents=True)
    raw = subprocess.check_output(['git', '-C', str(REPO), 'archive', FRONTEND_PIN])
    with tarfile.open(fileobj=io.BytesIO(raw)) as archive:
        archive.extractall(SOURCE, filter='data')
    core = subprocess.check_output(['git', '-C', str(REPO / 'vendor/flexe'), 'archive', CORE_PIN])
    assert hashlib.sha256(core).hexdigest() == 'c053dc1dbb35621cf16ad7208efc02800f264f8e30eab2ec921e4a0a86711026'
    exported = SOURCE / 'build/flexe-source'; exported.mkdir(parents=True)
    with tarfile.open(fileobj=io.BytesIO(core)) as archive:
        archive.extractall(exported, filter='data')
    (SOURCE / 'build/flexe-upstream.tar').write_bytes(core)
    with (HERE / '.work/pi-runtime-export.log').open('w') as log:
        for patch in ('flexe-integration.patch', 'flexe-ulp.patch', 'flexe-logging.patch', 'flexe-i2s-eof.patch'):
            with (SOURCE / 'patches' / patch).open('rb') as data:
                subprocess.run(['patch', '--fuzz=0', '-p1', '-d', str(exported)],
                               stdin=data, stdout=log, stderr=subprocess.STDOUT, check=True)
    record = dict(frontend_commit=FRONTEND_PIN, core_commit=CORE_PIN,
                  source_archive_sha256=hashlib.sha256(raw).hexdigest(),
                  core_archive_sha256=hashlib.sha256(core).hexdigest(),
                  other_checkout_dirty_changes_excluded=True, source_unmodified=True,
                  emulator_launched=False)
    (HERE / 'PI-RUNTIME-PREPARATION.json').write_text(json.dumps(record, indent=2) + '\n')


def build():
    assert platform.machine() == 'aarch64', 'This is the recorded Pi5 build'
    prepare()
    assert SOURCE.is_dir() and (SOURCE / 'build/flexe-source/CMakeLists.txt').is_file()
    # Source was exported before the original normal build. Preserve its failed
    # log and generated source; only the build cache and private outputs change.
    commands = [
        ['cmake', '-S', 'build/flexe-source', '-B', 'build/flexe-core',
         '-DCMAKE_BUILD_TYPE=Release', '-DCMAKE_POSITION_INDEPENDENT_CODE=ON',
         '-DFLEXE_LTO=OFF', '-DCMAKE_C_FLAGS=-Wno-error=stringop-truncation'],
        ['cmake', '--build', 'build/flexe-core', '--target', 'xtensa-emu-lib', '--parallel', '2'],
        ['cc', '-std=c17', '-O2', '-fPIC', '-shared', '-Wall', '-Wextra',
         '-Ibuild/flexe-source/src', 'adapter/flexe_vdp.c', 'adapter/ulp.c', 'adapter/ps2.c',
         'build/flexe-core/libxtensa-emu-lib.a', '-o', 'build/flexe-vdp.so',
         '-lssl', '-lcrypto', '-lz', '-lm', '-lpthread'],
        ['cc', '-std=c17', '-O2', '-Wall', '-Wextra', '-Iadapter', '-Ibuild/flexe-source/src',
         'tests/ulp_ps2.c', 'adapter/ulp.c', 'adapter/ps2.c', 'build/flexe-core/libxtensa-emu-lib.a',
         '-o', 'build/ulp-ps2-tests', '-lssl', '-lcrypto', '-lz', '-lm', '-lpthread'],
        ['build/ulp-ps2-tests'],
        ['cc', '-std=c17', '-O2', '-Wall', '-Wextra', '-Ibuild/flexe-source/src',
         'tests/i2s_eof.c', 'build/flexe-core/libxtensa-emu-lib.a', '-o', 'build/i2s-eof-tests',
         '-lssl', '-lcrypto', '-lz', '-lm', '-lpthread'],
        ['build/i2s-eof-tests'],
        ['cc', '-std=c17', '-O2', '-Wall', '-Wextra', '-Iadapter', 'tests/clock.c',
         '-o', 'build/clock-tests'],
        ['build/clock-tests'],
        ['/usr/bin/rustc', '--edition', '2021', '--test', 'agon-ez80-emulator/src/uart.rs',
         '-o', 'build/uart-tests'],
        ['build/uart-tests'],
        ['/usr/bin/cargo', 'build', '--offline', '--locked', '--release', '--jobs', '2',
         '-p', 'flexe-agon-emulator'],
    ]
    log_path = HERE / '.work/pi-runtime-build02.log'
    assert not log_path.exists(), 'Preserve build attempts'
    started = time.monotonic()
    report = dict(schema=1, frontend_commit=FRONTEND_PIN, core_commit=CORE_PIN,
                  architecture=platform.machine(), source_changes=False,
                  initial_attempt_log='.work/pi-runtime-build.log',
                  initial_attempt_failure='GCC -Werror=stringop-truncation in upstream rom_stubs.c',
                  warning_policy='Only stringop-truncation remains a warning; no source change',
                  commands=[], emulator_launched=False)
    env = dict(os.environ, FORCE='1')
    try:
        with log_path.open('w') as log:
            for command in commands:
                log.write('\n' + repr(command) + '\n'); log.flush()
                result = subprocess.run(command, cwd=SOURCE, env=env, stdout=log, stderr=subprocess.STDOUT)
                report['commands'].append(dict(argv=command, returncode=result.returncode))
                if result.returncode:
                    raise RuntimeError('Private runtime build failed: ' + repr(command))
        import shutil
        shutil.copyfile(SOURCE / 'target/release/flexe-agon-emulator', SOURCE / 'build/flexe-agon-emulator')
        report.update(passed=True, files={name: sha(SOURCE / 'build' / name)
                                         for name in ('flexe-agon-emulator', 'flexe-vdp.so')})
    except Exception as error:
        report.update(passed=False, error=repr(error))
        raise
    finally:
        report['elapsed_host_seconds'] = time.monotonic() - started
        report['build_log_sha256'] = sha(log_path)
        (HERE / 'PI-RUNTIME-BUILD.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    build()
