# Building the RALLY-19 candidate

This is an isolated research candidate, not the root `rally/` application.
R19-11/R19-12 in the root TODO remain open. The current call-inlining candidate
has native regression evidence and now runs after a board reset on restored
official VDP2.16.0, confirmed by the Author. Physical rendering is still visibly
slow and is not accepted. HARDWARE-DEBUG.md records the hardware investigation.
Do not treat the native emulator's host CPU as an ESP32 timing model.

## Where the code lives

1. Golem compiler: `/home/smith/Agon/mystuff/golem-rally19/src/golemc.cpp`
   and `src/hosted.hpp`, branch `rally19-vdp`. It compiles typed hosted programs
   to the stock VDP Buffered Commands API. Its design and intrinsic semantics
   are in `docs/design/rally19-hosted-v1.md`; tests run through
   `.venv/bin/python tests/run_hosted.py` from that Golem worktree.
2. Rally protocol and frontend: this task's `admission.golem`,
   `scene_protocol.hpp`, `frontend_state.hpp`, `golem_renderer.hpp` and
   `frontend.cpp`. Input, simulation and HUD remain on the eZ80; scene projection,
   sorting, drawing and retained scenery run on the VDP. FRONTEND.md and
   ABI.md describe the boundary; SCENERY.md covers the complete scene.
3. Golem source generation: `build_scenery_draw.py` composes the road, vehicle
   and scenery generators. These Python helpers write Golem source; the existing
   C++ compiler performs typed lowering, resource validation and byte emission.
   The final editable/generated source for the current research build is
   `.work/frontend/hardware-inline/kernels/oval/oval-scenery-draw.golem`, with the
   equivalent `fuji/fuji-scenery-draw.golem`. Paths in this document beginning
   `.work` are relative to this task directory, not the repository root.
4. Production extraction: `build_production.py` preserves accepted art upload,
   input/physics and HUD while removing research modes, reports and per-frame
   counters. `build_stack_candidate.py` is the earlier emergency reproduction
   helper; the fresh frontend-to-production chain below reproduces its deployed
   candidate byte-for-byte and avoids copying the old production source tree.

Generated kernels, binaries and profiles are ignored outputs. Retain tracked
source and evidence; do not manually edit a generated `.golem` file and expect
the generator to preserve that edit. The same directive selections must remain
covered by compiler, visual, lifecycle, performance and physical tests.

## Current Linux build chain

Run from `/home/smith/Agon/mystuff/AgonArcade-rally19`, using this worktree's
`.venv/bin/python`. The separate Golem worktree has its own venv for its host test
runner. Required build tools are host `g++`/`make` and agondev under
`/home/smith/Agon/agondev/release/bin`. Follow the shared `agon-dev-env/codex`
environment instructions for the Python environment and canonical emulator.
Physical serial capture additionally uses pyserial; firmware diagnostics use
the separately recorded PlatformIO/esptool installation.

The accepted oracle is reconstructed by `foundation.py` from tracked Rally,
RALLY-13 and RALLY-18 sources. It verifies the frozen binary hash. It has already
run here; do not rerun it over historical oracle evidence. A new environment
needs that foundation and the recorded prerequisite proofs, not merely a copied
binary. This research chain still contains Linux absolute paths in manifests
and proof checks; moving it requires explicit path/identity adaptation without
weakening those checks.

Choose an unused build name. `hardware-inline` already exists and is the
qualified current example:

```sh
export PATH=/home/smith/Agon/agondev/release/bin:$PATH
.venv/bin/python docs/tasks/RALLY-19/build_frontend.py NEW
.venv/bin/python docs/tasks/RALLY-19/build_production.py NEW --frontend NEW --inline-qualified
```

The explicit flag verifies the complete66-pose inlining proof, its source and
evidence hashes, exact bootstrap identities and regenerated loader signatures.
Without it the original bridge requires unchanged pre-inlining assets. It is
not a switch to accept arbitrary compiler output. A changed compiler or scene
requires new qualification evidence before this production path will accept it.

Production output is `.work/production/NEW/`. For oval, ship the matching
`bin/rally.bin`, `oval.vdp` and `oval.clr` together. Add `fuji.vdp` and `fuji.clr`
for Fuji. Production does not require `.road` files; they support the research
frontend's explicit CPU oracle option. Artwork is unchanged and embedded in
the executable; resident scene coefficients are in the bootstrap.

MOS launch from the directory containing the three matching files:

```text
load rally.bin
run . oval demo
```

Defaults are oval/demo. `race`, `fuji` and optional `autosteer` are supported.
The production game retains the120Hz physics clock/30Hz frame deadline and
contains no fencing, diagnostic files, performance counters or serial logs.
Temporary VDP instrumentation is a separate firmware experiment.

## Validation and emulator use

The current production rebuild matches the card candidate's executable,
source, every header, Makefile and both tracks' assets. See
`evidence/hardware-production/inline-candidate/production-rebuild.json`.
Its executable SHA256 is
`64c8b0734bcd253112d162173fc38f343eafbc96894dc1d09b4793766ed59129`.
Hardware deployment hashes and the preserved autoexec are recorded in
`evidence/hardware-production/inline-b-card/deployment.json`.

Build test-only variants with `build_stability.py`, `build_lifecycle.py` or
`build_render_work.py`, each taking
`NEW --frontend NEW --inline-qualified`. Their corresponding probes, test
semantics and limitations are in STABILITY.md and PERFORMANCE.md. They use
the exact production scene assets but add diagnostic eZ80 code. Never substitute
one of these diagnostic executables for the requested production card binary.

Test runners create fresh profiles under this task's `.emulator/` using
`profile.py` and the canonical setup tool. They launch headlessly by changing
into the profile and invoking `./fab-agon-emulator --renderer sw`; do not invoke
the raw linked emulator binary. The pinned native runtime is Fab1.2.4, stock
MOS3.0.2 and VDP2.16.0 under the AgonJukebox runtime directory. Do not reuse
AgonJukebox's application profile or map a parent tree into its own nested SD.
Run timing tests alone with normal eZ80 CPU limiting; UI presentations and
buffered-call returns have different meanings from completed physical frames.

The Author authorized one dedicated graphical review after the reset cause
was located. That candidate was launched and later closed; closing the window
does not establish graphical review approval. Subsequent physical4096-byte-stack
diagnosis and the Author's restored-official-firmware reset test confirm the
startup correction. No cold power-cycle test was performed. The frozen goal's
standing commit authorization applies to milestone checkpoints; this is not
performance approval, publication approval or permission to ship diagnostic builds.
