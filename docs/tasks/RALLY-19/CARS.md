# R19-08 accepted vehicle computation précis

Reference and implementation progress for R19-08, which remains open in root
TODO; this is not a separate task list. Authoritative oracle sources are
accepted949f618's `scene.hpp`, `traffic.hpp`, `vehicle.hpp`, `road.hpp` and
`src/main.cpp`, preserved under `.work/oracle`. Optional perspective is OFF in
the frozen target; do not substitute perspective-aware yaw.

For each of six original opponent indices0..5, distance is
`(car.position-player.position+lap)%lap` in hundredths of a world unit. Ordering
starts0..5 and runs exactly the nested15 pairs `(i,j)` with i0..4 and j=i+1..5,
swapping order entries when distance[order[i]]<distance[order[j]]. This draws far
to near. It is not a stable sort: indirect swaps can reverse equal-distance cars.
Preserve the exact algorithm for deterministic overlap, including ties.

For each sorted index:

```text
z = distance / 100                         // integer floor, nonnegative
visible iff 64 <= z <= 1100
q = 8000 / z                              // integer floor, q7..125
y = 96 + q
centre = trunc(road.centerQ8At(y)/256) + trunc(lane*q/50)
scale = q*2                               // signed Q8 matrix coefficients below
camera = trackSample((player.position/100)*256)
heading = trackSample((car.position/100)*256)
cross = trunc((camera.tx*heading.ty-camera.ty*heading.tx)/4096)
view = abs(cross)<264 ? 0 : <787 ? 1 : <1297 ? 2 : <1785 ? 3 : 4
mirror = cross > 0
bitmap = (originalIndex+1)*5 + view
matrix.xx = mirror ? -scale : scale
matrix.yy = scale
matrix.translationX = mirror ? 101*scale : 0
x = centre - (51*scale)/256
drawY = y - (70*scale)/256
```

Both heading samples deliberately discard sub-world-unit position. The road
coefficient evaluator retains fractional position. Track tangent interpolation
uses signed `>>14` (floor toward negative infinity), whereas cross/lane/centre
divisions truncate toward zero. These distinctions must not be silently replaced
by nearest rounding. The existing road endpoint trace rounds half away from zero
for road triangles; traffic and player placement need the unrounded centreQ8
evaluation followed by truncation. Traffic can request row103, already supported
by the qualified projection kernel.

The player contact row is214 (q118):

```text
playerCentre = trunc(road.centerQ8At(214)/256) + trunc(lateralQ8*118/12800)
playerView = min(4, (abs(steering)*4+10)/21)
playerMirror = steering > 0
playerX = playerCentre - (playerMirror ? 50 : 51)
playerDrawY = 154
```

The existing five64x48 source views become102x77 RGBA2222 bitmaps by the accepted
nearest-neighbour enlargement. Reflection is x'=101-x, which moves the straight
rear-tyre centre from51 to50. Opponents use their original livery index; preserve
all six palette maps, tyres, hubs, wings, helmets, visor and alpha. The accepted
bootstrap creates the additional liveries using stock buffered command72, not
another35 UART image uploads. `traffic.hpp::carColour` is authoritative.

`main.cpp::trafficMatrix` resets a3x3 affine matrix and loads its first six entries
as signed Q8, then selects the bitmap, uses that matrix and draws at x/drawY.
The final affine selection is reset to65535. Player drawing similarly selects
the existing mirror matrix or65535, then resets selection. The accepted scene
restores the graphics viewport to0,0..319,239 before road/vehicles; HUD is excluded
below224 by the frozen visual metric. Do not invent a new vehicle clipping rule.

The production admission fields already carry all six raw position/lane pairs,
player lateral/steering and the selected track. R19-07's admitted road preserves
them. Future vehicle work must keep original object identity through sorting,
bound depth before division, derive every geometry/matrix/bitmap selection on
VDP and produce its own per-car diagnostics/masks. Generic signed storage,
comparison and bitmap-command intrinsics may be needed in the existing C++
compiler; qualify them before relying on an assumed conversion or cache behavior.

## Numeric reference preparation

`vehicle_reference.py` reuses the existing accepted `host_fixture.cpp` with host
ASan/UBSan. Its66 original outputs match the frozen native guest scene CSV files
byte for byte. It adds90 host-only cases: every steering tick-21..21 on both
tracks with signed lateral extremes, depth visibility boundaries6399/6400/6499/
110099/110100 hundredths and a behind-player case, plus indirect equal-distance
sort ties. The added cases still need native candidate qualification; this is
reference preparation, not R19-08 completion.

