# Stock affine routes and timing boundaries

The stock API caches an inverse matrix while its matrix buffer remains unchanged.
Rally's identity-plus-six-value rebuild replaces that buffer, so the next draw
must create another inverse. Direct transformed plotting and command 40 then use
different raster paths. These are source findings; their cost on the target must
be measured before claiming a general weakness in the stock API.

## Source identity

The VDP reference is commit
`1056ee38ec1cc68ed327bd32ee47d04b1c30597c`; the vdp-gl reference is
`ac2dd5986daf496c43ae8e7fe41836274aec54a0`. The local VDP object repository is
`/Agon/mystuff/agon-vdplet/build/firmware/upstream.git`; obtain frozen VDP files
with `git show COMMIT:video/PATH`. The unpacked `firmware-src` directory is inside
an outer repository and is not itself the source Git repository.

The live `firmware-src/video/vdu_buffered.h` contains downstream changes, including
audio-buffer reservation logic. Its SHA256 is
`83c8c78ba5eb8fedacbd55397cfd0b6109e50cf71272b681a9d2b8f08f3d8e8c`, whereas the
frozen VDP file is
`b9d9d93295ddc5fb05c802071057e32ed9755837f029ce381340072352c262f0`.
The extracted command-40 code comes from the frozen file. Exact extraction hashes,
licenses and host shims are recorded in [SOURCE-MANIFEST.json](SOURCE-MANIFEST.json).
That manifest is an extraction correspondence, not a claim that a new firmware
binary was reproduced.

The following line references name files at those commits. Local vdp-gl source
is under `firmware-src/.pio/libdeps/esp32dev/vdp-gl/src`.

## Matrix selection, rebuilding and cached inverse

1. VDP `video/vdu_sys.h:262` dispatches `23,0,150,flags,matrixId` to
   `Context::setAffineTransform`; `video/context/graphics.h:894` selects the
   matrix ID when flag bit 0 is set. Matrix selection is distinct from creating
   or rebuilding its contents.
2. VDP `video/vdu_buffered.h:1613`,
   `VDUStreamProcessor::bufferAffineTransform`, implements buffered command 32.
   Identity operation 0 replaces the matrix. Operation 11 reads six values and
   composes the affine matrix through the DSP multiply routine. The operation
   creates a new matrix BufferStream and clears/replaces the target buffer.
   The fixture uses the game's identity operation followed by six signed 16-bit
   fixed-Q8 values, format byte `0xC8`.
3. VDP `video/buffers.h:161`, `checkTransformBuffer`, checks the matrix and creates
   its inverse if the buffer has only its original block. It invokes
   `dspm::Mat(transform,3,3).inverse()`, stores the resulting nine floats in a
   second 36-byte block, and reuses that block on later checks. Replacing the
   matrix discards the cached inverse.
4. VDP `video/context/graphics.h:857`, `Context::drawBitmap`, obtains the selected
   matrix, checks/caches its inverse, and supplies both to Canvas. An invalid or
   absent selected matrix uses the ordinary bitmap path. vdp-gl
   `canvas.cpp:623`, `Canvas::drawTransformedBitmap`, has a fallback inverse
   calculation, but Context has already supplied the inverse in this route.

Consequently, the fixture's warmed `cached-affine` row reuses its inverse.
`rebuilt-affine` includes matrix rebuild plus the subsequent lazy inverse and
draw. `matrix-only` includes the identity and six-value rebuild but no draw or
inverse generation inside its repeated body. All timed batches share one final
marker pixel and completion fence; the matrix-only interval is not a measurement
of matrix arithmetic alone.

## Direct transformed bitmap plotting

vdp-gl `displaycontroller.cpp:1749`, `drawBitmapWithTransform`, transforms four
source corners, truncates their floating coordinates to signed integers, adds
plot position and graphics origin, and intersects the bounds with the graphics
clip rectangle. Its native-format transformed path is commented out. The real
Rally source images used here are RGBA2222.

`displaycontroller.h:2823`,
`genericRawDrawTransformedBitmap_RGBA2222`, walks destination pixels with
`x < X2` and `y < Y2`, even though the surrounding rectangle representation uses
inclusive limits. Each visited pixel uses a full 3-by-3-by-1 floating multiply
through the inverse matrix, checks source floating bounds, truncates source
coordinates, and reads the source byte. Alpha-zero bytes skip the pixel setter;
the current artwork uses alpha values 0 and 3. This is not a general alpha-blend
benchmark.

