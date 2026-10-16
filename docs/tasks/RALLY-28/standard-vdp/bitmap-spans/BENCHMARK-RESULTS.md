# RALLY-28 — Road benchmark tranche return

Checkpoint **94cf665** committed and pushed the updated task contract and all prior dirt before execution. SPAN-001-06–10 independent preparation is delivered. The most useful result is that **on-demand buffered polygons beat this bitmap implementation on the measured eZ80/Fab road workload**. The exact phase lookup helps bitmap preparation, but the bitmap method still computes 120 centres and has a substantial VDP-side cost in the short Flexe probes. Hardware must decide the physical result; no optimization has been adopted into the game.

**Subsequent physical return:** [all ten Olimex cases pass](SPAN-001-09/HARDWARE-RESULTS.md), including all four128frame drawing runs. Active frame-span throughput is9.761nominal PRT FPS for on-demand polygons versus2.614for lookup bitmaps; VDP-local complete means70.883/340.984ms. Whole diagnostic windows including record readout give7.588/2.429FPS. Actual isolated physics334.91ticks/s/all420fields passes; input/startup hashes unchanged. The physical result supports polygons over this bitmap implementation. Earlier emulator observations/limits below remain preserved; no sustained Flexe completion ratio or full-game cadence claim follows.

Raw summaries, per-frame observations and identities are under [SPAN-001-07/evidence](SPAN-001-07/evidence/). [Machine-readable results](BENCHMARK-RESULTS.json) are reproduced by repository `.venv/bin/python` running [summarize_benchmark.py](summarize_benchmark.py); this reads saved evidence only. Early invalid calibration versions are explicitly excluded in [VERSIONS.json](SPAN-001-07/VERSIONS.json).

## eZ80 work and completed Fab frames

These are road-only, unpaced fixtures. Each uses the same runtime Fuji projection, stripe phase and selected 35-pixel proportions. CPU runs cover 1,024 frames/eight complete 128-pose cycles; live Fab controls cover 512 frames/four cycles. Every final case below lasts at least ten host seconds. Host elapsed time is the independent throughput observation; PRT stages use nominal 1,000 ticks/second.

| Candidate | CPU-only wall ms/frame | PRT geometry ms/frame | PRT packing ms/frame | Fab completed FPS | Fab live wall seconds |
| --- | ---: | ---: | ---: | ---: | ---: |
| Buffered polygons, on-demand endpoints | **22.830** | 5.602 | 17.011 | **31.98** | 16.012 |
| Polygons, redundant all-row geometry control | 41.994 | 25.276 | 16.516 | 19.85 | 25.796 |
| Bitmap spans, original phase arithmetic | 32.753 | 25.283 | 7.334 | 24.78 | 20.660 |
| Bitmap spans, exact phase lookup | 28.437 | 25.279 | 3.002 | 27.74 | 18.459 |

The common-geometry polygon control deliberately evaluates all 120 row centres before its band construction. It isolates packing/emission, but is **not** the fair polygon CPU baseline. The separately compiled `POLYGON_SPARSE=1` control restores on-demand band endpoints and emits identical polygon commands. This prevents an apparent bitmap win caused by redundant work in the control. On-demand endpoints are part of the already recovered lookup architecture; they are not an undocumented new game change.

Lookup phase packing saves about 4.33 nominal PRT ms/frame, with unchanged records. It leaves about 25.28 ms/frame of geometry for the bitmap path. All 960,000 phase/row combinations pass independent ASan/UBSan verification; the target assembly removes the recurring divide/wide remainder from that phase calculation. See [phase proof](SPAN-001-06/README.md).

Fab uses its native host VDP module. These completed rates are emulator road throughput, without player physics, traffic, scenery, HUD or audio. They do not establish full-game FPS, physical VDP performance, a 120 Hz physics cadence or a final backend choice. Live Fab mean synchronous submission is 8.07 nominal PRT ms/frame for sparse polygons and 6.95 for lookup bitmaps; mean remaining completion waits are 0.50 and 0.82 ms. Submission and wait are included in the completed rates; they are not omitted wire costs.

