"""INC-001-02 separate native phase diagnostics; never launch an emulator.

Build copies a caller-supplied package and fixture into this task's .work. The
historical throughput builders/reports are never executed or overwritten.
CCOUNT is an uncalibrated guest counter; this diagnostic is separate from the
uninstrumented 900-frame completed-render comparison.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import shutil
import struct
import subprocess
import sys

HERE = Path(__file__).resolve().parent
THROUGHPUT = HERE.parents[1] / 'throughput'
PACED = THROUGHPUT.parent / 'paced-road'
CONTROL = PACED / 'control'
sys.path.insert(0, str(THROUGHPUT))
sys.path.insert(0, str(PACED))
import phase_tape as tape_encoder
from phase_build import quiet_marker
from phase_verify import decode
from freeze_control import records

LOG, TAIL, HEADER, ROW, PRIVATE = 50305, 50306, 32, 52, 60000
NAME = 'phase-render'
LIMITS = dict(text=32768, data=4096, stack=2048, image=65536)


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def save(path, value):
    Path(path).write_text(json.dumps(value, indent=2) + '\n')


def once(text, old, new):
    assert text.count(old) == 1, ('Changed instrumentation site', old, text.count(old))
    return text.replace(old, new, 1)


def instrument(package,compact=False):
    native_path = package / 'native.c'
    native = native_path.read_text()
    native = once(native, '#include "helper/rally_render.c"',
                  '#define R28_PHASE 1\n#include "phase_clock.inc"\n#include "helper/rally_render.c"')
    native, n = re.subn(r'(?m)^__attribute__\(\(visibility\("default"\)\)\)\nint32_t vdplet_entry\(',
                        'static int32_t phase_original_entry(', native)
    assert n == 1, ('Unexpected entry declaration', n)
    native += '\n' + (HERE / ('phase_entry_compact.inc' if compact else 'phase_entry.inc')).read_text()
    native_path.write_text(native)
    shutil.copyfile(HERE/'phase_clock_compact.inc' if compact else THROUGHPUT/'phase_clock.inc',
                    package/'phase_clock.inc')
    helper_path = package / 'helper/rally_render.c'
    helper = helper_path.read_text()
    helper = once(helper, 'Out out={v.data,0,v.bytes,0};',
                  'Out out={v.data,0,v.bytes,0};\n                uint32_t phase_build_begin=phase_clock();')
    helper, n = re.subn(r'(?m)^(\s*)if\(out\.error',
        r'\1phase_values[3+i]+=phase_clock()-phase_build_begin;\n\1if(out.error', helper)
    assert n == 1, ('Unexpected helper failure check', n)
    helper_path.write_text(helper)


def supplied_parts(fixture, meta):
    """Keep exact paint and all post-UNLOAD cleanup from the actual input."""
    tape = (fixture / 'script.bin').read_bytes()
    parsed = records(tape)
    outputs = meta['resources']['outputs']
    suffix = b''.join(tape_encoder.call(o['buffer']) for o in outputs)
    paints = []
    for record in parsed:
        if record['opcode'] != 1 or not record['loop']:
            continue
        start = record['payload_offset']
        data = tape[start:start+record['payload_bytes']]
        if data.startswith(b'\x1a\x1f\0\0RALLY / GOLEM NATIVE DEMO'):
            assert data.endswith(suffix), 'Drawing CALL list changed'
            paints.append(data[:-len(suffix)])
    assert len(paints) == 1, 'Expected one per-frame paint block'
    paint = paints[0]
    split = bytes.fromhex('19 04 00 00 18 00 19 65 3f 01 67 00 '
                          '19 04 00 00 e0 00 19 65 3f 01 ef 00')
    assert split in paint, 'Phase input must retain the completed split-clear change'
    unload = [c['token'] for c in meta['checks'] if c['label'] == 'UNLOAD']
    assert len(unload) == 1
    sites = [i for i, r in enumerate(parsed) if r['opcode'] == 2 and r['token'] == unload[0]]
    assert len(sites) == 1
    cleanup = []
    for record in parsed[sites[0]+1:]:
        assert record['opcode'] in (0, 1), 'Unexpected non-SEND cleanup after UNLOAD'
        if record['opcode'] == 1:
            start = record['payload_offset']
            cleanup.append(tape[start:start+record['payload_bytes']])
    assert cleanup, 'Expected explicit road/sprite cleanup'
    return paint, cleanup


def fixture_build(case, package, source, module, out, frames,lite_mode=False):
    out.mkdir()
    original = json.loads((source / 'expected.json').read_text())
    resources = original['resources']
    iface = json.loads((package / 'interface.json').read_text())
    backend = json.loads((package / 'backends.json').read_text())
    names = {e['name']: e['logical_id'] for e in iface['entries']}
    fields = {g['name']: g for g in iface['globals']}
    root = iface['state_buffer']
    completion, outputs = resources['completion'], resources['outputs']
    paint, cleanup = supplied_parts(source, original)
    header_bytes,row_bytes=(16,12) if lite_mode else (HEADER,ROW)
    tape = tape_encoder.Tape()
    for name in ('probe.bin', 'artwork.vdu', 'assets.vdu', 'common.vdu', 'native.vdu'):
        shutil.copyfile(source / name, out / name)
    early_module_load = original.get('early_module_load', False)
    assert isinstance(early_module_load,bool)
    if not early_module_load:
        for name in ('artwork.vdu', 'assets.vdu'):
            tape.external(name, (out / name).read_bytes(), out)
    image = module.read_bytes()
    tape.send(tape_encoder.write(resources['staging'], image))
    tape.tx(1, struct.pack('<HIH', resources['staging'], len(image), 0),
            2, None, 'LOAD', capture=True)
    if early_module_load:
        for name in ('artwork.vdu', 'assets.vdu'):
            tape.external(name, (out / name).read_bytes(), out)
    for name in ('common.vdu', 'native.vdu'):
        tape.external(name, (out / name).read_bytes(), out)
    for wrapper in backend['native_wrappers']:
        tape.patch(tape_encoder.update(wrapper, backend['native_handle_offset'], b'\0\0'), 11)
    tape.send(tape_encoder.update(root, 8, struct.pack('<I', 7)))
    tape.send(tape_encoder.write(completion['buffer'], bytes(completion['offset']+48)))
    for desc in outputs:
        tape.send(tape_encoder.write(desc['buffer'], bytes(desc['bytes'])))

    def invoke(name):
        tape.send(tape_encoder.update(root, 28, struct.pack('<H', names[name])))
        tape.send(tape_encoder.update(completion['buffer'], completion['offset']+44, b'\0\0'))
        tape.tx(2, struct.pack('<HHH', 0, names[name], backend['native_arguments']),
                3, 0, name, handle=True)

    def private(op, label):
        tape.tx(2, struct.pack('<HHH', 0, PRIVATE+op, backend['native_arguments']),
                3, 0, label, handle=True)

    invoke('InitRace')
    assert resources['staging'] == LOG, 'Phase log reuse requires copied LOAD staging'
    tape.send(tape_encoder.write(LOG, bytes(header_bytes+frames*row_bytes)))
    if not lite_mode:
        private(0, 'phase reset')
    tail, patches = bytearray(), []

    def marker(op):
        patches.append(len(tail)+11)
        tail.extend(quiet_marker(PRIVATE+op, backend['native_arguments']))

    flush = b'\x17\0\xca'
    if lite_mode:
        tail.extend(paint+tape_encoder.call(outputs[0]['buffer'])+flush)
        marker(0)
        tail.extend(tape_encoder.call(outputs[1]['buffer'])+flush)
        marker(1)
        tail.extend(tape_encoder.call(outputs[2]['buffer'])+b'\x17\0\xc3'+flush)
    else:
        marker(1)
        tail.extend(paint+flush)
        marker(2)
        for i, desc in enumerate(outputs, 3):
            tail.extend(tape_encoder.call(desc['buffer'])+flush)
            marker(i)
        marker(6)
        tail.extend(b'\x17\0\xc3'+flush)
        marker(7)
    tail.extend(tape_encoder.command(65535, 7))
    tape.send(tape_encoder.write(TAIL, tail))
    for offset in patches:
        tape.patch(tape_encoder.update(TAIL, offset, b'\0\0'), 11)
    tape.tx(4, struct.pack('<H', 17), 4, None, 'stack before')
    tape.mark()
    tape.repeat(frames)
    tape.send(tape_encoder.call(backend['native_wrappers'][names['Tick120']])*4)
    invoke('Render30')
    tape.read(completion['buffer'], completion['offset']+44, 1, 'completion ready', 4)
    tape.read(completion['buffer'], completion['offset']+16, 0, 'completion request = frame', 16)
    tape.read(completion['buffer'], completion['offset']+20, 0, 'completion tick = frame*4', 8)
    tape.read(root, 20, 0, 'fresh root generation = frame*5+1', 36)
    tape.send(tape_encoder.call(TAIL))
    tape.read(LOG, 10, 0, 'phase row committed = frame', 20)
    tape.mark()
    tape.endrepeat()
    if not lite_mode:
        private(8, 'phase sequence complete')
    tape.tx(4, struct.pack('<H', 17), 4, None, 'stack after')
    tape.mark()
    tape.read(root, 20, 1+5*frames, 'final generation')
    tape.read(root, 22, 0, 'final generation high')
    tape.read(root, fields['worldTick']['offset'], frames*4, 'final world tick')
    tape.read(root, fields['renderRequest']['offset'], frames, 'final render request')
    data_buffers = [(root, (package/'state.bin').read_bytes())]
    data_buffers += [(a['buffer'], (package/a['initial_data']).read_bytes())
                     for a in iface['arrays'] if a['access'] == 3]
    for key, data in data_buffers:
        for offset in range(0, len(data), 2):
            tape.read(key, offset, None, f'final:{key}:{offset}')
    for offset in range(0, header_bytes+frames*row_bytes, 2):
        tape.read(LOG, offset, None, f'phase:{offset}')
    invoke('StopRace')
    tape.tx(3, b'\0\0', 3, 0, 'UNLOAD', handle=True)
    for command in cleanup:
        tape.send(command)
    tape.send(tape_encoder.command(TAIL, 2)+tape_encoder.command(LOG, 2))
    tape.data += b'\0'
    logged = sum(c['repeats']*10 for c in tape.checks if not c['flags'] & 4)
    assert tape.marks == frames+2 and tape.marks*3 <= 3000
    assert logged <= 50000 and len(tape.data) <= 0x30000
    (out/'script.bin').write_bytes(tape.data)
    (out/'run.txt').write_bytes(b'load probe.bin\r\nrun .\r\n')
    meta = dict(schema=1, frames=frames, physics_ticks=frames*4, paced=False,
        review_fast=True, checks=tape.checks, reply_bytes=logged,
        tick_samples=tape.marks, mos_tick_hz=120, prt_instrumented=True,
        prt_cycles_per_tick=18432, package=str(package), module_sha256=sha(module),
        resources=resources, phase_candidate=case, phase_log_buffer=LOG,
        phase_tail_buffer=TAIL, phase_header_bytes=header_bytes, phase_row_bytes=row_bytes,
        phase_lite=lite_mode,
        phase_tail_hex=tail.hex(), phase_handle_patch_offsets=patches,
        timing_scope='Separate instrumented diagnostic; raw CCOUNT is uncalibrated. MOS/PRT include checks, drawing, flushes and completed-swap fence.',
        phase_actor_scope='Add actors_build_cycles to actors_dispatch_draw_and_flush: specialized sampling can move work into preparation.',
        native_setup_byte_identical=True, paint_block_byte_identical=True,
        early_module_load=early_module_load,
        post_unload_input_cleanup_preserved=True,
        files={p.name:sha(p) for p in out.iterdir()})
    save(out/'expected.json', meta)
    return meta


def build(case, package, fixture, frames=128, text_limit=32768, compact=False):
    assert re.fullmatch(r'[a-zA-Z0-9][a-zA-Z0-9_-]*', case), 'Unsafe case name'
    assert frames in (64, 128)
    policy = CONTROL/'sdk/src/vdplet_policy.h'
    maximum = re.search(r'^#define VDPL_MAX_TEXT (\d+)u$', policy.read_text(), re.M)
    assert maximum and 0 < text_limit <= int(maximum.group(1)), 'Text allowance exceeds frozen policy'
    limits = {**LIMITS, 'text':text_limit}
    package, fixture = Path(package).resolve(), Path(fixture).resolve()
    work = HERE/'.work'/('phase-'+case)
    assert not work.exists(), 'Preserve phase outputs; choose a fresh case name'
    work.mkdir(parents=True)
    copied = work/'package'
    shutil.copytree(package, copied)
    before = {str(p.relative_to(package)):sha(p) for p in package.rglob('*') if p.is_file()}
    instrument(copied,compact)
    command = [sys.executable, str(CONTROL/'sdk/tools/build_module.py'), str(copied/'native.c'),
        '--name', NAME, '--build-id', '0x52324950', '--output', str(work/'target')]
    for key, value in limits.items():
        command += ['--'+key+'-limit', str(value)]
    try:
        result = subprocess.run(command, check=True, stdout=subprocess.PIPE,
                                stderr=subprocess.STDOUT, text=True)
    except subprocess.CalledProcessError as exc:
        save(work/'BUILD-FAILED.json', dict(error='Diagnostic module build failed',
             command=command, exit=exc.returncode, output=exc.stdout, limits=limits,
             sdk_or_policy_modified=False))
        raise
    (work/'target/build-output.txt').write_text(result.stdout)
    module = json.loads((work/'target'/(NAME+'.json')).read_text())
    meta = fixture_build(case, copied, fixture, work/'target'/(NAME+'.vdpl'), work/'fixture', frames)
    meta['compact_diagnostic']=compact
    save(work/'fixture/expected.json',meta)
    assert before == {str(p.relative_to(package)):sha(p) for p in package.rglob('*') if p.is_file()}
    for name in ('probe.bin', 'artwork.vdu', 'assets.vdu', 'common.vdu', 'native.vdu'):
        assert sha(fixture/name) == sha(work/'fixture'/name)
    report = dict(case=case, frames=frames, module=module, fixture=str(work/'fixture'),
        source_package=str(package), source_fixture=str(fixture), source_package_files=before,
        fixture_files={p.name:sha(p) for p in (work/'fixture').iterdir()},
        source_files={p.name:sha(p) for p in (HERE/'phase_test.py',
            HERE/('phase_entry_compact.inc' if compact else 'phase_entry.inc'),
            HERE/'phase_clock_compact.inc' if compact else THROUGHPUT/'phase_clock.inc')},
        phase_rows=frames, phase_retained_reply_bytes=meta['reply_bytes'],
        driver_unchanged=True, assets_and_native_setup_unchanged=True,
        early_module_load=meta['early_module_load'],
        compact_diagnostic=compact,
        declared_limits=limits, policy_sha256=sha(policy), policy_modified=False,
        firmware_changed=False, sdk_changed=False, emulator_run=False,
        separate_from_headline_throughput=True)
    save(work/'BUILD.json', report)
    print(json.dumps(dict(case=case, fixture=report['fixture'], module=module['module'],
                         phase_retained_reply_bytes=meta['reply_bytes']), indent=2))
    return report


def verify(directory, standard_result, expected_final):
    """Decode real returned phase observations and compare independent state."""
    directory = Path(directory)
    if isinstance(standard_result, (str, Path)):
        standard_result = json.loads(Path(standard_result).read_text())
    if 'result' in standard_result:
        standard_result = standard_result['result']
    if isinstance(expected_final, (str, Path)):
        expected_final = json.loads(Path(expected_final).read_text())
    if 'final_buffers' in expected_final:
        expected_final = expected_final['final_buffers']
    meta = json.loads((directory/'expected.json').read_text())
    assert standard_result['frames'] == meta['frames']
    assert standard_result['physics_ticks'] == meta['frames']*4
    assert standard_result['final_buffers'] == expected_final, 'Independent final state differs'
    words = {int(r['label'].split(':')[1]):r['value']
             for r in standard_result['observations'] if r['label'].startswith('phase:')}
    assert sorted(words) == list(range(0, HEADER+meta['frames']*ROW, 2))
    data = b''.join(struct.pack('<H', words[offset]) for offset in sorted(words))
    result = decode(data, meta['frames'])
    for row in result['rows']:
        row['road_preparation_and_execution'] = row['road_build_cycles']+row['road_dispatch_draw_and_flush']
        row['actors_preparation_and_execution'] = row['actors_build_cycles']+row['actors_dispatch_draw_and_flush']
    result.update(candidate=meta['phase_candidate'], full_final_state_matches_host=True,
        elapsed_mos_units=standard_result['elapsed_mos_ticks'],
        nominal_mos_seconds=standard_result['elapsed_seconds'],
        nominal_prt_seconds=standard_result['prt']['nominal_seconds_at_18432000_hz'],
        separate_from_headline_throughput=True)
    save(directory/'phase-verified.json', result)
    return result


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest='action', required=True)
    item = commands.add_parser('build')
    item.add_argument('--case', required=True)
    item.add_argument('--package', type=Path, required=True)
    item.add_argument('--fixture', type=Path, required=True)
    item.add_argument('--frames', type=int, choices=(64,128), default=128)
    item.add_argument('--text-limit', type=int, default=32768,
                      help='Explicit diagnostic allowance within unchanged frozen SDK policy')
    item.add_argument('--compact', action='store_true',
                      help='Equivalent compact private wrapper/serialization; existing modules preserved')
    item = commands.add_parser('verify')
    item.add_argument('--fixture', type=Path, required=True)
    item.add_argument('--result', type=Path, required=True)
    item.add_argument('--expected', type=Path, required=True)
    args = parser.parse_args()
    if args.action == 'build':
        build(args.case, args.package, args.fixture, args.frames, args.text_limit,args.compact)
    else:
        result = verify(args.fixture, args.result, args.expected)
        print(json.dumps({k:v for k,v in result.items() if k != 'rows'}, indent=2))
