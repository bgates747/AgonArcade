# Same moving pattern: sampler improves completed frames by24.2%

The accepted approaching/passing traffic pattern runs at **35.35 nominal MOS
FPS** with the additive sampler, versus **28.46** with the affine baseline:
**+24.22%**, saving **6.85 nominal ms/frame**. PRT independently gives **+24.26%**.
Both run orders improve. All four900-frame runs pass the same state/transport/
cleanup checks, and their complete timed outbound UART streams are byte-identical.
These are silent Oryx Flexe estimates; physical hardware remains untested.

## Matched completed-frame results

| Order | Renderer | Nominal MOS FPS | Nominal PRT FPS |
| --- | --- | ---: | ---: |
| First pair, first | Affine baseline | 28.1837 | 27.2191 |
| First pair, second | Additive sampler | 35.2711 | 34.0948 |
| Reverse pair, first | Additive sampler | 35.4331 | 34.2388 |
| Reverse pair, second | Affine baseline | 28.7387 | 27.7778 |
| **Pooled,1800frames each** | **Affine baseline** | **28.4585** | **27.4956** |
| **Pooled,1800frames each** | **Additive sampler** | **35.3519** | **34.1666** |

Pooling divides total completed frames by total elapsed time. Nominal MOS frame
time falls35.1389→28.2870ms. The old42.4%gain belongs to the earlier constant-gap
workload; it is not the gain for this motion pattern. Do not combine those runs
or the30Hz-paced human review with this comparison.

MOS assumes120units/s. PRT assumes the nominal emulated18.432MHz instruction
clock/18432clocks per interrupt; absolute clock readings differ. Host durations
include setup/teardown and are saved separately. Timed samples0→900 bracket900
completed, post-swap-fenced frames; the trailing sample is outside that interval.

## What was held equal

1. Both variants use the accepted review's exact21600-byte motion table, fixed
   three-lane updates and clean-MOS-exit driver. All six cars approach/recede over
   the same62scale values. The sampler tape matches the accepted review after
   removing its single foreground deadline. Stock swap/VSync remains on both.
2. There are900frames/3600source physics ticks per run. Timed command records,
   camera/player behavior, road bitmap renderer, split clear, artwork/assets,
   runtime and rendering fences are identical. The baseline is the existing
   Native-span/split-clear renderer with general affine actor scaling; the
   candidate changes car/sign sampling only. Neither native module was rebuilt.
3. The actual transmitted stream is **347bytes/frame** on both, including70bytes
   for scripted station/lane updates. All four312300-byte timed frame streams
   match exactly, including all900 motion packets. Their SHA256 is
   `370d42da5e5f05c6824e65862e5f1d5cec531e8f473deaa15cbb0014d8a88f45`.
   Resident VDP drawing commands are produced by each renderer and are not UART
   payload. Setup differences required by the sampler remain outside timing.
4. Every run validates2913retained replies, suppressed checks, exact scripted
   positions/lanes and independent player station, complete final root/array
   equality, unchanged inputs, PRT restoration, StopRace/UNLOAD, clean MOS return
   and zero backend errors. Final captures show MOS; they are not a per-frame
   image comparison. The Author accepted the moving sampler visuals and exit.
5. All four runs share one host boot/session, with both SDL drivers dummy and
   boost disabled under the existing monitor. Maximum sampled temperature56°C;
   boost restored to1 after all owned emulators stopped. Earlier CPU-heavy jobs
   were absent before this session. No physical media or firmware was changed.

The fixture keeps four simulation steps per render. It does not establish an
independent120Hz physics scheduler, playable-game throughput,60Hz rendering,
isolated phase costs for the new scene, or physical hardware FPS.

## Preserved exclusions and artifacts

The first baseline run passed but its sampler partner stalled during startup,
before timed frames; guarded abort preserved the incomplete pair. The next
session hit95°C at its initial check and aborted before launching an emulator.
Both are excluded. After the Author reported other jobs complete,49°C/idle-host
checks allowed the unchanged fresh02profiles to complete under the same guard.
No fixture patch or weakened guard was used to obtain the qualified runs.

[Machine-readable results](RESULTS.json), [input/byte matching proof](MATCH-PROOF.json),
[exact portable inputs/modules/firmware](PORTABLE.zip), [archive hashes](PACKAGE.json),
[raw evidence](evidence/) and [final verification](VERIFICATION.json) preserve the
comparison. Previous equal-speed and paced-review inputs remain unchanged.
All new work remains uncommitted; hardware and further optimization await scope.

Regenerate the report and archive without running an emulator:

```bash
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/incremental/sprites/motion-comparison/report.py
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/incremental/sprites/motion-comparison/package.py
```
