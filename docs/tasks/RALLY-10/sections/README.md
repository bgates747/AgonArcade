# Kerb-pitch sections executed on the VDP

Design and raw-command draft following the user's proposal. All experiment code
belongs in this task bucket. Mainline and the pavement experiment are unchanged.
This document does not claim the new protocol has run on an emulator or hardware.

## Rendering unit

One section covers one constant-colour kerb block: 40 world units in the current
pattern, with the complete A/B repeat spanning 80. Store two section templates:
red kerbs/yellow shoulders/yellow centreline, and white kerbs/white shoulders/no
centreline. Each contains the pavement and markings as filled triangles.

The eZ80 supplies only the centre X and row Y at the section's top and bottom.
That is four signed words, eight geometry bytes. The VDP derives perspective
widths, expands all strip vertices, and executes the resident drawing sequence.
No per-strip coordinates or floating-point coefficients need cross UART.

Buffered command 41 transforms coordinate data embedded in PLOT commands. It
provides an exact route to a widening trapezoid even though a single affine
bitmap transform cannot turn a rectangle into one. The distinction is that
the section template encodes upper/lower vertices as described below.

## Concrete command sequence

The [draft generator](protocol.py) uses reserved-for-this-proposal IDs 30000–30009.
Upload templates, coefficient matrix and two stored programs once. For each
section, update the eight-byte parameter buffer and call the red or white program.
The resident program performs:

1. Command 34: load the four integer parameters plus a resident constant 1.
2. Command 34: multiply by a constant coefficient matrix, deriving scales,
   centre displacement, height and origin on the VDP.
3. Command 5: copy the resulting eight floats into the prepared transform.
4. Command 41: transform all vertex records in the chosen section template.
5. Command 1: execute the resulting pavement/marking PLOT commands.

A standalone call is 25 UART bytes including the eight-byte update, framing and
call. A first implementation with roughly 10–15 sections would therefore use
250–375 section-command bytes, plus other frame traffic. A later master program
could consume a packed whole-frame table and share adjoining boundary records,
amortizing the headers. Those lower frame-byte counts are not yet implemented.

Run `.venv/bin/python docs/tasks/RALLY-10/sections/protocol.py` to generate raw
startup and single-section example streams in ignored `.work/`. These expect
physical graphics coordinates, the existing Rally palette/mode setup, and an
appropriate graphics viewport. They neither replace a complete game program
nor perform buffer swaps themselves.

## Why the transform works

Store every template vertex as `(u,v,u*v)`: `u` is its lateral world offset and
`v` is zero at the top, one at the bottom. The four-by-four matrix is:

```text
[ scaleTop, centreBottom-centreTop, scaleBottom-scaleTop, centreTop ]
[        0,         yBottom-yTop,                    0,      yTop ]
[        0,                    0,                    0,         0 ]
[        0,                    0,                    0,         1 ]
```

Here `scale=(y−96)/50`, preserving the current road-width relationship. The
result is `(screenX,screenY,0)`. Each source PLOT record contains an extra signed
word for the third coordinate; after transformation its two zero bytes are
harmless VDU 0 padding. Each strip is one 35-byte block: three-byte GCOL plus
four eight-byte vertex records. Command 41 uses options `0x4e`, format `0xc0`,
offset 5, stride 8 and limit 4. Its block-by-block mode applies this to all strips.

Installed source inspection confirms that command 41 accepts the singular
matrix: it multiplies coordinate vectors without requesting an inverse. It
also resets the offset and item limit between the strip blocks. This is a data
transform followed by triangle plotting, not draw-time bitmap transformation.

## Boundary and curve measurements

With the current 120-row viewport, alternating markings occupy y=116..223.
There are 9–10 marked pitch sections depending on phase. Rows 104..115 comprise
the remaining 12 rows, 10% of the road view. Existing white edges continue there,
but colour alternation and the yellow centreline stop.

All 4,000 phases in a half-period produce only 101 distinct lists of boundary
rows: 1,060 packed row bytes before indexing. The next half-period reuses those
lists with colours exchanged. A phase-indexed lookup can remove the per-row
depth/modulo classification; existing row/depth lookups give boundary distances.

Host sampling at 64 lap positions × 16 independent phases per track found:

| Sections at a one-pixel clipped geometric tolerance | Oval | Fuji |
| --- | ---: | ---: |
| Marked region, average | 9.79 | 9.55 |
| Marked region, maximum | 12 | 11 |
| Entire road including far region, average | 12.63 | 11.58 |
| Entire road, maximum in this sample | 15 | 15 |

One trapezoid per marked pitch met that tolerance throughout the marked region
in 73%/95% of oval/Fuji samples. Worst marked deviations were 2.56/2.49 pixels.
Occasional precomputed curve subdivisions can handle those cases without a
runtime search or a change to the material pattern.

A truly straight distant section can use one trapezoid. The current distant
region spans about 421–1,000 world units, so it can cross substantial bends.
An every-whole-world-unit sweep found worst clipped errors of 16.9/23.6 pixels
for one far trapezoid, and 4.6/5.7 even with the best split into two. The old
one-pixel tolerance sometimes needs six small far pieces. Thus two is a possible
deliberate visual simplification, not a guaranteed match to the existing curves.

The host audits are `audit.cpp` and `sections.cpp` in this bucket. They measure
continuous projected centre/outer-edge approximation with screen clipping;
they are not native raster tests or frame-time benchmarks. Internal thin
markings, integer rounding, seams and lateral positions still need visual checks.

Reproduce the host audits from the repository root:

```sh
mkdir -p docs/tasks/RALLY-10/sections/.work
c++ -O2 -std=c++17 -Irally/include docs/tasks/RALLY-10/sections/audit.cpp -o docs/tasks/RALLY-10/sections/.work/audit
c++ -O2 -std=c++17 -Irally/include docs/tasks/RALLY-10/sections/sections.cpp -o docs/tasks/RALLY-10/sections/.work/sections
docs/tasks/RALLY-10/sections/.work/audit
docs/tasks/RALLY-10/sections/.work/sections
```

## eZ80 work that remains

Select the stripe-phase row list and any stored curve splits. Compute or look up
centre positions only at these section boundaries, rather than projecting all
120 rows. Traffic currently reads the per-row road-centre array; the experiment
must instead obtain its few required centres from the active sections or direct
samples so the old 120-row projector is not inadvertently retained.

Full precomputation of the boundary centres can be a later step. The first
design already moves strip-width calculations, vertex expansion and command
construction onto the VDP, while reducing the number of road projections.

## Qualification notes and sources

The next implementation needs headless functional and timing checks, then a
human review launch. Report milliseconds/frame and the 16.67 ms budget, not
just a percentage improvement. The current matrix helper pads its product to
8×8, and command 41 copies/allocates template blocks. These are VDP costs to
measure, not reasons to move the work back to the eZ80. No throughput result is
claimed for this draft. Avoid command 34 diagonal operation 3: its current
implementation reads multiple arguments despite a single-scalar description.

Primary API: [Buffered Commands API](https://agonplatform.github.io/agon-docs/vdp/Buffered-Commands-API/),
commands 0, 1, 5, 34 and 41. The original research's section 4.3 already describes
[material-aligned bands and distant simplification](../../../research/pole-position/README.md#43-recommended-geometryrendering-split).
The installed VDP source confirms the program mechanics in `vdu_buffered.h`
(`bufferMatrixManipulate`, `bufferTransformData`) and `buffers.h` (`getBufferSpan`).
