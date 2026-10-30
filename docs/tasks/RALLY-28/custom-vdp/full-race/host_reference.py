"""Actual generated-C/independent-model reference with two warm render calls.

The eZ80 production presenter consumes this native route; it does not replace
the player physics or alter the frozen native fields. Synthetic host artwork is
only a retained-buffer input and cannot establish display correctness/timing.
"""
from pathlib import Path
import argparse
import ctypes
import hashlib
import json
import os
import struct
import subprocess
import sys

HERE = Path(__file__).resolve().parent
INC = HERE.parent / 'incremental'
SPRITES = INC / 'sprites'
WORK = HERE / '.work/host-reference'
PACKAGE = HERE / '.work/packages/additive'
sys.path.insert(0, str(SPRITES))
from host_replay import SpriteRuntime, PACED, BASE, Traffic, contact, specification


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def snapshot(runtime):
    root, arrays = runtime.snapshot()
    result = {str(runtime.root_id): bytes(root).hex()}
    result.update({str(array['buffer']): bytes(arrays[array['buffer']]).hex()
                   for array in runtime.spec.arrays.values() if array['access'] == 3})
    return result


def independent(runtime, model, player, tick):
    root, arrays = runtime.snapshot()
    wanted = dict(worldTick=tick, playerStation=player % model.lap, playerUnwrapped=player,
                  renderPhase=player % 8000, routeRecord=model.pace.record,
                  routeRemaining=model.pace.remaining, routeHeading=model.pace.heading,
                  routeLateral=model.pace.lateral)
    for field, value in wanted.items():
        assert runtime.spec.get(root, field) == value, (tick, field, value)
    hits = []
    for slot, car in enumerate(model.cars):
        hit = int(contact(car.position, car.lateral, player % model.lap, 0, model.lap))
        hits.append(hit)
        for field, value in [('active', car.active), ('position', car.position),
                             ('progress', car.progress), ('lateral', car.lateral), ('contacts', hit)]:
            assert runtime.spec.array_get(arrays, field, slot) == value, (tick, field, slot)
    assert runtime.spec.get(root, 'contactAny') == bool(any(hits))


def worker(mode, frames):
    library = WORK / (mode + '.so')
    runtime = SpriteRuntime(specification(PACKAGE), library)
    assert runtime.invoke('InitRace') == 0
    initial = snapshot(runtime)
    for request in (1, 2):
        assert runtime.invoke('Render30') == 0
        root, _ = runtime.snapshot()
        assert runtime.spec.get(root, 'renderRequest') == request
        assert int.from_bytes(root[20:24], 'little') == 1 + request
    fixture = SPRITES / 'motion-comparison/fixtures/additive'
    metadata = json.loads((fixture / 'expected.json').read_text())
    motion = (fixture / 'motion.bin').read_bytes()
    assert sha(fixture / 'motion.bin') == metadata['files']['motion.bin']
    lanes = struct.pack('<6i', *metadata['fixed_display_lanes'])
    tables = json.loads((BASE / 'reference/tables.json').read_text())
    model = Traffic(tables, 'circuit', 3276800, 1, 99)
    player = 3246800
    for car, gap in zip(model.cars, [0, 3199, 3200, 6400, 18000, 80000]):
        car.active = 1
        car.progress = player + gap
        car.position = car.progress % model.lap
        car.lateral = 0
    tick_hash = hashlib.sha256()
    for tick in range(1, frames * 4 + 1):
        record = (model.pace.record + 1) % 6 if model.pace.remaining == 0 else model.pace.record
        player += tables['records'][record][1] * 2
        model.advance(player, tick)
        assert runtime.invoke('Tick120') == 0
        independent(runtime, model, player, tick)
        root, arrays = runtime.snapshot()
        tick_hash.update(bytes(root))
        for key in sorted(arrays):
            tick_hash.update(bytes(arrays[key]))
        if tick % 4:
            continue
        frame = tick // 4
        positions = []
        for slot in range(6):
            phase = (frame - 1 + slot * 47) % 300
            gap = 110000 - phase * 450 if slot < 3 else -24550 + phase * 450
            positions.append((player + gap) % model.lap)
        row = motion[(frame - 1) * 24:frame * 24]
        assert row == struct.pack('<6I', *positions), ('Accepted moving table', frame)
        runtime.store(4, 0, row)
        runtime.store(5, 0, lanes)
        for car, position, lateral in zip(model.cars, positions, metadata['fixed_display_lanes']):
            car.position, car.lateral = position, lateral
        assert runtime.invoke('Render30') == 0
        root, _ = runtime.snapshot()
        assert runtime.spec.get(root, 'renderRequest') == frame + 2
        assert int.from_bytes(root[20:24], 'little') == 3 + frame * 5
        completion = runtime.data(50304)
        assert struct.unpack_from('<HHiiIII', completion) == (48, 1, 0, 0, 7, frame + 2, tick)
        assert struct.unpack_from('<H', completion, 44)[0] == 1
    final = snapshot(runtime)
    changed = {}
    if frames == 900:
        prior = json.loads((SPRITES / 'motion-comparison/CONTROL-FINAL.json').read_text())
        expected = dict(prior)
        root = bytearray.fromhex(prior['1'])
        for offset, label in ((20, 'native_generation'), (296, 'renderRequest')):
            before = struct.unpack_from('<I', root, offset)[0]
            struct.pack_into('<I', root, offset, before + 2)
            changed[label] = dict(offset=offset, before=before, after=before + 2)
        expected['1'] = root.hex()
        assert final == expected, 'Warm renders changed fields beyond their two generation counters'
    assert runtime.invoke('StopRace') == 0 and runtime.invoke(operation=3) == 0
    runtime.canaries()
    assert not runtime.live and runtime.grants == runtime.releases
    result = dict(schema=1, mode=mode, valid=True, warm_renders=2, frames=frames, physics_ticks=frames*4,
                  generated_invocations=frames*5+4, initial_buffers=initial, final_buffers=final, independent_world_checks_each_tick=True,
                  accepted_motion_independently_regenerated=True, prior_accepted_final_sha256=sha(SPRITES / 'motion-comparison/CONTROL-FINAL.json'),
                  only_final_differences_from_accepted_moving_fixture=changed,
                  tick_states_sha256=tick_hash.hexdigest(), source_native_c_sha256=sha(PACKAGE / 'native.c'),
                  source_render_core_sha256=sha(PACKAGE / 'helper/render_core.inc'), library_sha256=sha(library),
                  motion_sha256=sha(fixture / 'motion.bin'), leases=dict(peak=runtime.peak,
                    grants=runtime.grants, releases=runtime.releases, balanced=True, canaries=True),
                  limitation='Host ABI and synthetic artwork; no emulator/display/timing claim')
    (WORK / (mode + '-' + str(frames) + '.json')).write_text(json.dumps(result, indent=2) + '\n')
    print('PASS actual C plus independent warm/motion world:', mode, flush=True)


