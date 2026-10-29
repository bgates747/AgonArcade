"""Qualify actual sprite.inc against an independent rational Python oracle.

Ordinary and ASan/UBSan host execution only. The binary32 comparison is a
reciprocal/multiply boundary model, not an exact reproduction of Mat::inverse
or the Xtensa DSP accumulator. Pixel differences are observations, not a gate.
"""
from pathlib import Path
import argparse
import ctypes as C
import hashlib
import json
import os
import struct
import subprocess
import sys

HERE = Path(__file__).resolve().parent
WORK = HERE / '.work'
FIELDS = ('x', 'y', 'width', 'height', 'skip_x', 'skip_y', 'source_width',
          'source_height', 'scale', 'mirror', 'stride')


class Car(C.Structure):
    _fields_ = [(name, C.c_int32) for name in
                ('bitmap', 'matrix', 'scale', 'xx', 'translation', 'x', 'y')]


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def rational_plan(scale, mirror, sign, x, y, cliptop):
    """Use geometric intersections, independently of the candidate's planner."""
    source_width, source_height, stride = (64, 64, 62) if sign else (102, 77, 99)
    extent_x = ((101 if mirror else source_width) * scale) // 256
    extent_y = source_height * scale // 256
    left, right = max(x, 0), min(x + extent_x, 319)
    top, bottom = max(y, cliptop), min(y + extent_y, 223)
    if right <= left or bottom <= top:
        return None
    return (left, top, right - left, bottom - top, left - x, top - y,
            source_width, source_height, scale, int(mirror), stride)


def oracle_pixels(plan, source, initial):
    x, y, width, height, skip_x, skip_y, sw, sh, scale, mirror, stride = plan
    del x, y, sh
    target = bytearray(initial)
    xmap = []
    for column in range(width):
        numerator = (skip_x + column) * 256
        sample = 101 - (numerator + scale - 1) // scale if mirror else numerator // scale
        assert 0 <= sample < sw
        xmap.append(sample)
    for row in range(height):
        source_row = (skip_y + row) * 256 // scale
        for column, source_column in enumerate(xmap):
            target[row * stride + column] = source[source_row * sw + source_column]
    return bytes(target)


def positions(cliptop):
    # Entirely outside, exact borders, one-pixel slivers, all four clipped
    # corners, unobstructed pictures and upper-viewport restoration cases.
    return [(-200, cliptop), (-99, cliptop), (-1, cliptop), (0, cliptop),
            (1, cliptop), (120, cliptop - 80), (120, cliptop - 1),
            (120, cliptop), (120, cliptop + 1), (120, 120), (120, 180),
            (120, 222), (120, 223), (120, 224), (120, 400),
            (318, cliptop), (319, cliptop), (320, cliptop), (500, cliptop),
            (-1, cliptop - 1), (318, cliptop - 1), (-1, 222), (318, 222)]


def cases():
    seen = set()
    for scale in range(14, 251, 2):
        for sign, mirror in ((False, False), (False, True), (True, False)):
            for cliptop in ((104,) if sign else (24, 88)):
                for x, y in positions(cliptop):
                    case = scale, mirror, sign, x, y, cliptop
                    if case not in seen:
                        seen.add(case)
                        yield case
    # Cartesian border combinations at selected scales, independent of the
    # diagonal combinations above.
    for scale in (14, 16, 32, 64, 128, 160, 250):
        for sign, mirror in ((False, False), (False, True), (True, False)):
            for cliptop in ((104,) if sign else (24, 88)):
                for x in (-100, -99, -98, -2, -1, 0, 1, 217, 218, 219, 318, 319, 320):
                    for y in (cliptop - 76, cliptop - 1, cliptop, cliptop + 1, 150, 222, 223, 224):
                        case = scale, mirror, sign, x, y, cliptop
                        if case not in seen:
                            seen.add(case)
                            yield case


def f32(value):
    return struct.unpack('<f', struct.pack('<f', value))[0]


def float_boundaries():
    observations = 0
    differences = 0
    examples = []
    for scale in range(14, 251, 2):
        reciprocal = f32(1.0 / f32(scale / 256.0))
        for width, mirror in ((102, False), (102, True), (64, False)):
            extent = ((101 if mirror else width) * scale) // 256
            for dx in range(extent):
                value = f32(dx * reciprocal)
                float_sample = int(f32(101.0 - value)) if mirror else int(value)
                numerator = dx * 256
                exact = 101 - (numerator + scale - 1) // scale if mirror else numerator // scale
                observations += 1
                if float_sample != exact:
                    differences += 1
                    if len(examples) < 20:
                        examples.append(dict(scale=scale, width=width, mirror=mirror,
                                             destination_x=dx, rational=exact, binary32=float_sample))
    return dict(scope='Binary32 reciprocal/multiply model only; not actual Mat inverse/DSP parity',
                coordinate_observations=observations, differing_coordinates=differences,
                maximum_source_displacement=max((abs(e['rational'] - e['binary32']) for e in examples), default=0),
                examples=examples, acceptance_gate=False)


