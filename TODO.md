# AgonArcade TODO

## RALLY-20 execution register — paused for planning review

The Author requested this new goal on 2026-09-12: optimize the hardware-accepted
pre-Golem product and enable unattended development through Extender. Read the
[task and forwarding map](docs/tasks/RALLY-20.md) and
[frozen planning contract](docs/tasks/RALLY-20/CONTRACT.md). Planning is the only
completed phase. The requested emulator summons is notification-only.

**Author priority amendment, 2026-09-12:** first deliver mainboard SD read/write
access through Extender. Execution authority is the Extender project's local
`docs/tasks/PORT-017.md` on its active `main` branch. Only that capability's
necessary prerequisites may proceed before its physical acceptance; all other
Rally work waits. R20-02/03 consume that task's evidence instead of duplicating
its implementation. The goal remains paused until explicitly released.

0. [x] **R20-00 — Freeze the plan before implementation.** Identify the accepted
   stripped production binary; consolidate useful open Rally work without
   asserting unperformed acceptance; record ownership, bootstrap/recovery
   constraints, measurement controls, evidence gates and review pause. Commit
   planning documents only. Notify with an emulator, then await Author review.
1. [ ] **R20-01 — Preserve and reproduce the accepted product and bench.** Retain
   dirty deployment evidence and exact backups; establish source/build lineage,
   maintained-source integration plan, fresh hardware identities and supported
   connection/recovery paths. Preserve Extender keyboard input. Commit evidence.
2. [ ] **R20-02 — Freeze and prove the owned control/transfer interface.** Resolve
   concrete loader bootstrap, EMOS UART ownership, keyboard coexistence, RAM/ROM
   budgets, any additional firmware permission and recovery before implementation.
   Prove the smallest host/P4/eZ80 foreground service path. Commit contracts/proof.
3. [ ] **R20-03 — Qualify SD transactions and recovery.** Stage, verify and activate
   files through MOS with a preserved fallback; test integrity and interruption.
   Establish cooperative recovery and separately qualify any hardware reset path.
   Do not actuate the unresolved reset circuit. Commit results and limitations.
4. [ ] **R20-04 — Demonstrate ten unattended development cycles.** At least two
   distinct builds, bounded execution, retrieved results, recoverable failures
   and restored product, without human SD movement/reset. Commit orchestration
   and evidence; state any hard-hang recovery gap explicitly.
5. [ ] **R20-05 — Measure the physical pre-Golem baseline.** Constant-speed
   straight/curve matrix with independently varied traffic, both tracks;
   distinguish pacing, submission, completion and instrumentation overhead.
   Record matched batches and ordinary demo separately. Commit physical evidence.
6. [ ] **R20-06 — Optimize measured limiting work.** First batch bounded to three
   evidence-selected candidates; compare physical A/B results against frozen
   targets while preserving graphics, tuning and control feel. Commit retained
   changes and rejected findings; do not equate less UART traffic with faster VDP.
   Include the Author's deferred traffic-visibility candidate: draw traffic only
   once its projected top and footprint stay within the road-span refresh area,
   avoiding retained-background damage. Measure repair savings and appearance
   transitions; see the R20-06 contract amendment. Implementation remains paused.
7. [ ] **R20-07 — Qualify and restore clean production.** Both-track visuals,
   controls, stability and physical performance; instrumentation absent from
   product; official VDP restored and Extender keyboard working. Commit evidence
   and state outstanding human review rather than claiming it happened.
8. [ ] **R20-08 — Deliver a maintained product and repeatable bench.** Document
   source/build/run identities, measurements, rollback and remaining limitations;
   preserve oval demo startup and publish local component commit map. Obtain
   applicable human validation/commit approvals. Stop cleanly; no automatic push.

## RALLY-19 autonomous execution register

The Author authorized the goal, headless-only tests and a commit per completed
checkbox on 2026-09-12. The [frozen contract](docs/tasks/RALLY-19/CONTRACT.md)
defines scope and acceptance. Retain completed marks for this goal as requested.
This ordered register owns progress across AgonArcade and Golem.

0. [x] **R19-00 — Freeze before implementation.** Import the delivered Git
   checkpoint into an isolated Rally worktree; preserve originals. Commit this
   complete plan, oracle identity, scope, acceptance metrics, headless policy and
   per-checkbox commit rule before compiler/game development or experiments.