## VDP-local ordered timing under Flexe

The [isolated diagnostic firmware](SPAN-001-08/README.md) executes actual ESP32 VDP code under Flexe. Parameters arrive before the resident begin marker. The frame executes, the normal graphics worker passes its completion fence, then the end marker's result is acknowledged. This measures elapsed command interpretation, buffer copies, matrix/drawing work, preemption and worker completion on the VDP's clock. It is not exclusive raster CPU time or physical scanout time. Diagnostic timing does not force foreground primitive execution with `waitCompletion(false)`.

Final short probes cover **16 opening-section poses**, with cold first-frame/cache effects included. The empty control covers 32 frames. They qualify the mechanism and local timing observations, not sustained full-track performance.

| Candidate | VDP submit mean ms | VDP complete mean ms | Complete median ms | Complete p95 ms | VDP drain mean ms |
| --- | ---: | ---: | ---: | ---: | ---: |
| On-demand polygons | 29.131 | **44.805** | 44.247 | 54.560 | 15.675 |
| Common-geometry polygons | 26.263 | **41.939** | 40.315 | 54.773 | 15.676 |
| Bitmap original arithmetic | 330.637 | **347.382** | 347.833 | 348.237 | 16.745 |
| Bitmap lookup | 330.728 | **347.427** | 348.695 | 349.209 | 16.698 |
| Empty bracket | 0.039 | 16.105 | 16.180 | 17.181 | 16.066 |

Units are **nominal emulated VDP microseconds divided by 1,000**, not calibrated hardware milliseconds. Their absolute scale differs substantially from eZ80/host wall time in these interpreter runs. The local bitmap interval is roughly eight times the polygon interval, but no physical ratio is claimed. Empty-worker scheduling is retained; it must not be subtracted as a universal constant. Sum identities `submit + drain = complete`, record identity/count checks and ordinary GP completion all pass. The recorder passes nine host ASan/UBSan order/overflow/wrap scenarios.

Whole diagnostic host windows include the stopped-record retrieval after each capture block. That retrieval is outside individual frame stage spans. For a 16-frame probe it sends 6,750 additional request bytes; reporting frames divided by the whole window as uninterrupted rendering FPS would misstate the workload. VDP and eZ80 intervals overlap and are on different clocks; do not add them or subtract one from the other. Fab stock controls and Flexe diagnostic controls use different completion/instrumentation commands; they are not byte-identical cross-backend comparisons.

## Sustained Flexe failures are retained

All three final 128-frame diagnostic cases hit the 300-second host bound. No sustained Flexe FPS or full-track VDP phase distribution is qualified. The captured prefixes match the independent host serializer; replies and partial uploads locate the stopped boundary without proving its cause.

| Final case | Complete frame replies | Verified complete uploads | Stopped boundary |
| --- | ---: | ---: | --- |
| Common-geometry polygons | 113 | 113 | Next 600-byte command body received only 377 bytes |
| Bitmap original arithmetic | 57 | 57 | Next 720-byte plane received only 595 bytes |
| Bitmap lookup | 83 | 84 | Next plane arrived, frame completion did not; cleanup also failed |

The lookup case saved 83 frame rows, `restored=0`, and `failure=mode/CLI restore`; cleanup overwrote the earlier failure label. Its VDP-record columns remain zero because the first 128-frame capture never reached readout. Those rows are failure evidence only. Polygon/original cases did not save terminal summaries. All backend records show zero unhandled/unregistered/unmapped errors; that does not establish correct flow control. No further retries or private emulator repairs were attempted.

[Wire receipts](SPAN-001-07/WIRE-PROOF.json) verify all 16 short-frame commands and the exact truncated prefixes above. Original/lookup bitmap short streams have identical SHA256 `cd829367e253a94b8d4302c9aea91eecb27ae84fa93b51a1abfb3b319575f125`. Compressed raw UART/log captures and their uncompressed hashes are preserved under [runtime evidence](SPAN-001-07/evidence/runtime/MANIFEST.json). Final/stale calibration artifacts remain separately named; rejected runs are not pooled.

