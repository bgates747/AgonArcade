# Complete-race FPS: matrix versus bitmap caching

The tested eight-slot prepared-bitmap cache **does not improve complete-race FPS**: **29.74 nominal MOS FPS**, versus **29.86 FPS** with cached affine (-0.39%). Bitmap regeneration and misses are included, with both caches cold on the first measured frame. These are complete racing scenes on Oryx Flexe, not reciprocals of isolated draw microseconds.

| Actor rendering method | Completed frames | MOS elapsed s | MOS FPS | PRT elapsed s | PRT FPS | MOS vs rebuild |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| rebuild | 1,800 | 68.750 | 26.18 | 71.159 | 25.30 | +0.00% |
| cached-affine | 1,800 | 60.283 | 29.86 | 62.373 | 28.86 | +14.04% |
| prepared-bitmap | 1,800 | 60.517 | 29.74 | 62.628 | 28.74 | +13.61% |
| additive | 1,800 | 53.833 | 33.44 | 55.712 | 32.31 | +27.71% |

Each row pools two900-frame runs by total frames/total elapsed, in forward then reverse case order. Elapsed MOS seconds=units/120; PRT seconds=counts/1000. Both clocks remain separately labelled emulator clocks. Native road spans, physics, player, complete panorama/HUD/footer/audio work, assets, exact guest and rendering/post-swap fences are common. Runtime and firmware are identical to the preceding full-race comparison.

| Order / method | Frames | MOS seconds | MOS FPS | PRT seconds | PRT FPS |
| --- | ---: | ---: | ---: | ---: | ---: |
| affab01 / rebuild | 900 | 34.067 | 26.42 | 35.271 | 25.52 |
| affab01 / cached-affine | 900 | 30.083 | 29.92 | 31.130 | 28.91 |
| affab01 / prepared-bitmap | 900 | 30.250 | 29.75 | 31.301 | 28.75 |
| affab01 / additive | 900 | 27.167 | 33.13 | 28.106 | 32.02 |
| affba01 / additive | 900 | 26.667 | 33.75 | 27.606 | 32.60 |
| affba01 / prepared-bitmap | 900 | 30.267 | 29.74 | 31.327 | 28.73 |
| affba01 / cached-affine | 900 | 30.200 | 29.80 | 31.243 | 28.81 |
| afffinish01 / rebuild | 900 | 34.683 | 25.95 | 35.888 | 25.08 |

## What was cached

1. `rebuild` is the preserved native-road-span control. It rebuilds each traffic/sign matrix before direct affine plotting. `cached-affine` writes only changed matrix coefficients and lets stock VDP retain the inverse; pixels are still transformed on each plot.

2. `prepared-bitmap` keeps at most one last transformed image per traffic identity and two sign slots. Its key includes source view/artwork, scale, reflection and translation. A miss executes stock transform-to-bitmap command40 inside that frame; a hit ordinarily plots the retained pixels. No pre-scaled files or timed scaled-pixel UART uploads are used. Every queued actor has a distinct image slot until the final frame fence.

3. Both caches reset on bind and again at render request3, the first timed frame. Two normal display-page warm renders remain common but cannot prepopulate the measured cache. The repeated command stream naturally includes all future misses and size/view changes.

4. `additive` is the preserved accepted sampler with byte-fill road spans. It is a fresh comparison control, not folded into either caching result.

## Cache activity and memory

These counts come from actual generated-C host replay of the same902 renders/3600ticks and independently decoded commands; they are not separately instrumented target telemetry. The full-frame emulated execution uses those exact target sources and counts all their work.

| Method | Timed actor draws | Matrix writes | Matrix reuses | Image generations | Image reuses |
| --- | ---: | ---: | ---: | ---: | ---: |
| cached-affine | 4,867 | 1,738 | 3,129 | 0 | 0 |
| prepared-bitmap | 4,867 | 1,738 | 129 | 1,867 | 3,000 |

The candidate generates 1,717,661 pixels during timed frames. Its logical retained-image peak is 22,400 bytes in this replay; the conservative eight-slot pixel bound is52,488bytes, plus a temporary replacement image and stock object/matrix metadata. Old image replacement is inside the measured path. Output IDs50710..50717 are already cleared by the unchanged shared guest at exit.

The cache hits are concentrated in small images: 61.64% of actor draws hit, but they represent only 16.82% of their natural transformed pixel area. All 263 draws at scaleQ8≥128 miss this last-image cache. This explains why a much faster prepared draw need not improve whole-race FPS: large changing images still pay generation plus plotting. This payload distribution is a workload explanation, not a measured phase-time attribution. A larger cache retaining multiple sizes is a different, untested policy.

Stock command40 uses its natural resize/translation border. The generated-C command audit verifies exact source, scale/reflection, placement, clipping and drawing order. Actual post-swap scene captures at frames300 and301 are pixel-identical to the rebuild control (100%); the Author moving visual gate remains separate. No road, camera, physics, traffic cadence or game code is optimized in this tranche.

## Qualification and limits

All8runs pass independent raw-protocol audit:900completed frames/3600physics ticks each,5624retained native replies each, exact final root/arrays, every frame/post-swap fence, timer restoration, unload0, zero backend faults and MOS return. Their timed UART streams are byte-identical (352,768 bytes). Ordinary and ASan/UBSan host replay agree; road pixels and player command buffers are identical to control, cache plans match an independent oracle, and lease/canary checks pass.

The last reverse-order rebuild control stalled before timing, after only LOAD token1. Its original raw streams are preserved and independently classified as a pre-INFO18 startup transport stall; it contributes no FPS. The original seven completed runs are retained, and a fresh identical rebuild control completes the comparison under a separate guard. Separate frame captures are excluded from all timing.

Original95°C thermal guard retained; session maximum63°C. Both SDL drivers are dummy; original boost1 restored, all owned emulators stopped. Historical baseline/source/evidence are untouched. No physical hardware FPS, autonomous120Hz headroom or monitor scanout is established. The original 4.4× isolated host draw ratio was not a game FPS result. New implementation/results remain uncommitted for Author moving visual review.
