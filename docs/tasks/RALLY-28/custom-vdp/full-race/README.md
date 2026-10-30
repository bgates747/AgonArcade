# Complete race presentation comparison

Compare renderer variants while showing the actual race presentation, including
scrolling panorama, road, traffic, signs, player, finish markings, race HUD and
footer, plus the real engine command workload with silent host audio. Previous
flat-background results remain preserved as renderer-only evidence; their gains
must not be presented as full-race gains.

All 34 selected runs now pass independent raw checks. Equivalent repeats give
14.45 baseline,25.73 native-span and 31.76 additive nominal MOS FPS. The old static
gain does not transfer; word fills do not establish a gain beyond repeat
variation. [Full17-case results](RESULTS.md) retain both logical orders and all
original run references. [Review the stopped profiles](HUMAN-REVIEW.md) on Oryx;
all owned emulators are stopped and the host is free. Hardware is untested.

The Author directly releases this replacement fixture and all comparative runs.
Root TODO owns RACE-001. Preserve all existing dirt and historical inputs; no
commit/push is requested by this release. All automated runs remain truly
headless: SDL video/audio dummy, existing95°C guard, temporarily disabled boost
restored after owned processes stop. No physical deployment or firmware change.

RACE-001-01–06 below are completed historical scope, recorded with evidence in
[the dated log](../../../../2026-10-29-rally-full-race.md). Root TODO now retains
only RACE-001-07 for Author moving visual review and explicit publication approval.

1. **RACE-001-01:** inventory the maintained race drawing and frozen module
   lineage. Use a common production presentation and identical deterministic
   motion, camera, race/HUD state and completion checks across every variant.
   No diagnostic title or attract panel may substitute for the racing view.
2. **RACE-001-02:** build a common real eZ80 guest that executes maintained
   scenery/HUD/audio production each frame. Keep the frozen native module ABI;
   include all command transfer/backpressure and completion fencing. Generate
   variant-specific inputs without rebuilding geometry/samplers unless required
   for an explicitly documented compatibility fix. Maintain finite self-created
   result/state/clock/transport files and clean return to MOS.
3. **RACE-001-03:** use the existing no-damage deterministic driving policy for
   the main comparison, with approaching/receding traffic. Include maintained
   crash/recovery drawing in separate shared coverage scenes, rather than leave
   an untested effect hook. Clearly separate those diagnostics from throughput.
4. **RACE-001-04:** compare all 17 preserved native renderer variants: original
   baseline, ten earlier road variants, RGBA and Native span formats, split
   clear, additive sampler, rejected wider fill, and corrected static drawing.
   Same900 completed frames/3600 native physics ticks, unpaced foreground, stock
   swap and post-swap completion fence; sweep forward then reverse sequentially.
   Keep per-run MOS/PRT/host clocks and failures separately. Allow slower cases
   an appropriate bounded timeout while keeping the original thermal guard.
5. **RACE-001-05:** validate full state, all commands/replies, presentation
   coverage, scrolling/page repair, HUD erasure and scene captures. Production
   HUD and panorama retention are common, not invented baseline waste. Any old
   optimization that becomes redundant is reported as redundant, not assigned
   a fabricated gain. No row is assumed constant merely because it was blank
   in the old fixture.
6. **RACE-001-06:** report the fair full-race comparison, preserve portable exact
   inputs/source/raw outputs and leave a stopped silent visual review profile.
   Author moving review is the final appearance gate; new work uncommitted.

Stock buffered-row/matrix microbenchmarks and Wolf comparisons are separate
diagnostics/reference engines, not interchangeable native race renderer cases.
Their historical timings are not pooled into this comparison. A finite four-
physics-steps/render fixture does not establish autonomous 120 Hz gameplay or
physical frame rate. Scrolling scenery must repaint when needed in every case.

The final common guest is33116db786ef08033a3c5aa3404a7d5ed8411013af9b70ac27051ddd1ade53e9.
`DIAGNOSTIC-ATTEMPTS.md` records every preparation/startup exclusion.
`FRAME-COMPLETION-FENCE.md` establishes actual raster completion and page exchange
from the pinned source and firmware ELF; it does not claim physical scanout.
The bounded host-only fresh-profile retry controller preserves startup failures
without changing guest inputs, runtime, command stream or the original guard.
