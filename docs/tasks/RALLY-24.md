# RALLY-24 — Native VDPlet road and car projection: research and experiment plan

## Executive summary

**First-pass scope: native road and car projection from compact world-state updates.** The eZ80 supplies player/camera and opponent positions plus necessary steering/orientation and control state; it does not send road spans, projected car coordinates/scales, or per-car drawing commands. A classic-ESP32 VDPlet reads resident track/projection data and assets, then generates resident VDU commands for the road and cars. Rally would execute that buffer using ordinary VDP drawing commands. Candidate A retains current buffered section arithmetic as a compatibility control; candidate B replaces it with native endpoint calculation. Neither eliminates graphics dispatch, rasterization or presentation costs. Speedup remains a hypothesis.

**Status: local implementation/build/check tranche complete, 2026-10-12; paused before hardware.** Read the [review recommendation](RALLY-24/REVIEW.md), [proposed ABI](RALLY-24/DESIGN.md), and [measurement/implementation gates](RALLY-24/MEASUREMENTS.md). The Author subsequently approved the local tranche and committing/pushing outstanding work. Local task-silo source development, compilation and deterministic host checks are authorized; emulator changes, hardware deployment and physical qualification remain outside this tranche. No existing paused task is resumed. TODO.md remains the sole task register; this document owns the proposed work breakdown.

Local evidence: [LOCAL-RESULTS.md](RALLY-24/LOCAL-RESULTS.md). Candidate B fits one module and passes host command comparisons; physical execution, pixel parity and performance remain unqualified. The research statements below describe the earlier tranche.

## Scope and preserved baselines

**Author-confirmed objective, 2026-10-12:** replace both the eZ80 visual road/car projection and the retained buffered road matrix/endpoint arithmetic with native Xtensa VDPlet computation. Candidate B is the intended first-pass result. Candidate A is only a diagnostic intermediate/control; retaining its interpreted road arithmetic does not complete this objective. Ordinary VDP drawing, bitmap transforms and rasterization remain available. The eZ80 retains world-space physics, surface classification, traffic simulation and collision detection and sends compact world state, not projected geometry. This clarification authorizes recording the objective, not starting the next implementation tranche.

1. Target the maintained `rally-game/` full game, using the preserved `rally-production/` renderer headers. Keep production, bench and historical Rally directories intact. Do not substitute the old Golem frontend for current Rally.
2. Keep physics, input, traffic simulation/position updates, road/kerb/grass classification, collision detection and game rules on the eZ80 in the first candidate. Move visual road and player/opponent projection to VDP. Preserve HUD, scenery and page ownership semantics; their exact command/state boundary must be specified without weakening the position-only road/car contract. Normal stock-compatible Rally remains available. VDPlet execution explicitly requires runtime-enabled VDP firmware and must be an optional experimental build.
3. Keep Rally-specific modules and experiments in this repository. Reusable ABI/runtime additions belong to `../agon-vdplet` through a separately reviewed proposal. Do not modify that currently uncommitted repository or reinterpret its host tests as physical qualification.
4. Golem sources/evidence are historical comparison material only. No compiler development or revival of the abandoned experiment.

## Initial source findings

| Authority | Finding / consequence |
|---|---|
| `rally-game/src/main.cpp`, main loop | `prepareGameScene`, scenery, `road.emit`, finish line, traffic/player, panels/HUD, then `vdp_swap`; retain this ordering. |
| `rally-game/include/game_scene.hpp` | `prepareGameScene` calls `road.project`; projected centres also position traffic and the player. The revised first pass moves these visual consumers to VDP too; distinguish them from world-space physics and surface classification. |
| `rally-production/include/lookup_road.hpp` | Current road uses loaded lookup data and polynomial/interpolation work, not an assumed full floating-point 3D engine. Quantify the actual hot path. |
| `docs/specifications/rally-full-game.md` | Mode 136, 320×240 colour/double buffering; physics nominally 120 ticks/s; four-tick frame target is not proof of 30 displayed fps. Steering remains per rendered frame. |
| `../agon-vdplet/include/vdplet.h` and `docs/API-reference.md` | ABI 1.0; finite synchronous entry in VDP command task; checked contiguous buffer services, up to four live buffer leases; pointers expire at release/return. RUN argument buffer at most 32 bytes, read-protected. |
| Same runtime reference and supplied handoff | One active module; restricted 16 KiB package / 8 KiB text / 4 KiB data+BSS profile; no general drawing callback or C++ runtime. Confirm linked sizes and imported compiler helpers later. |
| Same API reference | Direct framebuffer service is single-buffered PALETTE2 only: unsuitable for current Rally. Buffer generation needs buffer capability only. Silent RUN costs 17 bytes; resident wrapper call costs six, excluding state upload and subsequent draw/swap. |

