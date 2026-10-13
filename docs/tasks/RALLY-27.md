# RALLY-27 — Restore direct eZ80 roadway rendering in the full game

## Executive summary

Replace the buffered roadway computation in `rally-game/` with the historical direct eZ80 renderer while preserving the complete RALLY-22 game. The eZ80 will calculate projection and final road, kerb, shoulder and centre-marking vertices and send ordinary VDU drawing commands. This becomes the playable baseline for a later VDPlet comparison. Removing Golem alone did not accomplish this: the current full game retained the older RALLY-15 buffered matrix stage.

**State: R27-01–03 implemented; R27-04 partially qualified; Console8 gameplay accepted, 2026-10-13.** The Author authorized the first tranche after committing/pushing prior dirt, then authorized SD deployment and reported that everything worked as expected. The deployment receipt identifies the exact direct-eZ80 candidate. The Author now reports the Flexe agent fixed keyboard input; validation of Rally with that updated runtime remains pending. See [results](RALLY-27/RESULTS.md) and [baseline](RALLY-27/BASELINE.md). No measured FPS or exhaustive physical phase coverage is claimed. Implementation remains uncommitted; explicit commit/push approval is still required. This task takes priority over further RALLY-24 integration. RALLY-24's sources, measurements and unresolved parity issues remain preserved. Root TODO.md owns task status; the numbered steps below define this task's execution plan and evidence gates.

## 1. Evidence and selected approach

The [version catalogue](../research/rally-versions/README.md) distinguishes the implementations and inventories local copies. Main at 4f2bb15 contains the full game; existing dirty RALLY-24 work and the catalogue must survive unchanged.

| Input | Role | Important qualification |
| --- | --- | --- |
| `rally-game/` | Destination and gameplay authority | Full title/menu, qualification, circuit/arcade races, HUD, signs, audio, saves and collision recovery |
| `rally/include/road.hpp`, `rally/src/main.cpp` | Direct geometry algorithm and integration reference | Historical playable prototype; do not transplant its old game loop or physics |
| `rally-production/include/road.hpp`, track/band headers | Compare preserved direct geometry definitions with historical donor | Current shared types/constants must not change inadvertently |
| `rally-production/include/lookup_road.hpp`, `section_road.hpp`, `section_protocol.hpp` | Current renderer to replace in the full-game call graph | eZ80 lookup centres followed by VDP buffered matrix expansion |
| RALLY-24 experiment/Flexe evidence | Preserved future comparison | Not the direct-eZ80 baseline and not a playable native game |

This is a selective source integration on main, not a Git branch merge. Use a game-owned direct-road adapter/header where needed rather than modifying preserved production headers or reviving the old executable. Reuse the proven direct projection and final-vertex arithmetic; adapt its interface to the current game. Do not merely replace VDP matrices while retaining the lookup renderer and label that the historical implementation.

Ordinary bitmap buffers, car/sign affine scaling, livery preparation and graphics rasterization remain available. The prohibition is buffered **road geometry computation**, not every use of the buffered API. No custom firmware or VDPlet is required by the resulting normal game.

## 2. Scope and invariants

1. Preserve current track geometry, physics, steering behavior/defaults, 200% default grip, traffic routes and policies, collision/surface handling, game clocks and normal presentation cap.
2. Preserve title/attract, selectors, qualification, race transitions/time extensions, results, scoring and existing save format. Preserve optional full-game telemetry without making it a normal runtime dependency.
3. Preserve retained per-page HUD and panorama scroll regions, clipping activation, actor/sign depth order, finish line and crash graphics. Preserve player tyre anchor and current traffic/sign placement conventions.
4. Preserve `rally-production/`, `rally-bench/`, historical `rally/`, Golem history, and RALLY-24 artifacts. No branch rewrite, cleanup of old binaries or unrelated refactor.
5. Remove the normal full game's dependency on `LookupRoad`, section startup programs and their per-section buffer calls. Direct road projection should need no `.road` coefficient file. Remove that requirement from loader, packaging and documentation only after verifying no other consumer requires those files; do not delete historical assets.
6. No difficulty rebalance, frame-rate cap change, asynchronous UART work, Extender/EMOS changes or VDPlet integration in this task.

