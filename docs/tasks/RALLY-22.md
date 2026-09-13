# RALLY-22 — Complete Agon Rally, then continue the Extender port

Status: Author authorized unattended continuation on 2026-09-13. This contract
is recorded before full-game implementation. BENCH-001 driving practice comes
first, with four 15-minute blocks at 200%, 180%, 160% and 140% grip under the
latest bedtime direction, excluding debugging/deployment. Previous practice
remains archived separately. The Author
deferred the driving demonstration until tomorrow, then requested a physical
run at 170% grip; that steering does not cancel this continuing goal.

## Scope and boundaries

Develop the accepted pre-Golem Rally lineage into a playable complete game:
title/splash presentation, qualifying, races, opponent behavior, scoring/timing,
HUD and return-to-attract flow. Preserve the accepted production snapshot and
the separate instrumented bench derivative. Golem remains outside scope.

The Author's reference is https://youtu.be/FFs1Xc82Q0U. Locate the existing
Agon Jukebox video downloader/converter tools; extract frames for study.
Downloaded video, frames, images and sounds must be outside repositories or in
an explicitly ignored directory verified with git check-ignore before download.
Use .research-cache for local reference material. Reference media must never
be staged, packaged or published as game assets. Create the game's own assets;
investigate the Nintendo-style font in agon-utils as requested and retain its
actual provenance. Label rules unseen in the reference as design decisions.

Both circulating race traffic and triggered arcade traffic belong to the
traffic specification. Their initial hooks are already stubbed under RALLY-21.
For offline-planned opponents, use sparse speed/direction/turn-rate/duration
records and per-car physics-tick countdowns, with Python planning and collision
validation. Preserve Fuji and the oval. Runtime gameplay must run with stock
onboard VDP; telemetry/custom EMOS/P4 features remain optional bench facilities.

## Ordered execution checklist

1. [x] R22-01: Close bounded driving practice. Retain telemetry/controller
   identities, practice budget, overlap/pass counts, automatic quit evidence,
   and the requested 170% grip result. Preserve working bench and accepted
   production binaries. No overnight attention cue while the Author sleeps.
2. [x] R22-02: Inspect local Jukebox/agon-utils tools and obtain the reference in
   ignored storage. Build a timestamped reference index for presentation, GUI,
   qualifying, races, traffic and transitions. Distinguish direct observations,
   earlier Author recollections and new design choices.
3. [x] R22-03: Freeze a concise full-game specification and implementation
   layout, keeping the hardware-approved baseline reproducible. Define controls,
   timing, lap/qualification thresholds, score/race outcomes, persistence,
   traffic policies and rendering/physics clocks. Define objective completion
   checks so the unattended game phase has a stopping point.
4. [x] R22-04: Implement title/attract/menu and HUD/font presentation with original
   or appropriately reusable assets. The HUD must be in the upper sky region
   permanently excluded from horizontal scrolling: per-buffer retained static
   labels and only changed numeric fields redrawn. Preserve palette discipline,
   road/scenery optimizations and accepted perspective/vehicle size.
5. [x] R22-05: Implement qualifying, grid/race start, racing, finish/failure and
   return-to-attract transitions. Use elapsed physics time; gameplay durations
   must not depend on rendering FPS. Test boundaries and resets.
6. [x] R22-06: Execute RALLY-21's released gameplay portion: deterministic
   generator/playback and opponent separation, plus both traffic policies as
   required by the selected race design. Retain stable racing identities/laps.
   Verify integer replay, wrap and complete repeat boundaries.
7. [x] R22-07: Finish gameplay feedback and presentation, including player/car
   contact consequences and appropriate original effects where needed. Keep
   instrumentation optional and absent from normal shipped execution. Roadside
   signs are lower priority than R22-04/05: use the Author's other game artwork,
   standard Agon material and the Agon Extender logo as single bitmaps scaled
   solely by distance, with no perspective transform. Preserve asset provenance.
8. [x] R22-08: Validate headlessly, then through bounded physical runs using
   remote SD/keyboard/reset tools. Preserve exact sources, binaries and rollback.
   Record visual-review items separately; historical acceptance does not validate
   new graphics/builds. Quit after every bench driving run.
9. [x] R22-09: Prepare a coherent full-game candidate, documentation, reproducible
   assets/builds, playable hardware deployment and tomorrow's review evidence.
   Respect human emulator validation and commit approval gates: leave affected
   changes uncommitted/unpushed until approval, continuing independent work.
