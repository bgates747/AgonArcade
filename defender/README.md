# Agon Defender

A native C++ space-rescue shooter for Agon: a wraparound planet, inertial flight,
fast lasers, marauding landers, and people who would very much like a lift home.
Original pixel art and synthesized sound effects run on the stock VDP.
Double-buffered bitmap rendering keeps the scrolling scene clean.

![Agon Defender running in the Fab emulator](docs/images/agon-defender.png)

## Play

| Key | Action |
| --- | --- |
| Enter / Space | Start or restart |
| Left / Right | Accelerate horizontally and face that direction |
| Up / Down | Climb / dive |
| Space | Fire lasers; hold for continuous fire |
| X | Smart bomb: destroys enemies in the current view and clears hostile shots |
| P | Pause / resume |
| M | Toggle sound |
| Escape | Exit to MOS |

You retain horizontal momentum when you release the arrows. Reverse thrust to
brake. Fly close to a person to pick them up, then slow down over a cyan pad near
the ground to deliver them. You can carry one passenger at a time.

Green landers descend to abduct people. Shoot the captor and catch its falling
passenger before they hit the ground. A successful abduction turns the alien
into an aggressive magenta mutant. Radar shows aliens in green/magenta, people
in yellow, your ship in white, and the edges of your current view in cyan.

You start with three hull points and three smart bombs. Destroy the enemy wave
to advance; surviving people earn a bonus and each new sector restores one bomb,
up to three. Each sector introduces ten new people. The best score is retained
for the current running session.

## Build and run

Run these commands from the shared repository root. The installed
`agondev-config` tool supplies the eZ80 compiler and libraries.
No custom VDP firmware is required.

```sh
make -C defender
.venv/bin/python defender/tools/prepare_emulator.py
./defender/run.sh
```

The project-local emulator uses official Fab 1.2.4 and verified MOS v3.0.2 Arthur.
`defender/bin/defender.bin` is linked into its isolated virtual SD card. On an Agon,
copy this binary to your SD card and launch it from MOS.

```sh
make -C defender test
make -C defender assets
```

Host tests cover movement, wraparound, pause, keyboard decoding, combat,
abduction, rescue, smart bombs, damage, sector transitions, and 400,000 randomized
simulation frames under AddressSanitizer and UndefinedBehaviorSanitizer.
Asset generation uses only Python's standard library. Pillow and clang-format
are optional capture/formatting tools. Normal tooling uses the shared
repository-root `.venv`. This game lives in `defender/` within the
AgonArcade checkout at `~/Agon/mystuff/AgonDefender`.

The implementation separates deterministic gameplay from the VDP frontend;
see [platform notes](docs/platform.md) and [development log](docs/2026-09-11.md).
This is an independent game inspired by Defender; no original game's artwork,
audio, or code is included.
