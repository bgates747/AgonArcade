# AgonArcade

A collection of native arcade games for Agon, with original pixel art and synthesized sound.

## Assembly maths reference — agon-fsim

**Consult sibling project `mystuff/agon-fsim` before writing new eZ80 maths kernels.**
The user identifies its assembly multiplication/division primitives (including
hand-written work by them and other authors) and working 3D matrix transforms as
useful reuse candidates. Its [assembly audit](../agon-fsim/agon/04-assembly-reachability-audit.md)
records exact donor sources in `pingoasm` and AgonMaths, including arithmetic,
matrix/vector operations and trigonometric tables; the assembly need not reside
in the fsim checkout itself.

For Rally, evaluate these alongside lookup tables when reducing geometry cost.
Check numeric formats, ranges, rounding, calling conventions and source provenance
before adapting routines, then measure the affected eZ80 work. See the
[RALLY-10 design discussion](docs/tasks/RALLY-10.md#assembly-maths-reference).

## Rendering references — AgonWolf3D and Wolf3dOrig

**Consult these sibling projects when choosing what to precompute and what to
render live.** The current checkout names map to these approaches:

1. [AgonWolf3D](../AgonWolf3D/docs/map-design-manual/appendix-b-map-build-format.md)
   precomputes projected panels and per-cell/per-direction visibility; its
   assembly runtime selects bitmap panels and stored screen coordinates.
2. [Wolf3dOrig](../Wolf3dOrig/README.md) follows the original Wolfenstein 3D
   rendering approach through a live raycaster in a bespoke VDP. Its
   [rendering milestone](../Wolf3dOrig/agonport/doc/first_correct_render_success_story.md)
   also documents lookup-based movement and cached projection arithmetic.

See [RALLY-10](docs/tasks/RALLY-10.md#wolf3d-rendering-references) for concrete
source pointers and their relevance to road rendering.

## Defender

[Agon Defender](defender/README.md) features inertial flight, a wraparound planet,
lasers, smart bombs, alien abductions, and civilian rescues.

![Agon Defender](defender/docs/images/agon-defender.png)

```sh
make -C defender
.venv/bin/python defender/tools/prepare_emulator.py
./defender/run.sh
```

Arrow keys fly, Space fires, and X uses a smart bomb. Pick up people and slow
down over a cyan pad to deliver them. Enter starts, P pauses, M toggles sound,
and Escape returns to MOS.

Builds use installed agondev and the stock Agon VDP. Each game owns its emulator
profile; local environments, emulator state and build output are ignored.

```sh
make -C defender test
```

The local checkout lives at `~/Agon/mystuff/AgonDefender`; the repository is named
**AgonArcade**. Future games belong in sibling subdirectories beside `defender/`.
Pynvaders and Aginvadors remain in their separate repository.

## Agon Rally prototype

The [flat-road prototype](rally/README.md) lives in `rally/`: gray asphalt,
red/white kerbs and yellow dashed markings, with a compact flat tri-oval and the preserved Fuji-reference circuit. Up accelerates, Down brakes, and Escape returns
to MOS. Left/Right steer the player car, with lateral inertia and adjustable grip. Kerb and grass contact impose progressively stronger speed penalties.
Six coloured opponents use VDP scaling, mirroring and local colour-table expansion.
The current traffic milestone is emulator-reviewed; physical-hardware validation
remains pending. The earlier road-only milestone passed on hardware.

![Agon Rally curve](rally/docs/curve-right.png)

Build with `make -C rally`, then launch `./rally/run.sh` after preparing its
isolated emulator profile as described in its README. The
[detailed research](docs/research/pole-position/README.md) covers original arcade
hardware, projection, command budgets and supporting sources; the
[earlier proposal](docs/plans/rally-flat-road.md) records the broader design.