The VGA64 route in `dispdrivers/vga64controller.cpp:658` obtains its setter from
`setRowPixelLambda(PaintMode)` at line 116. Its `std::function` dispatch remains
in the host extraction. A direct-store arithmetic kernel would be a separately
labelled experiment, not an equivalent extraction of this complete path.

## Command 40 followed by ordinary plotting

VDP `video/vdu_buffered.h:2048`,
`VDUStreamProcessor::bufferTransformBitmap`, takes a destination buffer ID,
options, matrix ID and actual 16-bit source bitmap key. Rally short bitmap ID
`N` therefore becomes source key `64000+N` here. Confusing that key with the
short selector would transform the wrong or a missing bitmap.

The fixture uses natural options 5 (`RESIZE|TRANSLATE`). The function transforms
the corners, obtains dimensions `max-min+1`, and uses the minimum coordinates as
its translation offset. This differs from the direct path's exclusive maximum
edges. The fixture retains each path's natural footprint and plots the command-40
result at the original position plus the minimum offset; it does not force equal
dimensions between the paths.

Each command-40 invocation allocates an output RGBA2222 buffer and loops over
every output pixel using the inverse transform. Out-of-source samples become
transparent zero; valid samples pass through `Bitmap::getPixel2222`. It replaces
the destination buffer and creates its bitmap after producing those pixels.
The fixture then issues an ordinary plot, adding another bitmap traversal.
`displaycontroller.cpp:367`, `Bitmap::getPixel2222`, supports the RGBA2222 and
RGBA8888 source cases, but returns transparent for unsupported native-format
source data. Native-converted images are therefore not substituted here.

The `ordinary-sized` control prepares this command-40 output once before timing.
`transform40-plot` repeats output allocation/replacement and plotting within every
operation. Both use original artwork uploaded once; neither loads pre-scaled
files nor uploads scaled pixels during its timed batch.

## Host extraction and target authority

The host harness preserves the source bounds, raster loops, clipping, alpha
branches, VGA64 address mapping and setter dispatch. It uses the exact official
ANSI multiply routine from ESP-DSP 1.8.0, compiled for the Pi5. The installed
firmware SDK DSP library is archive-only; its historical `Mat::inverse` source
was not recovered. The host inverse is an explicitly labelled analytic model
for these diagonal affine cases. Host allocations are ordinary vectors, not
ESP32 PSRAM or the complete VDP buffer service. No firmware-faithful cold-inverse
or matrix-service timing follows from those host numbers. See the manifest's
shims and [stock/SMOKE.json](stock/SMOKE.json).

The standalone command application exercises the actual firmware matrix service,
inverse, allocation, buffered dispatch and drawing. Its mode-136 batches perform
no swaps, and completed raster commands are fenced before their clock interval
ends. This measures ordered drawing completion rather than physical scanout.
See [target/README.md](target/README.md) for the repeated operations, controls,
clocks, output files and remaining limitations.

## Explicit feature enable and preserved first smoke

VDP `video/vdu_sys.h:262` and buffered affine/matrix/bitmap dispatch are gated by
`TESTFLAG_AFFINE_TRANSFORM`, defined as variable 1 in `video/agon.h`. The original
game explicitly enables it with `23,0,248,1,0,1,0` in `loadCars()`. The first target
build omitted that command. Its completion/marker checks passed, but those checks
alone do not establish execution of the intended transforms. Its timings are
excluded by [TARGET-QUALIFICATION-smoke01.json](TARGET-QUALIFICATION-smoke01.json).

All original first-build sources, build receipts and three fixture sets are
preserved in
[preparation/TARGET-ATTEMPT01-MISSING-AFFINE-ENABLE.zip](preparation/TARGET-ATTEMPT01-MISSING-AFFINE-ENABLE.zip),
with a separate SHA manifest. The original smoke profile and raw receipts are
unchanged. The corrected shared guest explicitly enables affine commands before
artwork/matrix setup; its SHA256 is
`c85b0fad6c24862b42daece1dc695f4eea38b2935cd8b5316482f8e4ff8a50ba`.
Fresh corrected runs require their own independent qualification.
