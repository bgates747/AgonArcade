"""Exact generated-C moving-fixture replay for the wider road-fill experiment.

Compile private host libraries from the frozen additive control and new package.
The ordinary and ASan/UBSan runs each execute exactly900frames/3600ticks per
package, with the accepted motion table injected after physics and before Render30.
No emulator, target timing, upstream edits or legacy-report writes.
"""
from pathlib import Path
import argparse
import ctypes as C
import hashlib
import importlib.util
import json
import os
import shutil
import struct
import subprocess
import sys
import traceback
import zipfile

HERE = Path(__file__).resolve().parent
SPRITES = HERE.parent / 'sprites'
WORK = HERE / '.work/host'
CONTROL = HERE / '.work/control/package'
CANDIDATE = HERE / '.work/candidate/package'
CAPTURE = WORK / 'capture-package'
MOTION_FIXTURE = SPRITES / 'motion-comparison/fixtures/additive'
SELECTED = (1, 60, 120, 180, 240, 300, 450, 600, 750, 900)
sys.path.insert(0, str(SPRITES))
from host_replay import SpriteRuntime, PACED, BASE, Traffic, contact, specification


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def digest(data):
    return hashlib.sha256(data).hexdigest()


def package_hashes(directory):
    return {str(p.relative_to(directory)): sha(p) for p in sorted(directory.rglob('*')) if p.is_file()}


def sources():
    paths = [HERE / 'replay.py', HERE / 'host_exports.c', SPRITES / 'host_replay.py',
             PACED / 'qualify_candidates.py', PACED.parent / 'throughput/span_check.py',
             BASE / 'generated-state/host.py', BASE / 'generated-state/adapter.py',
             BASE / 'reference/model.py', BASE / 'reference/tables.json',
             SPRITES / 'motion-comparison/CONTROL-FINAL.json',
             MOTION_FIXTURE / 'motion.bin', MOTION_FIXTURE / 'expected.json',
             PACED / 'control/sdk/include/vdplet.h']
    return {str(p): sha(p) for p in paths}


def reference_identity():
    """Compile input code is the authoritative accepted source/candidate export."""
    checked = {}
    with zipfile.ZipFile(SPRITES / 'PORTABLE.zip') as archive:
        for member in archive.namelist():
            if not member.startswith('source/candidate/') or member.endswith('/'):
                continue
            relative = member.removeprefix('source/candidate/')
            if relative.endswith(('.c', '.h', '.inc')) or relative in (
                    'interface.json', 'root.json', 'backends.json', 'common-install.bin'):
                actual = (CONTROL / relative).read_bytes()
                assert actual == archive.read(member), ('authoritative control changed', relative)
                checked[relative] = digest(actual)
    assert 'native.c' in checked and 'helper/render_core.inc' in checked
    return dict(portable_sha256=sha(SPRITES / 'PORTABLE.zip'), accepted_control_code_and_abi=checked)


def expected(runtime, model, player, tick, stage):
    root, arrays = runtime.snapshot()
    spec = runtime.spec
    wanted = dict(worldTick=tick, playerStation=player % model.lap,
                  playerUnwrapped=player, renderPhase=player % 8000,
                  routeRecord=model.pace.record, routeRemaining=model.pace.remaining,
                  routeHeading=model.pace.heading, routeLateral=model.pace.lateral)
    for field, value in wanted.items():
        assert spec.get(root, field) == value, (stage, tick, field, value)
    hits = []
    for i, car in enumerate(model.cars):
        hit = int(contact(car.position, car.lateral, player % model.lap, 0, model.lap))
        hits.append(hit)
        fields = [('active', car.active), ('position', car.position),
                  ('progress', car.progress), ('lateral', car.lateral), ('contacts', hit)]
        for field, value in fields:
            assert spec.array_get(arrays, field, i) == value, (stage, tick, field, i, value)
    assert spec.get(root, 'contactAny') == bool(any(hits)), (stage, tick, 'contactAny')
    return root, arrays


def same_world(left, right, label):
    a, b = left.snapshot(), right.snapshot()
    assert a == b, ('full root/arrays', label)
    return a


def install_motion(runtime, row, lanes):
    for name, payload in (('position', row), ('lateral', lanes)):
        array = runtime.spec.arrays[name]
        assert array['count'] == 6 and array['element_bytes'] == 4 and array['offset'] == 0
        runtime.store(array['buffer'], 0, payload)


