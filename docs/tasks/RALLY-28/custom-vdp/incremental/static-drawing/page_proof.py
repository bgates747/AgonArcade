"""Independent retained-page proof using the accepted generated moving scene.

This is a region/history proof, not a stock font or physical VGA emulator. The
actual generated road bitmap/commands, sampled actor buffers and fixed player
commands are composed on two retained pages. Synthetic actor/player pixels
exercise all four alpha values. An arbitrary stable glyph pattern represents
unchanged title bytes; its exact raster cannot affect the invariant-region proof.
No emulator or upstream mutation is involved.
"""
from pathlib import Path
import ctypes as C
import hashlib
import json
import struct
import subprocess
import sys

HERE = Path(__file__).resolve().parent
INC = HERE.parent
SPRITES = INC / 'sprites'
WIDE = INC / 'wide-fill'
WORK = HERE / '.work/page-proof'
PACKAGE = WIDE / '.work/control/package'
sys.path.insert(0, str(SPRITES))
from host_replay import SpriteRuntime, PACED, specification

WIDTH, HEIGHT = 320, 240
TITLE = b'RALLY / GOLEM NATIVE DEMO\r\nFuji - centerline / no damage\r\n'
CALLS = b''.join(b'\x17\0\xa0' + struct.pack('<H', i) + b'\1' for i in (50301, 50302, 50303))
VIEWPORT = b'\x18' + struct.pack('<hhhh', 0, 223, 319, 24) + b'\x19\4' + struct.pack('<hh', 0, 24)
ALPHA = bytes(v >> 6 for v in range(256))
COLOUR = bytes(v & 63 for v in range(256))
GLYPHS = {v: tuple(bytes(63 if ((v >> ((x + y) & 7)) & 1) else 0 for x in range(8))
                   for y in range(8)) for v in range(32, 127)}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def rect(left, top, right, bottom):
    return b'\x19\4' + struct.pack('<hh', left, top) + b'\x19\x65' + struct.pack('<hh', right, bottom)


def tape_records(data):
    """Private tape decoder, including the accepted motion opcode13."""
    offset, loop = 0, False
    result = []
    while offset < len(data):
        first = offset
        opcode = data[offset]
        offset += 1
        record = dict(offset=first, opcode=opcode, loop=loop)
        if opcode in (1, 3, 9, 12):
            n = int.from_bytes(data[offset:offset + 2], 'little')
            offset += 2
            record['value'] = n
            if opcode == 1:
                record['payload'] = data[offset:offset + n]
                offset += n
            elif opcode == 9:
                assert not loop
                loop = True
        elif opcode == 2:
            token, kind, flags, value, patch, size = struct.unpack_from('<HBBHHH', data, offset)
            offset += 10
            record.update(token=token, kind=kind, flags=flags, value=value, patch=patch,
                          payload=data[offset:offset + size])
            offset += size
        elif opcode == 4:
            patch, size = struct.unpack_from('<HH', data, offset)
            offset += 4
            record.update(patch=patch, payload=data[offset:offset + size])
            offset += size
        elif opcode == 6:
            size = int.from_bytes(data[offset:offset + 3], 'little')
            offset += 3
            end = data.index(0, offset)
            record.update(size=size, filename=data[offset:end].decode())
            offset = end + 1
        elif opcode == 10:
            assert loop
            loop = False
        elif opcode == 0:
            assert offset == len(data) and not loop
        else:
            assert opcode in (5, 11, 13), (first, opcode)
        assert offset <= len(data)
        record['raw'] = data[first:offset]
        result.append(record)
    assert result[-1]['opcode'] == 0
    return result


