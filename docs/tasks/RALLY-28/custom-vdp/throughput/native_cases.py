"""Register/package the source-proven Native bitmap setup-byte comparison."""
import json
from pathlib import Path
import shutil
import zipfile
from fixtures import HERE, PRIOR, sha, unpace, completion_fence


def prepare():
    registry = json.loads((HERE / 'FIXTURES.json').read_text())
    source = HERE / '.work/native-format/fixture'
    original_meta = json.loads((source / 'expected.json').read_text())
    assert all(sha(source / n) == h for n, h in original_meta['files'].items())
    span = json.loads((HERE / 'span-BUILD.json').read_text())
    assert original_meta['module_sha256'] == span['module']['sha256']
    rgba = HERE / registry['native-span-rgba2222-paced']['directory']
    before, after = (rgba / 'native.vdu').read_bytes(), (source / 'native.vdu').read_bytes()
    assert len(before) == len(after) and before[:-1] == after[:-1] and (before[-1], after[-1]) == (1, 3)
    for name in ('probe.bin', 'script.bin', 'artwork.vdu', 'assets.vdu', 'common.vdu', 'run.txt'):
        assert sha(source / name) == sha(rgba / name), name
    root = json.loads((PRIOR / 'control/package/interface.json').read_text())['state_buffer']
    report = {}
    for suffix in ('paced', 'unpaced', 'fenced-unpaced'):
        name = 'native-span-native-' + suffix
        target = HERE / '.work/fixtures' / name
        target.mkdir(parents=True, exist_ok=True)
        for item in source.iterdir():
            if item.is_file():
                shutil.copyfile(item, target / item.name)
        meta = json.loads((target / 'expected.json').read_text())
        meta.update(candidate=name, paced=suffix == 'paced', bitmap_format=3,
                    mode136_native_bytes_verified=True, physics_steps_per_frame=4,
                    foreground_deadline_mos_units=[3, 3, 4] if suffix == 'paced' else None,
                    swap_retained=True)
        tape = (target / 'script.bin').read_bytes()
        if suffix != 'paced':
            tape = unpace(tape)
        if suffix == 'fenced-unpaced':
            tape = completion_fence(tape, meta, root)
        (target / 'script.bin').write_bytes(tape)
        meta['files'] = {p.name: sha(p) for p in sorted(target.iterdir()) if p.name != 'expected.json'}
        (target / 'expected.json').write_text(json.dumps(meta, indent=2) + '\n')
        comparator = 'native-span-rgba2222-' + suffix
        previous = HERE / registry[comparator]['directory']
        assert sha(target / 'script.bin') == sha(previous / 'script.bin'), 'Timed/setup tape must stay identical'
        entry = dict(directory=str(target.relative_to(HERE)),
            files={p.name: sha(p) for p in sorted(target.iterdir()) if p.is_file()},
            module_sha256=meta['module_sha256'], foreground_paced=meta['paced'],
            completion_fenced=meta.get('completion_fenced', False), bitmap_format=3,
            module_and_pixel_bytes_unchanged=True, emulator_launched=False)
        registry[name] = entry
        report[name] = entry
    (HERE / 'FIXTURES.json').write_text(json.dumps(registry, indent=2) + '\n')
    members = {}
    for name, entry in report.items():
        for filename in entry['files']:
            members['fixtures/' + name + '/' + filename] = HERE / entry['directory'] / filename
    members['firmware/vdp_rally.bin'] = PRIOR / 'control/fixture/vdp_rally.bin'
    members['modules/rally-render.vdpl'] = HERE / '.work/span-candidate/target/rally-render.vdpl'
    for pattern in ('native*.py', 'native-FORMAT*.json'):
        for item in HERE.glob(pattern):
            members['source/' + item.name] = item
    hashes = {name: sha(path) for name, path in members.items()}
    archive = HERE / 'NATIVE-PORTABLE.zip'
    with zipfile.ZipFile(archive, 'w', zipfile.ZIP_DEFLATED) as z:
        for name, path in sorted(members.items()):
            info = zipfile.ZipInfo(name, (2026, 10, 28, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED
            z.writestr(info, path.read_bytes())
        info = zipfile.ZipInfo('MANIFEST.json', (2026, 10, 28, 0, 0, 0))
        info.compress_type = zipfile.ZIP_DEFLATED
        z.writestr(info, json.dumps(dict(files=hashes,
            limitation='Native byte identity requires exact mode136, opaque Set drawing and no affine transform'),
            indent=2).encode() + b'\n')
    receipt = dict(fixtures=report, archive_sha256=sha(archive), member_sha256=hashes,
        original_rgba_package_preserved=True, bitmap_setup_only_byte_change=[1, 3],
        firmware_and_module_unchanged=True, new_timing_claim=False)
    (HERE / 'NATIVE-CASES.json').write_text(json.dumps(receipt, indent=2) + '\n')
    print('Prepared3Native-format cases; module/tapes/pixels unchanged; original RGBA package preserved')
    return report


if __name__ == '__main__':
    prepare()