def snapshot_bytes(root, arrays):
    return bytes(root) + b''.join(bytes(arrays[key]) for key in sorted(arrays))


def capture_prepare(runtime, control):
    # Snapshot immediately before the original Render30, including scratch and
    # output tails; only the host clone's trace wrapper differs from the control.
    for key in control.buffers:
        runtime.store(key, 0, control.data(key))
    runtime.lib.host_capture_begin(C.cast(runtime.pointer(50700), C.POINTER(C.c_uint8)))


def capture_read(runtime, frame):
    lib = runtime.lib
    assert not lib.host_capture_overflow(), ('trace overflow', frame)
    output = bytearray()
    for index in range(lib.host_capture_count()):
        row = (C.c_int32 * 4)()
        lib.host_capture_read(index, row)
        offset, left, right, colour = row
        assert 0 <= offset <= 119 * 320 and offset % 320 == 0, (frame, index, tuple(row))
        assert 0 <= left <= right <= 320 and 0 <= colour <= 255, (frame, index, tuple(row))
        output += struct.pack('<HHHBB', offset, left, right, colour, 0)
    return bytes(output)


def replay(mode):
    control = SpriteRuntime(specification(CONTROL), WORK / ('control-' + mode + '.so'))
    candidate = SpriteRuntime(specification(CANDIDATE), WORK / ('candidate-' + mode + '.so'))
    runtimes = (control, candidate)
    for runtime in runtimes:
        assert runtime.invoke('InitRace') == 0
    capture = None
    if mode == 'ordinary':
        capture = SpriteRuntime(specification(CAPTURE), WORK / 'capture-ordinary.so')
        capture.lib.host_capture_begin.argtypes = [C.POINTER(C.c_uint8)]
        capture.lib.host_capture_count.restype = C.c_uint32
        capture.lib.host_capture_overflow.restype = C.c_uint32
        capture.lib.host_capture_read.argtypes = [C.c_uint32, C.POINTER(C.c_int32)]
        assert capture.invoke('InitRace') == 0
    meta = json.loads((MOTION_FIXTURE / 'expected.json').read_text())
    motion = (MOTION_FIXTURE / 'motion.bin').read_bytes()
    assert len(motion) == 900 * 24 and sha(MOTION_FIXTURE / 'motion.bin') == meta['files']['motion.bin']
    lanes = struct.pack('<6i', *meta['fixed_display_lanes'])
    tables = json.loads((BASE / 'reference/tables.json').read_text())
    model = Traffic(tables, 'circuit', 3276800, 1, 99)
    player = 3246800
    for car, gap in zip(model.cars, [0, 3199, 3200, 6400, 18000, 80000]):
        car.active = 1
        car.progress = player + gap
        car.position = car.progress % model.lap
        car.lateral = 0
    hashes = {name: hashlib.sha256() for name in ('all_ticks', 'render_world', 'road_pixels',
              'road_commands', 'actor_commands', 'player_commands', 'completion', 'actor_scratch', 'descriptors')}
    capture_binary, capture_rows = bytearray(), []
    command_bytes = [0, 0, 0]
    for tick in range(1, 3601):
        record = (model.pace.record + 1) % 6 if model.pace.remaining == 0 else model.pace.record
        player += tables['records'][record][1] * 2
        model.advance(player, tick)
        for runtime in runtimes:
            assert runtime.invoke('Tick120') == 0
            expected(runtime, model, player, tick, 'physics')
        root, arrays = same_world(control, candidate, tick)
        hashes['all_ticks'].update(snapshot_bytes(root, arrays))
        if tick % 4:
            continue
        frame = tick // 4
        row = motion[(frame - 1) * 24:frame * 24]
        # Independently regenerate the accepted review's approach/recede table.
        positions = []
        for i in range(6):
            phase = (frame - 1 + i * 47) % 300
            gap = 110000 - phase * 450 if i < 3 else -24550 + phase * 450
            positions.append((player + gap) % model.lap)
        assert row == struct.pack('<6I', *positions), ('motion table', frame)
        for runtime in runtimes:
            install_motion(runtime, row, lanes)
        for car, position, lateral in zip(model.cars, positions, meta['fixed_display_lanes']):
            car.position, car.lateral = position, lateral
        same_world(control, candidate, ('motion', frame))
        if capture and frame in SELECTED:
            capture_prepare(capture, control)
        for runtime in runtimes:
            assert runtime.invoke('Render30') == 0
        root, arrays = same_world(control, candidate, ('render', frame))
        done = candidate.data(50304)
        assert struct.unpack_from('<HHiiIII', done) == (48, 1, 0, 0, 7, frame, tick)
        assert struct.unpack_from('<H', done, 44)[0] == 1
        assert int.from_bytes(root[20:24], 'little') == 1 + frame * 5
        for key in (50301, 50302, 50303, 50304, 50700, *range(50710, 50718)):
            assert control.data(key) == candidate.data(key), ('entire output/scratch allocation', frame, key)
        descriptors = candidate.actors()
        assert descriptors == control.actors(), ('all8 actor descriptors', frame)
        lengths = struct.unpack_from('<III', done, 24)
        for index, name in enumerate(('road_commands', 'actor_commands', 'player_commands')):
            payload = candidate.data(50301 + index)[:lengths[index]]
            hashes[name].update(payload)
            command_bytes[index] += len(payload)
        hashes['render_world'].update(snapshot_bytes(root, arrays))
        hashes['road_pixels'].update(candidate.data(50700))
        hashes['completion'].update(done)
        hashes['descriptors'].update(b''.join(struct.pack('<7i', *r) for r in descriptors))
        for key in range(50710, 50718):
            hashes['actor_scratch'].update(candidate.data(key))
        if capture and frame in SELECTED:
            assert capture.invoke('Render30') == 0
            assert capture.snapshot() == control.snapshot(), ('capture world changed', frame)
            for key in (50301, 50302, 50303, 50304, 50700, *range(50710, 50718)):
                assert capture.data(key) == control.data(key), ('capture output changed', frame, key)
            raw = capture_read(capture, frame)
            capture_rows.append(dict(frame=frame, first_record=len(capture_binary) // 8,
                                     count=len(raw) // 8, sha256=digest(raw)))
            capture_binary += raw
    assert player % model.lap == meta['player_final_station']
    assert positions == meta['final_scripted_positions']
    accepted = json.loads((SPRITES / 'motion-comparison/CONTROL-FINAL.json').read_text())
    final = {str(control.root_id): bytes(root).hex()}
    final.update({str(a['buffer']): bytes(arrays[a['buffer']]).hex()
                  for a in control.spec.arrays.values() if a['access'] == 3})
    assert final == accepted, 'Full final root and all mutable arrays differ from accepted moving control'
    for runtime in (*runtimes, *([capture] if capture else [])):
        assert runtime.invoke('StopRace') == 0 and runtime.invoke(operation=3) == 0
        assert not runtime.live and runtime.grants == runtime.releases
        runtime.canaries()
        assert runtime.peak == 4
    if capture:
        assert len(capture_rows) == len(SELECTED) and len(capture_binary) < 128 * 1024
        (HERE / 'span-inputs.bin').write_bytes(capture_binary)
        (HERE / 'span-inputs.json').write_text(json.dumps(dict(schema=1,
            origin='Host-only capture clone of accepted additive control; selected actual moving-world Render30 calls',
            format='Little-endian8-byte <HHHBB: road-row byte offset,left,right,colour,zero padding',
            row_stride=320, road_bytes=38400, count=len(capture_binary) // 8,
            bytes=len(capture_binary), sha256=digest(capture_binary), frames=capture_rows,
            includes_empty_calls=True, initial_grass_memset_included=False,
            instrumented_outputs_exact_to_uninstrumented_control=True,
            frozen_control_render_core_sha256=sha(CONTROL / 'helper/render_core.inc'),
            instrumented_render_core_sha256=sha(CAPTURE / 'helper/render_core.inc')), indent=2) + '\n')
    return dict(frames=900, physics_ticks=3600, generated_invocations_per_package=4502,
        independent_traffic_route_player_contact_checks_per_tick=True,
        accepted_motion_table_independently_regenerated=True, render_time_positions_and_lanes_exact=True,
        full_final_root_and_mutable_arrays_exact_to_accepted_control=True,
        all_tick_and_render_root_arrays_exact_between_packages=True,
        all_completion_bytes_exact=True, road_pixels_exact=True,
        all_output_allocation_bytes_exact=True, road_actor_player_commands_exact=True,
        all8_actor_descriptors_exact=True, all8_actor_scratch_allocations_exact=True,
        hashes={name: h.hexdigest() for name, h in hashes.items()},
        command_bytes_total=dict(zip(('road', 'actor', 'player'), command_bytes)),
        final_buffers=final,
        leases={name: dict(peak=r.peak, grants=r.grants, releases=r.releases,
                          balanced=not r.live and r.grants == r.releases, canaries_intact=True)
                for name, r in zip(('control', 'candidate'), runtimes)},
        span_capture_selected_frames=list(SELECTED) if capture else [])


def make_capture():
    assert not CAPTURE.exists(), 'Use a fresh capture workspace; preserve prior data'
    shutil.copytree(CONTROL, CAPTURE)
    path = CAPTURE / 'helper/render_core.inc'
    text = path.read_text()
    signature = 'static void r28_span_fill(uint8_t *row, int left, int right, uint8_t colour) {'
    assert text.count(signature) == 1
    start = text.index(signature)
    end = text.index('\n}', start) + 2
    original = text[start:end]
    replacement = original.replace('r28_span_fill(', 'r28_span_fill_original(', 1)
    replacement += '\n' + signature + '\n    host_record_span(row, left, right, colour);\n'
    replacement += '    r28_span_fill_original(row, left, right, colour);\n}'
    path.write_text(text[:start] + replacement + text[end:])


def worker(mode):
    before = {name: package_hashes(directory) for name, directory in (('control', CONTROL), ('candidate', CANDIDATE))}
    result = dict(schema=1, mode=mode, authoritative_input=reference_identity(),
                  scope='Actual generated-C host replay; synthetic retained actor artwork; no emulator or speed claim',
                  limitations='Host ABI/compiler only. Accepted-control byte parity plus independent integer world/motion checks; full final root also equals accepted emulator evidence. Rendering/display completion and target timing require separate checks.',
                  replay=replay(mode), sources=sources(), package_sha256=before)
    assert before == {name: package_hashes(directory) for name, directory in (('control', CONTROL), ('candidate', CANDIDATE))}
    result['package_files_unchanged_during_replay'] = True
    (HERE / ('replay-' + mode + '.json')).write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(dict(mode=mode, frames=900, physics_ticks=3600, passed=True,
                         hashes=result['replay']['hashes'], leases=result['replay']['leases']), indent=2), flush=True)


def main():
    WORK.mkdir(parents=True, exist_ok=True)
    reference_identity()
    make_capture()
    for mode in ('ordinary', 'sanitized'):
        flags = [] if mode == 'ordinary' else ['-fsanitize=address,undefined', '-fno-omit-frame-pointer']
        for name, package in (('control', CONTROL), ('candidate', CANDIDATE), *([('capture', CAPTURE)] if mode == 'ordinary' else [])):
            command = ['cc', '-shared', '-fPIC', '-O1', '-fno-builtin', '-ffp-contract=off', *flags,
                       '-I' + str(PACED / 'control/sdk/include'), '-I' + str(package)]
            if name == 'capture': command += ['-DR28_HOST_CAPTURE']
            command += [str(HERE / 'host_exports.c'), '-o', str(WORK / (name + '-' + mode + '.so'))]
            subprocess.run(command, check=True)
        env = os.environ.copy()
        if mode == 'sanitized':
            env['LD_PRELOAD'] = subprocess.check_output(['cc', '-print-file-name=libasan.so'], text=True).strip()
            env['ASAN_OPTIONS'] = 'detect_leaks=0:halt_on_error=1'
            env['UBSAN_OPTIONS'] = 'halt_on_error=1:print_stacktrace=1'
        subprocess.run([sys.executable, __file__, '--worker', mode], env=env, check=True)
    a, b = (json.loads((HERE / ('replay-' + mode + '.json')).read_text()) for mode in ('ordinary', 'sanitized'))
    assert a['replay']['hashes'] == b['replay']['hashes']
    assert a['replay']['final_buffers'] == b['replay']['final_buffers']
    print('PASS: ordinary/sanitized digests and complete final buffers match.', flush=True)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--worker', choices=('ordinary', 'sanitized'))
    args = parser.parse_args()
    if args.worker:
        try:
            worker(args.worker)
        except BaseException as error:
            (HERE / ('replay-failure-' + args.worker + '.json')).write_text(json.dumps(dict(
                mode=args.worker, error=str(error), traceback=traceback.format_exc(),
                source_sha256=sha(__file__)), indent=2) + '\n')
            raise
    else:
        main()
