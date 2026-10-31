"""FPS-first full-race cache results. Pool by total frames/total time."""
from pathlib import Path
import hashlib,json
HERE=Path(__file__).resolve().parent
ORDER=('rebuild','cached-affine','prepared-bitmap','additive')
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()

def main():
    audit=json.loads((HERE/'RAW-AUDIT.json').read_text());assert audit['passed']
    host=json.loads((HERE/'HOST-ordinary.json').read_text());assert host['passed']
    rows=audit['rows'];pooled={}
    for name in ORDER:
        selected=[r for r in rows if r['case']==name];assert len(selected)==2
        frames=sum(r['frames'] for r in selected);mos=sum(r['nominal_mos_units'] for r in selected);prt=sum(r['nominal_prt_ticks'] for r in selected)
        pooled[name]=dict(frames=frames,mos_units=mos,mos_seconds=mos/120,mos_fps=frames*120/mos,
            prt_ticks=prt,prt_seconds=prt/1000,prt_fps=frames*1000/prt,
            mos_range=[min(r['nominal_mos_fps'] for r in selected),max(r['nominal_mos_fps'] for r in selected)])
    for name,row in pooled.items():
        row.update(mos_vs_rebuild_percent=(row['mos_fps']/pooled['rebuild']['mos_fps']-1)*100,
            mos_vs_cached_affine_percent=(row['mos_fps']/pooled['cached-affine']['mos_fps']-1)*100)
    data=dict(passed=True,metric='Completed race frames divided by elapsed time; MOS and PRT separate nominal clocks',
        pooled=pooled,runs=rows,cache_counts_host_replay=host['cache_counts'],
        caches_start_cold_at_first_timed_frame=True,bitmap_generation_and_misses_inside_measured_frames=True,
        memory_policy='Eight last-image slots, not all sizes. Pixel payload worst bound 6*99*75+2*63*63=52488B; plus transient replacement and object/matrix metadata',
        physical_fps_qualified=False,visual_acceptance_pending=True,source_sha256={n:sha(HERE/n) for n in ['RAW-AUDIT.json','HOST-ordinary.json','HOST-sanitized.json','BUILD.json','FIXTURES.json','CACHE-DISTRIBUTION.json','CAPTURE-COMPARISON.json','FINAL-CONTROL.json']})
    (HERE/'RESULTS.json').write_text(json.dumps(data,indent=2)+'\n')
    cache_gain=pooled['prepared-bitmap']['mos_vs_cached_affine_percent']
    text=['# Complete-race FPS: matrix versus bitmap caching','',
        f'The tested eight-slot prepared-bitmap cache **does not improve complete-race FPS**: **{pooled["prepared-bitmap"]["mos_fps"]:.2f} nominal MOS FPS**, versus **{pooled["cached-affine"]["mos_fps"]:.2f} FPS** with cached affine ({cache_gain:+.2f}%). Bitmap regeneration and misses are included, with both caches cold on the first measured frame. These are complete racing scenes on Oryx Flexe, not reciprocals of isolated draw microseconds.','',
        '| Actor rendering method | Completed frames | MOS elapsed s | MOS FPS | PRT elapsed s | PRT FPS | MOS vs rebuild |',
        '| --- | ---: | ---: | ---: | ---: | ---: | ---: |']
    for name in ORDER:
        r=pooled[name];text.append(f'| {name} | {r["frames"]:,} | {r["mos_seconds"]:.3f} | {r["mos_fps"]:.2f} | {r["prt_seconds"]:.3f} | {r["prt_fps"]:.2f} | {r["mos_vs_rebuild_percent"]:+.2f}% |')
    text+=['','Each row pools two900-frame runs by total frames/total elapsed, in forward then reverse case order. Elapsed MOS seconds=units/120; PRT seconds=counts/1000. Both clocks remain separately labelled emulator clocks. Native road spans, physics, player, complete panorama/HUD/footer/audio work, assets, exact guest and rendering/post-swap fences are common. Runtime and firmware are identical to the preceding full-race comparison.','',
        '| Order / method | Frames | MOS seconds | MOS FPS | PRT seconds | PRT FPS |','| --- | ---: | ---: | ---: | ---: | ---: |']
    for r in rows:text.append(f'| {r["campaign"]} / {r["case"]} | {r["frames"]} | {r["nominal_mos_units"]/120:.3f} | {r["nominal_mos_fps"]:.2f} | {r["nominal_prt_ticks"]/1000:.3f} | {r["nominal_prt_fps"]:.2f} |')
    text+=['','## What was cached','',
        '1. `rebuild` is the preserved native-road-span control. It rebuilds each traffic/sign matrix before direct affine plotting. `cached-affine` writes only changed matrix coefficients and lets stock VDP retain the inverse; pixels are still transformed on each plot.','',
        '2. `prepared-bitmap` keeps at most one last transformed image per traffic identity and two sign slots. Its key includes source view/artwork, scale, reflection and translation. A miss executes stock transform-to-bitmap command40 inside that frame; a hit ordinarily plots the retained pixels. No pre-scaled files or timed scaled-pixel UART uploads are used. Every queued actor has a distinct image slot until the final frame fence.','',
        '3. Both caches reset on bind and again at render request3, the first timed frame. Two normal display-page warm renders remain common but cannot prepopulate the measured cache. The repeated command stream naturally includes all future misses and size/view changes.','',
        '4. `additive` is the preserved accepted sampler with byte-fill road spans. It is a fresh comparison control, not folded into either caching result.','',
        '## Cache activity and memory','',
        'These counts come from actual generated-C host replay of the same902 renders/3600ticks and independently decoded commands; they are not separately instrumented target telemetry. The full-frame emulated execution uses those exact target sources and counts all their work.','',
        '| Method | Timed actor draws | Matrix writes | Matrix reuses | Image generations | Image reuses |','| --- | ---: | ---: | ---: | ---: | ---: |']
    for name,c in host['cache_counts'].items():text.append(f'| {name} | {c["draws"]:,} | {c["matrix_misses"]:,} | {c["matrix_hits"]:,} | {c["bitmap_misses"]:,} | {c["bitmap_hits"]:,} |')
    c=host['cache_counts']['prepared-bitmap']
    distribution=json.loads((HERE/'CACHE-DISTRIBUTION.json').read_text())
    text+=['',f'The candidate generates {c["generated_pixels"]:,} pixels during timed frames. Its logical retained-image peak is {c["logical_peak_retained_pixels"]:,} bytes in this replay; the conservative eight-slot pixel bound is52,488bytes, plus a temporary replacement image and stock object/matrix metadata. Old image replacement is inside the measured path. Output IDs50710..50717 are already cleared by the unchanged shared guest at exit.','',
        f'The cache hits are concentrated in small images: {distribution["hit_draw_percent"]:.2f}% of actor draws hit, but they represent only {distribution["hit_natural_pixels_percent"]:.2f}% of their natural transformed pixel area. All {distribution["stats"]["miss"]["large_draws"]} draws at scaleQ8≥128 miss this last-image cache. This explains why a much faster prepared draw need not improve whole-race FPS: large changing images still pay generation plus plotting. This payload distribution is a workload explanation, not a measured phase-time attribution. A larger cache retaining multiple sizes is a different, untested policy.', '',
        'Stock command40 uses its natural resize/translation border. The generated-C command audit verifies exact source, scale/reflection, placement, clipping and drawing order. Actual post-swap scene captures at frames300 and301 are pixel-identical to the rebuild control (100%); the Author moving visual gate remains separate. No road, camera, physics, traffic cadence or game code is optimized in this tranche.','',
        '## Qualification and limits','',
        f'All8runs pass independent raw-protocol audit:900completed frames/3600physics ticks each,5624retained native replies each, exact final root/arrays, every frame/post-swap fence, timer restoration, unload0, zero backend faults and MOS return. Their timed UART streams are byte-identical ({audit["timed_uart_bytes"]:,} bytes). Ordinary and ASan/UBSan host replay agree; road pixels and player command buffers are identical to control, cache plans match an independent oracle, and lease/canary checks pass.','',
        'The last reverse-order rebuild control stalled before timing, after only LOAD token1. Its original raw streams are preserved and independently classified as a pre-INFO18 startup transport stall; it contributes no FPS. The original seven completed runs are retained, and a fresh identical rebuild control completes the comparison under a separate guard. Separate frame captures are excluded from all timing.', '',
        f'Original95°C thermal guard retained; session maximum{audit["session"]["maximum_celsius"]:.0f}°C. Both SDL drivers are dummy; original boost{audit["session"]["original_boost"]} restored, all owned emulators stopped. Historical baseline/source/evidence are untouched. No physical hardware FPS, autonomous120Hz headroom or monitor scanout is established. The original 4.4× isolated host draw ratio was not a game FPS result. New implementation/results remain uncommitted for Author moving visual review.']
    (HERE/'RESULTS.md').write_text('\n'.join(text)+'\n')
    print(json.dumps(pooled,indent=2))

if __name__=='__main__':main()
