"""Prepare owned source variants without building or touching old packages."""
from pathlib import Path
import hashlib
import json
import re

HERE = Path(__file__).resolve().parent
BASE = HERE.parent / 'incremental/round-trips/source'


def replace(text, before, after):
    assert text.count(before) == 1, before[:100]
    return text.replace(before, after)


def prepare():
    inputs = {}
    names = ['checked.c', 'publication.inc', 'interface.json', 'root.json',
             'backends.json', 'common-install.bin']
    names += [str(p.relative_to(BASE)) for p in sorted((BASE / 'helper').iterdir())]
    source = {name: (BASE / name).read_bytes() for name in names}
    for name, data in source.items():
        inputs[str(BASE / name)] = hashlib.sha256(data).hexdigest()

    # The old package also exported stand-alone arithmetic/kernel test entries.
    # The race invokes only Tick120/InitRace/Render30/StopRace. Keep those exact
    # case bodies/entry numbers in BOTH arms; reject unused public test entries.
    native = source['checked.c'].decode()
    switch = native.index('switch(r->entry_id){')
    finish = native.index('\n}\nrc=renderer_hook', switch)
    cases = native[switch:finish]
    matches = list(re.finditer(r'^case (\d+):\{', cases, re.M))
    assert [int(m[1]) for m in matches] == list(range(17))
    keep = {3, 13, 15, 16}
    selected = 'switch(r->entry_id){\n'
    kept_hashes = {}
    for i, match in enumerate(matches):
        end = matches[i+1].start() if i+1 < len(matches) else len(cases)
        body = cases[match.start():end]
        if int(match[1]) in keep:
            selected += body
            kept_hashes[match[1]] = hashlib.sha256(body.encode()).hexdigest()
    native = native[:switch] + selected + native[finish:]
    native = replace(native, 'if(r->operation!=VDPL_RUN||r->entry_id>=17)return VDPL_E_UNSUPPORTED;',
                     'if(r->operation!=VDPL_RUN || (r->entry_id!=3 && r->entry_id!=13 && '
                     'r->entry_id!=15 && r->entry_id!=16))return VDPL_E_UNSUPPORTED;')
    source['checked.c'] = native.encode()

    core = source['helper/render_core.inc'].decode()
    core = replace(core, '/* Never retain acquired pointers in persistent module state. */',
                   '#if R28_DIRECT_ROWS\n#include "road_rows.inc"\n#endif\n'
                   '/* Never retain acquired pointers in persistent module state. */')
    core = replace(core, '    uint8_t *span_pixels;',
                   '    uint8_t *span_pixels;\n#if R28_DIRECT_ROWS\n'
                   '    R28RoadTarget *road_target;\n#endif')
    core = replace(core, '    if (left < right) memset(row + left, colour, (unsigned)(right - left));',
                   '#if R28_DIRECT_ROWS\n    r28_rows_fill(row, left, right, colour);\n'
                   '#else\n    if (left < right) memset(row + left, colour, (unsigned)(right - left));\n#endif')
    core = replace(core, 'static int r28_span_section(uint8_t *pixels, int ct, int cb, int yt, int yb, int marked) {',
                   'static int r28_span_section(const Assets *a, int ct, int cb, int yt, int yb, int marked) {\n'
                   '    uint8_t *pixels = a->span_pixels;')
    core = replace(core, '    if (!pixels || yt < R28_SPAN_TOP',
                   '    if (yt < R28_SPAN_TOP')
    core = replace(core, '        uint8_t *row = pixels + (y - R28_SPAN_TOP) * R28_SPAN_WIDTH;',
                   '#if R28_DIRECT_ROWS\n        uint8_t *row = r28_rows_row(a->road_target, (unsigned)y);\n'
                   '        if (!row) return 0;\n#else\n'
                   '        uint8_t *row = pixels + (y - R28_SPAN_TOP) * R28_SPAN_WIDTH;\n#endif')
    core = replace(core, '    memset(a->span_pixels, r28_span_colour(2), R28_SPAN_WIDTH);\n    r28_span_bitmap(o);',
                   '#if R28_DIRECT_ROWS\n    uint8_t *first_row = r28_rows_row(a->road_target, R28_SPAN_TOP);\n'
                   '    if (!first_row) { o->error = 1; return 0; }\n'
                   '    r28_span_fill(first_row, 0, R28_SPAN_WIDTH, r28_span_colour(2));\n#else\n'
                   '    memset(a->span_pixels, r28_span_colour(2), R28_SPAN_WIDTH);\n'
                   '    r28_span_bitmap(o);\n#endif')
    core = replace(core, 'r28_span_section(a->span_pixels, ct, cb, y, yy, marked)',
                   'r28_span_section(a, ct, cb, y, yy, marked)')

    render = source['helper/rally_render.c'].decode()
    original = '''                    vdplet_view_v1 pixels;int32_t pr=acquire(h,&r28_span_range,&pixels);
                    if(pr)rc=fail(c,RALLY_RENDER_REASON_ACQUIRE,pr,pr);
                    else if(!view_ok(&pixels,&r28_span_range))rc=fail(c,RALLY_RENDER_REASON_CAPACITY,VDPL_E_BOUNDS,0);
                    else{a.span_pixels=pixels.data;c->bands=(uint16_t)road(&out,&a);}
                    int32_t rr=release(h,&pixels);if(rr)rc=fail(c,RALLY_RENDER_REASON_RELEASE,rr,rr);'''
    direct = '''#if R28_DIRECT_ROWS
                    R28RoadTarget target;
                    int32_t pr=r28_rows_begin(h,&target);
                    if(!pr){a.span_pixels=0;a.road_target=&target;c->bands=(uint16_t)road(&out,&a);}
                    /* BEGIN can admit a lease before a layout refusal. Always END it. */
                    int32_t rr=r28_rows_end(&target);
                    if(pr || rr)rc=fail(c,RALLY_RENDER_REASON_ACQUIRE,pr?pr:rr,pr?pr:rr);
#else
''' + original + '\n#endif'
    render = replace(render, original, direct)
    render = replace(render, 'if(out.error && c->reason!=RALLY_RENDER_REASON_RELEASE)',
                     'if(out.error && !rc && c->reason!=RALLY_RENDER_REASON_RELEASE)')
    source['helper/render_core.inc'] = core.encode()
    source['helper/rally_render.c'] = render.encode()
    source['helper/road_rows.inc'] = (HERE / 'road_rows.inc').read_bytes()

    variants = {}
    for name, flag in [('bitmap', 0), ('rows', 1)]:
        directory = HERE / 'source' / name
        hashes = {}
        for relative, data in source.items():
            if relative == 'checked.c':
                data = f'#define R28_DIRECT_ROWS {flag}\n'.encode() + data
            path = directory / relative
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(data)
            hashes[relative] = hashlib.sha256(data).hexdigest()
        variants[name] = hashes
    report = dict(baseline_files=inputs, variants=variants,
                  scratch_allocation_retained=True, rows_scratch_pixels_written=False,
                  geometry_and_actor_sources_unchanged=True,
                  retained_entry_ids=sorted(keep), retained_case_body_sha256=kept_hashes,
                  unused_diagnostic_entries_removed_in_both_arms=True,
                  status='Sources prepared; not built, tested or target-qualified')
    (HERE / 'SOURCE.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(dict(variants=list(variants), files_per_variant=len(source)), indent=2))


if __name__ == '__main__':
    prepare()
