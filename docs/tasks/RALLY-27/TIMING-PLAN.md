# R27-05 — Portable direct-eZ80 frame-throughput fixture

## Executive summary

Measure completed frames per second for the current direct-eZ80 full game first. Isolate the existing Fuji attract workload in a separate fixture, hold the player on the centerline at traffic pace, retain collision checks without crash damage, and remove intentional pacing on both eZ80 and VDP. Run for 3,600 interrupt-updated MOS ticks (nominally 30 seconds), drain outstanding drawing, and create result files after measurement. Preserve reusable measurement hooks for subsequent development. Deprecated renderers are references only, not comparison candidates.

**State: implementation authorized, 2026-10-13.** After reviewing this plan, the Author instructed: commit and push all dirt, then proceed on task. Existing work was committed/pushed as `a2a613f`; fixture implementation and headless Oryx deployment then began. New diagnostic changes retain the human-review and commit-approval gates. Root TODO.md remains the sole authoritative task register. After approval, the initial deployment target is a headless, isolated Flexe instance on Oryx; the fixture must also be usable with Fab and physical hardware through explicitly identified timing backends.

Subtask IDs are permanent and must not be renumbered or reused. `[x]` means completed or otherwise disposed, with evidence/disposition recorded. Existing partial implementation and validation status remain in [timing results](timing/RESULTS.md); unchecked items do not erase that evidence.

## 1. Agreed workload and measurement

- **R27-05-SCOPE-01** [ ] — Use the maintained `rally-game/` direct-eZ80 renderer and existing attract/demo scene as the source. Preserve current geometry, traffic artwork and routes, signs, panorama, retained HUD, player drawing and sound workload. Record fixture-specific presentation and control changes explicitly; do not replace this with precomputed command replay or the historical prototype.

- **R27-05-SCOPE-02** [ ] — Select Fuji. Force the player to the road centerline and match longitudinal traffic pace to keep traffic present. Keep collision detection active and count contacts, but suppress damage, explosion and recovery. Inspect attract-mode collision behavior before adapting it; if the ordinary attract path bypasses checks, explicitly invoke the existing checker in the fixture. Do not claim crash/race/menu coverage from this workload.

- **R27-05-SCOPE-03** [ ] — Keep simulation advancing from elapsed MOS ticks at its normal tick rate. Remove the eZ80 `next=now+4` frame gate. Preserve deterministic state progression per simulation tick; an unpaced run can render the same simulation state multiple times. Record simulation ticks and workload identity rather than claiming identical frame samples across hosts.

- **R27-05-SCOPE-04** [ ] — Remove deliberate VDP frame/vblank waits from the measured path, including any synchronous swap behavior that enforces presentation cadence. Preserve valid draw-target ownership, double-buffer/page history and completion semantics. Establish the actual renderer/driver behavior before selecting an unpaced page handoff. Do not silently substitute front-buffer drawing or count a skipped swap as a completed frame.

- **R27-05-SCOPE-05** [ ] — Bound submission by direct reads of the interrupt-updated MOS clock: 3,600 ticks at the expected 120 Hz. No blocking wait-for-vblank call. Preserve raw ticks and the observed final drain interval. Label this nominal wall time; emulator throttling and tick delivery must be verified, not assumed equivalent to external host time.

- **R27-05-SCOPE-06** [ ] — Primary result: completed-frame throughput across the measured batch, including final completion drain in the denominator. Record submitted frames, confirmed completed frames, submission-window ticks, final-drain ticks, total elapsed ticks and nominal seconds. Distinguish this from displayed/optical FPS. If all submitted frames cannot be proven complete, mark the run incomplete and do not publish submitted FPS as completed FPS.

## 2. Timing mechanisms and reusable hooks

- **R27-05-HOOK-01** [ ] — First deliver sustained completed-frame FPS with minimal measurement overhead. Fence initialization and warm-up outside the measurement. Use an ordered final drawing-completion barrier; a parser acknowledgement alone is insufficient if drawing remains queued. Avoid mandatory per-frame round trips that serialize normal producer/consumer overlap.

- **R27-05-HOOK-02** [ ] — Expose fixture-only boundaries for hot-loop start/end, geometry preparation start/end, drawing submission start/end and VDP completion. Hot-loop measurements must exclude deliberate frame pacing and vblank waits; UART backpressure remains a distinct recorded limitation. Geometry timing must include live projection and clearly distinguish vertex generation interleaved with output. Do not refactor preserved renderer arithmetic merely to create an artificial pure-compute interval.

- **R27-05-HOOK-03** [ ] — Support the Author's PRT stopwatch design as a portable eZ80 timing backend for subsequent drill-down. Reference AgonJukebox timer definitions and AgonMaths stopwatch routines; verify timer ownership, interrupt-vector restoration, disabled-interrupt behavior, calibration and emulator support. Retain raw counts, divider/reload, assumed CPU frequency and instrumentation overhead. No exact-millisecond claim without qualification.

- **R27-05-HOOK-04** [ ] — For detailed VDP elapsed timing, design ordered start/stop stream markers. Start is consumed before the drawing batch; stop timestamps only after preceding queued drawing completes, before any deliberate presentation wait. Return duration through a custom packet using MOS's keyboard callback transport, following Pingo's signature/version/token/sequence convention. Keep the interrupt callback bounded: copy/validate minimal data, neutralize recognized synthetic key packets and publish readiness; pass ordinary keyboard input through. Foreground code consumes results. Verify packet-size and UART FIFO constraints before freezing the wire format.

