# 2026-09-12 — RALLY-19 resident road milestone

The Author's frozen unattended goal contract is in
`tasks/RALLY-19/CONTRACT.md`; root TODO.md is the sole checkbox register.
All work uses the isolated rally19-golem/golem-rally19 worktrees, stock native
VDP and headless canonical emulator wrappers. The original checkouts are preserved.

R19-07 is complete: Golem selects real coefficient records, evaluates the full
road, merges curve/stripe boundaries and plots every road material on VDP from
the80-byte raw-state ABI. The existing C++ compiler emits the resident commands;
Python repacks immutable data and orchestrates tests. No eZ80-projected corners
are sent. Packing the interval records avoids the earlier buffer-ID limit.

Final proof is81 native image pairs and420 admission/recovery events. Centres
are exact, outer edges differ by at most1px and minimum regional agreement is
97.56%. Additional edge/complete-clear checks exposed two triangle-fill coverage
faults; their failed evidence is retained and the coordinates are corrected.
Resource totals, exact source identities, reproduction and limitations are in
`tasks/RALLY-19/ROAD.md` and `evidence/golem-road/qualification.json` below it.
Golem completion documentation is commit9eb9fcc; compiler implementation is
unchanged from f54651a. R19-07 is checked and committed separately as requested.

R19-08 preparation reuses the original accepted host fixture: all66 original
vehicle scenes match their native CSVs exactly, with90 added host reference cases
for depth clipping, sort ties and every steering tick. These are reference inputs,
not a completed VDP vehicle renderer. Vehicles, scenery/frontend, full-scene
performance and ten-minute stability remain open. No hardware acceptance is
claimed and no graphical alert, SD deployment or GitHub push was performed.

R19-08 partial checkpoint: Golem1bbf6dc supplies qualified wide positive division/
conversion, scalar absolute value and full-width fixed comparisons.576 native
primitive records and all host sanitizer/negative/regression checks pass. The
R19-07 compiled roads remain byte-identical. New admitted vehicle distance/sort
code passes all156 fixtures, preserving the original15-pair ordering and IDs.
Resource use is759/783 IDs and62847/180711 resident payload bytes (oval/Fuji).
R19-08 stays unchecked pending projection, yaw/reflection, drawing and per-car
image tests. CARS.md records current storage, evidence, commands and the clipping/
compiler-bound issue to solve before reciprocal projection. This is progress
toward the existing full goal, not a reduced completion criterion.

R19-09 partial checkpoint: Golem cd0ae0c qualifies shared scalar conversion
scratch (672 native records plus host sanitizer/golden/negative suite). Complete
road/car plus fractional scenery heading fits976/995 owned IDs without raising
the1024 cap. Exhaustive host arithmetic checks cover all3,852,800 reachable
positions;773 native complete records match the accepted tangent/bearing and
all intermediate diagnostics. R19-09 remains open for scenery/history/frontend.

The next graphics investigation uncovered and natively confirmed an existing
oracle issue: its pixel-mode viewport helper calls reverse Y endpoints and are
ignored. A six-image probe verifies full-screen versus400/20-pixel clipping and
failure of the apparent full-view restoration. SCENERY.md records the proposed
explicit pixel-coordinate mapping and the requirement to preserve all original
full-scene/sequential imagery, including foreground repair. Original code and
captures remain untouched. This is a correctness discovery, not a timing result.

R19-09 next partial checkpoint: Golem392d96848c518d82ce56410b139f95e12f0f08d3
qualifies GraphicsViewport and ScrollGraphics. Thirty native image pairs match
direct commands exactly, with full outside-region preservation, actual in-region
drawing, one-pixel extents and viewport restoration. Host sanitizer/golden/
negative tests pass. Raw bitmap draws additionally require a non-drawing PLOT4
after VDU24 to synchronize Canvas clipping; this is now explicit in the intrinsic.

