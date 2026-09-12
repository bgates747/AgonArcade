# Controlled workload results — RALLY-10, iteration 2

The controlled Mac samples identify **road-band generation and command-stream
construction as the largest measured stage**, followed by road geometry.
They do not establish individual VDP primitive costs or hardware performance.
No rendering optimization or gameplay tuning change was made in this iteration.

## Method

1. Each run renders the same 64 poses around one tri-oval lap, indexed by
   submitted frame rather than elapsed time. Six cars stay at fixed relative
   distances of 160, 250, 340, 430, 520 and 610 world units, in their existing
   three lanes. The player uses view 3 with zero lateral offset. Reflection
   changes only its affine reflection selection. Physics and demo steering are
   excluded: the `physics` column measures pose setup/input overhead here.
2. Two unmeasured, fenced warm-up frames at pose zero initialize both buffers.
   All variants upload the same resources and use the same HUD and road stream.
   Startup is fenced. The baseline's final drain is included in batch duration.
   Scenery-off substitutes a plain blue rectangle; traffic-off omits opponent
   commands. The light variant removes stage clock reads and row storage but
   keeps scheduling, fences, workload hashes and whole-batch timing.
3. Twelve serial headless runs cover baseline, fence, scenery-off, traffic-off,
   player reflection and light instrumentation, in forward and reverse order.
   One reflection outlier prompted four additional ABBA runs of full/reflected
   scenes. The focused repeat did not reproduce that large slowdown.
4. All 16 runs submitted exactly 64 measured frames. Pose hash `1844998336` and
   road payload `98931` bytes match across every run. All 896 fenced measured
   frames received replies, with zero timeouts or omitted records. Two light
   runs intentionally record only batch summaries; they do not contain frame rows.
5. Tests confirm fixture equality on Fuji and tri-oval, equal player anchors and
   yaw view across reflection variants, fixed traffic distances, and byte-identical
   road streams through the original combined call and split measurement path.
   Native Linux build and Mac/Linux ASan/UBSan checks pass. Binary: 106,761 bytes,
   SHA256 `2ca804042731898cd33d66d973d1fe2ae1a9d0d040deaa6760e56056993e0424`.
6. Fab 1.2.4, stock platform VDP/MOS 3.0.2, SDL dummy video/audio, software renderer.
   No capture interposer or graphical emulator ran during performance samples.
   The manifests record binary/runtime/source hashes, track, host and load averages.

## Findings

| Comparison | Observation |
| --- | --- |
| Road computation | Across four full-scene fenced runs, band generation/stream construction averages about 8.8 ticks (73 ms), geometry about 5.4 ticks (45 ms). Together they account for about 74% of the 64-frame batch time. |
| Traffic | Removing six opponents reduces mean command submission from about 3.09 to 1.94 ticks/frame in the initial pair, roughly 9.6 ms. Total batch reduction varies from 16 to 84 ticks (0.13–0.70 seconds), so it is a smaller contributor than road computation here. |
| Scenery | Full-scene batches: 1258/1244 ticks; scenery-off: 1242/1246. These samples do not resolve a consistent useful reduction. |
| Reflection | Initial reflected runs: 1260/1602 ticks. The slow run coincided with load average increasing from 8.21 to 24.85. Focused ABBA: full 1238/1204, reflected 1236/1234, with identical mean submission time. No large repeatable reflection penalty is established on this Mac. |
| Fence | Baseline batches: 1188/1188 ticks; initial fenced batches: 1258/1244. Waiting did not improve throughput in this fixture. It still provides an explicit acknowledgment boundary. |
| Timing overhead | Light batches: 1268/1258 versus instrumented 1258/1244. Removing detailed timing did not measurably speed up these samples; this does not prove zero overhead. Host variation and residual batch instrumentation limit the estimate. |

Times use 120 MOS ticks/second. Individual readings change in steps of two
(about 16.7 ms); averaging many samples permits fractional-tick averages but
does not improve single-operation clock resolution. Counts are submissions and
poll replies, not unique SDL presentations or physical monitor frames.

`geometry` covers `Road::project`: track interpolation, coordinate projection
and material selection for rows. `bands` covers `Road::emit`: greedy band search,
edge calculations and VDU stream construction. It does **not** measure drawing
those primitives on the VDP. `submit` includes CPU work for scenery, traffic and
HUD plus UART/backpressure. These are not isolated VDP execution durations.

The Mac was shared and background load varied substantially. Native VDP code
runs on x86 while game code is emulated; the balance can differ greatly from
an eZ80 plus ESP32. Fixed lap-spaced poses also scroll faster than normal driving
and omit physics. Do not generalize these results to a hardware FPS or latency
claim, or rule out costly ESP32 affine operations from the Mac reflection result.

## Next review decision

The strongest next CPU target under RALLY-10 is to separate greedy band search
from command encoding inside `Road::emit`, then test one optimization against
identical road bytes/pixels. RALLY-14 remains the task for high-resolution timing
inside the emulator/VDP and tagged callbacks to MOS; it is needed to rank actual
VDP drawing operations rather than infer them from command submission.

## Evidence and reproduction

[Initial table](table.md), [initial manifest](manifest.json),
[reflection repeat table](reflection-repeat/table.md),
[reflection repeat manifest](reflection-repeat/manifest.json). CSVs beside each
manifest are the exact reports, including completion markers.

```sh
make -C rally
.venv/bin/python docs/tasks/RALLY-10/run_timing.py --workloads --passes 2
.venv/bin/python docs/tasks/RALLY-10/run_timing.py --workloads --cases full-fence mirror-fence --passes 2
```

Visual captures are separate, still headless, using
`docs/tasks/RALLY-10/capture_workloads.py`. They are excluded from performance
evidence. Only the final graphical launch is the user's review alert.

Selected captures show [full scenery/traffic](visuals/full.png),
[reflected player](visuals/mirror.png), [scenery off](visuals/no-scenery.png),
[traffic off](visuals/no-traffic.png), [ordinary manual play](visuals/manual.png)
and [MOS exit](visuals/mos-exit.png). The selected full/reflected images match
exactly outside the player-car region. Other stills are not claimed to depict
the same pose. The normal game capture shows demo takeover and a +9 steering
HUD value after injected Right input, then Escape returns to MOS.

Capture shutdown remains imperfect in the native runtime: four requested quits
ended with the known mutex exception (SIGABRT); one ended with SIGSEGV and a
truncated libc++abi message after all captures were saved. That shutdown variant
was not root-caused here. Timing runs all produced complete valid reports and
were then terminated by the harness; none relied on capture-time measurements.