## Bytes and actual physics

The final stock-mode benchmark averages 913.664 application bytes/frame for polygons and exactly 788 for bitmaps. The latter includes the 737-byte parameter update/CALL plus the recurring clear/completion wrapper patch. Diagnostic wrappers add their own bytes: 802/frame for bitmaps; polygon counts vary with bands/materials. Setup, explicit frame traffic and stopped-record retrieval are separately recorded. Replies and firmware mailbox instrumentation are preserved in raw captures. A one-write 737-byte sample does not mean the entire benchmark costs 737 bytes/frame, nor does smaller traffic guarantee faster drawing.

The new hardware-lifecycle wrapper around the **actual numerical physics** benchmark passes all 420 independently expected state fields after 8,192 ticks/four scenarios. It takes **24.4236 host seconds: 335.41 ticks/second**, versus 24,431 nominal PRT ticks and 2,932 MOS units. Its single-buffer entry mode and prior PRT state/vector are restored. It is a new executable with the old numerical workload, not falsely byte-identical to the old benchmark. No recurring render commands run inside the numerical kernel. This isolates capacity and is not integrated gameplay headroom; transport, frame preparation and bounded physics service still need measurement together.

## Olimex package and chain handoff

[PORTABLE.zip](SPAN-001-09/PORTABLE.zip) contains **ten** independently invocable finite cases: actual physics; three CPU road cases; three live diagnostic road cases; empty bracket; on-demand polygon CPU/live controls. Each has its own directory, create-new result files, exact binary/config/table hashes and explicit MOS command file. The three common live 128-frame cases have exactly the frozen long-Flexe app/assets/config/diagnostic image bytes. CPU/physics controls were measured under Fab. The sparse live 128-frame configuration is prepared but only its 16-frame version was exercised here. The archive includes no autoexec. It has not been copied to a physical card or flashed.

The exact diagnostic image is 1,085,168 bytes, SHA256 **36edc736c992502367489c8ccea677d7aebb11d20371cd58cb0b91ef61df9f99**. It derives from the pinned stock-VDP 2.16.0 scrolling diagnostic; source export/build/protocol provenance is retained in SPAN-001-08. Official MOS 3.0.2 uses a read-only ordinary-GP nibble mailbox for record retrieval; no custom MOS is required by the emulator probe. Installing this diagnostic is a separate hardware action with rollback preservation.

The [Pi coordinator](SPAN-001-09/README.md) passes **12 offline lifecycle/failure scenarios**. It journals intent before device actions, requires fresh boot/foreground/CLI/runtime/input facts, settles mode switches for at least one host-monotonic second, verifies results before dispatch and stops after reset, cancellation, unknown foreground or uncertain restoration. It contains no reset/replay/startup-write/flash operation. Normal startup/reset behavior is unchanged.

`PLAN.json` remains `ready:false`, with an unqualified adapter, uncommissioned lock and unknown installed EMOS/P4 pins. Current bench ownership lies elsewhere; no live hardware query was made. [Adapter handoff](SPAN-001-09/ADAPTER-HANDOFF.md) lists the concrete missing capabilities. The useful next physical tranche is commissioning that adapter/bench access, then running these exact bytes and retrieving their own logs. It needs separate operational scope; the current unattended preparation is complete.

All automated sessions forced **both SDL dummy drivers**, monitored CPU boost disabled and stopped their owned processes. Canonical Flexe names/guards and unchanged profile input hashes were verified. No graphical/audio launch or peer source/mail operation occurred. All 101 preserved product/demo inputs checked against the previous audit remain unchanged, including the accepted game binary SHA256 `7f1620ed8139ee779e7d50e333ef572aeaf612a154e41ec574e63a57da760293`. New source/results are uncommitted for review.
