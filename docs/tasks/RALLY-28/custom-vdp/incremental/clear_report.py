"""Summarize the first isolated clear experiment from preserved Oryx returns."""
from collections import defaultdict
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent


def read_ppm(path):
    magic, dimensions, maximum, pixels = path.read_bytes().split(b'\n', 3)
    assert magic == b'P6' and maximum == b'255'
    width, height = map(int, dimensions.split())
    assert (width, height) == (320, 240) and len(pixels) == width*height*3
    return pixels


def compare_pixels(a, b):
    changed = [(i//3 % 320, i//3 // 320) for i in range(0,len(a),3) if a[i:i+3] != b[i:i+3]]
    road = [(x,y) for x,y in changed if 104 <= y < 224]
    def bbox(points):
        return ([min(x for x,y in points), min(y for x,y in points),
                 max(x for x,y in points)+1, max(y for x,y in points)+1] if points else None)
    return dict(full_image_difference_bbox=bbox(changed), road_difference_bbox=bbox(road),
                road_changed_pixels=len(road), full_image_changed_pixels=len(changed))


def summarize(campaigns, session):
    rows, pictures, groups = [], [], defaultdict(list)
    identities = []
    for campaign in campaigns:
        result = json.loads((HERE/('CAMPAIGN-'+campaign+'.json')).read_text())
        profiles = json.loads((HERE/('PROFILES-'+campaign+'.json')).read_text())
        for name, r in result.items():
            assert r['passed'] and r['input_hashes_preserved'] and r['final_world_exact']
            assert r['frames'] == 900 and r['physics_ticks'] == 3600
            assert r['retained_replies'] == 2913 and r['process_exit'] == 0
            assert r['prt']['previous_vector_restored'] and r['boost_after'] == '0'
            assert not any(r['backend_stats'].get(k) for k in ('failed','unhandled','unregistered','unmapped'))
            identities.append({n:h for n,h in profiles[name]['input_sha256'].items()
                               if n not in ('sdcard/rally25/script.bin','sdcard/rally25/expected.json')})
            row = dict(campaign=campaign, case=name, frames=r['frames'],
                       nominal_mos_seconds=r['nominal_mos_seconds'], nominal_mos_fps=r['nominal_mos_fps'],
                       nominal_prt_seconds=r['prt']['nominal_seconds_at_18432000_hz'],
                       nominal_prt_fps=r['prt']['nominal_fps_at_18432000_hz'],
                       host_seconds_including_startup=r['host_seconds_including_startup'])
            rows.append(row)
            groups[name].append(row)
            pictures.append((campaign+'/'+name, read_ppm(HERE/'evidence'/campaign/name/'final.ppm')))
    assert len(rows) == 4 and all(len(v) == 2 for v in groups.values())
    assert all(p == identities[0] for p in identities), 'Unexpected runtime/input difference'
    pooled = {}
    for name, records in groups.items():
        frames = sum(r['frames'] for r in records)
        mos = sum(r['nominal_mos_seconds'] for r in records)
        prt = sum(r['nominal_prt_seconds'] for r in records)
        pooled[name] = dict(frames=frames, runs=len(records), nominal_mos_seconds=mos,
                            nominal_mos_fps=frames/mos, nominal_prt_seconds=prt,
                            nominal_prt_fps=frames/prt,
                            individual_mos_fps=[r['nominal_mos_fps'] for r in records])
    comparisons = []
    for label, im in pictures[1:]:
        comparisons.append(dict(reference=pictures[0][0], case=label, size=[320,240],
                                **compare_pixels(pictures[0][1], im)))
    s = json.loads((HERE/('SESSION-'+session+'.json')).read_text())
    assert s['error'] is None and s['boost_restored'] and not s['owned_emulator_processes_after']
    assert s['original_boost'] == s['final_boost']
    control, candidate = pooled['clear-control'], pooled['clear-split']
    report = dict(checkpoint='b0bf5e7', task='INC-001-01', rows=rows, pooled=pooled,
                  nominal_mos_fps_change_percent=(candidate['nominal_mos_fps']/control['nominal_mos_fps']-1)*100,
                  nominal_prt_fps_change_percent=(candidate['nominal_prt_fps']/control['nominal_prt_fps']-1)*100,
                  nominal_mos_ms_saved_per_frame=(control['nominal_mos_seconds']-candidate['nominal_mos_seconds'])/1800*1000,
                  identical_runtime_and_nonpatch_inputs=True,
                  clear_pixels_saved_per_frame=38400, additional_outbound_bytes_per_frame=12,
                  outbound_bytes_per_frame=dict(control=265,candidate=277),
                  all_final_states_exact=True, all_prt_vectors_restored=True, backend_errors=0,
                  image_comparisons=comparisons,
                  image_limit='Shutdown snapshots after saving/DONE text and MOS return, not frame-900 instrumentation; inspect difference locations.',
                  session={k:s[k] for k in ('host_boot_id','original_boost','final_boost','boost_restored',
                      'max_temperature_celsius','owned_emulator_processes_after','elapsed_host_seconds')},
                  timing_limit='Completion-fenced finite native fixture including checks/UART/swap; MOS nominal120Hz and PRT nominal18.432MHz reported separately. Host durations include startup/teardown. Not hardware or isolated VDP CPU timing.')
    (HERE/'CLEAR-RESULTS.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({k:report[k] for k in ('pooled','nominal_mos_fps_change_percent',
        'nominal_prt_fps_change_percent','nominal_mos_ms_saved_per_frame','image_comparisons')},indent=2))


if __name__ == '__main__':
    summarize(('incab01','incba01'), 'incsession01')