## 3. Work plan

### R27-01 — Preserve inputs and settle the renderer interface

Record relevant Git/source/binary hashes, build flags, compiler identity and existing dirt before editing. Preserve the current full-game binary and build manifest separately from future outputs. Compare donor and shared road/track/band definitions to prevent silent geometry or physics changes.

Map every renderer dependency: `loadTrack`, `project`, `centerAt`, `emit`, `bands`, error reporting/destruction, startup upload, scene preparation, player anchor, traffic, signs, finish line and debug HUD. Verify requested `centerAt` rows, including traffic above RoadTop, and endpoint row224. Specify signed arithmetic, truncation/rounding and range behavior before adapting them.

**Output:** `RALLY-27/BASELINE.md` with immutable input identities and a short interface/geometry decision table. Stop for discussion if preserving game behavior requires a new design choice rather than an adapter.

### R27-02 — Implement and qualify the direct-road component

Create the game-owned direct renderer using the donor's live fixed-point projection and direct quad emission. Keep a simple interface suitable for existing templated scene/sign preparation. Calculate all final road vertices on eZ80; no buffered matrix, lookup transform, or resident road program may remain in this component.

Use deterministic host cases for both tracks: straights, tight bends, lap/stripe seams, signed/offscreen positions, boundary rows and material changes. Compare against the independently retained donor, not an oracle that calls the new implementation. Check material layering, shoulder widths, adjacent section seams, finite output and stream bounds. Direct commands are larger: measure worst-case capacity and choose a bounded allocation or ordered chunk flush if necessary; never silently truncate or exit mid-frame. Avoid large new stack allocations and preserve constant initialization required by the toolchain.

**Output:** component source, focused tests, byte/geometry results. Exact agreement is required with the selected donor arithmetic; document necessary interface adaptations separately.

### R27-03 — Integrate into the normal full game

Replace LookupRoad instantiation and coefficient-file load/error/destructor lifecycle. Remove road `section::Startup` upload and buffered road submissions. Wire the direct component into current scene preparation and keep ordinary drawing order, viewport activation and HUD exclusion intact. Do not replace the current game loop with the prototype's loop.

Audit the resulting call graph and emitted road stream. Confirm eZ80 computes final vertices and road commands contain only ordinary drawing operations. Separate permitted bitmap/affine traffic from forbidden road arithmetic. Update normal packaging/runtime instructions to reflect actual ancillary-file requirements. Retain history through preserved source/products, not a default runtime switch back to buffered geometry.

**Output:** playable build in `rally-game/`; no production/bench source changes.

### R27-04 — Regression and visual qualification

Run `make -C rally-game test` and `make -C rally-game`, using repository `.venv/bin/python` for tooling. Extend existing tests only where necessary for the new renderer/interface. Verify build manifest, empty dynamic initialization tables, RAM/stack/stream budget, ordinary CLI behavior and optional telemetry build compatibility.

Reuse bounded headless game-flow fixtures for title, both track/mode selections, qualification success/failure, race completion/timeout, crash recovery, saves and Escape exit. Assisted fixtures prove transitions only, not handling. Compare deterministic scenes against the direct donor for road geometry and against the previous full game for preserved HUD/artwork/order. The old buffered road is not the pixel oracle for the replacement; explicitly report expected projection/rounding differences rather than accepting blanket image tolerances.

Capture straight/curve/seam scenes on both tracks, both drawing pages and HUD retained through turns. No new driving-learning campaign.

**Output:** `RALLY-27/RESULTS.md`, captures, test receipts and unresolved exceptions.

### R27-05 — Establish the actual eZ80 timing baseline

**2026-10-13 planning amendment:** [TIMING-PLAN.md](RALLY-27/TIMING-PLAN.md) defines the Author-requested fixture and supersedes the initial sequencing below where they differ: current direct renderer only, completed FPS first, Fuji attract-derived workload, a nominal 30-second MOS-tick window and deliberate pacing removed on both processors. Detailed stage timing is subsequent drill-down. The plan is paused for review; implementation and headless Oryx deployment await explicit go-ahead.