`evidence/golem-cars/reference.json` records all156 expected player placements,
ordered visible opponent identities/bitmap/scale/reflection/coordinates, source
hashes and raw80-byte admitted states. Its `admitted()` helper round-trips all17
frozen input words and supplies raw states only. No projected geometry, heading
or depth is transmitted. Use these inputs for numeric kernel probes; retain the
original66 native images/masks for final scene comparisons.

The saved hex records use the global fixture index as a diagnostic sequence.
A selected-track run must call `admitted(case,sequence)` with its own contiguous
sequence starting at0; do not replay those global-index hex records unchanged.
The sorting probe does this and verifies the complete active/admission readback.

## Qualified distance/order implementation

Golem1bbf6dc adds StorePositive32Floor, MatAbs, LessThan and large-divisor/s32
remainder DivModPositive. Native primitive proof passes576 complete output records;
host sanitizer/golden/negative tests pass. Both R19-07 road byte streams remain
identical. See `evidence/golem-vehicle-math/qualification.json` and its raw runs.
The first576-case batch was rejected by the existing512-case loader cap; two288
case batches pass, preserving that cap and the failed attempt.

`build_vehicle_sort.py` appends resident distance wrapping and the original15-pair
sort to the admitted full-road job. `car-player+lap` stays positive and below2^24;
its quotient is0/1 and the wrapped distance fits3276799. One shared comparator
uses ordered zero-extended bytes and avoids the0xffff sentinel. Full records move
through every swap. The tie fixture's order is5,2,3,1,4,0, not a stable sort.

All156 native fixtures pass (69 oval,87 Fuji), including complete admission state
and every ordered position/distance/lane/ID. The host-reference visible order is
cross-checked too. Source/protocol/runtime identities and readback are retained in
`evidence/golem-vehicle-sort/initial-oval` and `initial-fuji`. The native probe keeps
the road active in mode136 with pixel coordinates, but does not draw cars yet.

Vehicle math/working buffers are1700/1701;1702 holds six12-byte sorted records
(`s32 position, s32 distance, s16 lane, u16 originalID`);1703 is the swap temporary.
Matrices1800..1804 compute the distance; programs2800/2801 are the shared distance/
comparison jobs,2802 rebuilds and sorts all six records,2810..2824 swap fixed pairs.
The traced admitted road+sort uses759/783 IDs and62847/180711 resident payload bytes
(oval/Fuji). R19-08 remains open: actual projection/bitmap drawing is still absent.

```sh
.venv/bin/python docs/tasks/RALLY-19/probe_vehicle_sort.py initial-oval
.venv/bin/python docs/tasks/RALLY-19/probe_vehicle_sort.py initial-fuji --track fuji
```

Use fresh names when reproducing. Every emulator remains headless; these numeric
checks do not qualify full-scene images, timing, long-term memory or hardware.

## Projection integration considerations (recorded before implementation)

Camera/opponent headings discard sub-world-unit position, so tangent interpolation
can use local whole-world units0..63 and divide by64 instead of multiplying by
a Q14 fraction. This preserves the accepted signed-floor interpolation with
smaller exact integer products. It does not apply to road projection or scenery,
which retain fractional position. Bounds on compiler fields must honestly contain
the intermediate arithmetic; do not narrow declarations merely to silence a
range check. A scalar absolute-value operation and typed bitmap/affine selection
are useful here; MatAbs is now qualified, bitmap/affine selection is still pending.
Avoid introducing a
general renderer or replacing Golem with host-generated command bytes.

For projection, select a sorted12-byte record with the already-qualified
LoadElement. The existing road row evaluator supports103..224, but its unrounded
pixel-centre matrix1202 must be copied into a bounded ordinary field *inside* the
row job before returning: Call invalidates mutable matrix bounds. The car path
then truncates that value toward zero instead of using rounded road endpoints.
Keep the R19-07 generators unchanged; extend the generated source in an opt-in
vehicle builder so earlier proof streams remain reproducible.

Clipping must precede reciprocal evaluation. RequireRange/CallIf currently guard
execution but do not narrow a field's compiler range. Thus z declared0..32767
cannot simply be loaded into an invertible matrix after a64..1100 guard. A small
checked fixed-type copy into an initialized64..1100 destination, retaining the
old destination and returning status0 on failure, is a possible reusable solution.
Qualify it rather than falsely narrowing the broad source declaration. The
existing diagonal3x3 InvertAffine+MatExtract path can then compute8000/z.

