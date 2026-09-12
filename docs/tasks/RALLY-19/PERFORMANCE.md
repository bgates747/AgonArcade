# R19-10 measurement précis

## Later physical result — read before interpreting the native benchmarks

The corrected production game reached120 logged root-call returns on a physical
ESP32 with the stock4096-byte task-stack size, without a panic in that capture.
Calls3 through120 took approximately98.68 seconds between host UART arrivals:
about1.186 resident-call returns/second. This is sparse diagnostic timing, not
a scanout observer or official-release performance qualification. Nevertheless,
it confirms the Author's visibly slow hardware result survives the compiler's
stack correction. Full evidence and subsequent official-firmware restoration
are in HARDWARE-DEBUG.md. R19-10's native pass does not establish a practical
hardware speedup. Final-asset native measurements remain to be requalified.

After independently verified restoration of official VDP2.16.0, the Author used
the board reset button and confirmed the game continues running slowly. Therefore
the visible slowdown also occurs without our diagnostic firmware. This was not
a cold power cycle, nor a timed official-release benchmark. The production game
contains no fencing, performance counters or logging. See the recorded acceptance
scope in `evidence/hardware-production/official-inline-restore/acceptance.json`.

The Author's circle example correctly distinguishes command delivery from native
drawing work. Stock streamed and buffered execution both dispatch bytes through
`vdu(readByte())`; buffering does not introduce a faster circle rasterizer.
See the [pinned stock stream processor](https://github.com/AgonPlatform/agon-vdp/blob/c7ac293d2aa81ddfa693390549bcd909069c8fc3/video/vdu_stream_processor.h)
and [buffer call implementation](https://github.com/AgonPlatform/agon-vdp/blob/c7ac293d2aa81ddfa693390549bcd909069c8fc3/video/vdu_buffered.h).
Stored batches can save UART traffic and eZ80 command construction. Overall
speed improves only when those savings outweigh added interpreter work and
matter to the application's bottleneck. Any benefit from a native bulk matrix
operation comes from that native operation, not from storing its invocation.

Rally's current scalar/matrix/byte-manipulation lowering adds substantial
interpretation and buffer access to move arithmetic off the eZ80. The physical
result rejects an assumption that this implementation is a useful accelerator.
It does not prove every possible lowering or native bulk operation is unhelpful;
such alternatives need their own physical measurements before further claims.
No unmeasured optimisation is approved or promised by this note. The original
frozen criteria remain unchanged, and hardware performance is reported separately.

## Original measurement design and historical evidence

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

## Observer overhead qualification

`measure_swap_overhead.py initial` ran eight serial exact-oracle workloads, ABBA
per track with A=plain and B=observed, preparing all profiles and building the
observer before timing. Actual process arguments confirm normal CPU limiting;
there were no concurrent emulators, builds or captures. Source/runtime inputs
remained unchanged. Each batch has64 poses,384 traffic draws, matching track
state hashes and exact expected road-byte totals. Each observed run also retains
136 strictly nested events and63 steady completed-frame intervals; the first
transition includes the host go-marker handshake and is explicitly excluded.

| Track | Plain mean batch ticks | Observed mean batch ticks | Difference |
| --- | ---: | ---: | ---: |
| Oval |254|252|-0.7874%|
| Fuji |253|254|+0.3953%|

The120 Hz guest batch clock is quantized at8.333 ms. Both pass the diagnostic's
5% absolute-effect guard; these small differences are not evidence of a real
observer speedup. See `evidence/golem-swap-overhead/initial/results.json`, raw
CSV intervals and per-run manifests. This qualifies the method on these finite
oracle runs; it does not satisfy the Golem speedup or full-scene latency targets.

## Next concrete CPU measurement construction

Keep the R19-09 frontend source and qualified bootstraps intact. A separate
task-local benchmark build can replace only its diagnostic function/option guard,
using the exact same raw pose/physics setup and renderer functions. Reuse the
qualified `.vdp` bytes and identify the distinct benchmark binary. Preserve an
independent bridge to the untouched accepted oracle's64-pose state hashes, byte
totals and timing; instrumented oracle code is not automatically the original
binary. Prebuild all variants before serial timing.

For isolated eZ80 work, the diagnostic uses GNU linker wraps of `_mos_puts` and
`_putch`. The installed agondev uses `ez80-none-elf-ld`; its
`config/makefile.inc` puts linker options in LINKERFLAGS/LINKERLIBFLAGS (not a
generic LDFLAGS variable). The SDK signature is
`void mos_puts(const char *, uint24_t, char)` and `int putch(int)`. A separately
compiled CPU-only variant forwards normally during bootstrap and suppresses UART
output inside a finite measured scene-generation span. This retains original
geometry, command construction, branch decisions, HUD and swap construction,
while avoiding driver/backpressure waits in the work measurement. Do not enable
that suppression in the rendering/latency benchmark.

Native per-pose byte accounting and source/input-state checks now pass, including
97+17+3 candidate bytes with the fixed fixture HUD. The added counter/wrapper/
marker overhead still needs a bound. Debugger cycle markers have memory barriers
and exclude raw fixture setup/physics. Report actual work scope:
stream construction is distinct from MOS driver cycles and UART waits. Do not
silently treat a swallowed transmission as measured real submission, nor derive
CPU savings from its byte counter. If the wrap or overhead bounds are unsuitable,
fall back to explicitly scoped preparation spans plus separately measured real
submission, retaining the limitation. Real rendering runs must keep normal UART,
all120 road rows, original scenery/six cars and warmed resident data.

## CPU construction/count probe results

`build_cpu_work.py` builds a separate diagnostic from the qualified frontend,
changing only the diagnostic entry/option guard and adding `cpu_work.hpp`. It
rejects ordinary play. The real frontend and qualified bootstraps remain intact.
Two warmup frames render normally; the next64 spans construct the full scene's
command stream with output suppressed. Those64 are explicitly not rendered or
counted as VDP-completed frames. Normal output resumes for cleanup and reporting.

The first `_mos_puts`-only attempt missed60 bytes per oracle pose: SDK
`vdp_adv_use_affine_matrix.c` uses six `_putch` calls per matrix selection.
Its retained sources/report show that failure. The corrected linker wraps both
output functions, forwarding them outside the CPU span. Four ordinary native
count runs and four debugger runs pass all64 per-pose expected byte counts and
original state hashes on both tracks. Candidate spans have exactly four output
calls and117 constructed bytes each. Totals:56888 oracle bytes/oval batch,
49188 oracle/Fuji and7488 candidate bytes on either track, including the fixture
HUD and swap commands. These match the independent original byte accounting.

The debugger captures128 alternating begin/end stops per run, yielding64
construction-cycle spans. Raw means, including sink and marker overhead:

| Track | Oracle cycles/pose | Golem cycles/pose |
| --- | ---: | ---: |
| Oval |322475.9375|23517.484375|
| Fuji |291303.4375|23537.484375|

These are useful provisional measurements, not yet a frozen CPU-budget pass.
Before accepting a reduction, calibrate a conservative upper bound on sink/
marker bookkeeping and subtract that bound from oracle work, retaining raw
candidate work as a conservative upper comparison. Keep actual MOS driver/
UART waits outside this construction scope and measure real rendering separately.
No latency, unpaced-frame, heap or stability claim follows from these samples.

```sh
PATH=/home/smith/Agon/agondev/release/bin:$PATH .venv/bin/python docs/tasks/RALLY-19/build_cpu_work.py NEW
.venv/bin/python docs/tasks/RALLY-19/probe_cpu_work.py NEW-oval-oracle --build NEW --track oval --renderer oracle --cycles
.venv/bin/python docs/tasks/RALLY-19/probe_cpu_work.py NEW-oval-golem --build NEW --track oval --renderer golem --cycles
```

Repeat with Fuji and fresh evidence names. Build and execution identities,
complete intercepted counts, debugger logs and the initial failure are under
`evidence/golem-cpu-work/`. R19-10 remains unchecked.

## R19-10 completed qualification

`qualify_performance.py` passes the frozen budgets without changing the playable
frontend, compiler implementation, qualified bootstrap bytes or visual metric.
Golem's companion completion record is4efba69d43107622ce62af2b54bd2e6d530edf21.
R19-11 stability/lifecycle/review and R19-12 delivery remain open.

| Measured property | Oval | Fuji |
| --- | ---: | ---: |
| Golem scene/update/call/swap bytes |100|100|
| Scene traffic reduction |88.5305%|86.6944%|
| Conservative scene-construction CPU reduction |91.9657%|91.0111%|
| Native visible-frame median |31.6682 ms|31.6487 ms|
| Native visible-frame p95 |36.7422 ms|36.7128 ms|
| Median change versus accepted oracle |+0.00823%|-0.01802%|

The fixed timing HUD adds17 bytes, making117 total/frame. The unchanged demo HUD
adds24 bytes, making124 total/frame. Manual HUD strings vary with track, steering,
grip and surface; they remain separate from the100-byte scene budget and identical
to the accepted frontend. Offload substantially frees construction work and UART
capacity; emulator frame cadence remains effectively unchanged.

Real-rendering evidence uses an unwrapped diagnostic build: no output suppression,
no per-frame GP or geometry readback, no CPU unthrottling. Both tracks ran serial
ABBA against the exact accepted binary, two64-pose batches per variant. Every
Golem batch reports66 accepted states (two warmups plus64 poses), final sequence65,
next expected66 and zero admission errors. The external native observer confirms
all68 swaps including mode initialization and explicit startup. Each track/variant
provides126 steady native intervals; the first measured transition is excluded
because it contains the host marker handshake. All128 guest intervals remain.
Medians use the conventional definition; p95 uses nearest rank.

A separate eight-run bridge confirms the instrumented oracle's final scene CSV
matches the untouched binary exactly, with negligible median timing change. The
audit verifies normal process arguments, pinned runtime hashes, copied headers,
qualified bootstrap identities, raw event nesting/counts and per-pose accounting.
The first smoke run is retained independently of the acceptance batches.

CPU evidence uses another serial ABBA, two64-pose debugger samples per renderer
and track. Calibration covers32 cases, both output functions,64 calls per active
case and32-bit counter carries/wrap. Relocatable object instructions and relocation
targets for wrappers/markers are identical in measured and calibration builds.
The conservative bound is184 cycles per span plus323 per intercepted call,
including calibration-loop/argument overhead. The audit subtracts the entire
bound from each oracle sample and retains all candidate overhead. Resulting
mean lower oracle bounds are292682.046875/261804.6015625 cycles; candidate upper
means are23515.0234375/23533.3828125. These measure scene/command construction,
not the MOS serial driver or blocked UART time. Actual transmission waits are
preserved in the separate real-rendering runs; no CPU saving is inferred from
wire-byte counts.

Program-entry-to-warmed-ready time is2.750 s for the instrumented oval oracle
versus3.150 s Golem; Fuji is4.683 s oracle versus4.250–4.267 s Golem. These exclude
MOS binary loading and firmware boot. The exact original binary lacks that
counter; its native mode-swap-to-warmup span is separately retained. Warmed
process RSS is14736–14780 KiB for the measured oracles and15220–15488 KiB for Golem;
observed high-water RSS reaches16928 KiB. This includes emulator/host overhead,
not physical ESP32 heap. Static resident payload remains78565/199711 bytes and
836/853 owned IDs, excluding external original art and cached affine inverses.
Memory growth and fault recovery still require R19-11's separate untimed probes.

New-name native reproduction (all runners generate canonical headless profiles):

```sh
PATH=/home/smith/Agon/agondev/release/bin:$PATH .venv/bin/python docs/tasks/RALLY-19/calibrate_cpu_work.py NEW-calibration --build both-outputs
PATH=/home/smith/Agon/agondev/release/bin:$PATH .venv/bin/python docs/tasks/RALLY-19/build_render_work.py NEW-render
.venv/bin/python docs/tasks/RALLY-19/measure_render_work.py NEW-bridge --build NEW-render --phase bridge
.venv/bin/python docs/tasks/RALLY-19/measure_render_work.py NEW-abba --build NEW-render --phase abba
```

The immutable audit inputs are in `evidence/golem-performance/qualification.json`;
raw runs are under golem-render-work, golem-cpu-work and golem-cpu-calibration.
Historical failed sources/results remain. These results establish the frozen
Linux emulator performance criteria, not hardware performance or user acceptance.

## Debrief clarification

Double buffering itself does not imply30Hz. The pinned native USERSPACE path
consumes two separate boolean vblank signals per Canvas swap. This is a specific
emulator finding; no wait-removal experiment or hardware result establishes its
full causal impact yet. Sustained measured Golem throughput is30.2042/30.1281FPS
(oval/Fuji); reciprocal median latency (~31.6FPS) is not sustained throughput.
See DEBRIEF-2026-09-12.md. New build_render_work.py calls require an explicit
--frontend argument, e.g. --frontend checked-cleanup. The final loader-hardened
benchmark build is prepared but unrun at this requested stopping point.


## Final stack-fix assets — native budgets requalified

`evidence/golem-performance/hardware-inline/qualification.json` passes all frozen
checks on the exact corrected bootstraps. Each track has serial ABBA with two
64-pose samples/variant, separate instrumented-oracle bridge runs, raw native
swap observations and independently calibrated CPU construction cycles. Normal
18.432MHz guest limiting and real UART waits remain enabled for rendering.

| Final native metric | Oval | Fuji |
| --- | ---: | ---: |
| Golem native viewport-swap interval median, ms |31.7114645|31.303662|
| p95, ms |36.788592|36.092826|
| Median change versus matched original |+0.01765%|-0.31886%|
| Conservative eZ80 construction-work reduction |91.96372%|91.00777%|
| Scene UART reduction,100 bytes including swap |88.53047%|86.69439%|

The native mean intervals remain approximately33.13/33.22ms; do not convert the
median into an assertion of sustained physical FPS. The exact unchanged
wrapper/marker calibration bounds184 cycles/span plus324/call, conservatively
subtracted only from the oracle. The measured object instructions and carry/wrap
cases are retained. Fixture HUD adds17 bytes; interactive HUD is separate.
Raw startup scopes, resource ledgers, process memory and all source/runtime
identities are in the qualifier. No prior pre-inlining timing is substituted.

`audit_final_candidate.py` then passed, rechecking644 source/evidence files and
binding correctness, long replay, controls, lifecycle, production identity and
native timing in `evidence/final/qualification.json`. Its explicit
`physical_performance_accepted` value is false. The initial index attempt used
an incorrect replay-ledger field name; that script/error is retained in
`evidence/final-initial-index-failure/`. The fix reads the actual source_hashes
ledger and checks the independent replay auditor's identity; no test threshold,
game source, raw result or earlier qualification was changed to obtain a pass.
