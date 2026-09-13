# Agon Rally complete-game contract, candidate1

Author-authorized RALLY-22, recorded before game implementation. This is an
Agon arcade racing game inspired by the supplied reference, not a claim of
byte-for-byte Pole Position rules. Reference observations and limitations are
in ../research/rally-full-game-reference.md. TODO.md and RALLY-22 own execution.

## Source and compatibility

The maintained full-game candidate will live in rally-game/. It reuses the
hardware-accepted rally-production headers/data without modifying that frozen
snapshot, and keeps rally-bench as the separate telemetry-driving experiment.
New game rules, renderer integration, traffic playback, original UI/effects,
asset generators and tests live in rally-game. No Golem dependency. C++17 via
agondev, no exceptions or RTTI, no libstdc++ requirement.

Normal runtime is stock MOS3.0.2 / VDP2.16.0-compatible, mode136 at320x240,
regular bitmap plotting and double buffering. No telemetry, fencing, tracing,
performance measurement or custom firmware is required or enabled. Physical
Extender keyboard use is a MOS configuration choice, not an application ABI.
Experimental test builds remain explicitly separate from the shipped binary.
Development builds retain the essential speed, steering, grip, surface and
frame-cadence diagnostics in the protected upper HUD, not at the bottom. Their
layout may differ from production. No diagnostic collection is compiled into
the normal release; changing layout never exposes the HUD to sky scrolling.

Preserve the accepted perspective,102x77 player canvas/five reflected views,
64-colour palette, black tyres/light hubs, liveries, road geometry, both tracks,
kerb/grass grip and drag, lookup projection, and retained panorama scrolling.
Do not fold paused RALLY-20 performance experiments into this game. The renderer
still runs on eZ80/stock VDP; physics and clocks retain their existing semantics.

## Controls and clock

Left/right change steering by two256-circle ticks once per rendered frame
while held, within±21; simultaneous opposites cancel. Optional steer1 selects
the Author's finer comparison. This is independent of keyboard repeat. Up
accelerates, down brakes, and -= adjusts grip25–200 in5-point increments once
per rendered frame. Default grip60 and maximum speed300 preserve this lineage.
The candidate records grip with scores so tuned runs are not presented as
like-for-like records. The existing speed-linked engine sine remains unchanged;
a mute option and an in-game mute key can silence it.

Physics advances once per raw MOS tick,120 ticks per real second. Preserve the
existing Motion /100 integrator and world-speed multiplier2. Frame deadline
now+4 is a submission target, not a promise of30 displayed frames/sec. Timers,
countdowns, traffic routes and lap distances use physics ticks, not frame count.
Steering/grip deliberately remain per-render under the Author's chosen control
contract. No silent rescaling of handling when frame output changes.

An input release arms title/menu actions after launch; a held launch key cannot
start an attempt. Escape leaves gameplay for the title, then exits to MOS from
the title after release/repress. Headless fixtures may request immediate quit
through a test-only path; normal keys remain the human product controls.

## Session flow

Attract starts by default: the actual selected road, scenery and cars move behind
an original AGON RALLY title, objective/controls and a press-key prompt. Starting
a session opens a compact track/mode selection: oval or Fuji, circuit or arcade.
Left/right select track, up/down select traffic mode, Space/Return starts, and
Escape returns. No asset downloads or setup choices appear inside the game.

A3-second PREPARE TO QUALIFY countdown precedes one standing-start lap without
traffic. The clock starts on GO, not while assets load or the countdown runs.
Qualification results remain visible for4seconds, then a3-second race countdown.
An unsuccessful qualifier shows DID NOT QUALIFY, the lap/time result and retry
controls. A fresh attempt resets position, phase, lateral state, velocity, wheel
angle, timers, traffic, crash state and input arming. Preserve chosen track,
mode, grip and sound preference.

These are explicitly our initial balance settings, not recovered Namco rules:

| Setting | Oval | Fuji |
| --- | --- | --- |
| Qualifying limit |20s |90s |
| Pole-position target |11s |60s |
| Race length |6laps |2laps |
| Initial race time |20s |85s |
| Time added at each unfinished lap |16s |75s |

The player contact station is68world units ahead of Motion.position (the
existing camera position). Initialize the camera68units behind the start line;
measure player lap/grid/contact progress at that station. A rendered finish
line must agree with the physics crossing, not count the camera as the player.

