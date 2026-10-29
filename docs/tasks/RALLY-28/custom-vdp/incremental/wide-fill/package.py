"""Preserve the wider-fill experiment without building, running or deploying it.

Run explicitly after documentation and phase preservation are complete. Only
PORTABLE.zip and PACKAGE.json are written; selected inputs must stay unchanged.
Archive paths are relative. Original report contents retain their provenance.
"""
from pathlib import Path, PurePosixPath
import hashlib
import json
import shutil
import tempfile
import zipfile

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[5]
SPRITES = HERE.parent / 'sprites'
THROUGHPUT = HERE.parents[1] / 'throughput'
FIRMWARE_SHA256 = '8da2ebfdfa3b5b00f4a1929ad4885c838845b160f570259792ef370b69d4f473'
CONTROL_SHA256 = '310779643769adde8413b93ea282115990dfebfe873e3395ac5545ac9d506702'
SKIP_PARTS = {'.git', '__pycache__', '.cache', '.pytest_cache'}
LOCAL_SUFFIXES = {'.py', '.c', '.h', '.inc', '.json', '.md', '.txt', '.bin'}

ARCHIVE_README = '''# Preserved wider road-fill experiment

This archive preserves the byte-fill control and the aligned-word candidate,
their exact moving fixtures, the separate isolated fill probe, host qualification
and raw returned evidence. The whole-frame comparison did not establish a gain;
the candidate is preserved for evidence and was not promoted to the control.
Consult RESULTS.json and the experiment documents for the measured variation.

1. source/control and source/candidate contain the actual application packages.
   Inherited rally-render.* compiler-delivery artifacts are omitted from those
   directories. Only target/control and target/candidate contain the authoritative
   full-fixture module, ELF, object, disassembly, stack and compiler metadata.
2. fixtures/byte and fixtures/word are the exact completed-frame input sets.
   phase/ preserves the separately qualified source, target, fixture, inputs,
   host format checks and raw emulator counter returns. Host fake-clock output
   and isolated raw emulated CCOUNT are distinct from completed-frame timing.
3. Local test/build/runner tools, reports and original metadata are retained.
   EXPERIMENT-README.md is the repository's experiment overview. The selected
   shared runner is under runner/; qualification/fill-units retains the extracted
   original primitive and raw unit-test process output. Host .so libraries,
   caches, direct .work trees and inherited source-package build outputs are
   omitted. No archive member is a symlink.
4. firmware/vdp_rally.bin is extracted unchanged from the accepted sprite
   archive. IDENTITY.json supplies portable relative paths and identities.
   Exact original reports can contain historical absolute provenance strings;
   those strings are not portable path instructions. Rebuilding and launching
   still require the pinned repository toolchain, SDK and emulator environment.
5. evidence/ and phase/evidence/ retain raw returned files without editing them.
   SHA256SUMS covers every other archive member. The external PACKAGE.json also
   hashes SHA256SUMS and records CRC/readback validation. Preservation does not
   authorize another emulator run, hardware deployment or publication.
'''


def digest(data):
    return hashlib.sha256(data).hexdigest()


def encoded(value):
    return (json.dumps(value, indent=2, sort_keys=True) + '\n').encode()


def key(name):
    p = PurePosixPath(name)
    assert name and not p.is_absolute() and '\\' not in name, name
    assert not any(part in ('.', '..', '.work', *SKIP_PARTS) for part in p.parts), name
    assert p.as_posix() == name and not name.endswith('/'), name
    return name


def excluded(path):
    return (any(part in SKIP_PARTS for part in path.parts)
            or path.suffix in ('.so', '.pyc', '.pyo') or '.so.' in path.name)


def ordinary_file(path):
    """Never dereference a selected symlink, including a parent directory."""
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


def tree(members, snapshots, path, prefix, source_package=False):
    assert path.is_dir() and not path.is_symlink(), path
    count = 0
    for p in sorted(path.rglob('*')):
        relative = p.relative_to(path)
        assert not p.is_symlink(), ('symlink in selected tree', p)
        if excluded(relative) or not p.is_file():
            continue
        # These files belong to the old compiler delivery, not this source's
        # compiled renderer. The authoritative target directory is separate.
        if source_package and relative.parent == Path('.') and p.name.startswith('rally-render.'):
            continue
        collect(members, snapshots, p, prefix + '/' + relative.as_posix())
        count += 1
    assert count, path


