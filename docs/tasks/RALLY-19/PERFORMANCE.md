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

1. `canvas.cpp:647`, `Canvas::swapBuffers`, passes a SwapBuffers primitive to
   `addPrimitive` and calls `primitivesExecutionWait()`.
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

## Native execution-path detail and first probe

Further source inspection matters here: native `displaycontroller.cpp:540`
compiles out the queued path and executes primitives synchronously in
`addPrimitive`. Its `primitivesExecutionWait` calls userspace `waitVblank`.
Thus Canvas return includes a further wait after the actual viewport-pointer
swap. The two timestamps describe distinct milestones; neither is an SDL present.

The first task-local observer records both Canvas and paletted-controller call
entry/return, using bounded static storage and clock/atomic operations only in
the hot hooks. It resolves symbols during warmup and flushes after the entire
guest batch/report. The initial exact-oracle run produced68 nested calls of each
kind, failing the harness's predicted67. This is explained by stock
`vdu.h:300` (`vdu_mode`): entering a double-buffered mode internally swaps once
to clear the other page. The accepted diagnostic then explicitly swaps once,
warms twice and renders64 workload poses. The initial sources/logs are preserved
in `evidence/golem-swap-observer/initial-oval`; subsequent checks must require all
68 operations and must not count the mode initialization as a game frame.

This tests event identity/order only. Observer overhead, controls without the
observer, per-stage guest work and matched candidate timing remain unqualified.

The corrected `mode-count-oval` and `mode-count-fuji` runs both pass: each has
68 Canvas calls and68 paletted-controller calls, monotonically ordered ordinals
and strict entry/return nesting. Each unchanged guest reports64 poses,384 traffic
draws and its original per-track state hash. Runtime inputs remain unchanged.
The observer sees actual native swap functions through the original module;
it does not supply replacement graphics operations or a firmware callback.

```sh
.venv/bin/python docs/tasks/RALLY-19/probe_swaps.py NEW-oval --track oval
.venv/bin/python docs/tasks/RALLY-19/probe_swaps.py NEW-fuji --track fuji
```

This is a partial R19-10 checkpoint. Before using observer timestamps to accept
performance, qualify overhead against serial identical runs without preload,
retain guest raw intervals and separate steady completed-frame intervals from
the first frame's host marker handshake. CPU scene-work measurements still need
their own bounded symbol spans; neither native wall intervals nor a GP reply
alone supplies them.
