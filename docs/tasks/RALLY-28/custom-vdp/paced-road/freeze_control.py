"""Freeze and inspect the exact reviewed R25 control without launching it."""
from pathlib import Path
import hashlib
import json
import shutil
import struct
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[4]
DEMO = ROOT / 'docs/tasks/RALLY-25/native-demo'
SDK = ROOT.parent / 'agon-vdplet'
GOLEM = ROOT.parent / 'golem'
PACKAGE = GOLEM / 'docs/tasks/GOLEM-037/binding/delivery/candidate-48eac7efe8fa51f4'
sha = lambda p: hashlib.sha256(Path(p).read_bytes()).hexdigest()


def records(data):
    """Parse every driver tape opcode, without interpreting VDU commands."""
    at = 0
    result = []
    loop = False
    while at < len(data):
        start = at
        op = data[at]
        at += 1
        r = dict(offset=start, opcode=op, loop=loop)
        if op == 0:
            assert at == len(data), 'Trailing data after END'
            result.append(r)
            return result
        if op in (1, 3, 9, 12):
            n = int.from_bytes(data[at:at+2], 'little')
            at += 2
            r['value'] = n
            if op == 1:
                r['payload_offset'], r['payload_bytes'] = at, n
                at += n
            elif op == 9:
                assert not loop
                loop = True
        elif op == 2:
            token, kind, flags, value, patch, n = struct.unpack_from('<HBBHHH', data, at)
            at += 10
            r.update(token=token, kind=kind, flags=flags, value=value,
                     handle_patch=patch, payload_offset=at, payload_bytes=n)
            at += n
        elif op == 4:
            offset, n = struct.unpack_from('<HH', data, at)
            at += 4
            r.update(handle_patch=offset, payload_offset=at, payload_bytes=n)
            at += n
        elif op == 6:
            n = int.from_bytes(data[at:at+3], 'little')
            at += 3
            end = data.index(0, at)
            r.update(filename=data[at:end].decode(), payload_bytes=n)
            at = end+1
        elif op == 10:
            assert loop
            loop = False
        elif op not in (5, 11):
            raise AssertionError(('Unknown tape opcode', start, op))
        assert at <= len(data)
        result.append(r)
    raise AssertionError('Missing END')


def copy_checked(source, target, digest=None):
    digest = digest or sha(source)
    assert sha(source) == digest, str(source)
    target.parent.mkdir(parents=True, exist_ok=True)
    if target.exists():
        assert sha(target) == digest, f'Existing frozen file differs: {target}'
    else:
        shutil.copyfile(source, target)
    assert sha(target) == digest


