"""Host protocol qualification, not a substitute for native VDP rendering.

Decode the generated wire bytes through the relevant stock-VDP operations,
then compare the emitted geometry with an independent endpoint formula.
"""
import copy
import math
from pathlib import Path
import shutil
import struct
import subprocess
import tempfile
import unittest

import protocol as p


def f32(value):
    return struct.unpack('<f', struct.pack('<f', value))[0]


class Reader:
    def __init__(self, data):
        self.data = bytes(data)
        self.offset = 0

    def take(self, count):
        result = self.data[self.offset:self.offset + count]
        if len(result) != count:
            raise AssertionError('truncated VDU command')
        self.offset += count
        return result

    def byte(self):
        return self.take(1)[0]

    def word(self):
        return struct.unpack('<H', self.take(2))[0]


class ProtocolMachine:
    """Narrow decoder for the actual bytes, retaining separate buffer blocks.

    Matrix products round to float32 after each multiply/add. Real DSP fused
    operations may round differently; geometry comparisons allow one pixel.
    """
    def __init__(self):
        self.buffers = {}
        self.sizes = {}
        self.events = []
        self.nops = 0
        self.affine = False

    def matrix(self, ident):
        rows, columns = self.sizes[ident]
        data = self.buffers[ident]
        assert len(data) == 1 and len(data[0]) == rows * columns * 4
        return rows, columns, struct.unpack('<' + 'f' * rows * columns, data[0])

    def set_matrix(self, ident, rows, columns, values):
        self.sizes[ident] = (rows, columns)
        self.buffers[ident] = [bytearray(struct.pack('<' + 'f' * len(values), *values))]

    def run(self, wire):
        r = Reader(wire)
        while r.offset < len(r.data):
            first = r.byte()
            if first == 0:
                self.nops += 1
                continue
            if first == 18:
                self.events.append(('colour', r.byte(), r.byte()))
                continue
            if first == 25:
                self.events.append(('plot', r.byte(), *struct.unpack('<hh', r.take(4))))
                continue
            assert first == 23 and r.byte() == 0
            kind = r.byte()
            if kind == 0xf8:
                assert (r.word(), r.word()) == (1, 1)
                self.affine = True
                continue
            assert kind == 0xa0
            ident, op = r.word(), r.byte()
            if op == 0:
                self.buffers.setdefault(ident, []).append(bytearray(r.take(r.word())))
            elif op == 2:
                self.buffers.pop(ident, None)
                self.sizes.pop(ident, None)
            elif op == 1:
                for data in list(self.buffers[ident]):
                    self.run(data)
            elif op == 5:
                operation, offset, count = r.byte(), r.word(), r.word()
                if operation == 0xc2:
                    source = r.take(count)
                else:
                    assert operation == 0xe2
                    source_id, source_offset = r.word(), r.word()
                    source = bytes(self.buffers[source_id][0][source_offset:source_offset + count])
                assert len(source) == count
                assert offset + count <= len(self.buffers[ident][0])
                self.buffers[ident][0][offset:offset + count] = source
            elif op == 34:
                assert self.affine
                operation, rows, columns = r.byte(), r.byte(), r.byte()
                if operation == 0:
                    assert r.byte() == 0
                    values = struct.unpack('<' + 'f' * rows * columns, r.take(rows * columns * 4))
                elif operation == 0x20:
                    assert r.byte() == 0xc0
                    source, offset = r.word(), r.word()
                    raw = self.buffers[source][0][offset:offset + rows * columns * 2]
                    values = struct.unpack('<' + 'h' * rows * columns, raw)
                else:
                    assert operation == 6
                    ar, ac, a = self.matrix(r.word())
                    br, bc, b = self.matrix(r.word())
                    dimensions = max(rows, columns, ar, ac, br, bc)
                    values = []
                    for row in range(rows):
                        for column in range(columns):
                            value = 0.0
                            for k in range(dimensions):
                                left = a[row * ac + k] if row < ar and k < ac else 0
                                right = b[k * bc + column] if k < br and column < bc else 0
                                value = f32(value + f32(left * right))
                            values.append(value)
                self.set_matrix(ident, rows, columns, values)
            elif op == 41:
                assert self.affine
                options, fmt, transform, source = r.byte(), r.byte(), r.word(), r.word()
                assert options == 0x4e and fmt == 0xc0
                offset, stride, limit = r.word(), r.word(), r.word()
                rows, columns, matrix = self.matrix(transform)
                assert rows == columns == 4
                output = []
                for original in self.buffers[source]:
                    target = bytearray(original)
                    for item in range(limit):
                        position = offset + item * stride
                        vector = (*struct.unpack_from('<hhh', original, position), 1)
                        values = []
                        for row in range(3):
                            value = 0.0
                            for column in range(4):
                                value = f32(value + f32(matrix[row * 4 + column] * vector[column]))
                            values.append(math.trunc(value) & 0xffff)
                        struct.pack_into('<HHH', target, position, *values)
                    output.append(target)
                self.buffers[ident] = output
            else:
                raise AssertionError(f'unsupported VDU buffered operation {op}')


