# RALLY-28 — Incremental renderer improvements

Remove confirmed recurring waste one change at a time, retaining the accepted
Native-span fixture as the control. Start with eliminating the redundant road
clear: it has a small implementation surface, a source-proven saving of 38,400
clear writes per frame, and needs no new firmware, ABI or numerical behavior.
Then address specialized sprite scaling, the strongest larger opportunity from
the audit. Every candidate needs completed-frame timing and correctness checks;
source-level savings alone do not establish a speedup.

The Author authorized this plan, an all-dirt commit/push before implementation,
then the first modification and headless Oryx Flexe comparison on 2026-10-28.
This remains under RALLY-28. Root `TODO.md` owns the immutable INC-001 task items.
The ordered work below describes those items; only INC-001-01 is released for
implementation in this tranche. [Findings](../../research/RENDERER-COST-FINDINGS.md)
distinguish confirmed costs, Wolf precedents and proposed experiments.

## Order and rationale

1. **INC-001-01 — Remove redundant road clearing.** Preserve sky and bottom-strip
   clearing, every road/actor/title command, physics, module, assets, swap and
   final rendering fence. Replace the single full-height clear with two clears
   around the fully opaque road rectangle. Include the extra command bytes and
   dispatch in the measured result; do not silently combine static-text or
   bottom-strip changes. This first experiment needs no compilation or upstream
   service change. Prove the removed region is overwritten before presentation
   and compare captured pixels and authoritative final state.
2. **INC-001-02 — Specialize car/sign scaling and reflection.** Profile the current
   Native-span candidate's actor path, then compare a clipped additive sampler
   with the general affine implementation. Compute increments once per object;
   handle clipping, alpha, mirrored orientation and view/livery selection. Retain
   the player as a separate fixed-size/startup-mirror case. Measure transparent
   padding and allocation costs. Explore opaque runs independently after the
   basic scaler. Prefer existing native buffer/bitmap facilities; negotiate any
   actually missing service with its owner before changing the ABI/firmware.
3. **INC-001-03 — Optimize span filling.** Compare aligned replicated-color word
   stores with the current byte loop, preserving endpoints and exact output.
   Handle short/unaligned prefixes and tails. Check emitted code and memory
   behavior; measure whole frames and the isolated phase, with no predicted
   store-width speedup treated as fact.
4. **INC-001-04 — Cache static work and bounded sprite sizes.** Initialize static
   text/lower-strip content on both pages and repaint only when required. Compare
   bounded pre-scaled and pre-mirrored assets for stock VDP ordinary plots as well
   as the native variant. Budget bitmap IDs, PSRAM, setup time and retained-page
   histories. Present size quantization/visual tradeoffs to the Author. Keep
   these separate from the exact first clear experiment.
5. **INC-001-05 — Consolidate per-frame synchronization.** Replace intermediate
   diagnostic round trips with a sequenced combined completion/status mechanism
   while retaining error/publication semantics, a final rendering fence and a
   rich diagnostic control. Count all commands/replies and measured waits. Keep
   simulation independent of rendering; do not combine scheduler changes with
   the protocol A/B or relabel the four-ticks/render fixture as gameplay pacing.
6. **INC-001-06 — Evaluate composition and copy removal.** If current phase costs
   justify it, compose actors with the road, skip transparent runs and investigate
   direct framebuffer access. Account for actors above y=104 and both pages.
   Accepted framebuffer services do not support this mode-136 path; any extension
   requires owner coordination and its own resource/lifecycle qualification.

After each independent A/B, retain the change only if the measured benefit and
motion result justify it. Keep negative results. Reorder later experiments when
new evidence changes their expected value. Carry applicable findings to every
compatible standard/native consumer under the existing POS/REUSE/VDP audits;
this first native-fixture experiment does not silently alter the standard game.

## First-tranche comparison contract

1. Freeze all current dirt and this scope in pushed Git commits before writing
   implementation. Preserve original untracked/dirty evidence and prior controls.
2. Create isolated control/candidate fixtures under this directory, derived from
   `throughput/.work/fixtures/native-span-native-fenced-unpaced`. Pin all source
   files and prove only the paint-clear payload plus its record length and
   explanatory metadata change. Never regenerate the historical fixture registry.
3. Keep 900 completed frames, 3,600 authoritative ticks, 2,913 retained replies,
   Native bitmap format, all other drawing, driver, assets, firmware/runtime,
   timers and final post-swap check identical. No foreground pacing is added.
4. Verify interval coverage/VDU state and actual pixels. Use the independent
   existing span proof and final-world reference; reject stale/corrupt input,
   failed replies, leaked resources, unrestored PRT vectors or backend faults.
   Preserve failures and retry only with fresh profiles and unchanged bytes.
5. Stage fresh Oryx profiles and compare control→candidate, then candidate→control
   on the same runtime and host boot. Reuse the established session supervisor
   for temporary boost disable/restore and thermal recording. Every automated
   launch forces both `SDL_VIDEODRIVER=dummy` and `SDL_AUDIODRIVER=dummy`.
6. Record complete nominal MOS/PRT frame durations separately and host elapsed
   time with its boundaries. Pool frames/elapsed time rather than averaging FPS;
   report pairwise variation and any setup/command-byte difference. Flexe does
   not establish physical ESP32 timing or the desired 60 Hz hardware result.
7. Return results, exact input identities, correctness evidence and remaining
   risks. Stop after this first modification/comparison. No hardware deployment,
   flash, interactive launch, later optimization, or post-implementation commit/
   push is implied; new emulator work remains for Author review/publication.
