# Redundant road-clear removal: correct, small preliminary gain

Removing the road-area clear gives **26.33 versus 25.96 nominal MOS FPS**, a
pooled **1.41% increase**, in four completion-fenced Oryx Flexe runs. The final
captured images are pixel-identical and every authoritative final-state check
passes. Pairwise gains vary from 0.15% to 2.69%, so this sample does not establish
a stable 1.41% benefit or a substantial renderer improvement. Specialized
car/sign scaling remains the next stronger structural experiment; measure its
current phase cost and compare it independently.

All prior dirt and the [incremental plan](PLAN.md) were committed and pushed as
**b0bf5e7** before implementation. INC-001-01 is complete as a bounded experiment;
no product adoption, later modification or physical test is implied. New code
and evidence remain uncommitted for Author review/publication.

## What changed

1. The former clear covers x=0..319, y=24..239. The candidate retains two clears:
   sky y=24..103 and bottom y=224..239. The opaque road replaces every omitted
   pixel at y=104..223 before actors and presentation. This saves exactly
   **38,400 clear writes/frame** while preserving both pages, upper traffic
   restoration and bottom-strip behavior.
2. Splitting the rectangle adds **12 outbound command bytes/frame**: 265 becomes
   277 including all existing checked transactions and the final fence. That
   overhead is included in the measured result. No static-title caching, bottom
   initialization, scaler change or faster fill was combined with this change.
3. The only application-payload difference is one loop paint SEND and its length:
   110→122 payload bytes; tape size 63,623→63,635. Every other tape record is exact.
   Driver, Native-span module, artwork, all other assets, physics, firmware,
   runtime, swap and post-swap completion check are unchanged. Module SHA256 is
   `d178334e4d4beb8a3df326e70ffabae87ff16d0a193b972be15ac3078d1ca4bb`.

## Matched completed-frame results

Each run contains 900 completed frames and 3,600 simulation ticks. CPU boost is
off throughout the comparison, both SDL drivers are dummy, and all runs share
one host boot. Foreground pacing is absent; stock swap/VSync remains.

| Order | Case | Nominal MOS seconds | Nominal MOS FPS | Nominal PRT FPS |
| --- | --- | ---: | ---: | ---: |
| First pair, first | Control | 34.3500 | 26.2009 | 25.3129 |
| First pair, second | Split clear | 34.3000 | 26.2391 | 25.3607 |
| Reverse pair, first | Split clear | 34.0667 | 26.4188 | 25.5377 |
| Reverse pair, second | Control | 34.9833 | 25.7265 | 24.8612 |
| **Pooled control** | **1,800 frames** | **69.3333** | **25.9615** | **25.0850** |
| **Pooled candidate** | **1,800 frames** | **68.3667** | **26.3286** | **25.4489** |

Pooling uses completed frames divided by total elapsed seconds, not an average
of FPS. Nominal MOS average frame time falls from 38.5185 to 37.9815 ms, a
0.5370 ms difference. The PRT result rises 1.45%; it is reported separately.
Pairwise MOS changes are +0.1458% and +2.6908%. Control repeats themselves differ
by about 1.8%, so the small aggregate gain needs cautious interpretation.

These are the existing fixture's completion-fenced pipeline times, including
physics, native construction, drawing, UART/checks and swap. They do not isolate
the clear routine or VDP CPU time. MOS assumes nominal 120 units/s; PRT assumes
the emulator's nominal 18.432 MHz instruction clock. Neither is a calibrated
physical ESP32 clock. Host durations including startup/teardown are preserved
separately: 44.023, 44.013, 43.633 and 44.651 seconds in run order. No hardware
FPS, autonomous physics cadence or 60 Hz capability is established.

## Correctness and teardown

1. All four runs pass 2,913 retained replies each, the guest's suppressed checks,
   independent final root/arrays, input hashes, PRT vector restoration, clean
   exit and zero backend error counters. No failed emulator attempt occurred.
2. A six-case two-page model starts with arbitrary differing old pixels and
   proves equality after the opaque road replacement. Existing ordinary and
   sanitized 900-frame independent span-raster qualifications remain unchanged.
   [Clear/source proof](CLEAR-PROOF.json).
3. All four 320×240 RGB shutdown captures are identical: **zero changed pixels**
   across the full image, including the road. They occur after saving/DONE text
   and MOS return, so they are not per-frame capture instrumentation or the
   Author's moving visual review. The exact clear/coverage proof applies to
   every frame; original captures remain under [evidence](evidence/).
4. Original boost 1 was restored to 1 after stopping owned emulators. Maximum
   sampled temperature was 60°C; the session lasted 176.761 host seconds.
   Independent post-run process inspection found no Flexe/Fab emulator.
   [Session receipt](SESSION-incsession01.json).

## Disposition and reproduction

**Retain as an isolated, correct candidate; do not call it a major performance
win or silently adopt it into the games.** It removes confirmed waste, but the
sample shows a small and variable completed-frame difference. The next proposed
INC-001-02 examines general affine sprite scaling, including transparent padding,
before more extensive compositor or protocol work. Its implementation is not
released by this result.

[Machine-readable results](CLEAR-RESULTS.json), [first pair](CAMPAIGN-incab01.json),
[reverse pair](CAMPAIGN-incba01.json), [fixture registry](FIXTURES.json),
[portable exact inputs](CLEAR-FIXTURES.zip), [archive manifest](CLEAR-PACKAGE.json).
The immutable checkpoint preserves all old throughput/Wolf evidence. Historical
registries/reports were not regenerated or overwritten.

Recompute the report locally without launching an emulator:

```bash
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/incremental/clear_report.py
```

`clear_test.py prepare` creates fresh derived fixtures and refuses to overwrite
its registry. `stage NEWCAMPAIGN clear-control clear-split` stages fresh stopped
profiles through the pinned canonical staging tool. `session NEWSESSION ...`
uses the existing approved Oryx boost/thermal supervisor and silent runner.
Never reuse a measured profile or overwrite old evidence. Exact binary inputs
are also retained in the archive; no application compilation was necessary.