10. [ ] R22-10: Once the full-game candidate meets its machine-checkable contract,
    continue agon-extender's authoritative backlog: video throughput first,
    then VDP command-suite coverage. Read active ownership and concurrent work
    before touching shared files. This is a faithful VDP PORT, not a redesign
    or improvement project for upstream VDP. Keep implementation/evidence in
    Extender's owning tasks; do not duplicate its queue here.

## Operating authority

The Author authorizes sustained unattended development and existing hardware
access, including scoped firmware flashing, CLI, SD and Pi-controlled reset.
Preserve Extender keyboard and recovery. Do not change wiring or infer unknown
electrical connections. The USB sniffer is reportedly on all eight P4 data-line
header pins. Use the existing pinwalking utility to correlate actual pulses
with sniffer channels; consult its bus-ownership and capture procedure first.

Routine emulator tests remain headless. No overnight spoken/emulator alert is
needed for progress. Record physical interventions that require the Author and
continue independent work instead of repeatedly waking them. Source changes
remain in owning projects, preserving current branches, other agents' work and
task namespaces. No remote integration/push is implied. Later human replies
steer this continuing objective rather than silently cancelling it.

## Preparation while bounded driving finishes

The requested one-tick then two-tick comparison completed at180% grip with
31passes each,10clean laps each, and no contact/kerb/grass observations; both
quit automatically. Two ticks continues for the remaining160/140% blocks.
Latest Author priority is safe passing on either side before centre preference.
The practice record retains all parameter changes; these are not isolated
single-variable grip comparisons.

Reference thumbnails and local helper/font/Nurples inspection are indexed in
../research/rally-full-game-reference.md. Full video download failed HTTP403;
thumbnail limitations remain explicit. Full-game candidate1 is specified in
../specifications/rally-full-game.md before implementation. This preparation
overlaps physical practice; full-game code has not started. The separate
rally-game source layout will preserve both existing derivatives.

The cached Atari manual PDF20–21 was additionally read to resolve original
qualification/grid/score-flow details. The reference supplement records those
facts separately from the chosen Agon balance. Before implementation the
full-game specification now also fixes the scoring formula and records the
maximum grip used, preventing a last-second grip reduction from relabelling
a tuned result. The pre-code freeze manifest is refreshed for that clarification.

## Author priority and HUD amendment,09:40UTC

The Author explicitly prioritizes splash/title screens, qualifying, actual
race laps, time extensions, game-over conditions and the original-style HUD
ahead of signage. This supersedes any earlier implementation order that would
start signs first. Sign artwork comes from the Author's various games, standard
Agon material and the Extender logo; each sign is one distance-scaled bitmap.
No perspective distortion or new sign renderer is wanted. Do not copy third-
party reference advertisements from the Pole Position video into game assets.

The HUD belongs to a protected upper sky region never touched by horizontal
scroll/edge repair. There is no budget for redrawing it because the background
turned. Static labels are retained on both buffers, with per-buffer caches for
changed values. Clear/rebuild only when the HUD layout actually changes. The
new renderer's clipping helper must encode the reviewed VDP Y ordering.

All four practice blocks are now complete:3600.066s,399clean laps,1108passes,
zero contact entries/grass samples. BENCH-001/PRACTICE.md in agon-extender
contains the plot, per-run hashes and steering/reserve caveats. The post-drive
ROM/SD preservation audit passed: full ROM prefix matches EMOS16, startup and
accepted/experimental binaries match their recorded hashes, and staged/active
SD write readback passed. sdserve exited to the EMOS prompt.
No further learning runs under the exhausted allowance.

## Latest bedtime amendments

Development HUD retains essential diagnostics at the top rather than bottom;
its layout can differ from production. Both layouts remain wholly outside the
horizontal sky-scroll and repair region. Release builds compile out diagnostic
collection. Signage also gives Agon Jukebox a shoutout and investigates Richard
Turnnidge / Christian Pinter (Xian) artwork with recorded reuse permission.

The Author explicitly permits local Extender changes needed by this project,
and reiterates its live status: no experimental code may be pushed before
Author review. Finish the game phase first, then video throughput and faithful
VDP coverage in Extender's existing task ownership. Current draft changes
remain uncommitted; no publication or remote integration is authorized.

## Initial implementation and startup finding

