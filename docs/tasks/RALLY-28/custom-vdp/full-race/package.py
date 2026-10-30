"""Preserve complete-race inputs, original modules, sources and raw results.

Importing is inert. Run only after final reports/captures/raw audit are ready.
Only new PORTABLE.zip and PACKAGE.json are written; all selected input hashes
must remain unchanged throughout ZIP creation and CRC/SHA256/readback checks.
"""
from pathlib import Path, PurePosixPath
import hashlib
import io
import json
import shutil
import struct
import tempfile
import zipfile

HERE = Path(__file__).resolve().parent
CUSTOM = HERE.parent
ROOT = HERE.parents[4]
WORK = HERE / '.work'
SKIP_PARTS = {'.work', '.git', '__pycache__', '.cache', '.pytest_cache'}
OUTPUT_NAMES = {'PORTABLE.zip', 'PACKAGE.json'}
FIRMWARE_SHA256 = '8da2ebfdfa3b5b00f4a1929ad4885c838845b160f570259792ef370b69d4f473'
FINAL_GUEST_SHA256 = '33116db786ef08033a3c5aa3404a7d5ed8411013af9b70ac27051ddd1ade53e9'
NATIVE_C_SHA256 = '94d92d109f9b3b93e8ddfea1427edcdeb9059a87636a6bacfd93d3c3894a1992'
REQUIRED = ('RESULTS.json', 'RESULTS.md', 'RAW-AUDIT.json', 'CAPTURE-RESULTS.json',
            'CAPTURE-RESULTS.md', 'HUMAN-REVIEW.md', 'VARIANTS.json', 'FIXTURES.json',
            'BUILD-PROOF.json', 'GUEST-BUILD.json', 'STATE-PROOF-900.json',
            'COMPARISON-SELECTION.json', 'selection.py', 'finish_control.py')

ARCHIVE_README = '''# Preserved complete-race comparison

All17 named cases execute the same real eZ80 racing presentation: panorama
scrolling/repair, moving traffic, signs, player, finish, HUD/footer and engine
commands. The34-run forward/reverse comparison preserves each original native
renderer module and includes transport, backpressure, swaps and ordered frame
completion. RESULTS.md/RESULTS.json own measured whole-race results; historical
flat-background gains are not pooled or presented as complete-race gains.

1. fixtures/ contains all17 exact input sets. source/ contains15 actual source
   packages and target/ contains their authoritative frozen native modules.
   IDENTITIES.json maps split-clear to span-native and static to additive:
   these are input-identical compatibility aliases, not separate optimizations.
   Available authoritative target siblings are preserved from their original
   qualified archives. Missing road ELF/disassembly files are not invented;
   the road archive supplied module images and corresponding helper cores.
2. Inherited rally-render.* build artifacts are omitted from source/ because
   they describe an older compiler delivery. Only target/ holds authoritative
   renderer artifacts. Native source/modules remain unchanged; the real eZ80
   guest is newly compiled from the maintained production presentation and
   admits the module before mode136 and large artwork allocations.
3. guest/, presentation/, production/ and presentation-source/ preserve the
   actual guest, asset loaders, extracted presentation functions, maintained
   source/headers and exact artwork/stream inputs. GUEST-BUILD.json pins them.
   firmware/vdp_rally.bin and runner/ are unchanged qualified prior inputs.
   No new firmware, native compiler or SDK modification is included.
4. captures/ and any coverage diagnostics are separate from throughput. Their
   scene holds deliberately stop after a completed-frame fence; interrupted
   captures do not qualify game cleanup. The full runs and completed coverage
   own timer/StopRace/UNLOAD/clean MOS-return evidence. Raw failures and prior
   preparation archives remain preserved and excluded as reports describe.
5. Every local report/tool/input/raw return is preserved except direct .work
   trees, caches, host .so libraries and symlinks. SHA256SUMS covers every other
   archive member. PACKAGE.json also hashes that file and records CRC/readback
   validation and unchanged selected inputs. Original report/build strings may
   contain historical absolute provenance paths; they are not portable launch
   instructions. Reproduction still needs the pinned repository environment.

COMPARISON-SELECTION.json pins two logical 17-case orders to unchanged original
campaign/case receipts: 29 successful runs before the external boost interruption
and five finishing runs under a new guard. The interrupted run is excluded.
RESULTS.json lists all 34 source references. There are no synthetic campaign
copies. Only executable-identical baseline/native/additive replicas are pooled;
the observed repeat range limits interpretation of small wider-fill differences.
The accepted additive sampler with byte fills remains the reference.

Author moving visual review remains pending. Hardware has not been tested, and
packaging does not promote a candidate, authorize another emulator run, physical
deployment or publication.
'''


