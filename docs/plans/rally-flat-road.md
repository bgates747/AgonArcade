# Flat pseudo-3D road prototype

**Historical proposal; flat curves authorized September 11, 2026.** Project: Agon Rally. Working title: **Pole Position**.
The implementation proposal belongs to RALLY-01 in the root [TODO](../../TODO.md).
This document defines its scope and acceptance evidence, rather than maintaining
a separate task list. The implementation is now in `rally/`. The user accepted
the lowered viewpoint and then authorized curves from a supplied track map.
Current behavior is defined in `rally/README.md`: automatic track following and
acceleration/braking, with steering and other broader stages still deferred.

The proposed outcome is a small native Agon program that makes a level road feel
solid while it moves toward the viewer. It should let us freeze the view, inspect
perspective, change speed, steer, and then travel through gentle flat bends.
The result is a foundation to evaluate, not a finished racing game.

## Recommended approach

Use native C++17, the stock VDP, and mode 136 at 320×240. Retain the successful
Defender arrangement of double buffering and ordinary bitmap plotting. Draw the
road with opaque filled primitives; do not activate software sprites or depend
on custom firmware. Store camera projection values in small precomputed tables.

Keep a scanline geometry reference, then combine compatible rows into a smaller
number of trapezoidal bands for the VDP. That preserves a precise reference for
perspective while reducing command traffic. On a straight flat road, linear
edges are exact; on bends, the row reference provides a measurable error bound.

This is informed by the original arcade's compact road description, but the
implementation is original. The [research report](../research/pole-position/README.md)
explains the distinction, the historical evidence and the equations. Its
[source register](../research/pole-position/sources.md) pins the supporting material.

## Scope boundaries

| Included in this prototype | Deferred until the foundation is accepted |
| --- | --- |
| Fixed-height camera and level ground | Hills, crests, banking and tunnels |
| Straight road, shoulders and distance-based markings | Full tracks, lap timing and checkpoints |
| Acceleration/braking and lateral steering | Gearbox simulation and elaborate tire physics |
| Gentle left/right/S bends after straight-road acceptance | Traffic AI, collisions and damage |
| Simple car marker and optional roadside posts | Finished cars, branding, music and scenery |
| Freeze, single-step and performance diagnostics | Title-screen polish and score persistence |

“Flat” excludes vertical changes, not horizontal turns. The first implementation
stage is straight; flat curves are a subsequent demonstration using the same
coordinate system. The temporary title does not imply use of original game art,
ROMs or the original circuit's exact lookup data.

## Geometry contract

Use screen coordinates with positive `y` downward, world distance along the
road, and a separate lateral car offset. An initial calibration is horizon 96,
focal length 160 pixels, camera height 100 units and road half-width 90 units.
These are tuning inputs, not historical measurements. Keep road detail within
rows 97–223 and reserve a small bottom strip for diagnostics.

For `q = screen_y - horizon`, precompute `z = fH/q` and `scale = q/H`.
Never divide at `q=0`; use a finite far cutoff and a plain horizon band. All
stripes and posts derive from `traveled_distance + z`, not independent animation
counters. Positive lateral car movement shifts the projected road left, with a
larger displacement near the viewer.

Represent the visible road as cross-sections with depth, center, width, material
phase and clipping bounds. Initially all centerline displacements are zero.
For gentle bends, integrate a bounded local curvature model using world-distance
steps and the camera's local track tangent. Preserve fractional position within
the current interval to avoid jumps at boundaries. The research report gives
the proposed integration and its small-angle limitation.

The code should keep three concerns separate: world/driver state, projected
cross-sections, and encoded VDU bytes. Changing the number of drawing bands must
not change traveled distance, curvature, lane positions or handling.

## Reviewable stages

### Static reference road

The first native view is stationary. Show a horizon, road, shoulders, center
marks, distance samples and a car marker. Include freeze/single-step controls
from the outset. Demonstrate symmetrical straight edges, continuous fills, correct
clipping and clean alternating buffers. The purpose is to prove the coordinate
and rendering contract before motion disguises mistakes.

### Forward travel on a straight road

Add speed and elapsed-time-based distance. Road marks remain attached to world
positions and accelerate visibly toward the viewer. Low speed should expose
fractional motion rather than reveal segment-sized jumps. High speed should not
produce unstable horizon patterns. Lateral steering changes perspective according
to camera offset, while a centered, hands-off car stays stable on a straight.

### Level curves and continuity

Add one gentle left bend, one right bend and an S transition. The foreground,
visible bend and distant continuation should remain connected as the current
track interval changes. Test both directions and the track wrap boundary.
Do not introduce outward drift until the road geometry works with handling
forces disabled; that isolates rendering faults from driving behavior.

