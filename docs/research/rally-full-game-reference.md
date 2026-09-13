# Agon Rally full-game reference study

Prepared2026-09-13 for RALLY-22. This supplements the existing Pole Position
road/hardware research; it does not replace that report or own an actionable
queue. The Author supplied https://youtu.be/FFs1Xc82Q0U, titled *Arcade Game:
Pole Position (1982 Namco/Atari)*, uploaded by Old Classic Retro Gaming.

## Evidence quality

Three ordinary yt-dlp video downloads returned HTTP403, including with its
pinned EJS helper and Deno. No complete video or audio was obtained. Public
YouTube storyboard sheets were accessible: seven sheets,5x5 tiles each,
102x90 pixels per tile, approximately4.9367 seconds between tiles. They were
visually inspected. Approximate times below are tile indexes times that interval,
not precisely decoded event timestamps. Fine text, exact scores and timing
thresholds cannot be reliably recovered from these thumbnails.

All third-party media are in the verified ignored .research-cache/rally22/
storage. storyboards/index.json records SHA256 and layout. No reference image
or sound becomes a runtime asset, package input or staged file. The historical
Atari manual and road research cache remain in the original sibling worktree;
tracked sources.md records their public source links and hashes.

## Timestamped visual index

| Approximate interval | Observed sequence | Implication for this game |
| --- | --- | --- |
| 10–40s | Road demonstration with GAME OVER overlay, moving opponents and visible player explosion | Attract flow can demonstrate the actual course and traffic; outcomes need visible feedback. |
| 44–49s | Ranking/instruction screen followed by a Fuji track map/title | Explain the objective and show the selected track before driving. |
| 54–118s | PREPARE banner, stationary start, then a driving lap with sparse opponents | Qualifying is a distinct start and timed driving phase. |
| 123–133s | PREPARE TO RACE, followed by a grid/results overlay | Separate qualification results from race start; give the player time to read the result. |
| 138–217s | Racing with more opponents, roadside signs and persistent upper HUD | Keep score, time, lap and speed legible without covering the road. |
| 222–291s | Continued racing and a start/finish gantry | Course progress and a visible finish landmark help orient the player. |
| 296–365s | GOAL banner, score/bonus text, then initial-entry/ranking screen | The game needs a definitive finish and result flow. |
| 370–439s | Return to GAME OVER/attract, title/map and ranking screens | A finished session returns to a ready-to-play presentation. |
| 444–498s | Another qualifying lap | The attract/qualify/race cycle repeats. |
| 503–513s | Another race preparation/result overlay | A fresh attempt resets phase-specific timing and progress. |
| 518–686s | Further race with opponents and roadside artwork | This is supporting traffic/presentation evidence, not proof of the spawn algorithm. |
| 691–755s | GOAL, initials/rankings, then road/attract | Preserve a readable result before returning to the next attempt. |

The sky HUD visibly uses two principal rows: TOP/TIME/LAP above SCORE/SPEED.
There are white/yellow road shoulder markings, broad red/white kerbs, clouds,
mountain/foothill silhouettes, signs and a finish gantry. Perspective and car
scale in this project were already selected by the Author; do not replace them
from these small thumbnails. Exact original car counts, score formulas, race
length, gear rules and qualifying thresholds remain unverified.

The Author separately recalls triggered opponent spawns producing immediate
lap traffic. Treat that as an attributed design requirement, not a conclusion
proved by these frames. Preserve circulating opponents for the desired racing
mode as well as an explicitly distinct arcade-spawn policy.

## Local tools and assets

The video implementation lives in agon-hardware/first_steps/stream_agm/scripts/
youtube_video.py: explicit yt-dlp download_video and FFmpeg extract_frames.
Its module defaults target unrelated videos and delete output directories, so
these defaults were not executed. Current AgonJukebox is WAV-oriented; its
setup supplies the pinned yt-dlp2026.7.4 reference. The Rally cache preparation
record contains local paths/runtime hashes and the download failures.

