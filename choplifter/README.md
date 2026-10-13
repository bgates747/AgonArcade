# Choplifter — Pygame rescue game

A playable original-style rescue mission on an 848×480 canvas. Four camps hold
64 hostages; carry up to 16 at a time and return to base. Three helicopters,
tanks, jets, bombs, gunfire and gentle landings form the rescue loop. Artwork is
new procedural pixel art; no original game assets are included.

## Run

From the repository root:

```sh
.venv/bin/python -m pip install -r choplifter/requirements.txt
.venv/bin/python choplifter/game.py
```

Use Python 3.10 or newer. If the repository environment does not exist, create
it with `python3 -m venv .venv` first. `make -C choplifter run` also launches it.

| Key | Action |
| --- | --- |
| Enter | Start / restart after the mission |
| Arrows or WASD | Fly; release to slow down |
| Space | Fire in the facing direction |
| B | Drop a bomb |
| F | Toggle forward-facing bombing mode |
| P or Escape | Pause / resume |
| Q | Quit |

Shoot or bomb a camp to release its occupants. Land within 160 pixels of people
and stop so they can run to the helicopter. Return to the marked base pad and
stop to unload. The cabin holds 16. High vertical or horizontal landing speed
causes a crash. Enemy shots can kill exposed hostages; passengers are lost when
a helicopter crashes. The mission ends when all 64 people are rescued or lost,
or when the third helicopter is lost. Rescue count is the primary objective;
rescues earn 100 points and destroying enemies earns bonus points.

## Graphics contract

The logical and displayed canvas are exactly **848×480**. RGB222 provides the
64-color Cartesian palette `{0,85,170,255}³`. RGBA2222 alpha values are restricted
to the endpoints **0 and 255**; intermediate alpha values 85 and 170 are never
used. Shapes are opaque, text has antialiasing disabled, and there are no fades,
alpha modulation, filtered scaling, or partial-coverage edges. Font transparency
uses binary coverage. The completed frame is fully opaque. The renderer does
not use antialiased drawing or asset pipelines that expand the palette.

## Research and deliberate adaptations

See [RESEARCH.md](RESEARCH.md): the 1982 original is a single battlefield rescue
scenario, not a numbered multi-level campaign. This implementation uses that
structure. It is an original-style clone rather than a cycle-exact port:
movement, timing, combat, scoring, terrain, and artwork are independently made.
There is no multi-stage campaign or copied Sega scenery. Sound is not included.

## Verification

```sh
make -C choplifter test
.venv/bin/python choplifter/game.py --headless --frames 3 --screenshot /tmp/choplifter.png
```

Tests exercise a full 64-person rescue, passenger losses, three-life game over,
landing speeds, enemy/civilian hits, pause, movement, and a pixel-by-pixel palette
and alpha audit across title, gameplay, and end screens. The CLI smoke test
checks display initialization and shutdown without a graphical session.
