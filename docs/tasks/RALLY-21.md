# RALLY-21 — Deterministic traffic move tables

Status: the full-game portion was released through RALLY-22 and is implemented
in `rally-game`. Its normative record format, separation argument, stable grid
identities and both traffic policies are in the traffic specification. Host
replay and native full-game evidence pass within the scopes recorded by
RALLY-22; human handling/visual review and commit approval remain pending.
The original `rally-bench` policy stubs are preserved unchanged. The following
intake describes the earlier deferred boundary; RALLY-22 is the later authority.

## Requested behavior

Opponent cars must not run into one another. Generate their coordinated routes
offline with Python, then have Rally play sparse deterministic move tables.
Each car holds its current speed/direction and a countdown in physics ticks.
At zero, it loads the next speed/direction/duration entry and repeats. Keep the
runtime small; the route-planning intelligence belongs in the generator.

The Author additionally requested constant turn-rate segments: "turn at this
rate for this long." Include signed angular rate and tick duration, allowing a
single entry to sustain a curve without dense position samples or interpolation
between many waypoints. Heading/position integration still advances each physics
tick; table fetches occur only when the countdown expires. Prefer the codebase's
256-unit circle convention, selecting any fractional accumulator precision when
the exact runtime contract is designed. This intake does not freeze bit widths.

The guarantee concerns opponent-to-opponent motion. A human can deliberately
drive into traffic; avoiding that requires a separate gameplay decision. Do not
silently promise that precomputed opponents can avoid every player action.

The Author recalls that the original arcade game triggered opponent spawns
rather than circulating every opponent around the course, producing apparent
"lap traffic" almost immediately. This is an attributed design observation,
not independently researched original-hardware evidence. Preserve the current
circulating-car model: the Author likes it and intends a real racing mode.
Triggered arcade traffic may be a separate future policy, not a replacement
silently introduced by this task. Any such mode must define spawn/despawn
occupancy checks and include those boundaries in the separation proof. Real
racing additionally needs stable opponents, lap counts and race-order semantics;
those features are future scope, not authorized implementation here.

## Work when this task is released

1. Preserve the new CirculatingRace/TriggeredArcade interface boundary and its
   explicit unavailable stub. Review the Author's Nurples countdown/animation implementations, particularly
   `src/asm/explosion.inc`, `src/asm/enemy_seeker.inc`, and the turret/laser code.
   Resolve the sibling Nurples checkout from the shared repository guidance;
   the machine-local path is not part of the runtime format. Record the exact
   relevant code and revision before selecting the Rally representation.
2. Freeze explicit field widths, coordinate/direction and turn-rate conventions, physics tick
   timebase, countdown semantics, initial phases, loop behavior and track IDs.
   Reject zero-duration entries and invalid table indexes. Advance countdowns
   per physics tick, including elapsed-time catch-up, independently of rendering.
3. Write the Python route planner and exporter. Start with the current six
   opponents and retain editable generator inputs. Use a fixed seed if search
   needs randomness; identical inputs must reproduce the exact move tables.
4. Simulate all cars together using the runtime's exact integer integration.
   Check swept footprints between steps, lane changes, variable speeds, lap
   wrap and table-loop transitions. Validate a complete shared repeat period
   or provide an equally explicit indefinite separation argument; a short
   collision-free replay alone does not guarantee they never meet later.
5. Export only sparse speed/direction/turn-rate/duration changes and initial state. Measure
   RAM, table size and runtime cost; identify whether files are embedded or
   ancillary before changing the production packaging contract.
6. Keep the runtime a countdown/table interpreter. Validate its replay against
   Python, then test both selected tracks headlessly and on hardware. Obtain
   required human visual validation and commit approval before publication.

## Starting point and boundary

The accepted derivative's `rally-production/include/traffic.hpp` gives six cars
fixed lanes and different speeds. Cars in the same lane can therefore catch
one another. No opponent collision response exists. BENCH-001's new telemetry
and host passing controller must continue to observe that current behavior;
do not quietly replace traffic while demonstrating player avoidance.

Keep Golem and the wider paused RALLY-20 optimization work outside this item.
The definitive geometry/contact envelope and table tick widths are future
design choices, not frozen by this intake document.

## Interface intake evidence

`rally-bench/include/traffic_policy.hpp` declares initialise/tick/spawn/despawn
hooks. The running bench adapter selects CirculatingRace; TriggeredArcade is
unavailable, with no-op tick and rejected spawn/despawn. The native Agon build
passes. This is the Author-requested stub intake, not completion of the route
generator, separation proof, triggered traffic or real racing gameplay.

## RALLY-22 implementation record

The generated common-pace 600-tick route closes lateral position/heading exactly.
Per-car countdown copies and alternating lateral mirroring preserve stable
identities. Common longitudinal motion preserves circuit gaps indefinitely;
arcade admission checks the same separation envelope before a triggered spawn.
Python and C++ replay agree at every tick, and repeated circuits, laps, finish
ties, strict contact edges, recovery and spawn rejection pass host checks.
`rally-game/assets/routes-proof.json` is generated evidence. Renderer traffic
yaw includes the signed route heading as well as the road tangent. This candidate
uses one shared pace pattern; varied overtaking route plans are not claimed.