Heading source data can be compact unchanged `(tx,ty,nextTx-tx,nextTy-ty)` records
from the accepted TrackPoint arrays. Whole-world local interpolation uses0..63
and divisor64; its1/64 fractions remain exact through the signed floor store.
Lane and player lateral divisions must retain truncation toward zero. Actual
tangent components stay within[-4096,4096], making each determinant product exact
in binary32; a determinant exceeding2^24 may round by one, but that is already
beyond the largest yaw threshold1785 after division by4096, where view4 saturates.
Validate the actual view/handedness and frozen positions rather than requiring
irrelevant exactness in a saturated internal cross-product diagnostic.

## Qualified numeric projection checkpoint

Golem c1bdb577 adds CopyChecked and opt-in SharedWordScratch. Checked clipping
passes1110 native inputs, including all1037 valid integer depths64..1100; nested
shared/isolation tests pass330 full records. The compiler's full host sanitizer/
golden/negative suite passes. See evidence/golem-vehicle-clip and
evidence/golem-shared-scratch; each records the exact compiler source hashes used.
The clipping runs preceded the sharing change, whose subsequent full projection
runs exercise the same guarded reciprocal on the final compiler source.

`build_vehicle_projection.py` extends the admitted road+sort generator. It
statically repacks unchanged track tangents as `(tx,ty,deltaTx,deltaTy)` records
in Asset1900, selects them on VDP, and evaluates whole-world interpolation with
signed floor. It projects each sorted record only after CopyChecked admits its
depth. It exports the unrounded road pixel centre before the row Call returns,
then performs the accepted truncation, scale, yaw/view and reflection equations.
The final player projection uses the same road evaluator at row214. Per-frame
input remains the original80-byte raw state; no projected car data is supplied.

`probe_vehicle_projection.py` passes all156 native fixtures (69 oval,87 Fuji).
Every284-byte readback matches the accepted reference: complete admission state,
all six ordered records, all six projected slots, player coordinates/view/mirror,
and selection/visibility/count flags. All43 steering values per track, signed
lateral extremes, depth boundaries, lap wraps and equal-distance ordering are
included. The66 original references were previously matched to native oracle
scene diagnostics; the90 supplemental references came from the sanitized host
oracle. Numeric results are exact, rather than relying on the1px image tolerance.

Storage:1710 work,1711 four status/count words,1712 checked depth,1713 selected
12-byte car,1714 six16-byte output slots,1715 shared current slot,1716 player
12-byte record,1717 exported road float,1718 integer temporaries,1719 thresholds,
1720 signed zero. Each output slot is `(u16 visible,ID,bitmap,scale,mirror;
s16 x,y; u16 translation)`. Invisible slots keep their original ID and canonical
zero/default values; they are never drawn. Player storage is `(u16 bitmap,mirror;
s16 x,y,centre; u16 reserved)`. Matrices1810..1819 and1890..1893 support programs
2850..2861. Ordinary fields preserve values across Call; mutable matrix bounds
are deliberately reloaded. Bitmap drawing is not yet present in this checkpoint.

An initial broad player-centre bound correctly failed compilation; the exact
containing sum is[-4450,4449]. The first unshared full projection compiled at1022
IDs on the oval but exceeded the1024-ID cap on Fuji. Failed source/log evidence is
retained under evidence/golem-vehicle-projection/{bound-failure,resource-failure}.
Explicit sharing of short-lived conversion triples reduces ownership to848/867
IDs. Resident payload is69140/190294 bytes and bootstrap81338/202758 bytes. Both
remain within frozen ceilings; these are payload ledgers, not whole-VDP heap or
timing measurements. Qualification is in that directory's qualification.json.

Next within R19-08: typed bitmap/affine selection, original five views and VDP
colour mapping, native images with per-car material/occlusion comparisons.
All later frontend/performance/stability criteria remain open. Use fresh names:

```sh
.venv/bin/python docs/tasks/RALLY-19/probe_shared_scratch.py nested-initial
.venv/bin/python docs/tasks/RALLY-19/probe_vehicle_projection.py shared-initial-oval
.venv/bin/python docs/tasks/RALLY-19/probe_vehicle_projection.py shared-initial-fuji --track fuji
```
