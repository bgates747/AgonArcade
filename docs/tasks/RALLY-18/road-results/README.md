# RALLY-18 road lookup qualification

The selected representation stores **precomputed projected screen-line
polynomials**, with one selected track loaded before gameplay. The runtime
does not fetch map coordinates, call `trackSample()`, form a camera direction,
or perform a map-to-camera transform for road/traffic centre queries. It does
retain fixed-point interpolation arithmetic. Physics and vehicle heading are
separate consumers of the original track data.

The frozen contract remains [RALLY-18](../../RALLY-18.md). This document records
implementation decisions and evidence; it does not change that contract.

## Selection and sizing

Uniform sampled views miss sharp changes when a row's look-ahead point crosses
a stored track segment. The initial 16-world-unit proposal fails the geometry
limit even before road sections are drawn. The measured alternatives below use
122 rows, signed 16-bit centres scaled by 16, and linear progress interpolation.
Error was measured every 0.25 world unit across both complete laps, including
the cyclic last/first table interval. Sizes exclude a small file header.

| Track | Progress step | Dense bytes | Row delta + dedup bytes | Sparse rows + dedup bytes | Maximum temporal error |
| --- | ---: | ---: | ---: | ---: | ---: |
| Oval | 32 | 43,920 | 22,712 | 9,321 | 2.977 px |
| Oval | 16 | 87,840 | 45,426 | 18,762 | 1.602 px |
| Oval | 8 | 175,680 | 90,852 | 37,350 | 0.855 px |
| Oval | 4 | 351,360 | 181,708 | 73,962 | 0.473 px |
| Fuji | 32 | 249,856 | 93,732 | 36,240 | 5.527 px |
| Fuji | 16 | 499,712 | 187,200 | 72,871 | 3.008 px |
| Fuji | 8 | 999,424 | 374,031 | 145,364 | 1.539 px |
| Fuji | 4 | 1,998,848 | 747,689 | 288,772 | 0.855 px |

Row delta encoding means one signed 16-bit starting value followed by signed
8-bit deltas, with two extra bytes for an escape. Identical complete views share
a 16-bit view index. Sparse rows use row/value knots with a maximum 1/16-pixel
row-interpolation deviation **from the already quantized sampled view**. Their
reported sizes include the per-view knot count and view index. Sparse row error
and its runtime search/interpolation overhead would be additional to the
temporal error shown here; this table does not claim that the compressed
alternatives pass the final geometry test.

The selected coefficients need **20,520 bytes for the oval and 116,736 bytes for
Fuji**, with direct indexing and no variable-length decoding, per-frame SD
access, or live-projection fallback. The disk files add a 64-byte header:

| Track | Stored track intervals | Coefficient records | Resident payload | Disk file |
| --- | ---: | ---: | ---: | ---: |
| Oval | 90 | 1,710 | 20,520 B | 20,584 B |
| Fuji | 512 | 9,728 | 116,736 B | 116,800 B |

This is selected-track residency, not allocation of both tables. The runtime
also uses a 19-entry line cache (171 bytes), section endpoint/state arrays, and
small bookkeeping fields. The native host's complete `LookupRoad` object is
976 bytes; the game integration's eZ80 link map is authoritative for target
layout and total code/BSS/heap/stack accounting. The loader has a 64-byte header
buffer and allocates exactly the payload size. No second payload copy or
decompression buffer is allocated. The game integration separately reports
startup loading time and its remaining memory budget.

## What the coefficients represent

Within a stored 64-world-unit track interval, let `t` run from 0 to 1 and let
`q = screen_y - 96`. The existing track samples linearly interpolate position
and tangent. After substituting these into the centreline-camera projection,
the projected screen centre in each ahead interval has the form:

```text
screen_x(q, t) = A + B*t + q*(C + D*t + E*t*t)
```

The offline generator computes all five coefficients from the track. It stores
`A` scaled by 64, `B` by 256, and `C/D/E` by 4096. `C` uses signed 32 bits;
the others use signed 16 bits, with explicit range checks. Every record is
12 bytes. There are 19 possible ahead intervals for each current track interval,
covering every row from 103 through 224.

Runtime selects the current 64-unit interval once. For each row it selects the
ahead interval using the already existing depth table. It evaluates and caches
that interval's screen-line intercept and slope. It then evaluates the line at
the requested row. The table boundary follows the exact reference's Q8 depth,
so the sharp ahead-segment crossings are retained instead of smoothed across a
uniform set of sampled views. The coefficient derivation uses continuous
segments; all discrepancies from the reference's intermediate integer rounding
are included in the measured bounds below.

