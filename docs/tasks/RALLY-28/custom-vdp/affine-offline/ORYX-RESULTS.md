# Same affine checks on Oryx

The identical stock-VDP suite passes on Oryx: 124 full batches, 497 required replies and the same 110,240-byte application command stream as Pi. All 640 native host samples also pass, with identical cross-architecture pixels/checksums. Rebuilding matrices adds avoidable setup work; generating a transformed bitmap for every draw costs more than cached direct affine in these tests. This does not establish that the stock API is generally inefficient.

The two emulator clocks still disagree. Keep the native host CPU costs and raw emulator counts below separate; neither measures physical ESP32 milliseconds. No game or firmware change is adopted.

## Framerate — the primary result

**This affine investigation did not measure complete-race FPS. It draws isolated objects repeatedly, with no complete race frames or timed swaps. Therefore cached-bitmap FPS, cached-affine FPS and their game-framerate difference remain unmeasured.** The reported 4.4× near-car host draw advantage is not a 4.4× game FPS improvement.

The latest existing complete-race Oryx Flexe measurements are below. These are prior comparison results, not new outcomes of this affine probe:

| Complete-race renderer | Measured frames | Nominal MOS FPS | Nominal PRT FPS |
| --- | ---: | ---: | ---: |
| Original full-race baseline | 1,800 | 14.45 | 13.96 |
| Native road spans | 3,600 | 25.73 | 24.86 |
| Accepted additive actor sampler / byte fills | 3,600 | 31.76 | 30.68 |

**Calculation:** completed frames ÷ elapsed seconds; each row pools executable-identical repeats by total frames/total elapsed, rather than averaging FPS. Elapsed seconds are MOS units/120 or PRT counts/1000, reported separately. [Original full-race data and clock limits](../full-race/RESULTS.md). These are nominal emulator throughput measurements, not physical hardware FPS.

The missing comparison is the same complete-race workload with cached direct affine versus retained prepared bitmaps, including size changes, cache misses/generation, memory use and the final rendering fence. Report completed frames, elapsed time, FPS and FPS change first; isolated draw costs support that result. This is a proposed next experiment, not an implemented candidate or a new test release.

## Native Oryx CPU checks

Median microseconds per operation, five samples per method/case. These execute extracted stock kernels on the x86 host with GCC 15.2, boost disabled; they are not emulated VDP times. The inverse setup is an analytic diagonal host model, not the old firmware library. The original artwork, source and methods are unchanged from Pi.

| Case | Cached direct affine µs | Generate + ordinary plot µs | Ordinary prepared bitmap µs |
| --- | ---: | ---: | ---: |
| traffic-far | 0.155 | 0.308 | 0.059 |
| traffic-middle | 3.556 | 6.289 | 0.874 |
| traffic-near | 38.522 | 63.386 | 8.663 |
| sign-far | 0.516 | 0.810 | 0.206 |
| sign-near | 2.578 | 10.339 | 0.958 |
| player-fixed-mirror | 38.881 | 65.975 | 8.814 |

The prepared-image column excludes its one-time generation. No pre-scaled files or timed pixel uploads are used. Stock transform-to-bitmap has its natural extra output border and generates the full rectangle before plotting clips it; the near sign is mostly offscreen. The player mirror is synthetic: the actual recorded player draws are ordinary identity plots. ASan/UBSan and the independent raw/assembly audit pass. The empty-loop controls hit the repetition cap at 8.37–9.09 ms rather than the 40 ms calibration target; nonempty batches span 37.32–83.90 ms. No automatic empty-loop subtraction is used. The Pi measurements remain in [their unchanged report](RESULTS.md).

## Stock-VDP completion-fenced batches

Official VDP 2.16.0, MOS 3.0.2, guest/config/artwork and operation order are byte-identical. ARM and x86 runtime binaries are built privately from the same pinned frontend/core source. Each timed batch sends one six-byte resident CALL and includes stock flush/keyboard-callback completion; warm drawing and marker readback are outside the timed interval. No timed swaps occur.

| Case | Prepared plot PRT counts/op | Cached affine | Rebuilt affine | Generate + plot | Matrix only |
| --- | ---: | ---: | ---: | ---: | ---: |
| traffic-far | 0.1328 | 0.1602 | 1.2773 | 0.3281 | 0.2524 |
| traffic-middle | 0.1953 | 0.8828 | 1.9883 | 1.1641 | 0.2563 |
| traffic-near | 0.7305 | 7.3906 | 8.5195 | 8.6133 | 0.2539 |
| sign-far | 0.1406 | 0.2305 | 1.3086 | 0.3711 | 0.2505 |
| sign-near | 0.2227 | 0.6875 | 1.7656 | 1.6953 | 0.2529 |
| player-fixed-mirror | 0.7539 | 7.5312 | 8.7344 | 9.4258 | 0.2573 |

**These are raw PRT IRQ counts, not milliseconds or Xtensa cycles.** Drawing batches use 128 operations/four samples; matrix-only batches use 1,024. The separate empty control has median 0.0742 counts/op and is not automatically subtracted.

Full-run timed totals are 39,309 PRT counts and 1,958 MOS units. Nominal conversions disagree by 2.4091×, versus 4.4988× on Pi; 10 batches have zero MOS delta. The source audit establishes separately scheduled eZ80 PRT and native-raster/MOS progress. Faster host execution reduces the discrepancy but does not calibrate either clock. Whole-run host elapsed is 49.17 seconds versus 83.09 on Pi, including startup/loading/warming/readback/files/cleanup; it is not isolated draw time. [Independent cross-host audit](ORYX-COMPARISON-AUDIT.md).

## Practical findings and remaining limit

1. Reuse unchanged matrices. Replacing one invalidates its cached inverse; the next affine draw rebuilds it. The frozen baseline audit finds 64.29% of actor rebuilds repeat the previous coefficients. The accepted additive native renderer already avoids those affine calls; no new game FPS gain or UART saving is claimed.

2. Rendering cost grows with the sampled destination rectangle, including transparent samples. Cached direct affine avoids repeated output allocation and can clip before sampling. Regenerating a transformed image on every draw adds work; reusing a prepared image moves that work outside the repeated draw. Bounded caching remains a separate proposal.

3. Exact physical drawing time remains open. Preserve this same portable fixture for a later authorized hardware run; do not infer physical timing or a 60 Hz game result from host timings or these emulated raw counts.

Both Oryx emulator attempts pass first try: smoke 7.12 seconds/full 49.17 seconds. Private runtime build takes 56.51 host seconds; host compile/sanitizer/timing takes 55.00 seconds. Every guarded session keeps boost0 and restores original1; maximum temperature is 62°C under the original95°C limit. Both SDL drivers are dummy, every emulator is stopped and all 81 frozen inputs/Pi evidence files remain unchanged. Oryx is free. No graphical/audio launch, hardware operation, game/firmware edit, commit or push occurred.
