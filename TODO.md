# AgonArcade TODO

## RALLY-19 autonomous execution register

The Author authorized the goal, headless-only tests and a commit per completed
checkbox on 2026-09-12. The [frozen contract](docs/tasks/RALLY-19/CONTRACT.md)
defines scope and acceptance. Retain completed marks for this goal as requested.
This ordered register owns progress across AgonArcade and Golem.

0. [x] **R19-00 — Freeze before implementation.** Import the delivered Git
   checkpoint into an isolated Rally worktree; preserve originals. Commit this
   complete plan, oracle identity, scope, acceptance metrics, headless policy and
   per-checkbox commit rule before compiler/game development or experiments.
1. [ ] **R19-01 — Reproduce the accepted application and compiler foundations.**
   Verify handoff SHA256s and a083173 Golem identity; create isolated Golem branch
   and project venvs. Read current design/lifecycle/compiler code; preserve dirty
   deployment files. Build/test the existing compiler examples and exact reviewed
   Rally source locally. Record source/toolchain/runtime/binary/data hashes,
   headless profile locations and how to reproduce. Commit foundation evidence.
2. [ ] **R19-02 — Freeze and validate the visual/performance oracle.** Adapt the
   existing capture infrastructure to canonical Linux headless profiles. Freeze
   >=48 poses and per-object/material masks for the final accepted tuning. Prove
   the comparison catches missing cars/markings and tolerates <=1px edges. Record
   matched 64-pose baseline batches, bytes and stage timing on both tracks, with
   no unlimited CPU or interactive fence. Commit immutable fixture/metric evidence.
3. [ ] **R19-03 — Define Golem's renderer-facing types, lowering and ABI.** Specify
   finite hosted entrypoints, named buffers/fields, relocations, matrix/float and
   integer conversions, alias rules, ID allocation, errors and resource budgets.
   Design only the intrinsics needed by Rally, preserving existing language
   semantics. Fix exact compact state fields, ranges and ordered commit/trigger
   protocol including independent stripe phase and HUD needs. Commit design/tests.
4. [ ] **R19-04 — Implement and qualify reusable stock arithmetic in Golem.**
   Extend the C++ compiler with the defined lowering. Add golden/negative and
   sanitizer tests, preserving print/uint16/addition/For-Next. Run native headless
   varying-input product, multiply-add, reciprocal/division, rotation, negative
   conversion and computed PLOT probes; exercise finite loops/indexed operands.
   Record errors, bytes, timings and scratch lifetimes. Commit compiler then evidence.
5. [ ] **R19-05 — Qualify resident state, lookup and resource lifecycle.** Implement
   symbolic asset/table imports, bounded indexing, typed command-field patching,
   atomic-by-order state update and finite render dispatch. Test malformed and
   incomplete packets, track/table bounds, sequence handling, reload, allocation
   balance and return to outer input processing. Commit compiler/runtime and tests.
6. [ ] **R19-06 — Compute and draw one complete road section on VDP.** Feed only
   game-state/table inputs, evaluate current compact projection coefficients on
   VDP, derive stripe phase/boundaries and plot gray road, kerbs, shoulders and
   centreline. Compare signed/lateral/seam cases against the oracle; measure
   matrix/lookup batching choices and choose a measured construction. Commit proof.
7. [ ] **R19-07 — Extend resident road computation to both complete tracks.**
   Select resident sections, derive all required boundaries/material parity,
   maintain shared edges/finite clipping and lap-independent stripes. Pass the
   frozen road masks and <=1px boundary criterion, no missing material classes;
   report resource and recurring-traffic budgets. Commit full-road evidence.
8. [ ] **R19-08 — Move vehicle projection and draw ordering to VDP.** Use player
   and six competitor track/lateral states to derive visibility, depth ordering,
   screen position, scale and yaw/reflection with existing artwork/liveries.
   Preserve optional perspective OFF and all tyre/hub/helmet colours. Pass per-car
   masks, presence and overlap tests across the frozen poses. Commit scene evidence.
9. [ ] **R19-09 — Integrate the complete Golem-driven Rally frontend.** Add scenery
   bearing/retained-buffer handling and HUD/state mapping to the resident scene
   path. Preserve accepted simulation/input/manual/demo/settings and old renderer
   as an explicit oracle option. Prove a frame requires only compact state/trigger,
   not eZ80-projected corners; test input takeover and MOS exit headlessly. Commit.
