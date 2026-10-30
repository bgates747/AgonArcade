"""Complete-race inputs from preserved native renderers and one real eZ80 guest.

No emulator, remote access, compiler/SDK change or historical-fixture mutation.
The shared guest loads the module before large artwork uploads. Actual production
panorama/HUD retention is shared by every renderer; obsolete clear/static cases
are explicit input-identical aliases rather than invented extra work.
"""
from pathlib import Path
import argparse
import hashlib
import json
import shutil
import struct
import zipfile

HERE = Path(__file__).resolve().parent
CUSTOM = HERE.parent
PACED = CUSTOM / 'paced-road'
INC = CUSTOM / 'incremental'
WORK = HERE / '.work'
PRESENTATION = HERE / 'presentation'
ROOT = HERE.parents[4]
MODULE_NAME = 'rally-render.vdpl'
NATIVE_C_SHA = '94d92d109f9b3b93e8ddfea1427edcdeb9059a87636a6bacfd93d3c3894a1992'
FIRMWARE_SHA = '8da2ebfdfa3b5b00f4a1929ad4885c838845b160f570259792ef370b69d4f473'
FRAMES = 900
CONFIG_MAGIC = b'R28F'
CONFIG_SCHEMA = 1
COMMON_NAMES = ('probe.bin', 'artwork.vdu', 'presentation.vdu', 'run.txt')


def digest(data):
    return hashlib.sha256(data).hexdigest()


def sha(path):
    return digest(Path(path).read_bytes())


def write(path, data):
    """Reusing identical private inputs is safe; never overwrite another result."""
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists():
        assert path.read_bytes() == data, ('Existing input differs; preserve it', path)
    else:
        path.write_bytes(data)


def save(name, value):
    write(HERE / name, (json.dumps(value, indent=2) + '\n').encode())


def command(key, operation):
    return b'\x17\0\xa0' + struct.pack('<H', key) + bytes([operation])


def buffer_file(key, data):
    """Stock buffered write, preserving bytes in blocks no larger than65535."""
    result = bytearray(command(key, 2))
    for offset in range(0, len(data), 65535):
        chunk = data[offset:offset + 65535]
        result += command(key, 0) + struct.pack('<H', len(chunk)) + chunk
    return bytes(result)


def road_setup(bitmap_format):
    assert bitmap_format in (1, 3)
    key, width, height = 50700, 320, 120
    return (buffer_file(key, bytes(width * height)) + b'\x17\x1b\x20' + struct.pack('<H', key)
            + b'\x17\x1b\x21' + struct.pack('<HHB', width, height, bitmap_format))


def sampler_setup():
    result = bytearray()
    for slot in range(8):
        key = 50710 + slot
        width, height = (99, 75) if slot < 6 else (62, 62)
        result += buffer_file(key, bytes(width * height))
        result += b'\x17\x1b\x20' + struct.pack('<H', key)
        result += b'\x17\x1b\x21' + struct.pack('<HHB', width, height, 1)
    return bytes(result)


def verified_archive(path, manifest_path):
    manifest = json.loads(Path(manifest_path).read_text())
    wanted = manifest.get('sha256', manifest.get('archive_sha256'))
    assert wanted and sha(path) == wanted, ('Frozen archive changed', path)
    members = manifest.get('members')
    if not isinstance(members, dict):
        members = manifest.get('member_sha256')
    assert isinstance(members, dict)
    archive = zipfile.ZipFile(path)
    return archive, manifest, members


def archived(archive, members, name):
    data = archive.read(name)
    assert digest(data) == members[name], ('Frozen member changed', name)
    return data


def copy_package(package, destination, pins):
    for relative, wanted in sorted(pins.items()):
        path = package / relative
        assert sha(path) == wanted, ('Frozen source changed', path)
        write(destination / relative, path.read_bytes())


def archive_package(archive, members, prefix, destination):
    seen = []
    for member in sorted(members):
        if not member.startswith(prefix) or member.endswith('/'):
            continue
        relative = Path(member[len(prefix):])
        assert relative.parts and '..' not in relative.parts and not relative.is_absolute()
        # Inherited build artifacts in source packages are historical metadata.
        # Never confuse them with authoritative archive target/... modules.
        write(destination / relative, archived(archive, members, member))
        seen.append(str(relative))
    assert 'native.c' in seen and 'helper/render_core.inc' in seen


