# R19-08 accepted vehicle computation précis

Read-only preparation while R19-07 tests run. R19-08 remains open in root TODO;
this is not an implementation or separate task list. Authoritative sources are
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
