# R19-02 — Frozen oracle and measurement qualification

Frozen before candidate renderer development, 2026-09-12. The accepted source is
949f618's RALLY-13 review generator using RALLY-18, **not root rally/**. The exact
142,960-byte binary is reproduced by foundation.py. No game or Golem compiler
implementation changes are part of this milestone.

## Identity and reproduction

From `/home/smith/Agon/mystuff/AgonArcade-rally19`, use this worktree's Python:

```sh
.venv/bin/python docs/tasks/RALLY-19/foundation.py
.venv/bin/python docs/tasks/RALLY-19/build_fixture.py
.venv/bin/python docs/tasks/RALLY-19/run_oracle.py
.venv/bin/python docs/tasks/RALLY-19/qualify_harness.py
.venv/bin/python docs/tasks/RALLY-19/scene_masks.py
.venv/bin/python docs/tasks/RALLY-19/qualify_metric.py
.venv/bin/python docs/tasks/RALLY-19/byte_accounting.py
```

The native capture runner resumes only verified matching case files. For a new
runtime comparison, preserve this committed evidence and use a distinct output
bucket; do not overwrite the frozen baseline. `measure_oracle.py` generated the
initial timing evidence using fresh profiles; it intentionally rejects existing
profile/output names. Do not run timing concurrently with captures or builds.

Dependencies: local CPython 3.14.6 and Pillow 12.3.0, host g++ with ASan/UBSan,
clang, installed agondev C++17 toolchain, canonical setup_emulator.py, official
Fab 1.2.4/MOS 3.0.2, local SDL3 headers/library. Runtime/tool/input hashes are in
foundation.json and individual capture manifests. All launches use real canonical
profile-local wrappers with SDL dummy video/audio and software rendering.
Linux's capture helper uses LD_PRELOAD and an SDL library rpath: neither helper
nor preload is present in timing runs. This is Linux-specific tooling; Mac SDL
interposition and executable/library formats differ.

## Fixtures and metric

`fixtures.json` preserves the original 48 exact inputs (24 per track), including
signed lateral/steering extremes, grass excursions, independent stripe seams,
lap/interval boundaries and three-car overlap. A pre-candidate curvature audit
found the uniform Fuji samples missed its hairpin at track sample 248. Therefore
`fixtures-bends.json` adds 18 poses, without replacing any original: near/far
approaches to nine separated Fuji curvature peaks. Both tight oval peaks at
samples 26 and 63 already occur in several original views. Total: **66 cases**.

The diagnostic build adds only a bounded 68-byte pose-file loader inside the
existing snapshot branch. It still calls the accepted simulation/scene renderer.
Its distinct binary/source identity is recorded in fixture-build.json. Each
native scene.csv equals the host simulation result byte-for-byte. Capture waits
for the guest's ready marker, captures the static image ten SDL presentations
later, sends Escape, requires the guest's exit marker and finally quits. This
establishes static native image and input evidence, not rendering completion
latency or a one-to-one SDL/game-frame correspondence.

Each case records the input hash, binary hash, native PNG, exact scene state and
semantic-mask.png. The 640x480 scanout is sampled to 320x240 game pixels. Material
support uses actual native palette pixels and road geometry; car support uses
original source alpha, the actual startup integer enlargement, projected affine
sampling and far-to-near occlusion. Remaining scenery/grass is background; HUD is
excluded. Boundary sampling differences are covered only by the stated one-pixel
tolerance, not an assumption of an independent bit-exact software rasterizer.
Cases whose player is legitimately outside the image retain that accepted
visibility. Fully occluded/offscreen objects are distinguished from omitted
visible objects through scene records and visible support.

