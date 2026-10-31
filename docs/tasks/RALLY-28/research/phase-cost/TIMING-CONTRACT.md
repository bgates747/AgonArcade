# Proposed completion-correct diagnostic hooks

Design only: no instrumentation, fixture, module, firmware or SDK change is
implemented/released here. The unchanged control remains the source of
whole-frame FPS. This contract describes the smallest useful staged diagnostic;
its module-fit and host proofs precede any future target reservation.

## Separate the two questions

1. **Whole-frame comparison:** use the complete race workload, 900 frames and
   3,600 deterministic steps, two warm pages, original inputs, error checks,
   stock swap and checked final fence. Report completed-frame FPS, frames and
   elapsed MOS/PRT separately, paired in both orders. No per-phase markers or
   record readback in this performance control.
2. **Phase diagnosis:** a separate finite 128-frame run uses the same motion
   prefix, four steps per render, full scene and final fence. Accumulate native
   preparation and VDP execution intervals with a bounded retained log; log
   retrieval/files occur after the timed scene. Compare its total throughput
   with an otherwise matching diagnostic with hooks disabled. Its FPS exposes
   instrumentation overhead; it is not substituted for the 900-frame result.

This is not yet an independent real-time physics scheduler. Before selecting
any candidate cadence, benchmark actual player/VDP physics flat out for at
least ten wall-clock seconds, then measure it with real submissions and full
presentation. Serial-free capacity is a useful isolation, not integrated
headroom. Eventual rendering skips stale frames; physics does not wait for a
render reply or execute catch-up renders.

## Existing facilities and source-qualified completion

Use the existing private native module path and retained buffers. No new SDK
clock/log/drain service is inherently required. The pinned RPC accepts silent
RUNs (`flags=0`), as used by existing wrappers. Preserve normal RUN failure
handling and final checked Root-generation reply in the guest. New diagnostic
markers need their own sticky error/log validation because they have no
individual callback. Do not depend on a last-status value that a later command
can overwrite.

For fixed double-buffered mode136, the pinned controller executes ordinary
primitives inline (`displaycontroller.cpp:525–540`). Therefore a marker RUN
immediately after a stock plot/text/scroll command measures its completed
execution in that mode. Swap queues and waits for execution/VSync; its end
marker follows actual controller swap completion. A native render-preparation
reply still precedes the later output-buffer plotting and is not its end fence.

`VDU23,0,&CA` provides stock immediate queue draining through
`Canvas::waitCompletion(false)`. In a mode with background queued primitives,
place this drain **before each end marker** and before the initial start marker
where prior work could remain. Record that policy and separate its cost; it
serializes work and can change scheduling. Do not insert gratuitous per-phase
drains into mode136 simply to call the measurement fenced. A new mode/controller
requires a fresh source/behavior check. No claim covers arbitrary firmware or
physical display scanout.

## Marker transport and state ownership

A later **private diagnostic module copy**, not the accepted module, may add
BEGIN/END/COMMIT/RESET dispatch for typed diagnostic arguments before the
generated world-entry dispatcher. Assign private IDs only in that experiment's
frozen manifest, validate ABI/magic/session/phase/buffer size, and never alter
world generation/request/tick for a marker. The current generated entry bounds
and root entry identity checks stay unchanged for all game entries. This cannot
be slipped into the current image without a separate build/qualification.

Prebuild immutable marker RPC buffers with `flags=0`, handle patched once after
LOAD, and phase/session arguments resident on VDP. A hot-loop call is the six
byte buffered call, not an eZ80 reconstruction of the marker stream. Frame
index advances on COMMIT, so no dynamic per-marker argument upload is required.
Include every added call/RPC byte and native dispatch in the overhead ledger.
Keep rendering command order and all drawing unchanged.

Use resident scalar accumulators for in-progress times. Sampling already uses
all four runtime leases: root, asset, source, destination. Do **not** acquire a
log view from a sampling hook, retain a released pointer, or assume a fifth
lease. END samples only a counter. COMMIT runs after preparation/drawing leases
have been released; it acquires the log, writes one complete row, then publishes
its committed count and releases. Root/header reads, if needed, must also stay
within the four-slot limit. Check all acquire/release return paths.

One candidate log is buffer50305, formerly module-upload staging, replaced
**only after a successful LOAD reply**. It is already owned/cleared by the
fixture and must not alias root, assets, outputs, scratch or artwork. A future
host fixture must verify identity, allocation and cleanup; this document does
not change that buffer now.

## Proposed retained schema

All fields are little endian. A 32-byte header plus 128 rows of 96 bytes uses
**12,320 bytes**, within one 16-bit-sized buffer. Retained records, setup and
export are outside the race's wire timing; their memory/stack cost still counts
in admission. Unsupported diagnostic subsets use an explicit availability flag,
never fabricated zero timings.

| Header offset | Field |
| ---: | --- |
| 0 | magic `R28P`, 4 bytes |
| 4,6 | schema1, header32, two u16 |
| 8,10 | row96, capacity128, two u16 |
| 12,14 | committed rows, diagnostic mode, two u16 |
| 16,20 | flags, first error, two u32 |
| 24,28 | session, available-delta mask, two u32 |

Each row begins with frame, world generation, render request, physics tick,
PRID/core and flags (six u32,24 bytes), then road-band/car/sign counts and
reserved (four u16,8 bytes). The remaining 64 bytes hold sixteen u32 deltas:

| Slot | Boundary | Interpretation |
| ---: | --- | --- |
| 0 | Native render entry start to successful publication | Inclusive total, not additive with slots1–8 |
| 1 | Generated admission, snapshot and state validation | Accumulate explicit non-overlapping brackets; exclude preflight |
| 2 | Asset validation and 12-range preflight | Exclude setup-only full checksum |
| 3 | Road preparation | Geometry, raster fill and road/finish/footer command construction together initially |
| 4 | Actor projection/order/command construction | End before deferred sampling |
| 5 | Car image sampling | Includes source/destination lease overhead; no new log lease |
| 6 | Sign image sampling | Same, tagged by kind without reordering |
| 7 | Player command construction | Existing artwork/reflection only |
| 8 | Native completion/publication validation | Include generated post-helper checks; keep errors observable |
| 9 | Sky BEGIN→END in command stream | VDP elapsed scroll/repaint/repair and dispatch |
| 10 | Output50301 BEGIN→END | Road plot **and finish/footer clear**, accurately labeled |
| 11 | Output50302 BEGIN→END | Traffic/sign plotting in existing mixed painter order |
| 12 | Output50303 BEGIN→END | Player plotting |
| 13 | HUD/footer BEGIN→END | VDP text/viewport execution, excludes eZ80 formatting |
| 14 | Swap BEGIN→END | Presentation/VSync wait, kept separate from hot-loop rendering |
| 15 | Four native Tick-entry intervals | Native simulation plus admission; not pure arithmetic |

Keep root/frame IDs and requested counts aligned. Slots1–8 omit glue unless
explicitly bracketed; their sum is not required to equal inclusive slot0.
Slots9–14 are command-worker elapsed intervals and may include preemption and
input starvation, not just primitive instructions. Do not sum processor clocks
into a wall-clock budget. Sky can execute while the eZ80 is preparing later
commands. The four simulation intervals precede rendering and do not imply
120 Hz cadence.

Use shorter **separate** variants only if a measured phase needs a finer split:
road geometry versus byte fills, car versus sign plotting, sky scroll versus
repair, HUD versus footer, or validation versus useful native physics. Preserve
mixed draw order and report whether per-object counters/fences perturb the
loop. Do not start with a timer around every span/pixel.

Place COMMIT after the swap end marker, before the original final checked fence.
The fence then proves the row was published before the frame completes.
On overflow, pairing/core mismatch, invalid phase/session, counter ambiguity or
any native/lease error, set the sticky failure and invalidate the run; do not
wrap log rows or silently discard observations.

## Clock and overhead rules

1. Native intervals use unsigned32 `CCOUNT` differences on one checked PRID.
   Reject deltas at/above `0x80000000` or core changes. Label emulator results
   **raw emulated counter units**, not ESP32 cycles/microseconds. CCOUNT includes
   interruption/preemption; it is not task CPU accounting. Preserve the pinned
   interpreter/JIT identity and its uncalibrated counter semantics.
2. eZ80 uses the existing interrupt-owned PRT and its 24-bit modular difference.
   Preserve claim/vector/restoration checks, bound intervals below half range,
   and report PRT separately from nominal120Hz MOS. Aggregate MOS over long
   capacity runs; do not use one tick to resolve a short function.
3. Add eZ80 diagnostic brackets for sky calculation, HUD formatting/cell diff,
   physics computation, serial calls and waits. Label nested/overlapping brackets
   explicitly. Do not subtract noisy short send brackets and call the remainder
   an exact CPU profiler.
4. Measure back-to-back counter reads, an empty BEGIN/END pair, silent dispatch,
   and (where used) stock drains with identical mode. Report raw and overhead
   observations. Do not blindly subtract one empty-fence value from every busy
   phase: queue scheduling and timer quantization are workload dependent.
5. Every result starts with completed-frame FPS and frames/elapsed time versus
   its matched control. Emulator evidence guides selection; physical hardware
   later decides the target. No host microbenchmark establishes game FPS.

## Build, failure and scheduling gates

The accepted image uses **32,264/32,768 text bytes**, leaving only **504 bytes**,
and1,004/4,096 resident data bytes. A full set of hooks may not fit. Prove exact
text/data/image/stack admission and four-slot lease balance before preparing a
target profile. Split private diagnostic variants if required; do not silently
raise limits, replace firmware or repurpose the production ABI. Static module
stack reports exclude SDK/caller/interrupt frames; retain observed target stack
as a separate later qualification.

Before any future target launch, preserve original snapshots and freeze private
source/module/driver/marker buffers/log schema/predictions and finite timeout.
Use the **current self-service FIFO** in
`/Agon/mystuff/agon-dev-env/cross-agent/vdplet-rollout/README.md`: prepare, reserve,
fresh whole-host inspection/check out when first, assert ownership before each
process. Automated sessions force both SDL dummy drivers and original thermal
guards. Stop owned processes, retrieve raw data, inspect/release before analysis,
then immediately steer the returned next agent; disclose failed delivery.
Scheduling time is not a release to implement or test this proposed contract.

Retrieve/read logs only after the diagnostic window and checked fence. Stop and
UNLOAD before destroying buffers; restore timers/text and remove callbacks only
when no RPC is pending. Preserve failure logs and keep callback storage resident
on pending timeout, following the existing guest's failure path. A later error
must not publish a partial success file or trigger an automatic retry.