def fixture_contract():
    control = HERE / 'fixtures/control'
    candidate = HERE / 'fixtures/static'
    old = tape_records((control / 'script.bin').read_bytes())
    new = tape_records((candidate / 'script.bin').read_bytes())
    old_paint = b'\x1a\x1f\0\0' + TITLE + b'\x12\0\x10' + rect(0, 24, 319, 103) + rect(0, 224, 319, 239) + VIEWPORT + CALLS
    new_paint = b'\x1a\x12\0\x10' + rect(0, 100, 319, 103) + VIEWPORT + CALLS
    page_setup = b'\x1a\x1f\0\0' + TITLE + b'\x12\0\x10' + rect(0, 24, 319, 103) + rect(0, 224, 319, 239) + b'\x17\0\xc3'
    expected_setup = page_setup * 2
    old_draw = [r for r in old if r['loop'] and r.get('payload') == old_paint]
    new_draw = [r for r in new if r['loop'] and r.get('payload') == new_paint]
    setups = [r for r in new if not r['loop'] and r.get('payload') == expected_setup]
    assert len(old_draw) == len(new_draw) == len(setups) == 1
    # Exact identity of every other tape record, not only a copied metadata label.
    old_other = [r['raw'] for r in old if r is not old_draw[0]]
    new_other = [r['raw'] for r in new if r is not new_draw[0] and r is not setups[0]]
    assert old_other == new_other
    assert len(old_paint) == 122 and len(new_paint) == 49 and len(expected_setup) == 184
    setup_index = new.index(setups[0])
    assert new[setup_index + 1]['opcode'] == 2 and new[setup_index + 1]['token'] == 3
    assert new[setup_index + 1]['kind'] == 4 and new[setup_index + 1]['flags'] == 2
    assert new[setup_index + 2]['opcode'] == 5, 'Setup must precede checked INFO and initial mark'
    assert [r['value'] for r in old if r['opcode'] == 9] == [900]
    for file in control.iterdir():
        if file.name not in ('script.bin', 'expected.json'):
            assert file.read_bytes() == (candidate / file.name).read_bytes(), file.name
    assert (control / 'script.bin').read_bytes() == (WIDE / 'fixtures/byte/script.bin').read_bytes()
    return old_paint, new_paint, expected_setup, dict(
        control_paint_bytes=len(old_paint), candidate_paint_bytes=len(new_paint),
        recurring_uart_bytes_saved=73, setup_uart_bytes=184, setup_tape_bytes=187,
        two_setup_swaps=True, unchanged_nonpaint_records=True,
        setup_followed_by_existing_checked_info_before_initial_mark=True,
        control_script_sha256=sha((control / 'script.bin').read_bytes()),
        candidate_script_sha256=sha((candidate / 'script.bin').read_bytes()))