Retained evidence includes a direct-reference affine-feature omission, equal but
unclipped intermediate smoke images, and a stock native crash for an unsupported
255-row scroll inside a60-row region. Scroll amount must fit its viewport axis;
the valid255-horizontal/320-wide Rally case passes. No firmware changes or timing
claims. R19-09 remains unchecked pending retained history/scenery/frontend work.

R19-09 numeric retained-page checkpoint: all444 complete native records pass
(213 oval/231 Fuji), matching the accepted two-page offsets/validity, alternating
logical slot, wrapped delta, repaint strip and scroll amount. Exhaustive host
proof covers4,194,304 combinations of old/new bearing, validity and page. This
does not qualify actual buffer swaps or scenery images yet.

The initial history source omitted explicit widening, then the corrected source
exceeded the1024 ID cap. Both failures are retained. Golem a997437 qualifies
immutable binary32 operand pooling inside opt-in SharedScalarScratch:672 native
literal records,672 existing conversion regressions and the full host suite pass;
default/word-only bootstrap bytes remain unchanged. Combined numeric history now
fits821/838 IDs. R19-09 remains open for drawing, real page association and the
accepted interactive frontend, followed by frozen timing and stability criteria.

R19-09 completed:186 full-scene native image pairs pass, including all66 frozen
poses and120 sequential actual-page tests. Vehicle pixels are exact, background
radius-one agreement100%, road-region minimum98.095%, and all centreline geometry
matches. The unchanged compiler's byte-identical bootstraps drive the integrated
frontend. All12 both-track control/exit runs and638 sanitized raw-state records
pass; accepted input/physics/HUD blocks remain unchanged. The initial fixed-bands
option-guard failure is retained with its source and headless error capture.

SCENERY.md, FRONTEND.md and their separate qualification reports hold the evidence.
Golem completion record cd6d1eda81b077bf358d834e8f5a16fb83413d27 precedes checking
R19-09. Recurring scene/update/call/swap is100 bytes, with HUD separate.836/853
IDs fit the unchanged cap. No performance or live-memory claim follows from
these correctness results; R19-10 through R19-12 remain open. All emulator work
was headless, with no alerts, pushes, SD deployment or original/upstream edits.

R19-10 partial measurement checkpoint: an external Linux observer reaches the
unchanged native Canvas/paletted-controller swap functions. Both exact-oracle
64-pose tracks pass136 nested entry/return records, accounting for the mode's
internal page-clear swap, one explicit startup swap and two warmup swaps. The
first expected-count failure (67 versus68) and its sources are retained; stock
vdu_mode explains the additional initialization swap. PERFORMANCE.md records
the synchronous userspace primitive path and distinguishes pointer-swap return,
Canvas's further vblank wait and SDL presentations. Observer overhead, candidate
ABBA and isolated guest CPU work remain open; no R19-10 box is checked.

The native observer overhead check passes eight serial exact-oracle batches,
ABBA per track with two plain/two observed runs. Batch-clock differences are
-0.7874% oval and+0.3953% Fuji, inside the5% diagnostic guard; guest clock
quantization is8.333ms. All inputs/state hashes/road totals match, and observed
events preserve the qualified68-swap sequence. Raw steady-frame intervals are
retained with the initial host-handshake transition explicitly excluded. This
qualifies the finite Linux observation method, not Golem performance. The next
benchmark construction and CPU-scope pitfalls are documented in PERFORMANCE.md.

R19-10 next partial checkpoint: a separate CPU-only frontend diagnostic now
matches all64 independent per-pose command counts and original state hashes on
both tracks, both normally and under debugger cycle sampling. The first sink
missed60 bytes/pose because the SDK affine helper uses putch; the corrected build
wraps both putch and mos_puts, and retains the failed sources/count report.

Raw construction means (sink/marker overhead included) are322475.9375/23517.484375
cycles for oval oracle/Golem and291303.4375/23537.484375 for Fuji. These are not
yet accepted CPU savings: overhead must be bounded, and real UART/VDP timing
must remain separate. The CPU-only64 spans do not render; only two warmups do.
PERFORMANCE.md records exact scope and next calibration. No box is completed.