def prepare_sources():
    frozen = json.loads((PACED / 'CONTROL.json').read_text())
    for name, wanted in frozen['immutable_files'].items():
        assert sha(PACED / name) == wanted, ('Frozen control changed', name)
    package_pins = {name.removeprefix('control/package/'): wanted
                    for name, wanted in frozen['immutable_files'].items()
                    if name.startswith('control/package/')}
    baseline_package = PACED / 'control/package'
    modules = {}
    road_build = json.loads((PACED / 'CANDIDATE-BUILD.json').read_text())
    archive, manifest, members = verified_archive(PACED / 'CANDIDATES.zip', PACED / 'CANDIDATES-PACKAGE.json')
    with archive:
        for source_name, metadata in road_build.items():
            name = 'baseline' if source_name == 'control' else source_name
            package = WORK / 'packages' / name
            # Most package files are common generated simulation/ABI metadata;
            # each preserved road core is the sole implementation replacement.
            for relative, wanted in sorted(package_pins.items()):
                if relative == 'helper/render_core.inc':
                    continue
                path = baseline_package / relative
                assert sha(path) == wanted
                write(package / relative, path.read_bytes())
            core_name = 'modules/' + source_name + '/render_core.inc'
            image_name = 'modules/' + source_name + '/' + MODULE_NAME
            write(package / 'helper/render_core.inc', archived(archive, members, core_name))
            image = archived(archive, members, image_name)
            assert digest(image) == metadata['module']['sha256']
            write(WORK / 'modules' / (name + '.vdpl'), image)
            modules[name] = dict(module_sha256=digest(image), module_bytes=len(image),
                                 package=str(package.relative_to(HERE)),
                                 target=str((WORK / 'modules' / (name + '.vdpl')).relative_to(HERE)),
                                 source_kind='preserved road helper', source_name=source_name,
                                 source_archive=str((PACED / 'CANDIDATES.zip').relative_to(CUSTOM)),
                                 source_archive_sha256=manifest['sha256'],
                                 source_target_member=image_name, bitmap_format=None, sampler=False,
                                 text_bytes=metadata['module']['resident_text_bytes'],
                                 data_bytes=metadata['module']['resident_data_bytes'])
    span_build = json.loads((CUSTOM / 'throughput/span-BUILD.json').read_text())
    archive, manifest, members = verified_archive(CUSTOM / 'throughput/span-PACKAGE.zip', CUSTOM / 'throughput/span-PACKAGE.json')
    with archive:
        image_name = 'target/' + MODULE_NAME
        image = archived(archive, members, image_name)
        assert digest(image) == span_build['module']['sha256']
        for name, bitmap_format in (('span-rgba', 1), ('span-native', 3)):
            package = WORK / 'packages' / name
            archive_package(archive, members, 'package/', package)
            write(WORK / 'modules' / (name + '.vdpl'), image)
            modules[name] = dict(module_sha256=digest(image), module_bytes=len(image),
                                 package=str(package.relative_to(HERE)),
                                 target=str((WORK / 'modules' / (name + '.vdpl')).relative_to(HERE)),
                                 source_kind='resident span bitmap', source_archive='throughput/span-PACKAGE.zip',
                                 source_archive_sha256=manifest['sha256'], source_target_member=image_name,
                                 bitmap_format=bitmap_format, sampler=False,
                                 text_bytes=span_build['module']['resident_text_bytes'],
                                 data_bytes=span_build['module']['resident_data_bytes'])
    for name, directory in (('additive', INC / 'sprites'), ('word-fill', INC / 'wide-fill')):
        archive, manifest, members = verified_archive(directory / 'PORTABLE.zip', directory / 'PACKAGE.json')
        with archive:
            package = WORK / 'packages' / name
            archive_package(archive, members, 'source/candidate/', package)
            image_name = 'target/candidate/' + MODULE_NAME
            image = archived(archive, members, image_name)
            qualified = (manifest['qualified_targets']['candidate'] if name == 'additive'
                         else json.loads((directory / 'BUILD.json').read_text())['module'])
            assert digest(image) == qualified['sha256']
            write(WORK / 'modules' / (name + '.vdpl'), image)
            modules[name] = dict(module_sha256=digest(image), module_bytes=len(image),
                                 package=str(package.relative_to(HERE)),
                                 target=str((WORK / 'modules' / (name + '.vdpl')).relative_to(HERE)),
                                 source_kind='additive actor sampler' if name == 'additive' else 'rejected aligned word fill',
                                 source_archive=str((directory / 'PORTABLE.zip').relative_to(CUSTOM)),
                                 source_archive_sha256=manifest['sha256'], source_target_member=image_name,
                                 bitmap_format=3, sampler=True,
                                 text_bytes=qualified['resident_text_bytes'],
                                 data_bytes=qualified['resident_data_bytes'])
    modules['split-clear'] = dict(modules['span-native'], alias_of='span-native',
        alias_reason='Production presenter draws only required panorama/HUD regions; obsolete full-road clear is absent in every case')
    modules['static'] = dict(modules['additive'], alias_of='additive',
        alias_reason='Actual panorama and HUD page retention are common production behavior; flat-sky retention is invalid and omitted')
    order = ['baseline', 'float-tri-layered', 'integer-tri-layered', 'float-quad-layered',
             'integer-quad-layered', 'float-tri-strips', 'integer-tri-strips',
             'float-quad-strips', 'integer-quad-strips', 'integer-quad-segments',
             'float-quad-segments', 'span-rgba', 'span-native', 'split-clear',
             'additive', 'word-fill', 'static']
    assert set(modules) == set(order) and len(order) == 17
    for value in modules.values():
        package = HERE / value['package']
        assert sha(package / 'native.c') == NATIVE_C_SHA
        assert (package / 'interface.json').read_bytes() == (baseline_package / 'interface.json').read_bytes()
        assert (package / 'backends.json').read_bytes() == (baseline_package / 'backends.json').read_bytes()
    result = dict(schema=1, order=order, variants={name: modules[name] for name in order},
                  generated_native_c_sha256=NATIVE_C_SHA, frozen_abi=True,
                  original_modules_unchanged=True, compiler_sdk_firmware_changed=False,
                  production_presentation_common=True,
                  aliases={'split-clear': 'span-native', 'static': 'additive'},
                  obsolete_flat_sky_optimization_removed=True)
    save('VARIANTS.json', result)
    return result


