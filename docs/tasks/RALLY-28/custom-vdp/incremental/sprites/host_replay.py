"""Actual generated-C sprite integration, independent replay and fault tests.

No emulator or upstream mutation. Compile the exact candidate package and
accepted span control into private ordinary/ASan+UBSan host libraries.
"""
from pathlib import Path
import argparse
import ctypes as C
import hashlib
import importlib.util
import json
import os
import struct
import subprocess
import sys
import traceback

HERE = Path(__file__).resolve().parent
THROUGHPUT = HERE.parent.parent / 'throughput'
PACED = HERE.parent.parent / 'paced-road'
WORK = HERE / '.work/host'
PACKAGE = HERE / '.work/candidate/package'
CONTROL_PACKAGE = THROUGHPUT / '.work/span-candidate/package'
TAG = ''
sys.path.insert(0, str(THROUGHPUT))
sys.path.insert(0, str(PACED))
from span_check import SpanRuntime
from qualify_candidates import specification, BASE, Traffic, contact
from sampler_units import rational_plan, oracle_pixels


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def artwork():
    """Different deterministic colors/alpha for every retained actor image."""
    result = {}
    for bitmap in [*range(5, 35), *range(120, 128)]:
        width, height = (102, 77) if bitmap < 120 else (64, 64)
        result[64000 + bitmap] = bytes(((x * 13 + y * 17 + bitmap * 7) & 63)
                                       | (((x + y + bitmap) & 3) << 6)
                                       for y in range(height) for x in range(width))
    return result


ART = artwork()


class SpriteRuntime(SpanRuntime):
    def __init__(self, spec, library):
        super().__init__(spec, library)
        for slot in range(8):
            self.install(50710 + slot, bytes([0xa5]) * (7425 if slot < 6 else 3844))
        for key, data in ART.items():
            self.install(key, data, 1)
        self.lib.host_actor.argtypes = [C.c_uint, C.POINTER(C.c_int32)]

    def actors(self):
        out = []
        for slot in range(8):
            row = (C.c_int32 * 7)()
            self.lib.host_actor(slot, row)
            out.append(tuple(row))
        return out


def commands(data, long_ids):
    """Decode the two ordinary VDU actor command encodings independently."""
    at = 0
    current = None
    clip = (0, 223, 319, 24)
    pending_clip = clip
    clip_activated = True
    draws = []
    while at < len(data):
        if data[at:at + 6] == b'\x17\0\xa0\xff\xff\7':
            assert at + 6 == len(data)
            break
        if data[at] == 24:
            pending_clip = struct.unpack_from('<hhhh', data, at + 1)
            clip_activated = False
            at += 9
        elif data[at] == 25:
            assert data[at + 1] == 4
            clip = pending_clip
            clip_activated = True
            at += 6
        elif data[at:at + 3] == b'\x17\0\xa0':
            assert data[at + 5] == 32
            op = data[at + 6]
            assert op in (0, 11)
            at += 7 if op == 0 else 20
        elif data[at:at + 4] == b'\x17\0\x96\1':
            if long_ids:
                assert data[at + 4:at + 6] == b'\xff\xff'
            at += 6
        elif data[at:at + 3] == b'\x17\x1b\0':
            assert not long_ids
            current = data[at + 3]
            at += 4
        elif data[at:at + 3] == b'\x17\x1b\x20':
            assert long_ids
            current = struct.unpack_from('<H', data, at + 3)[0]
            at += 5
        elif data[at:at + 3] == b'\x17\x1b\3':
            assert clip_activated, ('bitmap before PLOT4 activates VDU24 clipping', at, pending_clip, clip)
            x, y = struct.unpack_from('<hh', data, at + 3)
            draws.append((current, x, y, clip))
            at += 7
        else:
            raise AssertionError(('unknown actor command', at, data[at:at + 16].hex()))
    assert at == len(data) - 6
    return draws