The likely requested Nintendo-style font is agon-utils/examples/font_editor/
tgt/fonts/super_mario_bros_2_8x8.font. Its editable TTF identifies TheWolfBunny
and a FontStruct Non-Commercial License. The encoded FontStruct page currently
restricts downloads while the corresponding DaFont page says100%Free. No font
was copied into Rally and no MIT relicensing is assumed. The new game can use
an original small pixel alphabet, preserving the requested arcade readability.
Sources: https://fontstruct.com/fontstructions/show/1733070/arcade-classic-2-19-9
and https://www.dafont.com/super-mario-bros-2.font .

Nurples at1b2b488046eff27aabfc41c55d4276a509ecd602 confirms the requested
countdown idiom. explosion.inc decrements animation_timer and reloads8 at the
next frame; enemy_seeker.inc decrements movement_timer before changing heading
and reloading its duration; tile_turret_fireball.inc counts down before firing.
These are implementation precedents, not an existing Rally trajectory format.

## New-game calibration, explicitly not original-game evidence

A local C++ probe using unchanged production Motion and DemoDriver at four
physics ticks per rendered frame measured the standing-start/rolling demo lap
at60% grip: oval13.383/12.917 seconds, Fuji64.533/64.067 seconds. The demo uses
corner assistance and tops out at224; these are neither human difficulty data
nor hardware performance measurements. Saved source/output are in the ignored
Rally cache. Qualification limits and race timers must be recorded as our own
tunable design choices, with room above those indicative demo times.

## Primary manual supplement

The already-cached Atari TM-218 seventh-printing scan was subsequently inspected
at PDF pages20–21 (printed1-12/1-13), rendered into the same ignored cache.
Primary source: https://files.stardustarcade.com/PDF_Arcade_Atari_Kee/Pole_Position/Pole_Position_TM-218_7th_Printing.pdf .
This supplements the low-resolution video and resolves several items that
were unverified above. The manual describes a90-second initial clock, qualifying
within73seconds at the recommended setting, eight grid positions, and an
operator-selectable four-lap race. Its recommended qualifying table spans
58.50seconds/pole to73seconds/eighth; points reward distance, passes and time
remaining. It describes explosion/reappearance after hitting cars or signs,
more cars appearing as the race progresses, a lap time extension, and initials
entry after play. The complete underlying spawn algorithm is still not proven.

Those are original-game facts. Candidate1 intentionally retains this project's
six coloured opponents/seven-car field, different track scale, selected two-/
six-lap race lengths and forgiving initial timers. The selected settings are
explicitly our balance choices, not an assertion that the manual uses them.
The manual also has different printed track-distance text from the Author's
reference map; no geometry or length was altered to reconcile that artwork.

## Signage intake (after game-flow implementation)

Author-requested sources now include Agon Jukebox, Agon Extender, Aginvadors,
Defender and Nurples, plus Richard Turnnidge and Christian Pinder (Xian).
The GitHub source account is xianpinder; the Author's earlier spelling Pinter
refers to that developer. Foggy's Quest readme credits original creator John
Blythe, MPAGD by Jonathan Cauldwell and Agon port by Christian Pinder:
https://github.com/xianpinder/Agon/blob/main/Foggy/readme.md . Do not misattribute
its original art to the porter. Richard's Starship Sentinel is documented at
https://github.com/richardturnnidge/starship_sentinel ; its public tree contains
a binary and screenshots, with no explicit artwork reuse licence found.
No permission was inferred from source availability and neither developer was
contacted. Original text tribute plates can stand in pending artwork approval.

The Author-owned Extender social-preview.png is present on public main but
absent from this older local tree. Retrieved the exact image at commit
c78807b4c9b2685dc0df8917150372bd8685df9c into ignored art cache without fetching
or merging remote changes. Its central red/white mascot supplies the requested
Extender branding. AgonJukebox's logo.rgba2 is80x120 and its project is Unlicense;
source checkout0a09cee58327ecded770d835d3f7c7ac503980de. Other owned game art has
editable local generators; do not import those generators as modules when they
write their source repositories at import time.
