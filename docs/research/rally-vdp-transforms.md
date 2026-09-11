# Rally VDP matrix notes

References checked September 11, 2026:

- https://agonplatform.github.io/agon-docs/vdp/Buffered-Commands-API/
- https://agonplatform.github.io/agon-docs/vdp/System-Commands/
- Local upstream `agon-vdp/video/context/graphics.h`, `Context::drawBitmap`.

Enable affine transforms with `VDU 23,0,&F8,1;1;`. Buffered command 32
creates a 3×3 affine matrix; operation 0 resets it to identity, operation 5
scales, operation 6 translates, operation 11 accepts the first six row-major
coefficients. Format &C0 means signed 16-bit integers, zero fractional bits;
&C8 means signed 8.8 fixed point. The VDP converts inputs to floats internally.
Explicit byte encoding avoids CPU floating-point conversion and SDK signed-scale
conversion issues. Reset before rebuilding to avoid accumulating operations.

`VDU 23,0,&96,1,id;` selects the matrix for bitmap drawing. Set id=65535
to disable it; flags=0 does not clear the prior matrix. Transform origin is the
bitmap's top left, relative to its draw position. The VDP caches the inverse.

Current player uses five uploaded 102×77 images, preserving startup CPU nearest
neighbor enlargement. Matrix buffer 63984 holds [-1,0,101; 0,1,0; 0,0,1],
reflecting the full canvas while preserving its anchor. Source buffers are
64000–64004. Right steering selects reflection; left and center draw normally.
Reset transform immediately after the car to avoid affecting subsequent assets.

For future distance-scaled cars/signs: combine positive scale and anchor
translation in a matrix, keeping source pixels loaded. A horizontal reflection
uses negative X scale and a compensating translation. Quantize/cache distance
scales and profile VDP draw time on hardware: reduced UART traffic does not mean
free rasterization. Buffered command 40 can instead bake reusable transformed
RGBA2222 bitmaps (VDP 2.10+), trading bitmap RAM for repeated draw speed.
Draw-time affine APIs date from VDP 2.9 and require their feature flag.
Traffic now uses draw-time Q8 scale/reflection matrices in buffers 63970–63975.
Each matrix is reset before replacing its six coefficients. Source bitmaps are
shared by view within each livery; thirty-five source buffers span 64000–64034.
Roadsign scaling remains future work.

## VDP-side livery generation

Buffered command 72 supports 8-bit to 8-bit lookup mapping: options 0x10
selects 8-bit pixels (low three bits zero) and a mapping buffer. Wire command:
`23,0,0xA0,destination;72,0x10,source;map;`. A 256-byte single-block table
contains exact RGBA2222 results including alpha. Source images 64000–64004
remain unchanged. Each opponent destination 64005–64034 is expanded, then
registered as a bitmap explicitly; expansion alone does not register it.
Scratch map 63960 is reused across liveries and cleared after all expansions.
Commands execute in order, so a table is consumed before it is replaced.
Five 102×77 uploads plus six maps total 40,806 payload bytes; rendered bitmap
RAM remains 274,890 bytes. This needs firmware implementing command 72.
