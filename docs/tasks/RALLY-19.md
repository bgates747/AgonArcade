# RALLY-19

## Final bounded experiment

The final corrected candidate and compiler pass the frozen native-emulator
criteria. The physical startup stack failure is corrected and the Author
confirmed slow continued operation after the board reset button on restored
official VDP2.16.0. Hardware rendering remains too slow; no practical acceleration
or cold power-cycle equivalence is claimed. See [DELIVERY.md](RALLY-19/DELIVERY.md)
for actual source locations, artifacts, linked checkpoints, commands and limits;
[REVIEW.md](RALLY-19/REVIEW.md) and [HARDWARE-DEBUG.md](RALLY-19/HARDWARE-DEBUG.md)
hold final evidence. Root TODO remains the execution register. Earlier design
and authorization statements below are chronological history.

The Author later explicitly authorized physical deployment, official firmware
restoration, temporary serial diagnosis and one dedicated graphical bug-review
emulator. Those amendments are recorded in HARDWARE-DEBUG.md. The current device
uses official firmware and production oval/demo without game measurement or logs.
No further optimization, publication or deployment is implied by this delivery.

## Current authorization

On 2026-09-12 the Author authorized the unattended Golem/Rally goal, detailed
checkbox planning, a frozen contract and a commit per completed checkbox.
All emulator work must be headless; no GUI alerts. The execution authority is
[CONTRACT.md](RALLY-19/CONTRACT.md) and root TODO.md. Earlier discussion-only
wording below is historical and superseded.

## Status and purpose

Design notes opened at the user's request. Explore a VDP-resident scene renderer
fed by compact game state instead of per-section geometry and per-car drawing
commands. This is discussion, not authorization to implement or modify firmware.
Root TODO.md is the authoritative checklist. Any later scripts, prototypes and
results belong in docs/tasks/RALLY-19/.

Current reviewed baseline: 949f618, incorporating RALLY-18 road lookup and
RALLY-13 handling/speed tuning. Keep it available for comparison.

## Proposed division of work

The eZ80 handles input, physics and game rules. A car's position is represented
by distance along the track and signed lateral offset from its centreline.
Longitudinal position wraps at the lap boundary. The player also supplies its
steering setting for sprite selection; it is currently a visual pose proxy,
not a separately integrated physical heading. Competitor track-relative heading
can be derived from the track at each competitor's longitudinal position.

The proposed recurring state packet contains player longitudinal/lateral
position and steering, and competitor longitudinal/lateral positions. Opponent
identities/artwork and other static configuration can be resident. Exact field
widths, packet framing, update atomicity and cadence remain undecided. HUD state
such as displayed speed may require additional fields; the few position fields
are an aspiration for scene input, not a proven complete application protocol.

The VDP retains track/projection data, artwork and drawing programs and derives
the complete road, vehicle placement, scenery and presentation from that state.
Preserve the fixed-centreline camera, full road markings, six competitors and
current optional vehicle-view correction. Use centreline curvature across the
road width; no lane-dependent turn-radius calculations.

## Stripe pitch instead of individual stripe state

The user proposes storing the track's stripe pitch on the VDP. Stripe locations
then follow from distance and pitch: no separately maintained or transmitted
position for every stripe.

For two alternating equal-pitch patterns, the conceptual selection is:

    pattern = floor(distance / pitch) & 1
    boundary(k) = k * pitch

The view's nearest relevant boundary comes from the distance remainder modulo
pitch; further boundaries are whole multiples of pitch. The existing kerb,
shoulder and centreline pattern relationships must be retained or explicitly
redefined together. Projection still has to map those world boundaries into
screen rows and trapezoids; multiplication alone does not perform that step.

Our current stripe phase is independent of lap wrapping. Wrapped track distance
alone cannot reconstruct it on tracks whose lengths are not multiples of the
pattern repeat. Choose explicitly among sending a compact phase, sending enough
unwrapped distance/lap information, or adopting a different seam convention.
Avoid an accidental phase reset or new per-stripe bookkeeping.

## Questions to resolve before an execution contract

1. Determine how much of this state-to-scene computation the stock buffered
   command API can express using resident tables, buffer adjustment, indexing
   and control flow. Do not assume it is a general-purpose arithmetic engine.
2. Distinguish a solution using stock VDP commands from any optional custom
   firmware implementation. No custom VDP is implied or authorized by this idea.
3. Select resident projection representation and indexing/interpolation, using
   the measured RALLY-18 geometry bound and memory costs as the reference.
4. Define a small consistent state update and render trigger, including stripe
   phase, HUD needs and handling of incomplete/new updates during a render.
