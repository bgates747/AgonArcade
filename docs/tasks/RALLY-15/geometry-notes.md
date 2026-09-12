# RALLY-15 geometry implementation

The candidate `SectionRoad` uses the unchanged original `Road` header for
shared track, motion and stream definitions. It does not call the original
row projector or greedy fitter. Mainline files are unchanged.

`project()` merges two sorted endpoint lists: the current 16-world-unit
track bin's existing conservative curve boundaries, and the current marking
phase's exact boundaries. It computes a road centre once at each distinct
endpoint. `emit()` sends those shared endpoint pairs to the resident VDP
section routine. There is no per-frame 120-row projection, row material modulo
loop, width calculation or trapezoid vertex expansion on the eZ80.

The first version deliberately retains the current curve tables. It therefore
uses more sections than the earlier audit's individually fitted minimum. This
preserves the existing geometric margin and isolates the change in execution
model. Refining those conservative tables is a separate measured decision.

## Exact phase lookup

The generator preserves the original integer material rule:

```text
depthHundredths(y) = floor(800000 / (y - 96))
painted(y, phase) = y >= 116 and ((depthHundredths(y) + phase) % 8000 < 4000)
```

There are 101 distinct row lists in phases 0..3999. Phases 4000..7999 reuse
those endpoints with opposite materials. A direct 4,000-byte phase index
avoids a runtime search; 101 two-byte offsets and 1,060 packed row bytes bring
the material tables to **5,262 bytes**. A 129-entry Q8 depth table adds
**516 bytes**, for **5,778 new table bytes**. The original curve tables are
reused. No depth divisions are needed for visible road or traffic rows.

Endpoint 116 is always included so the unpainted distant region remains
separate. Every list terminates at 224. Shared boundaries avoid gaps and
duplicate projection, and both geometric and material lists advance when
they select the same endpoint.

`centerAt(y)` evaluates the original integer camera/track projection explicitly
for the few traffic requests. This includes row 103, above the rendered road.
It does not interpolate from a coarse section or read an uninitialized row
cache. The same Q8 sample and rounding arithmetic is retained. Invalid or
repeated lap/phase positions are normalized once before lookup; the game
normally already supplies values in range.

## Host validation

Run from the repository root:

```sh
.venv/bin/python docs/tasks/RALLY-15/generate_phase_table.py --check
c++ -O2 -g -std=c++17 -fsanitize=address,undefined -Wall -Wextra \
  -Irally/include -Idocs/tasks/RALLY-15 \
  docs/tasks/RALLY-15/test_sections.cpp \
  -o docs/tasks/RALLY-15/.work/test_sections
docs/tasks/RALLY-15/.work/test_sections
```

The focused test passed with AddressSanitizer and UndefinedBehaviorSanitizer.
It exhausts all 8,000 legal hundredth-unit material phases and every curve
table combined with every one of the 202 distinct full-period material
classes. Capacity and row material classification therefore cover all finite
lookup combinations, irrespective of lap/stripe-phase correlation.

Geometry validation uses 106,032 held-out views: positions at 1.37-world-unit
spacing, both sides of each curve-table seam, lap endpoints and three camera
offsets (−100, 0 and +100 world units). Another 64 poses × 16 independent
phases per track check the fixture range. The largest observed Q8 centre
interpolation error was **0.447917 pixels**. Clipping continuous projected
edges to the screen did not enlarge that error. These are sampled geometric
bounds, not an exhaustive proof over every fractional position or a VDP
rasterisation measurement.

Tests also check shared endpoint continuity, exact explicit traffic centres,
signed off-screen coordinates reaching the protocol unchanged, material
program selection, explicit lap/phase wrap, optional background fill and
stream capacity. Integer vertex rounding and VDP fill rules are qualified
separately by native protocol and integrated visual tests.

## Actual section counts

The first table weights each curve bin and distinct material class equally;
it is a lookup coverage report rather than a driving-time distribution.

| Track | Table/material combinations | Minimum sections | Maximum | Mean |
|---|---:|---:|---:|---:|
| Tri-oval | 72,720 | 10 | 29 | 19.3563 |
| Fuji | 413,696 | 10 | 32 | 15.1734 |

For the unchanged 64-pose deterministic fixture:

| Track | Sections over 64 frames | Mean/frame | Maximum/frame | Road UART bytes over 64 frames |
|---|---:|---:|---:|---:|
| Tri-oval | 1,239 | 19.3594 | 28 | 32,895 |
| Fuji | 955 | 14.9219 | 24 | 25,795 |

Byte counts include 25 bytes per section plus 30 per frame for grass and HUD
fills, with scenery handled by the unchanged outer game renderer. Resident
program startup is excluded. The largest stream across all lookup combinations
is **830 bytes**. Even the structural worst case of one section per row would
fit: `45 + 120 × 25 = 3,045` bytes including optional sky, below the existing
4,096-byte stream capacity.

These counts establish reduced projection and UART work. Complete-frame speed
must come from the separate headless candidate/control measurements.
