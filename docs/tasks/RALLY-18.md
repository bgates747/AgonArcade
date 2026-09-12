# RALLY-18

**Accepted execution contract — frozen by checkpoint commit.** 2026-09-12.
The user accepted this contract, explicitly authorized committing the current
repository state and this contract, and instructed implementation to proceed.
Root `TODO.md` remains the only authoritative task checklist. Further changes
to this frozen contract require agreement; record implementation evidence and
decisions separately in the task bucket.

## Intended result

Fix the camera laterally to the track centreline at the player's current
longitudinal position. Continue advancing the camera along the track and
orienting it along the local track tangent. Move the player car across the
road instead of moving the road sideways with the player. Steering must not
change road geometry at an otherwise identical track position and stripe phase.
Curves still move through the view as the player advances.

Precompute the existing courses' centreline-camera road projections offline.
At runtime, look up road centres using track progress and screen row rather
than repeatedly sampling map coordinates and performing camera projection.
Keep the current full-road VDP section rendering method: pavement, kerbs,
shoulders, centreline, traffic, player, scenery and HUD.

Investigate lateral-position-dependent vehicle appearance as a separate,
measured option. Do not couple a visual sprite-angle change to new driving
physics. Aim toward 60 FPS / 16.67 ms; success is a correct, reviewable candidate
with measured costs, not an unsupported promise of 60 displayed FPS.

## Isolation and inputs

All experiment implementation, table generators, generated data, tests,
profiling scripts and retained results belong in `docs/tasks/RALLY-18/`.
Generated source copies and binaries go in its ignored `.work/`; isolated
emulator profiles go in its ignored `.emulator/`. Reuse existing tools through
checked copies or imports, with input identities recorded. Do not change
`rally/`, earlier task experiments, upstream emulator/VDP sources, or the
migration handoff. Keep the Linux game worktree clean; cross-compile in fresh
scratch directories using the established fallback and repository
`.venv/bin/python`.

After contract approval, record the approved contract hash, Git HEAD/status,
input source/binary/runtime hashes and source provenance before implementation.
Preserve the current dirty work. The user authorized the initial checkpoint commit; later commits still require
explicit approval. No reset, redundant backup of a clean checkout, or changes
to any physical SD card are authorized.
Verify protected inputs before and after build/test actions. Freeze the approved
contract; put implementation decisions and deviations in the task bucket.

Sources: RALLY-15 resident-section renderer and protocol; RALLY-17 controlled
fixtures, debugger cycle measurement, byte-sink and computation-only paths;
`rally/include/road.hpp`, `track.hpp`, `scenery.hpp` and current game helpers.
RALLY-10's continuous lateral-camera requirement is superseded **for this
experiment only** by the user's new centreline-camera direction.

## Camera, placement and physics contract

1. Set lateral camera displacement to zero in the isolated candidate and its
   comparison reference. Road shape and scenery heading follow track progress,
   not player lateral position or steering. Preserve current camera height,
   horizon, 120 road rows y=104..223 and shared endpoint y=224.
2. Preserve track shapes, stripe pitch/phase semantics, six opponents, speed,
   grip, off-road rules, controls, demo behavior and collision policy. Any
   deliberate visual change is confined to camera/player placement and the
   separately selected sprite-orientation option.
3. Recalibrate player placement from world lateral position to screen X using
   a documented ground-contact row and actual artwork anchor. The old system
   divides movement between `carX()` and `cameraOffset()`; retaining the old
   screen coefficient would understate lateral movement. Verify that zero
   lateral position centres the tyre/contact footprint on the centreline and
   that kerb/off-road contacts agree with existing physics thresholds. Record
   intentional off-screen clipping at extreme displacement.
4. Keep traffic lane offsets projected at each car's depth. Use the road lookup
   for traffic's centreline queries as well as section endpoints; include row
   103, which traffic can request above the first rendered road row.
5. Keep physics independent of displayed frame rate. Benchmark one existing
   physics update per controlled cycle, as in RALLY-17. For interactive review,
   preserve the existing elapsed-time physics rules and document presentation
   pacing explicitly; do not advance physics once per unconstrained draw loop.

