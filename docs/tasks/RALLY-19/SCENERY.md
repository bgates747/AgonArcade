# R19-09 scenery integration précis

R19-08 is complete. R19-09 remains open in the root TODO execution register.
MatFloor, shared scalar conversion scratch and the numeric heading kernel are
qualified. Scenery drawing/history and
the interactive frontend are not yet integrated.
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

## Initial construction cautions (historical; results below)

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

## Qualified floor and initially proposed interpolation construction

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

## Exhaustive host result and first resident heading construction

The subsequent proof_scenery.py run `fraction-and-direct` checks all3,852,800
reachable hundredth-positions (7,705,600 tangent components). Both the proposed
split construction and the cheaper direct product, scale1/16384, MatFloor,
then integer-base addition match accepted trackSample exactly at every position.
Although some Fuji products lose integer precision, none cross a floor boundary
in the frozen reachable domain. This corrects the earlier conservative concern:
splitting is not necessary for these exact track data. The native road's
floor(float(local)*2.56) fraction also matches the accepted fraction everywhere.

The corrected atan ratio and final heading match the oracle throughout. There
are no overestimates and62 Fuji underestimates; at position533719, tangent
(3904,1220) gives estimate79 where the exact table index is80. Actual major
minima are2890/2858 (oval/Fuji), inside the conservative2048..4096 guard.
This is exhaustive host evidence, not yet native scenery qualification.

build_scenery_heading.py therefore uses the cheaper direct interpolation and
only the necessary upward quotient correction. It refuses generation unless
the proof and all source hashes match, with zero direct-product mismatches and
zero overestimates for the selected frozen track. This data-specific proof must
be rerun before adapting the construction to changed track data. Pinned stock
userspace-platform/matrix/mat.cpp::inverse computes adjoint/determinant; for the
diagonal(major,1,1) matrix, its first entry is the single binary32 division1/major.

The first complete road/car+numeric-heading program compiles the oval at1018
owned IDs; Fuji exceeds the frozen1024 limit. No native heading test or scenery
draw has run yet. The failed source/log is preserved in
evidence/golem-scenery-heading/resource-failure. Next, qualify optional reuse of
the short-lived32-bit conversion triple, analogous to SharedWordScratch, instead
of raising the cap. This also leaves room for history/scroll/frontend work.

Current proposed storage:1730 work/diagnostics,1731 signed tangents,1732 seven
status words,1733 bounded major,1734 checked atan index,1735 selected atan byte,
1736 wrap constant; immutable atan Asset1902. Programs3000..3008 reuse existing
vpM0..9 and vpInverse after vehicle drawing for this numeric-only checkpoint.
The eventual scene order must prepare the road's interval/fraction first, draw
scenery next, then road/vehicles; the current appended heading calculation is
only a proof harness, not the final ordering.

## Qualified shared scalar scratch

Golem cd0ae0c adds opt-in SharedScalarScratch, preserving default and word-only
lowering. All672 native records (224 each isolated/word/scalar) and host
sanitizer/golden/negative tests pass. See evidence/golem-shared-scalar. The first
probe failed compilation for missing explicit Copy byte counts; no emulator ran
for that failed source. Corrected typed copies pass with signed zero/subnormals,
wide carries, nested calls, repeated conversions and neighbour preservation.

Using that directive reduces the complete road/car+numeric-heading program by42
IDs. Current oval/Fuji compilation:976/995 IDs,75825/196979 resident payload,
89867/211287 bootstrap bytes. No resource ceiling was raised. These figures are
not native heap or performance acceptance.

The first scenery-heading loader omitted the artwork forward declaration and
failed to build; retained smoke-oval/build.txt records it. Declaring artwork
correctly produced two exact native oval records. Broader interval and correction
witness coverage is in progress; no scenery-image claim yet.

## Viewport ordering question for the next native graphics probe

Read-only source inspection found a detail that needs direct qualification:
agondev/src/lib/libvdp/vdp_set_graphics_viewport.c sends its arguments unchanged
as left,bottom,right,top. Pinned console8/video/vdu.h reads that wire order and
passes left,top/right,bottom through toScreenCoordinates. In pixel mode,
context/viewport.h::scale preserves Y, and setGraphicsViewport rejects reversed
corners. The accepted main.cpp calls vdp_set_graphics_viewport(left,0,right,103).
Those calls appear reversed for this source path. Do not silently assume the
named helper or apparent rectangle order proves clipping happened. Before
integrating scroll, compare exact emitted bytes and native clipped drawing,
including the accepted order and the opposite Y order, one-pixel regions, and
full-view restoration. Preserve the oracle; any behavioral difference must be
documented before choosing a candidate mapping. This is a source-level concern,
not yet an observed native failure or permission to rewrite the accepted game.

The six-image native `golem-viewport-order/initial` probe now confirms the concern.
After VDU26 restores the full viewport, accepted order(20,30,39,49) allows all
76800 red pixels through; correct wire order(20,49,39,30) clips to exactly400
pixels in x20..39,y30..49. The accepted full-view call(0,0,319,239) also fails to
restore a previously valid small viewport. Correct ordering permits a one-pixel
width, producing20 pixels; accepted ordering again leaves the full screen.

