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
