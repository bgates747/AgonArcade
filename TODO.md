# AgonArcade TODO

## Prioritized optimization work

- **RALLY-28 / SYNC-001-01** [ ] — Standalone stock buffered drawing-completion probes **Author launch and automated checks pass; broader input and Console8 confirmation open**. [Results](docs/tasks/RALLY-28/standard-vdp/completion-probe/RESULTS.md), [Author launch record/instructions](docs/tasks/RALLY-28/standard-vdp/completion-probe/README.md#author-visualinput-review-on-oryx). Callback and general-poll applications each pass 52/52 against official unmodified VDP 2.16.0/MOS 3.0.2; callback uses virtual key zero, preserves eight ordinary input events, foreground counter progresses while drawing, own summary/CSV/done files. Primary completion precedes separate readback/poll validation. All pre-implementation dirt pushed as aee0aad/01f6333; new probe work uncommitted. Same RALLY-28 umbrella; no game/scheduler integration.

- [ ] **[RALLY-28](docs/tasks/RALLY-28.md) — Faster Rally engine, standard VDP FIRST.** Released measurement tranche delivered2026-10-15 after pushed all-dirt checkpoints `7576ceb`/`552d2df`. [Actual physics/census results](docs/tasks/RALLY-28/standard-vdp/capacity/RESULTS.md):8,192normal game ticks,420 actual final-state fields independently pass;334.70nominal PRT/365.44MOS ticks/s, clocks disagree9.19%, no cadence selected. Dense construction sink:57.19ms/frame preparation and88.29ms greedy/vertices/emission (nominal PRT), not game FPS.900-frame full-scene census1,859.59B/frame,74%road/18%traffic-signs; simple buffered road model saves52%road bytes including patches/CALLs, unimplemented. [Shared positioning/partial-optimization map](docs/tasks/RALLY-28/research/PROJECTION-AND-REUSE.md) covers all consumers, caches/lifetimes/rounding and preserved prior wins. **Next tranche RELEASED2026-10-15, STD-002-01–04:** STD-001-03/REUSE-001-02 shared lookup/sparse derivative with coarse option, bounded simple road-template prototype and PACE-001-02 actual UART/CTS/completed-pipeline measurement; PACE-001-03 scheduler later. Physics pacing follows candidate capacity including real traffic, rendering opportunistic/one outstanding frame/no catch-up renders/no physics waits. Preserve approximate rendering for Author motion review; no pixel/one-pixel/99% gate. PACE-001-01 complete; WIRE/POS/REUSE umbrellas remain open for actual transport/native/implementation scope. New results uncommitted for review; all automated profiles stopped, both SDL dummy drivers forced. Preserved product/old fixtures/SDK/firmware unchanged. Earlier [arithmetic](docs/tasks/RALLY-28/research/HOT-LOOP-REVIEW.md)/[lookup](docs/tasks/RALLY-28/research/LOOKUP-ENGINE-REVIEW.md) evidence remains; sparse lookup reduces centre arithmetic but conservative direct bands add32.88%road bytes. Native FS-001-07 remains separate.

## Preserved direct eZ80 baseline and timing

- [ ] **[RALLY-27](docs/tasks/RALLY-27.md) — Restore direct eZ80 roadway computation in the full game.** R27-01–03 implemented; R27-04 host checks and both-track Flexe demo checks pass. Author reports Console8 gameplay acceptance of the exact direct-eZ80 candidate. On 2026-10-13 the Author reported that the Flexe agent fixed keyboard input; Rally validation with the updated runtime remains pending. [Results](docs/tasks/RALLY-27/RESULTS.md). Remaining regression coverage and emulator review are open; Restoration and prior dirt committed/pushed as `a2a613f` on Author instruction. R27-05 [plan](docs/tasks/RALLY-27/TIMING-PLAN.md) released: fixture/custom diagnostic firmware built and deployed headlessly on Oryx. Final fixture completed twice at nominal 12.19–12.40 FPS in interpreter mode; JIT produced 5.29 FPS once but repeated UART CTS stalls prevent its qualification. A fresh interpreter review profile is prepared and stopped. Fab native backend and physical timing remain unqualified. [Timing results](docs/tasks/RALLY-27/timing/RESULTS.md). Fixture/work contract frozen and pushed as `f3196b9` on Author instruction; remaining human validation is still open. VDPlet integration remains later.

## Active native VDPlet work


- [ ] **[RALLY-24](docs/tasks/RALLY-24.md) — Native VDPlet road and car projection.** First pass sends compact world state, not spans or projected cars; replace both eZ80 visual projection and buffered road matrix arithmetic with native computation. Candidate A is a control only; B is the objective. Research/design tranche complete: [recommendation](docs/tasks/RALLY-24/REVIEW.md). Local tranche complete: [results](docs/tasks/RALLY-24/LOCAL-RESULTS.md). Both candidates pass 5,840 host poses each; B fits one module. Headless Oryx tranche complete: [results/portable hardware fixtures](docs/tasks/RALLY-24/flexe/RESULTS.md). Native execution/log checks pass; B has a documented pixel-parity exception and startup upload stalls remain an emulator follow-up. Author physical runs and game integration remain pending. No hardware work performed. Preserve current Rally and all paused tasks.

- [ ] **[RALLY-25](docs/tasks/RALLY-25.md) — Native traffic simulation and collision callbacks.** **Full-scene native fixture: FS-001-07 investigates failed Author launch (black; startup transport stalls).** FS-001-01–06 built/headlessly qualified/staged; [visual review failed/pending correction](docs/tasks/RALLY-25/full-scene/README.md). Contract/all prior dirt pushedc96a55d.900frames/3600ticks and independent final world pass; final Flexe28.51FPS,397scrolls/24engine changes, original R27 presentation functions and intended eZ80/VDP split.33peer package files match published4beafb0, ten candidate inputs/runtime hashes verified. Author explicitly authorizes checkpoint publication2026-10-14; failed visual acceptance remains open, protected fixtures/results unchanged. TRF-001-55/56 headroom/phase measurements remain ahead of D3 scheduler implementation. TRF-001-54 found the existing full-scene R27-05 Fuji fixture (scrolling scenery/traffic/HUD/audio, collision checks without damage), reusable PRT and VDP marker hooks; its simplified player advancement does not measure actual player physics. R22 basis; VDP-owned opponents/collisions. Historical 120/30 Hz fixtures remain unchanged; future candidate cadence follows RALLY-28 measured pacing, real wire costs and independent opportunistic rendering. Preparation/scope frozen and pushed at `314efe6`, then isolated renderer helper delivered: [results](docs/tasks/RALLY-25/renderer-helper/RESULTS.md). TRF-001-24/25/26 host work complete: 9,120 scenes plus 79 failure/lifecycle/metadata cases pass in ordinary/sanitized builds; generated IDs and independent contexts supported. TRF-001-23/14 complete: Golem accepted the exact v0.3 contract; [record](docs/tasks/RALLY-25/renderer-helper/ACCEPTANCE.md). TRF-001-31–35 complete after pushed checkpoint `4489f58`: [generated state results](docs/tasks/RALLY-25/generated-state/RESULTS.md),2,924 actual generated-C host invocations/two layouts/ordinary+sanitized; all expected root/array bytes match,261 delivery files and44 exported sources verified. Returned for review; broader TRF-001-12/13 target/full numeric integration remains open. Multiplication is peer-reported human accepted/published `1ddfd64`; division is separately identity-received and now owner-reported human accepted, publication pending. TRF-001-36–40 complete after pushed `a31c2ce`: [historical route/contact results](docs/tasks/RALLY-25/route-kernels/RESULTS.md),319,072 generated-C host checks match independent reference; route results frozen at `90919ad`. Golem D2 resource gate reports tiny combined text8224/limit8192 and stack576/allowance512 before real glue; Author agrees to raise both text and stack allowances; Stage A now proposes ceilings64KiB code/16KiB data/128KiB image/2KiB declared stack after measuring the fuller25,620-byte code scaffold; numerical selection/Stage B/coherent policy delivery and combined qualification remain pending (Golem GOLEM-002 capacity protocol). TRF-001-41–45 complete after pushed `90919ad`: [host scene replay](docs/tasks/RALLY-25/scene-replay/RESULTS.md),900 exact independent command frames/3,600 ticks/30 failure-lifecycle cases per four variants; actual simulation/helper with explicitly modeled render wrapper, new work uncommitted for review. Author released TRF-001-46–49 on2026-10-14: build the real composed Fuji demo, headless-check and stage on Oryx; recoverable VDP crashes acceptable. Mail thirty-two releases necessary Golem SDK/glue/runtime work; Rally owns driver/assets/profile: derived source passes3,600 host ticks and the unpaced Oryx driver-only smoke saves its logs. Old hybrid clock coupling blocks deadline pacing (mail thirty-five). TRF-001-46–50 complete: actual Golem/native helper candidate and enlarged/corrected-clock runtime pass900 rendered frames/3,600 physics ticks in full/viewing Oryx controls; final world matches independent model, logs/PRT teardown verified. [Demo visual review accepted; human logs verified](docs/tasks/RALLY-25/native-demo/README.md); TRF-001-53 complete: [byte-identical unpaced comparison](docs/tasks/RALLY-25/native-demo/IDENTICAL-COMPARISON.md), Flexe29.02FPS versus Console823.45FPS; exact ten input files/firmware and resulting reply/final state match, no rebuilding. Console8 staging/manual return qualification TRF-001-51/52 complete at `/test/arcade/rally`: [hardware results](docs/tasks/RALLY-25/native-demo/HARDWARE-RESULTS.json),900frames/3600ticks and independent final state pass; unpaced aggregate fixture23.45FPS, PRT23.49FPS (within0.19%), vector restored. Firmware vdp_rally.bin; card/logs preserved. Timing conversion corrected to nominal120MOS ticks/s (human29.30FPS), viewing28.85FPS against30FPS target; no autonomous scheduling claim; hardware timing is aggregate fixture throughput. New work remains uncommitted. Separate completion storage agreed; array bundle human accepted/pushed by Golem, received but not integrated here; wide simulation and combined-module/native stack/resource qualification remain later work. Helper/accepted contract checkpointed at `e94f0aa`; harness results are frozen at `4489f58`; generated-state results are frozen at `a31c2ce`. TRF-001-27–30 complete after pushed checkpoint `e94f0aa`: [C integration harness/results](docs/tasks/RALLY-25/integration-harness/RESULTS.md),72 Fuji snapshots/two mappings and138 failure/lifecycle groups per ordinary/sanitized build; returned for review. No game/firmware/target run or further pixel research; Author's own visual confirmation remains the final visual gate.

- [ ] **[RALLY-26](docs/tasks/RALLY-26.md) — Resident crash effects and VDPlet state machine.** VDP owns struck-opponent/explosion bookkeeping while other traffic continues; coordinated with RALLY-25/RALLY-28 at a measured fixed simulation cadence and independent opportunistic rendering; preserve real-time effect/recovery durations. Module/state resources and recovery synchronization await review; implementation paused.

## Full-game checkpoint

- [ ] **[RALLY-22](docs/tasks/RALLY-22.md) — Complete Rally, then continue the Extender port.**
  Bounded practice is complete. The full-game candidate implements qualifying,
  races, retained top HUD, deterministic traffic, saves and community signs.
  Headless and bounded hardware checks pass; the normal candidate and source ZIP
  are locally committed. The Author reviewed the presentation and judged the
  gameplay too difficult after the attended Fuji arcade run in R22-11.
  Default startup on stock Fab 1.2.4 was accepted on 2026-09-14;
  difficulty remains unresolved. Development and Extender video work remain paused.
  Afterwards prioritize Extender video speed, then faithful VDP command coverage.
  The Author requested the local commit freeze before discussing new contracts.

## Current BENCH-001 component work

- [ ] **BENCH-001 — Rally telemetry and engine sound**
  - Status: Resident telemetry, CLI driving and engine implemented; the bounded
    hour is complete with retained evidence. Human review and the recorded
    native diagnostic limitation remain open.
  - Details: [BENCH-001](docs/tasks/BENCH-001.md)

## Deferred gameplay work

- [ ] **[RALLY-23](docs/tasks/RALLY-23.md) — Learned driving with batched headless C simulations.**
  Author scheduled for next week: thousands of independent simulations on the
  Pi, actual policy learning and transfer back to ordinary Agon controls.
  Registration only; tonight's work remains RALLY-22/BENCH-001.

- [ ] **[RALLY-21](docs/tasks/RALLY-21.md) — Deterministic traffic move tables.**
  Python generates coordinated opponent routes; sparse speed/direction/turn-rate/tick-count
  entries play through per-car countdowns. Prove opponent separation across
  repeated loops. Implemented in rally-game under RALLY-22; bench stubs are
  preserved. Human review and approval remain open.


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
