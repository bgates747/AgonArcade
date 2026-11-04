"""Finite actual-C road/state comparison; host row mappings are explicit mocks."""
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
CUSTOM = HERE.parent
BASE_SOURCE = CUSTOM / 'incremental/round-trips/source'
sys.path.insert(0, str(CUSTOM / 'full-race'))
from host_reference import SpriteRuntime, specification, snapshot, independent, BASE, Traffic
from host import Host


class Frame(C.Structure):
    _fields_ = [('struct_bytes', C.c_uint32), ('lease', C.c_uint32),
                ('x', C.c_int32), ('y', C.c_int32)] + [
                (n, C.c_uint32) for n in ('width', 'height', 'row', 'native_format')] + [
                ('data', C.POINTER(C.c_uint8))] + [
                (n, C.c_uint32) for n in ('row_bytes', 'x_bias', 'pixel_xor', 'color_mask', 'preserve_mask')]


Color = C.CFUNCTYPE(C.c_int32, C.c_void_p, C.c_uint32, C.POINTER(Frame))


class ExtendedHost(C.Structure):
    _fields_ = Host._fields_ + [(n, C.c_void_p) for n in (
        'vdu', 'lines', 'surface', 'pixels', 'pcm_open', 'pcm_enqueue', 'pcm_state',
        'pcm_control', 'pcm_close', 'audio_queue', 'pcm_sink', 'color_frame')]


class RowsRuntime(SpriteRuntime):
    def __init__(self, spec, library):
        super().__init__(spec, library)
        self.table = ExtendedHost(C.sizeof(ExtendedHost), 1, 6, 273, None,
                                  self.acquire_cb, self.release_cb, None, None, None)
        self.color_cb = Color(self.color)
        self.table.color_frame = C.cast(self.color_cb, C.c_void_p).value
        self.host = C.cast(C.pointer(self.table), C.POINTER(Host)).contents
        # Separate allocations per row/page, with guard bytes and varying sync.
        self.pages = [[(C.c_uint8 * 352)() for _ in range(120)] for _ in range(2)]
        self.sync = []
        for page, rows in enumerate(self.pages):
            saved = []
            for y, row in enumerate(rows):
                row[:] = bytes([0xa6]) * 352
                row[16:336] = bytes((((x + y + page) & 3) << 6) | 0x2a for x in range(320))
                saved.append(bytes(row[16:336]).translate(bytes(i & 0xc0 for i in range(256))))
            self.sync.append(saved)
        self.page = 0
        self.active = False
        self.token = 0
        self.begins = self.ends = 0
        self.row_calls = []
        self.callback_error = None
        self.row_fault = None
        self.store(50700, 0, bytes([0xa5]) * 38400)

    def color(self, context, operation, pointer):
        try:
            f = pointer.contents
            assert f.struct_bytes == C.sizeof(Frame)
            if operation == 1:
                assert not self.active and f.lease == 0
                assert (f.x, f.y, f.width, f.height) == (0, 104, 320, 120)
                if self.row_fault == 'begin':
                    return 7
                self.active = True
                self.token += 1
                self.begins += 1
                self.row_calls = []
                f.lease = self.token
                f.native_format = 64
                f.data = C.POINTER(C.c_uint8)()
                f.row_bytes = f.x_bias = 0
                f.pixel_xor, f.color_mask, f.preserve_mask = 2, 63, 192
                if self.row_fault == 'layout':
                    f.pixel_xor = 0
                return 0
            assert self.active and f.lease == self.token
            if operation == 3:
                self.active = False
                self.ends += 1
                f.lease = f.row_bytes = 0
                f.data = C.POINTER(C.c_uint8)()
                return 0
            assert operation == 2 and f.row < 120
            if self.row_fault == ('row', f.row):
                return 3
            self.row_calls.append(f.row)
            f.data = C.cast(C.addressof(self.pages[self.page][f.row]) + 16, C.POINTER(C.c_uint8))
            f.row_bytes = 320
            if self.row_fault == 'null':
                f.data = C.POINTER(C.c_uint8)()
            elif self.row_fault == 'short':
                f.row_bytes = 319
            return 0
        except Exception as error:
            self.callback_error = repr(error)
            return 1

    def compare_road(self, rgba):
        assert self.row_calls == list(range(120)), self.row_calls
        mask = bytes(i & 63 for i in range(256))
        sync = bytes(i & 192 for i in range(256))
        for y, row in enumerate(self.pages[self.page]):
            raw = bytes(row[16:336])
            assert raw.translate(sync) == self.sync[self.page][y], ('sync', y)
            assert bytes(row[:16]) == bytes(row[336:]) == b'\xa6' * 16
            logical = bytearray(320)
            logical[0::4], logical[1::4] = raw[2::4], raw[3::4]
            logical[2::4], logical[3::4] = raw[0::4], raw[1::4]
            assert bytes(logical).translate(mask) == rgba[y*320:(y+1)*320].translate(mask), y
        assert self.data(50700) == b'\xa5' * 38400, 'Intermediate road image was written'
        assert not self.active and not self.callback_error
        self.page ^= 1


