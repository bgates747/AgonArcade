# Wider road-span fills

The aligned-store experiment is complete. It preserves exact output and reduces
the separate fill replay's raw emulated counter cost, but establishes no
whole-frame speedup. Keep the accepted additive sampler with its byte fill.
[Results](RESULTS.md) preserve the negative comparison and its limits.

The Author released this tranche on2026-10-29 after requesting commit/push of
all prior dirt first. Checkpoint `84fa64d` was pushed before implementation.

Root TODO owns INC-001-03. The bounded implementation covers:

- **INC-001-03-01** [x] — Checkpoint all existing code/evidence and this scope before
   implementation. Clone the accepted additive package/fixture into this silo;
   replace only the road-span fill primitive. Align actual destination addresses,
   retain byte prefixes/tails and respect C aliasing rules. Inspect target code
   for genuine32-bit stores and any unexpected helper calls.
- **INC-001-03-02** [x] — Qualify clipping, all byte alignments, short/empty spans,
   colours, row boundaries and canaries; compare actual generated-world replay
   and road pixels with the accepted control under ordinary and sanitizer builds.
   Keep actors/player, geometry, command lists, source physics, buffers/lifetimes,
   allocations, SDK/firmware and scheduler unchanged.
- **INC-001-03-03** [x] — Measure whole completion-fenced900-frame/3600-tick moving
   fixtures in both orders on Oryx. Driver/motion/artwork/runtime and every347-byte
   timed UART frame match. Separately measure isolated fill work with equal span
   inputs and disclose raw-counter/overhead limits. Do not enlarge a diagnostic
   enough to compromise admission of the existing workload.
- **INC-001-03-04** [x] — Preserve exact input/source/target/raw data, negative results
   and input-hash/PRT/stop/unload/MOS-exit/backend checks. Leave a fresh stopped
   sound-disabled review profile when useful. Return with new work uncommitted;
   hardware, affine audit, cache/composition and later optimizations are separate.

Every automated emulator run forces SDL_VIDEODRIVER=dummy and
SDL_AUDIODRIVER=dummy. Recheck host load/temperature, use the existing guarded
temporary boost disable and restore it after stopping owned emulators. Preserve
startup failures/thermal aborts and use fresh profiles for justified retries.

Both full-frame orders passed; the pooled nominal MOS result is37.00→36.33FPS
(-1.82%), with opposite-sign pairs. The phase result is52.65% fewer raw CCOUNT
units in a separate no-physics/no-drawing replay; its Oryx run overlapped other
CPU work. These are emulator observations, not physical frame rates or cycles.
No fresh visual profile is needed to promote an unproven improvement: the
candidate is preserved as an experiment, and the accepted review profile remains
unchanged. New implementation/evidence is uncommitted for Author review.
