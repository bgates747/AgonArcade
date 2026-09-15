# Agon Rally — full game candidate

This is RALLY-22's stock-VDP game derivative of the accepted pre-Golem renderer.
The frozen `../rally-production` product and `../rally-bench` telemetry experiment
remain separate. This is the current game on `main`; integration and publication were authorized
on 2026-09-14. The Author accepted default startup in stock Fab 1.2.4 on 2026-09-14.
Previously reported difficulty remains an open handling issue.
Bounded native/hardware launch, qualifier/save, exit and SD recovery checks pass;
these do not establish physical frame rate or human difficulty.

It starts with a moving title screen, then offers the oval or Fuji and two
traffic modes. Qualify over one standing-start lap, take your grid position,
and complete six oval laps or two Fuji laps before time runs out. Each unfinished
race lap adds time. Circuit opponents retain their race identities; arcade
traffic appears at course-progress triggers. Contact causes a brief explosion,
recovery in a clear lane and temporary invulnerability.

## Playing

Put `rally.bin`, `oval.road` and `fuji.road` in the same SD directory, change to
that directory at MOS, then `LOAD rally.bin` and `RUN . oval`. The three files
are the required runtime; art, fonts and traffic routes are embedded.

| Input | Action |
| --- | --- |
| Any key on the title | Open race selection, after launch keys have been released |
| Left/right in selection | Choose oval or Fuji |
| Up/down in selection | Choose circuit or arcade traffic |
| Space/Return | Start; retry from a result screen |
| Left/right while driving | Increment held steering once per rendered frame |
| Up/down while driving | Accelerate/brake |
| Minus/equals | Adjust grip, 25–200%, in five-point increments |
| M | Toggle the existing speed-linked sine engine sound |
| Escape | Return to title; release and press again there to exit to MOS |

Command-line options are `oval`, `fuji`, `circuit`, `arcade`, `steer1`, `steer2`
and `mute`. Last track/mode/steering choice wins. Defaults are oval, circuit,
two steering ticks, 200% grip and sound enabled. `demo` is a compatibility alias
for the default title/attract launch. There are no production telemetry, fencing,
benchmark or forced-phase switches.

Best score/lap records use `rally.sav`, with `rally.new` staging and `rally.bak`
as the previous good copy. Records distinguish track, traffic policy, steering
step and maximum grip used during the attempt. Missing or invalid records and
save failures do not prevent play. Save I/O occurs on stopped result screens.

## Building and checking

Use agondev's C++17 toolchain. The code requires neither exceptions, RTTI nor
libstdc++. The parent repository's `.venv/bin/python` runs project tooling.

```sh
make -C rally-game AGONDEV_CONFIG=/path/to/agondev/bin/agondev-config
make -C rally-game test AGONDEV_CONFIG=/path/to/agondev/bin/agondev-config
make -C rally-game assets AGONDEV_CONFIG=/path/to/agondev/bin/agondev-config
```

The executable is `rally-game/bin/rally.bin`. Build checking rejects dynamic
global initializer/finalizer tables because this installed agondev CRT handles
them incorrectly. Keep globals constant-initializable. It also rejects stale
fixture/production flags and records exact source/binary identities in `bin/build.json`
and the ignored `.research-cache/rally22/builds/` archive. Each build recompiles
the single translation unit so flag changes cannot silently reuse an object.

Host tests exercise rule deadlines, resets and catch-up; retained HUD pages;
exact Python/C++ route replay and separation; contact recovery; and save-format
validation/activation. Font/route generation uses Python's standard library.
Sign conversion and capture conversion additionally require Pillow (the current
development environment has Pillow 12.3.0). Editable sources and provenance are
under `assets/`; generated headers live under `include/`.

A development build adds the essential diagnostics in the protected **top** HUD:

```sh
make -C rally-game EXTRA_GAME_FLAGS=-DRALLY_DEVELOPMENT
```

W is steering, G is grip, ROAD/KERB/GRASS is tyre contact, DT is raw MOS ticks
between submitted updates, B is road bands, C is visible traffic, and S is the
held steering step. DT is not a physical VDP frame-completion measurement.
Production omits that row's collection/formatting. Both layouts exclude the
upper 24 pixels from every panorama scroll and repair operation. Static text
is cached independently on both pages; empty output must never be passed to
MOS's zero-length/delimiter-mode string API.

## Isolated native captures

The canonical environment setup tool creates every profile. Typical Linux use:

```sh
.venv/bin/python rally-game/tools/prepare_emulator.py rally22-review --args 'oval mute'
cd .emulator/rally22-review
./fab-agon-emulator --renderer sw
```

Use the generated profile-local wrapper, never its raw linked executable.
The helper defaults to the locally qualified official Fab 1.2.4 runtime under
the sibling AgonJukebox tree; `--runtime` selects its location on another machine.
The shared `agon-dev-env` setup environment must exist. Linux capture tooling
builds an SDL3/LD_PRELOAD interposer with clang and user-local SDL headers/libs;
that helper needs adaptation for macOS. Ordinary unattended tests use
`tools/capture.py`, SDL dummy video/audio and fresh profiles. Captures measure
appearance/input only, not performance. Human approval is still required before
committing emulator-related changes.

Test-only compile definitions `RALLY_CAPTURE`, `RALLY_TEST_DRIVER`,
`RALLY_TEST_RACE_TIMEOUT`, `RALLY_TEST_CLEAR_ROAD` and `RALLY_TEST_CONTACT` are isolated qualification
fixtures, never release options. The assisted test driver uses the existing
demo steering in the actual game loop; its scores are never saved as manual
play. A clear-road fixture proves long-track flow without claiming populated
traffic validation. The contact fixture injects one overlap to test the ordinary
crash/recovery path; it does not claim that generated routes produced a contact.
Exact fixture flags accompany evidence.

The authoritative work queue is the parent `TODO.md`, with detail in
`../docs/tasks/RALLY-22.md`. Rules and rendering decisions are in
`../docs/specifications/rally-full-game.md`; traffic format/proof is in
`../docs/specifications/rally-traffic.md` and `assets/routes-proof.json`.

## Local review package

After a normal build, run `.venv/bin/python rally-game/tools/package.py
.research-cache/rally22/aginv-rally-review.zip` from the repository root (one
command). It rejects fixture flags and stale inputs. Runtime files and
readme.txt are at archive root; project_files contains editable sources, build
inputs, README.md and a base-commit reference explicitly labelled uncommitted.
The manifest hashes every supplied file. This does not publish the candidate.

## Attended host-driving build

R22-11 adds an explicitly separate `-DRALLY_HOST_TELEMETRY` variant. It requires
the already-qualified EMOS resident telemetry provider and Extender keyboard
path. Launch arguments add `grip200`; phase flow and all driving rules remain
normal. This variant never writes human score records. The normal build is
byte-identical to the original candidate and excludes the gateway object.

The paired host controller is Extender's `scripts/rally_race.py`; it takes
`--url`, a fresh `--output` folder, and a bounded `--seconds` deadline. Start
it in the Fuji qualifying countdown at200% grip after selecting arcade via
the normal CLI/menu. It stops on a result, stale telemetry or keyboard takeover,
releasing its keys. Raw telemetry is preserved. The optional application
profile is specified in RALLY-22's R22-11 section; no firmware change is needed.

To test the packet against the actual P4 receiver, compile
`tests/host_telemetry_test.cpp` with game/production include paths and the
Extender `vdp/video/extender/telemetry` include directory. Its stdout is a
sequence of eleven140-byte snapshots for the paired host decoder tests.
