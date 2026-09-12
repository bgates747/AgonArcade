# R19-07 full-road integration notes

R19-06 completed at Rally005ee0f / Golem980024b (compiler f54651a). Its complete
row160 band passes74 native image comparisons. R19-07 remains open in root TODO;
these are implementation notes, not a competing checklist or changed contract.

The first integration step packs coefficient intervals into immutable banks,
using existing qualified Golem intrinsics. A record is228 bytes (19 twelve-byte
mixed coefficients), so at most287 records fit in a65535-byte stock buffer.
Oval needs one20520-byte bank. Fuji needs65436 and51300-byte banks. Source bytes
remain unchanged, with complete typed fields for compile-time layout/range checks.
The VDP calculates bankNumber=interval/287 and bankRecord=interval%287, then calls
one of two finite LoadElement programs. Each copies only the selected228-byte
record into intervalData; it never copies the entire64KiB bank per frame.

`build_packed_section.py` initially retains the qualified row160 section drawing
to isolate the layout change. `probe_section.py --packed --track fuji` adds poses
immediately before/at/after the bank seam (position1836800), across both stripe
halves. Later full-road work must use the frozen visual poses and full road masks;
passing the packed one-band probe alone must not check R19-07.

After bank qualification, replace anchor descriptors with the complete curve and
stripe boundary arrays. Share per-position/per-phase preparation, merge their
ordered endpoints with a finite bounded job, reuse the prior bottom centre as
the next top centre, preserve first-marked-row116 parity and final endpoint224.
Keep the fixed centreline camera and phase independent from lap wrap. Integrate
the qualified80-byte admission protocol and resource ownership before claiming a
production scene path. Do not raise the1024-ID ceiling to evade integration.

## Packed-bank checkpoint

Native readback passes61 oval and91 Fuji one-band queries. The12 extra Fuji
queries bracket the287-interval bank seam across four phase values. Interval,
depth, coefficient, phase and curve selection status all succeed; rows/materials
match the accepted implementation and centres remain within1px. Evidence:
`evidence/golem-section/packed-{oval,fuji}`. Compiler implementation is unchanged
from f54651a; these use the already-qualified generic Asset/LoadElement intrinsics.

| Packed one-band construction | Oval | Fuji |
| --- | ---: | ---: |
| Coefficient banks | 1 | 2 |
| Owned IDs | 366 | 389 |
| Resident payload bytes | 36954 | 140554 |
| Bootstrap bytes | 42140 | 146062 |

Fuji drops from877 to389 IDs. Arithmetic packing adds a small fixed program/
scratch cost, while freeing488 IDs. The rough389+306=695 admission-plus-road
sum leaves headroom, but is not an integrated resource ledger: private and
explicit IDs must be assigned in one compilation. Current diagnostic buffers
1000/1001/1002 and program2000 overlap the frozen staging/active/status/admission
roles. Reuse production active-state fields at their actual offsets; do not add
overlapping duplicate Field declarations, which would break complete-record
layout validation. Relocate geometry/status scratch and render entry points.
Keep the existing guarded admission program's semantics and finite call ordering.

The packed image regression is a separate one-band check using
`visual_section.py --packed`. Eleven Fuji cases pass (the final frozen-bend cases
and added seam/lateral poses), with exact centres and passing per-material pixels;
see `evidence/golem-section-visual/packed-fuji-b`. It still does not enumerate or
draw the full road, and R19-07 remains unchecked. Earlier R19-06 reports preserve
their exact inputs; current numeric query sets also include the new bank seams.

`road_bounds.py` examines every curve-bin/phase-pattern combination against the
accepted source arrays:36360 oval and206848 Fuji combinations. Maximum merged
band counts are29 and32 respectively. The other half-period only flips material
parity, so it cannot increase these counts. `evidence/golem-road-bounds.json`
records source hashes and the exact witness rows/poses (oval107200/phase80,
Fuji1566400/phase1389). A32-iteration finite merge is sufficient for the accepted
tables; include these witnesses when validating the full renderer and require its
finished flag after the loop. Do not use an endless buffered loop.

The accepted arrays contain2408 curve offsets,16803 inclusive curve ends,101
phase offsets and1060 shared phase endpoints. They fit small immutable buffers.
Offline repacking may store curve ends+1 directly as u16 to avoid a runtime
conversion and preserve the accepted endpoint convention. Keep dynamic cursors
guarded. Set material false before116; at116 select the phase-half parity; flip
once at each later stripe boundary. Advance both cursors when boundaries coincide,
and do not fetch beyond the terminal224 after marking the job finished. Reuse the
previous bottom centre for the next top. Full-road diagnostic readback must retain
the candidate's own complete endpoint list for independent pixel masks.

## Full-road construction and final qualification setup

The first full-road native probe passes63 oval and93 Fuji poses, totalling2493
bands with exact accepted rounded centres, rows and material parity. The32-call
finite job reports inactive at its terminal224. The first road-only images also
pass (30 oval and30 Fuji cases plus the four-case initial run). These are useful
pre-integration evidence, not the final milestone qualification.