### Attached objects and performance decision

Add a few original rectangular posts with bottom-center anchors and a small
precomputed range of bitmap sizes, if needed to demonstrate distance attachment.
Compare image quality, emitted bytes and frame cadence with the plain-road view.
This is the point to accept the foundation or change the drawing strategy,
rather than automatically proceeding to a complete game.

## Performance contract and alternatives

Aim initially for **25 displayed frames per second**, with ordinary frames near
or below **3,000 emitted VDU bytes**. Those are provisional targets. The inspected
serial configuration's ceiling is 115,200 payload bytes/second; the real program
must leave room for CPU work, VDP drawing, flow control and presentation.

A representative 24-band road with four packed quadrilateral fills per band and
300 bytes of other commands totals 2,892 bytes, or 25.10 ms of nominal wire time.
This is an estimate, not a measured frame rate. A naïve four-span-per-scanline
version costs 7,980 bytes with the same allowance, already taking 69.27 ms on the
wire. Full-frame pixel uploads are excluded from the baseline for that reason.

| Candidate | Role in the decision |
| --- | --- |
| Per-row spans | Correctness/debug reference; not the assumed real-time renderer |
| Coarser rectangular bands | Simple benchmark and fallback; visible edge stair steps are a risk |
| Adaptive trapezoidal bands | Recommended baseline for smooth edges at a bounded command count |
| Stored/patchable VDP command sequences | Conditional optimization only if measured traffic justifies it |
| Custom VDP or hardware sprites | Outside this prototype |

A packed quadrilateral uses a color command and four PLOT positions. Verify that
its two triangles cover the intended shape without holes at shared edges. Compare
against the normal triangle helper before relying on the proposed 27-byte count.
Count actual generated command bytes rather than estimating from function calls.

Band boundaries must preserve visible stripe/color boundaries. If the required
band count grows beyond budget, first simplify subpixel distant markings, then
reassess cadence. Keep a one-pixel initial road-edge error target relative to the
row reference. Do not sacrifice continuity or silently change vehicle speed to
meet a performance number. See the [budget data](../research/pole-position/wire-budget.csv).

## Acceptance evidence

| Area | Evidence required before calling the foundation successful |
| --- | --- |
| Perspective | Monotonic depth/width; forward/inverse projection agrees; no horizon division |
| Motion | The same world marker stays attached to its road location at low, medium and high speeds |
| Steering | Correct sign and near/far parallax; no spontaneous drift on a straight |
| Curves | No visible snap entering/leaving bends, crossing intervals or wrapping the track |
| Rasterization | No holes, stale frames, buffer alternation artifacts or software-sprite trails |
| Stability | Controlled horizon detail; clean left/right/offscreen clipping |
| Timing | Actual bytes/frame and displayed cadence recorded separately from simulation updates |
| Input | Native MOS key path verified; controls remain responsive under drawing load |
| Target behavior | Emulator review followed by hardware review before claiming hardware performance |

Host-side checks should compare generated cross-sections and VDU streams against
known cases, including signed coordinates and fixed-width arithmetic. Use explicit
32-bit intermediates where required; the target's ordinary `int` is 24 bits.
Serialization must explicitly emit little-endian 16-bit VDU coordinates.

The native benchmark should run fixed scenes and log command sizes and elapsed
work. A headless emulator capture can verify visual transitions. The graphical
review should make stationary inspection, one-step movement and free driving
easy. A real Agon run is necessary to validate ESP32 throughput; host rendering
speed alone is not that evidence.

## Proposed subproject and controls

If this plan is accepted, place the implementation in `rally/` beside `defender/`.
The working title is display text, not a reason to bake a borrowed product name
into every path. Reuse the repository-root venv and installed agondev toolchain.
Give Rally its own `.emulator/` generated through the canonical setup tool;
map only the application binary and required assets into its SD tree.

Proposed controls are Left/Right to steer, Up to accelerate, Down to brake,
Space to freeze/unfreeze, N to advance one simulation step while frozen,
R to reset, and Escape to return to MOS. A diagnostic toggle can show depth,
phase, band count and bytes/frame. These controls favor evaluating the effect;
a later game can choose a different driving layout.

## Decision for review

The recommendation is to proceed with the static and straight-moving flat-road
stages using table-driven geometry and adaptive trapezoidal drawing. Curves and
posts then demonstrate that the coordinate model generalizes without introducing
hills or game systems. The main issue to validate experimentally is the visual
quality achievable within the command budget.

The research review is complete. The authorized straight-road subset is now
implemented under `rally/`; RALLY-01 in the root TODO tracks human validation.