def check_fixtures(members, registry_name, directory_prefix, modules):
    registry = json.loads(members[registry_name])
    checked = {}
    for case, entry in sorted(registry.items()):
        directory = key(directory_prefix + entry['directory'])
        for name, expected in entry['files'].items():
            member = key(directory + '/' + name)
            assert digest(members[member]) == expected, member
        module_name = modules[case]
        module = members[module_name]
        assert members[directory + '/script.bin'].count(module) == 1, (case, 'embedded module')
        module_hash = digest(module)
        if 'module_sha256' in entry:
            assert entry['module_sha256'] == module_hash, case
        checked[case] = dict(directory=directory, module=module_name,
                             module_sha256=module_hash, registered_hashes_verified=True,
                             embedded_module_exact=True)
    return checked


def preserve():
    members, snapshots = {}, {}
    for p in sorted(HERE.iterdir()):
        if p.name in ('PACKAGE.json', 'PORTABLE.zip') or not p.is_file():
            continue
        if p.suffix not in LOCAL_SUFFIXES or excluded(p.relative_to(HERE)):
            continue
        collect(members, snapshots, p, 'EXPERIMENT-README.md' if p.name == 'README.md' else p.name)
    for kind in ('control', 'candidate'):
        tree(members, snapshots, HERE / '.work' / kind / 'package', 'source/' + kind, source_package=True)
        tree(members, snapshots, HERE / '.work' / kind / 'target', 'target/' + kind)
    tree(members, snapshots, HERE / 'fixtures', 'fixtures')
    tree(members, snapshots, HERE / 'evidence', 'evidence')
    tree(members, snapshots, HERE / 'phase', 'phase')
    for name in ('baseline_fill.inc', 'ordinary.stdout.json', 'ordinary.stderr.txt',
                 'sanitized.stdout.json', 'sanitized.stderr.txt'):
        collect(members, snapshots, HERE / '.work/fill-units' / name, 'qualification/fill-units/' + name)

    pins = json.loads((THROUGHPUT / 'RUNNER-PINS.json').read_bytes())
    for name, expected in pins.items():
        p = THROUGHPUT / 'support' / name
        assert digest(p.read_bytes()) == expected, ('shared runner changed', name)
        collect(members, snapshots, p, 'runner/support/' + name)
    for name in ('RUNNER-PINS.json', 'stage.py', 'oryx_session.py'):
        collect(members, snapshots, THROUGHPUT / name, 'runner/' + name)

    prior_manifest_path = SPRITES / 'PACKAGE.json'
    prior_archive = SPRITES / 'PORTABLE.zip'
    ordinary_file(prior_manifest_path)
    ordinary_file(prior_archive)
    prior_manifest_bytes = prior_manifest_path.read_bytes()
    prior = json.loads(prior_manifest_bytes)
    snapshots[prior_manifest_path] = digest(prior_manifest_bytes)
    snapshots[prior_archive] = digest(prior_archive.read_bytes())
    assert snapshots[prior_archive] == prior['sha256']
    assert json.loads(members['BUILD.json'])['source_archive_sha256'] == prior['sha256']
    with zipfile.ZipFile(prior_archive) as archive:
        firmware = archive.read('firmware/vdp_rally.bin')
    assert digest(firmware) == prior['members']['firmware/vdp_rally.bin'] == FIRMWARE_SHA256
    members['firmware/vdp_rally.bin'] = firmware

    fixture_checks = check_fixtures(members, 'FIXTURES.json', '',
                                   {'byte': 'target/control/rally-render.vdpl',
                                    'word': 'target/candidate/rally-render.vdpl'})
    phase_checks = check_fixtures(members, 'phase/FIXTURES.json', 'phase/',
                                 {'fill': 'phase/target/fill-phase.vdpl'})
    for name, expected in json.loads(members['phase/MANIFEST.json'])['files'].items():
        assert digest(members[key('phase/' + name)]) == expected, ('phase manifest', name)
    assert fixture_checks['byte']['module_sha256'] == CONTROL_SHA256
    assert fixture_checks['word']['module_sha256'] == json.loads(members['BUILD.json'])['module']['sha256']
    for kind in ('control', 'candidate'):
        meta = json.loads(members['target/' + kind + '/rally-render.json'])['module']
        assert digest(members['target/' + kind + '/rally-render.vdpl']) == meta['sha256']
    for name, data in members.items():
        if PurePosixPath(name).name.startswith('PROFILES-') and name.endswith('.json'):
            for entry in json.loads(data).values():
                assert entry['input_sha256']['esp32-firmware.bin'] == FIRMWARE_SHA256, name
    for mode in ('ordinary', 'sanitized'):
        unit = json.loads(members['fill_units_' + mode + '.json'])
        assert unit['passed'] and unit['sources']['wide_fill.inc'] == digest(members['wide_fill.inc'])
        replay = json.loads(members['replay-' + mode + '.json'])
        assert replay['package_files_unchanged_during_replay']
        assert (replay['replay']['frames'], replay['replay']['physics_ticks']) == (900, 3600)
        assert replay['replay']['road_pixels_exact'] and replay['replay']['road_actor_player_commands_exact']
        assert all(lease['balanced'] and lease['canaries_intact'] for lease in replay['replay']['leases'].values())
        assert json.loads(members['phase/host/phase_HOST.json'])[mode]['passed']
    assert members['wide_fill.inc'] == members['source/candidate/helper/wide_fill.inc']

    results = json.loads(members['RESULTS.json'])
    identity = dict(schema=1, task='INC-001-03', checkpoint='84fa64d', candidate_promoted=False,
                    disposition='Exact candidate preserved; whole-frame gain not established; accepted byte-fill control retained',
                    sources={k: 'source/' + k for k in ('control', 'candidate')},
                    targets=fixture_checks, isolated_probe=phase_checks,
                    firmware=dict(path='firmware/vdp_rally.bin', sha256=FIRMWARE_SHA256,
                                  source_archive='prior sprites/PORTABLE.zip', source_archive_sha256=prior['sha256']),
                    whole_frame=dict(nominal_mos_gain_percent=results['nominal_mos_gain_percent'],
                                     nominal_prt_gain_percent=results['nominal_prt_gain_percent'], pairs=results['pairs']),
                    raw_evidence_roots=['evidence', 'phase/evidence'],
                    source_paths='Relative archive paths; exact original reports may retain historical absolute provenance strings',
                    excluded='Inherited source-package rally-render.* artifacts, direct .work paths, symlinks, .git, caches, host .so libraries')
    members['IDENTITY.json'] = encoded(identity)
    members['README.md'] = ARCHIVE_README.encode()
    hashes = {name: digest(data) for name, data in sorted(members.items())}
    members['SHA256SUMS'] = ''.join(h + '  ' + n + '\n' for n, h in hashes.items()).encode()
    hashes['SHA256SUMS'] = digest(members['SHA256SUMS'])
    assert all(key(name) == name and not excluded(PurePosixPath(name)) for name in members)

    with tempfile.TemporaryDirectory(prefix='rally28-wide-fill-', dir='/tmp') as temporary:
        archive_path = Path(temporary) / 'PORTABLE.zip'
        with zipfile.ZipFile(archive_path, 'w', compression=zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
            for name, data in sorted(members.items()):
                info = zipfile.ZipInfo(name, date_time=(1980, 1, 1, 0, 0, 0))
                info.create_system = 3
                info.external_attr = 0o100644 << 16
                info.compress_type = zipfile.ZIP_DEFLATED
                archive.writestr(info, data)
        with zipfile.ZipFile(archive_path) as archive:
            assert archive.testzip() is None
            assert len(archive.namelist()) == len(set(archive.namelist())) == len(hashes)
            assert {n: digest(archive.read(n)) for n in archive.namelist()} == hashes
        for path, expected in snapshots.items():
            ordinary_file(path)
            assert digest(path.read_bytes()) == expected, ('input changed during preservation', path)
        result = dict(schema=1, archive='PORTABLE.zip', sha256=digest(archive_path.read_bytes()),
                      bytes=archive_path.stat().st_size, members=dict(sorted(hashes.items())),
                      zip_crc_verified=True, member_readbacks_verified=True,
                      embedded_SHA256SUMS_verified=True, selected_inputs_unchanged=True,
                      candidate_promoted=False, qualified_targets=fixture_checks, phase=phase_checks,
                      unchanged_firmware_sha256=FIRMWARE_SHA256,
                      preservation_tool_sha256=digest(members['package.py']),
                      excluded_source_build_artifacts=True, direct_work_trees_or_symlinks_in_archive=False,
                      raw_evidence_members=sum(n.startswith(('evidence/', 'phase/evidence/')) for n in members))
        shutil.copyfile(archive_path, HERE / 'PORTABLE.zip')
        (HERE / 'PACKAGE.json').write_bytes(encoded(result))
    with zipfile.ZipFile(HERE / 'PORTABLE.zip') as archive:
        assert {n: digest(archive.read(n)) for n in archive.namelist()} == hashes
    print(json.dumps(dict(archive='PORTABLE.zip', sha256=result['sha256'], members=len(hashes),
                          bytes=result['bytes'], raw_evidence_members=result['raw_evidence_members']), indent=2))


if __name__ == '__main__':
    preserve()
