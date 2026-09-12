# Pavement-only experiment

User-authorized temporary RALLY-10 experiment. All implementation and tooling
belong in this bucket; mainline Rally source and its binary remain untouched.

The [headless results](results/README.md) report FPS equivalents, absolute frame
times and the 60 Hz budget alongside the control build.

Render only gray pavement with filled trapezoids. Remove kerbs, shoulder stripes
and centreline stripes from road emission, and stop splitting pavement bands at
material transitions. Keep the 120-row viewport, width, projection, scenery,
cars, controls, collision/surface physics and pacing unchanged. Invisible kerb
and grass handling boundaries still exist; this is a rendering experiment.
Projection still computes the old paint flags so this comparison isolates
emission and segmentation. It does not yet introduce bitmap strips or buffered
VDP command reuse.

`pavement.hpp` derives a temporary renderer from the existing Road type. The
runner snapshots Rally into ignored `.work/` directories, injects this type only
into the experimental copy and builds using the established Linux helper.
It preserves a separate full-markings control from the identical source snapshot.
Existing tests run in each copy; the candidate adds phase-independence, gray-quad
encoding, geometric error and capacity checks.

From the repository root, using `.venv/bin/python`:

```sh
.venv/bin/python docs/tasks/RALLY-10/pavement/experiment.py build
.venv/bin/python docs/tasks/RALLY-10/pavement/experiment.py bench
.venv/bin/python docs/tasks/RALLY-10/pavement/experiment.py capture
.venv/bin/python docs/tasks/RALLY-10/pavement/experiment.py review
```

Benchmarks and automated captures are headless. The `review` action alone opens
a graphical emulator, using the canonical wrapper and an autoexec that loads the
isolated pavement binary. The full game remains available in its existing profile.
Report absolute frame time, the 16.67 ms/60 Hz budget, stage costs and wire bytes.
Root TODO.md remains the sole task checklist; this experiment has no separate list.
