# R19-10 measurement précis

R19-10 remains unchecked in the root TODO. This document refines measurement
implementation within CONTRACT.md; it does not change its acceptance thresholds.
The complete frontend currently has correctness/control evidence only. Its
`startup_ticks` covers the selected Golem bootstrap upload/call/parser barrier,
after artwork loading, so it must not be reported as total application startup.

## Existing baseline and required separation

ORACLE.md and `measure_oracle.py` preserve the exact949f618 baseline binary and
normal-clock64-pose measurements. The old compute-only symbol span includes pose
setup/physics and bookkeeping; its cycles cannot directly prove50% scene-work
savings. The old submission result is a batch mean on a120 Hz clock, not a
per-frame median/p95. Its fixed diagnostic HUD costs17 bytes; the interactive
HUD needs separate accounting. None of these limitations should be hidden by
reusing the old field names for different Golem measurements.

The next matched benchmark needs separately identified spans for raw fixture
setup, pure scene preparation/packet construction, and submission including UART
waits. Keep pose preparation and physics out of the isolated scene-work span.
Use the existing accepted64-pose workload for both tracks, with warm resident
assets and serial ABBA, at least two samples per variant. Preserve the independently
identified original binary as a bridge for any minimally instrumented oracle.
No captures, builds or other probes should overlap the timing batch.

Guest120 Hz raw intervals can describe unpaced submission but have8.333 ms
quantization. They cannot alone establish when the final drawing reached the
visible page. GP acknowledgement establishes parser progress only. Keep raw
measurements, resolution and any observer overhead explicit; do not infer useful
CPU savings from packet byte counts or use SDL presents as game-frame counts.

## Read-only native completion observation candidate

Inspection of the pinned official Fab1.2.4 runtime source found potentially useful
exported native functions. Under
`AgonJukebox/.emulator/runtime/fab-1.2.4/src/vdp/userspace-vdp-gl/src/`:

1. `canvas.cpp:647`, `Canvas::swapBuffers`, queues the SwapBuffers primitive and
   calls `primitivesExecutionWait()`.
2. `dispdrivers/vgabasecontroller.cpp:812`, `VGABaseController::swapBuffers`, waits
   for userspace vblank, acquires the display lock and swaps viewport pointers.
3. `dispdrivers/vgapalettedcontroller.cpp:405`, `VGAPalettedController::swapBuffers`,
   invokes the base operation and updates the paletted scanout pointers.

The installed `vdp_platform.so` exports all three symbols, confirmed with `nm -D`.
A task-local Linux observer may be able to timestamp these calls/returns without
changing firmware or upstream source. This is a proposed diagnostic, not yet a
qualified rendering-completion measurement. It must verify the actual call path,
completed primitive counts and ordering against a finite known frame sequence,
and measure its overhead against the same workload without the observer. Avoid
disk I/O, allocation or framebuffer readback inside a timing hook; retain records
in bounded storage and write them after the run. Counting both base and derived
calls as separate frames would be incorrect. SDL presentation remains separate.

The existing heap observer in `memory_probe_linux.cpp` belongs to untimed memory
qualification. Do not mix its allocation tracking with performance results.
All runtime modules remain stock and hash-identified; all emulators are headless.