These are initial read-only findings, not a completed lifetime/ABI audit. The VDPlet repository has no committed HEAD at inspection; establish content hashes and toolchain/source pins before any later experiment.

## Research tranche record

The Author approved this research/design tranche after reviewing the roadmap. Read-only source/official-document inspection and source-derived size/byte accounting are complete; no builds, tests, firmware or application changes occurred. Checked items below mean the design is documented, not that the proposed implementation has passed. Scope dependency found: existing sign, finish-line and crash geometry also moves to avoid projected-coordinate round trips; new effects remain RALLY-26.

## Proposed investigation sequence

### REV — map the real costs and dependencies

- [x] REV-001 — Trace road projection, band/material selection, VDU emission, UART submission and swap/pacing in current Rally. List every consumer of projected centres and exact fixed-width arithmetic/rounding semantics, including eZ80 integer-width assumptions.
- [x] REV-002 — Review retained pre-Golem and Golem measurements for reusable poses, traces and instrumentation. Separate emulator evidence from physical results; reject incompatible comparisons rather than treating prior FPS as a current baseline.
- [x] REV-003 — Read VDPlet loader/runtime and examples for actual admission, buffer mutability, command-stream ordering, finite execution, stack and cleanup guarantees. Check module-buffer aliasing and queued drawing before proposing command-buffer reuse. Consult local official VDP buffered-command documentation where needed.

### ABI — specify bounded road/car jobs

- [x] ABI-001 — Specify byte-exact, versioned little-endian input/output layouts, reserved fields, ranges and error status. Proposed job: generate one frame's road and player/opponent drawing commands from world state. RUN arguments can identify a larger state buffer containing all cars; do not assume every position fits in the argument block. Keep RUN arguments within 32 bytes; larger immutable track/tables live in separately acquired buffers. Assign buffer IDs only after auditing current Rally allocations.
- [x] ABI-002 — Specify ownership of input, lookup data, command output, status and wrapper buffers; lease count, capacities and invalidation on track/module changes. Define completion publication last, and prevent executing stale/partially written commands after a failed silent RUN. A following buffer CALL is not automatically conditional on native success: resolve this explicitly.
- [x] ABI-003 — Resolve variable output length, trailing bytes, command termination, maximum bands and signed clipping. Prefer bounded, initialized command layouts; never interpret uninitialized output or rely on undocumented buffer truncation.
- [x] ABI-004 — Move road centres, car screen position/scale/yaw/view selection and draw ordering to VDP. Separate world-space surface/collision calculations retained on eZ80 from visual projection; eliminate the latter's eZ80 dependencies rather than shipping projected coordinates or reading them back. Specify coherent state sequence/physics tick for every car in a submitted frame.

### EXP — select the smallest useful candidate

- [x] EXP-001 — First propose one road section as a correctness probe, followed by complete road and car command generation on both tracks if resources and semantics fit. A road-only probe is an intermediate check, not completion of the first pass. Preserve colour, kerbs, shoulders, centre markings, clipping and ordering with scenery/finish/traffic.
- [x] EXP-002 — Compare current eZ80 generation against native generation using identical VDU command semantics and poses. Verify that recurring road/car traffic contains world state and invocation only. Count any retained non-road/car commands explicitly. Do not accept eZ80 car projection as the completed first pass. Reject the proposal before implementation if the useful work cannot fit current services or resource limits.
- [x] EXP-003 — Specify explicit feature detection and failure/exit behaviour, original firmware/startup/binary backups, module unload and buffer cleanup. Keep production startup unchanged. Identify runtime physical qualification as a prerequisite, not something Rally's host checks establish.

### MEA — define correctness and performance evidence

