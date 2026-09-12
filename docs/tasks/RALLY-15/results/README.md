# Full road rendered by resident VDP sections

The complete marked road now runs through stock VDP resident programs.
Controlled headless fixed-pose measurements average **22.59 FPS on the oval**
and **23.63 FPS on Fuji**, versus 7.71 and 8.16 for the frozen full-road control.
Pavement, kerbs, shoulder lines, centreline, vehicles, background and HUD remain.

| Track | Control | VDP sections | Candidate frame time | 60 Hz budget | Still over budget |
| --- | ---: | ---: | ---: | ---: | ---: |
| Tri-oval | 7.71 FPS | 22.59 FPS | 44.27 ms | 2.66× | 27.60 ms |
| Fuji | 8.16 FPS | 23.63 FPS | 42.32 ms | 2.54× | 25.65 ms |

The target is 16.67 ms/frame. These are preliminary emulator batch equivalents,
not a physical-hardware measurement. The unchanged four-tick scheduler caps
submissions at 30 Hz before workload delays. This experiment does not change
pacing or claim that removing that cap alone would achieve 60 Hz.

## What moved and what remains

1. Road geometry falls from 46.35/47.27 ms to 2.08/1.82 ms per frame in these
   runs. Command construction falls from 34.64/28.65 ms to 4.17/3.52 ms.
   The eZ80 selects precomputed row boundaries and projects only their centres.
   It no longer classifies or projects every road row, computes strip widths,
   or expands each strip's PLOT vertices. Traffic requests its centres directly
   during submission, so that small projection cost appears in submission.
2. Road UART traffic falls from 2,281/1,763 to 514/403 bytes per frame,
   approximately 77% less. A section sends eight endpoint bytes inside a
   25-byte update/call. The VDP derives the transform, expands all strip
   vertices and executes the drawing buffer. Startup uploads 864 bytes once.
3. The conservative first pass averages 19.36/14.92 sections per fixture
   frame. It reuses the existing curve tables and adds a 5,778-byte exact phase/
   depth lookup. This exceeds the earlier minimum-fitting audit deliberately.
   The candidate binary is 134,184 bytes, 4,947 bytes larger than the control.
4. Submission still averages 20.57/18.36 ms, and completion waits 17.19/17.97 ms.
   Submission includes scenery, cars, HUD, UART backpressure and drawing calls.
   The post-swap poll covers the queued frame. Neither stage isolates actual
   VDP raster time. The accurate eZ80 instruction model is useful evidence;
   native VDP, UART and host scheduling are a different fidelity question.

## Ordinary gameplay with physics

Separate 20-second headless demo runs, with moving traffic and normal physics,
produced the following. They are not fixed-pose renderer A/B comparisons, and
sample only the opening portion of each track. All 880 submitted frames were
acknowledged without timeouts or omitted records.

| Track | Demo FPS | ms/frame | 60 Hz budget used | Still over budget |
| --- | ---: | ---: | ---: | ---: |
| Tri-oval | 18.77 | 53.28 | 3.20× | 36.61 ms |
| Fuji | 25.20 | 39.68 | 2.38× | 23.02 ms |

These samples include the existing physics and scheduling behavior. Host load
was approximately 35–52. [Original CSVs and manifest](demo/manifest.json)
record the same candidate binary and the absence of capture instrumentation.

## Detailed fixed-pose evidence

See [the full table](table.md), [machine-readable summary](summary.json),
[runtime/build manifest](manifest.json) and the adjacent original CSVs.

## Measurement scope and variation

Each track ran control/sections/sections/control, 64 deterministic poses per
run plus two unmeasured warm-ups. All **512 measured frames were acknowledged**;
there were no dropped records or poll timeouts. Pose hashes match within each
track, and road-byte counts repeat exactly. Both variants show six opponents
and retain the same player, reflection setting and scenery. The fixture excludes
elapsed-time physics; its physics column measures only fixture setup.

All runs were serial, using SDL dummy video/audio and the canonical stock
software-renderer wrapper, with no capture interposer. One-minute host load
was approximately **44–79** during this comparison. Candidate runs ranged
39.06–49.48 ms/frame on the oval and 33.85–50.78 ms on Fuji. The reported
averages use all runs, not the fastest samples. The improvement is substantial
across every pair, but this host variation prevents a precise stable-rate claim.
The two-raw-tick clock resolution also makes individual stage samples coarse.

## Correctness and isolation

1. The frozen control rebuild reproduces mainline SHA-256 exactly:
   `d08300dc7c0b4ab9b55dbbafc7cf3ba02c1f6e9cb42b8b828385751e1e6aa920`.
   Candidate SHA-256:
   `0081dc8164dbfb259f97f6cde29a3f0cc47d599cf1a76c8b218d74bab8c4cfaf`.
   Builds and all tests use task-local copies. Mainline source, assets and
   binary fingerprints remain unchanged from the pre-build snapshot.
2. Existing Linux ASan/UBSan checks pass, as do the candidate's focused tests.
   They exhaust all 8,000 phases and all curve-table/material combinations.
   Every combination fits in the stream: maximum 32 sections / 830 bytes.
   Another 106,032 held-out camera views show at most 0.447917 px geometric
   interpolation error. This is sampled geometry evidence, not exhaustive
   native raster equivalence. [Geometry details](../geometry-notes.md).
3. Five protocol tests check actual wire decoding, independent endpoint math,
   retained templates, shared-boundary precision, signed coordinates, zero
   padding and compiled C++ byte parity under sanitizers.
   [Protocol details](../protocol-notes.md).
4. The twelve-section native probe, including one-/two-row bands, strong skew,
   negative coordinates, clipping and both patterns, is pixel-identical to its
   independent direct-PLOT reference. Both runs acknowledge completion.
   [Comparison](probe/comparison.json), [resident capture](probe/resident-frame-300.png),
   [direct capture](probe/direct-frame-300.png).
5. Separate headless game captures cover both tracks, demo, manual takeover,
   right and left steering, traffic, off-road movement and Escape to MOS.
   [Oval demo](visuals/oval-frame-600.png), [Fuji demo](visuals/fuji-frame-600.png),
   [right steering](visuals/oval-frame-720.png),
   [left steering](visuals/oval-frame-840.png),
   [MOS return](visuals/fuji-frame-900.png).

The capture harness's requested native emulator quit still produces the
pre-existing mutex/SIGABRT shutdown failure after captures are saved; an earlier
capture also ended with SIGSEGV. In-game Escape returns to MOS successfully.
These are not clean native-shutdown results, and no emulator fix is included.

Human acceptance and hardware validation remain pending. All implementation
stays in this [task bucket](../README.md); no mainline promotion or hardware deployment has occurred. The Author
authorized a development checkpoint commit on 2026-09-12.
