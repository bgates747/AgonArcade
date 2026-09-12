# RALLY-15

Frozen execution contract, 2026-09-12. Implement the user's kerb-pitch road
section proposal using the stock VDP buffered command API. Root `TODO.md` is
the authoritative checklist; this document defines execution and acceptance.
Keep this contract unchanged after the pre-implementation checkpoint. Record
implementation decisions and evidence in [RALLY-15/](RALLY-15/).

## Intended result

Restore the complete road appearance—pavement, red/white kerbs, alternating
shoulder stripes and yellow centreline—while retaining vehicles, scenery and
HUD. Use one stored section template for each of the two marking patterns.
The eZ80 sends the centre X and screen Y at a section's two boundaries; resident
VDP commands derive widths, expand vertices and draw the entire section.

The natural marked section is 40 world units, half the 80-unit A/B repeat.
The viewport remains exactly 120 rows, y=104..223; shared endpoints include
y=224. Material alternation begins at y=116. Preserve existing track geometry,
camera, physics, controls, traffic, assets and timing fixture. Occasional
curve subdivisions and separate distant pieces preserve the existing
one-pixel geometric quality target; two distant trapezoids are not assumed
sufficient around all bends.

## Isolation and freeze

Before implementation, archive every changed tracked/untracked repository
file, this contract, Git HEAD/status/index/worktree diffs, and the current
mainline binary. Include useful existing experiment binary/build identities.
Record SHA-256 hashes and verify archived contents. This is a filesystem
checkpoint, not a Git commit; preserve the existing index and working tree.

All new experiment code, generators, tests, launch/build orchestration and
promoted evidence belong in `docs/tasks/RALLY-15/`. Generated source copies
and binaries belong in its ignored `.work/`; isolated emulator profiles belong
in its ignored `.emulator/`. Build from copies of `rally/`, verify mainline
source and binary fingerprints before and after each action, and reject a
stale or unexpectedly modified input. Do not edit mainline game code, the
pavement experiment, upstream VDP/emulator checkouts or the migration handoff.
Use repository `.venv/bin/python` and the existing Linux build fallback.

## Execution stages

1. **Qualify the resident program.** Start from the source-checked design in
   [RALLY-10/sections/](RALLY-10/sections/). Allocate task-specific buffer IDs
   outside existing game assets. Upload the two templates and constant matrix
   once. Use buffered commands 34, 5, 41 and 1 to derive the section transform,
   transform embedded PLOT coordinates, and execute the result. The proposed
   input is four signed words; the initial update/call is 25 UART bytes.
   Verify straight, skewed, narrowing/widening and clipped native rendering
   headlessly. Check both material patterns, seams and signed coordinates.
   Source inspection is not sufficient evidence of working VDP execution.
2. **Remove redundant eZ80 projection.** Generate compact stripe-phase
   boundary lookups and conservative curve subdivisions offline. Preserve
   exact row material classification. Compute centres only at the resulting
   section boundaries; do not retain the 120-row projector. Traffic must
   obtain its few required road centres explicitly, including the far row
   above the road viewport. Avoid runtime greedy fitting and per-row modulo.
   Record actual table size, section counts and validation coverage. Begin
   with reliable precomputed boundaries; refine them only if evidence warrants
   it. Full centre-position precomputation remains a possible later task.
3. **Integrate an isolated candidate.** Supply a compatible task-local road
   class and generated startup commands. Apply small checked substitutions
   only to the copied game source. Preserve the existing full-scene fixture,
   traffic, player reflection, scenery, startup/completion polling and
   scheduler. Keep the present four-tick scheduling cap for controlled A/B;
   do not fold an unrelated pacing change into this experiment.
4. **Validate correctness.** Run meaningful host tests and existing sanitizer
   tests on the copied project. Exercise both tracks, lap seams, independent
   stripe phases, lateral offsets, boundary continuity, material selection,
   signed encoding and stream capacity. Distinguish sampled geometric bounds
   from exhaustive proof. Inspect native headless captures for both tracks,
   control takeover, left/right steering, traffic and Escape back to MOS.
   Functional capture instrumentation must be absent from performance runs.
5. **Measure complete frames.** Build matching frozen-mainline control and
   section candidate. Run the 64-pose, six-car, fenced deterministic fixture
   headlessly in alternating order on each track. Check matching pose hashes,
   complete acknowledgements, runtime/firmware/binary identities and stable
   command counts. Report FPS, milliseconds per frame, multiple of the
   16.67 ms / 60 Hz budget, stage timings, road UART bytes and section counts.
   Keep VDP/emulator fidelity caveats precise: eZ80 instruction timing is the
   stronger evidence; stage timings do not isolate actual VDP raster cost.
6. **Prepare human review.** Document measured outcome and limitations even
   if the candidate misses 60 Hz. When visually functional, generate its
   profile with `autoexec.txt`, launch the canonical profile-local graphical
   emulator and leave it available as the user's review notification.
   Automated tests must never open a graphical emulator. Human acceptance,
   physical-hardware qualification and explicit commit approval remain open.

## Technical basis and risks to resolve

Represent template vertices as `(u,v,u*v)`, where `u` is lateral world position
and `v` is zero/one at the top/bottom. A 4×4 transform then generates a widening,
skewed trapezoid exactly in continuous geometry. Embed each vertex in an
eight-byte PLOT record so transformed Z=0 becomes two harmless VDU 0 bytes.
Command 41 uses signed integer data, independent strip blocks and a shared
transform. A constant coefficient matrix lets the VDP derive its transform
from four integer endpoints; no floating-point coefficients cross UART per
section. The eZ80 renderer itself remains integer-only.

Qualify integer rounding and native fill rules, rather than assuming a host
picture matches FabGL. Matrix multiplication and block allocation cost VDP
work; measure that cost. Do not move it back to the eZ80 merely because it
exists. Avoid the documented/source mismatch in command 34 diagonal operation
3. If the proposed sequence fails, record the concrete failure and implement
the smallest stock-API correction within this bucket.

References: [VDP Buffered Commands API](https://agonplatform.github.io/agon-docs/vdp/Buffered-Commands-API/),
[original research](../research/pole-position/README.md),
[performance investigation](RALLY-10.md),
[pavement-only measurements](RALLY-10/pavement/results/README.md).
