"""Preserve the static-drawing experiment after results and review preparation.

Run explicitly; importing does not package anything. Only new PORTABLE.zip and
PACKAGE.json outputs are written. Every selected input is hash-frozen, archive
paths are relative, and ZIP CRC/SHA256/readback checks precede publication.
Historical absolute provenance strings inside original reports are preserved.
"""
from pathlib import Path, PurePosixPath
import hashlib
import io
import json
import shutil
import tempfile
import zipfile

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[5]
PRIOR = HERE.parent / 'wide-fill'
MODULE_SHA256 = '310779643769adde8413b93ea282115990dfebfe873e3395ac5545ac9d506702'
FIRMWARE_SHA256 = '8da2ebfdfa3b5b00f4a1929ad4885c838845b160f570259792ef370b69d4f473'
SKIP_PARTS = {'.work', '.git', '__pycache__', '.cache', '.pytest_cache'}
OUTPUT_NAMES = {'PORTABLE.zip', 'PACKAGE.json'}
REQUIRED_LOCAL = ('RESULTS.json', 'RESULTS.md', 'STATIC-REVIEW.json',
                  'PAGE-PROOF.json', 'PAGE-PROOF.md', 'BUILD-PROOF.json',
                  'FIXTURES.json', 'CAPTURE-FIXTURES.json', 'RAW-AUDIT.json',
                  'CAPTURE-RESULTS.json', 'HUMAN-REVIEW.md')

ARCHIVE_README = '''# Preserved two-page static-drawing experiment

This archive contains the accepted additive-sampler/byte-fill control and a
tape-only candidate that initializes static title/sky/lower-strip pixels on both
display pages, then restores only the sky rows that moving actors can touch.
The native module, original full-size artwork, generated physics, motion table,
driver, resource allocations, firmware, frame swaps and completion fences are
unchanged. Consult RESULTS.md/RESULTS.json for measured whole-frame results.

1. fixtures/control and fixtures/static are the exact900-frame benchmark input
   sets. Both embed the same authoritative target/control/rally-render.vdpl.
   source/control is the corresponding accepted source package. Inherited old
   rally-render.* delivery artifacts are omitted from source/control; only
   target/control contains the actual accepted module/ELF/object/disassembly/
   stack and compiler metadata. No new native compilation was performed.
2. captures/ contains separate30/31-frame scene-hold diagnostics and raw returns.
   Their hold and deliberate interruption are excluded from benchmark timing.
   A successful capture does not qualify game cleanup; the completed900-frame
   benchmark runs own final-state/timer/StopRace/UNLOAD/MOS-return evidence.
3. All local experiment tools, reports, fixture registries, scene diagnostics and
   raw returned evidence are preserved recursively. EXPERIMENT-README.md is the
   repository overview. Direct .work trees, caches, host .so libraries and
   symlinks are excluded. runner/ retains the selected pinned shared runner and
   the exact reused motion-control runner. No new emulator is included.
4. The shared source, authoritative target and firmware/vdp_rally.bin are copied
   unchanged from the verified prior wider-fill archive's CONTROL, never its
   rejected wider-fill candidate. IDENTITY.json gives portable relative paths.
   Exact original reports may contain historical absolute provenance strings;
   those are evidence, not portable path instructions. Rebuilding/running tools
   still requires the pinned repository toolchain, SDK and emulator environment.
5. SHA256SUMS hashes every other member. External PACKAGE.json also hashes that
   file and records CRC/readback checks and selected-input preservation.

The candidate is preserved for Author visual review and is not adopted by this
archive. Hardware has not been tested. Preservation does not authorize another
emulator run, physical deployment or publication.
'''


def digest(data):
    return hashlib.sha256(data).hexdigest()


def encoded(value):
    return (json.dumps(value, indent=2, sort_keys=True) + '\n').encode()


def key(name):
    p = PurePosixPath(name)
    assert name and not p.is_absolute() and '\\' not in name, name
    assert not any(part in ('.', '..', *SKIP_PARTS) for part in p.parts), name
    assert p.as_posix() == name and not name.endswith('/'), name
    return name


def excluded(relative):
    return (any(part in SKIP_PARTS for part in relative.parts)
            or relative.suffix in ('.so', '.pyc', '.pyo')
            or '.so.' in relative.name)


def ordinary_file(path):
    assert path.is_relative_to(ROOT), path
    for part in (path, *path.parents):
        assert not part.is_symlink(), ('symlink is not portable input', part)
        if part == ROOT:
            break
    assert path.is_file(), path


