# Vehicle placement and orientation

This is implementation evidence for the accepted RALLY-18 contract. All code
and generated tables are in this bucket. The existing motion, grip, surface,
traffic and car artwork inputs are unchanged.

## Placement calibration

1. The existing startup enlargement samples the 64×48 source into a 102×77
   bitmap with `source[x*64/102, y*48/77]`. Inspection of the source image,
   generated pixels and Blender model agrees that the unmirrored source poses
   face left as their positive Blender yaw increases. The control path therefore
   keeps positive steering/cross products mirrored, exactly as before.
2. In the straight rear view, the black rear tyre pixels occupy local x=23..35
   and x=67..79 near the bottom. The last black row is **59**. Their horizontal
   pixel-centre midpoint is **51** and their outside radius is **28 pixels**.
   The previous draw at y=149 put the last rear tyre pixels at y=208: the
   nominal traffic anchor of 70 was not the player artwork's tyre contact.
3. The candidate draws the player at **y=154**, five pixels below the previous
   origin. The ground boundary immediately below those tyres is **y=214**;
   this is `PlayerContactY`, with local anchor y=60. At that row, perspective
   scale is `(214−96)/50 = 2.36 pixels/world unit`. The existing physical car
   half-width of 12 world units projects to **28.32 pixels**, within 0.32 pixels
   of the artwork. This is placement calibration, not a physics change.
4. The caller supplies the projected road centre at y=214. Player centre X is
   that centre plus `lateralQ8 * 118 / (50*256)`, with the existing signed
   integer truncation toward zero. At zero lateral position the tyre footprint
   centres on the actual drawn centreline, including curves. Road geometry
   itself has no lateral or steering input.
5. Reflection uses the existing VDP matrix `x′=101−x`. It moves the artwork
   anchor from x=51 to x=50. The draw helper therefore subtracts **51** for
   ordinary views and **50** for mirrored views. Pass the selected pose's
   `mirrored` field to `playerDrawX`; do not keep the previous `carX()−19`.
6. On a straight section, the outside tyre and asphalt edge agree within one
   raster pixel at lateral ±78 world units. The same is true of the outside
   tyre and outer kerb at ±94 units. Physics still changes to KERB immediately
   beyond ±78 and to GRASS immediately beyond ±94, exactly as `Motion::surface`
   specifies. A raster pixel cannot resolve the one-Q8-unit state transition.
7. The sprite's fixed model origin is retained for yawed poses. Their bounding
   boxes are deliberately not recentered, and fixed-width arcade contact rules
   do not expand with yaw. A rotated wheel can appear farther down or sideways;
   this known art/physics distinction is preserved and needs visual review.
8. With a fixed centreline camera, much of the near road extends off screen.
   At the existing maximum displacement ±150 units, the player is entirely
   clipped. The screen does not constrain lateral state and the camera does not
   chase an off-screen car. This follows the accepted camera change; the
   headless review should include normal left/right driving and recovery.

## Optional viewing-bearing correction

`Pose` holds the existing five-view index and a mirror flag. With the option
disabled, player selection exactly matches `Motion::view()/mirrored()` for all
legal steering states, and traffic keeps the original thresholds
264/787/1297/1785 and cross-product sign. Screen position has no effect on this
control option.

With the option enabled, angles use signed integers with 65,536 units per turn:

1. Player heading is the existing visual steering proxy multiplied by 256.
   No body-yaw state, steering rules or motion equations are added.
2. Traffic heading uses the principal arcsine of the existing signed Q12 cross
   product. This deliberately retains the old cross-only heading information;
   it cannot distinguish a 120° heading from 60°. The table clamps an out-of-
   range cross product to ±4096. This is a small visual experiment using the
   existing local-heading proxy, not a new full 3D vehicle model.
3. Viewing bearing is `atan((screenCentreX−160)/160)`, precomputed at two-pixel
   intervals, with a small integer interpolation for odd pixels. Traffic's
   already-projected centre includes both road curvature and its lane offset,
   so the same lane displacement naturally matters less at greater distance.
4. Visible yaw is heading minus viewing bearing. Its magnitude is rounded to
   the nearest source pose, with a spacing of 7.3828125° (1,344 integer units),
   and clamped to source view 4 (29.53125°). Positive visible yaw uses a mirror.
   A straight-ahead car at screen centre selects the unmirrored rear view.
5. The bearing table covers ±512 pixels from screen centre. Cars intersecting
   the viewport have centres within about ±211 pixels at the existing maximum
   scale, so this covers every visible opponent and the player's usual clipped
   excursions. Fully off-screen positions beyond this range use the extreme
   table bearing. No runtime trigonometry or floating point is used.

The two tables use **1,092 bytes**: 514 for bearing and 578 for heading. Dense
arcsine samples near the endpoint prevent a large error near ±90°. Exhaustive
host comparison against double-precision mathematics finds a maximum bearing
error of **0.005024°** for all integer offsets −512..512 and a maximum heading
error of **0.007734°** for all integer cross inputs −4096..4096. These are much
smaller than the 7.3828125° source-view spacing, but a value exactly near a pose
threshold can still select the adjacent view. No hysteresis is enabled; qualify
visible flicker before adding state or changing threshold behavior.

The helpers emit no commands. Root integration measures any orientation CPU
cost and change in mirror usage separately; the tables' small size is not proof
that the runtime cost is negligible. Existing traffic scale/mirror transmission
and resident player mirror matrices remain in use.

## Reproduce the focused host checks

From the repository root:

```sh
.venv/bin/python docs/tasks/RALLY-18/generate_vehicle_tables.py
c++ -std=c++17 -Wall -Wextra -Werror -fsanitize=address,undefined -g \
  -Irally/include -Idocs/tasks/RALLY-18 \
  docs/tasks/RALLY-18/test_vehicle.cpp \
  -o docs/tasks/RALLY-18/.work/test_vehicle
docs/tasks/RALLY-18/.work/test_vehicle
```

The tests inspect actual embedded car pixels, verify mirrored anchoring,
unchanged contact thresholds and control pose selection, exhaustively check
the two angle lookups, and exercise lateral symmetry, convergence with depth,
curved-heading cancellation, clamp behavior and continuity across rear/mirror
transitions. ASan/UBSan run passed on macOS. Native framebuffer review and
eZ80 runtime costs are reported by the task's integration evidence, not by
these host tests. `vehicle-table-evidence.json` records source hashes and the
generated representation.