New rally-game compiles with the accepted headers, tick-driven rules and
per-page cached HUD. Host deadline, extension, reset/catch-up and unchanged-HUD
checks pass. The first native boot found an inherited agondev CRT defect:
dynamic global construction causes its initializer walker to call the address
after .init_array instead of the function pointer. The debugger stopped in
rodata before main at0485b8, trying to write ROM000501. HudImage now has a
constexpr constructor; the rebuilt map has an empty .init_array. Preserve
this constant-initialization requirement and reject nonempty startup tables
in this candidate. No toolchain/reference changes were made. Native visual
qualification continues; this is not yet a playable complete-game delivery.

The first moving visual capture exposed a second stock behavior: VDU24 stores
the graphics viewport but direct VDU23,27,3 bitmap drawing retains the old
canvas clip. The new viewport helper now follows VDU24 with a non-drawing
PLOT4 MOVE to activate it. Official VDP2.16 context/graphics.h setGraphicsOptions
and drawBitmap establish this distinction. Road clipping includes the lower
status strip because inherited road.emit clears that strip. A subsequent
headless capture will validate retained HUD/panels through turns and exit.

## Machine progress after initial game-flow captures

Title/menu/countdown/qualification, six-lap oval race completion, two-lap Fuji
completion in an explicitly clear-road assisted fixture, race timeout and
manual qualification failure are exercised headlessly. Normal release starts
and exits through ordinary keys with no fixture/diagnostic strings. These are
not human handling acceptance; the populated Fuji arcade fixture timed out
late in lap2, while the clear-road fixture verifies long-track phase flow only.

The retained HUD corruption was traced to MOS length-zero output: mos_puts
with length0 uses delimiter mode, replaying stale bytes after an unchanged HUD.
The sender now skips empty writes. Corrected release02 captures retain the
production HUD, and hud-long02 retains all B/C/S development labels across
five captures through moving turns. The previous font/cursor hypothesis was
not the cause; redundant VDU4 selection was removed as unnecessary overhead.

Native phase evidence before the latest final candidate is in ignored
.research-cache/rally22/{flow-oval01,flow-fuji01,timeup01,fuji-finish01,release02,
hud-long02}. Captures before release02/hud-long02 include the now-fixed empty
write defect and must not be presented as current visual acceptance. From
check_build.py onward, every build keeps exact source/map/binary identities in
ignored content-addressed builds; earlier exploratory captures identify their
binaries but lack that complete source archive.

Traffic generator/runtime agree exactly for600ticks, close lateral/heading
state, and preserve the common-pace gap invariant. Contact recovery and
grid-order ties pass host tests. A half-lap wrap had been counted as a pass;
forwardPass now requires the former distance be within the player's actual
tick advance. Normalized station positions avoid repeated integer divisions
inside six-car per-tick contact checks. No paused RALLY-20 experiment is folded
into the renderer. Optional saved records use validated setting-specific data,
verified staging and a previous good copy; corruption/activation tests pass.

## Presentation/gameplay implementation complete; qualification underway

R22-04 through R22-07 mark implementation and component checks, not human
acceptance. Eight 64x64 billboards include Aginvadors, Defender, Nurples, Agon,
Agon Jukebox and Extender's mascot, plus original text tributes to Richard
Turnnidge and Xian. Actual third-party game pixels remain pending permission.
All eight are visible in the native capture. Every whole-world track station
was checked on both actual lookup roads: 4541 oval and 25706 Fuji visible sign
projections remain inside road-refreshed rows. Sign/traffic depth ordering uses
the shared distance scale. Font/routes/sign derivatives regenerate identically.

`signs-oval01` completes qualification and six race laps with retained top
diagnostics, ordinary signs and the explicit assisted fixture. `record-write01`
uses ordinary input (capture-only build) and saves score348 after an unfinished
qualifier; the 2320-byte record validates, and `record-read01` shows TOP348 in
a fresh process. `final-release01` uses the normal uninstrumented image and
retains title/menu/qualifier/failure and Escape exit. Result transitions now
zero speed so the stopped display and engine agree. These captures are visual
machine inspection, not Author acceptance or frame-rate benchmarks.

A source-inclusive local package puts runtime files/readme.txt at archive root
and all build/source material under project_files. The base commit is labelled
explicitly as an uncommitted candidate, and hashes identify exact inputs. An
extracted archive rebuilds byte-identically and passes all host tests. No
reference video/manual imagery or experimental debug options are packaged.
The physical smoke uses a separate SD directory and unchanged existing firmware,
startup and accepted production install; its outcome is recorded separately.

