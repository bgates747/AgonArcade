# Full-race affine and prepared-bitmap comparison

Measure completed race frames per second with matrix reuse and prepared-bitmap
reuse on the same deterministic racing scene. Bitmap generation, cache misses,
command dispatch and final graphics completion belong inside the measured run.
Prior isolated host times establish no full-game FPS result.

The Author released this comparison on 2026-10-30 after requiring all dirt to be
committed and pushed. The starting checkpoint is fa7932d (preceded by static
checkpoint a3a1ddc and full-race checkpoint 059f1f7), all pushed to main. Root
TODO owns the immutable work IDs below; this document defines their scope.

1. AFF02-01: preserve the 900-frame full-race guest, scrolling panorama, HUD,
   footer, audio commands, native road spans, player, deterministic moving traffic,
   four physics ticks/frame, native ABI, firmware, runtime and completion fences.
   Build isolated actor-only variants: inherited matrix rebuilding, unchanged
   matrix reuse, bounded prepared-bitmap reuse, and accepted additive sampler.
2. AFF02-02: qualify actual generated C against the frozen final world and actor
   command plans. Matrix cache keys include matrix ID and all coefficients;
   bitmap keys also include original artwork. Use eight retained output slots,
   at most one per drawn actor, so queued objects cannot overwrite one another.
   Account for cold misses, size/view/reflection changes, retained memory and
   stock command40 natural output edges. No pre-scaled files or pixel uploads.
3. AFF02-03: stage fresh Oryx profiles with exact shared guest/motion/assets and
   the same runtime/firmware as the prior full-race comparison. Run silent
   guarded smoke, then all cases in forward and reverse order. Both SDL drivers
   dummy, original95°C limit, temporary boost0 and actual original restoration.
   Preserve any startup failures and restrict fresh retries to pre-timing stalls.
4. AFF02-04: lead results with frames, elapsed MOS/PRT time, separate FPS and
   changes versus matched controls. Independently check final world, replies,
   UART intervals, backend/timer/exit and source/input identity. Preserve exact
   results, leave emulators stopped and return for Author visual review. No
   hardware operation, firmware change or post-tranche publication is released.

This is a bounded last-image cache per traffic identity and sign draw slot,
not an unlimited table of all sizes. Cache state resets on renderer bind. Every
miss generates the image through stock transform-to-bitmap commands during the
frame. Native sampler remains a separate control; the game is not changed.