The shared progress fraction has 12 fractional bits; its square is calculated
once per frame. A newly used line requires three signed 32-bit fixed-point
multiplications. Every centre query then needs one slope-times-row multiply.
There is no per-endpoint general division: the evaluator divides only by 4096
and 16, preserving C++ truncation toward zero. Row/track selection and cache
checks still have a cost. By comparison, the optimized live endpoint calculation
requires at least two map-position interpolation multiplies, two cross-product
multiplies, one perspective multiply and division by 50, plus its map loads.
The compiler can omit the ahead tangent fields, so counting all four fields of
`trackSample()` as mandatory would overstate the saving. Actual eZ80 cycle
measurements belong in the game benchmark results; these operation counts are
not timing results.

The existing stripe phase lookup and conservative curve boundaries remain
unchanged. Stripe phase is independent of wrapped track position. The task's
live reference and lookup both round emitted section centres to the nearest
pixel, with ties away from zero. This is an explicit change from the earlier
renderer’s truncation: it reserves a half-pixel endpoint quantization budget.
The live projection's arithmetic remains unchanged. Traffic `centerAt()` keeps
the original truncation rule.

## Geometry and safety evidence

The exhaustive run checks **all 3,852,800 legal hundredth-unit positions** across
both tracks, with additional duplicate samples immediately around every stored
track seam and the lap seam. Every position checks all 122 road/traffic rows.
For final section error it checks every distinct section interval generated by
all 202 material phase classes, covering every legal phase independently of
track position. It does not grant the table and section approximation separate
one-pixel allowances.

| Track | Maximum row lookup error | Maximum final section centre/edge error | Largest section count | Road bytes, no sky |
| --- | ---: | ---: | ---: | ---: |
| Oval | 0.13671875 px | 0.95703125 px | 29 | 755 |
| Fuji | 0.13671875 px | 0.95312500 px | 32 | 830 |

The final section comparison uses the actual integer endpoints submitted by the
candidate, interpolates the drawn section between them, and compares against
the exact live reference's Q8 centre at every covered row. The continuous road
edge has the same centre displacement because width and row are unchanged;
clipping cannot increase that displacement. This bounds geometry, including
table/interpolation/endpoint rounding and trapezoid approximation. It is not a
claim that native VDP rasterization is pixel-identical at every subpixel edge;
native images are qualified separately by the game integration.

The retained exhaustive log records **470,261,444 row queries** and
**13,988,513,975 phase-independent section-row comparisons** including seam
duplicates. All 486,416 finite track-bin/material-class combinations also check
the candidate's boundaries, material labels and command-buffer capacity against
the live reference. The 4,096-byte stream has substantial capacity remaining;
including the sky adds 15 bytes to the road figures above.

ASan/UBSan checks cover a held-out 16.07-world-unit sweep and all stored-track
seams. Loader tests reject missing files, wrong tracks, unsupported versions,
incorrect sizes, truncation, trailing bytes and corrupted payloads. Reloading
and track switching are tested. Steering/lateral camera arguments leave emitted
road bytes identical in explicit positive/negative cases. Negative and repeated
positions/phases normalize at lap/pattern boundaries. The centre ranges over
the full legal domain are 35..161 pixels for the oval and 19..278 for Fuji;
road edges may extend outside the viewport and retain normal VDP clipping.

The file header contains magic/version, track identity, track length/count,
camera/row dimensions, interval/record sizes, fixed-point scales, representation
identity, payload length and FNV-1a checksum. Track identity is calculated from
the original signed 16-bit track point fields in canonical little-endian order.
The loader compares those identities and dimensions before allocation and
checks the complete payload and exact file length before allowing use. Source
and file SHA-256 identities are retained in `../data/manifest.json`.

## Reproduction

Run from the repository root:

```sh
.venv/bin/python docs/tasks/RALLY-18/generate_road.py
.venv/bin/python docs/tasks/RALLY-18/verify_road.py
```

The second command exhausts positions, runs the independent sanitizer sample,
and repeats the rejected-table sizing study. `--quick` replaces exhaustive
position coverage with the sanitizer sampling stride while retaining all phase
classes, all stored-track seam cases, and loader checks. Generated executables
stay in the task's ignored `.work/`. Data, source, reports and manifests remain
inside this task. Accepted game and upstream sources are only read.
