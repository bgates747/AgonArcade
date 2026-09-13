# Rally full-game development — 2026-09-13

RALLY-22 owns the unattended continuation after BENCH-001's completed bounded
practice. New code lives in rally-game; rally-production and rally-bench remain
preserved. Golem and the paused broader RALLY-20 optimization remain outside it.
No project commits, pushes, firmware flashes or resets occurred in this increment.

## Candidate behavior

Original moving title/menu, oval/Fuji selection, one-lap qualification, seven
starting positions, six-lap oval and two-lap Fuji timed races, lap extensions,
finish/timeout/retry and return to attract are implemented. Timers and sparse
traffic use elapsed 120Hz MOS ticks; held steering remains two ticks per render,
with steer1 available. The supplied inherited 60% grip/300 speed and sine tone
are unchanged; human difficulty tuning remains open.

Circuit cars keep stable race identities. Arcade cars spawn on progress triggers.
Both replay one coordinated sparse common-pace route. Identical longitudinal
advance preserves admitted opponent gaps indefinitely; lateral turns use signed
256-circle Q8 heading and a countdown. Python/C++ agree at every one of600ticks.
This is a deliberately simple guaranteed-separation candidate, not varied AI.
Player contacts cause original integer bursts, clear-lane recovery and flashing
invulnerability. Saved records distinguish track, mode, steering and maximum
used grip. Attract rebases unused race totals at lap boundaries for indefinite
idle running; actual on-track positions remain unchanged.

The protected top24pixels hold independently cached HUD pages. Production omits
the development row's collection/formatting. Bottom text is gameplay guidance,
not the old debug strip. Panels retain their pixels through turns. Eight
uniformly scaled signs include Author game art, Agon/Jukebox/Extender and two
original text tributes. No third-party game screenshots or reference media are
runtime assets. Actual Turnnidge/Xian game art awaits a clear reuse permission.

## Critical implementation findings

1. This installed agondev CRT mishandles nonempty global initializer tables.
   The first Hud constructor triggered it before main. Globals are now constant
   initialized, and build checking rejects nonempty initializer/finalizer tables.
   No SDK/reference checkout was changed.
2. The inherited viewport encoded Y bounds backwards. Pixel-mode VDU24 expects
   bottom before top. Setting the viewport also needs a PLOT4 MOVE before the
   direct bitmap API uses the new canvas clip. New game integration corrects
   that ordering/activation while leaving the accepted snapshot untouched.
3. MOS output with length zero means delimiter mode, not an empty write. A warm
   unchanged HUD had replayed stale buffer contents. The shared sender now skips
   zero-length output; production and development captures retain all labels.
4. Wrapped opponent separation can jump across half a lap. A pass now also
   requires its previous distance to be within actual player advance, preventing
   points while stationary. Normalized contact positions avoid per-car modulo.

## Evidence and limits

The task detail and docs/tasks/RALLY-22/evidence index exact images/binaries.
Host rules, route replay/separation, contact/recovery, save corruption/activation,
HUD cache and whole-track sign bounds pass. Native captures exercise both tracks,
qualification/race flow, six oval laps, two Fuji laps in an explicit clear-road
fixture, timeout, failure, crash and recovery, record write/read and ordinary
production launch/exit. The contact fixture injects one overlap; the clear-road
fixture does not claim populated Fuji completion. The populated Fuji assisted
run timed out late in its second lap. These are bounded machine checks, not
human handling acceptance or physical frame-rate measurements.

A normal, source-inclusive ZIP builds byte-identically after extraction. It
has runtime/readme.txt at root and source/README/base-commit under project_files,
with a manifest identifying the uncommitted changes. The final idle-counter
refinement has a separate capture; archive identities remain distinct. Nothing
is published. A separate physical smoke/deployment record completes the bench
portion; accepted production and startup are preserved.

Human review must cover title/HUD readability, steering/grip balance, manual
qualification/racing on both tracks, passing/contact recovery and sign artwork.
Fresh emulator validation and explicit commit approval remain required before
emulator-coupled changes are committed or pushed. Extender work may proceed
independently after the machine candidate is complete, under its own queue.
