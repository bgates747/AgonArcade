"""Freeze the released two-pixel recipe before capacity/runtime implementation.

Target inputs contain original-art identities, transform commands and metadata;
the host stock image model supplies a few registration probes, never uploads.
"""
from pathlib import Path
import csv
import hashlib
import json
import struct

HERE = Path(__file__).resolve().parent
PREP = HERE.parent / 'preparation'
CUSTOM = HERE.parents[1]
CONTROL = CUSTOM / 'incremental/round-trips'
AFFINE = CUSTOM / 'affine-offline'
sha = lambda p: hashlib.sha256(Path(p).read_bytes()).hexdigest()


def fnv(data):
    n = 2166136261
    for b in data:
        n = ((n ^ b) * 16777619) & 0xffffffff
    return n


def write(name, data):
    p = HERE / name
    p.parent.mkdir(parents=True, exist_ok=True)
    if p.exists():
        assert p.read_bytes() == data, ('Frozen file changed', name)
    else:
        p.write_bytes(data)


def command(bitmap, op):
    return b'\x17\0\xa0' + struct.pack('<HB', bitmap, op)


def generate(entry):
    s = entry['q'] * 2
    coefficients = (-s if entry['mirror'] else s, 0,
                    101*s if entry['mirror'] else 0, 0, s, 0)
    b = command(entry['id'], 2)
    b += command(51998, 32) + b'\0'
    b += command(51998, 32) + b'\x0b\xc8' + struct.pack('<6h', *coefficients)
    b += command(entry['id'], 40) + struct.pack('<B4H', 3, 51998,
                    64000+entry['source'], entry['width'], entry['height'])
    assert len(b) == 48
    return b


def physical(value):
    return (value & 3) << 4 | (value & 12) | (value >> 4 & 3)