## Road lookup design

1. Build a centreline-camera **live projection reference** from a copied current
   renderer. This is the correctness oracle and isolates camera changes from
   lookup changes. Do not compare candidate pixels only against the old moving
   camera. Keep its integer rounding rules explicit.
2. Generate projected road-centre data from the existing sampled tracks. Select
   by longitudinal progress; lateral offset is no longer a table dimension.
   Store fixed-width, explicitly scaled coordinates, with signed range checks.
   Prefer direct lookup or small integer interpolation; runtime road lookup
   must not call `trackSample()` and redo map-to-camera projection.
3. Support arbitrary required rows, including moving stripe boundaries, curve
   subdivisions, traffic rows and the bottom shared endpoint. Preserve existing
   material-phase lookups initially. Stripe phase remains independent of wrapped
   track position: do not assume the same pattern phase on every lap, especially
   where track length is not an integer multiple of the pattern repeat.
4. Start the sizing study with samples every 16 world units and 122 rows
   (103..224), using signed 16-bit centres. This is only a candidate: raw sizes
   are 87,840 bytes for the oval and 499,712 bytes for Fuji, before metadata.
   Measure alternatives such as coarser/finer progress sampling, compact row
   interpolation, delta encoding and deduplication. Do not silently accept
   visible stepping or an oversized runtime allocation to meet this sketch.
5. Select a representation by measured geometry error, runtime decode cost and
   memory use. Preserve the existing one-pixel road approximation objective;
   validate the final drawn boundaries, accounting for both table interpolation
   and trapezoid approximation instead of giving each an independent full-pixel
   allowance. Include lap seams and transitions between stored track segments.
6. Prefer loading the selected track's compact data once before gameplay.
   Budget code, assets, tables, index, heap, stack and transient buffers from
   actual link maps and allocation sizes. Report binary/disk/RAM/VDP usage.
   If residency cannot meet the quality and memory limits, document the result
   before adding a cache/streaming design; no invisible per-frame SD loading or
   live-projection fallback that defeats the experiment.
7. Any external binary data needs version, track/camera identity, dimensions,
   size checks and a checksum. Prepare it in the isolated profile and fail
   clearly on a missing/mismatched file. Keep startup loading outside timing,
   but report its size and duration separately.

## Vehicles: heading and line of sight

A car's visible yaw depends on its body heading **relative to the line of sight
from the camera to the car**, not just its heading relative to the track.
Moving sideways can therefore change which side is visible even with unchanged
heading; distance affects the magnitude. This is a perspective design basis,
not a newly verified claim about original Pole Position behavior.

Current traffic selection uses the difference between camera and car track
headings and ignores lane/viewing bearing. The player currently uses steering
as a visual pose proxy; it does not simulate a separate body-yaw state.

1. **Control option:** retain existing player/traffic pose selection while
   qualifying camera placement and the road lookup. This keeps the first
   performance comparison attributable to road changes.
2. **Perspective option:** combine the existing heading/steering pose proxy
   with a small lookup for camera-to-car bearing, derived from its projected
   centre X (or equivalent lateral/depth ratio). Conceptually, visible yaw is
   relative heading minus viewing bearing. At focal length 160, the bearing
   corresponds to `atan((screenCentreX - 160) / 160)`; precompute the mapping,
   rather than adding live eZ80 trigonometry.
3. Quantize and clamp to the existing five source views plus mirrors. Verify
   artwork sign conventions, continuity and behavior beyond the available view
   range. Avoid floating point, per-road-section orientation work and new art
   in this first task. Evaluate at most the player and visible opponents.
4. Test straight-road left/centre/right placement, increasing distance, curved
   track heading, both steering directions and mirror transitions. Check that
   the centred straight-ahead case retains the rear view. If view switching
   flickers near a boundary, qualify a small hysteresis separately.
5. Keep both orientation options available in review and report their CPU and
   UART differences. The expectation that this costs less than road work is a
   hypothesis to measure, not an accepted performance finding.