- [x] MEA-001 — Freeze source/toolchain/firmware/module/data hashes and comparable scene inputs. Separate installation/upload/load cost from recurring state updates, RUN, command-buffer CALL and swap traffic; count complete wire packets, not just the six-byte wrapper.
- [x] MEA-002 — Plan paired baseline/candidate/control runs with the same runtime-enabled VDP firmware to isolate native offload; include stock-firmware baseline separately where useful. Match hardware clocks, mode, scene, pacing, warmup and diagnostics. No unlimited-CPU emulator result substitutes for hardware.
- [x] MEA-003 — Measure eZ80 calculation and submission, native entry execution where observable, drawing completion, and realised presentation separately. Module return and buffer-call return do not establish completed display frames. Record synchronization method and diagnostic overhead; no unsupported timing precision.
- [x] MEA-004 — Use both tracks, straight/tight curves, wrap, signed lateral extremes and min/max band cases; freeze deterministic poses. Compare generated commands/coordinates and complete colour output against current renderer, documenting any tolerance before tests. Preserve HUD/sky/page history, player and traffic alignment.
- [x] MEA-005 — Report median/p95/max elapsed milliseconds, completed frame rate where measured, recurring bytes, load cost, text/data/BSS/stack and VDP buffer memory. Repeated paired ordering should expose warmup/order variation. State whether the gain is CPU relief, wire reduction, displayed cadence or none.
- [x] MEA-006 — Propose numerical acceptance thresholds after auditing existing evidence, before running a candidate. Correctness and no material full-frame regression are mandatory; 30-fps pacing may hide headroom gains. Do not increase render cadence silently because that changes per-frame steering response.

### PLN — Author decision gate

- [x] PLN-001 — Present the hot-path map, exact proposed ABI, unsupported dependencies, memory estimate, measurement matrix and recommendation. Name unresolved runtime-service requirements separately.
- [x] PLN-002 — Author approved local implementation/build/checks on 2026-10-12. Contract frozen in LOCAL-CONTRACT.md. Hardware scope remains a separate gate. Human visual acceptance remains necessary for new output.

## Questions the research must settle

1. Is VDU command construction a large enough cost after the existing lookup optimisation to justify native execution?
2. Can the output buffer be updated and invoked safely using only existing ABI services, including failure handling, without per-frame replies?
3. Can resident tables meet contiguous-buffer constraints and ESP32 memory limits while retaining existing assets and double buffering?
4. Can all required road/car visual projection fit bounded native jobs while world-space surface checks and collisions remain on eZ80? If not, report a blocker rather than silently reduce scope.
5. Does synchronous native execution delay input/VDP servicing enough to offset its benefit?
6. Which physical completion signal can measure actual rendering without changing the production timing contract?

## Current roadmap and processor boundary

The Author clarified this scope on 2026-10-12. These are ordered proposals for review, not execution authority. Later stages have separate task records and do not block a useful first-pass result.

| Stage | VDP responsibility | eZ80 responsibility | Owning task |
|---|---|---|---|
| 1 | Road spans/materials and car projection/view/scale/order; resident command generation | World positions, physics, surface classification, traffic simulation, collisions, rules and input | RALLY-24 |
| 2 | Evaluate moving traffic position updates and collision tests; sequenced collision events | Consume events and apply authoritative gameplay outcomes under an agreed timing contract | RALLY-25 |
| 3 | Resident explosion animation and bounded effect updates; optional module swaps | Start/cancel effects and manage gameplay transitions and invocation timing | RALLY-26 |

Track data, projection tables and car artwork/liveries should be installed once and stay resident. Each frame updates world state, not precomputed visual geometry. Position alone may not encode steering, pose or phase: specify the minimal necessary additional fields instead of claiming literal position bytes are always sufficient. HUD/scenery/audio and lifecycle traffic must remain visible in the full byte accounting.

Use the existing synchronous transport for the first comparison. A possible future asynchronous UART transfer is independent; it neither blocks this work nor counts toward the measured offload gain. Measure host cycles spent submitting as well as bytes: less UART babysitting is an explicit objective even if fixed presentation pacing conceals an FPS gain.

Multiple VDPlets are in scope if needed, but current runtime admits one active module. Stored packages are not simultaneously executing modules. Before stage 1 depends on switching, specify state outside module data/BSS and measure load/relocation costs. Prefer a common racing job if it fits; do not assume rapid per-frame swapping is free. Stage 3 owns the broader effect-state-machine proposal.

## Review boundary

This task records a proposed investigation and experiment. No success, speedup or hardware readiness is asserted. Changes are confined to planning/research documents and root TODO registration. Local implementation is authorized under LOCAL-CONTRACT.md; hardware remains gated. Choplifter was preserved in a separate commit under the Author’s commit-all instruction.