class PageModel:
    """VDU subset actually emitted here; preserve pending and active clips."""
    def __init__(self, pages):
        self.pages = [bytearray(p) for p in pages]
        self.draw_page = 0
        self.pending_clip = self.active_clip = (0, 0, 319, 239)
        self.move = (0, 0)
        self.cursor = (0, 0)
        self.colour = 0
        self.bitmap = None
        self.output = {}
        self.images = {}
        self.writes = 0
        self.alpha = [0, 0, 0, 0]
        self.draw_bounds = None
        self.full_resets = 0
        self.bottom_attempts = 0
        self.bottom_writes = 0
        self.saw_pending_move = False

    def reset_bounds(self):
        self.draw_bounds = None

    def point(self, x, y, colour):
        left, top, right, bottom = self.active_clip
        if 0 <= x < WIDTH and 0 <= y < HEIGHT and left <= x <= right and top <= y <= bottom:
            self.pages[self.draw_page][y * WIDTH + x] = colour
            self.writes += 1
            if self.draw_bounds is None:
                self.draw_bounds = [x, y, x, y]
            else:
                self.draw_bounds = [min(self.draw_bounds[0], x), min(self.draw_bounds[1], y),
                                    max(self.draw_bounds[2], x), max(self.draw_bounds[3], y)]
            if y >= 224:
                self.bottom_writes += 1

    def rectangle(self, left, top, right, bottom):
        x1, y1, x2, y2 = self.active_clip
        if top == 224 and bottom == 239:
            self.bottom_attempts += 1
        left, top = max(left, x1, 0), max(top, y1, 0)
        right, bottom = min(right, x2, 319), min(bottom, y2, 239)
        if left > right or top > bottom:
            return
        row = bytes([self.colour]) * (right - left + 1)
        for y in range(top, bottom + 1):
            self.pages[self.draw_page][y * WIDTH + left:y * WIDTH + right + 1] = row
        count = (right - left + 1) * (bottom - top + 1)
        self.writes += count
        if self.draw_bounds is None:
            self.draw_bounds = [left, top, right, bottom]
        else:
            self.draw_bounds = [min(self.draw_bounds[0], left), min(self.draw_bounds[1], top),
                                max(self.draw_bounds[2], right), max(self.draw_bounds[3], bottom)]
        self.bottom_writes += (right - left + 1) * max(0, bottom - max(top, 224) + 1)

    def glyph(self, value):
        # Stable opaque foreground/background pattern within the actual 8x8
        # cell. This deliberately is not a copy of the stock font raster.
        column, line = self.cursor
        assert line < 2 and column < 40, ('title exceeds invariant band', column, line)
        assert self.active_clip == (0, 0, 319, 239)
        for y, pixels in enumerate(GLYPHS[value]):
            start = (line * 8 + y) * WIDTH + column * 8
            self.pages[self.draw_page][start:start + 8] = pixels
        self.writes += 64
        self.cursor = (column + 1, line)

    def image(self, x, y):
        width, height, data = self.images[self.bitmap]
        assert len(data) == width * height
        assert self.active_clip == self.pending_clip, 'Plot before activating pending VDU24 clip'
        left, right = max(x, self.active_clip[0], 0), min(x + width - 1, self.active_clip[2], 319)
        top, bottom = max(y, self.active_clip[1], 0), min(y + height - 1, self.active_clip[3], 239)
        if left > right or top > bottom:
            return
        count = right - left + 1
        for yy in range(top, bottom + 1):
            source = (yy - y) * width + left - x
            pixels = data[source:source + count]
            mask = pixels.translate(ALPHA)
            counts = [mask.count(a) for a in range(4)]
            for alpha, n in enumerate(counts): self.alpha[alpha] += n
            written = count - counts[0]
            if not written:
                continue
            target = yy * WIDTH + left
            previous = self.pages[self.draw_page][target:target + count]
            value = pixels.translate(COLOUR) if not counts[0] else bytes(
                src & 63 if src & 0xc0 else old for src, old in zip(pixels, previous))
            self.pages[self.draw_page][target:target + count] = value
            self.writes += written
            if yy >= 224: self.bottom_writes += written
            first = min(mask.find(bytes([a])) for a in (1, 2, 3) if counts[a])
            last = max(mask.rfind(bytes([a])) for a in (1, 2, 3) if counts[a])
            if self.draw_bounds is None:
                self.draw_bounds = [left + first, yy, left + last, yy]
            else:
                self.draw_bounds = [min(self.draw_bounds[0], left + first), min(self.draw_bounds[1], yy),
                                    max(self.draw_bounds[2], left + last), max(self.draw_bounds[3], yy)]

    def execute(self, data):
        at = 0
        while at < len(data):
            value = data[at]
            if value == 26:
                self.pending_clip = self.active_clip = (0, 0, 319, 239)
                self.full_resets += 1
                at += 1
            elif value == 31:
                self.cursor = tuple(data[at + 1:at + 3]); at += 3
            elif value == 13:
                self.cursor = (0, self.cursor[1]); at += 1
            elif value == 10:
                self.cursor = (self.cursor[0], self.cursor[1] + 1); at += 1
            elif value == 18:
                assert data[at + 1] == 0
                self.colour = data[at + 2]; at += 3
            elif value == 24:
                left, bottom, right, top = struct.unpack_from('<hhhh', data, at + 1)
                self.pending_clip = (left, top, right, bottom)
                self.saw_pending_move = False
                at += 9
            elif value == 25:
                operation = data[at + 1]
                x, y = struct.unpack_from('<hh', data, at + 2)
                if operation == 4:
                    self.active_clip = self.pending_clip
                    self.saw_pending_move = True
                    self.move = x, y
                else:
                    assert operation == 101
                    self.rectangle(*self.move, x, y)
                    self.move = x, y
                at += 6
            elif data[at:at + 3] == b'\x17\0\xa0':
                key = int.from_bytes(data[at + 3:at + 5], 'little')
                operation = data[at + 5]
                at += 6
                if key == 65535 and operation == 7:
                    assert at == len(data)
                    return
                assert operation == 1, (key, operation)
                self.execute(self.output[key])
            elif data[at:at + 3] == b'\x17\0\xc3':
                self.draw_page ^= 1; at += 3
            elif data[at:at + 4] == b'\x17\0\x96\1':
                assert data[at + 4:at + 6] == b'\xff\xff', 'Nonidentity affine outside this fixture proof'
                at += 6
            elif data[at:at + 3] == b'\x17\x1b\x20':
                self.bitmap = int.from_bytes(data[at + 3:at + 5], 'little'); at += 5
            elif data[at:at + 3] == b'\x17\x1b\0':
                self.bitmap = data[at + 3]; at += 4
            elif data[at:at + 3] == b'\x17\x1b\3':
                self.image(*struct.unpack_from('<hh', data, at + 3)); at += 7
            else:
                assert 32 <= value < 127, ('Unhandled VDU command', at, data[at:at + 16].hex())
                self.glyph(value); at += 1
        assert at == len(data)