def digest(data):
    return hashlib.sha256(data).hexdigest()


def encoded(value):
    return (json.dumps(value, indent=2, sort_keys=True) + '\n').encode()


def key(name):
    path = PurePosixPath(name)
    assert name and not path.is_absolute() and '\\' not in name, name
    assert not any(part in ('.', '..', *SKIP_PARTS) for part in path.parts), name
    assert path.as_posix() == name and not name.endswith('/'), name
    return name


def excluded(relative):
    return (any(part in SKIP_PARTS for part in relative.parts)
            or relative.suffix in ('.so', '.pyc', '.pyo') or '.so.' in relative.name)


def ordinary_file(path):
    assert path.is_relative_to(ROOT), path
    for part in (path, *path.parents):
        assert not part.is_symlink(), ('Symlink is not a preservation input', part)
        if part == ROOT:
            break
    assert path.is_file(), path


def add(members, name, data):
    name = key(name)
    assert not excluded(PurePosixPath(name)), name
    if name in members:
        assert members[name] == data, ('Conflicting archive member', name)
    else:
        members[name] = data


def collect(members, snapshots, path, name, expected=None):
    ordinary_file(path)
    data = path.read_bytes()
    if expected is not None:
        assert digest(data) == expected, ('Selected source identity', path)
    add(members, name, data)
    snapshots[path] = digest(data)


def tree(members, snapshots, path, prefix, source_package=False):
    assert path.is_dir() and not path.is_symlink(), path
    count = 0
    for item in sorted(path.rglob('*')):
        relative = item.relative_to(path)
        if excluded(relative):
            continue
        assert not item.is_symlink(), ('Symlink in selected tree', item)
        if not item.is_file():
            continue
        if source_package and relative.parent == Path('.') and item.name.startswith('rally-render.'):
            continue
        collect(members, snapshots, item, prefix + '/' + relative.as_posix())
        count += 1
    assert count, path


def local_tree(members, snapshots):
    for item in sorted(HERE.rglob('*')):
        relative = item.relative_to(HERE)
        if excluded(relative) or (relative.parent == Path('.') and item.name in OUTPUT_NAMES):
            continue
        assert not item.is_symlink(), ('Symlink in selected local tree', item)
        if item.is_file():
            name = 'EXPERIMENT-README.md' if relative.as_posix() == 'README.md' else relative.as_posix()
            collect(members, snapshots, item, name)


def open_verified(path, manifest_path, snapshots):
    ordinary_file(path)
    ordinary_file(manifest_path)
    data, manifest_data = path.read_bytes(), manifest_path.read_bytes()
    manifest = json.loads(manifest_data)
    assert digest(data) == manifest.get('sha256', manifest.get('archive_sha256')), path
    pins = manifest.get('members')
    # The older span manifest stores its member count under "members" and the
    # actual filename/hash map under "member_sha256".
    if not isinstance(pins, dict):
        pins = manifest.get('member_sha256')
    assert isinstance(pins, dict), manifest_path
    archive = zipfile.ZipFile(io.BytesIO(data))
    assert archive.testzip() is None
    assert len(archive.namelist()) == len(set(archive.namelist()))
    snapshots[path], snapshots[manifest_path] = digest(data), digest(manifest_data)
    return archive, manifest, pins


