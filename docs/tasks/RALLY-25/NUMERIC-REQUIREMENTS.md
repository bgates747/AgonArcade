# RALLY-25 numeric requirements — D1 handoff

Explicit signed/unsigned 32-bit arithmetic suffices for the preserved route/contact kernel and selected lookup projection under the frozen datasets and valid-input domains below. Signed 16-bit player lateral state is insufficient. The older direct map projection has a conservative cross-product bound exceeding signed32 and needs a proven tighter geometric bound or a checked wider helper before any migration. This audit does not introduce 64-bit source syntax or replace fixed-point arithmetic with floats.

Inputs and hashes are in [the lineage receipt](reference/inputs.json). [Numeric vectors](reference/numeric-vectors.json) and [range receipt](reference/numeric-ranges.json) are generated with unbounded Python integers; the frozen C++ lookup implementation independently checks actual pose cases. Conservative bounds are not observed maxima. Primitive overflow/conversion examples are future Golem conformance expectations, not proof those features exist. Arithmetic error-code values remain to be agreed; semantic labels avoid guessing them.

## Domains and units

| State / operand | Domain / unit | Required representation |
| --- | --- | --- |
| Track station | Fuji 0..3,276,799; oval 0..575,999; hundredth world units | Explicit sint32 or checked uint32; normalized before station comparisons |
| Finish distance | Fuji two laps 6,553,600; oval six laps 3,456,000 | uint32; explicit checked conversion before signed comparison |
| Race progress / next spawn | Signed grid progress can be -60,000; arcade cumulative progress and nextSpawn grow | sint32 progress, uint32 clock/nextSpawn with admission limits; no indefinite signed accumulation claim |
| Player lateral | -38,400..38,400 Q8 world units (±150) | sint32; checked narrowing to sint16 must reject extremes |
| Route heading | Current records produce ±1,920 turn16 units; sine helper accepts all sint16 values | sint16 storage, explicit sint32 magnitude/interpolation; handle -32,768 without sint16 abs |
| Route duration/speed | Duration ≤180 ticks, speed ≤180, advance ≤360 hundredths/tick | uint16 storage; widen before products |
| Pace/slot lateral | Full 600-tick cycle 0..10,088 Q8; half excursion 5,044; slot lateral ±14,260 Q8 | sint32 calculations; final slot value fits sint16 but player does not |
| Player controls | Speed 0..300; steering ±21; renderer yaw uses turn16 | Existing eZ80 motion stays owned there; validate telemetry before helpers |
| Identity/timing | Slot generation uint16 wraps intentionally; tick/finish uint32 | Protocol/state counters; zero finish is sentinel, so caller supplies nonzero elapsed ticks for finish tests |

For finite D1 replay, require nonnegative player progress ≤`INT32_MAX-60000`, no signed car progress/added advance beyond `INT32_MAX`, safe `a-b` before cyclic modulo, and checked `nextSpawn+90000`/tick increments. The published streams remain far inside these limits. Those local preconditions do not define a new production session-duration/rebase policy. Historical attract handling explicitly rebases car progress to on-track position and clears finish at each player lap (`main.cpp` lines 329–341 in the pin); a standalone indefinitely accumulating kernel would lose that protection. Later autonomous operation must retain/review rebasing or stop safely at an agreed bound.

## Route, lifecycle and contact formulas

| Formula / source | Evaluation order and bounds |
| --- | --- |
| `routeSine`, `race_traffic.hpp` | Widen heading before absolute value; reflect magnitude above 16384; index 0..256, fraction 0..63. Interpolate `(next-value)*fraction/64` with truncation toward zero, then apply sign. No float sine regeneration |
| `RouteCursor::tick` | Load the next record/initial heading only when countdown is zero; add rate before movement. `sint32(speed)*2*sine/12800` has actual cycle product ±2,159,280 and conservative bound 11,796,120; preserve division before accumulation. Forward advance is `speed*2` |
| Slot placement | `(slot%3-1)*36*256 + sign*(pace.lateral-5044)`; widen before multiplication and unsigned slot subtraction. Preserve shared phase/countdown, first-free slot selection and generation wrapping |
| Lap normalization | `r=n-trunc(n/lap)*lap`; add lap if negative. Do not use a truncating remainder directly as a normalized station |
| Cyclic separation | Normalize `a-b`, then subtract lap only if `d>lap/2`. Station helper adjusts once because both inputs are normalized. Exact half-lap sign differs between helpers but the absolute contact result agrees |
| Contact | Strict `abs(longitudinal)<3200` and `abs(slotQ8-playerQ8)<6144`. Equality is a near miss; maximum admitted lateral difference 52,660. `abs(INT32_MIN)` is not an admissible world operation |
| Spawn/retire | Reject cyclic gap `<9600`, accept equality; retire only for `car.progress < player-12000`. Spawn ahead `player+60000`, threshold increments 90000 even when spawn fails |
| Race finish/rank | Latch first nonzero finish tick at `progress>=finishDistance`; ordinary rank uses strict progress greater-than; finished ties use grid order in the retained game. New remote rank/score bindings remain D2/D3 design |