def freeze():
    frozen = json.loads((PREP/'PREPARATION-FREEZE.json').read_text())
    for name, digest in frozen['source_data_sha256'].items():
        assert sha(PREP/name) == digest, name
    assert sha(CONTROL/'guest/probe.bin') == frozen['baseline_guest_sha256']
    assert sha(CONTROL/'target/rally-render.vdpl') == frozen['baseline_module_sha256']
    policy = json.loads((PREP/'FINDINGS.json').read_text())['policies']['two-pixel-stock-model']
    images = {(int(r['source']), int(r['mirror']), int(r['q'])):
              {k: int(v) for k, v in r.items() if k not in ('stock_rgba_error', 'stock_mask_error')}
              for r in csv.DictReader((PREP/'IMAGES.csv').open())}
    stock = (PREP/'.work/stock-images.bin').read_bytes()
    assets = {r['bitmap_id']: r for r in json.loads((AFFINE/'WORKLOAD.json').read_text())['bitmaps']}
    entries, directories, maps = [], bytearray(), bytearray()
    selected = {}
    for family in range(18):
        mapping = {int(q): int(v) for q, v in policy['q_maps'][str(family)].items()}
        selected[family] = sorted(set(mapping.values()))
        maps += bytes(selected[family].index(mapping[q]) if q in mapping else 255 for q in range(126))
    for source in [*range(5, 35), *range(120, 128)]:
        art = assets[source]
        assert sha(AFFINE/art['path']) == art['sha256']
        original = (AFFINE/art['path']).read_bytes()
        for mirror in ((0, 1) if source < 120 else (0,)):
            family = 2*((source-5) % 5)+mirror if source < 120 else 10+source-120
            first = len(entries)
            for q in selected[family]:
                r = images[source, mirror, q]
                pixels = stock[r['offset']:r['offset']+r['bytes']]
                candidates = []
                for y in range(r['height']):
                    for x in range(r['width']):
                        value = pixels[y*r['width']+x]
                        if value >> 6 != 3:
                            continue
                        # Prefer interior flat colours whose nearest source pixel
                        # has a same-colour neighbourhood: robust to tiny inverse
                        # rounding differences between host model and ESP DSP.
                        sx = int((101-x*256/(2*q)) if mirror else x*256/(2*q))
                        sy = int(y*256/(2*q))
                        if not (0 <= sx < art['width'] and 0 <= sy < art['height']):
                            continue
                        neighbours = [original[yy*art['width']+xx]
                            for yy in range(max(0, sy-1), min(art['height'], sy+2))
                            for xx in range(max(0, sx-1), min(art['width'], sx+2))]
                        score = (all(v == value for v in neighbours),
                                 physical(value) not in (0, 63),
                                 min(x, y, r['width']-1-x, r['height']-1-y))
                        candidates.append((score, x, y, physical(value)))
                assert candidates, ('No opaque registration witness', source, mirror, q)
                candidates.sort(reverse=True)
                points = []
                for _, x, y, value in candidates:
                    if not points or all(abs(x-a)+abs(y-b) >= max(1, min(r['width'], r['height'])//4)
                                         for a, b, _ in points):
                        points.append((x, y, value))
                        if len(points) == 4:
                            break
                entries.append(dict(id=52000+len(entries), source=source, mirror=mirror,
                    family=family, q=q, width=r['width'], height=r['height'],
                    anchor_x=r['anchor_x'], anchor_y=r['anchor_y'], bytes=r['bytes'],
                    probe=list(points[0]), detailed_probes=[list(p) for p in points]))
            directories += struct.pack('<HBBHHIBBH', source, family,
                mirror | (2 if source >= 120 else 0), first, len(entries)-first,
                1152+family*126, art['width'], art['height'], 0)
    assert len(entries) == 901 and sum(e['bytes'] for e in entries) == 2211975
    # Keep detailed points on just one large representative per geometry family.
    detailed = {max((e for e in entries if e['family'] == f), key=lambda e:e['bytes'])['id']
                for f in range(18)}
    small = max(entries, key=lambda e:e['bytes'])['id']
    for e in entries:
        e['detailed'] = e['id'] in detailed
    recipe = dict(schema='rally.aff03.two-pixel-recipe.v1', experimental=True,
        appearance_accepted=False, dispatch='2026-10-30_19-44-52_golem_golem057-rally-capacity-experiment-eight',
        policy='two-pixel-stock-model', full_domain=True, runtime_fallback=False,
        pixel_uploads=False, generator='stock-command40-options3-q8-v1',
        source_artwork={str(n):assets[n]['sha256'] for n in [*range(5,35),*range(120,128)]},
        small_probe_id=small, image_count=901, pixel_bytes=2211975, entries=entries)
    recipe_data = (json.dumps(recipe, indent=2)+'\n').encode()
    recipe_tag = fnv(recipe_data)
    source_tag = fnv(json.dumps(recipe['source_artwork'], sort_keys=True).encode())
    records = b''.join(struct.pack('<HBBhh', e['id'], e['width'], e['height'], e['anchor_x'], e['anchor_y']) for e in entries)
    body = directories + maps + records
    assert len(directories) == 1088 and len(maps) == 2268 and len(body)+64 == 10628
    header = bytearray(64)
    struct.pack_into('<4sHHIIHHHHIIIII', header, 0, b'R3PI', 1, 64,
        10628, fnv(body), 68, 18, 901, 1, 64, 1152, 3420, 1, recipe_tag)
    # Explicit field writes make the accepted layout independent of host structs.
    struct.pack_into('<HHHHI', header, 44, 126, 52000, 901, 0, source_tag)
    table = bytes(header) + body
    assert table[56:64] == bytes(8)
    plan = b''.join(struct.pack('<HHHBBBBBBHH', e['id'], e['source'], 2*e['q'],
        e['width'], e['height'], e['mirror'], *e['probe'], e['bytes'], 1 | (2 if e['detailed'] else 0)) for e in entries)
    generation = b''.join(generate(e) for e in entries)
    write('recipe.json', recipe_data)
    write('index.bin', table)
    write('plan.bin', plan)
    write('generation.vdu', generation)
    write('index.vdu', command(51999, 2)+command(51999, 0)+struct.pack('<H',len(table))+table)
    write('recipe-pins.hpp', ('#pragma once\nnamespace capacity_pins {\n'
        f'constexpr unsigned Count=901,TableBytes=10628,SmallId={small};\n'
        f'constexpr uint32_t TableFNV={fnv(table)}u,PlanFNV={fnv(plan)}u,WireFNV={fnv(generation)}u;\n'
        '}\n').encode())
    files = ['recipe.py','recipe.json','index.bin','plan.bin','generation.vdu','index.vdu','recipe-pins.hpp']
    pins = dict(schema='rally.aff03.recipe-freeze.v1', before_capacity_implementation=True,
        interface_sha256=sha(PREP/'PACKED-INTERFACE-v1.md'),
        preparation_freeze_sha256=sha(PREP/'PREPARATION-FREEZE.json'),
        source_generator_pins=json.loads((AFFINE/'SOURCE-MANIFEST.json').read_text()),
        baseline_guest_sha256=sha(CONTROL/'guest/probe.bin'),
        baseline_module_sha256=sha(CONTROL/'target/rally-render.vdpl'),
        files={n:sha(HERE/n) for n in files})
    write('RECIPE-FREEZE.json', (json.dumps(pins,indent=2)+'\n').encode())
    print(json.dumps(dict(images=len(entries), pixels=2211975, table_bytes=len(table),
        generation_bytes=len(generation), freeze_sha256=sha(HERE/'RECIPE-FREEZE.json')),indent=2))


if __name__ == '__main__':
    freeze()