def archived(archive, pins, name):
    key(name)
    data = archive.read(name)
    assert digest(data) == pins[name], ('Prior archive member identity', name)
    return data


def preserved_modules(members, snapshots):
    variants = json.loads(members['VARIANTS.json'])
    assert len(variants['order']) == len(variants['variants']) == 17
    assert variants['aliases'] == {'split-clear': 'span-native', 'static': 'additive'}
    assert variants['generated_native_c_sha256'] == NATIVE_C_SHA256
    actual = {name: info for name, info in variants['variants'].items() if not info.get('alias_of')}
    assert len(actual) == 15
    frozen_path = CUSTOM / 'paced-road/CONTROL.json'
    ordinary_file(frozen_path)
    frozen_bytes = frozen_path.read_bytes()
    frozen = json.loads(frozen_bytes)['immutable_files']
    snapshots[frozen_path] = digest(frozen_bytes)
    archives = {}
    identities = {}
    manifest_names = {
        'paced-road/CANDIDATES.zip': 'paced-road/CANDIDATES-PACKAGE.json',
        'throughput/span-PACKAGE.zip': 'throughput/span-PACKAGE.json',
        'incremental/sprites/PORTABLE.zip': 'incremental/sprites/PACKAGE.json',
        'incremental/wide-fill/PORTABLE.zip': 'incremental/wide-fill/PACKAGE.json',
    }
    try:
        for name, info in actual.items():
            source_archive = info['source_archive']
            if source_archive not in archives:
                archives[source_archive] = open_verified(CUSTOM / source_archive,
                    CUSTOM / manifest_names[source_archive], snapshots)
            archive, manifest, pins = archives[source_archive]
            assert manifest.get('sha256', manifest.get('archive_sha256')) == info['source_archive_sha256']
            original_image = archived(archive, pins, info['source_target_member'])
            image_path = HERE / info['target']
            assert image_path.parent == WORK / 'modules' and image_path.name == name + '.vdpl'
            image_hash = digest(original_image)
            assert image_hash == info['module_sha256'] and len(original_image) == info['module_bytes']
            collect(members, snapshots, image_path, 'target/' + name + '/rally-render.vdpl', image_hash)
            package = HERE / info['package']
            assert package == WORK / 'packages' / name
            tree(members, snapshots, package, 'source/' + name, source_package=True)
            assert digest(members['source/' + name + '/native.c']) == NATIVE_C_SHA256
            checked_sources = {}
            for member, data in members.copy().items():
                prefix = 'source/' + name + '/'
                if not member.startswith(prefix):
                    continue
                relative = member.removeprefix(prefix)
                if source_archive == 'paced-road/CANDIDATES.zip':
                    if relative == 'helper/render_core.inc':
                        expected = digest(archived(archive, pins, 'modules/' + info['source_name'] + '/render_core.inc'))
                    else:
                        expected = frozen['control/package/' + relative]
                else:
                    prefix_old = 'package/' if source_archive.startswith('throughput/') else 'source/candidate/'
                    expected = digest(archived(archive, pins, prefix_old + relative))
                assert digest(data) == expected, ('Actual source package identity', name, relative)
                checked_sources[relative] = expected
            parent = PurePosixPath(info['source_target_member']).parent
            siblings = []
            for old_name in sorted(pins):
                old_path = PurePosixPath(old_name)
                if old_path.parent != parent or not old_path.name.startswith('rally-render.'):
                    continue
                data = archived(archive, pins, old_name)
                add(members, 'target/' + name + '/' + old_path.name, data)
                siblings.append(old_path.name)
            identities[name] = dict(source='source/' + name,
                target='target/' + name + '/rally-render.vdpl', module_sha256=image_hash,
                source_files=checked_sources, source_archive=source_archive,
                source_archive_sha256=info['source_archive_sha256'],
                authoritative_available_target_files=sorted(set(siblings + ['rally-render.vdpl'])))
    finally:
        for archive, _, _ in archives.values():
            archive.close()
    for alias, original in variants['aliases'].items():
        identities[alias] = dict(alias_of=original, source=identities[original]['source'],
            target=identities[original]['target'], module_sha256=identities[original]['module_sha256'],
            reason=variants['variants'][alias]['alias_reason'])
    return identities


