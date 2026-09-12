# RALLY-19: Golem stock-VDP scene computation — execution contract v1

Frozen before implementation on 2026-09-12. The Author explicitly authorized a
Golem/Rally goal, High thinking, unattended execution, a detailed checkbox plan,
and a commit every time a checkbox is completed. All emulator work is headless;
no graphical emulator or attention beep is permitted. This newer authorization
supersedes the delivered handoff's discussion-only status and earlier workflow
requiring a GUI review before committing emulator-related work. It authorizes
local staged commits, not GitHub pushes, SD deployment or firmware modifications.

## Objective and boundaries

Continue the existing C++ Golem compiler so programs/data resident in the stock
VDP compute Rally scene geometry from compact game state, reducing per-frame
eZ80 geometry and UART work. Deliver a runnable full-scene candidate, compiler
source/examples, reproducible headless evidence and an honest measured comparison.
The eZ80 retains input, physics and game rules. No competing Python compiler,
custom VDP commands/firmware, unrelated language features, new game content,
or hardware-performance claims. Auxiliary Python is allowed using project venvs.

The accepted Rally oracle is commit 949f6186853ab99f257906e95786593a7a2e098f,
RALLY-13 review generated from RALLY-18; root rally/ is not that candidate.
Reviewed binary SHA256: 03322954c8c4fe29d90eaa0706c9169b242cdd264ea3b7b287cece58a6469d79.
Preserve 120 road rows, full markings/scenery/six competitors, fixed-centreline
camera, optional perspective OFF, manual cornering with optional autosteer,
demo assistance, incremental steering, existing grip/surface mechanics,
maximum speed 300 and WorldSpeedMultiplier=2. Preserve independent stripe phase
across lap wrap. Do not quietly change projection to a new general 3D camera.
Compact lookup coefficients may remain resident: moving their evaluation/indexing
to VDP is useful offload; recomputing known geometry with expensive trig is not
required. General arithmetic probes establish reusable Golem capability separately.

## Workspaces and authoritative state

AgonArcade execution worktree: /home/smith/Agon/mystuff/AgonArcade-rally19,
branch rally19-golem, based on the delivered checkpoint. Original AgonDefender
checkout and handoff.md remain untouched. Golem work uses an isolated branch/
worktree based on a083173, preserving original untracked deploy.py/deploy.toml.
Keep original oracle binary/data and baseline captures hash-identified and read-only.
Use stock official Fab 1.2.4 / MOS 3.0.2 via canonical generated wrappers.
Never edit upstream reference repositories or reuse another application's profile.

Root AgonArcade TODO.md contains the single ordered execution checklist, IDs
R19-00 through R19-12. This contract defines criteria; it is not a second checklist.
The Author explicitly requests retaining [x] completion marks, overriding the
usual removal of completed TODOs for these goal milestones only. Other task IDs
and historical notes remain intact. Golem TODO should reference this shared
execution register rather than duplicate it. Detailed evidence belongs under
RALLY-19/ and Golem's tests/examples/devlogs, not the cross-agent mailbox.

## Compiler and protocol requirements

Extend golemc.cpp and its existing semantics, not a replacement emitter hidden
in a Rally Python script. Add typed, inspectable stock-command intrinsics and
symbolic buffer/field relocations where needed. Preserve existing print, uint16,
addition and For/Next behavior with regression tests. Arithmetic values live in
float/matrix buffers; VDP variables are 16-bit state, not a float register file.
Qualify signed conversion, overflow bounds, singular depth rejection, conditional
operands, loops, aliasing and buffer lifetimes. Every hosted render call returns;
no endless buffered loop starving the outer VDP event/keyboard/UART machinery.

Recurring protocol supplies player progress/lateral/steering, six competitor
states, independent stripe phase, necessary HUD state and a sequence/version.
Static artwork, track data, pitch, programs and constants upload once. Define
exact widths, ranges, buffer IDs and update/trigger ordering before integration.
A finite call after a complete ordered state update is preferred to speculative
asynchronous protocols. Malformed/incomplete inputs must not launch a partial
frame. Do not send precomputed projected coordinates and call that VDP computation.
No recurrent allocation growth or cached-matrix alias collisions.