def validate_bindings():
    interface = json.loads((PACED / 'control/package/interface.json').read_text())
    backends = json.loads((PACED / 'control/package/backends.json').read_text())
    fields = {field['name']: field for field in interface['globals']}
    entries = {entry['name']: entry['logical_id'] for entry in interface['entries']}
    text = (HERE / 'bindings.hpp').read_text()
    constants = dict(Root=interface['state_buffer'], RootBytes=interface['state_bytes'],
                     Args=backends['native_arguments'], Staging=50305, Completion=50304,
                     Init=entries['InitRace'], Tick=entries['Tick120'], Render=entries['Render30'],
                     Stop=entries['StopRace'], TickWrapper=backends['native_wrappers'][entries['Tick120']],
                     HandleOffset=backends['native_handle_offset'], PlayerStation=fields['playerStation']['offset'],
                     PlayerLateral=fields['playerLateral']['offset'], RenderPhase=fields['renderPhase']['offset'],
                     RenderSteering=fields['renderSteering']['offset'], RenderFlags=fields['renderFlags']['offset'],
                     RenderRequest=fields['renderRequest']['offset'], PlayerUnwrapped=fields['playerUnwrapped']['offset'],
                     WorldTick=fields['worldTick']['offset'], FrameCount=FRAMES, WrapperCount=len(backends['native_wrappers']),
                     StateBytes=interface['state_bytes'] + sum(array['bytes'] for array in interface['arrays'] if array['access'] == 3),
                     PositionBuffer=4, LateralBuffer=5, SpanBuffer=50700, SamplerFirst=50710)
    for key, value in constants.items():
        assert f'constexpr uint32_t {key}={value};' in text, ('Bindings mismatch', key)
    buffers = [dict(id=interface['state_buffer'], offset=0, bytes=interface['state_bytes'])]
    buffers += [dict(id=array['buffer'], offset=array['offset'], bytes=array['bytes'])
                for array in interface['arrays'] if array['access'] == 3]
    abi = dict(schema=1, interface=interface, state_buffers=buffers,
               field_map={field['name']: dict(offset=field['offset'], bytes=field['bytes'], type=field['type'])
                          for field in interface['globals']},
               state_bytes=sum(buffer['bytes'] for buffer in buffers),
               interface_sha256=sha(PACED / 'control/package/interface.json'),
               backends_sha256=sha(PACED / 'control/package/backends.json'))
    save('ABI.json', abi)
    return dict(constants=constants, state_buffers=buffers, header_sha256=sha(HERE / 'bindings.hpp'),
                interface_sha256=sha(PACED / 'control/package/interface.json'),
                backends_sha256=sha(PACED / 'control/package/backends.json'))


