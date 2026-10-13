# RALLY-25 — VDP-owned opponents, collisions and paced simulation

## Executive summary

Author planning amendment, 2026-10-13: use the complete RALLY-22 game as the integration basis for native VDPlet rendering, building on RALLY-24. The eZ80 owns player physics and game rules and sends compact player-state updates, including track position and engine RPM where needed. The custom VDP owns opponent simulation, collision detection, opponent bookkeeping and crash/explosion presentation. All physics runs at fixed 120 Hz; rendering is explicitly paced to 30 Hz, one render deadline per four simulation ticks. Preserve the current direct-eZ80 RALLY-27 game and fixture as the baseline/rollback.

**State: work contract frozen on Author instruction, 2026-10-13.** The Author authorized committing/pushing the current state, then an unattended high-effort tranche covering GOL-000-01 through GOL-000-10 and the qualification plan portion of GOL-000-11. Capability investigation, established-mailbox exchanges and prototype-contract negotiation may proceed. Actual implementation, delivery qualification, runtime/firmware changes and deployment remain outside this tranche; present results at GOL-000-12. Subtask IDs are now frozen. Root TODO.md remains the sole authoritative task register. Subtask identifiers below are permanent: mark their following checkbox `[x]` when completed or otherwise disposed, recording the disposition/evidence; never renumber or reuse an identifier. Existing RALLY-24 fixture rates are promising evidence, not a demonstrated integrated-game ceiling or proof of available frame headroom.

## Prerequisite — investigate current Golem capability

**GOL-000** [ ] — **First work, before all other RALLY-25 phases.** Investigate the current maintained Golem compiler, language, backends and runtime integration to determine whether they can express and deliver the proposed native VDPlet game component. Do not judge present capabilities solely from the abandoned RALLY-19 experiment or assume that buffered-command generation and native Xtensa compilation are equivalent. This subsection defines an investigation to perform after review; it does not select Golem as the implementation language in advance.

- **GOL-000-01** [ ] — Identify the authoritative current Golem checkout/branch/revision, local modifications, maintained documentation, supported targets and relevant tests/examples. Distinguish current implementation from historical copies, proposals and unimplemented features. Record exact source identities and evidence.

- **GOL-000-02** [ ] — Map the proposed component to demonstrated language/compiler features: persistent opponent/effect state, arrays/records and stable IDs, fixed-width signed arithmetic, route playback, world-space collision checks, bounded loops, fixed 120 Hz simulation steps, 30 Hz render entry points and reusable drawing routines. Check memory layout, lifetime and initialization rather than assuming host-language behavior carries over.

- **GOL-000-03** [ ] — Establish whether current Golem can emit native Xtensa code or otherwise produce a loadable VDPlet through a supported toolchain. Audit module format, entry/export conventions, host-service bindings, buffer access, allocation/stack limits and calling conventions. A buffered VDU program is not evidence of native VDPlet support. If a C/C++ bridge or new backend would be required, state that explicitly with its scope.

- **GOL-000-04** [ ] — Separate compiler/language capability from missing firmware/runtime services. Audit the ability to bind telemetry snapshots, timer/task-driven bounded invocation, collision-event publication and rendering services under the proposed ownership model. Identify which needs can use existing interfaces and which require new Golem, VDPlet-runtime or custom-firmware work. Do not assume timer callbacks can directly run arbitrary module code safely.

- **GOL-000-05** [ ] — Examine correctness and performance evidence relevant to generated arithmetic, control flow, memory use and code size. Preserve RALLY-19 failure findings as reference, but distinguish their particular buffered lowering from any current native implementation. Do not infer 120 Hz simulation or 30 Hz full-game viability from feature presence or old fixture FPS.

- **GOL-000-06** [ ] — Produce `RALLY-25/GOLEM-CAPABILITY.md` with an executive conclusion, a requirement-to-evidence table (supported / partial / missing / unverified), blocking gaps, smallest necessary extensions and a recommendation: usable now, usable with bounded extensions, or unsuitable for this tranche. Describe any minimal proof still needed; new builds/probes or edits in independently owned projects require separately reviewed scope.

- **GOL-000-07** [ ] — Enumerate capability gaps with stable gap identifiers and a disposition for each. State the functionality Rally needs, a concrete use case, required semantics, priority/blocking status, existing workaround if any, acceptance evidence and proposed owner (Golem compiler/language, VDPlet runtime, custom firmware or Rally). Distinguish missing functionality from unverified support; provide requirements the Golem agent can implement rather than only an unsuitable/suitable verdict.

- **GOL-000-08** [ ] — Exchange the capability findings and functionality requests with the Golem agent through the established agent mailbox system. Consult `agon-dev-env/cross-agent/README.md` and the applicable topic index, including the existing `rally_golem` topic, to confirm participants and current scope; distinguish this new native VDPlet effort from historical RALLY-19. Follow canonical timestamped filenames, message front matter and backward references. Published messages remain immutable; update the topic index and keep negotiation provenance linked to each gap.

