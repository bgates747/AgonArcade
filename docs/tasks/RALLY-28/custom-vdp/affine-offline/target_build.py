"""Build a standalone stock-command target probe; no emulator or remote access.

Real RGBA2222 source artwork is loaded once. All repeated commands live in VDP
buffers; timed eZ80 transmission is one six-byte buffered CALL per batch.
"""
from pathlib import Path
import argparse
import hashlib
import json
import os
import re
import shutil
import struct
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[4]
TARGET = HERE / 'target'
WORK = HERE / '.work/target-build'
SELECTED = ['traffic-far', 'traffic-middle', 'traffic-near', 'sign-far', 'sign-near', 'player-fixed-mirror']


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def command(key, operation):
    return b'\x17\0\xa0' + struct.pack('<H', key) + bytes([operation])


def artwork_bytes(cases, workload):
    bitmaps = {bitmap['bitmap_id']: bitmap for bitmap in workload['bitmaps']}
    output = bytearray()
    resources = []
    for bitmap_id in sorted({case['bitmap_id'] for case in cases}):
        bitmap = bitmaps[bitmap_id]
        path = HERE / bitmap['path']
        assert sha(path) == bitmap['sha256']
        data = path.read_bytes()
        assert len(data) == bitmap['width'] * bitmap['height']
        key = 64000 + bitmap_id
        output += command(key, 2) + command(key, 0) + struct.pack('<H', len(data)) + data
        output += b'\x17\x1b\x20' + struct.pack('<H', key)
        output += b'\x17\x1b\x21' + struct.pack('<HHB', bitmap['width'], bitmap['height'], 1)
        resources.append(dict(bitmap_id=bitmap_id, buffer=key, bytes=len(data),
                              source_path=bitmap['path'], source_sha256=bitmap['sha256']))
    return bytes(output), resources


def natural_bounds(case):
    xx, xy, tx, yx, yy, ty = case['matrix_q8']
    corners = [(0, 0), (case['source_width'], 0),
               (0, case['source_height']), (case['source_width'], case['source_height'])]
    xs = [int((xx * x + xy * y + tx) / 256) for x, y in corners]
    ys = [int((yx * x + yy * y + ty) / 256) for x, y in corners]
    return min(xs), min(ys), max(xs), max(ys)


def config(draws, samples, setup, mask, poll):
    return struct.pack('<4sHHHHHBB', b'R28A', 1, draws, samples, setup, mask, int(poll), 0)