Consequently the accepted scenery path's apparent viewport optimizations are
not operating as described by its intent on this pinned native runtime. Preserve
all original captures and source. The resident construction should use explicit
pixel-coordinate GraphicsViewport(left,top,right,bottom), emitting native wire
left,bottom,right,top, and restore the viewport correctly. This is an intentional
implementation correction within the offload/optimization task, not a changed
visual oracle: it must pass the frozen full-scene and sequential-history images
against original behavior. In particular, narrower clipping must not leave old
car/road pixels in the sky. Keep the full-panorama fallback available if the
accepted output cannot be maintained by the intended strip/repair construction.
No performance saving is established by the clipping probe alone.

## Numeric heading checkpoint qualified

All773 complete native183-byte records pass:165 oval,608 Fuji. These comprise
the156 existing vehicle poses, every track interval midpoint with fractional
progress, and axis/equal-component/reciprocal-correction witnesses plus adjacent
positions. All tangents, ratio intermediates, seven status words and final
bearings match the accepted trackSample/sceneryHeading host reference and the
exhaustively proved binary32 construction. Road and all car jobs remain active;
the unchanged original artwork is bootstrapped. Only the production80-byte state
is updated per call; diagnostic readback is excluded from scene-UART claims.

`evidence/golem-scenery-heading/qualification.json` audits actual readback bytes,
all fixture names, source/compiler identities, unchanged runtime inputs and
resource limits. The initial audit compared the whole before/after inventory,
which includes new guest results/exit files after execution; inspection confirmed
zero changed inputs, and the audit now checks all pre-run entries remain exact.
Golem implementation is cd0ae0c907692cfc1a45fc153910f633caa2ada6.

Reproduce from the execution root with new run names:

```sh
.venv/bin/python docs/tasks/RALLY-19/probe_scenery_heading.py NEW-oval --track oval
.venv/bin/python docs/tasks/RALLY-19/probe_scenery_heading.py NEW-fuji-a --track fuji --offset 0 --limit 384
.venv/bin/python docs/tasks/RALLY-19/probe_scenery_heading.py NEW-fuji-b --track fuji --offset 384 --limit 384
```

Existing evidence must never be overwritten.
The current qualification audit binds the named frozen runs and source hashes.

R19-09 remains unchecked. Next qualify typed viewport/scroll drawing, implement
both retained-page histories, compare full-scene and sequential scrolling images,
then integrate the accepted input/simulation/demo/HUD frontend. Numeric heading
does not establish full-scene performance, retained-image correctness or stability.

## Viewport/scroll primitive work in progress

The first typed graphics probe exposed two more harness/runtime details. The
direct-reference branch initially omitted Golem's stock affine feature flag;
affine-reset bytes then produced a64-pixel text artifact. Adding the same flag
gives exact candidate/reference smoke images, but inspecting those images shows
that correct VDU24 ordering alone still does not clip raw bitmap draws. VDU24
updates Context::graphicsViewport; raw Context::drawBitmap uses the Canvas clip
left by the previous PLOT. Context::plot always calls setGraphicsOptions, which
synchronizes the clip even for a non-drawing PLOT4 move.

The proposed typed GraphicsViewport therefore emits VDU24 in correct wire order
followed by absolute PLOT4(0,0), explicitly updating the graphics cursor stack as
a documented side effect. It must be tested with an independent outside-region
pixel assertion, not merely against an equally unclipped reference. Both direct
reference and compiler candidate will use that synchronization and correct full
restoration. Earlier captures remain preserved as failed/insufficient evidence.

The broad initial reference probe also exited by SIGSEGV at the transition to
the255-pixel downward-scroll case in a60-pixel-high region. This was not a timeout.
Pinned displaycontroller.h::genericVScroll fills `scroll` rows without clamping
to region height; at Y30,255 rows can exceed the240-row framebuffer. This source
path explains the likely crash, though no upstream code was changed. Scroll's
caller precondition is now explicit: amount must not exceed the current region's
size along the selected axis. Test valid edge values including equality, all four
directions, one-pixel extents, and255 horizontally in a320-wide viewport. Rally's
horizontal0..255 movement across a320-wide panorama satisfies that precondition.
Out-of-region crash evidence stays archived; it is not a supported scroll case
or a reason to expand this goal into firmware repair.

## Viewport/scroll checkpoint qualified

All30 valid native image pairs pass with correct viewport Y order and PLOT4
synchronization. The audit independently checks every outside-region pixel,
nonempty drawing/scroll fill within the region, the restored-view marker and
all original image/source/runtime hashes. It covers all four directions,
zero and equal-axis-size moves, one-pixel regions, and255 horizontally in width320.
The full host sanitizer/golden/negative suite passes with the new viewport target.
Evidence is in `evidence/golem-viewport/qualification.json`, valid-0 through
valid-3. Golem commit is recorded in this checkpoint's development log.

Reproduction uses fresh names, from the execution root:

```sh
.venv/bin/python docs/tasks/RALLY-19/probe_viewport.py NEW-0 --offset 0 --limit 8
.venv/bin/python docs/tasks/RALLY-19/probe_viewport.py NEW-1 --offset 8 --limit 8
.venv/bin/python docs/tasks/RALLY-19/probe_viewport.py NEW-2 --offset 16 --limit 8
.venv/bin/python docs/tasks/RALLY-19/probe_viewport.py NEW-3 --offset 24 --limit 8
```

The accepted game and its frozen images remain untouched. History/scenery
integration and visual comparison are next; R19-09 is still unchecked.