Qualification time maps monotonically from pole target to qualifying limit into
seven grid positions, with times at/below the pole target taking first place.
A lap crossing at exactly the time limit succeeds; an unfinished lap at the
limit fails. Record lap crossing and timer progression per physics tick. These
settings deliberately allow room above the unchanged60%-grip assisted demo's
indicative13.4s oval /64.5s Fuji standing laps. Manual/human balance still needs
review; finite telemetry-controller results do not establish human difficulty.

Circuit mode uses six stable circulating opponents and race-order/lap semantics.
Player grid position sets the initial signed longitudinal offset relative to
those opponents. Each opponent's completed race time is latched on its first
finish crossing, but it continues moving until the player's result so the
separation invariant is preserved. Player finish position uses finish times
and deterministic grid-order ties; running position uses total race progress.

Arcade mode uses course-progress-triggered traffic. It measures completed laps
and time/score, not a fabricated rank against transient slots. A spawn that
fails occupancy checks is skipped rather than overlapping an existing car.
Both policies remain explicit; one never silently substitutes for the other.

The finish screen presents result, lap/best time, score and remaining-time
bonus, then offers another session and automatically returns to attract after
12seconds. Timeout presents TIME UP with the same clear restart path.

## Traffic playback and opponent separation

RALLY-21's complete-game portion is released through RALLY-22. Python generates
sparse routes; eZ80 plays countdown records. Candidate format1 uses compiled
fixed-width records: uint16 duration ticks, uint16 longitudinal speed, int16
entry heading, int16 signed heading increment per tick. A heading uses65536
units/turn (the256-unit circle with8fractional bits), relative to the road
tangent. Nonzero turn rate sustains a turn without dense position samples.
Speed is the longitudinal track component, not total Cartesian velocity.

At record entry set its heading; each tick first add turn rate, then integrate
longitudinal distance by speed*2 hundredth-world units and lateral Q8 by the
recorded integer sine convention. Decrement duration after that tick and load
the next record only when it reaches zero. Exact rounding, sine samples and
loop closure belong to the generator/runtime format implementation and must
be documented there before export. Reject zero duration, bad indexes, invalid
headings/speeds and lateral/accumulator overflow. No per-frame file reads.

The initial planner uses a common longitudinal pace cycle for all six cars,
with individual lateral base positions and mirrored turn sequences. Therefore
every active opponent advances by exactly the same longitudinal amount each
physics tick. With an initial/spawn circular gap of at least96world units and
a conservative32-unit combined contact length, no pair can catch another.
Lateral movements cannot invalidate that longitudinal separation. This is an
explicit invariant over indefinite repetition, not a claim inferred from a
short clean replay. The validator also checks actual swept rectangles, lateral
bounds, heading continuity and exact route-loop closure.

A candidate6-record cycle has60ticks of positive turn rate,60of negative rate,
180straight,60negative,60positive,180straight. Forward pace is matched between
the positive/negative lobes to close the lateral loop exactly. Initial left/
centre/right base offsets and mirrored trajectories keep all wheels on-road.
The exporter records actual proven extrema and sizes, rather than assuming
these durations imply a particular lane displacement. This intentionally
conservative first race field can be enriched by future offline plans.

Triggered slots join the common global pace phase, including current record
countdown and lateral/heading state, rather than starting an independent speed
cycle. Spawn600world units ahead when a900-unit player-progress trigger fires;
check every active opponent's circular longitudinal gap before activation.
Retire cars120units behind the player. There are at most six active slots;
active identities include a generation counter so slot reuse is not a lap.
The race policy does not use these spawn/despawn rules.

## Player contact and feedback

Use the existing combined32longitudinal/24lateral world-unit
contact envelope and check every physics tick, including catch-up. A new
contact starts a1.25-second crash, immediately removes speed and temporarily
ignores acceleration/steering. Draw an original palette-limited expanding
explosion/debris animation in place of the car; do not import reference sprites
or audio. Opponents retain their deterministic routes through player contact.

After the crash, choose the free road lane nearest centre; if no lane is free,
wait for a gap. Recovery is explicit gameplay behavior, with a one-second
flashing invulnerability period. It is separate from the bench driving proof,
which preserves manual physics and has no such contact response. Grass/kerb
penalties remain; roadside signs are decoration in this candidate, not new
invisible collision obstacles.