def build():
    workload_path = HERE / 'WORKLOAD.json'
    workload = json.loads(workload_path.read_text())
    entries = {case['name']: case for case in workload['target_cases']}
    cases = [entries[name] for name in SELECTED]
    header = '#pragma once\n#include <stdint.h>\n'
    header += 'struct AffineCase {const char *name;uint16_t source;int matrix[6];int x,y,minX,minY;int clip[4];};\n'
    header += 'constexpr unsigned CaseCount=6;\nconstexpr AffineCase Cases[]={\n'
    described = []
    for case in cases:
        bounds = natural_bounds(case)
        header += ('{"' + case['name'] + '",' + str(64000 + case['bitmap_id']) + ',{' + ','.join(map(str, case['matrix_q8']))
                   + '},' + ','.join(map(str, [case['x'], case['y'], bounds[0], bounds[1]]))
                   + ',{' + ','.join(map(str, case['clip'])) + '}},\n')
        described.append(dict(case, actual_bitmap_key=64000 + case['bitmap_id'],
                              natural_command40_bounds=list(bounds),
                              natural_command40_size=[bounds[2] - bounds[0] + 1, bounds[3] - bounds[1] + 1],
                              natural_command40_plot=[case['x'] + bounds[0], case['y'] + bounds[1]]))
    header += '};\n'
    TARGET.mkdir(parents=True, exist_ok=True)
    (TARGET / 'cases.hpp').write_text(header)
    donor = ROOT / 'rally-game/src/timing_prt.asm'
    shutil.copyfile(donor, TARGET / 'timing_prt.asm')
    (WORK / 'src').mkdir(parents=True, exist_ok=True)
    (WORK / 'include').mkdir(exist_ok=True)
    for source in TARGET.glob('*'):
        if source.suffix in ('.cpp', '.asm'):
            shutil.copyfile(source, WORK / 'src' / source.name)
    shutil.copyfile(TARGET / 'cases.hpp', WORK / 'include/cases.hpp')
    make = ('NAME=probe\nLDHAS_ARG_PROCESSING=0\nLDHAS_EXIT_HANDLER=0\n'
            'include /Agon/agondev/release/config/makefile.inc\n'
            'CXXFLAGS += -std=c++17 -fno-exceptions -fno-rtti -Wall -Wextra -Werror\n')
    (WORK / 'Makefile').write_text(make)
    environment = dict(os.environ, PATH='/Agon/agondev/release/bin:' + os.environ['PATH'])
    result = subprocess.run(['make', '-C', str(WORK)], env=environment, check=False,
                            stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    (HERE / 'TARGET-BUILD-OUTPUT.txt').write_text(result.stdout)
    assert result.returncode == 0, result.stdout
    mapping = (WORK / 'bin/probe.map').read_text()
    for name in ('init_array', 'ctors', 'dtors', 'fini_array'):
        found = re.search(r'^\.' + name + r'\s+0x[0-9a-f]+\s+(0x[0-9a-f]+)', mapping, re.M)
        assert found and int(found[1], 16) == 0, name
    artwork, resources = artwork_bytes(cases, workload)
    binary = (WORK / 'bin/probe.bin').read_bytes()
    fixture_registry = {}
    for name, draws, samples, setup, mask, poll in [
        ('full', 128, 4, 1024, 63, False),
        ('smoke', 4, 1, 16, 33, False),
        ('smoke-poll', 4, 1, 16, 33, True),
    ]:
        destination = TARGET / 'fixtures' / name
        destination.mkdir(parents=True, exist_ok=True)
        for filename, data in [('probe.bin', binary), ('artwork.vdu', artwork),
                               ('config.bin', config(draws, samples, setup, mask, poll)),
                               ('run.txt', b'load probe.bin\r\nrun .\r\n')]:
            (destination / filename).write_bytes(data)
        planned = (5 * mask.bit_count() + 1) * samples
        metadata = dict(schema=1, standalone_stock_commands=True, mode=136,
            double_buffered=True, timed_swaps=0, timed_drawing_on_hidden_page=True,
            source_workload_sha256=sha(workload_path), guest_sha256=sha(destination / 'probe.bin'),
            draw_repeats=draws, samples=samples, setup_repeats=setup, case_mask=mask,
            planned_batches=planned, primary_completion='general-poll' if poll else 'key-zero',
            config_contract='16B little endian <4sHHHHHBB: R28A,schema1,draw repeats,samples,setup repeats,case mask,poll selector,reserved0',
            timed_batch_uart_bytes=6, buffered_repeat_call_bytes=6,
            method_names=['ordinary-sized', 'cached-affine', 'rebuilt-affine', 'transform40-plot', 'matrix-only', 'empty'],
            affine_feature_enable=[23, 0, 248, 1, 0, 1, 0],
            matrix_only_repeat_body_has_no_drawing_or_inverse_generation=True,
            constant_batch_tail='One marker pixel plus flush/completion after every batch, including empty and matrix-only; no timed swap',
            command40_options=5, command40_dimensions='Natural resize+autoTranslate: max-min+1; differs from direct transformed exclusive edge loops',
            ordinary_sized_control='Stock command40 output prepared once before timing; no pre-scaled files or timed pixel uploads',
            warm_operation_before_each_batch=True, warm_completion_excluded=True,
            source_artwork=resources, target_cases=described,
            completion='Stored flush+key0 callback or explicit GP control; verify final marker only after primary completion',
            completion_limit='Ordered raster completion in synchronous mode136; no swap, physical scanout or host-window presentation claim',
            output_files=['summary.json', 'timings.csv', 'done.txt'],
            mos_clock_hz_nominal=120, prt_clock_hz_nominal=1000,
            mos_required_version='3.0.2 official; saved keyboard vector at sysvars+0x6c',
            files={path.name: sha(path) for path in destination.iterdir() if path.is_file() and path.name != 'expected.json'})
        (destination / 'expected.json').write_text(json.dumps(metadata, indent=2) + '\n')
        fixture_registry[name] = dict(directory=str(destination.relative_to(HERE)),
            files={path.name: sha(path) for path in sorted(destination.iterdir()) if path.is_file()},
            planned_batches=planned, diagnostic=True, foreground_paced=False)
    sources = [Path(__file__), TARGET / 'main.cpp', TARGET / 'callback.asm', TARGET / 'cases.hpp', TARGET / 'timing_prt.asm']
    report = dict(schema=1, compiled=True, emulator_launched=False,
        binary_sha256=sha(WORK / 'bin/probe.bin'), binary_bytes=len(binary),
        source_workload_sha256=sha(workload_path), source_artwork=resources,
        source_files={str(path.relative_to(HERE)): sha(path) for path in sources},
        prt_donor_sha256=sha(donor), no_dynamic_initializers=True,
        firmware_game_and_historical_fixture_changes=False, target_cases=described,
        fixture_registry=fixture_registry,
        limitations=['Nominal emulated clocks remain separate from host elapsed and physical ESP32 timing',
                     'Repeated same-position opaque/transparent drawing; not a complete-game frame benchmark',
                     'Setup, warm draws and readback occur outside timed batches; draw allocation stays within transform40 rows',
                     'No timed swap; empty-dispatch/fence control is reported without automatic subtraction'])
    (HERE / 'TARGET-FIXTURES.json').write_text(json.dumps(fixture_registry, indent=2) + '\n')
    (HERE / 'TARGET-BUILD.json').write_text(json.dumps(report, indent=2) + '\n')
    print('Built standalone target:', len(binary), 'bytes; full124 batches, smoke11; no emulator run.')


if __name__ == '__main__':
    argparse.ArgumentParser(description=__doc__).parse_args()
    build()