def authority():
    # The private host library compiles the authoritative source/candidate
    # export, which is the accepted additive/byte-fill module, not wider fill.
    build = json.loads((WIDE / 'BUILD.json').read_text())
    assert build['control_module_sha256'] == '310779643769adde8413b93ea282115990dfebfe873e3395ac5545ac9d506702'
    assert '#include "wide_fill.inc"' not in (PACKAGE / 'helper/render_core.inc').read_text()
    expected = json.loads((WIDE / 'fixtures/byte/expected.json').read_text())
    assert expected['module_sha256'] == build['control_module_sha256']
    return dict(module_sha256=build['control_module_sha256'],
                source_files={str(p.relative_to(PACKAGE)): sha(p.read_bytes()) for p in sorted(PACKAGE.rglob('*'))
                              if p.is_file() and p.suffix in ('.c', '.h', '.inc')})


def prepare_runtime():
    WORK.mkdir(parents=True, exist_ok=True)
    exported = WORK / 'page-host.c'
    exported.write_text('#include "native.c"\nvoid host_actor(unsigned slot,int32_t*out){const RallyRenderActorScratchV1*a=slot<6?&renderer.cars[slot]:&renderer.signs[slot-6];memcpy(out,a,sizeof(*a));}\n')
    library = WORK / 'page-host.so'
    command = ['cc', '-shared', '-fPIC', '-O1', '-fno-builtin', '-ffp-contract=off',
               '-I' + str(PACED / 'control/sdk/include'), '-I' + str(PACKAGE), str(exported), '-o', str(library)]
    subprocess.run(command, check=True)
    runtime = SpriteRuntime(specification(PACKAGE), library)
    assert runtime.invoke('InitRace') == 0
    return runtime, command