1. [x] **R19-01 — Reproduce the accepted application and compiler foundations.**
   Verify handoff SHA256s and a083173 Golem identity; create isolated Golem branch
   and project venvs. Read current design/lifecycle/compiler code; preserve dirty
   deployment files. Build/test the existing compiler examples and exact reviewed
   Rally source locally. Record source/toolchain/runtime/binary/data hashes,
   headless profile locations and how to reproduce. Commit foundation evidence.
2. [x] **R19-02 — Freeze and validate the visual/performance oracle.** Adapt the
   existing capture infrastructure to canonical Linux headless profiles. Freeze
   >=48 poses and per-object/material masks for the final accepted tuning. Prove
   the comparison catches missing cars/markings and tolerates <=1px edges. Record
   matched 64-pose baseline batches, bytes and stage timing on both tracks, with
   no unlimited CPU or interactive fence. Commit immutable fixture/metric evidence.
3. [x] **R19-03 — Define Golem's renderer-facing types, lowering and ABI.** Specify
   finite hosted entrypoints, named buffers/fields, relocations, matrix/float and
   integer conversions, alias rules, ID allocation, errors and resource budgets.
   Design only the intrinsics needed by Rally, preserving existing language
   semantics. Fix exact compact state fields, ranges and ordered commit/trigger
   protocol including independent stripe phase and HUD needs. Commit design/tests.
4. [x] **R19-04 — Implement and qualify reusable stock arithmetic in Golem.**
   Extend the C++ compiler with the defined lowering. Add golden/negative and
   sanitizer tests, preserving print/uint16/addition/For-Next. Run native headless
   varying-input product, multiply-add, reciprocal/division, rotation, negative
   conversion and computed PLOT probes; exercise finite loops/indexed operands.
   Record errors, bytes, timings and scratch lifetimes. Commit compiler then evidence.
5. [x] **R19-05 — Qualify resident state, lookup and resource lifecycle.** Implement
   symbolic asset/table imports, bounded indexing, typed command-field patching,
   atomic-by-order state update and finite render dispatch. Test malformed and
   incomplete packets, track/table bounds, sequence handling, reload, allocation
   balance and return to outer input processing. Commit compiler/runtime and tests.
6. [x] **R19-06 — Compute and draw one complete road section on VDP.** Feed only
   game-state/table inputs, evaluate current compact projection coefficients on
   VDP, derive stripe phase/boundaries and plot gray road, kerbs, shoulders and
   centreline. Compare signed/lateral/seam cases against the oracle; measure
   matrix/lookup batching choices and choose a measured construction. Commit proof.
   Qualified:74 native section-image pairs, exact centres and100% radius-one
   agreement per visible material; shared preparation selected by serial ABBA.
   See `docs/tasks/RALLY-19/SECTION.md` and its qualification.json. Golem980024b
   records completion (implementation f54651a). Full-scene targets remain open.
7. [x] **R19-07 — Extend resident road computation to both complete tracks.**
   Select resident sections, derive all required boundaries/material parity,
   maintain shared edges/finite clipping and lap-independent stripes. Pass the
   frozen road masks and <=1px boundary criterion, no missing material classes;
   report resource and recurring-traffic budgets. Commit full-road evidence.
   Qualified:81 native road-image pairs, exact centres, <=1px outer edges,
   >=97.56% per-material agreement;420 admission/recovery events pass. Finite
   bands<=32,707/731 owned IDs,100-byte state/update/call/swap. See ROAD.md and
   `docs/tasks/RALLY-19/evidence/golem-road/qualification.json`; Golem9eb9fcc.
8. [x] **R19-08 — Move vehicle projection and draw ordering to VDP.** Use player
   and six competitor track/lateral states to derive visibility, depth ordering,
   screen position, scale and yaw/reflection with existing artwork/liveries.
   Preserve optional perspective OFF and all tyre/hub/helmet colours. Pass per-car
   masks, presence and overlap tests across the frozen poses. Commit scene evidence.
   Qualified:112 native image pairs,156 numeric fixtures, all five views/both
   reflections and original liveries. Every vehicle pixel exact; road materials
   >=98.095%.894/913 IDs,100-byte scene packet. See CARS.md and
   `docs/tasks/RALLY-19/evidence/golem-cars/qualification.json`; Golem c66d0f.
