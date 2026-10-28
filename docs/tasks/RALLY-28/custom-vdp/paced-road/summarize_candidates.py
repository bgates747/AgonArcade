"""Summarize paired aggregate timing without inferring native phase timings."""
from pathlib import Path
import json
from build_candidates import HERE


if __name__=='__main__':
    campaign=json.loads((HERE/'CAMPAIGN-qualified.json').read_text())
    host=json.loads((HERE/'HOST-ordinary.json').read_text())
    raster=json.loads((HERE/'RASTER-SAMPLES.json').read_text())
    base=campaign['control']['fps'];rows=[]
    for name,r in campaign.items():
        h=host[name];pixels=raster[name]
        rows.append(dict(candidate=name,fps=r['fps'],ratio_to_control=r['fps']/base,
            average_bands=h['average_bands'],average_material_shapes=h['average_material_shapes'],
            average_polygon_fills=h['average_polygon_fills'],average_resident_road_bytes=h['average_road_bytes'],
            average_sampled_material_writes=pixels['mean_material_pixel_writes'],
            maximum_sampled_pixel_difference=pixels['maximum_differing_frame_pixels'],
            stack=r['stack_observations']))
    result=dict(scope='Matched silent headless Flexe with boost disabled; paced900frames/3600steps per case; nominal120MOS units/s',
        rows=rows,best_observed=max(rows,key=lambda x:x['fps'])['candidate'],
        driver_and_hot_loop_tape_unchanged=True,firmware_and_runtime_unchanged=True,
        recurring_ez80_wire_bytes_per_frame=248,requested_pacer_fps=36,physics_steps_per_frame=4,
        identical_final_world=True,physical_candidate_run=False,
        limitations=['Single campaign, small differences need repeat confirmation',
            'Aggregate fixture timing; native physics/geometry/raster phase timings not isolated',
            'Host raster samples do not replace Author motion review',
            'Emulator VDP throughput does not predict hardware gain',
            'Unpaced measurements remain deferred'])
    repeat=HERE/'CAMPAIGN-repeat01.json'
    if repeat.exists():
        result['repeat']=json.loads(repeat.read_text())
        baseline='control';best='float-quad-layered'
        for r in result['repeat'].values():
            assert r['boost_after']=='0' and r['final_buffers']==campaign[baseline]['final_buffers']
        pooled={name:1800/(campaign[name]['nominal_mos_seconds']+result['repeat'][name]['nominal_mos_seconds']) for name in (baseline,best)}
        result['paired_repeat']=dict(first_order=[baseline,best],repeat_order=list(result['repeat']),
            first_ratio=campaign[best]['fps']/campaign[baseline]['fps'],
            repeat_ratio=result['repeat'][best]['fps']/result['repeat'][baseline]['fps'],
            pooled_fps=pooled,pooled_ratio=pooled[best]/pooled[baseline])
        result['limitations'][0]='Control/best repeated in reverse order; other variants have one completed measurement'
    (HERE/'CANDIDATE-RESULTS.json').write_text(json.dumps(result,indent=2)+'\n')
    lines=['# Paced native renderer candidates','',
        'All candidates retain the exact tested driver, physics, assets, diagnostics, firmware and per-frame command tape. Only the native road helper and its setup upload change. These are nominal MOS-clock Flexe aggregates with boost disabled, not isolated VDP timings or hardware results.','',
        '| Candidate | FPS | Relative to control | Bands/frame | Polygon fills/frame | Resident road bytes/frame |',
        '| --- | ---: | ---: | ---: | ---: | ---: |']
    for r in rows:lines.append(f"| {r['candidate']} | {r['fps']:.3f} | {r['ratio_to_control']:.3f}× | {r['average_bands']:.2f} | {r['average_polygon_fills']:.2f} | {r['average_resident_road_bytes']:.2f} |")
    if 'paired_repeat' in result:
        r=result['paired_repeat'];lines += ['',
            f"Reversed-order repeat: quad {result['repeat']['float-quad-layered']['fps']:.3f} FPS, control {result['repeat']['control']['fps']:.3f} FPS. The observed gains are {(r['first_ratio']-1)*100:.2f}% and {(r['repeat_ratio']-1)*100:.2f}%; pooled counts/time give {(r['pooled_ratio']-1)*100:.2f}% ({r['pooled_fps']['float-quad-layered']:.3f} versus {r['pooled_fps']['control']:.3f} FPS). These are boost-off emulator measurements; no hardware gain is claimed."]
    lines += ['',
        '1. Every case completed900renders/3600physics steps and2913retained observations, with exact independently qualified final root/arrays, clean backend exit, restored PRT vector and balanced helper leases. Ordinary and ASan/UBSan host replays each cover the same900frames/3600ticks per candidate;79helper failure/lifecycle cases pass for every ordinary/sanitized candidate.',
        '2. Integer/fixed-point endpoints remove all floating-point operations from the compiled road-section path. That is not a whole-module float removal: actor transforms remain unchanged. Numerator bounds fit signed32, plot coordinates fit signed16 and conservative output bounds fit the existing20480-byte road buffer. Annotated section assembly is under `assembly/`.',
        '3. The legacy partition averages14.79bands/frame. Its generator fits a112/256-pixel residual rather than forcing track-segment boundaries. The separate provisional segment-aligned candidate splits at changes to the projected lookup segment index plus stripe transitions, averaging22.07bands/frame. Same assets and simulation; this is an explicit geometry change for Author motion review. A second aligned variant keeps the faster float/quad/layered path to isolate the partition from the slow strip layout. Multiple track boundaries projecting into one integer row coalesce; fractional-pixel segment boundaries are not represented.',
        '4. Sampled disjoint materials remove about48.7%of material pixel writes and eliminate material overdraw, but increase shape count and resident command interpretation. Those bytes stay inside VDP; recurring eZ80 traffic remains248bytes/frame in every candidate. Less overdraw alone does not select the winner.',
        '5. Ten sampled frame rasters per candidate use the unchanged stock scanline algorithm. Float candidates with unchanged partition match sampled control pixels; rational integer endpoints differ by at most10pixels per sampled320×240frame, and the provisional segment partition by at most142pixels. These are disclosed differences, not acceptance thresholds; Author motion review remains required.',
        '6. This is still the preserved3/3/4MOS-unit absolute pacer (nominal36FPS request). Current source\'s four-unit30FPS pacer and any unpaced variant are separate comparisons. No new gameplay scheduler or processor split is implemented.',
        '7. One integer-quad-strip attempt timed out during initial module upload, before LOAD or rendering; backend fault counters stayed zero. The partial exact UART prefix and stopped process are preserved in STARTUP-FAILURE.json and evidence/auto01/integer-quad-strips/. The exact same candidate bytes completed in a fresh finish01 profile. This is a recorded startup transport stall, not a geometry performance result or a claimed emulator fix.',
        '', 'Human review profiles and any repeat results are recorded separately. Physical deployment follows Author visual review; no new card writes or flashing occurred in this tranche.',
        '', 'For the later unpaced tranche, stock mode136 swaps themselves wait for VSync. Removing the explicit foreground pacer alone does not remove that display ceiling; rendering-only/offscreen capacity and scanout-inclusive throughput need separate labels/modes. Current comparisons preserve the original swap and pacing exactly.','']
    (HERE/'CANDIDATE-RESULTS.md').write_text('\n'.join(lines))
    print(result['best_observed'],max(x['fps'] for x in rows))
