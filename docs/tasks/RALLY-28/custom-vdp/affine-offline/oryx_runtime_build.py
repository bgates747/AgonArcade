"""Export pinned sources locally, then build a private x86_64 Flexe runtime.

Run --prepare on the development host and transfer .work/runtime-archives with
this script. The default command builds from those archives without Git, a
dependency fetch, another checkout edit, or an emulator launch. A failed attempt
keeps its numbered receipt/log; a successful one also writes the authoritative
ORYX-RUNTIME-BUILD.json consumed by oryx_control.py.
"""
from pathlib import Path
import argparse
import hashlib
import json
import os
import platform
import re
import shutil
import subprocess
import tarfile
import time

HERE = Path(__file__).resolve().parent
ARCHIVES = HERE / '.work/runtime-archives'
SOURCE = HERE / '.work/oryx-flexe-source'
REPO = HERE.parents[5] / 'flexe-agon-emulator'
FRONTEND_PIN = 'a35b17d7dddb83d127ef4bb75f33a5808d9d8515'
CORE_PIN = 'fbda8e905ccff36a090e4e33b0ffc2337dd79c52'
PINS = {
    'frontend': (FRONTEND_PIN, 'eff797d9665f8be348b8ef2a1726505adcfb1a079df60c31ad5128292d3eff76'),
    'core': (CORE_PIN, 'c053dc1dbb35621cf16ad7208efc02800f264f8e30eab2ec921e4a0a86711026'),
}
PATCHES = ('flexe-integration.patch', 'flexe-ulp.patch',
           'flexe-logging.patch', 'flexe-i2s-eof.patch')


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def write_new_or_identical(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists():
        assert path.read_bytes() == data, ('Preserve existing artifact', str(path))
    else:
        path.write_bytes(data)


def json_bytes(value):
    return (json.dumps(value, indent=2) + '\n').encode()


def archive_manifest():
    return dict(schema=1, frontend_commit=FRONTEND_PIN, core_commit=CORE_PIN,
                archives={role: dict(filename=role + '-' + pin + '.tar',
                                     commit=pin, sha256=digest)
                          for role, (pin, digest) in PINS.items()},
                source_unmodified=True, other_checkout_dirty_changes_excluded=True,
                network_used=False, emulator_launched=False)


def prepare():
    """Read exact local Git objects; never export live dirty source files."""
    record = archive_manifest()
    for role, (pin, digest) in PINS.items():
        repo = REPO if role == 'frontend' else REPO / 'vendor/flexe'
        data = subprocess.check_output(['git', '-C', str(repo), 'archive', pin])
        assert hashlib.sha256(data).hexdigest() == digest, ('Archive identity', role)
        write_new_or_identical(ARCHIVES / record['archives'][role]['filename'], data)
    write_new_or_identical(ARCHIVES / 'ARCHIVES.json', json_bytes(record))
    print(json.dumps(record, indent=2))


def checked_archives():
    manifest = json.loads((ARCHIVES / 'ARCHIVES.json').read_text())
    assert manifest == archive_manifest(), 'Unexpected archive manifest'
    paths = {}
    for role, info in manifest['archives'].items():
        path = ARCHIVES / info['filename']
        assert sha(path) == info['sha256'], ('Changed source archive', role)
        paths[role] = path
    return manifest, paths


def extract(path, destination):
    assert hasattr(tarfile, 'data_filter'), 'Python with tarfile data_filter is required'
    with tarfile.open(path) as archive:
        archive.extractall(destination, filter='data')


def export_private_source(manifest, paths):
    receipt = HERE / 'ORYX-RUNTIME-PREPARATION.json'
    if SOURCE.exists():
        saved = json.loads(receipt.read_text())
        assert saved['archives'] == manifest['archives']
        for filename, digest in saved['source_files'].items():
            assert sha(SOURCE / filename) == digest, ('Changed private source', filename)
        return saved
    assert not receipt.exists(), 'Preparation receipt exists without its source tree'
    SOURCE.mkdir(parents=True)
    extract(paths['frontend'], SOURCE)
    core = SOURCE / 'build/flexe-source'
    core.mkdir(parents=True)
    extract(paths['core'], core)
    shutil.copyfile(paths['core'], SOURCE / 'build/flexe-upstream.tar')
    log_path = HERE / '.work/oryx-runtime-export.log'
    assert not log_path.exists(), 'Preserve earlier source export log'
    with log_path.open('w') as log:
        for patch in PATCHES:
            command = ['patch', '--fuzz=0', '-p1', '-d', str(core)]
            log.write(repr(command) + ' < patches/' + patch + '\n'); log.flush()
            with (SOURCE / 'patches' / patch).open('rb') as stream:
                subprocess.run(command, stdin=stream, stdout=log,
                               stderr=subprocess.STDOUT, check=True)
    files = [p for p in SOURCE.rglob('*') if p.is_file()
             and p.relative_to(SOURCE).parts[0] != 'build']
    files += [p for p in core.rglob('*') if p.is_file()]
    record = dict(schema=1, frontend_commit=FRONTEND_PIN, core_commit=CORE_PIN,
                  archives=manifest['archives'], published_patches=list(PATCHES),
                  source_files={str(p.relative_to(SOURCE)): sha(p) for p in sorted(files)},
                  source_changes_from_published_build=False,
                  other_checkout_dirty_changes_excluded=True,
                  export_log_sha256=sha(log_path), network_used=False,
                  emulator_launched=False)
    write_new_or_identical(receipt, json_bytes(record))
    return record


def tool(name, override=None):
    # Keep the cargo/rustc symlink basename: resolving it to rustup changes the
    # program that rustup dispatches when these entry points are invoked.
    if override:
        path = shutil.which(override) if '/' not in override else override
    else:
        path = shutil.which(name)
        if not path and name in ('cargo', 'rustc'):
            candidate = Path.home() / '.cargo/bin' / name
            if candidate.is_file():
                path = str(candidate)
    assert path and os.access(path, os.X_OK), ('Missing build tool', name, override)
    return str(Path(path).absolute())


def build(args):
    assert platform.machine() == 'x86_64', 'Oryx build requires x86_64; Pi receipts stay separate'
    assert re.fullmatch(r'[A-Za-z0-9_-]+', args.attempt), 'Simple fresh attempt name required'
    final = HERE / 'ORYX-RUNTIME-BUILD.json'
    receipt = HERE / ('ORYX-RUNTIME-BUILD-' + args.attempt + '.json')
    log_path = HERE / ('.work/oryx-runtime-build-' + args.attempt + '.log')
    assert not any(p.exists() for p in (final, receipt, log_path)), 'Preserve prior build attempts'
    manifest, archives = checked_archives()
    prepared = export_private_source(manifest, archives)
    cc, cargo, rustc = tool('cc', args.cc), tool('cargo', args.cargo), tool('rustc', args.rustc)
    cmake = tool('cmake')
    env = dict(os.environ, FORCE='1', CARGO_NET_OFFLINE='true', RUSTC=rustc, CC=cc)
    env['PATH'] = os.pathsep.join(dict.fromkeys([str(Path(cargo).parent),
        str(Path(rustc).parent), *env.get('PATH', '').split(os.pathsep)]))
    commands = [
        [cmake, '-S', 'build/flexe-source', '-B', 'build/flexe-core',
         '-DCMAKE_BUILD_TYPE=Release', '-DCMAKE_POSITION_INDEPENDENT_CODE=ON',
         '-DFLEXE_LTO=OFF', '-DCMAKE_C_FLAGS=-Wno-error=stringop-truncation',
         '-DCMAKE_C_COMPILER=' + cc],
        [cmake, '--build', 'build/flexe-core', '--target', 'xtensa-emu-lib', '--parallel', '2'],
        [cc, '-std=c17', '-O2', '-fPIC', '-shared', '-Wall', '-Wextra',
         '-Ibuild/flexe-source/src', 'adapter/flexe_vdp.c', 'adapter/ulp.c', 'adapter/ps2.c',
         'build/flexe-core/libxtensa-emu-lib.a', '-o', 'build/flexe-vdp.so',
         '-lssl', '-lcrypto', '-lz', '-lm', '-lpthread'],
        [cc, '-std=c17', '-O2', '-Wall', '-Wextra', '-Iadapter', '-Ibuild/flexe-source/src',
         'tests/ulp_ps2.c', 'adapter/ulp.c', 'adapter/ps2.c', 'build/flexe-core/libxtensa-emu-lib.a',
         '-o', 'build/ulp-ps2-tests', '-lssl', '-lcrypto', '-lz', '-lm', '-lpthread'],
        ['build/ulp-ps2-tests'],
        [cc, '-std=c17', '-O2', '-Wall', '-Wextra', '-Ibuild/flexe-source/src',
         'tests/i2s_eof.c', 'build/flexe-core/libxtensa-emu-lib.a', '-o', 'build/i2s-eof-tests',
         '-lssl', '-lcrypto', '-lz', '-lm', '-lpthread'],
        ['build/i2s-eof-tests'],
        [cc, '-std=c17', '-O2', '-Wall', '-Wextra', '-Iadapter', 'tests/clock.c',
         '-o', 'build/clock-tests'],
        ['build/clock-tests'],
        [rustc, '--edition', '2021', '--test', 'agon-ez80-emulator/src/uart.rs',
         '-o', 'build/uart-tests'],
        ['build/uart-tests'],
        [cargo, 'build', '--offline', '--locked', '--release', '--jobs', '2',
         '-p', 'flexe-agon-emulator'],
    ]
    started = time.monotonic()
    report = dict(schema=1, frontend_commit=FRONTEND_PIN, core_commit=CORE_PIN,
                  architecture=platform.machine(), host=platform.node(), source_changes=False,
                  archives=manifest['archives'], preparation_sha256=sha(HERE / 'ORYX-RUNTIME-PREPARATION.json'),
                  attempt=args.attempt, warning_policy='Only stringop-truncation remains a warning; no source change',
                  tools={name: dict(path=path, version=subprocess.check_output([path, '--version'],
                         env=env, text=True, stderr=subprocess.STDOUT).splitlines()[0])
                         for name, path in [('cc', cc), ('cargo', cargo), ('rustc', rustc), ('cmake', cmake)]},
                  python_version=platform.python_version(),
                  offline_policy=dict(cargo_flags=['--offline', '--locked'], CARGO_NET_OFFLINE='true'),
                  commands=[], emulator_launched=False, network_used=False,
                  source_tree=str(SOURCE), output_directory=str(SOURCE / 'build'))
    try:
        with log_path.open('w') as log:
            for command in commands:
                log.write(repr(command) + '\n'); log.flush()
                result = subprocess.run(command, cwd=SOURCE, env=env,
                                        stdout=log, stderr=subprocess.STDOUT)
                report['commands'].append(dict(argv=command, returncode=result.returncode))
                if result.returncode:
                    raise RuntimeError('Private runtime build failed: ' + repr(command))
        for filename, digest in prepared['source_files'].items():
            assert sha(SOURCE / filename) == digest, ('Build changed private source', filename)
        shutil.copyfile(SOURCE / 'target/release/flexe-agon-emulator', SOURCE / 'build/flexe-agon-emulator')
        report.update(passed=True, source_hashes_unchanged=True,
                      files={name: sha(SOURCE / 'build' / name)
                             for name in ('flexe-agon-emulator', 'flexe-vdp.so')})
    except Exception as error:
        report.update(passed=False, error=repr(error))
        raise
    finally:
        report.update(elapsed_host_seconds=time.monotonic() - started,
                      build_log=str(log_path.relative_to(HERE)), build_log_sha256=sha(log_path))
        data = json_bytes(report)
        write_new_or_identical(receipt, data)
        if report.get('passed'):
            write_new_or_identical(final, data)
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--prepare', action='store_true', help='Export exact local Git objects for transfer; do not build')
    parser.add_argument('--attempt', default='01', help='Fresh build receipt/log suffix; default 01')
    parser.add_argument('--cc')
    parser.add_argument('--cargo')
    parser.add_argument('--rustc')
    options = parser.parse_args()
    if options.prepare:
        prepare()
    else:
        build(options)
