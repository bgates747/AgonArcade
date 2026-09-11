# Agon Rally — flat-track prototype

![Driving prototype](docs/driving.png)

A native C++17 pseudo-3D road experiment: gray asphalt, red/white kerbs,
yellow dashed center line, white/yellow shoulder lines, doubled kerb width,
a solid blue sky and distant procedural scenery. It starts stationary on the front stretch of the compact flat tri-oval.
The earlier Fuji-reference circuit is also selectable.
Player speed is capped at 224 to limit the observed backwards-motion strobing.
Hold **Up** to accelerate or **Down** to brake to a stop. Releasing both holds
speed on the road. **Escape** returns to MOS. Hold **Left/Right** to change steering by three 256-circle angle units per rendered frame (21
each way; 1.40625° per unit). Releasing keeps the angle; holding the opposite direction returns
through center. Both held together leave it unchanged. The HUD shows the signed angle unit. Steering changes the car angle while
lateral motion retains inertia. The chase camera follows part of the lateral
movement; bends push the car outward. Kerbs slow the car moderately; grass slows it more strongly. Speed is in arbitrary world units/second, not km/h.
The HUD shows speed, steering angle and whether the car is on road, kerb or grass.

From the AgonArcade repository root:

```sh
make -C rally
make -C rally test
.venv/bin/python rally/tools/prepare_emulator.py
./rally/run.sh
```

## Track source and geometry

![Hand-traced centreline](assets/track.svg)

Two circuits are embedded in the binary:

1. **Tri-oval** (default): an original, unbanked loop with a bowed front stretch,
   long back straight and matching tighter end turns. It runs counterclockwise in map
   coordinates. Lap length is 5,760 world units; this
   is a gameplay scale, not a measured Michigan/Daytona replica. The tightest analytical radius is about 367 units, twice Fuji's 183.
   Sampled-table minima are about 369 and 190 respectively.
2. **Fuji reference**: the previously accepted hand-traced arcade-map centreline,
   preserved byte-for-byte in its generated geometry CSV. It is not surveyed
   Fuji geometry or game-ROM data. Its lap remains 32,768 world units.

Editable cubics live in `assets/tracks/fuji.json` and `tri-oval.json`.
`make -C rally track` regenerates both tables, maps, CSVs and radius summaries.
Both use 64-unit arc spacing (512 Fuji samples, 90 tri-oval samples), with
interpolated position and tangent and continuous closing seams. Ground stays
level throughout; neither circuit introduces banking. Live grip tuning limits lateral tire acceleration against the bend demand
(`speed² / radius`) and steering demand.

After loading `rally.bin` in MOS:

```text
run                 # tri-oval
run . oval          # explicit tri-oval
run . fuji          # preserved Fuji circuit
```

See [track maps and geometry notes](assets/tracks/README.md).

For each screen row, find the track point at the corresponding distance ahead
and project its lateral displacement against the camera's local right vector.
Depth uses arc distance along the course. This is an arcade approximation, not
a general 3D camera: it preserves the established road-width/depth relationship
while introducing curves. It is not intended for crossing roads, hills or banked
surfaces. Forward progress and camera orientation follow the route tangent. Steering controls
a separate lateral offset with a bounded arcade slip model, not a free-world
vehicle heading simulation. This keeps the current road projection intact.

## Rendering and validation

Mode 136 (320×240) uses double buffering, filled primitives and no active software
sprites. Every frame covers the back buffer. Simulation uses elapsed MOS
centiseconds; rendering targets 25 fps. Actual presentation rate remains subject
to CPU/VDP timing. The user confirmed the earlier automatic-following build passes on physical
hardware on September 11, 2026; the current traffic milestone is emulator-reviewed and awaits hardware validation.
Hardware frame rate was not measured.

Projection remains `z = 8000 / (y - 96)`, with camera height 50 world units.
The road starts at row 103 with a finite 24-pixel width, hiding the vanishing
point. Foreground width extends beyond the screen; signed coordinates let the
VDP clip the sides. Unresolved markings above row 116 are suppressed. Material
phase runs continuously as track position wraps, avoiding a texture jump.

Projected rows merge into bands only when material agrees and their centreline
is within one pixel of the interpolated segment, before coordinate rounding.
Adjacent bands share their boundary edge: native VDP rasterization exposed gaps
when bands stopped on separate final rows. A packed quadrilateral costs 27 bytes.
A sweep at 17-world-unit intervals around the loop observed at most 2,043 road/
background bytes and 17 bands; this sampled bound is not an exhaustive proof.
HUD and swap traffic is additional. No command-buffer patching is needed here.

`make -C rally test` runs ASan/UBSan checks for projection, material phases,
acceleration/braking/coasting, track interpolation boundaries, the closing seam,
band approximation error, command capacity and 16-bit coordinate encoding.
Headless native captures additionally exercised right and left turns, acceleration,
coasting, stopping and Escape. A host-only VDU exporter in `tests/preview_track.cpp`
helps inspect whole-loop scenes; native captures remain the rasterization check.

For repeatable native captures, append a starting distance: `run . oval 4000`
or `run . fuji 4800`. A numeric-only argument also selects a tri-oval distance.
The two-track driving build has been reviewed through user emulator play; native
selection and rendering have also been exercised in isolated headless captures.

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

## Player car artwork

The [editable Blender model and five source yaw views](assets/car/README.md) are integrated
into the driving prototype. All exported sprites use the Agon RGB222 palette and
binary transparency. The five views are embedded in the binary and preloaded
into VDP bitmap memory once, then drawn as ordinary bitmaps into the back buffer.
No separate asset files are required. The nearest view follows the fine steering angle; a VDP affine reflection supplies
the four opposite orientations. See [matrix notes](../docs/research/rally-vdp-transforms.md).