- **GOL-000-09** [ ] — Negotiate versioned prototype contracts for the requested functionality with the Golem agent. Specify interfaces and examples, fixed-width types/arithmetic, state/buffer layout and ownership, lifetime, calling conventions, scheduling/thread restrictions, failure behavior, resource limits, build/module format and acceptance cases as applicable. Clearly distinguish agreed semantics from open questions and provisional assumptions. Record who implements each side and which deliverables unblock Rally; promote accepted decisions into the topic's normative contract rather than relying on mailbox discussion alone.

- **GOL-000-10** [ ] — Define parallel implementation boundaries so Rally can code against agreed prototype contracts while the Golem agent provides the missing functionality. Identify independently implementable Rally adapters/call sites and faithful stubs or fixtures, ownership fences, dependencies, integration checkpoints and compatibility/version checks. Mark stub results as provisional, not proof of real Golem support or performance. Record semantic collisions through the mailbox before resolving shared interfaces; involve the Author where a design choice remains disputed.

- **GOL-000-11** [ ] — Plan replacement of prototypes/stubs with Golem deliverables and joint contract qualification. Verify generated module loading, required arithmetic/state behavior, telemetry/event bindings and timing/resource constraints against the agreed cases. Track each gap to accepted delivery, deferral or rejection with evidence. Update the capability report and contract when implementation reveals a necessary change; do not silently let the two sides diverge.

- **GOL-000-12** [ ] — **Review gate:** present the capability/gap assessment, negotiated prototype-contract approach and parallel work boundaries before advancing into implementation. The Author has now released the investigation/mailbox/contract-drafting tranche. This does not revive RALLY-19 or authorize backend/game/firmware implementation. Once the reviewed work scope is released, agreed contracts may support parallel Rally and Golem development without waiting for every Golem feature to be finished. Root TODO.md owns actionable status; the sections below remain the proposed downstream design.

## 1. Ownership and collision behavior

- **TRF-001-01** [ ] — eZ80: player physics at 120 Hz, input, game clocks/rules, scoring and player crash recovery. Send sparse player telemetry/state rather than opponent positions, projected vertices or per-frame drawing lists. Specify player orientation/speed and recovery state only as needed by VDP simulation and presentation; freeze the packet fields during design review.

- **TRF-001-02** [ ] — VDP: opponent positions and routes at 120 Hz, world-space collision checks, opponent lifecycle and rendering/effects. It identifies and takes out the correct opponent on collision, handles its explosion/removal and related bookkeeping, and keeps unaffected opponents moving. Exact opponent return/despawn policy remains a review detail; do not invent permanent removal semantics.

- **TRF-001-03** [ ] — On collision, notify eZ80 through the custom keyboard-packet callback interrupt. The eZ80 needs only notification that a collision occurred, not opponent identity. It saves its current track position, performs a preset timed countdown and resumes racing. The countdown duration and restart motion rule remain to be specified; do not silently inherit a duration or relocation behavior from the old crash code.

- **TRF-001-04** [ ] — Opponent identity/generation remains VDP-internal. The wire notification may include minimal event/session sequencing for duplicate/stale-event rejection, but must not require eZ80 opponent bookkeeping. Latch one player collision/recovery episode so persistent contact cannot restart the countdown repeatedly. Define rearming and recovery synchronization explicitly.

- **TRF-001-05** [ ] — The MOS interrupt callback copies recognized event data into a bounded mailbox/queue and returns. Foreground eZ80 code handles the recovery state. Real keyboard events must pass through unchanged; synthetic packets must be neutralized before normal MOS key processing.

## 2. Fixed simulation and paced rendering

- **TRF-002-01** [ ] — Every physics update, on both processors, uses the fixed 120 Hz simulation timebase. VDP opponent simulation and collision checks are independent of the render cadence. Advance discrete simulation ticks; do not substitute one large variable-delta physics update or one simulation update per rendered frame.

- **TRF-002-02** [ ] — Render at fixed 30 Hz deadlines: one frame per four simulation ticks. Do not use a render-as-fast-as-possible loop for the playable VDPlet game. The objective is regular cadence and headroom for additional features, rather than consuming all available time with rendering.

- **TRF-002-03** [ ] — Read the latest complete player-state snapshot without waiting for a new telemetry packet at every render or simulation tick. Define timestamp/tick alignment, buffering and the treatment of player state between sparse updates; no interpolation/extrapolation policy is selected yet. Neither processor's simulation should silently stall waiting for the other.

- **TRF-002-04** [ ] — Use absolute deadlines rather than accumulating work-time drift. Measure simulation latency, render duration and missed deadlines; pacing alone does not guarantee zero frame skips. Specify bounded catch-up, backlog and overrun behavior for review before implementation, with no silent physics-step loss or burst of stale renders.