def worker(mode):
    lib = C.CDLL(str(WORK / ('sampler_unit-' + mode + '.so')))
    lib.sampler_unit_plan.argtypes = [C.POINTER(Car), C.c_int, C.c_int, C.POINTER(C.c_int)]
    lib.sampler_unit_sample.argtypes = [C.POINTER(C.c_uint8), C.POINTER(C.c_uint8), C.POINTER(C.c_int)]
    images = {}
    for width, height in ((102, 77), (64, 64)):
        raw = bytes((((x * 13 + y * 17 + 7) & 63) | (((x + y) & 3) << 6))
                    for y in range(height) for x in range(width))
        images[width] = raw, (C.c_uint8 * len(raw)).from_buffer_copy(raw)
    total = visible = samples = alpha_mask = 0
    cases_by_kind = {'normal_car': 0, 'mirrored_car': 0, 'sign': 0}
    for scale, mirror, sign, x, y, cliptop in cases():
        key = 'sign' if sign else 'mirrored_car' if mirror else 'normal_car'
        cases_by_kind[key] += 1
        car = Car(120 if sign else 5, 63930 if sign else 63970,
                  scale, -scale if mirror else scale, 101 * scale if mirror else 0, x, y)
        expected = rational_plan(scale, mirror, sign, x, y, cliptop)
        output = (C.c_int * len(FIELDS))()
        present = lib.sampler_unit_plan(C.byref(car), int(sign), cliptop, output)
        assert bool(present) == bool(expected), ('visibility', scale, mirror, sign, x, y, cliptop, present, expected)
        total += 1
        if expected is None:
            continue
        actual = tuple(output)
        assert actual == expected, ('plan', scale, mirror, sign, x, y, cliptop, actual, expected)
        visible += 1
        source, csource = images[expected[6]]
        stride, rows = expected[-1], 62 if sign else 75
        initial = bytes([0xa5]) * (stride * rows)
        destination = (C.c_uint8 * len(initial)).from_buffer_copy(initial)
        guard = lib.sampler_unit_sample(destination, csource, output)
        assert guard == 0, ('scratch guard', scale, mirror, sign, x, y, cliptop, guard)
        reference = oracle_pixels(expected, source, initial)
        rendered = bytes(destination)
        assert rendered == reference, ('pixels', scale, mirror, sign, x, y, cliptop,
                                       next(i for i, (a, b) in enumerate(zip(rendered, reference)) if a != b))
        samples += expected[2] * expected[3]
        # Track all alpha bit patterns in actually sampled candidate pixels.
        for row in range(expected[3]):
            for value in rendered[row * stride:row * stride + expected[2]]:
                alpha_mask |= 1 << (value >> 6)
    assert alpha_mask == 15
    result = dict(schema=1, mode=mode, scope='Pure actual candidate planner/sampler on host; no emulator or timing claim',
                  passed=True, total_cases=total, visible_cases=visible, sampled_pixels=samples,
                  cases_by_kind=cases_by_kind, scale_domain={'first': 14, 'last': 250, 'step': 2},
                  alpha_patterns_observed=[0, 1, 2, 3], guard_bytes_each_side=32,
                  unsampled_scratch_unchanged=True,
                  sources={name: sha(HERE / name) for name in ('sprite.inc', 'sampler_unit_host.c', 'sampler_units.py')},
                  host_library_sha256=sha(WORK / ('sampler_unit-' + mode + '.so')),
                  float_boundary_observations=float_boundaries())
    (HERE / ('sampler_unit-' + mode + '.json')).write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps({k: result[k] for k in ('mode', 'passed', 'total_cases', 'visible_cases', 'sampled_pixels')}, indent=2), flush=True)


def main():
    WORK.mkdir(exist_ok=True)
    for mode in ('ordinary', 'sanitized'):
        flags = [] if mode == 'ordinary' else ['-fsanitize=address,undefined', '-fno-omit-frame-pointer']
        subprocess.run(['cc', '-std=c11', '-shared', '-fPIC', '-O1', '-fno-builtin', '-ffp-contract=off',
                        *flags, str(HERE / 'sampler_unit_host.c'), '-o', str(WORK / ('sampler_unit-' + mode + '.so'))], check=True)
        env = os.environ.copy()
        if mode == 'sanitized':
            env['LD_PRELOAD'] = subprocess.check_output(['cc', '-print-file-name=libasan.so'], text=True).strip()
            env['ASAN_OPTIONS'] = 'detect_leaks=0:halt_on_error=1'
            env['UBSAN_OPTIONS'] = 'halt_on_error=1:print_stacktrace=1'
        subprocess.run([sys.executable, __file__, '--worker', mode], env=env, check=True)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--worker', choices=('ordinary', 'sanitized'))
    args = parser.parse_args()
    worker(args.worker) if args.worker else main()