The car displays at approximately 1.6x its original size: each 64x48 source
view is resampled to 102x77 with nearest-neighbor sampling during startup.
This is about 20% smaller in each dimension than the preceding 128x96 trial.
Five VDP bitmaps use 39,270 pixel bytes; embedded source uses 15,360 bytes.
The draw origin is adjusted to retain the same ground contact and center.

Each rendered frame snapshots the complete 16-byte held-key map and applies
steering once. OS/VDP key-repeat events do not control steering. Elapsed-time
physics updates cannot apply extra steering during catch-up.

## Live grip tuning

Hold **-** to reduce grip or **=** to increase it, by five percentage points per
rendered frame. Range 25–200%, default 60%; both together leave it unchanged.
The HUD displays the value. It applies immediately and is not saved between runs.

The tire-force budget is 180 world acceleration units at 100% grip, shared by
steering and the acceleration needed to follow the curve. Demand beyond that
budget causes outward slip; braking reduces curve demand with speed squared.
Kerbs increase the lateral grip budget by 15%; grass halves it. Kerb drag removes three speed units per
centisecond above 160; grass drag removes four above 90. Throttle adds two,
so neither surface allows full-speed running. Braking still reaches zero.
These are
arcade tuning units, not calibrated real-world G measurements or a full vehicle
model. Track-relative forward motion and the chase camera remain as before.

## First traffic pass

Six opponents follow fixed lateral lines at 140, 160 and 180 world units/sec.
Their body colours are blue, British Racing Green (dark RGB222 approximation),
yellow, cyan, lavender and orange. Each has complementary nose/wing accents and
an independently chosen contrasting helmet. Lavender is lighter than blue.

Five original images cross UART once. Six 256-byte lookup tables describe the
body, stripe, wing and helmet substitutions; VDP buffered command 72 generates
the thirty opponent images locally. Tyres, metal, visor and transparency survive
unchanged. Image/table payload is 40,806 bytes instead of 274,890 pixel bytes
(about 85% less), plus command headers. One scratch mapping buffer is reused
and freed after expansion.
All liveries share five embedded source views. Thirty-five uploaded bitmaps
(five views for the player and each opponent) use 274,890 pixel bytes.

Opponents use the road's arc-distance projection and draw farthest first, before
the player. VDP Q8 matrices scale and mirror the loaded views. Relative track
tangents choose a yaw view, clamped to the available artwork. Cars disappear
behind the near plane; there are no car-to-car collisions or overtaking decisions yet.

## Distant scenery and road edges

The [procedural panorama](assets/scenery/README.md) uses solid blue sky shading, clouds, periodic foothills and a snow-capped mountain. One infinitely
distant layer scrolls with absolute track heading, wrapping at 1024 pixels.
Stock viewport scrolling retains separate scenery offsets in both draw buffers
and repaints only exposed edges; unchanged headings skip upper-sky drawing. The bottom sixteen sky rows are
refreshed to erase road/traffic overlap.
The same heading restores the same view, independent of steering and lateral
position. A prebuilt 4-bit image expands on the VDP from a single 52,736-byte upload.

Kerbs now span 16 world units per side (formerly eight). An inset two-unit
shoulder stripe occupies lateral distances 84–86 world units (moved inward
by its own two-unit width) and alternates white/yellow with the existing marking phase. Road
projection and driving limits retain their prior scale. Two narrow quadrilaterals
per road band draw the shoulder stripes without repainting the road interior; wider kerbs reuse existing commands.

Surface contact uses a 12-world-unit car half-width. Asphalt ends at ±90;
kerbs end at ±106. Thus kerb contact starts when the car centre exceeds ±78,
and grass contact when it exceeds ±94. Contact on either side selects the
worse surface. These are fixed-width arcade collision bounds, independent of
the rendered yaw view. The HUD reports ROAD, KERB or GRASS.

## Current performance limitation

The September 11 scenery/surface build (96,333 bytes) was deployed to hardware.
User testing reports lag and backwards-motion strobing at the 224 speed cap;
the emulator has also become less smooth. Functional captures and host tests
do not establish frame-rate or pacing acceptance. Timing research is pending.

## Demo driver

Launch defaults to demo driving on the tri-oval; `run . fuji` demos Fuji.
The information bar is replaced by PRESS ANY KEY TO RACE.
Track name, `demo`, and an optional starting distance can appear in any order.
Any newly held key switches to manual control after launch keys have been
released; Escape then exits on a subsequent press. Use `run . race` to bypass
demo. The takeover continues the current lap and speed.

A damped lateral controller steers toward the centre with at most three angle
units per rendered update. A 512-world-unit curvature look-ahead chooses a
conservative speed using the configured grip, leaving correction headroom.
The driver uses ordinary acceleration/braking, lateral grip and surface physics;
it never teleports or locks the car to the centre. A curvature-derived steering
baseline supplies the road-following component of the displayed angle; the
controller adds lateral correction. This baseline is subtracted from lateral
demand because the track reference frame already turns. Manual takeover removes
the baseline and restores the existing manual model. No opponent avoidance is
implemented; car-to-car collisions are still absent. There is no lap/time limit.
Host checks complete two laps on each track at 4/12/24 raw clock units per
control update, recovering from a 40-world-unit lateral offset. This is a
functional demo, not a measured constant-speed performance benchmark.

Implicit track-following/autosteer is acknowledged and deferred for review under
RALLY-13. The user requested retaining current behaviour for now.