The physical capture-only build completed title, selection, countdown, normal
manual-input qualification timeout at exactly2400ticks, score309 save and
Escape return. The checksum-validated2320-byte record has only setting43,
score309, lap0. SD foreground recovery and unchanged startup readback pass.
The source-bound normal build is being staged separately for its own bounded
attract/exit check; no historical physical result is relabelled as this build.

## Machine game phase delivered

The normal171072-byte binary SHA256
3ac79285f327bbb0bfe6a56cae7b839f124486a0fbd253647278b8bfa5a40434
is staged, activated and fully read back in the isolated RALLY-22 SD directory.
A25-second muted attract window and Escape return are followed by a successful
CLI SAVE receipt and recovered SD service. Root startup is unchanged; the
foreground finally returns to EMOS CLI. No firmware, reset, production install
or additional driving practice changed. Private deployment/journals stay in
.research-cache/rally22/hardware-release-2026-09-13-10-52-48Z.

Local source-inclusive review package: .research-cache/rally22/agon-rally-review03.zip,
SHA2567eb43e726a7c93c771d55243f5f65c87bbf431a1197c5a608fe6b11a805f50f4.
It is an uncommitted candidate, not a published release. R22-09 denotes machine
delivery; Author visual/handling review and explicit commit approval remain
open. R22-10 now continues under Extender PORT-003's video-throughput increment.

## R22-11 — Attended Fuji arcade host drive

Author requested a live Fuji/arcade race and restart after inspecting the full
game. This authorizes a bounded attended demonstration, not renewed overnight
practice or Extender backlog work. The full game currently lacks bench telemetry.

1. [x] Add an opt-in RALLY_HOST_TELEMETRY build using the existing EMOS gateway.
2. [x] Test the snapshot against the actual retained P4 receiver and host decoder;
   compile ordinary and instrumented variants, preserve ordinary runtime.
3. [x] Stage/read back a separate SD binary, restart Fuji arcade and drive one
   qualifying/race attempt through ordinary keys at explicitly disclosed200% grip.
4. [x] Release keys and retain telemetry/outcome; leave human review open.

Contract frozen before edits: no firmware changes, direct state control, demo
assistance during driving, balance/traffic-route changes or automatic restarts.
Use existing140-byte v2 framing; optional full-game application profile places
the phase enum in the previously unused upper nibble of flags byte3. Low flags
retain running/manual/demo/assist/audio meanings; running is set only in driving
phases outside crash recovery. All reserved bytes remain zero. Non-race/inactive
traffic slots use signed distance INT32_MIN and zero lane/speed, an explicit
absent-slot sentinel rejected by the old driver and removed by the new adapter.
Active slots report exact signed Q8 lanes and route speed; use player station
(camera+68units), actual crash count and normal physics. Keep monotonically
advancing frame/clock across phase changes; the host resets only its prediction
state at an observed phase change, never accepts a new run/keyboard epoch.
The host profile verifies phase, CRC, freshness, flags and inactive sentinels,
reuses the existing PassingDriver only for manual phases, releases controls
during countdown/results/crash, and stops on a result or stale/changed ownership.
No score-file writes in this instrumented build. Normal binary contains no
telemetry options/calls; keep both current deployed candidates intact.

Attended outcome: normal build remains byte-identical SHA256
3ac79285f327bbb0bfe6a56cae7b839f124486a0fbd253647278b8bfa5a40434
(the authoritative build.json carries the exact identity). Instrumented172643B
SHA2569ce657cd9df7b2302ec5aa7e975f992c0e2bd93430a25df687ee63de82725cc1
was independently staged/read back/activated as hostrace.bin beside the isolated
full-game candidate. QualifyReady→Qualify→Qualified→RaceReady→Race→Finished
completed in173.65wall seconds at200% grip, two-tick steering.1621observations
were road-only; the real game counted4crashes. Approximate observed phase
intervals: qualifying46.68s, two-lap race117.81s. These are host observation
intervals, not exact in-game lap timer readings. This passes the requested
attended attempt, not collision-free driving acceptance. The existing controller
forecasts opponents at their current lateral position; moving-route forecasting
remains a limitation, not a proven diagnosis of all four crashes. No tuning or
repeat attempt was performed. Ordinary Escape exit stopped telemetry and left
the keyboard neutral/released. Extender private evidence is
agents/video-throughput/author-fuji-race-01; paired deployment/menu/exit journals
share author-fuji prefixes. All changes remain local/uncommitted. Extender video
work remains paused. Profile byte81 is unused zero; byte84 counts real crashes.