def main(frames):
    WORK.mkdir(parents=True, exist_ok=True)
    exports = WORK / 'exports.c'
    exports.write_text('''#include "native.c"
void host_actor(unsigned slot,int32_t *out){
const RallyRenderActorScratchV1 *actor=slot<6?&renderer.cars[slot]:&renderer.signs[slot-6];
memcpy(out,actor,sizeof(*actor));}
''')
    for mode in ('ordinary', 'sanitized'):
        flags = [] if mode == 'ordinary' else ['-fsanitize=address,undefined', '-fno-omit-frame-pointer']
        subprocess.run(['cc', '-shared', '-fPIC', '-O1', '-fno-builtin', '-ffp-contract=off', *flags,
                        '-I' + str(PACED / 'control/sdk/include'), '-I' + str(PACKAGE),
                        str(exports), '-o', str(WORK / (mode + '.so'))], check=True)
        environment = os.environ.copy()
        if mode == 'sanitized':
            environment['LD_PRELOAD'] = subprocess.check_output(['cc', '-print-file-name=libasan.so'], text=True).strip()
            environment['ASAN_OPTIONS'] = 'detect_leaks=0:halt_on_error=1'
            environment['UBSAN_OPTIONS'] = 'halt_on_error=1:print_stacktrace=1'
        subprocess.run([sys.executable, __file__, '--worker', mode, '--frames', str(frames)], env=environment, check=True)
    ordinary, sanitized = (json.loads((WORK / (mode + '-' + str(frames) + '.json')).read_text()) for mode in ('ordinary', 'sanitized'))
    assert ordinary['final_buffers'] == sanitized['final_buffers']
    assert ordinary['tick_states_sha256'] == sanitized['tick_states_sha256']
    suffix = '-' + str(frames)
    for name, content in [('EXPECTED-FINAL' + suffix + '.json', ordinary['final_buffers']),
                          ('STATE-PROOF' + suffix + '.json', dict(schema=1, passed=True, ordinary=ordinary,
                             sanitized=sanitized, modes_agree=True, cpp_presenter_does_not_patch_native_player=True))]:
        path = HERE / name
        data = json.dumps(content, indent=2) + '\n'
        if path.exists():
            assert path.read_text() == data, ('Preserve prior reference', path)
        else:
            path.write_text(data)
    print('Saved exact406-byte full-race final reference:', frames, 'frames; generation', frames*5+3, 'request', frames+2)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--worker', choices=('ordinary', 'sanitized'))
    parser.add_argument('--frames', type=int, default=900)
    arguments = parser.parse_args()
    assert 1 <= arguments.frames <= 900
    worker(arguments.worker, arguments.frames) if arguments.worker else main(arguments.frames)
