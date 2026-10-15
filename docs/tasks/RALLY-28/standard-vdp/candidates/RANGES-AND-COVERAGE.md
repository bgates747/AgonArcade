# Shared projection prototype: ranges, reuse and tradeoffs

The new standard prototype reuses the recovered coefficient evaluator and its per-map-line cache. All seven positioning consumers use one frame projection/depth/edge service. Actual gameplay physics/rules remain the preserved normal game; the independent diagnostic world is compiled from byte-identical input/tick bodies. These changes stay in RALLY-28's isolated area, with stock firmware and SDK unchanged.

## Arithmetic and range evidence

AgonDev ADL `int` is24bits, `short`16 and `long`32. New static tables contain1,037 exact inverse-depth bytes and122x10 signed16-bit edge offsets. The values are generated using integer division with C-style truncation for negative widths. Depth is only queried for validated z64–1100; q7–125 and scale14–250 fit8bits, while matrix translation101*scale fits signed16. No float or buffered geometry computation is introduced.

The player's actual lateral clamp is±38,400Q8 units. Multiplication by its fixed contact-row distance118 is bounded by4,531,200, within signed24-bit range; the prototype narrows that operand explicitly before division12800. World state, integration, tangent cross products and checked rules remain wide. Map interpolation needs32-bit intermediate products: tangent delta times fraction14 can exceed signed24. The specialized tangent sampler calculates only tx/ty, discarding neither x/y results after computing them nor the two legacy sampling conventions. Scenery uses fractional station; traffic yaw keeps integral-world station, preserving its view quantization.

Original coefficient arithmetic remains32-bit. Exhaustive record maxima from the unchanged files are:

| Track | maxabs a,b,c,d,e | Bound abs(lineA) | Bound abs(lineB) | Conservative abs centre-pixel bound |
| --- | --- | ---: | ---: | ---: |
| Fuji |20605,13748,77934,9570,2287 |96168 |89791 |3182 |
| Oval |10272,7058,66929,8964,1315 |48146 |77208 |2601 |

FractionsQ12 and squared fractions are at most4095/4094. Products such as13748*4095 fit32bits but exceed24. The loose independent bound lineB*128 can also exceed signed24; narrowing that multiplication requires a correlated row/map-line proof, not the fact that the final pixel is small. Retain the proven coefficient evaluator in this tranche. All cached centre pixels fit signed16 under the conservative3182 bound; adding the largest271-pixel width remains safe. Coarse interpolation uses at most6364*120=763680 before division, within signed24. The finish checker subdivision uses span<=458 and span*12<=5496; one quotient/remainder followed by retained integer credit reproduces all thirteen original boundaries.

For the two declared tracks, sign count is68/12. Setup index*lap is bounded by67*3276800=219545600, fitting signed32; station and ceil-boundary tables are calculated once. Per-frame binary search replaces position*count/lap and repeated sign-station products. Host checks retain negative/off-screen coordinates and both tracks; this does not qualify arbitrary future track formats/counts.

## Consumer coverage

| Consumer | Shared result / preserved win | Behavior and remaining scope |
| --- | --- | --- |
| Road | Original coefficient/map-line cache; sparse boundary samples; exact precomputed widths | Direct and buffered emitters both hoist top/bottom centre and row-offset pointers once per band, retaining the earlier emitter's local endpoint reuse |
| Opponents | Shared q/scale/ground row and cached centre; tangent-only sampler | Original order, route heading, integral camera/opponent sampling, reflection and anchor retained |
| Signs | Same depth/centre service plus setup stations/thresholds | Original side/artwork, depth merge and road/sky clipping retained; index selection is exact |
| Player | Shared row214 centre; bounded24-bit lateral positioning | Artwork anchors/reflection unchanged; world lateral/contact/rules unaffected |
| Finish line | Same depth/centre/width service; incremental checker boundaries | Exact original checker quotient rule; source/host coverage includes this path, although the900-frame wire control never sees a finish line |
| Panorama | One frame camera tangent/heading shared by its history | Fractional-station heading and both retained-page histories unchanged;397 scrolls/399 repaints in all host variants |
| Road materials | Original stripe schedule, separate from geometric subdivision | Material boundaries retained in both fine/coarse variants; road grey/kerb/shoulder/stripe colors unchanged |
| World physics | Separate unchanged Motion/rules/routes/contact/passing/rank/input | No projected coordinates or frame caches feed collision; independent partial-prefix state checks cover diagnostic progress |

Other audited families—HUD formatting before cache checks, redundant footer erase/redraw, matrix/viewport traffic and SDK per-byte affine emission—remain intentionally outside this bounded projection/road experiment. Existing changed-only HUD/panel/audio and shared opponent route/sine improvements are retained. They are pending work, not claimed unsuitable optimizations or completed REUSE-001-02 coverage.

## Explicit visual differences and lifecycle

The shared fine path uses nearest-pixel centres consistently across roadway and objects; the recovered objects previously truncated their centre. That can move an object by one pixel. It is a declared visual change, not a change to world/contact math. The coarse variant retains material edges, removes optional curve subdivisions less than24rows from the retained boundary, and places objects/player/finish on the resulting polygonal centreline. In9,632 sampled pose cases it differs by up to28centre pixels from the fine evaluator. Retain it for Author moving-image selection; no accuracy-only rejection or universal pixel/percentage gate is imposed. Its current schedule filters the preserved conservative list, so it still evaluates discarded endpoints; further schedule specialization is a later possible improvement.

Frame pixel/Q8 caches invalidate on every `project` call. Loaded coefficients are track-owned and must be explicitly reloaded on track changes; the test loads once before timing. Sign caches are keyed to the track. Drawing page sky/HUD/panel caches remain separate and alternate with actual swaps. Parameters are patched and consumed sequentially by resident commands; their x/y bytes are copied before ordinary plotting parses them. The template edits a distinct drawing buffer, not its own running byte stream. One frame is outstanding, and its completion fence releases all parameters before the next frame. No caller writes asynchronously into an in-flight parameter plane.

Buffered templates use only stock SET byte copies plus ordinary draw commands. Their resident bodies total1379bytes, before buffer-map/allocation overhead. Five clear/upload headers add70setup bytes. A four-layer band sends53bytes and a five-layer band61, including the11-byte patch header and6-byte CALL. Copy/interpreter processing is an additional VDP cost; upstream savings alone do not prove speed.

The diagnostic deliberately does not implement the gameplay scheduler. Its rendered scene follows the preserved four-ticks/frame replay for comparability. Mode2 advances a separate actual-game world against the nominal120-unit clock, services bounded chunks while awaiting completion and drains retained debt before another frame; it records blocking/debt and independent final state. That reference rate is a test, not a selected cadence, and does not turn the scripted scene into real-time gameplay.
