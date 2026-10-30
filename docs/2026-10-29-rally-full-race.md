# 2026-10-29 — Full-race renderer comparison

The replacement fixture executes the maintained racing panorama, HUD/footer and
engine commands alongside native road, traffic, signs, player and finish
drawing. All 17 renderer cases completed 900 measured frames in each logical
order. Equivalent repeats give 14.45 nominal MOS FPS for the original renderer,
25.73 for native spans and 31.76 for the additive sampler. These are preliminary
Flexe results, with hardware and the Author's moving visual review still open.
The old static-drawing gain is specific to its flat-background fixture and does
not survive this corrected comparison.

1. **RACE-001-01 completed:** [variant inventory](tasks/RALLY-28/custom-vdp/full-race/VARIANTS.json)
   preserves 15 renderer configurations using 14 distinct native modules, plus
   two explicit input-identical aliases.
   Existing source, modules, firmware and historical evidence remain unchanged.
2. **RACE-001-02 completed:** the common real-eZ80 guest executes production
   scenery, race HUD and engine functions, rather than a prerecorded drawing
   stream. Two warmed pages, scrolling/edge repair, approaching/receding traffic,
   race fields, footer expiry and native finish output use the same sequence
   across every case. Admission occurs before mode 136/large graphics allocation.
   [Presentation and ownership](tasks/RALLY-28/custom-vdp/full-race/PRESENTATION.md).
3. **RACE-001-03 completed:** the main race retains the agreed centerline and
   no-damage policy while checking contacts. Separate completed coverage draws
   the maintained explosion, blink and recovery transition over 272 frozen-camera
   frames; captures show their clipping. Coverage is excluded from throughput
   and does not qualify a full collision/recovery scheduler.
4. **RACE-001-04 completed:** all 34 selected 900-frame/3600-tick runs pass. The
   [selection](tasks/RALLY-28/custom-vdp/full-race/COMPARISON-SELECTION.json)
   preserves 17 forward and 12 reverse successes from the original guard session,
   followed by the five remaining reverse cases in a new exclusive-host session.
   The interrupted attempt stays excluded; original receipts were not rewritten
   or copied into synthetic campaigns. Startup-only retries retain every raw
   failure and exact prefix. [Attempt history](tasks/RALLY-28/custom-vdp/full-race/DIAGNOSTIC-ATTEMPTS.md).
5. **RACE-001-05 completed:** independent native-world/array and command/reply
   checks, actual production-function host/sanitizer models, two-page panorama
   and HUD proofs, captured scenes, timer restoration and clean MOS return are
   preserved. All 34 timed outgoing command streams are identical 352,768-byte
   sequences. Baseline/additive frame 300 captures are pixel-identical.
   The pinned source/ELF audit fences synchronous raster work and page exchange,
   including swap/VSync and transport; it does not measure physical scanout or
   isolate raster CPU time. [Fence evidence](tasks/RALLY-28/custom-vdp/full-race/FRAME-COMPLETION-FENCE.md).
6. **RACE-001-06 completed:** [full results](tasks/RALLY-28/custom-vdp/full-race/RESULTS.md)
   retain all 17 paired rows and 34 original run references, with separate MOS/PRT
   clocks. Exact sources, inputs, firmware and raw returns are preserved in the
   new checked portable archive. Fresh silent review profiles are stopped on
   Oryx; [review instructions](tasks/RALLY-28/custom-vdp/full-race/HUMAN-REVIEW.md).
7. **RACE-001-07 remains open:** the Author reviews the corrected moving race
   and explicitly approves any later commit/push. No new optimization, hardware
   deployment or publication is released by these results.

Native-span aliases repeat 25.73 pooled MOS FPS; additive aliases repeat 31.76.
Their individual identical-input repeats vary by up to 7.07%. Wider word fills
give 31.87 pooled MOS FPS, only 0.35% above the four accepted additive byte-fill
runs, so they do not establish an improvement. Keep the accepted additive
sampler and byte fills. The corrected `static` case is exactly additive; the
corrected `split-clear` case is exactly span-native. Retaining production
panorama and changed-cell HUD state is common work, not invented baseline waste.
No general inefficiency of the built-in affine API follows from these results.

The original guard stopped on an external boost change after 2304.571 host seconds
with 29 successful selected cases. Its selected intervals used boost 0 and its
recorded peak was 64°C; cleanup restored original boost 1. The five-case exclusive
continuation took 358.939 host seconds, peaked at 60°C and restored its actual
original boost 0. All owned emulators are stopped. The Author and both previously
contacted agents were notified that Oryx is free. The two controller sessions
total 44.39 minutes including loading, retries and cleanup; preparation, diagnostics,
retrieval and reporting are separate. Future completion estimates should allow
roughly 45 minutes for a comparable full matrix, plus setup/retries.

All automated runs use both SDL dummy drivers and the original 95°C guard.
Host activity and the split reverse session limit timing inference. MOS 120 units/s
and PRT 1000 ticks/s remain separate nominal emulation clocks; their absolute FPS
values differ. Four native physics steps per unpaced render do not establish
an autonomous 120 Hz simulation or actual manual-player CPU headroom. No physical
card, firmware or startup file was modified. All new work remains uncommitted.

The Author subsequently reports “it looks good.” The moving visual gate is
accepted; [the separate acceptance receipt](tasks/RALLY-28/custom-vdp/full-race/HUMAN-ACCEPTANCE.json)
postdates the frozen archive and leaves its inputs/results unchanged. RACE-001-07
remains in rootTODO solely for explicit publication approval. No human-run logs
were fetched and no human timing was added to the benchmark. The proposed shorter
car draw distance remains a discussion candidate. The Author separately released
the isolated affine investigation, with all preparation/testing on Pi5 while
Oryx is unavailable.