R19-10 completed after calibrated CPU and real-rendering ABBA audits. Conservative
construction-work reductions are91.9657% oval/91.0111% Fuji;100-byte scene traffic
reduces UART load88.5305%/86.6944%. Normal-clock native medians31.6682/31.6487 ms
and p9536.7422/36.7128 ms pass, with negligible change versus the exact oracle.
Every Golem batch accepts all66 warmup/workload states without errors and has
all68 native swaps accounted for, including the two non-workload startup swaps.

Calibration bounds unchanged sink/marker object instructions at184 cycles/span
plus323/call, conservatively removed from oracle work while retaining candidate
overhead. Real rendering is unwrapped with normal UART waits and no per-frame
poll. The oracle bridge, raw intervals/cycles, copied-header/bootstrap identities,
startup scopes, process RSS and static ledgers are audited in PERFORMANCE.md and
evidence/golem-performance/qualification.json. Golem completion4efba69 precedes
checking R19-10. R19-11 stability/review and R19-12 delivery remain open.


## R19-11 completed after physical stack correction

The Author authorized deployment, official firmware restoration and ESP32 serial
diagnosis after production reset on hardware. Official VDP2.16.0 reported a4096-
byte processLoop stack-canary failure. Golem f9e7d8d adds compiler-recorded selective
InlineCalls expansion; all14 host sanitizer suites pass. Observed nesting falls
from eight to six;120 returns complete on a4096-byte diagnostic stack, minimum
164-byte headroom including instrumentation. The temporary larger-stack firmware
was diagnostic only. Official release segments were restored and independently
verified before the Author confirmed continued slow operation using the reset
button, without full power-off. H2 checkpoint10b7ecb records that limited success;
H3 checkpointeb24628 records prepared human review and full headless regression.

The corrected assets pass all66 frozen poses, both602-second independently audited
replays, both210-event lifecycle suites,834 loader fault cases, eight native
file-failure cases and12 frontend controls/638 independent host records.
Final native ABBA passes: medians31.7115/31.3037ms, p9536.7886/36.0928ms,
conservative CPU construction reductions91.9637%/91.0078% and UART reductions
88.5305%/86.6944%. `audit_final_candidate.py` binds644 checked source/evidence
identities and the production/card byte equivalence; REVIEW.md indexes the work.

Hardware performance is explicitly not accepted. Sparse diagnostic timing gives
about1.186 root-call returns/sec, and the Author sees slow rendering on restored
official firmware too. The same stock drawing primitive gains no faster rasterizer
merely by residing in a buffer; this scalar arithmetic lowering adds too much
interpreter work on ESP32. Native host timing did not predict that cost or its
stack constraint. No claim of practical hardware acceleration follows from the
native frozen-criteria pass. Final delivery remains R19-12; no source expansion,
remote push or additional physical/GUI action is part of this checkpoint.


## R19-12 delivery

Golem delivery checkpoint3ac500cfb1733e53d475443bfcb8217817b03603 precedes this
Rally delivery. DELIVERY.md supplies actual source/generated-kernel locations,
compiler/language and protocol ownership, reproducible build/run/benchmark
commands, resource totals, production/compiler/data hashes, environment limits
and the physical result. `evidence/final/delivery.json` binds artifact identities
to both repositories' completed validation checkpoints. AGENTS.md, BUILDING.md
and the task entry point now lead to the final candidate rather than old code.

All frozen native criteria and the authorized observed hardware startup fix are
complete. The research experiment did not deliver useful physical acceleration:
the current arithmetic lowering remains visibly slow on official firmware.
That result is explicit and is not converted into hardware performance acceptance.
No additional optimization, source scope, remote publication or hardware action
is undertaken. Original worktrees, local flash/SD backups and the accepted oracle
are retained. The final experiment closes under the frozen scope; further work
requires a new task decision.


The parent RALLY-19 task is closed after its separately committed R19-12 delivery
(e91eb4c). All requested execution checkboxes are retained as completed under the
Author's explicit goal instruction. This closes the measured research scope;
physical acceleration remains unsuccessful, and unrelated task IDs remain open.
