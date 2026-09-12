# Resident section protocol

Implementation notes for the frozen [RALLY-15 contract](../RALLY-15.md).
The generator and its host tests do not establish native VDP drawing speed or
raster correctness; native captures and timings belong with the task results.

## Interface and ownership

`protocol.py` generates `section_protocol.hpp`. The header includes the original
`road.hpp` for `rally::Stream` and provides:

```cpp
rally::section::Startup
rally::section::StartupSize
rally::section::draw(stream, cxTop, cxBottom, yTop, yBottom, painted)
```

Upload the 864 startup bytes once, before the startup completion barrier. Each
`draw` appends exactly 25 bytes: an 11-byte command-5 envelope, four signed
16-bit endpoint parameters (8 bytes), and a 6-byte call. The generated C++ is
integer-only; the caller ensures `104 <= yTop < yBottom <= 224` and signed-word
parameter bounds. Shared `Stream` capacity/overflow behaviour is preserved.

The two immutable templates are 175 and 140 bytes, each split into independent
35-byte strip blocks. The painted template has kerb, pavement, two shoulder
strips and centreline; the alternate template omits the centreline. Lateral
world coordinates and palette indices match the existing road renderer.

| Buffer | Purpose |
| --- | --- |
| 30000 | Four signed endpoint words followed by constant word 1 |
| 30001 | Parameter vector, a 5-by-1 float matrix |
| 30002 | Immutable 8-by-5 coefficient matrix |
| 30003 | Product, eight float coefficients |
| 30004 | Mutable 4-by-4 section transform |
| 30005 / 30006 | Immutable painted / alternate templates |
| 30007 | Transformed output, replaced for each section |
| 30008 / 30009 | Resident painted / alternate draw procedures |

These IDs do not intersect current Rally scenery source 63800, palette buffer
63960, traffic transforms starting at 63970, player transform 63984, or bitmap
buffers starting at 64000. Startup clears exactly 30000 through 30009.

## Expansion

Each stored vertex is `(u, v, u*v)`: lateral world position `u`, and `v` equal
to zero at the top or one at the bottom. Given endpoint centres `ct/cb` and
screen rows `yt/yb`, VDP matrix operations calculate:

```text
[(yt-96)/50, cb-ct, (yb-yt)/50, ct]
[         0, yb-yt,          0, yt]
[         0,     0,          0,  0]
[         0,     0,          0,  1]
```

Command 34 loads the four integer parameters plus the retained constant 1 as
a vector, then multiplies the constant coefficient matrix by that vector.
Command 5 copies the product's 32 bytes into the transform's first two rows.
The remaining rows and matrix metadata stay unchanged.

Command 41 applies this matrix with `options=0x4e`, `format=0xc0`, offset 5,
stride 8 and limit 4 per block. Each block consists of three GCOL bytes and
four PLOT records, with three signed 16-bit coordinates per record. The
third output coordinate is zero, so the record becomes an ordinary PLOT plus
two VDU 0 bytes. The first two vertices move to top left/right; the next two
fill triangles to bottom left/right. Command 1 executes the transformed
blocks in order. The source templates are never changed.

## Source checks and precision

Checked against the local emulator checkout's `src/vdp/vdp-console8/video/`
implementation, whose `version.h` reports VDP 2.16.0:

- `vdu_buffered.h:2189`: command 41 multiplies coordinates directly; it does
  not request a matrix inverse, so the zero third row is valid.
- `buffers.h:197` and `vdu_buffered.h:2314`: after the fourth vertex, span
  handling advances the block index; per-block processing restores offset 5
  and limit 4 for the next cloned block.
- `vdu_buffered.h:1818`: command 34 creates/replaces matrices and preserves
  their dimensions in metadata. Multiplication pads to square dimensions;
  this 8-by-5 times 5-by-1 operation uses an 8-by-8 intermediate.
- `types.h:253` and `types.h:283`: fixed-point format `0xc0` reads signed
  16-bit integers and converts the float results back to 16-bit coordinates.
  Final conversion truncates; it is not nearest-pixel rounding. Negative
  output words and clipping need native qualification.
- Command 34 diagonal operation 3 is deliberately unused: the local source
  reads one argument per diagonal element, unlike the scalar wording in the
  documentation.

Float32 products can differ from ideal real-number coordinates by one output
pixel at truncation boundaries. A shared endpoint computed as one section's
bottom and the next section's top can also differ by one pixel. Host tests
bound that difference over every interior viewport boundary, but do not claim
pixel-identical stock-VDP output. Native seam inspection must establish that
the fill order and integer conversion produce an acceptable image.

VDP allocations remain part of this experiment: matrix creation makes new
blocks and command 41 clones each strip block. The intended trade is more
work on VDP in exchange for less eZ80 computation and UART traffic. Measure
complete frames before deciding whether these costs need further work.

## Host validation

```sh
.venv/bin/python docs/tasks/RALLY-15/protocol.py --check
.venv/bin/python docs/tasks/RALLY-15/test_protocol.py -v
```

Tests decode the actual startup/update/call bytes, execute the relevant
buffer and matrix operations, and compare resulting PLOT coordinates with
an independent endpoint formula. Coverage includes both material templates,
straight/skewed/clipped sections, signed encoding, invalid parameter bounds,
all interior row boundaries, zero Z padding, retained matrix rows, and repeated
execution without modifying templates or constant data. A compiled C++ test
under ASan/UBSan verifies byte-for-byte agreement with Python output and
unchanged stream overflow behaviour. This decoder is intentionally narrow;
it is neither a full VDP emulator nor raster validation.

## Native qualification

The independent task-local `probe.cpp` draws twelve adjacent sections either
through this resident program or directly through integer PLOT coordinates.
Its stock-VDP headless captures are pixel-identical, and both variants receive
completion acknowledgements. The cases include both material patterns, skew,
clipping, and a negative centre of -30. See
[the comparison](results/probe/comparison.json) and
[capture/build identities](results/probe/manifest.json).

This is a static protocol qualification, separate from the full-game visual
and timing checks. It includes one-row and two-row sections as well as taller
bands. It does not establish pixel equivalence for every possible endpoint.
