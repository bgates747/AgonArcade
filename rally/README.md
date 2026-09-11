# Agon Rally — flat-track prototype

![Emulator right-hand bend](docs/curve-right.png)

A native C++17 pseudo-3D road experiment: gray asphalt, red/white kerbs,
yellow dashed center line, blue sky and green ground. It starts stationary on
the top straight, travelling right around a loop traced from the supplied map.
Hold **Up** to accelerate or **Down** to brake to a stop. Releasing both holds
speed. **Escape** returns to MOS. The camera follows the track automatically;
there is no steering yet. Speed is in arbitrary world units/second, not km/h.
The HUD shows progress around the loop and the current drawing-band count.

From the AgonArcade repository root:

```sh
make -C rally
make -C rally test
.venv/bin/python rally/tools/prepare_emulator.py
./rally/run.sh
```

## Track source and geometry

![Hand-traced centreline](assets/track.svg)

The centreline is hand-digitized from the user's 320×200 arcade track-map image.
It follows the visible route and direction, but is not surveyed Fuji geometry
or extracted game-ROM data. The Jukebox Potrace adapters were inspected; they
trace region outlines, whereas this small reference needs one smooth centreline.
No Jukebox files were changed. A mask was unnecessary for this first trace.

`tools/generate_track.py` owns editable cubic control points in reference-image
coordinates. `make -C rally track` regenerates the SVG, CSV, and integer C++ table.
The closed loop is uniformly sampled by arc length into 512 points, spaced 64
world units apart: 32,768 units total. This scale is chosen for road rendering,
not a claim to reproduce the map's printed 4,359-meter lap length. The generator
also stores unit tangents; runtime interpolation preserves fractional progress
through samples and across the closing seam. Geometry uses fixed-point math.

For each screen row, find the track point at the corresponding distance ahead
and project its lateral displacement against the camera's local right vector.
Depth uses arc distance along the course. This is an arcade approximation, not
a general 3D camera: it preserves the established road-width/depth relationship
while introducing curves. It is not intended for crossing roads, hills or banked
surfaces. The simulation automatically follows the centreline and tangent.

## Rendering and validation

Mode 136 (320×240) uses double buffering, filled primitives and no active software
sprites. Every frame covers the back buffer. Simulation uses elapsed MOS
centiseconds; rendering targets 25 fps. Actual presentation rate remains subject
to CPU/VDP timing. The user confirmed the deployed prototype passes on physical
hardware on September 11, 2026; hardware frame rate was not measured.

Projection remains `z = 8000 / (y - 96)`, with camera height 50 world units.
The road starts at row 103 with a finite 24-pixel width, hiding the vanishing
point. Foreground width extends beyond the screen; signed coordinates let the
VDP clip the sides. Unresolved markings above row 116 are suppressed. Material
phase runs continuously as track position wraps, avoiding a texture jump.

Projected rows merge into bands only when material agrees and their centreline
is within one pixel of the interpolated segment, before coordinate rounding.
Adjacent bands share their boundary edge: native VDP rasterization exposed gaps
when bands stopped on separate final rows. A packed quadrilateral costs 27 bytes.
A sweep at 17-world-unit intervals around the loop observed at most 1,125 road/
background bytes and 17 bands; this sampled bound is not an exhaustive proof.
HUD and swap traffic is additional. No command-buffer patching is needed here.

`make -C rally test` runs ASan/UBSan checks for projection, material phases,
acceleration/braking/coasting, track interpolation boundaries, the closing seam,
band approximation error, command capacity and 16-bit coordinate encoding.
Headless native captures additionally exercised right and left turns, acceleration,
coasting, stopping and Escape. A host-only VDU exporter in `tests/preview_track.cpp`
helps inspect whole-loop scenes; native captures remain the rasterization check.

For repeatable native captures, the program accepts an optional starting distance
in world units. After loading the binary in MOS, `run . 4800` starts before the
first sharp right bend; `run . 14500` approaches the left bend. Normal `run`
starts at the map's start point. The user accepted emulator gameplay and confirmed the hardware test passes.

## Hardware deployment

With the AGON card mounted at `/media/smith/AGON`, run
`.venv/bin/python rally/tools/deploy.py` from the repository root. It publishes
only `rally.bin` to `/mystuff/arcade/rally` and leaves `autoexec.txt` untouched.
From MOS:

```text
cd /mystuff/arcade/rally
load rally.bin
run
```
