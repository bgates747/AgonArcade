# Paced native renderer candidates

All candidates retain the exact tested driver, physics, assets, diagnostics, firmware and per-frame command tape. Only the native road helper and its setup upload change. These are nominal MOS-clock Flexe aggregates with boost disabled, not isolated VDP timings or hardware results.

| Candidate | FPS | Relative to control | Bands/frame | Polygon fills/frame | Resident road bytes/frame |
| --- | ---: | ---: | ---: | ---: | ---: |
| control | 14.839 | 1.000× | 14.79 | 130.14 | 1799.29 |
| float-tri-layered | 14.559 | 0.981× | 14.79 | 130.14 | 1799.29 |
| integer-tri-layered | 14.485 | 0.976× | 14.79 | 130.14 | 1799.29 |
| float-quad-layered | 15.661 | 1.055× | 14.79 | 65.07 | 1799.29 |
| integer-quad-layered | 15.181 | 1.023× | 14.79 | 65.07 | 1799.29 |
| float-tri-strips | 10.576 | 0.713× | 14.79 | 230.69 | 3156.73 |
| integer-tri-strips | 10.830 | 0.730× | 14.79 | 230.69 | 3156.73 |
| float-quad-strips | 11.558 | 0.779× | 14.79 | 115.35 | 3156.73 |
| integer-quad-strips | 11.666 | 0.786× | 14.79 | 115.35 | 3156.73 |
| integer-quad-segments | 9.299 | 0.627× | 22.07 | 167.81 | 4573.15 |
| float-quad-segments | 13.629 | 0.918× | 22.07 | 94.94 | 2605.75 |

Reversed-order repeat: quad 15.220 FPS, control 14.241 FPS. The observed gains are 5.54% and 6.88%; pooled counts/time give 6.22% (15.437 versus 14.534 FPS). These are boost-off emulator measurements; no hardware gain is claimed.

1. Every case completed900renders/3600physics steps and2913retained observations, with exact independently qualified final root/arrays, clean backend exit, restored PRT vector and balanced helper leases. Ordinary and ASan/UBSan host replays each cover the same900frames/3600ticks per candidate;79helper failure/lifecycle cases pass for every ordinary/sanitized candidate.
2. Integer/fixed-point endpoints remove all floating-point operations from the compiled road-section path. That is not a whole-module float removal: actor transforms remain unchanged. Numerator bounds fit signed32, plot coordinates fit signed16 and conservative output bounds fit the existing20480-byte road buffer. Annotated section assembly is under `assembly/`.
3. The legacy partition averages14.79bands/frame. Its generator fits a112/256-pixel residual rather than forcing track-segment boundaries. The separate provisional segment-aligned candidate splits at changes to the projected lookup segment index plus stripe transitions, averaging22.07bands/frame. Same assets and simulation; this is an explicit geometry change for Author motion review. A second aligned variant keeps the faster float/quad/layered path to isolate the partition from the slow strip layout. Multiple track boundaries projecting into one integer row coalesce; fractional-pixel segment boundaries are not represented.
4. Sampled disjoint materials remove about48.7%of material pixel writes and eliminate material overdraw, but increase shape count and resident command interpretation. Those bytes stay inside VDP; recurring eZ80 traffic remains248bytes/frame in every candidate. Less overdraw alone does not select the winner.
5. Ten sampled frame rasters per candidate use the unchanged stock scanline algorithm. Float candidates with unchanged partition match sampled control pixels; rational integer endpoints differ by at most10pixels per sampled320×240frame, and the provisional segment partition by at most142pixels. These are disclosed differences, not acceptance thresholds; Author motion review remains required.
6. This is still the preserved3/3/4MOS-unit absolute pacer (nominal36FPS request). Current source's four-unit30FPS pacer and any unpaced variant are separate comparisons. No new gameplay scheduler or processor split is implemented.
7. One integer-quad-strip attempt timed out during initial module upload, before LOAD or rendering; backend fault counters stayed zero. The partial exact UART prefix and stopped process are preserved in STARTUP-FAILURE.json and evidence/auto01/integer-quad-strips/. The exact same candidate bytes completed in a fresh finish01 profile. This is a recorded startup transport stall, not a geometry performance result or a claimed emulator fix.

Human review profiles and any repeat results are recorded separately. Physical deployment follows Author visual review; no new card writes or flashing occurred in this tranche.

For the later unpaced tranche, stock mode136 swaps themselves wait for VSync. Removing the explicit foreground pacer alone does not remove that display ceiling; rendering-only/offscreen capacity and scanout-inclusive throughput need separate labels/modes. Current comparisons preserve the original swap and pacing exactly.