def collect(members, snapshots, path, name):
    ordinary_file(path)
    name = key(name)
    assert not excluded(PurePosixPath(name)), name
    data = path.read_bytes()
    assert name not in members, ('duplicate archive member', name)
    members[name] = data
    snapshots[path] = digest(data)


def local_tree(members, snapshots):
    for path in sorted(HERE.rglob('*')):
        relative = path.relative_to(HERE)
        if excluded(relative) or (relative.parent == Path('.') and path.name in OUTPUT_NAMES):
            continue
        assert not path.is_symlink(), ('symlink in selected local tree', path)
        if path.is_file():
            name = 'EXPERIMENT-README.md' if relative.as_posix() == 'README.md' else relative.as_posix()
            collect(members, snapshots, path, name)


def prior_control(members, snapshots):
    """Read only qualified control source/target, unchanged firmware and runner."""
    manifest_path, archive_path = PRIOR / 'PACKAGE.json', PRIOR / 'PORTABLE.zip'
    ordinary_file(manifest_path)
    ordinary_file(archive_path)
    manifest_bytes = manifest_path.read_bytes()
    archive_bytes = archive_path.read_bytes()
    prior = json.loads(manifest_bytes)
    assert digest(archive_bytes) == prior['sha256'], 'Prior archive identity changed'
    snapshots[manifest_path] = digest(manifest_bytes)
    snapshots[archive_path] = digest(archive_bytes)
    selected = {}
    with zipfile.ZipFile(io.BytesIO(archive_bytes)) as archive:
        assert archive.testzip() is None, 'Prior archive CRC failure'
        assert len(archive.namelist()) == len(set(archive.namelist()))
        for name in sorted(archive.namelist()):
            if not (name.startswith(('source/control/', 'target/control/', 'runner/'))
                    or name == 'firmware/vdp_rally.bin'):
                continue
            key(name)
            assert not excluded(PurePosixPath(name)), name
            relative = PurePosixPath(name).relative_to('source/control') if name.startswith('source/control/') else None
            if relative is not None and relative.parent == PurePosixPath('.') and relative.name.startswith('rally-render.'):
                continue
            assert name not in members, ('duplicate imported member', name)
            data = archive.read(name)
            assert digest(data) == prior['members'][name], ('Prior member identity', name)
            members[name] = data
            selected[name] = digest(data)
    assert digest(members['target/control/rally-render.vdpl']) == MODULE_SHA256
    assert digest(members['firmware/vdp_rally.bin']) == FIRMWARE_SHA256
    for required in ('source/control/native.c', 'source/control/helper/render_core.inc',
                     'source/control/helper/sprite.inc', 'target/control/rally-render.elf',
                     'target/control/rally-render.disassembly.txt', 'runner/support/run_headless.py'):
        assert required in selected, required
    target = json.loads(members['target/control/rally-render.json'])['module']
    assert target['sha256'] == MODULE_SHA256
    pins = json.loads(members['runner/RUNNER-PINS.json'])
    for name, expected in pins.items():
        assert digest(members['runner/support/' + name]) == expected, ('Imported runner pin', name)
    reused = HERE.parent / 'sprites/motion-comparison/control.py'
    assert digest(reused.read_bytes()) == 'fdcb090a9228bcc2f3a209551681ef4d34d21ed3e746575ac44301a2fe8e52f2'
    collect(members, snapshots, reused, 'runner/motion-comparison-control.py')
    members['provenance/wide-fill-PACKAGE.json'] = manifest_bytes
    return dict(archive='prior wide-fill/PORTABLE.zip', sha256=prior['sha256'],
                imported_members=selected, rejected_word_candidate_imported=False)


def check_fixtures(members, registry_name, directory_prefix=''):
    checked = {}
    for case, entry in sorted(json.loads(members[registry_name]).items()):
        directory = key(directory_prefix + entry['directory'])
        for name, expected in entry['files'].items():
            member = key(directory + '/' + name)
            assert digest(members[member]) == expected, ('Fixture identity', member)
        assert entry['module_sha256'] == MODULE_SHA256
        script = members[directory + '/script.bin']
        assert script.count(members['target/control/rally-render.vdpl']) == 1, ('Embedded module', case)
        checked[case] = dict(directory=directory, module='target/control/rally-render.vdpl',
                             module_sha256=MODULE_SHA256, registered_hashes_verified=True,
                             embedded_module_exact=True)
    return checked


