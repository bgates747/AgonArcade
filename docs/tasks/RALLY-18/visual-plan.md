# RALLY-18 visual evidence

The task-local [capture.py](capture.py) and [visual_capture_macos.c](visual_capture_macos.c)
adapt RALLY-15's native SDL scanout capture and keyboard injection. They run a
prepared canonical **stock VDP** profile through its generated wrapper with dummy
video/audio and normal eZ80 throttling. No graphical window opens. These tools
are exclusively for visual/input checks: the interposer, file checks and pixel
readback must never participate in a performance run.

The harness accepts profiles only under this task's `.emulator/`. Its output
directory must be new and inside this task. It records the wrapper, actual child
command, runtime/firmware/data hashes before and after, captures, and an exact
log of the requested key events. A stale guest signal/report is an error; prepare
a fresh profile instead of accidentally capturing an old run. The harness does
not change profile autoexec or game files.

## Fixed scenes

The game snapshot path is configured by the build/prepare tool using arguments
`snapshot pose=N lateral=N steering=N` with optional `perspective`. After drawing
and draining the fixed scene it creates `sdcard/rally/ready.viz`. The harness can
start its capture schedule from that signal, so different startup loading times
do not select different poses. For example, from the repository root:

```sh
.venv/bin/python docs/tasks/RALLY-18/capture.py \
  --profile docs/tasks/RALLY-18/.emulator/snapshot-oval-left \
  --output docs/tasks/RALLY-18/visual-results/oval-left \
  --ready-file docs/tasks/RALLY-18/.emulator/snapshot-oval-left/sdcard/rally/ready.viz \
  --frames 10 --keys escape:20:26 --quit-frame 50
```

The capture is the complete native scanout (normally 640×480 for the 320×240
game). Frame numbers count **host SDL presents**, beginning when the ready file
is detected; they do not claim to count completed game renders. Escape in the
example is sent after the captured scene. The later host quit closes the
headless test instance. Native requested-quit aborts have occurred in earlier
tasks, so exit status is retained separately; successfully injected host quit
and complete artifacts are required rather than treating a nonzero native exit
as proof that the capture failed.

The initial [harness smoke result](visual-harness-validation.json) verifies the
interposer against a tiny standalone dummy-SDL program: exact RGB readback,
one Right press/release pair, and requested quit at the scheduled presents.
It does not substitute for running and inspecting candidate game captures.

Use paired centreline-live/reference and lookup profiles with identical track,
pose, lateral position, steering and orientation options. Capture centred,
left and right player positions on straight and curved views of both tracks.
Include at least one kerb/grass displacement, the lap seam, and perspective
vehicle angle examples. Interpret pixel differences alongside the exhaustive
geometry tests: a bounded coordinate error can legitimately move a primitive's
raster boundary by one pixel, so full-frame pixel identity is not the contract.
The centreline road must remain invariant when only player lateral/steering
changes. Vehicle/player pixels and relevant HUD/scenery regions are assessed
separately.

## Input and exit

For ordinary gameplay profiles without a ready signal, schedules begin with
the first host present. This repeats RALLY-15's startup allowance and then tests
demo takeover, right/left steering and Escape:

```sh
.venv/bin/python docs/tasks/RALLY-18/capture.py \
  --profile docs/tasks/RALLY-18/.emulator/controls-oval \
  --output docs/tasks/RALLY-18/visual-results/controls-oval \
  --frames 600,720,840,900 \
  --keys space:620:626,right:680:710,left:740:830,escape:850:870 \
  --quit-frame 920
```

Supported keys are `up`, `down`, `left`, `right`, `space`, and `escape`; multiple
holds can overlap. Event injection alone is not proof of gameplay response.
Inspect screenshots and, when the candidate supplies one, require a guest exit
report with `--expect-file PATH`. That report is copied into the retained
output. Confirm steering changes, player lateral movement, active grass/kerb
rules and the return to the MOS prompt. Keep a later interactive graphical
launch separate as the human-review alert; this harness does not launch it.

## Provenance and scope

The source is adapted from committed RALLY-15/capture_macos.c, SHA-256
`85ab8edcb085992367d9cf7c1e8676b45ff637e6b89a57bb050f670fc0b50f41`.
The macOS `BASH_ENV` shim exists because the generated canonical bash wrapper
would otherwise lose a directly supplied `DYLD_INSERT_LIBRARIES` value. It is
task-local, opt-in, and captured in the manifest; no upstream library or wrapper
is patched. Capture manifests prove runtime identity and event delivery, not
physical-hardware behavior or visual acceptance by the user.

## Paired scene runner

[visual_cases.py](visual_cases.py) prepares fresh stock profiles with the current
`.work/builds.json` live/reference and lookup binaries, then invokes the capture
harness serially. It never starts a graphical window. Inspect its matrix before
launching, or run the full bounded matrix with optional controls:

```sh
.venv/bin/python docs/tasks/RALLY-18/visual_cases.py --mode all --plan
.venv/bin/python docs/tasks/RALLY-18/visual_cases.py --mode all
```

The default six static scenes produce twelve emulator runs: oval pose 0 at
left/centre/right with control orientation, Fuji pose 16 left with control
orientation, Fuji pose 16 right with perspective orientation, and Fuji pose 63
centred. Pose 63 is a late-lap sample, not an exact wrap boundary; exhaustive
geometry validation owns the exact seam checks. `--quick` reduces the static
matrix to one paired Fuji curve scene. `--extended` adds the missing track/pose
and orientation comparisons and ±70-unit road displacements. Grass begins
beyond ±94 world units; the final scripted driving captures cover grass and
off-screen clipping. `--mode controls` runs
only the two gameplay checks; the default mode is `snapshots`.

Each fixed scene retains its native PNG, `scene.csv`, `exit.viz`, exact
host-versus-guest numerical comparison, source/runtime identities and key log.
Each pair includes a changed-pixel mask, channel difference image, and a
two-native-pixel neighborhood diagnostic (equivalent to one game pixel at
2× scanout). Neighbor color matching is only an image diagnostic. It does not
prove geometric accuracy or classify vehicle-pose changes as road errors.
Saved section rows/materials must match and saved centres must differ by no
more than one pixel. The exhaustive projection/trapezoid error budget remains
separate. Repeated views at the same track progress require identical road
state despite different player lateral/orientation inputs.

The optional controls checks run the lookup candidate on oval with control
orientation and Fuji with perspective orientation. They wait for the guest's
`play-ready.viz`, then send takeover, acceleration, both steering directions and
Escape. `play-result.csv` must confirm demo mode ended, frames/progress/speed
are positive, and `exit.viz` must exist. Three captures document the intervening
player movement. Event delivery and final state alone do not prove every
intermediate steering response; inspect those images as part of visual review.
No per-frame guest filesystem output is required.