def production_sources(members, snapshots):
    guest = json.loads(members['GUEST-BUILD.json'])
    guest_sha256 = guest['files']['probe.bin']
    assert guest_sha256 == FINAL_GUEST_SHA256, 'Final actor-clipping guest identity changed'
    assert guest['actual_ez80_per_frame_presentation'] and guest['race_phase'] == 'Race'
    assert not guest['diagnostic_title'] and not guest['attract_panel']
    for name, expected in guest['files'].items():
        assert digest(members['presentation/' + name]) == expected, ('Shared guest/artwork identity', name)
    for directory in ('rally-game/include', 'rally-production/include'):
        tree(members, snapshots, ROOT / directory, 'production/' + directory)
    for name, expected in guest['old_sources'].items():
        collect(members, snapshots, ROOT / name, 'production/' + name, expected)
    for source, destination, expected in (
        (WORK / 'presentation/include/presentation-functions.inc', 'presentation-source/presentation-functions.inc', guest['extracted_functions_sha256']),
        (WORK / 'presentation/artwork.cpp', 'presentation-source/artwork.cpp', guest['generated_asset_source_sha256']),
        (WORK / 'presentation/Makefile', 'presentation-source/Makefile', None),
    ):
        collect(members, snapshots, source, destination, expected)
    header = members['guest/native.hpp'].decode()
    setup = header[header.index('bool setup(){'):header.index('void startTimer()')]
    assert setup.index('handle=transaction(1,') < setup.index('vdp_mode(136)'), 'Guest must LOAD before mode136'
    main = members['guest/main.cpp'].decode()
    road_clip = 'viewport(stream,0,rally::RoadTop,319,239);flush();fs::command(fs::Outputs[0],1);'
    actor_clip = 'viewport(stream,0,HudHeight,319,223);flush();'
    assert main.count(road_clip) == main.count(actor_clip) == 2
    for part in main.split(road_clip)[1:]:
        assert part.index(actor_clip) < part.index('fs::command(fs::Outputs[1],1);')
    return dict(guest_sha256=guest_sha256, maintained_source_pins=guest['old_sources'],
                original_header_trees=['production/rally-game/include', 'production/rally-production/include'],
                native_LOAD_precedes_mode136=True, road_clip_then_actor_clip_preserved=True,
                original_full_size_artwork=True)


def firmware_and_runner(members, snapshots):
    directory = CUSTOM / 'incremental/wide-fill'
    archive, manifest, pins = open_verified(directory / 'PORTABLE.zip', directory / 'PACKAGE.json', snapshots)
    with archive:
        firmware = archived(archive, pins, 'firmware/vdp_rally.bin')
        assert digest(firmware) == FIRMWARE_SHA256
        add(members, 'firmware/vdp_rally.bin', firmware)
        for name in sorted(pins):
            if name.startswith('runner/'):
                add(members, name, archived(archive, pins, name))
    runner_pins = json.loads(members['runner/RUNNER-PINS.json'])
    for name, expected in runner_pins.items():
        assert digest(members['runner/support/' + name]) == expected
    for name in ('stage.py', 'oryx_session.py'):
        current = CUSTOM / 'throughput' / name
        ordinary_file(current)
        assert current.read_bytes() == members['runner/' + name], ('Shared runner changed', name)
        snapshots[current] = digest(current.read_bytes())
    return dict(path='firmware/vdp_rally.bin', sha256=FIRMWARE_SHA256,
                prior_archive='incremental/wide-fill/PORTABLE.zip', prior_archive_sha256=manifest['sha256'])


