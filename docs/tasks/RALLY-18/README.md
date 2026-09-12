# RALLY-18

Centreline-fixed camera and precomputed road experiment. The accepted
[contract](../RALLY-18.md) and previous work were frozen in commit **182a1d0**.
Implementation remains isolated here. The user reviewed the running candidate
and requested a checkpoint before further discussion; see [freeze note](FREEZE.md).

The road lookup replaces live map projection with compact precomputed screen
lines and fixed-point interpolation. Steering moves the player across the road;
it does not move the camera sideways. An optional vehicle-view correction uses
heading plus the camera-to-car viewing angle. Driving physics is unchanged.

| Evidence | Contents |
|---|---|
| [Measured results](results/README.md) | Matched computation, command/UART and completed-render results in milliseconds and FPS |
| [Road qualification](road-results/README.md) | Exhaustive geometry bounds, rejected table alternatives, loader and sanitizer checks |
| [Memory budget](memory.md) | Actual link-map sizes, selected-table residency, loading and incremental VDP usage |
| [Vehicle notes](vehicle-notes.md) | Tyre/contact anchoring, mirror compensation, integer bearing tables and tests |
| [Implementation record](IMPLEMENTATION.md) | Deliberate shared-reference rounding, integration choices and unchanged timing rules |
| [Visual methodology](visual-plan.md) | Native captures, state comparisons and scripted input checks |
| [Visual results](visual-results/README.md) | Six exact native image pairs, camera invariance, controls and off-screen behavior |

From the repository root, prepare both tracks and both orientation options and
launch the oval with perspective-corrected vehicle views:

```
.venv/bin/python docs/tasks/RALLY-18/review.py --prepare-all --launch
```

To open Fuji, use `--track fuji --launch`. To compare the original sprite-view
selection, use `--orientation control --launch`. Each invocation prepares an
isolated canonical profile and records its path in review-profiles.json. The
profile's autoexec loads the lookup binary and selected road data. Demo runs
until a key takes over; arrow keys drive, minus/equal adjust grip, Escape exits.
Interactive presentation retains the existing four-tick deadline and elapsed
time physics, with a stock VDP completion poll after each swap (`fence`).
No benchmark byte sink or screenshot interposer is in review.

Reproduction uses repository `.venv/bin/python`:

```
.venv/bin/python docs/tasks/RALLY-18/generate_road.py
.venv/bin/python docs/tasks/RALLY-18/verify_road.py
.venv/bin/python docs/tasks/RALLY-18/generate_vehicle_tables.py
.venv/bin/python docs/tasks/RALLY-18/build.py live lookup
.venv/bin/python docs/tasks/RALLY-18/bench.py --perspective
.venv/bin/python docs/tasks/RALLY-18/bench.py --modes display --perspective
.venv/bin/python docs/tasks/RALLY-18/visual_cases.py --mode all
```

Run exhaustive host validation before performance measurements. All performance
runs are headless; the display-only repeat separates host contention during the
initial validation run. The benchmark manifest retains every run and its exact
binary, source/data identities, CPU flags, counts and cycle or clock evidence.
Only launch a graphical review after those runs finish.

Generated builds and emulator profiles remain under ignored `.work/` and
`.emulator/`. New code, data and retained evidence stay inside this task bucket.
`TODO.md` at the repository root is the sole task checklist.