## VDP and command traffic

Retain the qualified resident two-pattern section programs and initially their
25-byte section update/call. Precomputed road geometry reduces computation;
it does **not** inherently reduce that byte count. Count total and road-only
bytes per frame, bytes per second at measured FPS and at 60 FPS, and section
counts. Keep section count within the measured command-buffer capacity.

Keep work already delegated to VDP there. Do not introduce a bespoke rendering
firmware, remove kerbs/lines, reduce traffic, or change the UART throttle to make
this comparison look faster. Further resident-data/protocol compression is a
separate measured follow-up, not a hidden change in the geometry experiment.

## Execution after approval

1. Record input identities and create isolated source/profile copies. Implement
   the centreline-camera live reference, correct player anchoring, and capture
   the expected appearance headlessly.
2. Generate and size candidate road tables; select sampling/encoding with
   measured final geometry error and a complete memory budget. Implement the
   lookup and qualify its row queries against the live reference.
3. Integrate the lookup with the existing complete scene and resident VDP road
   sections. Qualify both tracks, stripe/lap seams, controls and off-road
   placement using host tests and native headless captures.
4. Measure the live centreline reference and lookup candidate with matching
   fixed poses and unchanged orientation. Add the perspective-orientation
   option only after that comparison is sound, then measure it separately.
5. Prepare the interactive candidate with both tracks and documented orientation
   options in task-local profiles. Autoexec must load and run the game. Launch
   a graphical emulator only when ready for the user's review; performance
   testing is always headless. Leave the candidate window available.

## Measurement and acceptance evidence

Use normal 18.432 MHz eZ80 timing throughout. Preserve UART baud/FIFO timing in
transmission measurements. Use the RALLY-17 debugger cycle-counter method with
batch-boundary observations and no logging inside the measured loop. Repeat
both tracks in alternating comparison order; keep pose/physics inputs matched,
including explicit nonzero lateral/steering cases that exercise the new method.

Report these separately:

1. Computation and typed RAM-state updates only: no command building/buffering
   or VDP sends. Ensure calculations remain observable; verify zero UART bytes.
2. Computation plus command construction and transmission to the post-UART
   sink: VDP congestion excluded, CPU and serial costs retained.
3. Full rendering with stock VDP completion: actual completed throughput,
   including backpressure and known native swap waits. Do not call a cycle
   throughput equivalent displayed FPS.

Every report must include **FPS or explicitly labelled FPS equivalent**, ms per
frame/cycle, percentage change, 16.67 ms budget multiple and excess/remaining
milliseconds. Show vehicle-orientation cost separately and avoid subtracting
incompatible workloads as though they were an exact CPU profile.

Historical RALLY-17 section results for context (not a substitute for the
matching centreline reference):

| Workload | Oval | Fuji |
| --- | --- | --- |
| Computation/state only | 19.73 ms; 50.68 FPS equivalent | 17.51 ms; 57.11 FPS equivalent |
| Including commands/UART, no VDP congestion | 32.10 ms; 31.16 FPS equivalent | 27.94 ms; 35.80 FPS equivalent |

Acceptance requires correct camera invariance under steering, consistent player
contact placement, preserved stripes and seamless road/traffic projection,
bounded table error with stated coverage, safe measured memory use, reproducible
headless results, and a launched visual candidate. Record whether the 60 FPS
budget is met; do not call it achieved merely because a CPU-only path fits.
Human visual acceptance, physical-hardware qualification and commit approval
remain distinct from automated evidence.

References: [RALLY-10](RALLY-10.md), [RALLY-15](RALLY-15.md),
[RALLY-17 results](RALLY-17/compute-results/README.md),
[original research](../research/pole-position/README.md). For focused arithmetic
alternatives, retain the project references to `mystuff/agon-fsim`,
`mystuff/Wolf3dOrig` (original live renderer) and `mystuff/AgonWolf3D` (prebaked
Agon approach). Do not replace the lookup experiment with an unmeasured math
rewrite merely because those libraries are available.