5. Budget startup uploads, VDP storage, recurring UART bytes and VDP rendering
   work. Moving computation to the VDP is intentional, but benefits need measurement.
6. Preserve the accepted 30 Hz pacing/no-poll production configuration for
   comparisons. Use headless performance tests and launch GUI only for review.
   Report milliseconds, FPS or explicitly labelled throughput equivalents,
   and budget margins. Do not assume an emulator-wide 30 Hz ceiling or treat a
   general-poll echo as a documented rendering-completion API.

No performance gain, stock-API feasibility or final packet size is established
by these notes. Continue adding discussion here before agreeing execution scope.

## Stock arithmetic investigation

The user clarified: stock VDP only, including buffered control flow, matrix
operations and VDP variables; no custom firmware functions. A small offline
language/compiler emitting ordinary buffered commands is within the idea under
consideration. Read-only documentation and implementation findings, concrete
arithmetic constructions and a bounded proof proposal are recorded in
[stock-api-feasibility.md](RALLY-19/stock-api-feasibility.md).

The evidence now supports investigating resident multiplication, trigonometric
matrix construction, reciprocal via inversion, and feeding computed coordinates
back into drawing commands. These are not yet tested kernels or a throughput
claim. Source inspection alone does not qualify a full renderer.

## Existing Golem project found on Linux

`agon-linux:/home/smith/Agon/mystuff/golem` already targets precisely this idea:
a compiled language emitting stock VDP buffered commands. Read it before
proposing a separate compiler. Read-only inspection found HEAD `a083173` and
existing untracked `deploy.py`/`deploy.toml`; these were left untouched.

The C++ prototype in `src/golemc.cpp` has progressed beyond the stale README's
initial description: declarations, assignment/addition expressions, print and
For/Next counted-loop code generation are present. `examples/loop_golem/loop.golem`
contains an actual 50-iteration source program. Devlogs report emulator validation;
that evidence has not been independently rerun in this investigation.

Relevant references are its `docs/design/language-type-proposals.md` and devlogs
for execution lifecycle (2026-07-28), compiler milestone (2026-07-28), and loop
prototype (2026-07-29). Its lifecycle investigation says resident calls must
return to allow outer VDP event/input processing. Its older proposed command-34
1x1 inversion remains unverified and is not supported by the command-34 operation
list inspected here; distinguish it from the proposed command-32 affine inverse.

Golem is a potential compiler foundation, not evidence that the arithmetic
kernels or complete Rally renderer already exist. No files on Linux were changed.

## Bounded-goal discussion and Linux move

The user wants development to continue on Linux because VS Code/emulator CPU
load is exceeding the Mac's practical power/charging capacity. Stop heavy work
on the Mac. Prepare a handoff for the agent on Linux; do not start a new goal
merely from the discussion of a possible goal.

The user proposes the frozen application as a quantitative correctness oracle
and would accept 95% visual correctness rather than insisting on 99.9%. These
percentages still need an agreed metric. Proposed safeguards against drift:

1. Select and freeze comparison poses before implementation: both tracks,
   straights/bends, lap/stripe seams, lateral extremes and traffic overlap.
2. Compare road and vehicles separately from sky/background. A whole-screen
   score can conceal a broken road behind a large unchanged sky. Require all
   expected cars/materials to exist; do not let aggregate similarity hide a
   missing object or incorrect overlap order.
3. Start with the prior one-pixel road geometry objective and a provisional
   95% regional pixel-match target. Calibrate the metric on harmless edge
   differences and deliberately broken scenes. These are proposed criteria,
   not yet an agreed numeric acceptance specification.
4. Measure performance separately: recurring UART bytes, submission cost,
   full-scene throughput and frame-time variation. Correct images alone do
   not prove that the offload is useful. Freeze the speed acceptance threshold
   before launching a broad autonomous goal; none was agreed in this discussion.
5. Stage arithmetic, one section, full fixed scenes, then interactive play.
   Freeze working stages. Stop when the agreed images/performance pass and
   launch for human review; do not keep enlarging Golem.
6. Rally is the concrete application driving Golem's required features.
   Reuse/develop Golem rather than creating a competing general compiler.
   Stock buffered API only; preserve the accepted game, renderer content,
   physics and settings as the comparison target. No bespoke VDP, unrelated
   language features or extra simulated physics.

The user described this as “make tools to make tools.” The compiler and game
should advance together in small measured steps. See [Linux handoff](RALLY-19/LINUX-HANDOFF.md)
for exact checkpoints, paths, deployment caveats and corrections to past claims.
