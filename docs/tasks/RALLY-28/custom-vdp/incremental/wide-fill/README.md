# Wider road-span fills

Test whether writing four identical road pixels per aligned store improves the
accepted sampler fixture. The current control completes the moving pattern at
35.35nominal MOS FPS. Preserve that exact workload and compare fresh runs; this
proposal promises identical pixels, not a fourfold speedup. Author released the
tranche on2026-10-29 after requesting commit/push of all prior dirt first.

Root TODO owns INC-001-03. The bounded implementation covers:

1. **INC-001-03-01:** Checkpoint all existing code/evidence and this scope before
   implementation. Clone the accepted additive package/fixture into this silo;
   replace only the road-span fill primitive. Align actual destination addresses,
   retain byte prefixes/tails and respect C aliasing rules. Inspect target code
   for genuine32-bit stores and any unexpected helper calls.
2. **INC-001-03-02:** Qualify clipping, all byte alignments, short/empty spans,
   colours, row boundaries and canaries; compare actual generated-world replay
   and road pixels with the accepted control under ordinary and sanitizer builds.
   Keep actors/player, geometry, command lists, source physics, buffers/lifetimes,
   allocations, SDK/firmware and scheduler unchanged.
3. **INC-001-03-03:** Measure whole completion-fenced900-frame/3600-tick moving
   fixtures in both orders on Oryx. Driver/motion/artwork/runtime and every347-byte
   timed UART frame match. Separately measure isolated fill work with equal span
   inputs and disclose raw-counter/overhead limits. Do not enlarge a diagnostic
   enough to compromise admission of the existing workload.
4. **INC-001-03-04:** Preserve exact input/source/target/raw data, negative results
   and input-hash/PRT/stop/unload/MOS-exit/backend checks. Leave a fresh stopped
   sound-disabled review profile when useful. Return with new work uncommitted;
   hardware, affine audit, cache/composition and later optimizations are separate.

Every automated emulator run forces SDL_VIDEODRIVER=dummy and
SDL_AUDIODRIVER=dummy. Recheck host load/temperature, use the existing guarded
temporary boost disable and restore it after stopping owned emulators. Preserve
startup failures/thermal aborts and use fresh profiles for justified retries.