Reuse RALLY-24's deterministic world-state cases where applicable, but execute **live eZ80 projection, vertex construction and UART submission**. Do not time a precomputed VDU replay and call it this baseline. Separate geometry CPU time, command bytes/submission, completion waits and whole-frame timing where the available instruments support it.

Run headlessly in an isolated Flexe profile on the review host with normal eZ80 limiting; record exact MOS/VDP/frontend/engine identities. Include both tracks, straight/curve and traffic controls. Preserve the normal paced game; an unpaced timing fixture must be separately built and labelled. Keep logs within fixture directories for later Author-run hardware collection. No per-frame SD writes or performance hooks in the normal release.

Report milliseconds, median/p95 and completed-batch throughput with clock limits. Distinguish emulator, physical, submission and presentation measurements. R24 results may be shown only with their different workload/timing boundaries stated; a claimed speedup requires matched measurements. Do not expand into VDPlet integration to obtain this baseline.

**Output:** reproducible fixture, fixture-local logs/decoder, resource and timing tables. Performance is measured, not assumed to improve; a severe regression warrants review rather than restoring buffered geometry covertly.

### R27-06 — Human review and closeout

Prepare the normal playable candidate on the review host with an isolated canonical profile, verified assets and startup. Leave it stopped and supply the exact profile-local `cd ...` then `./flexe-agon-emulator` commands. Author checks title/selectors, driving on both tracks, road/HUD correctness, traffic/signs, crash behavior and exit.

Stage physical fixtures only under subsequent hardware authority; current R24 physical runs remain Author-controlled. Historical hardware acceptance does not validate this build. Record human findings separately from automated results. After explicit emulator validation and commit approval, commit the scoped work, update the current full-game specification/README and record the new direct baseline for RALLY-24. Push only when authorized. Do not claim physical acceptance without a new physical run.

## 4. Acceptance and stopping conditions

| Requirement | Evidence needed |
| --- | --- |
| Direct eZ80 roadway is the normal path | Source call graph and decoded road stream; no resident matrix geometry calls/startup |
| Full game retained | Existing tests plus bounded phase/input/save regression and Author playtest |
| Geometry correct | Independent donor cases, seam/bounds tests and scene captures; explicit exceptions |
| Safe resource use | Build/map/initialization checks, bounded stream and memory/stack accounting |
| Useful future benchmark | Actual eZ80 work and UART timing, identities, reproducible logs, honest clock limits |
| Preserved rollback | Original full-game inputs/binary and historical directories retained |

Pause on ambiguous geometry semantics, unexplained corruption, resource exhaustion, game-flow/input regression, or a need to change physics/track behavior. Routine implementation fixes stay within scope. Do not mark completion solely because compilation or a demo run succeeds.

## 5. Sequencing and authority

The Author selected this direct-renderer restoration before continuing VDPlets and requested this formal plan. The Author subsequently authorized R27-01–04, using the new Flexe Agon Emulator on the review host, after committing and pushing existing work. No new goal tracker was requested. Further timing work remains R27-05, outside this tranche.

The R27-01 through R27-04 implementation tranche has delivered the direct candidate with recorded qualification exceptions. Subsequent authorized Console8 deployment and reported gameplay acceptance satisfy a physical review checkpoint, without closing all regression or emulator review gates. The Flexe input repair is reported by the Author; its new runtime identity and Rally results have not yet been recorded here. R27-05 then produces matched timing evidence; R27-06 is the human acceptance gate. If a gate fails, preserve findings before moving on. Canonical emulator rules prohibit committing coupled emulator changes until explicit human validation and commit approval.

The task structure follows Extender's REMOTE-007 and SCAN-001 examples: executive conclusion, evidence, scope, stable work IDs, concrete outputs and distinct acceptance gates. Supporting artifacts belong in `docs/tasks/RALLY-27/`; root TODO.md remains the sole task register.
