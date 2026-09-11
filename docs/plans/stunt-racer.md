# Stunt racer — project direction

Recorded September 11, 2026. User reports Tom requests Stunt Car Racer and
specifies a custom VDP with a true 3D renderer capable of flat-shading triangles.
This is a separate future AgonArcade subproject; no implementation has started.
Root TODO.md owns STUNT-01. Rally remains its existing stock-VDP application.

## Reference and intended foundation

[User-supplied game reference](https://en.wikipedia.org/wiki/Stunt_Car_Racer):
elevated racing tracks, ramps/gaps, airborne cars, suspension and landing damage.
The intended visual foundation is flat-shaded 3D. Original artwork and a new
release title can follow; the source game's name identifies the reference.

Read-only examples inspected in `/home/smith/Agon/mystuff/pingoasm`:

1. `apps/earth-party-flat/README.md`: per-triangle palette colors, scene lighting,
   eZ80-owned poses and asynchronous rendering. Candidate architecture reference.
2. `tests/apps/lighting-shading/README.md`: isolated flat-palette/lighting fixture;
   shading and illumination are separate controls. Candidate first qualification.
3. Root README: one render in flight, P3DR completion and pose coalescing;
   retained scene resources avoid resending mesh geometry every frame.
4. `apps/fsim/application/README.md`: working C/assembly integration precedent;
   not a requirement to adopt the terrain application's complexity.

## Proposed first experiment

Load a small elevated track mesh once, then update camera/vehicle transforms.
The VDP owns 3D rendering; eZ80 owns input, simulation and collisions. Begin with
one straight platform and ramp, proving clipping, depth visibility and camera
motion, then wheel contact, suspension, takeoff and landing. The physical feel
of cresting and landing is the key uncertainty after renderer qualification.

This is a proposal, not an active implementation checklist. Confirm the current
Pingo protocol/firmware provenance from its maintained contracts before coding;
example READMEs alone do not establish binary compatibility. Use a dedicated
AgonArcade emulator profile through canonical bespoke-VDP setup when implemented.
Do not alter the Pingo application repository or firmware as part of this brief.