def fixture_checks(members, registry_name, identities, guest_sha256):
    result = {}
    for case, entry in json.loads(members[registry_name]).items():
        directory = key(entry['directory'])
        for filename, expected in entry['files'].items():
            member = key(directory + '/' + filename)
            assert digest(members[member]) == expected, ('Exact fixture input', member)
        source = entry.get('source_renderer', case)
        assert source in identities, (registry_name, case, source)
        identity = identities[source]
        image = members[identity['target']]
        module_vdu = members[directory + '/module.vdu']
        assert module_vdu.count(image) == 1, ('Module upload payload', case)
        marker = b'\x17\0\xa0' + struct.pack('<H', 50305)
        assert module_vdu == marker + b'\x02' + marker + b'\0' + struct.pack('<H', len(image)) + image
        assert entry['module_sha256'] == digest(image)
        config = members[directory + '/config.bin']
        magic, schema, frames, module_bytes, flags, reserved = struct.unpack('<4sHHIHH', config)
        assert (magic, schema, module_bytes, flags, reserved) == (b'R28F', 1, len(image), 0, 0)
        assert digest(members[directory + '/probe.bin']) == guest_sha256
        result[case] = dict(directory=directory, source_renderer=source,
            module=identity['target'], module_sha256=digest(image), frames=frames,
            exact_file_hashes_verified=True, actual_module_upload_verified=True,
            diagnostic=entry.get('diagnostic', False))
    return result


def comparison_checks(members, audit, results):
    """Keep the report and independent audit tied to original source receipts."""
    selector_name = 'COMPARISON-SELECTION.json'
    selected = json.loads(members[selector_name])
    selector_sha = digest(members[selector_name])
    assert selected['schema'] == 1
    assert audit['source_selection'] == selector_name
    assert audit['comparison_selection_sha256'] == selector_sha
    provenance = results['comparison_selection']
    assert provenance['path'] == selector_name and provenance['sha256'] == selector_sha
    assert provenance['source_receipts'] == selected['source_receipts']
    assert provenance['source_sessions'] == selected['source_sessions']
    order = list(json.loads(members['FIXTURES.json']))
    assert [row['case'] for row in selected['forward']] == order
    assert [row['case'] for row in selected['reverse']] == list(reversed(order))
    references = selected['forward'] + selected['reverse']
    assert len(references) == len({(row['campaign'], row['case']) for row in references}) == 34
    for name, expected in selected['source_receipts'].items():
        assert digest(members[key(name)]) == expected, ('Selected original receipt identity', name)
    named = results['named_runs']
    assert len(named) == 34
    audited = {(row['campaign'], row['case']): row for row in audit['whole_runs']}
    assert len(audited) == 34
    assert [(row['source_campaign'], row['source_case']) for row in named] == [
        (row['campaign'], row['case']) for row in references]
    for row in named:
        receipt_name = 'CAMPAIGN-' + row['source_campaign'] + '.json'
        assert receipt_name in selected['source_receipts']
        original = json.loads(members[receipt_name])[row['source_case']]
        assert original['passed'] and original['input_hashes_preserved'] and original['process_exit'] == 0
        assert row['source_session'] == selected['source_sessions'][row['source_campaign']]
        actual_directory = original.get('evidence_directory', 'evidence/' + row['source_campaign'] + '/' + row['source_case'])
        assert row['source_evidence_directory'] == actual_directory
        assert key(actual_directory) + '/run.json' in members
        raw = audited[(row['source_campaign'], row['source_case'])]
        assert (raw['frames'], raw['native_physics_ticks'], raw['raw_native_replies']) == (900, 3600, 5624)
        assert raw['evidence_directory'] == actual_directory
        assert not raw['timing_excluded']
        assert all(raw[field] for field in ('every_request_response_exact', 'retained_equals_all_raw_native',
            'full_final_root_and_arrays_exact', 'timer_vector_restore_guest_check', 'native_stop_unload_zero',
            'mode8_MOS_prompt_after_cleanup', 'backend_zero_errors'))
        assert raw['nominal_mos_units'] == row['nominal_mos_ticks']
        assert raw['nominal_prt_ticks'] == row['nominal_prt_ticks']
        assert raw['final_state_sha256'] == row['state_sha256']
        for name in ('frames', 'physics_ticks', 'nominal_mos_ticks', 'nominal_prt_ticks',
                     'nominal_mos_fps', 'nominal_prt_fps', 'state_sha256', 'timed_wire_bytes'):
            assert row[name] == original['result'][name], ('Named run source value', row['source_case'], name)
    counts = {campaign: sum(row['campaign'] == campaign for row in references)
              for campaign in dict.fromkeys(row['campaign'] for row in references)}
    assert counts == {'raceab03': 17, 'raceba03': 12, 'racefinish01': 5}
    groups = results['equivalent_replicate_groups']
    assert {name: group['runs'] for name, group in groups.items()} == {
        'baseline': 2, 'native_spans': 4, 'additive_sampler': 4}
    assert results['wider_fill']['adopted'] is False
    return dict(path=selector_name, sha256=selector_sha, source_receipts=selected['source_receipts'],
                source_sessions=selected['source_sessions'], selected_runs_by_campaign=counts,
                original_successful_runs_retained=29, new_finishing_runs=5,
                interrupted_attempt_excluded=True, synthetic_campaigns_or_raw_copies=False,
                all_named_report_rows_match_original_receipts=True)