def build(frames=900, only=None):
    variants = prepare_sources()
    bindings = validate_bindings()
    abi = json.loads((HERE / 'ABI.json').read_text())
    for name in COMMON_NAMES:
        assert (PRESENTATION / name).is_file(), ('Build the shared production guest first', name)
    shared_motion = INC / 'sprites/motion-comparison/fixtures/additive/motion.bin'
    accepted = json.loads((INC / 'sprites/motion-comparison/fixtures/additive/expected.json').read_text())
    assert sha(shared_motion) == accepted['files']['motion.bin'] and shared_motion.stat().st_size == FRAMES * 24
    common = (PACED / 'control/fixture/common.vdu').read_bytes()
    assets = (PACED / 'control/fixture/assets.vdu').read_bytes()
    native_base = (PACED / 'control/fixture/native.vdu').read_bytes()
    # Independently reproduce the accepted resource creation bytes.
    span_native = native_base + road_setup(3)
    assert digest(span_native) == '911f0067cb200f951841a52278ae1bc5a84de58618c08cde5f2beaf989c1bc78'
    additive_native = span_native + sampler_setup()
    assert digest(additive_native) == accepted['files']['native.vdu']
    firmware = PACED / 'control/fixture/vdp_rally.bin'
    assert sha(firmware) == FIRMWARE_SHA
    if frames == 900:
        final_station = accepted['player_final_station']
        final_positions = accepted['final_scripted_positions']
    else:
        reference = json.loads((HERE / ('EXPECTED-FINAL-' + str(frames) + '.json')).read_text())
        final_station = struct.unpack_from('<I', bytes.fromhex(reference['1']), 198)[0]
        final_positions = list(struct.unpack('<6I', bytes.fromhex(reference['4'])))
    order = [name for name in variants['order'] if only is None or name in only]
    assert order and (only is None or set(order) == set(only))
    suffix = '' if frames == 900 else '-smoke' + str(frames)
    fixture_root = HERE / ('fixtures' + suffix)
    registry = {}
    for name in order:
        variant = variants['variants'][name]
        target = fixture_root / name
        module = (HERE / variant['target']).read_bytes()
        assert digest(module) == variant['module_sha256']
        native = native_base
        if variant['bitmap_format'] is not None:
            native += road_setup(variant['bitmap_format'])
        if variant['sampler']:
            native += sampler_setup()
        config = CONFIG_MAGIC + struct.pack('<HHIHH', CONFIG_SCHEMA, frames, len(module), 0, 0)
        assert len(config) == 16
        files = dict(common={'common.vdu': common, 'assets.vdu': assets,
                             'motion.bin': shared_motion.read_bytes()},
                     variant={'native.vdu': native, 'module.vdu': buffer_file(50305, module),
                              'config.bin': config})
        for group in files.values():
            for filename, data in group.items():
                write(target / filename, data)
        for filename in COMMON_NAMES:
            write(target / filename, (PRESENTATION / filename).read_bytes())
        metadata = dict(schema=1, frames=frames, physics_ticks=frames * 4, warm_frames=2,
                        paced=False, completion_fenced=True, common_guest=True, candidate=name,
                        module_sha256=variant['module_sha256'], module_bytes=len(module),
                        native_source_sha256=NATIVE_C_SHA, mos_tick_hz=120,
                        prt_cycles_per_tick=18432, firmware_sha256=FIRMWARE_SHA,
                        config_format='16-byte little endian: 4s magic R28F,u16 schema1,u16 frames,u32 module bytes,u16 flags0,u16 reserved0',
                        bitmap_format=variant['bitmap_format'], additive_sampler=variant['sampler'],
                        alias_of=variant.get('alias_of'), alias_reason=variant.get('alias_reason'),
                        player_final_station=final_station,
                        final_scripted_positions=final_positions,
                        fixed_display_lanes=accepted['fixed_display_lanes'],
                        expected_render_requests=frames + 2,
                        expected_native_generation=1 + frames * 5 + 2,
                        expected_native_world_ticks=frames * 4,
                        interface=abi['interface'], state_buffers=abi['state_buffers'],
                        state_bytes=abi['state_bytes'], interface_sha256=abi['interface_sha256'],
                        presentation='Maintained actual racing panorama,HUD/footer,font,engine workload; no diagnostic title or menu',
                        clear_policy='Production page-aware panorama restoration and HUD caching shared by every case',
                        timing_scope='Full-race eZ80 presentation, native physics/geometry/drawing, commands/backpressure, stock swap and post-swap checked completion; no physical scanout claim',
                        files={path.name: sha(path) for path in sorted(target.iterdir())
                               if path.is_file() and path.name != 'expected.json'})
        write(target / 'expected.json', (json.dumps(metadata, indent=2) + '\n').encode())
        registry[name] = dict(directory=str(target.relative_to(HERE)),
                              files={path.name: sha(path) for path in sorted(target.iterdir()) if path.is_file()},
                              module_sha256=variant['module_sha256'], diagnostic=False,
                              foreground_paced=False, alias_of=variant.get('alias_of'))
    common_names = (*COMMON_NAMES, 'assets.vdu', 'common.vdu', 'motion.bin')
    for filename in common_names:
        assert len({entry['files'][filename] for entry in registry.values()}) == 1, filename
    alias_proof = {}
    for alias, original in variants['aliases'].items():
        if alias not in registry or original not in registry:
            continue
        a, b = registry[alias]['files'], registry[original]['files']
        differences = [filename for filename in a if a[filename] != b[filename]]
        assert differences == ['expected.json'], (alias, differences)
        alias_proof[alias] = dict(original=original, all_guest_inputs_byte_identical=True,
                                 differences= differences, measured_noop_not_speedup=True)
    save('FIXTURES' + suffix + '.json', registry)
    if frames == 60:
        save('SMOKE-FIXTURES.json', registry)
    save('BUILD-PROOF' + suffix + '.json', dict(schema=1, frames=frames, physics_ticks=frames * 4,
        variants=len(registry), order=order, shared_files=common_names,
        shared_hashes={name: registry[order[0]]['files'][name] for name in common_names},
        aliases=alias_proof, bindings=bindings, native_modules_unchanged=True,
        source_generated_c_sha256=NATIVE_C_SHA, firmware_sha256=FIRMWARE_SHA,
        real_scrolling_panorama_restored=True, production_hud_page_caching_common=True,
        all_config_flags_zero=True, module_load_before_large_artwork=True,
        emulator_launched=False, new_performance_claim=False))
    print('Prepared', len(registry), 'complete-race cases:', frames, 'frames; one shared real guest.')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--sources-only', action='store_true')
    parser.add_argument('--frames', type=int, default=900)
    parser.add_argument('--only', nargs='+')
    arguments = parser.parse_args()
    assert 1 <= arguments.frames <= 900
    assert arguments.only is None or arguments.frames < 900
    if arguments.sources_only:
        result = prepare_sources()
        validate_bindings()
        print('Prepared frozen modules/source packages:', len(result['order']))
    else:
        build(arguments.frames, arguments.only)