`visual_metric.py` reports exact and symmetric radius-one same-colour,
same-semantic-object agreement on the union of expected/actual support. Every
visible car and each road material must independently reach 95%, with nonempty
support in both images. Sky cannot pad car/road scores. A separate piecewise
geometry check evaluates the union of road breakpoints, requiring <=1 pixel
centreline error. Fixed road-width constants remain part of the contract;
material support comparison tests their rasterized boundaries too. Candidate
support **must come independently from its own emitted geometry**, never by
copying the oracle mask. Future native comparisons must also verify object order
and expected visibility from scene data, not rely on a whole-image similarity.

Synthetic calibration passes identity and one-pixel edge movement, and rejects
two-pixel geometry displacement, omitted near/far cars and markings, a wrong
livery and reversed occlusion. Native adversarial qualification erases every
visible car/marking in every case while keeping its claimed mask unchanged: each
must fail. `metric-calibration.json` and `metric-adversarial.json` record results.
The standalone Linux SDL smoke verifies actual RGB readback and exactly one
keydown, keyup and quit on their scheduled presents. The pose parser accepts a
valid input and rejects 37 malformed/truncated/out-of-range inputs under host
sanitizers. Evidence: harness-qualification.json.

## Initial baseline, normal clock and stock VDP

The exact accepted binary ran serial warmed 64-pose batches on each track in
compute / submit / submit / compute order. These are baseline modes, **not** the
future oracle/candidate ABBA comparison required by R19-10. All runs preserve
speed 300 and the accepted 2x world-progress tick. Each has 64 poses, 384 vehicle
draws and the matching per-track state hash; no unlimited CPU, per-frame poll,
custom VDP, or visual interposer is involved.

| Batch | Compute instruction time/frame | Submission batch mean/frame |
| --- | ---: | ---: |
| Oval, repeats 1/2 | 14.9368 / 14.9368 ms | 32.8125 / 33.0729 ms |
| Fuji, repeats 1/2 | 14.0051 / 14.0051 ms | 33.0729 / 33.0729 ms |

Compute timing uses Fab debugger cycle counts at the accepted r18Begin/r18End
symbols and 18.432 MHz. That span includes deterministic pose setup and physics,
scene preparation and bookkeeping, not just projection. Submission uses the
guest's 120 Hz clock for the whole unpaced 64-pose batch, including waiting for
the UART transmitter to empty. A post-batch GP is outside the timed span; it is
a parser/echo milestone, not a documented rendering-completion event. Load ticks
measure road-file loading only (about 50–52 oval, 282 Fuji); they are not full
startup duration. Raw results and launch arguments are in evidence/baseline/.

These initial numbers are batch means, not individual-frame medians/p95s. They
are not evidence of the final frozen performance targets, CPU savings, stock
hardware speed, or a universal swap ceiling. R19-10 must run matching candidate
and oracle jobs, qualify finer timing, distinguish physics from scene work and
report full startup/memory/end-to-end limitations explicitly.

`byte_accounting.py` executes unchanged extracted accepted draw function bodies
on the host, with libvdp command-length substitutes grounded in the hashed
library source. Its road totals match both actual native submission batches.
Other component totals are procedural accounting, not a measured UART trace:

| Mean bytes/frame | Oval | Fuji |
| --- | ---: | ---: |
| Road | 513.594 | 399.922 |
| Scenery | 62.281 | 55.641 |
| Vehicles, including player | 293 | 293 |
| Diagnostic HUD | 17 | 17 |
| Swap | 3 | 3 |
| Total | 888.875 | 768.563 |

HUD here is the fixed TIMING FIXTURE label. The interactive HUD has a different
update policy and must be accounted separately during integration. Per-pose
counts, source hashes and totals are in byte-accounting.json and *-bytes.csv.

## Failures retained

The first Linux capture attempt failed before starting Fab because LD_PRELOAD
could not find SDL before the canonical wrapper set its environment. Adding the
helper's local SDL rpath fixed it; both attempts remain under smoke-oval*.
The first fixture compile lacked stdio.h in the new header; its failed log and
the successful rebuild are retained. The initial 48-pose coverage shortfall and
18-pose extension above were resolved before any candidate rendering or scoring.
No acceptance threshold was relaxed.