- **R27-05-HOOK-05** [ ] — A VDP marker interval can include command starvation and queue scheduling; report it as elapsed VDP processing/completion time, not pure rasterizer CPU time. Callback delivery latency must not enter the returned VDP duration. Deferred timers remain optional and separately identified so their overhead does not silently redefine the initial FPS baseline.

- **R27-05-HOOK-06** [ ] — Use explicit capability detection and backend metadata. Fab, Flexe and hardware may expose different clocks or completion mechanisms; unsupported measurements must be reported unavailable. Emulator debugger cycle counters can supplement later CPU analysis, but paused debugger runs cannot supply valid wall-clock FPS. Native ESP32 and host-emulated timestamp units must remain distinguishable.

- **R27-05-HOOK-07** [ ] — Custom timing firmware is separate from the normal game. Its scope is measurement infrastructure reusable by later development. The conversation's mention of future custom firmware/Golem does not reopen abandoned Golem rendering or authorize implementation in another project's owned tree. Resolve firmware ownership and exact source/runtime identities before changes.

## 3. Fixture output and preservation

- **R27-05-DATA-01** [ ] — Keep the normal release free of benchmark defaults, hooks and logging. Produce an explicitly identified standalone fixture build with source/build hashes and a portable runtime package. Preserve existing release binaries, archives, RALLY-24 evidence and dirty implementation.

- **R27-05-DATA-02** [ ] — Collect bounded counters and any optional samples in RAM; no SD writes, printf, host telemetry calls or result decoding inside the measured batch. Thirty seconds of aggregate measurement must not be truncated by a sample-buffer limit. Record sample capacity, stored/dropped counts and instrumentation settings when detailed sampling is enabled.

- **R27-05-DATA-03** [ ] — After final completion, the guest creates its own files in its run directory: a machine-readable summary and, when enabled, stage samples. Record schema/workload version, build identity, track, centerline/traffic/contact policy, pacing configuration, clock/backend identities, raw counts, completion evidence, failure state and result-file write status. Choose unique run names or create-new semantics to preserve prior runs. A failed or timed-out run must be distinguishable from a valid completion.

- **R27-05-DATA-04** [ ] — Host tooling may decode and aggregate guest output, attach runtime/firmware identities and calculate FPS, but guest measurement must work on physical hardware without a host callback service or debugger. Physical launch and SD deployment remain subject to subsequent explicit authority.

## 4. Proposed implementation sequence after approval

- **R27-05-PLAN-01** [ ] — **R27-05A — Freeze boundaries and capabilities.** Inspect current demo, traffic/contact path, MOS clock, swap/queue completion, timer reference code, repaired Flexe runtime and firmware ownership. Record a concise implementation design and identity manifest. Escalate an inability to remove VDP pacing while preserving valid frames; do not silently benchmark a paced path.

- **R27-05-PLAN-02** [ ] — **R27-05B — Build the reusable fixture.** Isolate the agreed workload, add unpaced execution and ordered batch completion, bounded result collection, guest-created output and optional stage-hook interfaces. Qualify PRT/callback capabilities before enabling their detailed measurements. Reuse existing code and scripts where appropriate; no deprecated-renderer benchmark matrix.

- **R27-05-PLAN-03** [ ] — **R27-05C — Validate and deploy headlessly on Oryx.** Verify normal-build separation, duration arithmetic, output integrity, completion/error handling and retained current-game tests. Prepare a new project-local isolated profile using the repaired Flexe runtime and canonical guards, with Flexe-named launcher and exact identities. Run bounded headless qualification, retrieve results and leave the profile stopped. No graphical launch or attention summons.

- **R27-05-PLAN-04** [ ] — **R27-05D — Present the first baseline.** Report completed FPS first, then workload/settings, raw duration/counts, drain cost and limitations. Keep setup/warm-up/file-writing outside timing. Repeat only as necessary to establish a credible baseline or resolve anomalies. Further Fab/physical runs and detailed bottleneck investigation follow review and applicable authorization.

## 5. Acceptance and pause

- **R27-05-GATE-01** [ ] — A valid first run measures the live current renderer, exercises the agreed full scene for a nominal 30 seconds, and proves all counted frames completed with intentional pacing removed on both processors.

- **R27-05-GATE-02** [ ] — Result files are produced by the guest after completion, survive retrieval and identify the exact workload, game, timing backend and runtime. Failure and overflow cannot masquerade as success.

- **R27-05-GATE-03** [ ] — Future development can reuse the workload/output schema and optional stage boundaries without depending on deprecated renderer variants. Detailed timing capabilities and absent capabilities are explicit.

- **R27-05-GATE-04** [ ] — No claim of measured optical refresh, exact hardware milliseconds or native hardware speed is inferred from emulator results. No production gameplay change, Golem resumption, RALLY-20 work, driving-learning campaign or unrelated port work is included.

- **R27-05-GATE-05** [ ] — **Review gate released by the Author on 2026-10-13.** Implementation and headless Oryx deployment are authorized. Existing human-validation and explicit commit/push gates remain in force; approving this plan does not approve publication.