class ProtocolTests(unittest.TestCase):
    def setUp(self):
        self.machine = ProtocolMachine()
        self.machine.run(p.startup())

    def test_startup_reserves_only_task_buffers_and_distinct_templates(self):
        self.assertEqual(p.BUFFER_IDS, tuple(range(30000, 30010)))
        self.assertTrue(set(self.machine.buffers).issubset(p.BUFFER_IDS))
        self.assertEqual(self.machine.buffers[p.PARAM], [bytes(8) + b'\x01\x00'])
        for template, painted, count in ((p.RED, True, 5), (p.WHITE, False, 4)):
            self.assertEqual(len(self.machine.buffers[template]), count)
            for raw, expected in zip(self.machine.buffers[template], p.strips(painted)):
                self.assertEqual(len(raw), 35)
                self.assertEqual(raw[:3], bytes((18, 0, expected[2])))
                for index, (u, v) in enumerate(((expected[0], 0), (expected[1], 0),
                                               (expected[0], 1), (expected[1], 1))):
                    pos = 3 + index * 8
                    self.assertEqual(raw[pos:pos + 2], bytes((25, 4 if index < 2 else 85)))
                    self.assertEqual(struct.unpack_from('<hhh', raw, pos + 2), (u, v, u * v))

    def test_execution_geometry_zero_padding_and_immutable_sources(self):
        untouched = {ident: copy.deepcopy(self.machine.buffers[ident])
                     for ident in (p.COEFFICIENTS, p.RED, p.WHITE, p.DRAW_RED, p.DRAW_WHITE)}
        # Straight, skewed, narrowing, clipped, and shared-boundary cases.
        cases = [(160, 160, 104, 224), (140, 180, 116, 160),
                 (-150, -60, 116, 224), (390, 450, 104, 120),
                 (-1, 0, 160, 161), (180, 140, 160, 224)]
        for painted in (True, False, True):
            for ct, cb, yt, yb in cases:
                self.machine.events.clear()
                self.machine.nops = 0
                wire = p.draw_section(ct, cb, yt, yb, painted)
                self.assertEqual(len(wire), 25)
                self.machine.run(wire)
                expected_strips = p.strips(painted)
                self.assertEqual(len(self.machine.events), len(expected_strips) * 5)
                self.assertEqual(self.machine.nops, len(expected_strips) * 8)
                for index, (left, right, colour) in enumerate(expected_strips):
                    events = self.machine.events[index * 5:index * 5 + 5]
                    self.assertEqual(events[0], ('colour', 0, colour))
                    for event, (u, centre, y) in zip(events[1:], ((left, ct, yt), (right, ct, yt),
                                                               (left, cb, yb), (right, cb, yb))):
                        self.assertEqual(event[0], 'plot')
                        self.assertEqual(event[3], y)
                        expected_x = math.trunc(centre + u * (y - 96) / 50)
                        self.assertLessEqual(abs(event[2] - expected_x), 1)
                for raw in self.machine.buffers[p.OUTPUT]:
                    for offset in (9, 17, 25, 33):
                        self.assertEqual(raw[offset:offset + 2], b'\0\0')
                for ident, original in untouched.items():
                    self.assertEqual(self.machine.buffers[ident], original)
                self.assertEqual(self.machine.buffers[p.PARAM][0][8:], b'\x01\x00')
                self.assertEqual(self.machine.matrix(p.TRANSFORM)[2][8:], (0, 0, 0, 0, 0, 0, 0, 1))

    def test_signed_packet_and_invalid_boundaries(self):
        packet = p.draw_section(-32768, 32767, 104, 224, False)
        self.assertEqual(struct.unpack('<hhhh', packet[11:19]), (-32768, 32767, 104, 224))
        self.assertEqual(packet[19:], p.command(p.DRAW_WHITE, 1))
        for args in ((0, 0, 103, 224), (0, 0, 104, 225), (0, 0, 224, 224),
                     (-32769, 0, 104, 224), (0, 32768, 104, 224)):
            with self.assertRaises(ValueError):
                p.draw_section(*args, True)

    def test_adjacent_sections_share_boundaries_within_one_rounding_pixel(self):
        # A point reached through the bottom's delta terms can round slightly
        # differently from the next section's top coefficient. Bound that
        # discrepancy across every possible interior screen-row boundary.
        maximum_difference = 0
        for y in range(105, 224):
            centre = (y * 37) % 540 - 100
            self.machine.events.clear()
            self.machine.run(p.draw_section(centre - 25, centre, 104, y, True))
            above = self.machine.events[:]
            self.machine.events.clear()
            self.machine.run(p.draw_section(centre, centre + 40, y, 224, True))
            below = self.machine.events[:]
            for strip_index in range(5):
                for edge in (0, 1):
                    end = above[strip_index * 5 + 3 + edge]
                    start = below[strip_index * 5 + 1 + edge]
                    self.assertEqual(end[3], start[3])
                    difference = abs(end[2] - start[2])
                    maximum_difference = max(maximum_difference, difference)
                    self.assertLessEqual(difference, 1)
        self.assertLessEqual(maximum_difference, 1)

    def test_generated_cpp_matches_wire_format_and_stream_overflow(self):
        self.assertEqual((p.ROOT / 'section_protocol.hpp').read_text(), p.cpp_header())
        compiler = shutil.which('c++')
        self.assertIsNotNone(compiler, 'host C++ compiler required for wire-format test')
        repo = p.ROOT.parents[2]
        source = '''#include "section_protocol.hpp"
#include <cstdio>
int main() {
  std::fwrite(rally::section::Startup,1,rally::section::StartupSize,stdout);
  rally::Stream out;
  rally::section::draw(out,-32768,32767,104,224,false);
  rally::section::draw(out,140,180,116,160,true);
  if(out.size != 50 || out.overflow) return 1;
  std::fwrite(out.data,1,out.size,stdout);
  for(unsigned i=0;i<200;++i) rally::section::draw(out,0,0,104,224,true);
  return !out.overflow || out.size != sizeof(out.data);
}
'''
        with tempfile.TemporaryDirectory(prefix='rally15-protocol-') as directory:
            directory = Path(directory)
            (directory / 'test.cpp').write_text(source)
            subprocess.run([compiler, '-std=c++17', '-Wall', '-Wextra', '-Werror',
                            '-fsanitize=address,undefined', '-I', str(repo / 'rally/include'),
                            '-I', str(p.ROOT), str(directory / 'test.cpp'), '-o', str(directory / 'test')],
                           check=True, capture_output=True)
            actual = subprocess.run([str(directory / 'test')], check=True, capture_output=True).stdout
        self.assertEqual(actual, p.startup() + p.draw_section(-32768, 32767, 104, 224, False)
                         + p.draw_section(140, 180, 116, 160, True))


if __name__ == '__main__':
    unittest.main()