def freeze():
    source = DEMO / 'evidence/c8-review02'
    emulator = DEMO / 'evidence/review-restaged02'
    deploy = json.loads((DEMO / 'C8-REVIEW-DEPLOYMENT.json').read_text())
    fixture = HERE / 'control/fixture'
    for name, digest in deploy['files'].items():
        copy_checked(source/name, fixture/name, digest)
    # Output logs are preserved as .bin to avoid the repository-wide *.log ignore.
    for platform, directory in [('console8', source), ('flexe', emulator)]:
        for name in ('replies', 'ticks', 'prt', 'clock'):
            copy_checked(directory/(name+'.log'), HERE/'control/returns'/platform/(name+'.bin'))
    for name in ('probe.bin', 'script.bin', 'artwork.vdu', 'assets.vdu',
                 'common.vdu', 'native.vdu', 'expected.json'):
        assert sha(source/name) == sha(emulator/name), name

    export = json.loads((PACKAGE.parent/(PACKAGE.name+'-export-receipt.json')).read_text())
    for name, item in export['present_files'].items():
        copy_checked(PACKAGE/name, HERE/'control/package'/name, item['sha256'])
    manifest = json.loads((PACKAGE/'delivery-manifest.json').read_text())
    pin = json.loads((GOLEM/'docs/tasks/GOLEM-037/helper-pin.json').read_text())
    for name, digest in pin['copied_sources'].items():
        copy_checked(DEMO.parent/'renderer-helper'/name, HERE/'control/package/helper'/name, digest)
    copy_checked(DEMO/'demo.golem', HERE/'control/source/demo.golem', manifest['source_sha256'])
    copy_checked(PACKAGE/'delivery-manifest.json', HERE/'control/package/delivery-manifest.json')
    copy_checked(PACKAGE.parent/(PACKAGE.name+'-export-receipt.json'), HERE/'control/package/export-receipt.json')

    # Export the exact accepted SDK builder, rather than adopting its newer live revision.
    for name in manifest['sdk_files']:
        data = subprocess.check_output(['git', '-C', str(SDK), 'show', '9fbb21d:'+name])
        assert hashlib.sha256(data).hexdigest() == manifest['sdk_files'][name], name
        dest = HERE/'control/sdk'/name
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_bytes(data)
    license_data = subprocess.check_output(['git', '-C', str(SDK), 'show', '9fbb21d:LICENSE'])
    (HERE/'control/sdk/LICENSE').write_bytes(license_data)

    tape = (fixture/'script.bin').read_bytes()
    parsed = records(tape)
    expected = json.loads((fixture/'expected.json').read_text())
    runtime = json.loads((HERE/'ORYX-INPUTS.json').read_text())
    for name in ('probe.bin', 'script.bin', 'artwork.vdu', 'assets.vdu',
                 'common.vdu', 'native.vdu', 'expected.json'):
        assert runtime['verified_files']['sdcard/rally25/'+name] == sha(fixture/name), name
    assert runtime['verified_files']['esp32-firmware.bin'] == sha(fixture/'vdp_rally.bin')
    image = (HERE/'control/package/rally-render.vdpl').read_bytes()
    offset = tape.index(image)
    assert tape.count(image) == 1
    assert hashlib.sha256(image).hexdigest() == expected['module_sha256']
    assert expected['paced'] and expected['review_fast'] and expected['frames'] == 900
    assert expected['physics_ticks'] == 3600 and expected['reply_bytes'] == 29130
    assert [r['value'] for r in parsed if r['opcode'] == 9] == [900]
    assert len([r for r in parsed if r['opcode'] == 11 and r['loop']]) == 1
    assert [r['filename'] for r in parsed if r['opcode'] == 6] == ['artwork.vdu', 'assets.vdu', 'common.vdu', 'native.vdu']
    meta = json.loads((PACKAGE/'backends.json').read_text())
    interface = json.loads((PACKAGE/'interface.json').read_text())
    tick_id = next(e['logical_id'] for e in interface['entries'] if e['name'] == 'Tick120')
    wrapper = meta['native_wrappers'][tick_id]
    call = b'\x17\0\xa0'+struct.pack('<H', wrapper)+b'\1'
    assert sum(tape[r['payload_offset']:r['payload_offset']+r['payload_bytes']] == call*4
               for r in parsed if r['opcode'] == 1 and r['loop']) == 1
    (HERE/'TAPE.json').write_text(json.dumps(parsed, indent=2)+'\n')

    # Recover the old 3/3/4 pacer. The assembled result must prove this recovery.
    current = (DEMO/'guest.asm').read_text()
    old = current.replace('    ld bc,4\n    add hl,bc\n    ld (frame_deadline),hl',
        '    ld bc,3\n    add hl,bc\n    ld a,(frame_fraction)\n    inc a\n    cp 3\n'
        '    jr c,pace_fraction_ready\n    xor a\n    inc hl\n'
        'pace_fraction_ready:\n    ld (frame_fraction),a\n    ld (frame_deadline),hl', 1)
    assert old != current
    old = old.replace('include ".work/mos_api.inc"', 'include "mos_api.inc"')
    old = old.replace('; 11=absolute30-Hz deadline: four MOS units per60-Hz-mode frame.',
                      '; 11=preserved reviewed pacer: three, three, four MOS units.')
    (HERE/'control/source/guest.asm').write_text(old)
    copy_checked(DEMO/'.work/mos_api.inc', HERE/'control/source/mos_api.inc')
    copy_checked(DEMO/'prt.inc', HERE/'control/source/prt.inc')
    assembler = GOLEM/'docs/tasks/GOLEM-007/build/ez80asm'
    build = HERE/'.work/driver'
    build.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(HERE/'control/source/guest.asm', build/'guest.asm')
    shutil.copyfile(HERE/'control/source/mos_api.inc', build/'mos_api.inc')
    shutil.copyfile(HERE/'control/source/prt.inc', build/'prt.inc')
    subprocess.run([str(assembler), 'guest.asm', 'probe.bin', '-c', '-l', '-s'], cwd=build, check=True,
                   stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    assert sha(build/'probe.bin') == sha(fixture/'probe.bin'), 'Recovered driver is not byte-identical'

    toolchain = Path.home()/'.platformio/packages/toolchain-xtensa-esp32/bin/xtensa-esp32-elf-gcc'
    receipt = dict(schema=1, checkpoint='bb20c48', immutable_files={str(p.relative_to(HERE)):sha(p)
        for p in sorted((HERE/'control').rglob('*')) if p.is_file()},
        same_seven_inputs_on_flexe_and_console8=True, module_offset_in_tape=offset,
        driver_rebuilt_byte_identically=True, assembler_sha256=sha(assembler),
        native_toolchain_sha256=sha(toolchain),
        native_toolchain_version=subprocess.check_output([str(toolchain),'--version'],text=True).splitlines()[0],
        runtime_identity_receipt_sha256=sha(HERE/'ORYX-INPUTS.json'),
        runtime_files=runtime['verified_files'],
        frames=900, physics_ticks=3600, physics_steps_per_frame=4, logged_reply_records=2913,
        pacer=dict(opcode=11, absolute_deadline=True, increment_mos_units=[3,3,4],
                   nominal_mos_units_per_second=120, requested_fps=36,
                   source_warning='Current R25 guest.asm uses four units; preserve recovered driver for this comparison'),
        limitations=['Foreground render-ready checks concern command publication, not pixel completion',
                     'Per-frame mark follows swap submission; there is no separate completed-swap reply',
                     'Paced aggregate is not maximum physics/render throughput'],
        emulator_launched=False, physical_card_written=False)
    (HERE/'CONTROL.json').write_text(json.dumps(receipt,indent=2)+'\n')
    print(json.dumps({k:v for k,v in receipt.items() if k!='immutable_files'},indent=2))


if __name__ == '__main__':
    freeze()
