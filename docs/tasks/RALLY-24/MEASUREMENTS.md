# RALLY-24 proposed implementation and measurement gates

## Executive summary

First build a current-game oracle and two candidates differing only in road-command generation. Qualify finite native execution before integrating live gameplay. Use physical paired tests to decide whether lower UART traffic and eZ80 computation translate into useful headroom or completed frames. **All items below are proposed later work; none was executed in the research tranche.**

## 1. Implementation tranches for approval

**Next proposed tranche: local implementation, compilation and deterministic checks only.** Target candidate B's native projection and road endpoints; A is a diagnostic stepping stone, not an acceptable final substitute. Proceed from one-section arithmetic parity to complete road/car generation and the existing finish-line/sign/crash visual dependencies. Deliver generated-command comparisons, malformed-input/failure-gate checks, module size/import/stack findings and a clear readiness or blocker report. Preserve the current playable build. No flashing, deployment, live gameplay or emulator/profile changes in this tranche. Recommend high reasoning for the numerical, ABI and lifetime work. Await explicit approval before beginning; hardware qualification and performance measurement remain later tranches.

1. **Local proof:** separate experiment under `docs/tasks/RALLY-24/experiment/`; no edits to preserved renderer headers. Implement ABI serialization/validation, current-game host oracle, candidate A and then B, command decoding and failure-gate tests. Native compilation uses the existing VDPlet SDK; archive text/data/package/stack/disassembly and missing-import failures. Stop if8KiB/4KiB/16KiB constraints do not fit. Physical qualification is not inferred from host sanitizers.
2. **Physical runtime proof:** confirm bench ownership, installed identities and restorable firmware/startup/input. Runtime owner evidence must establish LOAD/RUN/UNLOAD and buffer access on the actual classic ESP32. If it is still pending, obtain approval for that small prerequisite instead of slipping in a firmware deployment. Retain an eZ80-renderer control under the same runtime-enabled firmware.
3. **Deterministic visual/compute comparison:** current oracle vs A/B, same static world poses and drawing order, including full-game signs/finish/crash. Load assets once; keep timed execution free of file reads and per-frame logs.
4. **Physical performance and play review:** repeated paired batches, same clocks/track/traffic/pacing. Leave a recognisable game for fresh Author inspection only after qualification. Human review/commit/publication gates remain explicit and separate.

## 2. Correctness matrix

| Family | Required cases |
|---|---|
| Road | Both tracks; straight, minimum-radius curves, interval/bin/stripe boundaries, wrap just before/at/after lap; maximum legal section count |
| Player | Steering -21/0/+21 and each view threshold, both mirrors, lateral extremes and road/kerb/grass thresholds |
| Opponents |0/1/6 active, near64/far1100 depth boundaries, overlap/depth ties, heading limits, wrap and absent slots; preserve current truncation of Q8 lanes |
| Scene | Finish stripe present/absent;0/1/2 signs and merge ties; menu actor clipping; crash age and invulnerability blink; both page histories |
| ABI/lifecycle | Missing/multiblock/wrong-size/aliased buffers, bad version/reserved fields, invalid ranges, stale/duplicate session/sequence, repeated bind/load/exit, output capacity failure |
| Guard | Invalid runtime handle before entry; module failure after partial output; prior successful ready flag; all draw wrappers must skip failed output; terminator must hide old tail |

First require exact projected integer coordinates and command semantics. A should retain exact current road-command sequences apart from IDs/wrappers; B may use different command bytes but must retain order/materials and exact final pixels. Target exact pixel equality for frozen static scenes. A discrepancy is a review stop, not permission to borrow the old Golem ±1px tolerance. Host eZ80 oracle and physical VDP captures remain distinct checks. For moving histories verify protected HUD/sky regions and page alternation, not just isolated frames.

Keep physics/traffic/collision state hashes identical when replaying fixed inputs at fixed physics ticks. Per-render steering makes uncontrolled live runs unsuitable for exact physics A/B attribution. Do not change cadence to improve a benchmark without labelling that separate fixture.

## 3. Performance matrix and clocks

| Variant | Firmware | Rendering work |
|---|---|---|
| S | Matched stock release, where useful | Current eZ80 full game, historical-compatibility control |
| C | Runtime-enabled pinned firmware | Current eZ80 renderer, no module invocation; isolates firmware cost from offload |
| A | Same as C | Native projection/resident commands; original buffered section arithmetic |
| B | Same as C | Native projection/direct road endpoints; normal colour PLOT/bitmap rendering |