def preserve():
    for name in OUTPUT_NAMES:
        assert not (HERE / name).exists(), ('Preserve prior output', name)
    for name in REQUIRED_LOCAL:
        ordinary_file(HERE / name)
    assert (HERE / 'evidence').is_dir(), 'Whole-frame raw evidence is not ready'
    assert (HERE / 'captures/evidence').is_dir(), 'Scene-capture raw evidence is not ready'
    members, snapshots = {}, {}
    local_tree(members, snapshots)
    prior = prior_control(members, snapshots)
    fixtures = check_fixtures(members, 'FIXTURES.json')
    captures = check_fixtures(members, 'CAPTURE-FIXTURES.json')
    if 'captures/FIXTURES.json' in members:
        check_fixtures(members, 'captures/FIXTURES.json', 'captures/')
    assert set(fixtures) == {'control', 'static'}
    assert len(captures) == 4
    proof = json.loads(members['BUILD-PROOF.json'])
    assert proof['module_sha256'] == MODULE_SHA256
    assert proof['module_driver_artwork_motion_physics_generated_outputs_unchanged']
    review = json.loads(members['STATIC-REVIEW.json'])
    assert review['passed']
    assert json.loads(members['RAW-AUDIT.json'])['passed']
    assert json.loads(members['PAGE-PROOF.json'])['passed']
    results = json.loads(members['RESULTS.json'])
    assert results['same_native_module_driver_assets_motion_runtime']
    assert results['full_final_worlds_exact'] and not results['hardware_tested']
    for name, data in members.items():
        if PurePosixPath(name).name.startswith('PROFILES-') and name.endswith('.json'):
            for entry in json.loads(data).values():
                assert entry['input_sha256']['esp32-firmware.bin'] == FIRMWARE_SHA256, name
    identity = dict(schema=1, task='INC-001-04', checkpoint='aab566d',
                    candidate_promoted=False, human_visual_review_pending=True, hardware_tested=False,
                    disposition='Tape-only static-page candidate preserved for Author review; accepted additive sampler/byte-fill module unchanged',
                    source='source/control', shared_target='target/control',
                    qualified_whole_frame_fixtures=fixtures, diagnostic_scene_hold_fixtures=captures,
                    firmware=dict(path='firmware/vdp_rally.bin', sha256=FIRMWARE_SHA256),
                    prior_control=prior,
                    whole_frame=dict(nominal_mos_gain_percent=results['nominal_mos_gain_percent'],
                                     nominal_prt_gain_percent=results['nominal_prt_gain_percent'],
                                     pairs=results['pairs']),
                    raw_evidence_roots=['evidence', 'captures/evidence'],
                    capture_limit='Deliberate interruption during hold; excluded timing and no cleanup qualification',
                    source_paths='Relative archive paths; original reports retain historical absolute provenance strings',
                    excluded='Direct .work trees, inherited source-package rally-render.* artifacts, symlinks, .git, caches and host .so libraries')
    assert 'IDENTITY.json' not in members and 'README.md' not in members
    members['IDENTITY.json'] = encoded(identity)
    members['README.md'] = ARCHIVE_README.encode()
    hashes = {name: digest(data) for name, data in sorted(members.items())}
    assert 'SHA256SUMS' not in members
    members['SHA256SUMS'] = ''.join(expected + '  ' + name + '\n' for name, expected in hashes.items()).encode()
    hashes['SHA256SUMS'] = digest(members['SHA256SUMS'])
    assert all(key(name) == name and not excluded(PurePosixPath(name)) for name in members)
    with tempfile.TemporaryDirectory(prefix='rally28-static-drawing-', dir='/tmp') as temporary:
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
                        candidate_promoted=False, human_visual_review_pending=True, hardware_tested=False,
                        qualified_targets=fixtures, diagnostic_captures=captures,
                        unchanged_module_sha256=MODULE_SHA256, unchanged_firmware_sha256=FIRMWARE_SHA256,
                        prior_control_archive_sha256=prior['sha256'],
                        preservation_tool_sha256=digest(members['package.py']),
                        excluded_source_build_artifacts=True, direct_work_trees_or_symlinks_in_archive=False,
                        raw_evidence_members=sum(name.startswith(('evidence/', 'captures/evidence/')) for name in members))
        shutil.copyfile(output, HERE / 'PORTABLE.zip')
        (HERE / 'PACKAGE.json').write_bytes(encoded(manifest))
    with zipfile.ZipFile(HERE / 'PORTABLE.zip') as archive:
        assert archive.testzip() is None
        assert {name: digest(archive.read(name)) for name in archive.namelist()} == hashes
    print(json.dumps(dict(archive='PORTABLE.zip', sha256=manifest['sha256'], bytes=manifest['bytes'],
                          members=len(hashes), raw_evidence_members=manifest['raw_evidence_members']), indent=2))


if __name__ == '__main__':
    preserve()
