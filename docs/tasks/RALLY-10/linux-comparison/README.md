# Linux versus macOS headless Rally comparison — 2026-09-12

Requested by the Author after compiling and reviewing the migrated Rally changes.
Results are in [the per-case and stage tables](results/table.md),
[manifest](results/manifest.json), and adjacent raw CSVs.

## Findings

The Linux machine does not materially improve these emulator workloads over
the recorded Intel Mac results. The full-scene unfenced baseline is identical
at 154.69 ms/frame on both hosts; fenced baseline differs by only 0.2%.
The latest 120-row results are:

| Track / scene | Mac equivalent FPS | Linux equivalent FPS | Mac ms/frame | Linux ms/frame |
| --- | ---: | ---: | ---: | ---: |
| Oval / full markings | 7.81 | 7.97 | 127.99 | 125.52 |
| Fuji / full markings | 8.74 | 8.87 | 114.45 | 112.76 |
| Oval / pavement only | 14.01 | 12.49 | 71.35 | 80.08 |
| Fuji / pavement only | 13.64 | 13.71 | 73.31 | 72.92 |

Removing markings remains useful on Linux, reducing batch time by 36.2% on
the oval and 35.3% on Fuji, but it still takes 4.80× and 4.38× the 16.67 ms
budget respectively. Linux pavement geometry alone averages 44.53/42.19 ms;
fence waits add about 16.7 ms. These stage definitions do not isolate native
VDP operations. The slower Linux oval pavement result is repeatable in this
pair (616/614 ticks), but two samples do not establish its causal explanation.

The earlier 121-row fixed-band comparison also reproduces the optimization:
Linux batch time falls 21.5% on the oval and 31.3% on Fuji versus greedy.
Fixed-band Linux times are 1.7%/3.7% shorter than the matching Mac results.
The original Mac reflection outlier is absent on Linux; its focused Mac repeat
was already much closer to the normal full scene, so it is not evidence of a
large intrinsic Linux reflection advantage.

All **32 runs / 2,048 measured frames** completed with equal Mac/Linux pose
hashes and road-byte counts, zero timeouts and zero omitted samples. All 1,920
fenced frames received acknowledgments; the other 128 intentionally used no
per-frame fence. Linux one-minute load samples ranged about 0.81–3.22.
No hardware performance claim follows from this comparison.

## Matched method

Replays the Mac controlled workload suite (12 runs), its focused reflection
repeat (4), greedy/precomputed-band ABBA on both tracks (8), and the isolated
full/pavement ABBA experiment on both tracks (8). Each run has 64 fixed poses
and two unmeasured warm-up frames. Uses the original `run_timing.run_case`
validation and canonical generated profile entry point, dummy SDL video/audio,
software rendering, and no capture interposer. Runs are serial; the graphical
review emulator was stopped before measurement.

Original guest binaries were recovered from the retained Linux scratch builds
and matched by SHA-256 to the Mac manifests. No source regeneration, guest
recompilation, or substitution of today's 120-row binary for the older 121-row
comparisons was used. Archived inputs and current game sources/binary remain
unchanged. A copy of the current preparation helper provisions separate ignored
profiles beneath `rally/.emulator/benchmarks/linux-comparison/`.

The runner checks exact Mac/Linux equality of pose hash, road bytes and submitted
frame count for every case, plus the original acknowledgment, timeout, omitted
sample, traffic, reflection and stage-total invariants. Full and pavement are
separate binaries; the experiment is not promoted into mainline.

Linux host: AMD Ryzen AI 9 HX 370, 12 cores / 24 threads, x86-64. Mac reference:
Intel macOS 14.8.9; precise CPU model is not recorded in the supplied manifests.
Both use official Fab 1.2.4 and MOS 3.0.2, with stock platform VDP. Native host
executables/modules naturally have different hashes; identities are retained.
Inspected Linux VDP submodules match the Mac research references:
vdp-console8 `7bcf28e0a2376e32328a6a5554d0df852b75c80e` and
userspace-vdp-gl `2c12e77a0d00f8989c884525479ee6d37340751a`.

## Interpretation limits

Tables convert guest batch ticks including final drain at 120 ticks/second,
divide by 64 frames, and report the inverse as **equivalent FPS**. These are
fixed-pose emulator workloads, not physical-display FPS or normal gameplay;
elapsed-time physics is excluded. Individual timestamps have two-tick resolution.
Submission includes guest preparation and transmission/backpressure, not solely
VDP raster time. Fence acknowledgments are not counted SDL presentations.

Fab's `src/main.rs` selects an emulated CPU clock of 18,432,000 Hz unless
`--unlimited-cpu` is requested. Neither host benchmark requests that option.
Consequently this comparison is not an unrestricted host-CPU benchmark. Similar
CPU-heavy timings are consistent with the emulator's guest-speed limit; this
is an interpretation, not proof that all native VDP costs are identical.
Mac historical samples had variable background load. Compare repeated results,
not a single slow outlier. These tests do not qualify performance on physical Agon.
The older iteration-1 free-running 20-second demo runs are not reproduced here:
they follow different trajectories as timing changes and are weaker matched-host
evidence than the later deterministic fixture suites.

## Reproduction

From the repository root, with the archived scratch binaries still available:

```sh
.venv/bin/python docs/tasks/RALLY-10/linux-comparison/run.py
.venv/bin/python docs/tasks/RALLY-10/linux-comparison/summarize.py
```

The runner is Linux-specific and records the actual dedicated Fab runtime. It
preserves the original Mac evidence and writes only this comparison's results
and ignored profiles. No build, hardware deployment or commit is performed.
