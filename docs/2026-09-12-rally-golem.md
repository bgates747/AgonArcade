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
