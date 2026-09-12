# Application pacing removed, eZ80 still throttled

All application pacing and per-frame timing/waits have been removed from the
isolated rendering fixture. The emulator retains its normal 18.432 MHz eZ80
clock. Completed-batch results, including the final drain:

| Renderer | Oval FPS | Oval ms/frame | Fuji FPS | Fuji ms/frame |
| --- | ---: | ---: | ---: | ---: |
| Full road, fixed bands | 8.57 | 116.67 | 9.95 | 100.52 |
| Pavement only | 13.94 | 71.74 | 16.34 | 61.20 |
| VDP-resident sections | 29.65 | 33.72 | 29.88 | 33.46 |

The section renderer is still approximately **2.0× the 16.67 ms budget**, or
16.8–17.1 ms over it. There is no application 30 Hz limiter in these binaries.
This result does not establish the renderer's maximum throughput independently
of the emulator's swap path.

## A second limit found in the emulator

Read-only inspection of the installed Fab 1.2.4 native VDP source identifies
**two consumptive vertical-blank waits per ordinary buffer swap**:

1. `userspace-vdp-gl/src/canvas.cpp:647`, `Canvas::swapBuffers()`, calls
   `addPrimitive(SwapBuffers)` and then `primitivesExecutionWait()`.
2. `displaycontroller.cpp:540`, `addPrimitive()`, executes that primitive
   synchronously in this userspace adapter; its queued implementation is
   disabled with `#if 0`.
3. The swap reaches `dispdrivers/vgabasecontroller.cpp:812`, where the userspace
   path calls `waitVblank()` before exchanging the buffers.
4. Returning to `Canvas::swapBuffers()`, `primitivesExecutionWait()` at
   `displaycontroller.cpp:636` calls `waitVblank()` again under `USERSPACE`.
5. `waitVblank()` at `displaycontroller.cpp:466` consumes an atomic boolean
   signal by changing true to false. The two calls therefore need separate
   signals. `rust_glue.cpp:35` supplies those signals; its mode refresh reporting
   and the host presentation loop use 60 Hz for this mode.

These paths live under the read-only runtime's `src/vdp/`. The eZ80 SDK's
`libvdp/vdp_swap.c` itself only sends `23,0,0xC3`; it adds no CPU-side delay.
Two refresh events per swap explain a roughly 30 swaps/sec ceiling and are
consistent with the measured section results. This is source evidence, not a
patched-driver A/B experiment or an isolated measurement of raster work. The
native adapter differs from the embedded non-USERSPACE implementation, so
this is not evidence of an equivalent hardware limit. No VDP/emulator source,
firmware module or pacing behavior was changed by this investigation.

This also qualifies the earlier unlimited-CPU interpretation: those earlier
binaries had an explicit 30 Hz application cap, but reaching 30 FPS did not
separate that cap from this additional native swap-path limit. Their large
speedup still demonstrates sensitivity to eZ80 execution speed.

## Validation and measurement scope

1. Twelve serial headless runs: full/pavement/sections/sections/pavement/full
   on each track, 64 measured poses per run and two warm-ups outside the batch.
   All 768 frames and 4,608 traffic draws complete; all 12 final completion
   checks succeed. There are no per-frame completion checks.
2. Pose hashes and road-byte totals match the corresponding earlier fixtures
   exactly. Both repeats of each case reproduce their byte counts. The actual
   process command line is recorded and checked for absence of unlimited CPU
   flags. Runtime/firmware and each binary have SHA-256 identities.
3. Clock reads exist only at batch boundaries. Final drain is 16.67 ms for
   eleven runs and 33.33 ms for one, included in completed-batch throughput.
   These are entire-batch drain costs, not per-frame waits.
4. One-minute host load is 2.44–3.90. Results retain both runs, not only the
   fastest sample. Clock resolution remains two raw ticks / 16.67 ms, averaged
   over the 64-frame batches.
5. Existing road, pacing and band sanitizer tests pass for all three builds;
   focused pavement/section tests pass in their respective builds. The source
   generator checks for absence of clock/wait/deadline calls in the hot path.
   All original mainline source/assets/binary fingerprints remain unchanged.
6. Physics and keyboard sampling are omitted from this fixed-pose rendering
   benchmark. The counters and pose hash remain for validation. These figures
   are not normal-gameplay FPS, physical-display FPS or isolated VDP raster
   timings. Native visual behavior of the unchanged renderers was qualified
   in the preceding task; this run adds throughput/stream-completion evidence.

[Full table](table.md), [summary](summary.json), [manifest](manifest.json), raw
CSVs and build/test logs are alongside this document. Implementation and
reproduction commands are in the [task bucket](../README.md).