def replay(mode):
    old_spec, new_spec = specification(CONTROL_PACKAGE), specification(PACKAGE)
    old = SpriteRuntime(old_spec, WORK / ('host_control_' + mode + '.so'))
    new = SpriteRuntime(new_spec, WORK / ('host_candidate_' + mode + '.so'))
    assert old.invoke('InitRace') == new.invoke('InitRace') == 0
    tables = json.loads((BASE / 'reference/tables.json').read_text())
    model = Traffic(tables, 'circuit', 3276800, 1, 99)
    player = 3246800
    for car, gap in zip(model.cars, [0, 3199, 3200, 6400, 18000, 80000]):
        car.active = 1
        car.progress = player + gap
        car.position = car.progress % model.lap
        car.lateral = 0
    world, road_digest, sprite_digest = (hashlib.sha256() for _ in range(3))
    sampled = draws = actor_bytes = old_actor_bytes = 0
    visible_slots = set()
    for tick in range(1, 3601):
        speed = tables['records'][(model.pace.record + 1) % 6 if model.pace.remaining == 0 else model.pace.record][1]
        player += speed * 2
        model.advance(player, tick)
        assert old.invoke('Tick120') == new.invoke('Tick120') == 0
        root, arrays = new.snapshot()
        assert (root, arrays) == old.snapshot(), ('tick state', tick)
        expected = dict(worldTick=tick, playerStation=player % model.lap, playerUnwrapped=player,
                        renderPhase=player % 8000, routeRecord=model.pace.record,
                        routeRemaining=model.pace.remaining, routeHeading=model.pace.heading,
                        routeLateral=model.pace.lateral)
        for field, value in expected.items():
            assert new_spec.get(root, field) == value, (tick, field)
        hits = []
        for i, car in enumerate(model.cars):
            hit = int(contact(car.position, car.lateral, player % model.lap, 0, model.lap))
            hits.append(hit)
            for field, value in [('active', car.active), ('position', car.position), ('progress', car.progress),
                                 ('lateral', car.lateral), ('contacts', hit)]:
                assert new_spec.array_get(arrays, field, i) == value, (tick, field, i)
        assert new_spec.get(root, 'contactAny') == bool(any(hits))
        if tick % 4:
            continue
        frame = tick // 4
        before = [new.data(50710 + slot) for slot in range(8)]
        assert old.invoke('Render30') == new.invoke('Render30') == 0
        root, arrays = new.snapshot()
        assert (root, arrays) == old.snapshot(), ('render state', frame)
        done, old_done = new.data(50304), old.data(50304)
        assert struct.unpack_from('<HHiiIII', done) == (48, 1, 0, 0, 7, frame, tick)
        assert done[:24] == old_done[:24] and done[36:] == old_done[36:]
        assert struct.unpack_from('<H', done, 44)[0] == 1
        lengths, old_lengths = (struct.unpack_from('<III', d, 24) for d in (done, old_done))
        output = [new.data(key)[:n] for key, n in zip((50301, 50302, 50303), lengths)]
        old_output = [old.data(key)[:n] for key, n in zip((50301, 50302, 50303), old_lengths)]
        assert output[0] == old_output[0] and output[2] == old_output[2], ('road/player commands', frame)
        assert new.data(50700) == old.data(50700), ('road pixels', frame)
        cars, signs = struct.unpack_from('<HH', done, 38)
        descriptors = new.actors()
        assert descriptors[:cars] == old.actors()[:cars]
        assert descriptors[6:6 + signs] == old.actors()[6:6 + signs]
        slot_by_bitmap = {descriptors[i][0]: i for i in [*range(cars), *range(6, 6 + signs)]}
        planned = {}
        for slot in range(8):
            active = slot < cars if slot < 6 else slot - 6 < signs
            expected_pixels = before[slot]
            if active:
                bitmap, matrix, scale, xx, translation, x, y = descriptors[slot]
                sign = slot >= 6
                p = rational_plan(scale, xx < 0, sign, x, y, 104 if sign else 24)
                if p is not None:
                    planned[slot] = p
                    expected_pixels = oracle_pixels(p, ART[64000 + bitmap], before[slot])
                    sampled += p[2] * p[3]
                    visible_slots.add(slot)
            assert new.data(50710 + slot) == expected_pixels, ('scratch pixels/padding', frame, slot)
            sprite_digest.update(expected_pixels)
        expected_draws = []
        for bitmap, x, y, clip in commands(old_output[1], False):
            slot = slot_by_bitmap[bitmap]
            assert (x, y) == descriptors[slot][-2:]
            if slot in planned:
                px, py, width, height, *_ = planned[slot]
                expected_draws.append((50710 + slot, px, py, (px, py + height - 1, px + width - 1, py)))
        actual_draws = commands(output[1], True)
        assert actual_draws == expected_draws, ('painter order/clipping', frame, actual_draws, expected_draws)
        if frame == 1:
            assert output[1][0] == 24 and output[1][9:11] == b'\x19\4'
            missing_move = output[1][:9] + output[1][15:]
            try:
                commands(missing_move, True)
            except AssertionError as error:
                assert 'bitmap before PLOT4' in str(error), error
            else:
                raise AssertionError('clipping model accepted missing PLOT4 regression')
        draws += len(actual_draws)
        actor_bytes += lengths[1]
        old_actor_bytes += old_lengths[1]
        road_digest.update(new.data(50700))
        world.update(bytes(root) + b''.join(bytes(arrays[k]) for k in sorted(arrays)))
    final = json.loads((BASE / 'native-demo/SOURCE-RESULTS.json').read_text())
    for a in new_spec.arrays.values():
        if a['access'] == 3:
            assert bytes(arrays[a['buffer']]).hex() == final['final_arrays'][a['name']]
    for runtime in (old, new):
        assert runtime.invoke('StopRace') == 0 and runtime.invoke(operation=3) == 0
        assert not runtime.live and runtime.grants == runtime.releases
        runtime.canaries()
    assert new.peak == 4
    return dict(frames=900, ticks=3600, independent_world_pass=True, final_arrays_exact=True,
                road_player_commands_exact=True, road_pixels_exact=True, geometric_descriptors_exact=True,
                painter_order_and_clipping_exact=True, scratch_padding_and_inactive_slots_unchanged=True,
                canvas_clipping_activated_before_bitmap=True, missing_plot4_regression_rejected=True,
                retained_actor_sources=38, sampled_pixels=sampled, visible_draws=draws,
                exercised_scratch_slots=sorted(visible_slots), peak_leases=new.peak, balanced_leases=True,
                world_sha256=world.hexdigest(), road_sha256=road_digest.hexdigest(), sprite_sha256=sprite_digest.hexdigest(),
                average_actor_bytes=actor_bytes / 900, previous_average_actor_bytes=old_actor_bytes / 900)