9. [x] **R19-09 — Integrate the complete Golem-driven Rally frontend.** Add scenery
   bearing/retained-buffer handling and HUD/state mapping to the resident scene
   path. Preserve accepted simulation/input/manual/demo/settings and old renderer
   as an explicit oracle option. Prove a frame requires only compact state/trigger,
   not eZ80-projected corners; test input takeover and MOS exit headlessly. Commit.
   Qualified:186 full-scene native image pairs,444 native history records,
   12 both-track control/exit runs and638 sanitized raw-state records. Accepted
   input/physics/HUD unchanged;100-byte scene/update/call/swap. See SCENERY.md,
   FRONTEND.md and their qualification reports. Golem completion cd6d1ed.
10. [x] **R19-10 — Meet the frozen offload/performance budgets.** Run normal-clock
    serial ABBA on both tracks with identical fixtures and warmed assets; record
    >=75% scene-UART reduction and <=128-byte scene packets, >=50% eZ80 scene-work
    reduction, median <=33.33ms and p95 <=50ms, no >5% median regression. Optimize
    within contract if needed; retain honest end-to-end/timing limitations. Commit.
    Qualified:100-byte scene traffic,86.69–88.53% UART reduction,>=91.01%
    conservative scene-construction CPU reduction; native medians<=31.67 ms,
    p95<=36.75 ms, negligible oracle regression. Both-track serial ABBA and
    source/runtime/sequence audits in PERFORMANCE.md and golem-performance
    qualification. Golem completion4efba69; hardware/stability remain unproven.
11. [x] **R19-11 — Complete stability and independent correctness review.** Run
    >=10 minutes per track of deterministic headless replay, signed extremes,
    overlap, input transitions, reset/reload and shutdown. Verify sequence/memory
    integrity, compiler/loader negative tests and all frozen regional visual
    thresholds. Review generated commands for hidden eZ80 geometry/custom features.
    Commit the audit and reproducible evidence; do not assert hardware acceptance.
    Hardware investigation authorized after the stock-VDP reset reproduced:
    11.1. [x] **R19-11-H1 — Locate the physical reset.** Capture stock ESP32
          serial boot/crash output; if necessary flash a separately built VDP
          with targeted serial diagnostics. Preserve exact production assets.
    11.2. [x] **R19-11-H2 — Correct and qualify stock compatibility.** Fix the
          evidenced game/compiler cause; reproduce the failure and validate the
          correction on physical VDP, restoring official firmware after diagnosis.
    11.3. [x] **R19-11-H3 — Prepare human review.** Run appropriate headless
          regression checks, preserve evidence and launch a dedicated review
          emulator only when the bug is identified and the game likely runs.
          Details and authorization: `docs/tasks/RALLY-19/HARDWARE-DEBUG.md`.
12. [x] **R19-12 — Deliver and stop at the agreed scope.** Document Golem language
    additions, renderer protocol, ownership, build/run/benchmark commands, resource
    totals, final binary/data/compiler hashes and measured limits. Record linked
    Golem/Rally commits, preserve the oracle and update handoffs. Commit final
    evidence, mark the goal complete only if all criteria passed, and report in
    writing without launching an emulator or pushing/deploying anything.

This is the authoritative task checklist. Details are in `docs/tasks/<ID>.md`;
task-specific supporting files belong in `docs/tasks/<ID>/`.

18. [x] [RALLY-19](docs/tasks/RALLY-19.md): Frozen research experiment complete through R19-12 (delivery e91eb4c; Golem3ac500c). Native criteria pass; physical startup corrected, hardware rendering too slow. See DELIVERY.md; no practical acceleration or publication claimed.

RALLY-18, RALLY-17, RALLY-16, RALLY-15, RALLY-10, RALLY-14, RALLY-04,
RALLY-09, RALLY-08 and RALLY-11 are **consolidated into RALLY-20**, not marked
completed. Their original documents/results remain historical evidence. The
[forwarding map](docs/tasks/RALLY-20.md#forwarded-work) records each remaining
obligation and its new execution step. Old native timings are not hardware FPS.

2. [ ] [STUNT-01](docs/tasks/STUNT-01.md): Future separate 3D stunt racer.

Completed milestones and acceptance evidence remain in the dated development
logs: [Rally](docs/2026-09-11-rally.md), [Mac continuation](docs/2026-09-11-rally-macos.md),
[Defender](defender/docs/2026-09-11.md), and [research](docs/2026-09-11-research.md).