`build_road_kernel.py` replaces anchor descriptors with the complete typed phase/
curve arrays and resident cursor merge. It evaluates the first top centre, then
one new bottom centre per band. Optional diagnostic tracing unrolls the32 calls
and copies each current endpoint/material into33 fixed6-byte slots in1600. Tail
slots repeat the terminal endpoint; only bandCount+1 entries are meaningful, and
the terminal material is unused. An untraced build uses bounded Repeat(32).

`build_admitted_road.py` links the original admitted-state program to the road
job in one Golem compilation. It preserves staging1000, active1001, admission
status1002 and expectedSequence1003; road output/status move to1020/1021, matrices
move+100 and program IDs+400. Road reads the existing activeposition/activephase
fields directly, with no duplicate active-record fields. On oval, staging/active
position bounds are specialized to the same lap limit already enforced by its
guard. The old position-times-two diagnostic is retained for direct comparison
with the original210-event admission suite, then dispatches the road job.

Resident clearRoad and clearFooter draw the green road region and black HUD
background. The moving road requires the frozen97-byte state/trigger packet plus
3-byte swap, without host-projected corners or host road-clear rectangles. The
visual loader uploads the constant sky region only on initial buffer preparation;
GP/readback traffic is diagnostic and separately excluded from recurring scene
traffic. Actual vehicle/scenery/HUD integration remains later milestones.

Both selected-track admitted jobs pass all210 original admission events, including
27 accepted road frames each. Every rejected/missing trigger preserves all288
bytes of road output/status/trace. Byte-cut recovery, modulo sequence wrap and
reload remain covered. Final admitted full-road images are in progress.

Before final image qualification, `road_outline_metric.py` adds a supplemental
strict native-outline check. The original frozen centreline and per-material
metrics are unchanged. Per-row minimum/maximum road-coloured x coordinates must
differ by at most1px; an appearing/disappearing row is allowed only for a single
clipped border column. Calibration accepts1px translation and rejects2px shifts,
2px width growth, an erased interior row and a two-column border appearance.
This strengthens width/outer-edge evidence; it does not relax a failing metric.

## Clear-edge failure and remediation

The admitted-oval and admitted-fuji-a images passed the older regional scores
but failed the separately frozen strict outline check. In oval frame000570,
row172 agrees through x318; only candidate x319 retains an old red pixel where
the oracle is green. This makes the apparent outer boundary17px too wide, even
though it is a single stale pixel beyond the correct edge. Fuji exhibits the
same failure. Both failed outline reports and complete captures are preserved.

The resident clear used two filled triangles with inclusive rectangle-style
coordinates0..319. Unlike the earlier host rectangle clear, this leaves the
rightmost column untouched. The fix uses right extent320, road bottom224 and
footer bottom240, letting viewport clipping cover the last physical column/row.
The shader, coefficient evaluation and frozen acceptance metrics are unchanged.
Five admitted smoke poses pass the strict one-pixel outline check after the fix.
All30 clipped-clear oval poses also pass that check. However, the additional
complete-clear audit in `qualify_road.py` catches a second edge: the triangle
excludes its top row. Candidate row104 stays black and row224 retains road colour;
the oracle has green104 and black224. The diagnostic report is preserved as
clipped-clear-oval/clear-coverage-failure.json. The next correction uses clear tops
103/223, and the audit explicitly requires the complete green104 and black224..239
rows. The existing road metrics remain unchanged; these extra clear invariants
are frozen before evaluating the correction. R19-07 remains open.

From the execution repository root, the final image commands are:

```sh
.venv/bin/python docs/tasks/RALLY-19/visual_road.py covered-clear-oval --admitted --limit 30
.venv/bin/python docs/tasks/RALLY-19/check_road_outlines.py covered-clear-oval
.venv/bin/python docs/tasks/RALLY-19/visual_road.py covered-clear-fuji-a --admitted --track fuji --limit 30
.venv/bin/python docs/tasks/RALLY-19/check_road_outlines.py covered-clear-fuji-a
.venv/bin/python docs/tasks/RALLY-19/visual_road.py covered-clear-fuji-b --admitted --track fuji --offset 30 --limit 21
.venv/bin/python docs/tasks/RALLY-19/check_road_outlines.py covered-clear-fuji-b
.venv/bin/python docs/tasks/RALLY-19/probe_admitted_road.py covered-clear-oval
.venv/bin/python docs/tasks/RALLY-19/probe_admitted_road.py covered-clear-fuji --track fuji
.venv/bin/python docs/tasks/RALLY-19/qualify_road.py
```

Run names are immutable; use fresh names and update a new audit invocation when
reproducing. All visual/native runners generate isolated canonical profiles and
run headlessly. Image capture uses an external SDL observer, is not a timing
measurement, and does not establish full-scene/hardware acceptance.