def failures(mode):
    spec = importlib.util.spec_from_file_location('sprite_helper_faults', BASE / 'renderer-helper/verify.py')
    old = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(old)
    library = C.CDLL(str(WORK / ('host_candidate_' + mode + '.so')))

    class Harness(old.Harness):
        def __init__(self):
            super().__init__(library)
            self.limit = 4
            self.set(50700, bytes([0xcc]) * 38400)
            for slot in range(8):
                self.set(50710 + slot, bytes([0xa5]) * (7425 if slot < 6 else 3844))
            for key, data in ART.items():
                self.set(key, data)
            self.target = None
            self.target_at = 1
            self.target_calls = 0
            self.kind = None

        def acquire(self, context, key, access, offset, n, out):
            fault = None
            if key == self.target:
                self.target_calls += 1
                if self.target_calls == self.target_at:
                    fault = self.kind
            if fault in ('missing', 'busy'):
                self.acquires += 1
                return 2 if fault == 'missing' else 7
            if fault == 'short-allocation':
                self.acquires += 1
                return 3
            rc = super().acquire(context, key, access, offset, n, out)
            if not rc and fault:
                if fault == 'short-view':
                    out.contents.bytes -= 1
                elif fault == 'null-view':
                    out.contents.data = C.POINTER(C.c_uint8)()
                elif fault == 'wrong-access':
                    out.contents.access = 2 if access == 1 else 1
                elif fault == 'partial-error':
                    return 2
            return rc

    library.rally_render_bind_v1.argtypes = [C.POINTER(old.Host), C.POINTER(old.Context), C.POINTER(old.Bindings), C.POINTER(old.Completion)]
    library.rally_render_prepare_v1.argtypes = [C.POINTER(old.Host), C.POINTER(old.Context), C.POINTER(old.State), C.POINTER(old.Completion)]
    library.rally_render_stop_v1.argtypes = [C.POINTER(old.Context), C.POINTER(old.Completion)]
    scenes = json.loads((BASE / 'renderer-prep/scene-cases.json').read_text())['cases']
    sample = next(x for x in scenes if x['track'] == 'fuji' and x['label'].startswith('boundary:') and x['counts'][1] >= 2)
    state = old.convert(bytes.fromhex(sample['state_hex']))
    h = Harness()
    assert h.bind() == h.prepare(state) == 0 and h.c.ready
    baseline_acquires, baseline_releases = h.acquires, h.releases
    visible = []
    for slot in [*range(h.c.cars), *range(6, 6 + h.c.signs)]:
        actor = h.ctx.cars[slot] if slot < 6 else h.ctx.signs[slot - 6]
        p = rational_plan(actor.scale, actor.xx < 0, slot >= 6, actor.x, actor.y, 104 if slot >= 6 else 24)
        if p:
            visible.append((slot, 64000 + actor.bitmap))
    assert visible
    slot, source = visible[0]
    rows = []
    for destination in range(50710, 50718):
        for kind in ('missing', 'short-view', 'null-view', 'partial-error'):
            h = Harness()
            h.target, h.target_at, h.kind = destination, 1, kind
            rc = h.bind()
            assert rc and not h.ctx.bound and not h.c.ready, ('bind destination', destination, kind, rc)
            h.clean()
            h.canaries()
            rows.append(dict(target='bind-destination-' + str(destination), fault=kind,
                             rc=rc, reason=h.c.reason, balanced=True))
    for target, at, label in ((source, 1, 'source'), (50710 + slot, 2, 'destination-actual'),
                              (50710 + slot, 1, 'destination-preflight')):
        for kind in ('missing', 'busy', 'short-allocation', 'short-view', 'null-view', 'wrong-access', 'partial-error'):
            h = Harness()
            assert h.bind() == 0
            h.target, h.target_at, h.kind = target, at, kind
            rc = h.prepare(state)
            assert rc and not h.c.ready, (label, kind, rc)
            h.clean()
            h.canaries()
            rows.append(dict(target=label, fault=kind, rc=rc, reason=h.c.reason, balanced=True))
    # Every service call made by a successful actual prepare, including both
    # source/destination releases and final asset release, must propagate faults.
    h = Harness()
    assert h.bind() == 0
    h.reset_faults()
    assert h.prepare(state) == 0
    counts = {'acquire': h.acquires, 'release': h.releases}
    for service, count in counts.items():
        for index in range(1, count + 1):
            h = Harness()
            assert h.bind() == 0
            h.reset_faults()
            setattr(h, 'fail_' + service, index)
            rc = h.prepare(state)
            assert rc and not h.c.ready, (service, index, rc)
            if service == 'release':
                assert not h.ctx.bound, (service, index, h.c.reason)
            h.clean()
            h.canaries()
            rows.append(dict(target='prepare', fault=service, index=index, rc=rc, reason=h.c.reason, balanced=True))
    # Output overflow must neither publish success nor write past the capacity.
    for output in range(3):
        h = Harness()
        h.b.output[output].bytes = 1
        assert h.bind() == 0
        rc = h.prepare(state)
        assert rc and not h.c.ready
        h.clean()
        h.canaries()
        rows.append(dict(target='output-' + str(output), fault='capacity-one', rc=rc, reason=h.c.reason, balanced=True))
    h = Harness()
    assert h.bind() == h.prepare(state) == h.stop() == 0 and not h.ctx.bound
    assert h.prepare(state) and not h.c.ready
    h.clean()

    # The long deterministic run has only three simultaneously visible cars.
    # Bounded independent scene states exercise all six retained traffic slots.
    h = Harness()
    assert h.bind() == 0
    direct_slots = set()
    direct_cases = 0
    direct_samples = 0
    selected = [x for x in scenes if x['track'] == 'fuji' and x['counts'][1] == 6]
    for scene in selected[:128]:
        s = old.convert(bytes.fromhex(scene['state_hex']))
        before = [bytes(h.buffers[50710 + i]) for i in range(8)]
        assert h.prepare(s) == 0 and h.c.ready, ('direct scene', scene['label'])
        for i in range(8):
            active = i < h.c.cars if i < 6 else i - 6 < h.c.signs
            reference = before[i]
            if active:
                actor = h.ctx.cars[i] if i < 6 else h.ctx.signs[i - 6]
                p = rational_plan(actor.scale, actor.xx < 0, i >= 6, actor.x, actor.y,
                                  104 if i >= 6 else 88 if s.flags & 2 else 24)
                if p:
                    reference = oracle_pixels(p, ART[64000 + actor.bitmap], reference)
                    direct_slots.add(i)
                    direct_samples += p[2] * p[3]
            assert bytes(h.buffers[50710 + i]) == reference, ('direct scene pixels', scene['label'], i)
        h.clean()
        h.canaries()
        direct_cases += 1
        if direct_cases >= 16 and set(range(6)) <= direct_slots:
            break
    assert set(range(6)) <= direct_slots, ('missing traffic slot coverage', direct_slots)
    assert h.stop() == 0 and not h.ctx.bound
    return dict(passed=True, cases=len(rows), all_malformed_grants_released=True,
                failed_release_unbinds=True, bind_prepare_stop_pass=True,
                successful_prepare_acquires=counts['acquire'], successful_prepare_releases=counts['release'],
                additional_six_car_scenes=direct_cases, additional_sampled_pixels=direct_samples,
                additional_scratch_slots=sorted(direct_slots),
                second_sign_slot='Preflight/fault tested and unchanged when inactive; no second visible sign in supplied scene cases',
                rows=rows)