Use both tracks, straight/curve poses and0/6 traffic. Three paired batches per comparison, alternating C-A-A-C then C-B-B-C or equivalent; freeze actual sequence before execution. Warm assets, same input sequence, preserve startup and input route. Start with120 measured frames per batch plus fixed warmup; lengthen only if timer resolution prevents a meaningful comparison, recording the amendment. Separate ordinary30-target gameplay from any unpaced diagnostic. No Golem variant and no future asynchronous UART implementation in this comparison.

Record these separately:

1. MOS application-cycle intervals (nominal120Hz, verify current clock): frame target is4 ticks, not elapsed presentation. Aggregate short calculations across repeated bounded work; report quantization bounds. Do not fabricate microsecond precision from MOS ticks.
2. Host-side calculation/state packing and UART submission/blocking. Use matched diagnostic instrumentation and a no-work calibration; where precise hardware CPU timing is unavailable, report combined stage/aggregate bounds rather than label wall time CPU execution.
3. Native entry elapsed duration: propose bounded diagnostic cycle-counter sampling if supported by the module toolchain; pin CPU frequency and interrupt/preemption interpretation. No current service provides a general timer; this must pass a small qualification before use. Entry return is not Canvas completion.
4. Drawing completion / presentation: pinned `switchBuffer` reaches Canvas swap; top-level source comment says VSYNC, but that alone does not establish exact physical completion. Trace pinned Canvas implementation and use a separately approved bounded firmware timestamp/counter at completed swap/VSYNC, or external video observation, to establish displayed frames. If neither is available, mark actual FPS unmeasured. Per-frame acknowledgement is a different instrumented condition, never the silent-production number.
5. Count recurring command bytes at the eZ80 API boundary, independently decode the stream, and reconcile wire captures if later authorized. Show retained HUD/scenery/audio/swap separately and total. Measure CTS/backpressure effects rather than assuming line rate converts bytes directly into CPU savings.
6. Installation, consolidation, loading, resource allocation and unload/reload separately. Record largest available executable/internal/data blocks, stack watermarks and post-loop allocation recovery as well as nominal module size.

## 4. Proposed decision criteria

These are proposed review thresholds, not previously accepted targets or claimed results.

1. Correctness: all deterministic states and physical frozen images pass; zero malformed command lists, unhandled native failures, missing cars/materials or page corruption. No new hardware resets or input failures.
2. Structural benefit: no road spans or projected car commands cross UART;112-byte state/147-byte invocation channel is confirmed or every deviation is explained. Compare against measured current per-frame traffic, not the6-byte wrapper alone.
3. Useful gain: aim for at least50% median reduction in road/car recurring bytes and at least25% reduction in combined eZ80 visual-preparation/submission time across the defined scenes, with no more than5% median/p95 completed-frame regression beyond clock uncertainty. A byte-only improvement is reported as such if CPU timing cannot establish the second criterion.
4. Preserve30-target normal pacing. If both variants meet it, report measured headroom and tails instead of claiming a frame-rate improvement. A variant meeting only CPU/wire goals may still be worth retaining; Author decides from the table.
5. Reject/stop on a failed numerical/size/alias/return or physical stability gate. If A helps and B fails rounding parity, present A as a bounded interim result, not completed removal of buffered arithmetic. If neither helps, retain evidence and stop; do not expand into RALLY-25/26 or arbitrary scheduler changes.

## 5. Byte-count estimate and limits

Source-level current road emission (fillSky=false) is **30+25×bands bytes**. For illustrative16/32-band frames that is430/830 bytes for road alone. Proposed147-byte channel also covers car state/invocation, but excludes residual frame traffic. Relative to those hypothetical road-only counts it is65.8%/82.3% smaller; these are arithmetic illustrations, not observed average bands or full-game savings. Cars currently add27-byte affine-matrix preparation plus selection/use/plot calls; six visible cars add substantial traffic, to be counted exactly in the later stream oracle.

Native direct PLOT command output may be larger in VDP RAM than the old host parameter stream. That is acceptable for wire savings but incurs normal VDU dispatch. Compare A/B to measure whether avoiding buffer transforms/allocations compensates for the resident command volume.
