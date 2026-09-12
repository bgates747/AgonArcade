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