def worker(mode):
    result = dict(schema=1, mode=mode, scope='Actual generated-C host integration; synthetic actor artwork, no emulator timing',
                  candidate_package=str(PACKAGE), tag=TAG,
                  replay=replay(mode), failures=failures(mode),
                  package_sources={str(p.relative_to(PACKAGE)): sha(p) for p in PACKAGE.rglob('*') if p.is_file()},
                  sources={p.name: sha(p) for p in (HERE / 'host_replay.py', HERE / 'host_exports.c')})
    (HERE / ('host_' + (TAG + '_' if TAG else '') + mode + '.json')).write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(dict(mode=mode, replay=result['replay'], failure_cases=result['failures']['cases']), indent=2), flush=True)


def main():
    WORK.mkdir(parents=True, exist_ok=True)
    for mode in ('ordinary', 'sanitized'):
        flags = [] if mode == 'ordinary' else ['-fsanitize=address,undefined', '-fno-omit-frame-pointer']
        for kind, package in (('control', CONTROL_PACKAGE), ('candidate', PACKAGE)):
            subprocess.run(['cc', '-shared', '-fPIC', '-O1', '-fno-builtin', '-ffp-contract=off', *flags,
                            '-I' + str(PACED / 'control/sdk/include'), '-I' + str(package),
                            str(HERE / 'host_exports.c'), '-o', str(WORK / ('host_' + kind + '_' + mode + '.so'))], check=True)
        env = os.environ.copy()
        if mode == 'sanitized':
            env['LD_PRELOAD'] = subprocess.check_output(['cc', '-print-file-name=libasan.so'], text=True).strip()
            env['ASAN_OPTIONS'] = 'detect_leaks=0:halt_on_error=1'
            env['UBSAN_OPTIONS'] = 'halt_on_error=1:print_stacktrace=1'
        subprocess.run([sys.executable, __file__, '--worker', mode, '--package', str(PACKAGE), '--tag', TAG], env=env, check=True)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--worker', choices=('ordinary', 'sanitized'))
    parser.add_argument('--package', type=Path, default=PACKAGE,
                        help='Actual generated native package to compile and qualify')
    parser.add_argument('--tag', default='', help='Separate report/library suffix, e.g. clipfix')
    args = parser.parse_args()
    assert all(c.isalnum() or c in '_-' for c in args.tag), 'invalid report tag'
    PACKAGE = args.package.resolve()
    TAG = args.tag
    if TAG:
        WORK = WORK / TAG
    if args.worker:
        try:
            worker(args.worker)
        except BaseException as error:
            (HERE / ('host_failure_' + (TAG + '_' if TAG else '') + args.worker + '.json')).write_text(json.dumps(
                dict(mode=args.worker, error=str(error), traceback=traceback.format_exc(),
                     source_sha256=sha(HERE / 'host_replay.py')), indent=2) + '\n')
            raise
    else:
        main()
