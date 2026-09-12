# Linux unlimited-CPU replay — 2026-09-12

All 32 matched workloads completed: 2,048 measured frames, 1,920 expected
per-frame acknowledgments, no timeouts or omitted samples. Pose hashes and
road-byte totals match the capped Mac/Linux runs. Exact guest binaries and
all workload/capture settings are preserved; the timing helper differs from
`../run_timing.py` only by adding `-u` to the canonical emulator invocation.

The current 120-row full-road scenes rise from 7.97/8.87 FPS-equivalent on
oval/Fuji to 30.00 on both. Pavement-only rises from 12.49/13.71 to 30.00.
31 batches take exactly 256 raw ticks for 64 frames; one historical Fuji greedy
batch takes 258. Its two-run mean is 29.88 FPS-equivalent. Other case means
are 30.00. See [the complete comparison table](results-unlimited/table.md),
[manifest](results-unlimited/manifest.json) and adjacent raw CSVs.

## The next limit is application pacing

The fixed fixture still executes `next=now+4` after its deadline check.
At 120 raw MOS ticks/second, this restricts submissions to 30 Hz even when
CPU work becomes fast. Thus these tests demonstrate meeting the existing
pacing limit, not maximum unpaced rendering throughput, 60 Hz capacity, or
physical-display frame rates. No application pacing or gameplay source was
changed. Coarse two-tick timestamps reporting zero geometry time do not mean
geometry became free. Fence time includes stock swap/poll synchronization;
it is not isolated raster time.

Fab 1.2.4's parser accepts `-u` or `--unlimited_cpu`. Its help advertises
`--unlimited-cpu`, but that spelling is ignored with an unused-argument warning
in this runtime. The valid flag was verified in the live process command line;
headless logs use dummy video and contain no unused-argument warning.
Internally this option requests 1 GHz rather than 18.432 MHz; it is not a
literal infinite-clock setting. Actual host throughput still limits execution.
Only Linux has been tested with `-u` here; the Mac columns remain capped.

## Reproduce

```sh
.venv/bin/python docs/tasks/RALLY-10/linux-comparison/run_unlimited.py
.venv/bin/python docs/tasks/RALLY-10/linux-comparison/summarize_unlimited.py
```

Unlimited results and profiles have distinct paths from capped evidence.
Review emulator was stopped during serial timings and restored with `-u`
afterward. No commits, hardware deployment or game-source changes.

## Interpretation and scope

Accelerating only eZ80 execution lets these earlier full-road and pavement
renderers meet the 30 Hz application cap. This supports eZ80-side work being
the bottleneck at normal speed; the emulated VDP keeps up at that rate.
It does not establish 60 Hz capability. The newer RALLY-15 resident-section
renderer was not part of these unlimited-CPU runs.