Distance contributes one point per16world units; clean passes add100, each
completed lap adds1000, qualifying adds500*(8-gridPosition), and finishing
adds100per whole second remaining. Clamp score at9999999. A pass is a forward
longitudinal crossing without a contact/crash in that crossing interval;
slot activation/despawn is never a pass. No score accrues in attract, menus
or crash recovery. Keep scoring rules in one pure game-rule module.

## Rendering and assets

The original-style upper HUD has two primary8px rows: TOP/TIME/LAP over
SCORE/SPEED, with current race position/count available in the lower status bar.
Its24px full-width sky region is permanently excluded from every horizontal
scroll, edge repair and full scenery repaint. Preserve the sky's solid blue
behind the HUD. Initialize static labels on both buffers; keep independent
per-buffer field caches and redraw only values that changed on that page.
Turning alone must cause zero HUD repaint bytes. No per-frame whole-strip clear.
Keep road horizon96, RoadTop104 and lower status area at224+.

Title/menu panels use fully repainted rectangular regions when their contents
change. Invalidate both affected page caches on phase/layout changes; never
scroll old HUD/text into the scene. The existing lower-sky repair remains
outside the protected HUD until a separately qualified optimization. Add a
command-trace assertion that scroll viewports never intersect rows0..23 and
an unchanged-HUD test that emits no text/clear bytes on both warmed pages.

Reuse the existing five car sources and VDP-side livery maps/reflections. Build
an original8x8 monochrome font as a separate VDP Font-API resource, leaving the
system font intact; restore system font and release the resource on exit.
Splash/title, qualification, actual race laps/time extensions, game over and
the HUD take implementation priority over roadside signage. Later signs reuse
the Author's game artwork, standard Agon material and the Agon Extender logo,
with a recorded source/permission trail. Each is a single palette-converted
bitmap, uniformly distance-scaled with the existing affine scaling mechanism;
no perspective distortion. Agon Jukebox must receive a sign. Also investigate
Richard Turnnidge and Christian Pinter (Xian) projects for original artwork,
recording actual reuse permission/licence and credit before inclusion. Unclear
permission may leave a sign pending without blocking the higher-priority game.
No video-reference advertisements become assets.
Finish markings and original crash effects use the existing palette. New asset
conversion has editable inputs and reproducible derivatives.
New typography and layout require fresh visual review.

The inherited production main passes viewport Y endpoints in reversed pixel
order. Official VDP vdu_graphicsViewport reads bottom before top, and rejects
inverted rectangles. New HUD clipping requires a correctly named helper that
calls vdp_set_graphics_viewport(left,bottom,right,top), with bottom>=top in
pixel coordinates. Correct this in the new renderer, documenting the change;
do not edit the preserved production or claim an RALLY-20 performance result.

The binary embeds game-specific font/traffic/effect data; existing oval.road and
fuji.road remain the only required ancillary runtime inputs. Save records are
optional and never required for startup. Save failures leave a playable game.
Persist best lap and best score with track/mode/steering-step/maximum-grip
encountered-during-the-attempt identity, using versioned
validated data, write/readback before activation, and a retained previous good
copy. Write only at results/ordinary exit, outside timed physics. Initials entry is deferred; records identify the local run settings.
The primary manual supplement later confirmed original eight-car grids and
recommended73-second qualification. Our selected field/timers remain explicit
initial Agon balance choices, not original-rule claims.

## Completion evidence

Machine completion requires host tests for phase boundaries, physics-time
catch-up, reset, exact qualifying cutoffs, grid/rank/finish, countdown replay,
spawn admission, collision/recovery and malformed saves. The independent
Python planner and C++ interpreter must agree exactly and retain the separation
proof. Asset regeneration must reproduce checked-in generated data.

Headless real-eZ80 captures cover title, selection, countdown, qualifying, race,
crash, timeout/results, both tracks and re-entry without stale HUD/sky pixels.
Capture hooks/test autopilots are separate fixtures and absent from production.
A stock-profile normal build starts/plays/exits without custom firmware.
Bounded physical smoke runs use the accepted SD/keyboard/recovery pathways,
preserve exact binary/source/rollback identities and return to the CLI. These
checks do not substitute for the Author's visual/human handling review.

A coherent local playable candidate, documented build/assets and retained
rollback completes the machine game phase. Human validation and explicit commit
approval remain pending; no emulator-coupled changes are committed or published
until that approval. Independent Extender port work may then continue under
its authoritative ownership/queue, with video throughput ahead of coverage.
