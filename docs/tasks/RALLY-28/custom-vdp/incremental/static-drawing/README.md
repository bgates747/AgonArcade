# Retain static drawing on both pages

Avoid repainting unchanged text and the lower strip every frame. Initialize
both display pages correctly, preserve all moving content, then compare completed
frames with the accepted additive sampler and byte road fills. This is the first
bounded part of INC-001-04; bitmap-size caching remains a separate proposal.

The completed candidate improves matched throughput35.95→42.77nominal MOS FPS
(+18.97%) with unchanged module/physics/driver and exact scenes on both parities.
[Results](RESULTS.md) and a [stopped review profile](HUMAN-REVIEW.md) are ready;
new work remains uncommitted pending Author moving review. Hardware untested.

The Author released this tranche with “commit and push any dirt, then proceed”
on2026-10-29. Freeze all existing wider-fill results, its rejection and this
scope before implementation. Root `TODO.md` owns the actionable subtask IDs.

1. **INC-001-04-01:** preserve the accepted exact moving fixture as control.
   Identify invariant draw commands and which pixels each physical page can
   retain. Keep the accepted module/driver/artwork/motion/physics/runtime/fences
   unchanged. No wider-fill candidate is adopted.
2. **INC-001-04-02:** derive an isolated tape-only candidate, moving invariant
   title/lower-strip setup before timing and initializing both pages. Preserve
   graphics/text state, clipping, draw order, swap phase and clean MOS return.
   Audit sky clearing against actual moving actor/sign bounds; retain clears
   where needed to erase old content. No new dirty-region algorithm is implied.
3. **INC-001-04-03:** prove control/candidate two-page equality over the actual
   deterministic motion, including first use of each page and prior actor dirt.
   Account for setup swaps, added initialization bytes and reduced hot-loop
   bytes. Keep actual world/commands apart from fixed presentation differences;
   use independent raw command/reply checks and preserve all old inputs.
4. **INC-001-04-04:** run fresh control/candidate then reversed-order900-frame/
   3600-tick completed-frame comparisons under the existing silent Oryx runner.
   Keep PRT/MOS/host clocks separate and do not infer physical timing. Before
   each session recheck competing jobs/temperature; use both SDL dummy drivers,
   original95°C guard and temporary boost disable/restoration. Preserve failures.
5. **INC-001-04-05:** preserve exact fixtures/source/raw results and portable
   archive. Leave a fresh stopped, sound-disabled candidate review profile if
   correctness passes. Return for Author visual review with new work uncommitted.
   No physical test, bitmap caching, affine audit, synchronization consolidation
   or later optimization is included in this release.

The comparison includes the reduced UART traffic and dispatch work as part of
the optimization. It retains900 renders,3600 authoritative physics steps,
2913 retained replies, all completion checks and stock swap/VSync. Static work
moved into setup is measured in bytes and reported separately, not hidden in a
claim about total startup cost. This fixture is not an independent physics
scheduler or the full playable game.