10. [ ] **R19-10 — Meet the frozen offload/performance budgets.** Run normal-clock
    serial ABBA on both tracks with identical fixtures and warmed assets; record
    >=75% scene-UART reduction and <=128-byte scene packets, >=50% eZ80 scene-work
    reduction, median <=33.33ms and p95 <=50ms, no >5% median regression. Optimize
    within contract if needed; retain honest end-to-end/timing limitations. Commit.
11. [ ] **R19-11 — Complete stability and independent correctness review.** Run
    >=10 minutes per track of deterministic headless replay, signed extremes,
    overlap, input transitions, reset/reload and shutdown. Verify sequence/memory
    integrity, compiler/loader negative tests and all frozen regional visual
    thresholds. Review generated commands for hidden eZ80 geometry/custom features.
    Commit the audit and reproducible evidence; do not assert hardware acceptance.
12. [ ] **R19-12 — Deliver and stop at the agreed scope.** Document Golem language
    additions, renderer protocol, ownership, build/run/benchmark commands, resource
    totals, final binary/data/compiler hashes and measured limits. Record linked
    Golem/Rally commits, preserve the oracle and update handoffs. Commit final
    evidence, mark the goal complete only if all criteria passed, and report in
    writing without launching an emulator or pushing/deploying anything.

This is the authoritative task checklist. Details are in `docs/tasks/<ID>.md`;
task-specific supporting files belong in `docs/tasks/<ID>/`.

18. [ ] [RALLY-19](docs/tasks/RALLY-19.md): Design compact game-state updates for a VDP-resident scene renderer; derive stripes from distance and resident pitch. Discussion only; implementation scope pending.

17. [ ] [RALLY-18](docs/tasks/RALLY-18.md): Review isolated centreline-camera/road-lookup candidate; headless validation passed. Lookup computation 67.0/71.4 FPS equivalent (oval/Fuji), commands+UART 37.0/41.2; perspective option measured separately. Unfenced 30 Hz review baseline accepted as a working assumption, not a verified guarantee; mainline integration and hardware qualification pending; [results](docs/tasks/RALLY-18/results/README.md).

16. [ ] [RALLY-17](docs/tasks/RALLY-17.md): Review isolated benchmarks: computation/state only 19.73/17.51 ms versus 32.10/27.94 ms including command construction/UART (oval/Fuji); accepted game unchanged.

15. [ ] [RALLY-16](docs/tasks/RALLY-16.md): Review unpaced normal-eZ80 benchmark: resident sections 29.7/29.9 FPS; native VDP swap path contains two vertical-blank waits.

14. [ ] [RALLY-15](docs/tasks/RALLY-15.md): Review isolated VDP-resident full-road renderer — implemented; headless fixed fixture 22.6/23.6 FPS, ordinary demo 18.8/25.2 FPS (oval/Fuji); mainline unchanged.
9. [ ] [RALLY-10](docs/tasks/RALLY-10.md): Investigate performance and frame pacing — pavement experiment measured at 13.6–14.0 FPS; full-road VDP section experiment proceeds as RALLY-15.
13. [ ] [RALLY-14](docs/tasks/RALLY-14.md): Instrument emulator/VDP draw operations and MOS timing callbacks — supports RALLY-10.
3. [ ] [RALLY-04](docs/tasks/RALLY-04.md): Validate the selected Rally build on physical hardware.
8. [ ] [RALLY-09](docs/tasks/RALLY-09.md): Review kerb/grass handling and inset shoulder lines.
7. [ ] [RALLY-08](docs/tasks/RALLY-08.md): Complete scenery and road-edge emulator review.
10. [ ] [RALLY-11](docs/tasks/RALLY-11.md): Qualify implemented retained scenery scrolling; performance remains unaccepted.
2. [ ] [STUNT-01](docs/tasks/STUNT-01.md): Future separate 3D stunt racer.

Completed milestones and acceptance evidence remain in the dated development
logs: [Rally](docs/2026-09-11-rally.md), [Mac continuation](docs/2026-09-11-rally-macos.md),
[Defender](defender/docs/2026-09-11.md), and [research](docs/2026-09-11-research.md).
