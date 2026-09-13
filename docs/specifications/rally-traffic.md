# Rally traffic policy contract

Author-selected design, 2026-09-13. Implementation status and outstanding work
belong to [RALLY-21](../tasks/RALLY-21.md), not this specification.

## Policy boundary

Rally has two explicit traffic policies sharing initialise, physics-tick update,
spawn and despawn hooks. The current bench derivative selects CirculatingRace
at compile time; this preserves existing traffic behavior and avoids a new
runtime branch in its hot loop. TriggeredArcade is an explicit unavailable stub.
Its initialise/spawn/despawn hooks return failure and its tick hook is inert.
An unavailable policy must not be offered as working or silently fall back to
another policy. The source boundary is `rally-bench/include/traffic_policy.hpp`.

CirculatingRace retains stable opponents around repeated laps. It supports the
Author's intended real racing mode; lap/order bookkeeping must remain possible.
The current fixed-population implementation rejects explicit spawn/despawn.
TriggeredArcade owns appearance/disappearance at course triggers and will check
occupancy at those boundaries. The Author recalled triggered traffic in the
original arcade game; that recollection informs this policy distinction without
constituting independently verified research on the original implementation.

## Shared motion execution

Both policies can consume sparse offline-generated motion records. A record
describes speed, direction/heading or signed turn rate, and a duration in physics
ticks. Each active car maintains a countdown and record cursor. Motion integrates
each physics tick; the next record is fetched when the countdown expires.
Constant-rate curves do not require dense position waypoints. Rendering cadence
does not determine countdown progress, including when elapsed physics catches up.
The exact representation and integer rounding rules require a versioned format
before runtime playback is implemented; this contract does not invent bit widths.

Python owns route search/planning and deterministic export. Rally owns bounded
playback. The offline validator must use the same integration rules and prove
opponent separation, including swept motion, spawn/despawn, lap wrap and repeat
boundaries appropriate to the selected policy. Finite testing without a repeat
or equivalent argument does not establish perpetual separation.

## Demonstration boundary

BENCH-001 changes only the policy interface plumbing: its six circulating cars
retain their original lanes and speeds. Its host driver observes and avoids
them through telemetry and ordinary keys. No triggered spawns, route tables,
opponent AI, collision response or racing rules are enabled by these stubs.

## RALLY-22 format1 implementation contract

The new rally-game derivative releases both policies; the preceding bench
stubs remain frozen. Each compiled record has duration:uint16,speed:uint16,
entry-heading:int16,turn-rate:int16. Heading is a65536-unit circle, relative
to the road tangent. On entry, set heading; each120Hz tick first adds turn
rate, advances longitudinal position by2*speed hundredth-world units and adds
trunc-toward-zero(2*speed*sinQ15(heading)/12800) to lateral Q8. Then decrement
the per-car countdown. The exported sine table uses257 quarter-wave samples
with64-heading-unit linear interpolation, symmetric under sign reversal.

Six records repeat every600 ticks: durations60,60,180,60,60,180; heading rates
+32,-32,0,-32,+32,0; speeds180,180,170,180,180,150. Entry headings are
0,1920,0,0,-1920,0. The generator proves exact lateral and heading closure,
continuous record boundaries and lane bounds. Cars mirror the resulting curve
around individual bases. Longitudinal distance need not close in one route
cycle; lap wrapping preserves its common advance.

Every active car shares the same longitudinal pace phase. Circuit initialization
uses at least100world-unit gaps; arcade admission rejects circular gaps below96.
Identical displacement preserves those gaps for all future ticks, including
swept motion and track wrap. Cars keep moving after finishing; latch finish
time rather than stopping one car inside the field. New arcade cars copy the
current global record/countdown/heading/lateral state and therefore cannot
introduce an independent pace phase. Generator evidence retains measured bounds
and exhaustive route-cycle replay; host C++ output is compared byte-for-byte
with the independent Python interpreter. No live opponent AI is required.