No paired division output is written on divisor zero (agreed status 4) or `INT32_MIN/-1` overflow (code pending). Quotient truncates toward zero; remainder has numerator sign or is zero, satisfies `n=q*d+r`, and has magnitude below divisor magnitude. Examples include `-7/3=-2 remainder -1`, `7/-3=-2 remainder 1`, and `-7/-3=2 remainder -1`. Checked arithmetic/conversion failures preserve their destination; earlier successful assignments remain. An invocation must not publish success after an arithmetic error.

## Projection and renderer helper arithmetic

| Formula / scope | Bound / requirement |
| --- | --- |
| Position to Q8 | `(position/100)*256+(position%100)*256/100`; normalized Fuji max 8,388,605, oval 1,474,557. Preserve division order; multiplication-first equivalence here does not license reassociation elsewhere |
| Track sample interpolation | Adjacent coordinate delta times `f≤16383` is ≤1,048,512; Fuji tangent product ≤19,905,345. Signed `>>6` / `>>14` must keep arithmetic-shift/floor semantics. Replacing with truncating signed division changes negative results |
| Lookup phase | Local position 0..6399 gives fractionQ14 ≤16381; retain its two low bits. fractionQ12 ≤4095, squared/4096 ≤4094; depth selects one of 19 coefficient records |
| Lookup center | `A=a*4+trunc(b*f/4096)`; `B=c+trunc(d*f/4096)+trunc(e*ff/4096)`; `center=A+trunc(B*q/16)`, `q=7..128`. All coefficient products fit signed32; conservative largest product Fuji 56,298,060, oval 36,707,580. CenterQ8 absolute bounds 814,496 / 665,810 |
| Opponent heading cross | Tangents bounded ±4096; two products and subtraction ≤33,554,432 before `/4096`. Clamp/lookup behavior retains the existing sine-proxy heading branch |
| Actor placement | Visible z=64..1100 world units; `q=8000/z` ≤125, scale ≤250; lane truncates Q8 `/256` before `*q/50`. Player `lateralQ8*118/(50*256)` intermediate ≤4,531,200. Matrix translation `101*scale` ≤25,250 |
| Signs/scenery | Fuji `position*total` / `index*lap` conservative ≤222,822,400; oval ≤6,912,000. Tangent ratio for sky lookup `abs(tangent)*256` ≤1,048,576; guard zero axis through the existing branch. Page-history delta is cyclic and bounded |
| Road endpoints, R24 B | Binary32 ordered multiply/add followed by signed truncation remains in the native C renderer helper. Preserve contraction/conversion behavior; committed Golem float support is available but not a reason to rewrite this helper now. Existing pixel exceptions remain D2 review work |
| Direct map projection, reference only | Independent map-coordinate bound for `-dx*ty+dy*tx`: Fuji 16,821,256,192; oval 3,570,401,280. These are conservative full-map combinations, not evidence actual visible poses overflow. If this route is selected, require a tighter local proof or exact signed wider cross/mul-div helper, plus result/narrowing checks |

For a needed wider helper, the required semantic operation is exact `(a*b+c*d)/divisor` with truncation toward zero after the sum, checked inputs/output, no writes on failure, and an explicitly bounded native binding. Splitting division across terms changes rounding/cancellation. No signature or error code is frozen here, and D1 route/contact does not depend on this optional direct-projection path.

Existing FNV identity/checksum multiplication intentionally wraps uint32; isolate it from checked game arithmetic. Slot generation and root success-generation wrapping are likewise deliberate protocol operations, not permission for unchecked signed overflow. Stream words use explicit signed16 encoding only after bounds/clip policy is established; table/byte lengths use subtraction-based range checks to avoid unsigned offset+length overflow.

## Delivery and review boundary

Golem receives the route/contact vectors, arithmetic/division/conversion/shift vectors, actual lookup poses and source identities through the established mailbox. Array/index support, wide source arithmetic, numeric failure code, all-or-neither paired stores and real native/buffered execution remain GOLEM-035/036 deliverables. Renderer helper signatures and any wider path remain D2 negotiation. Snapshot prediction, clocks, recovery and callback semantics remain outside this tranche.
