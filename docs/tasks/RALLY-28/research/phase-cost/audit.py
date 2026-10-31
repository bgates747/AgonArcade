"""Offline input/call-site/evidence accounting; never starts a guest or emulator.

Run with repository .venv/bin/python. --write creates this audit's derived files;
the default verifies them and all preserved input hashes.
"""
from collections import Counter
from pathlib import Path
import argparse
import csv
import hashlib
import json
import re
import shlex

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[4]
CUSTOM = ROOT / 'docs/tasks/RALLY-28/custom-vdp'
CONTROL = CUSTOM / 'incremental/round-trips'
BENCH = CUSTOM / 'prepared-bitmap-set/prepared-benchmark'
inputs = {}


def pin(path, expected=None):
    path = path.resolve()
    digest = hashlib.sha256(path.read_bytes()).hexdigest()
    if expected is not None:
        assert digest == expected, str(path)
    inputs[str(path)] = digest
    return digest


def load(path):
    pin(path)
    return json.loads(path.read_text())


def generate():
    emission = load(HERE / 'assembly/EMISSION.json')
    pin(Path(emission['command'][0]), emission['compiler_sha256'])
    pin(HERE / 'assembly/ez80-main.s', emission['assembly_sha256'])
    pin(CONTROL / 'guest/src/main.cpp', emission['source_sha256'])
    pin(CONTROL / 'guest/probe.bin', emission['baseline_guest_sha256'])
    # Preserve exact prior fixtures and archives, not just the files discussed.
    frozen = load(CONTROL / 'FROZEN-INPUTS.json')
    for name, digest in frozen.items():
        pin(CONTROL / name, digest)
    protected = load(CONTROL / 'PROTECTED.json')
    for name, digest in protected.items():
        pin(Path(name), digest)
    package = load(CONTROL / 'PACKAGE.json')['members']
    reviewed = [p for directory in ('source', 'guest', 'target')
                for p in (CONTROL / directory).rglob('*') if p.is_file()
                and (p.suffix in ('.c', '.h', '.hpp', '.inc', '.asm', '.elf', '.vdpl', '.su')
                     or p.name in ('rally-render.json', 'rally-render.disassembly.txt'))]
    for path in reviewed:
        pin(path, package[path.relative_to(CONTROL).as_posix()])
    # Compiler-emitted transitive include list; assert .work copies are exact.
    dep = HERE / 'assembly/ez80-main.d'
    pin(dep)
    for name in shlex.split(dep.read_text().replace('\\\n', ' ').split(':', 1)[1]):
        path = (Path(emission['cwd']) / name).resolve()
        pin(path)
        if path.is_relative_to(CONTROL / '.work/guest'):
            durable = CONTROL / 'guest' / path.relative_to(CONTROL / '.work/guest')
            assert path.read_bytes() == durable.read_bytes(), str(path)
            pin(durable)
    sdk = CUSTOM / 'paced-road/control/sdk'
    for path in sdk.rglob('*'):
        if path.is_file() and path.suffix in ('.h', '.py'):
            pin(path)
    xtensa = Path.home() / '.platformio/packages/toolchain-xtensa-esp32/bin/xtensa-esp32-elf-gcc'
    pin(xtensa)
    graphics = load(CUSTOM / 'paced-road/STOCK-PATH.json')
    recovery = load(HERE / 'stock/PROVENANCE.json')
    for name, digest in graphics['files'].items():
        path = HERE / 'stock/vdu_buffered.h' if name.endswith('/vdu_buffered.h') else Path(name)
        pin(path, digest)
    assert recovery['sha256'] == graphics['files'][str(Path(next(iter(graphics['files']))).parents[2] / 'video/vdu_buffered.h')]
    # vdu_sys was separately pinned by the earlier qualified stock-source audit.
    old_phase = load(CUSTOM / 'throughput/phase_SOURCE.json')
    firmware_source = Path(next(iter(graphics['files']))).parents[2]
    pin(firmware_source / 'video/vdu_sys.h', old_phase['vdu_sys_sha256'])
    for name in ('rally-game/src/main.cpp', 'rally-game/include/hud.hpp',
                 'rally-game/include/race_traffic.hpp', 'rally-game/include/routes_data.hpp',
                 'rally-production/include/road.hpp'):
        pin(ROOT / name)
    module = load(CONTROL / 'target/rally-render.json')
    pin(CONTROL / 'target/rally-render.vdpl', module['module']['sha256'])

    assembly = (HERE / 'assembly/ez80-main.s').read_text().splitlines()
    functions = {}
    current = None
    for number, line in enumerate(assembly, 1):
        match = re.match(r'\s*\.type\s+([^,]+),@function', line)
        if match:
            current = match[1]
            functions[current] = {'line': number, 'calls': []}
        call = re.match(r'\s*call\s+([^\s;]+)', line)
        if call and current:
            functions[current]['calls'].append({'line': number, 'target': call[1]})
        if re.match(r'\s*\.size\s+', line):
            current = None
    for info in functions.values():
        info['static_call_counts'] = dict(sorted(Counter(c['target'] for c in info['calls']).items()))
    hud = functions['__ZN12_GLOBAL__N_17drawHudEm']['static_call_counts']
    assert {k: hud[k] for k in ('_snprintf', '__ldivu', '__lremu', '__lmulu')} == {
        '_snprintf': 7, '__ldivu': 4, '__lremu': 2, '__lmulu': 1}
    assert functions['__ZN12_GLOBAL__N_16bottomEv']['static_call_counts']['_snprintf'] == 1
    assert functions['_main']['static_call_counts']['__lrems'] == 2
    assert functions['__ZN12_GLOBAL__N_15paintEv']['static_call_counts']['__lrems'] == 1

    records = []
    for label, directory in (
        ('latest-qualified-control', BENCH / 'evidence/prace900ab01/compact'),
        ('prior-compact-ab', CONTROL / 'evidence/rlyrtab01/compact'),
        ('prior-compact-ba', CONTROL / 'evidence/rlyrtba01/compact'),
    ):
        result = load(directory / 'result.json')
        pin(directory / 'stages.csv')
        with (directory / 'stages.csv').open(newline='') as stream:
            rows = list(csv.DictReader(stream))
        assert len(rows) == 1
        stages = {k: int(v) for k, v in rows[0].items()}
        assert result['frames'] == 900 and result['physics_ticks'] == 3600
        assert stages['loop_prt_ms'] == result['prt_ticks']
        assert stages['wire_bytes'] == result['timed_wire_bytes'] == 291568
        records.append({'label': label, 'directory': str(directory), 'result': result,
                        'stages_overlapping_nominal_prt_units': stages,
                        'nominal_mos_seconds': result['elapsed_mos_ticks'] / result['mos_tick_hz'],
                        'nominal_mos_fps': 900 * result['mos_tick_hz'] / result['elapsed_mos_ticks'],
                        'separate_nominal_prt_seconds': result['prt_ticks'] / 1000,
                        'separate_nominal_prt_fps': 900000 / result['prt_ticks']})
    manifest = {'schema': 1, 'scope': 'offline read-only review of existing control',
                'frozen_control_inputs_verified': len(frozen),
                'protected_archives_sources_verified': len(protected),
                'reviewed_package_members_verified': len(reviewed),
                'graphics_files_verified': len(graphics['files']),
                'files': dict(sorted(inputs.items()))}
    return {'INPUTS.json': manifest, 'ASSEMBLY-CALLS.json': functions,
            'EXISTING-EVIDENCE.json': {'schema': 1, 'new_measurements': False, 'runs': records}}


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--write', action='store_true')
    args = parser.parse_args()
    for name, value in generate().items():
        text = json.dumps(value, indent=2) + '\n'
        path = HERE / name
        if args.write:
            path.write_text(text)
        else:
            assert path.read_text() == text, name
    print(f'PASS: {len(inputs)} exact input hashes; static call counts; three existing runs. No target run.')