def negative_controls(old_paint, new_paint, setup, output, images):
    initial = [bytes([page * 113 + 7]) * (WIDTH * HEIGHT) for page in range(2)]
    old, bad = PageModel(initial), PageModel(initial)
    # Exactly two swaps but only one initialized page: parity alone must not
    # make an incomplete retained-page initialization pass.
    bad.execute(setup[:len(setup) // 2] + b'\x17\0\xc3')
    assert bad.draw_page == old.draw_page == 0
    detected = None
    for frame in (1, 2):
        old.output = bad.output = output
        old.images = bad.images = images
        old.execute(old_paint); bad.execute(new_paint)
        equal = old.pages[old.draw_page] == bad.pages[bad.draw_page]
        if frame == 1: assert equal
        if not equal: detected = frame
        old.execute(b'\x17\0\xc3'); bad.execute(b'\x17\0\xc3')
    assert detected == 2
    # Stale alpha-bearing car dirt at the first permitted moving scanline;
    # transparent pixels of a new image must not erase it on their own.
    good, bad = PageModel(initial), PageModel(initial)
    for page in (good, bad):
        page.execute(setup)
        page.pages[0][100 * WIDTH + 160] = 5
        page.images = {1: (1, 1, b'\x00')}
    good.execute(b'\x1a\x12\0\x10' + rect(0, 100, 319, 103))
    for page in (good, bad):
        page.execute(b'\x17\x1b\0\1\x17\x1b\3' + struct.pack('<hh', 160, 100))
    assert good.pages[0][100 * WIDTH + 160] == 16
    assert bad.pages[0][100 * WIDTH + 160] == 5
    # A fresh VDU24 without the required activating PLOT4 must be rejected.
    clip = PageModel(initial); clip.images = {1: (1, 1, b'\xff')}
    try:
        clip.execute(b'\x18' + struct.pack('<hhhh', 160, 100, 160, 100)
                     + b'\x17\x1b\0\1\x17\x1b\3' + struct.pack('<hh', 160, 100))
    except AssertionError as error:
        assert 'activating pending' in str(error)
    else:
        raise AssertionError('Missing PLOT4 activation regression was accepted')
    return dict(uninitialized_second_page_detected_on_frame=2,
                missing_100_to_103_clear_leaves_stale_actor_pixel=True,
                transparent_current_actor_pixel_retains_old_dirt=True,
                missing_plot4_clip_activation_rejected=True)


def main():
    identity = authority()
    before = identity['source_files']
    old_paint, new_paint, setup, contract = fixture_contract()
    runtime, compile_command = prepare_runtime()
    control = HERE / 'fixtures/control'
    expected = json.loads((control / 'expected.json').read_text())
    motion = (control / 'motion.bin').read_bytes()
    assert len(motion) == 900 * 24 and sha(motion) == expected['files']['motion.bin']
    lanes = struct.pack('<6i', *expected['fixed_display_lanes'])
    # Distinct physical-page dirt proves initialization independently of the
    # actual mode clear. Retain multiple histories, including all bit patterns.
    scenarios = []
    for seed in (0, 71, 233):
        initial = [bytes((i * 17 + page * 113 + seed) & 255 for i in range(WIDTH * HEIGHT)) for page in range(2)]
        old, new = PageModel(initial), PageModel(initial)
        new.execute(setup)
        assert old.draw_page == new.draw_page == 0
        scenarios.append((old, new, hashlib.sha256()))
    proof_hash, bounds_hash, native_hash = (hashlib.sha256() for _ in range(3))
    min_actor_y, max_actor_y = 240, -1
    exercised = set()
    render_count = 0
    for tick in range(1, 3601):
        assert runtime.invoke('Tick120') == 0
        if tick % 4:
            continue
        frame = tick // 4
        for name, data in (('position', motion[(frame - 1) * 24:frame * 24]), ('lateral', lanes)):
            runtime.store(runtime.spec.arrays[name]['buffer'], 0, data)
        assert runtime.invoke('Render30') == 0
        done = runtime.data(50304)
        assert struct.unpack_from('<HHiiIII', done) == (48, 1, 0, 0, 7, frame, tick)
        lengths = struct.unpack_from('<III', done, 24)
        output = {key: runtime.data(key)[:length] for key, length in zip((50301, 50302, 50303), lengths)}
        for data in output.values(): native_hash.update(data)
        images = {50700: (320, 120, runtime.data(50700))}
        images.update({key: ((99, 75, runtime.data(key)) if key < 50716 else (62, 62, runtime.data(key)))
                       for key in range(50710, 50718)})
        for bitmap in range(5):
            images[bitmap] = (102, 77, bytes(((x * 13 + y * 17 + bitmap * 7) & 63)
                                          | (((x + y + bitmap) & 3) << 6) for y in range(77) for x in range(102)))
        for old, new, digest in scenarios:
            old.output = new.output = output
            old.images = new.images = images
            old.execute(old_paint[:old_paint.index(CALLS)])
            new.execute(new_paint[:new_paint.index(CALLS)])
            # Independently record all effective actual native writes. All
            # deleted regions must remain disjoint, not merely equal in an
            # already stale pair of models.
            old.reset_bounds(); new.reset_bounds()
            bottom_before = old.bottom_writes, new.bottom_writes
            for key in (50301, 50302, 50303):
                old.execute(output[key]); new.execute(output[key])
                assert old.draw_bounds == new.draw_bounds
            assert old.draw_bounds == new.draw_bounds
            assert old.draw_bounds is not None and old.draw_bounds[1] >= 100 and old.draw_bounds[3] <= 223
            assert (old.bottom_writes, new.bottom_writes) == bottom_before
            assert old.pages[old.draw_page] == new.pages[new.draw_page], ('Presented page mismatch', frame, old.draw_page)
            if frame >= 2:
                assert old.pages == new.pages, ('Retained hidden-page mismatch', frame)
            digest.update(old.pages[old.draw_page])
            old.execute(b'\x17\0\xc3'); new.execute(b'\x17\0\xc3')
            assert old.draw_page == new.draw_page == (frame & 1)
        # Actual actor buffer decoding, independent of the emitter's planner.
        from host_replay import commands
        draws = commands(output[50302], True)
        for bitmap, x, y, clip in draws:
            assert bitmap in range(50710, 50718)
            left, bottom, right, top = clip
            assert (left, top) == (x, y) and 0 <= left <= right <= 318
            assert 100 <= top <= bottom <= 222
            min_actor_y, max_actor_y = min(min_actor_y, top), max(max_actor_y, bottom)
            exercised.add(bitmap - 50710)
            bounds_hash.update(struct.pack('<7i', bitmap, x, y, *clip))
        proof_hash.update(scenarios[0][0].pages[(frame - 1) & 1])
        render_count += 1
        if frame % 100 == 0:
            print('Retained-page proof', frame, '/900 frames', flush=True)
    root, arrays = runtime.snapshot()
    final = {str(runtime.root_id): bytes(root).hex()}
    final.update({str(a['buffer']): bytes(arrays[a['buffer']]).hex() for a in runtime.spec.arrays.values() if a['access'] == 3})
    assert final == json.loads((SPRITES / 'motion-comparison/CONTROL-FINAL.json').read_text())
    assert runtime.invoke('StopRace') == 0 and runtime.invoke(operation=3) == 0
    assert runtime.grants == runtime.releases and not runtime.live
    runtime.canaries()
    assert render_count == 900 and 0 in exercised and 6 in exercised
    for old, new, _ in scenarios:
        assert all(old.alpha) and all(new.alpha)
        assert old.bottom_attempts == 1800 and new.bottom_attempts == 902
    assert authority()['source_files'] == before
    negative = negative_controls(old_paint, new_paint, setup, output, images)
    result = dict(schema=1, task='INC-001-04-03', passed=True,
        scope='Actual generated900-frame moving scene composed on retained physical pages; independent alpha/clipping and invariant-region/history proof; not stock-font/physical-display pixel emulation',
        frames=900, physics_ticks=3600, scenarios=len(scenarios), physical_pages=2,
        presented_pages_equal=900 * len(scenarios), both_pages_equal_after_second_frame=899 * len(scenarios),
        first_use_of_each_page_equal=True, distinct_dirty_initial_pages=True,
        frame_parity_unchanged=True, actual_native_output_commands=True, actual_generated_road_and_actor_scratch=True,
        unchanged_complete_final_world=True, invariant_regions=dict(title='Unchanged two8-pixel lines within0..15; untouched16..23 retained',
            sky='24..99 initialized once per page; no actual native drawing reaches it',
            lower_strip='224..239 initialized once per page; native lower rect clipped by playfield ending223'),
        moving_restoration=dict(recurring_sky='100..103 opaque colour16', road='104..223 full-width opaque bitmap',
            actual_actor_bounds_y=[min_actor_y, max_actor_y], actual_actor_slots=sorted(exercised),
            effective_native_bounds_y=[100, 223], rgba_alpha_patterns=[0,1,2,3],
            alpha_rule='Pinned genericRawDrawBitmap_RGBA2222: alpha bits !=0 write; alpha0 retains prior pixel',
            pending_vdu24_activated_by_plot4=True),
        history_sha256=[h.hexdigest() for _, _, h in scenarios], presented_scene_sha256=proof_hash.hexdigest(),
        generated_commands_sha256=native_hash.hexdigest(), actor_bounds_sha256=bounds_hash.hexdigest(),
        balanced_leases=True, grants=runtime.grants, releases=runtime.releases, peak_leases=runtime.peak,
        contract=contract, authority=identity, compile_command=compile_command,
        negative_controls=negative,
        source_sha256=sha(Path(__file__).read_bytes()), emulator_used=False, target_timing_claim=False,
        limitations=['Host ABI/compiler only; no new target execution or physical timing.',
            'Stable arbitrary8x8 title glyph patterns prove retained support and bytes; stock font raster is not emulated.',
            'Actor/player images intentionally synthetic and contain all four alpha patterns; actual artwork appearance remains a separate scene-capture/human gate.',
            'Initial mode/common/font setup is shared; arbitrary unequal physical-page contents deliberately strengthen retained-region initialization tests.',
            'Only the accepted deterministic motion is replayed; general geometry bounds are documented independently by the source audit.'])
    (HERE / 'PAGE-PROOF.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps({k: result[k] for k in ('passed','frames','physics_ticks','presented_pages_equal','both_pages_equal_after_second_frame','history_sha256')}, indent=2))


if __name__ == '__main__':
    main()
