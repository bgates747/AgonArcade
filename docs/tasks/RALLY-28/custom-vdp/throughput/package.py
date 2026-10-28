"""Register final host-qualified candidates and package exact portable input bytes."""
import hashlib
import json
from pathlib import Path
import shutil
import zipfile
from fixtures import HERE, PRIOR, prepare, sha, unpace, completion_fence


def package():
    registry = prepare()
    span = json.loads((HERE / 'span-BUILD.json').read_text())
    source = HERE / '.work/span-candidate/fixture'
    assert all(sha(source / name) == digest for name, digest in span['fixture']['files'].items())
    for paced in (True, False):
        key = 'native-span-rgba2222-' + ('paced' if paced else 'unpaced')
        target = HERE / '.work/fixtures' / key
        target.mkdir(parents=True, exist_ok=True)
        for name in span['fixture']['files']:
            shutil.copyfile(source / name, target / name)
        meta = json.loads((target / 'expected.json').read_text())
        if not paced:
            (target / 'script.bin').write_bytes(unpace((target / 'script.bin').read_bytes()))
        meta.update(candidate=key, paced=paced, physics_steps_per_frame=4, swap_retained=True,
                    foreground_deadline_mos_units=[3, 3, 4] if paced else None)
        meta['files'] = {p.name: sha(p) for p in sorted(target.iterdir()) if p.name != 'expected.json'}
        (target / 'expected.json').write_text(json.dumps(meta, indent=2) + '\n')
        registry[key] = dict(directory=str(target.relative_to(HERE)),
                            files={p.name: sha(p) for p in sorted(target.iterdir()) if p.is_file()},
                            module_sha256=span['module']['sha256'], foreground_paced=paced,
                            physics_and_drawing_records_unchanged=True, emulator_launched=False)
    phases = json.loads((HERE / 'phase_BUILD.json').read_text())
    for name, entry in phases.items():
        key = 'phase-' + name
        source = HERE / '.work/phase-build' / name / 'fixture'
        assert all(sha(source / n) == h for n, h in entry['fixture_files'].items())
        registry[key] = dict(directory=str(source.relative_to(HERE)), files=entry['fixture_files'],
                            module_sha256=entry['module']['sha256'], foreground_paced=False,
                            diagnostic=True, frames=entry['frames'], emulator_launched=False)
    root = json.loads((PRIOR / 'control/package/interface.json').read_text())['state_buffer']
    for original in ('control-unpaced', 'float-quad-layered-unpaced', 'native-span-rgba2222-unpaced'):
        key = original.removesuffix('-unpaced') + '-fenced-unpaced'
        source = HERE / registry[original]['directory']
        target = HERE / '.work/fixtures' / key
        target.mkdir(parents=True, exist_ok=True)
        for name in registry[original]['files']:
            shutil.copyfile(source / name, target / name)
        meta = json.loads((target / 'expected.json').read_text())
        tape = completion_fence((target / 'script.bin').read_bytes(), meta, root)
        (target / 'script.bin').write_bytes(tape)
        meta['candidate'] = key
        meta['files'] = {p.name: sha(p) for p in target.iterdir() if p.name != 'expected.json'}
        (target / 'expected.json').write_text(json.dumps(meta, indent=2) + '\n')
        registry[key] = dict(directory=str(target.relative_to(HERE)),
            files={p.name: sha(p) for p in sorted(target.iterdir()) if p.is_file()},
            module_sha256=meta['module_sha256'], foreground_paced=False, completion_fenced=True,
            extra_outbound_bytes_per_frame=17, extra_reply_payload_bytes_per_frame=10,
            emulator_launched=False)
    (HERE / 'FIXTURES.json').write_text(json.dumps(registry, indent=2) + '\n')
    members = {}
    for name, case in registry.items():
        for filename in case['files']:
            members['fixtures/' + name + '/' + filename] = HERE / case['directory'] / filename
    members['firmware/vdp_rally.bin'] = PRIOR / 'control/fixture/vdp_rally.bin'
    members['modules/native-span-rgba2222.vdpl'] = HERE / '.work/span-candidate/target/rally-render.vdpl'
    for name in phases:
        members['modules/phase-' + name + '.vdpl'] = HERE / '.work/phase-build' / name / 'target/phase-render.vdpl'
    # Scripts and helper sources are reviewable; the frozen SDK/generated source
    # is already in checkpoint39a546a. No live peer files enter this package.
    for item in HERE.iterdir():
        if item.is_file() and item.suffix in ('.py', '.inc', '.c'):
            members['source/' + item.name] = item
    for item in (HERE / 'support').glob('*.py'):
        members['source/support/' + item.name] = item
    members['source/RUNNER-PINS.json'] = HERE / 'RUNNER-PINS.json'
    members['source/phase_HOST-ordinary.json'] = HERE / 'phase_HOST-ordinary.json'
    hashes = {name: sha(path) for name, path in members.items()}
    archive = HERE / 'PORTABLE.zip'
    with zipfile.ZipFile(archive, 'w', zipfile.ZIP_DEFLATED) as z:
        for name, path in sorted(members.items()):
            info = zipfile.ZipInfo(name, (2026, 10, 28, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = 0o100644 << 16
            z.writestr(info, path.read_bytes())
        info = zipfile.ZipInfo('MANIFEST.json', (2026, 10, 28, 0, 0, 0))
        info.compress_type = zipfile.ZIP_DEFLATED
        z.writestr(info, json.dumps(dict(checkpoint='39a546a', files=hashes,
            scope='Host-qualified experimental native fixtures; emulator/hardware performance not qualified'),
            indent=2).encode() + b'\n')
    with zipfile.ZipFile(archive) as z:
        assert all(hashlib.sha256(z.read(n)).hexdigest() == h for n, h in hashes.items())
    report = dict(sha256=sha(archive), files=len(members) + 1, member_sha256=hashes,
                  baseline_checkpoint='39a546a', firmware_changed=False, emulator_launched=False,
                  card_deployed=False, physical_testing_released=False)
    (HERE / 'PACKAGE.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(dict(fixtures=len(registry), packaged_files=report['files'], sha256=report['sha256'])))


if __name__ == '__main__':
    package()
