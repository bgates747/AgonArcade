# RALLY-28 — Offline rendering phase and assembly audit

Establish where to measure the current race workload and identify expensive
recurring work before another optimization. The prepared-image experiment fits
and works, but its one completed comparison is essentially tied with compact
control. Source inspection and existing artifacts can clarify the next useful
measurement while Golem investigates transport. This tranche runs no emulator
and changes no game, firmware, qualified fixture or runtime.

The Author's2026-10-31 instruction releases this plan, a commit/push checkpoint
of all current dirt, then the offline work below. Root `TODO.md` is the sole
actionable register; COST-001 identifiers here describe those promoted items.
New audit findings remain uncommitted for review after the requested checkpoint.

## Scope and preserved baseline

Use the actual accepted compact native renderer and its full-race eZ80 driver
under `custom-vdp/incremental/round-trips/`, not the approximate prepared-image
candidate. The latest independently qualified first-order control rendered
900frames/3600ticks at36.1930nominal MOS FPS, with separate PRT34.9610FPS.
These are existing references, not new measurements from this audit. Preserve
the earlier qualified cohorts and clock limits; do not pool different runs.

The native source, target object/disassembly, exported SDK/firmware source and
guest build sources are read-only inputs. The direct-eZ80 game is a secondary
cross-check for shared arithmetic and duplicated positioning work. Keep processor
and implementation identities explicit. Existing flat-sky, quad and old affine
phase timings do not describe the current compact full-race renderer.

## COST-001-01 — Pin the paths and account for existing evidence

Pin the exact control guest/module/source, compilers, SDK, presentation, artwork
and timing inputs used by this review. Inventory existing phase fields and saved
CPU/transport/wait records, separating qualified observations from estimates and
unmeasured costs. Locate all deferred work after native command construction.
Deliver an input manifest and a source-linked phase map covering:

1. eZ80 player/rules/input and native tick submission;
2. native opponent/contact simulation, geometry and road-image preparation;
3. actor planning and traffic/sign sampling, including work deferred until
   command-output leases are released;
4. road dispatch/plot, traffic/sign plots, fixed-size player/reflection and
   finish drawing;
5. sky scroll/repaint/repair, HUD/footer and engine-command handling;
6. serial submission, callbacks/waits, queued drawing completion and swap.

The map must explain which work overlaps and which labels cannot be added as
exclusive time. The current finite fixture performs four physics steps per
render; it does not prove an autonomous120Hz physics cadence.

## COST-001-02 — Design useful timing hooks and completion fences

Specify hooks without implementing them. Distinguish geometry/command assembly,
sampling/image preparation, queued command execution and actual deferred drawing
completion. Give exact start/end locations, clock, resource owner, retained
record layout, wrap handling, out-of-window retrieval and failure cleanup.
Include road, traffic/signs, player, sky, HUD/footer and final presentation.

Audit existing stock completion facilities and the pinned native ABI before
proposing a new service. A native RUN reply or command-buffer return is not
automatically proof that queued Canvas primitives have finished. Identify the
actual drain/fence implementation and every remaining gap. Preserve the existing
checked final post-swap fence and full native error/publication validation.

Define a diagnostic mode separately from the uninstrumented FPS control. Keep
all clock domains separate: native counters, PRT, MOS ticks and host wall time.
Do not convert raw counters into physical milliseconds without qualification.
Place uploads, setup generation, counter readback and file writes outside the
steady window. Bound record storage and report overflow rather than silently
drop events. Quantify marker/fence overhead and avoid counting the same deferred
sampling twice. Additional phase fences can serialize work and distort total
throughput; retain a whole-frame control to expose that effect.

Future fixtures must keep physics independent of render completion, measure
flat-out physics capacity before selecting a pace, account for serial overhead
and skip obsolete renders rather than blocking physics or catching up drawing.
This audit implements no scheduler. Any eventual run must retain the complete
race drawing workload and report completed-frame FPS/frames/elapsed time first,
with phase information supporting it. No emulator or hardware test is released.

## COST-001-03 — Inspect the generated hot-loop machine code

Review existing target disassembly and compiler output. If needed, emit annotated
assembly for unchanged source into this research directory using the same pinned
compiler/options; no rebuild or replacement of qualified binaries. Trace expensive
wide integer/floating arithmetic, division/conversion, redundant track samples,
buffer copies, per-object setup and lease/command overhead to actual call sites.

Distinguish eZ80 costs from Xtensa costs; a 32-bit operation is not equally costly
on both. Identify runtime versus setup-only work, argument ranges, repetition
counts and evidence of what the compiler already eliminated. Cross-check shared
positioning calculations so an optimization is considered at all useful callers.
Integer/fixed-point narrowing, lookup tables and visual approximation remain
valid proposals when ranges and later human review support them. Half precision
is a research alternative, not an assumed speedup. Do not adopt any arithmetic
or rendering change in this tranche.

## COST-001-04 — Rank bounded follow-ups and return findings

Rank a short set of next experiments by source evidence, expected whole-frame
relevance, implementation effort and the measurement required to decide. Separate
confirmed waste from hypotheses. Preserve rendering-speed/accuracy tradeoffs
explicitly; do not reject them silently or optimize away race drawing tasks.
Use the prepared-cache near-tie as evidence about that one comparison, not proof
that caching is generally useless or that a particular processor is the bottleneck.

Deliver source-linked findings, a concrete timing-hook contract, assembly notes
and proposed next tranche. Mark completed COST items in the dated log and remove
them from root TODO. Promote any accepted new work separately; proposals do not
authorize implementation or tests. Return with new audit work uncommitted.

## Boundaries

No Oryx contact, lease request, emulator/library session, review profile, hardware,
firmware/SDK service change, game/fixture edit, optimization implementation or
messages to another owner are required. Keep all AFF03 successful/failed/unrun
witnesses and freezes unchanged. The requested checkpoint publishes existing
work and this scope; it does not adopt the approximate cache or close human,
hardware or performance-validation gates.