- **TRF-002-05** [ ] — Preserve normal MOS/eZ80 input semantics. Existing per-render steering/grip adjustments need an explicit timebase decision before decoupling input/simulation from rendering. Do not silently change handling by applying those adjustments on every faster loop iteration.

## 3. VDP scheduling and telemetry reception

- **TRF-003-01** [ ] — Existing VDP UART reception uses interrupt-driven HardwareSerial buffering and RTS flow control. The command parser consumes received bytes in a FreeRTOS task. Receiving bytes while drawing is different from parsing/applying new player state during a native call.

- **TRF-003-02** [ ] — Current VDPlet native entries run synchronously in the VDP command task and must return. The runtime does not currently supply an autonomous 120/30 Hz game scheduler. This plan requires a reviewed custom-firmware scheduling extension rather than assuming the renderer can remain inside a module indefinitely and still consume commands.

- **TRF-003-03** [ ] — A periodic ESP32 timer should signal due work using task notifications or an equivalent bounded mechanism. Timer callbacks stay short; perform neither rendering nor telemetry parsing in the interrupt/timer callback. A receiving/command task assembles complete state packets and atomically publishes a snapshot; the game task consumes it and owns opponent simulation, collisions and render scheduling.

- **TRF-003-04** [ ] — Freeze task/core ownership, synchronization, module lifetime, drawing API access, memory budgets and shutdown ordering before implementing this extension. A separate render task is a proposal to validate, not proof that existing Canvas/VDPlet services are safe for concurrent calls. Preserve one clear drawing owner and valid double-buffer/page histories.

- **TRF-003-05** [ ] — Add the collision return service through owned custom firmware/runtime dispatch, reusing Pingo's keyboard-packet framing pattern. Current module services do not expose unrestricted UART/callback access. Define small packets, registration, queue capacity, overflow/recovery and teardown; do not call MOS from a VDP callback or do game work in the MOS interrupt handler.

## 4. Review work and evidence gates

- **TRF-001** [ ] — map retained RALLY-22 rules/assets to RALLY-24 native rendering and VDP-owned opponent state; preserve the RALLY-27 direct baseline and deprecated experiment evidence.

- **TRF-002** [ ] — specify common 120 Hz tick alignment, sparse telemetry semantics, latest-snapshot publication, absolute 30 Hz deadlines, bounded catch-up and steering/grip timebase. Review task/core and drawing ownership.

- **TRF-003** [ ] — Specify and review the VDP scheduler, telemetry receiving task, drawing ownership and collision-return service described in TRF-003-01 through TRF-003-05.

- **COL-001** [ ] — specify the minimal collision-notification transport and MOS mailbox, including stale/duplicate handling, registration and safe teardown; no opponent identity requirement on eZ80.

- **COL-002** [ ] — specify the player countdown/restart contract and VDP collision latch, correct opponent effects/removal, unaffected traffic continuation and rearming. Coordinate [RALLY-26](RALLY-26.md).

- **VAL-001** [ ] — plan deterministic 120 Hz replay, collision/near-miss/lap-wrap cases, sparse/missing telemetry, recovery and event duplication, render overruns, queue pressure, exit and reset. Measure completed FPS, cadence, physics backlog, callback latency, wire bytes and both processors' work. Resolve RALLY-24 parity exceptions before promotion; record native/Fab/Flexe/physical evidence separately.

- **REV-001** [ ] — present the concrete ABI, scheduler, recovery choices and resource budget for Author review before code/runtime changes or hardware tests. Reuse RALLY-27 fixture measurements where appropriate without treating its unpaced diagnostic firmware as the playable scheduler.

## 5. References and authority

Code inspection: `agon-vdp/video/vdp_protocol.h` configures receive buffering/flow control; `video/video.ino` creates the command-processing task; `video/vdu_stream_processor.h` reads received bytes. The installed ESP32 SDK exposes periodic `esp_timer` callbacks and recommends notifying tasks for substantial work. `agon-vdplet/docs/API-reference.md` defines synchronous native entries that must return. Pingo's render-completion callback demonstrates the return-packet pattern, not an already implemented autonomous game loop.

This amendment supersedes the older proposals to move only one of traffic/collision detection initially and to send opponent identity back to eZ80. RALLY-24's existing implementation still has eZ80-owned traffic/collisions until a new integration is approved. RALLY-20 remains paused and the RALLY-19 Golem renderer remains abandoned. GOL-000 proposes evaluating current Golem capabilities for the new native component; it does not resume that old renderer. Bounded driving practice stays complete. The Author authorized the initial all-dirt commit/push to freeze the work contract and current state. Preserve subsequent audit/coordination changes for review. Stop at GOL-000-12 before implementation; do not infer additional commit/publication authority for new work.