def preserve():
    for name in OUTPUT_NAMES:
        assert not (HERE / name).exists(), ('Preserve earlier package', name)
    for name in REQUIRED:
        ordinary_file(HERE / name)
    assert (HERE / 'evidence').is_dir() and (HERE / 'captures').is_dir()
    members, snapshots = {}, {}
    local_tree(members, snapshots)
    audit, captures = json.loads(members['RAW-AUDIT.json']), json.loads(members['CAPTURE-RESULTS.json'])
    # RAW-AUDIT uses positive qualification fields, not a top-level passed flag.
    assert audit.get('passed', True) and audit.get('error') is None
    assert captures.get('passed') is True
    assert audit['whole_run_count'] == len(audit['whole_runs']) == 34 and audit['variants'] == 17
    assert audit['independent_of_builder_runner_and_verifier']
    assert audit['all_runtime_and_input_identities_exact']
    assert audit['full_timed_ez80_UART_identical_across_all34']
    results = json.loads(members['RESULTS.json'])
    assert results['completed_runs'] == 34 and results['variants'] == 17
    assert results['all_final_worlds_exact'] and not results['hardware_tested']
    comparison = comparison_checks(members, audit, results)
    guest_sha256 = json.loads(members['GUEST-BUILD.json'])['files']['probe.bin']
    assert guest_sha256 == FINAL_GUEST_SHA256
    assert results['guest_sha256'] == guest_sha256
    identities = preserved_modules(members, snapshots)
    production = production_sources(members, snapshots)
    firmware = firmware_and_runner(members, snapshots)
    registries = {}
    for name in sorted(members.copy()):
        if '/' not in name and (name == 'FIXTURES.json' or name.endswith('-FIXTURES.json') or name.startswith('FIXTURES-')):
            registries[name] = fixture_checks(members, name, identities, guest_sha256)
    assert len(registries['FIXTURES.json']) == 17
    registry = json.loads(members['FIXTURES.json'])
    variants = json.loads(members['VARIANTS.json'])
    for alias, original in variants['aliases'].items():
        left, right = registry[alias]['files'], registry[original]['files']
        assert set(left) == set(right)
        assert [name for name in left if left[name] != right[name]] == ['expected.json']
    for name, data in members.items():
        if PurePosixPath(name).name.startswith('PROFILES-') and name.endswith('.json'):
            for entry in json.loads(data).values():
                assert entry['input_sha256']['esp32-firmware.bin'] == FIRMWARE_SHA256, name
    identity = dict(schema=1, task='RACE-001', candidate_promoted=False,
                    human_visual_review_pending=True, hardware_tested=False,
                    actual_source_packages=15, named_comparison_cases=17,
                    variants=identities, fixture_registries=registries,
                    executable_aliases=variants['aliases'], firmware=firmware, production=production,
                    actual_guest='presentation/probe.bin', renderer_native_c_sha256=NATIVE_C_SHA256,
                    authoritative_module_bytes_unchanged=True, no_native_recompile=True,
                    whole_race_completed_runs=34, historical_flat_background_timings_pooled=False,
                    comparison_selection=comparison,
                    raw_evidence_roots=['evidence', 'captures'],
                    capture_limit='Scene-hold interruptions are excluded from timing and do not qualify cleanup',
                    paths='Relative archive paths; exact reports/Makefile retain historical absolute provenance strings',
                    excluded='Direct .work trees, caches, host .so libraries, symlinks and inherited source-package rally-render.* outputs')
    assert 'IDENTITIES.json' not in members and 'README.md' not in members
    members['IDENTITIES.json'] = encoded(identity)
    members['README.md'] = ARCHIVE_README.encode()
    hashes = {name: digest(data) for name, data in sorted(members.items())}
    assert 'SHA256SUMS' not in members
    members['SHA256SUMS'] = ''.join(expected + '  ' + name + '\n' for name, expected in hashes.items()).encode()
    hashes['SHA256SUMS'] = digest(members['SHA256SUMS'])
    assert all(key(name) == name and not excluded(PurePosixPath(name)) for name in members)
    with tempfile.TemporaryDirectory(prefix='rally28-full-race-', dir='/tmp') as temporary:
        output = Path(temporary) / 'PORTABLE.zip'
        with zipfile.ZipFile(output, 'w', compression=zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
            for name, data in sorted(members.items()):
                info = zipfile.ZipInfo(name, date_time=(1980, 1, 1, 0, 0, 0))
                info.create_system = 3
                info.external_attr = 0o100644 << 16
                archive.writestr(info, data, compress_type=zipfile.ZIP_DEFLATED, compresslevel=9)
        with zipfile.ZipFile(output) as archive:
            assert archive.testzip() is None
            assert len(archive.namelist()) == len(set(archive.namelist())) == len(hashes)
            assert {name: digest(archive.read(name)) for name in archive.namelist()} == hashes
        for path, expected in snapshots.items():
            ordinary_file(path)
            assert digest(path.read_bytes()) == expected, ('Selected input changed during preservation', path)
        manifest = dict(schema=1, archive='PORTABLE.zip', sha256=digest(output.read_bytes()),
                        bytes=output.stat().st_size, members=dict(sorted(hashes.items())),
                        zip_crc_verified=True, member_readbacks_verified=True,
                        embedded_SHA256SUMS_verified=True, selected_inputs_unchanged=True,
                        named_comparison_cases=17, actual_source_packages=15,
                        fixture_registries=registries, executable_aliases=variants['aliases'],
                        comparison_selection=comparison,
                        guest_sha256=guest_sha256, unchanged_firmware_sha256=FIRMWARE_SHA256,
                        authoritative_modules_unchanged=True, excluded_source_build_artifacts=True,
                        preservation_tool_sha256=digest(members['package.py']),
                        direct_work_trees_or_symlinks_in_archive=False,
                        candidate_promoted=False, human_visual_review_pending=True, hardware_tested=False,
                        raw_evidence_members=sum(name.startswith(('evidence/', 'captures/')) for name in members))
        shutil.copyfile(output, HERE / 'PORTABLE.zip')
        (HERE / 'PACKAGE.json').write_bytes(encoded(manifest))
    with zipfile.ZipFile(HERE / 'PORTABLE.zip') as archive:
        assert archive.testzip() is None
        assert {name: digest(archive.read(name)) for name in archive.namelist()} == hashes
    print(json.dumps(dict(archive='PORTABLE.zip', sha256=manifest['sha256'], bytes=manifest['bytes'],
                          members=len(hashes), raw_evidence_members=manifest['raw_evidence_members']), indent=2))


if __name__ == '__main__':
    preserve()
