"""Derive the qualified sprite comparison; exclude rejected startup/clip trials."""
import hashlib
import json
from pathlib import Path
import sys

HERE=Path(__file__).resolve().parent
sys.path.insert(0,str(HERE.parent))
from clear_report import read_ppm,compare_pixels


def summarize():
    groups={name:[] for name in ('clipfix-affine','clipfix-additive')}
    rows=[];pictures=[];inputs=[]
    for campaign in ('sprcab01','sprcba01'):
        results=json.loads((HERE/('CAMPAIGN-'+campaign+'.json')).read_text())
        profiles=json.loads((HERE/('PROFILES-'+campaign+'.json')).read_text())
        assert set(results)==set(groups)
        for name,r in results.items():
            assert r['passed'] and r['input_hashes_preserved'] and r['final_world_exact']
            assert (r['frames'],r['physics_ticks'],r['retained_replies'])==(900,3600,2913)
            assert r['process_exit']==0 and r['boost_after']=='0'
            assert r['prt']['timer_borrowed'] and r['prt']['previous_vector_restored']
            assert not any(r['backend_stats'].get(k) for k in ('failed','unhandled','unregistered','unmapped'))
            row=dict(campaign=campaign,case=name,frames=900,physics_ticks=3600,
                     nominal_mos_seconds=r['nominal_mos_seconds'],nominal_mos_fps=r['nominal_mos_fps'],
                     nominal_prt_seconds=r['prt']['nominal_seconds_at_18432000_hz'],
                     nominal_prt_fps=r['prt']['nominal_fps_at_18432000_hz'],
                     host_seconds_including_startup=r['host_seconds_including_startup'])
            observations=json.loads((HERE/'evidence'/campaign/name/'run.json').read_text())['result']['observations']
            row['stack_minfree_bytes']={r['label']:r['value'] for r in observations if r['label'] in ('stack before','stack after')}
            rows.append(row);groups[name].append(row)
            pictures.append((campaign+'/'+name,read_ppm(HERE/'evidence'/campaign/name/'final.ppm')))
            inputs.append({n:h for n,h in profiles[name]['input_sha256'].items()
                           if n not in ('sdcard/rally25/script.bin','sdcard/rally25/native.vdu','sdcard/rally25/expected.json')})
    assert all(n==inputs[0] for n in inputs),'Runtime/driver/artwork mismatch'
    pooled={}
    for name,rs in groups.items():
        assert len(rs)==2
        frames=sum(r['frames'] for r in rs);mos=sum(r['nominal_mos_seconds'] for r in rs);prt=sum(r['nominal_prt_seconds'] for r in rs)
        pooled[name]=dict(runs=2,frames=frames,nominal_mos_seconds=mos,nominal_mos_fps=frames/mos,
                          nominal_mos_ms_per_frame=mos/frames*1000,nominal_prt_seconds=prt,
                          nominal_prt_fps=frames/prt,individual_mos_fps=[r['nominal_mos_fps'] for r in rs])
    pixel_comparisons=[dict(reference=pictures[0][0],case=name,**compare_pixels(pictures[0][1],pixels))
                       for name,pixels in pictures[1:]]
    assert all(r['full_image_changed_pixels']==0 for r in pixel_comparisons),'Inspect actual capture differences'
    session=json.loads((HERE/'SESSION-sprcsession01.json').read_text())
    assert session['error'] is None and session['boost_restored'] and not session['owned_emulator_processes_after']
    control=pooled['clipfix-affine'];candidate=pooled['clipfix-additive']
    pair_changes=[]
    for campaign in ('sprcab01','sprcba01'):
        c={r['case']:r for r in rows if r['campaign']==campaign}
        pair_changes.append(dict(campaign=campaign,nominal_mos_gain_percent=
            (c['clipfix-additive']['nominal_mos_fps']/c['clipfix-affine']['nominal_mos_fps']-1)*100))
    report=dict(task='INC-001-02',checkpoint='32a7cb4',rows=rows,pooled=pooled,
                nominal_mos_gain_percent=(candidate['nominal_mos_fps']/control['nominal_mos_fps']-1)*100,
                nominal_prt_gain_percent=(candidate['nominal_prt_fps']/control['nominal_prt_fps']-1)*100,
                nominal_mos_ms_saved_per_frame=control['nominal_mos_ms_per_frame']-candidate['nominal_mos_ms_per_frame'],
                pair_changes=pair_changes,pixel_comparisons=pixel_comparisons,
                module_sha256='310779643769adde8413b93ea282115990dfebfe873e3395ac5545ac9d506702',
                extra_retained_scratch_bytes=52238,per_frame_outbound_bytes=277,
                firmware_sdk_driver_artwork_physics_unchanged=True,
                startup='Both modules LOAD before artwork/mode136; exact same timed tape on both sides.',
                session={k:session[k] for k in ('host_boot_id','original_boost','final_boost','boost_restored',
                    'max_temperature_celsius','elapsed_host_seconds','owned_emulator_processes_after')},
                rejected_trials=['sprab01 late-LOAD candidate MEMORY6 before physics/rendering',
                                 'spreab01/spreba01 preclip sampler stale pixels; timings excluded',
                                 'sprphaseEarly01 full additive diagnostic MEMORY6',
                                 'sprcompact01 compact additive diagnostic MEMORY6'],
                clocks='Completion-fenced finite900frame/3600tick fixture; MOS nominal120units/s, PRT nominal18.432MHz emulated instruction clock. Host durations include startup/teardown. Not hardware or an independently scheduled gameplay rate.',
                visual_limit='All four final shutdown captures identical, not an exhaustive moving-frame comparison; Author motion gate remains.')
    (HERE/'RESULTS.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({k:report[k] for k in ('pooled','nominal_mos_gain_percent','nominal_prt_gain_percent',
                     'nominal_mos_ms_saved_per_frame','pair_changes','pixel_comparisons')},indent=2))
    return report


if __name__=='__main__':summarize()