def worker(mode):
    work = HERE / '.work/host'
    reference = SpriteRuntime(specification(BASE_SOURCE), work / ('original-' + mode + '.so'))
    bitmap = SpriteRuntime(specification(HERE / 'source/bitmap'), work / ('bitmap-' + mode + '.so'))
    rows = RowsRuntime(specification(HERE / 'source/rows'), work / ('rows-' + mode + '.so'))
    runtimes = (reference, bitmap, rows)
    for runtime in runtimes:
        assert runtime.invoke('InitRace') == 0
    pixel_hash = hashlib.sha256()

    def compare():
        assert snapshot(reference) == snapshot(bitmap) == snapshot(rows)
        old = reference.data(50304)
        assert old == bitmap.data(50304)
        direct = bytearray(rows.data(50304))
        length = struct.unpack_from('<I', old, 24)[0]
        assert struct.unpack_from('<I', direct, 24)[0] == length - 18
        struct.pack_into('<I', direct, 24, length)
        assert bytes(direct) == old
        assert reference.data(50301) == bitmap.data(50301)
        assert reference.data(50301)[18:length] == rows.data(50301)[:length-18]
        for key in (50302, 50303, *range(50710, 50718)):
            assert reference.data(key) == bitmap.data(key) == rows.data(key), key
        pixels = reference.data(50700)
        assert pixels == bitmap.data(50700)
        rows.compare_road(pixels)
        pixel_hash.update(pixels)

    for _ in range(2):
        for runtime in runtimes:
            assert runtime.invoke('Render30') == 0
        compare()
    fixture = CUSTOM / 'full-race/fixtures/additive'
    meta = json.loads((fixture / 'expected.json').read_text())
    motion = (fixture / 'motion.bin').read_bytes()
    lanes = struct.pack('<6i', *meta['fixed_display_lanes'])
    tables = json.loads((BASE / 'reference/tables.json').read_text())
    model = Traffic(tables, 'circuit', 3276800, 1, 99)
    player = 3246800
    for car, gap in zip(model.cars, [0, 3199, 3200, 6400, 18000, 80000]):
        car.active, car.progress, car.position, car.lateral = 1, player+gap, (player+gap) % model.lap, 0
    for tick in range(1, 3601):
        record = (model.pace.record+1) % 6 if model.pace.remaining == 0 else model.pace.record
        player += tables['records'][record][1] * 2
        model.advance(player, tick)
        for runtime in runtimes:
            assert runtime.invoke('Tick120') == 0
        assert snapshot(reference) == snapshot(bitmap) == snapshot(rows)
        independent(rows, model, player, tick)
        if tick % 4:
            continue
        data = motion[(tick//4-1)*24:tick//4*24]
        for runtime in runtimes:
            runtime.store(4, 0, data)
            runtime.store(5, 0, lanes)
        for car, pos, lat in zip(model.cars, struct.unpack('<6I', data), meta['fixed_display_lanes']):
            car.position, car.lateral = pos, lat
        for runtime in runtimes:
            assert runtime.invoke('Render30') == 0
        compare()
    assert snapshot(rows) == json.loads((CUSTOM / 'full-race/EXPECTED-FINAL-900.json').read_text())

    # Unused diagnostics must refuse before mutating the established state.
    for runtime in (bitmap, rows):
        for entry in set(range(17)) - {3, 13, 15, 16}:
            assert runtime.invoke(entry=entry) != 0
    faults = ['begin', 'layout', 'null', 'short', ('row', 0), ('row', 59), ('row', 119)]
    for fault in faults:
        rows.row_fault = fault
        assert rows.invoke('Render30') != 0
        assert not rows.active and rows.begins == rows.ends and not rows.live
        assert struct.unpack_from('<H', rows.data(50304), 44)[0] == 0
        assert not rows.callback_error
    rows.row_fault = None
    for runtime in runtimes:
        assert runtime.invoke('StopRace') == runtime.invoke(operation=3) == 0
        runtime.canaries()
        assert not runtime.live and runtime.grants == runtime.releases
    result = dict(passed=True, mode=mode, frames=900, warm_frames=2, physics_ticks=3600,
                  independent_world_each_tick=True, full_original_state_and_actor_output_exact=True,
                  road_pixels_compared=902*38400, both_page_parities=True,
                  row_guard_and_sync_bits_preserved=True, row_scope_balanced=True,
                  intermediate_road_image_untouched=True, road_command_bytes_removed_per_frame=18,
                  row_faults=[str(x) for x in faults], max_buffer_leases=max(r.peak for r in runtimes),
                  original_road_pixel_sha256=pixel_hash.hexdigest(),
                  limitation='Row service is a host mock; no target raster, Canvas scheduling or FPS claim')
    (HERE / ('HOST-' + mode + '.json')).write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(result, indent=2))


def build_and_check():
    work = HERE / '.work/host'
    work.mkdir(parents=True, exist_ok=True)
    for mode in ('ordinary', 'sanitized'):
        for name in ('original', 'bitmap', 'rows'):
            source = BASE_SOURCE / 'checked.c' if name == 'original' else HERE / 'source' / name / 'checked.c'
            export = work / (name + '.c')
            export.write_text('#include "' + str(source) + '"\n'
                              'void host_actor(unsigned n,int32_t *out){memcpy(out,n<6?&renderer.cars[n]:&renderer.signs[n-6],28);}\n')
            flags = [] if mode == 'ordinary' else ['-fsanitize=address,undefined', '-fno-omit-frame-pointer']
            args = ['cc', '-shared', '-fPIC', '-O1', '-fno-builtin', '-ffp-contract=off', *flags,
                    '-I' + str(HERE / 'sdk/include'), str(export), '-o', str(work / (name+'-'+mode+'.so'))]
            subprocess.run(args, check=True, timeout=180)
        env = dict(os.environ)
        if mode == 'sanitized':
            env.update(LD_PRELOAD=subprocess.check_output(['cc', '-print-file-name=libasan.so'], text=True).strip(),
                       ASAN_OPTIONS='detect_leaks=0:halt_on_error=1', UBSAN_OPTIONS='halt_on_error=1')
        run = subprocess.run([sys.executable, __file__, '--worker', mode], env=env,
                             text=True, capture_output=True, timeout=180)
        (HERE / ('HOST-' + mode + '.txt')).write_text(run.stdout + run.stderr)
        print(run.stdout + run.stderr)
        if run.returncode:
            raise SystemExit(run.returncode)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--worker', choices=['ordinary', 'sanitized'])
    args = parser.parse_args()
    worker(args.worker) if args.worker else build_and_check()
