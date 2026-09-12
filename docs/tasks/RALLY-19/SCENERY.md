# R19-09 scenery integration précis

R19-08 is complete. R19-09 remains in the root TODO execution register; its
MatFloor prerequisite is qualified, but no scenery kernel is implemented yet.
The accepted oracle is949f618 under `.work/oracle`. Authoritative files are
`include/scenery.hpp`, `include/scenery_data.hpp`, `include/scene.hpp`, and
`src/main.cpp::loadScenery/drawScenery`. Keep the accepted artwork and behaviour.

## Accepted heading and history

Unlike vehicle yaw, the scenery tangent retains sub-world-unit progress:
`pQ8=(position/100)*256+(position%100)*256/100`. It uses trackSample(pQ8),
not the whole-world vehicle camera tangent. For tangent x,y:

```text
ax=abs(x); ay=abs(y)
if ax==0 && ay==0: offset=0
else:
    angle = ax>=ay ? HeadingAtan[ay*256/ax] : 256-HeadingAtan[ax*256/ay]
    if x<0: angle=512-angle
    if y<0: angle=1024-angle
    offset=angle&1023
```

HeadingAtan is the unchanged257-byte table in scenery_data.hpp. Both divisions
floor nonnegative integers. This is a1024-unit panorama bearing, separate from
the256-unit steering convention. No per-frame general trig is necessary.

SceneryHistory owns two offsets and two valid flags, initially0/false, with
slot0. For each accepted render, consult the current draw slot:

```text
delta=(offset-oldOffset+1536)%1024-512
full=(!valid || delta>255 || delta< -255)
oldOffset=offset; valid=true
full:  delta=0, left=0, right=319, repaint=true
zero:  delta=0, left=0, right=0, repaint=false
delta>0: left=320-delta, right=319, repaint=true
delta<0: left=0, right=-delta-1, repaint=true
```

The oracle toggles slot after the buffer swap. A resident implementation must
preserve this association, including initial redraw of both pages and explicit
reset/reload. Rejected staging packets must not advance history. Do not confuse
the parser GP echo with a completed raster or let malformed input toggle a page.

## Accepted graphics commands

loadScenery uploads packed SceneryPixels into63800, uses stock command72 option4
with the embedded SceneryPalette to create bitmap100 (buffer64100), then binds
it as1024 by RoadTop104 RGBA2222. Source63800 is cleared after conversion.

drawScenery first resets affine selection65535. A nonzero delta sets viewport
0,0..319,103 and calls scroll extent2, direction1 for positive delta or0 for
negative, amount abs(delta). This is the existing stock screen-scroll
optimization; do not replace it with per-frame full-panorama uploads.

For repaint, clip to left,0..right,103. Draw bitmap100 at(-offset,0) if
1024-offset>left, and at(1024-offset,0) if1024-offset<=right. When no repaint is
needed or delta is nonzero, additionally repair rows88..103 across the full
width: draw at(-offset,0), plus the wrapped copy if offset>704. This repairs
foreground/traffic overdraw on the retained sky, including a static heading.
Finally restore the full viewport0,0..319,239 before foreground geometry.

Locally checked agondev source encodes the viewport as VDU24 plus four LE16
coordinates. Screen extent scroll is VDU23,7,extent,direction,amount (five bytes).
R19-08's typed DrawBitmap already supports external bitmap100 and signed x,
with explicit affine reset. Typed viewport/scroll intrinsics still need compiler
validation and native proof before integration. Resource ownership excludes
the existing63800..64100 reservation from Golem allocation/cleanup.

## Construction cautions, not qualified implementation

The admitted road already exports interval and fraction14 in output1020 at
offsets0/4. Fraction14 is0..16381 and preserves exactly the accepted hundredths
toQ8 conversion. Vehicle tangent Asset1900 contains unchanged
(tx,ty,nextTx-tx,nextTy-ty) records. These static data can support scenery, but
the current vpComputeHeading intentionally uses whole-world fractions and must
not simply be reused unchanged.

Accepted tangent interpolation floors the signed delta product *before* adding
the integer base tangent. Fraction14 introduces1/16384 fractions: unlike the
vehicle1/64 fractions, these can be lost by the32768 bias in StoreI16Floor.
Even adding the base tangent before flooring can round a nearly integral result.
Qualify a genuine signed-floor construction on the delta product before adding
the base. Do not falsely narrow or quantize the fraction to get a passing image.

The ratio uses a variable nonzero major component, not DivModPositive's constant
divisor. A bounded reciprocal followed by exact remainder correction is a
possible construction; prove/qualify its error and bound the denominator before
inversion. A finite integer quotient search is another fallback. Neither is
implemented or accepted yet. Preserve the zero-vector case explicitly.

R19-09 must also integrate the accepted simulation/input/demo/settings/HUD path
with the resident state protocol. The current vehicle visual loader is a
diagnostic fixture, not the game frontend. Static payload ledgers omit stock
cached inverse chunks and allocator metadata; later heap/stability tests remain
necessary. Full-scene timing belongs to R19-10 at normal CPU/UART settings.

## Qualified floor and proposed exact interpolation construction

Golem f856fa2d0e0465d0586b16f7086a3377b046772f adds MatFloor. All236 native
full-record tests pass for binary32 integer neighbours,1/16384 fractions,
signed zero/subnormals, byte carries and source preservation. Host tests check
every integer boundary0..16777215 and adjacent binary32 values with both signs;
the full sanitizer/golden/negative suite passes. See evidence/golem-floor.
This is a primitive checkpoint, not scenery integration.

Static tangent data bounds are oval DX[-624,624], DY[-408,480]; Fuji
DX[-1005,432], DY[-395,1215]. Fuji's largest delta*fraction product is19902915,
above exact binary32 integers. Applying MatFloor after that rounded product
would be too late. The following proposed decomposition avoids that product:

```text
h=fraction14/64; l=fraction14%64       // h0..255, l0..63
biased=delta*h+262144                 //5869..571969 for common delta[-1005,1215]
q=biased/256; r=biased%256            // integer DivModPositive, r0..255
correction=floor((r*64+delta*l)/16384)
interpolated=base+(q-1024)+correction
```

All integer products/sums fit binary32 exactly. The final numerator is
[-63315,92865]; dividing by16384 preserves its fraction at magnitude<6.
MatFloor then produces[-4,5]. The broad resulting component interval is
[-5124,5311], containing the tighter mathematical convex-interpolation bound
[-4096,4096]. A checked narrowing copy can validate that bound before absolute
value/reciprocal use. One common delta/base helper can serve x and y without
duplicating its compiler temporaries. This construction still needs native
integration and exhaustive host comparison with accepted trackSample.

For each record, max(abs(baseX)-abs(deltaX),abs(baseY)-abs(deltaY)) lower-bounds
the major absolute tangent over the full interpolation interval. The minimum
is2441 on the oval and2501 on Fuji. Thus a checked denominator range2048..4096
is conservative for both complete tracks. Preserve a default zero heading on
the unreachable zero-vector path; do not evaluate a zero reciprocal.

This tight denominator also bounds the atan ratio construction without a new
general divider: numerator<=4096*256=1048576 and reciprocal<=1/2048 give an
initial quotient bound0..512. Correct the floored estimate against exact
products q*major and(q+1)*major, each<=513*4096=2101248. Decrement when the first
exceeds the numerator; increment when the second does not. Finally validate
the expected0..256 table index. Prove the reciprocal's error is within one
integer and test the construction before relying on this proposal. No per-frame
ratio or bearing should be supplied by the eZ80.