## Frozen acceptance criteria

The following numeric targets are execution choices adopted for this autonomous
goal, not claims the Author previously agreed to specific timing thresholds.
They must not be relaxed silently to obtain a pass.

Correctness: freeze at least 48 deterministic poses before candidate rendering,
covering both tracks, each tight turn, straights, lap and stripe seams, signed
lateral extremes, steering signs, all liveries and depth overlap. Compare against
the accepted oracle, not the older root game. Freeze expected object visibility
and material classes. Require <=1 pixel road-boundary error on the qualified
pose set and >=95% regional pixel agreement separately for road and each visible
vehicle (union of expected/actual support, no padding by empty sky). Background
is evaluated separately. Every expected car/material must appear, with correct
occlusion order; none may be hidden by an aggregate score. Calibrate tolerances
against edge-only perturbations and deliberately missing cars/markings. If the
metric is inadequate, amend and commit it before evaluating a candidate, with
an explanation; never retrofit it after a failing comparison to declare success.

Numerics: prove product (7*9), reciprocal/division (84/7), rotation, multiply-add,
negative coordinate conversion and arithmetic-to-PLOT output on stock native VDP.
Vary input values so baked answers cannot pass. Cover bounded loops and indexing.
Use finite known depth ranges and clipping before reciprocal. Record numerical
error and command/memory cost, not merely a screenshot or source plausibility.

Performance: normal 18.432 MHz guest clock/UART, no unlimited CPU. Headless
serial ABBA comparison on identical >=64-pose workloads, both tracks, warmed
resident data, >=2 repeats/variant. Measure unpaced computation/submission work
separately from the unchanged 30 Hz interactive deadline. Record at least raw
intervals, distributions, startup time, recurring UART bytes, memory, eZ80 work,
and end-to-end externally observed frame sequence where available. A general
poll proves a parser milestone, not a documented rendering-completion event.
SDL presentations are not automatically distinct game frames.

Target recurring scene state + trigger <=128 UART bytes/frame and at least 75%
less recurring scene traffic than the matched oracle; account HUD separately
and report total bytes too. Target >=50% less eZ80 scene computation/submission
CPU work, without moving physics or falsifying waits. Target full-scene unpaced
median <=33.33 ms and p95 <=50 ms, and no >5% median regression versus the matched
oracle. If reliable timing cannot separate stages, report the limitation and
qualify another measurement; do not fabricate CPU savings from wire-byte counts.

Stability: both-track deterministic replay for >=10 minutes each, including
manual-input sequences and seam/overlap cases; zero missing/duplicate accepted
state sequences, protocol errors, nonfinite coordinates or memory growth.
Host/compiler/loader sanitizers and malformed-input tests pass. Prompt return
from resident jobs, mode reset/reload and MOS exit are tested headlessly.

## Execution, commits and failure handling

Each checkbox is completed only with its stated evidence. Commit immediately
when marking it [x]. For a cross-repository step, commit Golem artifacts first,
then record that commit and checkbox in the AgonArcade commit. Do not batch
multiple completed boxes into one commit. In-progress fixes can be checkpointed
without falsely checking a box. Do not amend earlier evidence or rewrite history.
No pushes, graphical alerts or SD-card changes. Preserve all unrelated dirty files.

Read-only reconnaissance and isolated checkpoint import were necessary to write
this contract; no compiler/game implementation or new experiments preceded it.
After the freeze, proceed autonomously through the register. Prefer small kernels
and short tests before full scenes. Adapt implementation within this contract;
record substantive architecture decisions and source/runtime identities durably.

If a stock limitation defeats a construction, try bounded alternatives (batched
matrix evaluation, resident reciprocal/section tables, split jobs) and retain
failed evidence. Do not substitute custom firmware or silently weaken visual/
performance targets. Keep unresolved boxes unchecked; report a concrete blocker
with the smallest necessary contract amendment rather than claiming completion.
Stop expanding features once all criteria pass. Final delivery is a written
report and reproducible headless commands; user visual/hardware acceptance remains
separate. No review emulator is launched.
