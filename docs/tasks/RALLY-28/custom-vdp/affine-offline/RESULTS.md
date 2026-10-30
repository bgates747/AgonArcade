# Isolated affine results on Pi5

Stock direct affine plotting is measurably more work than an ordinary plot of an already resized image. Generating that image afresh and then plotting it is slower than cached direct affine in these host checks. Reusing a prepared image is a different workload. The stock API itself is not judged generally inefficient.

All 124 standalone stock-VDP batches pass their independent command/reply and cleanup audit. The Pi emulator’s independently scheduled clocks disagree, so this test does not establish calibrated VDP milliseconds. Host CPU times below are valid for this Pi5 process; they are not ESP32 timings. No game change is adopted.

## Actual host CPU cost

Median microseconds per operation, five samples per case; actual original artwork and observed placements, except the explicitly forced player reflection. Stock cached matrix, clipping, alpha and VGA64 pixel setter paths execute in the extracted host code. Each method reverses order on alternate trials.

| Case | Cached direct affine | Generate bitmap + ordinary plot | Ordinary prepared bitmap |
| --- | ---: | ---: | ---: |
| traffic-far | 0.234 | 0.515 | 0.076 |
| traffic-middle | 6.253 | 9.157 | 1.132 |
| traffic-near | 62.258 | 90.256 | 10.838 |
| sign-far | 0.781 | 1.299 | 0.242 |
| sign-near | 4.213 | 14.987 | 1.177 |
| player-fixed-mirror | 63.625 | 97.974 | 11.473 |

1. The prepared-image column excludes its one-time generation; the generate-and-plot column includes host allocation, sampling and plotting on every operation. Original full-size art is loaded once; no pre-scaled artwork files or timed pixel uploads are introduced.

2. Direct plotting clips before sampling. Natural transform-to-bitmap generates the whole resized rectangle before the ordinary plot clips it. The observed near sign is mostly off the left edge, making that distinction especially visible.

3. Stock natural output has an extra border relative to direct affine bounds. Thirteen selected cases agree exactly; right/bottom clipping and the synthetic all-opaque case differ by 11/15/53 pixels respectively. These are reported stock edge conventions, not a reason to pursue pixel-exact repair in this investigation.

4. All 43 original images were recovered and hash-checked. Timings cover 14 selected real/synthetic poses plus opaque/transparent controls, not every one of the 2,737 unique measured draw combinations. All 900 observed player draws are ordinary untransformed plots; the forced mirror and identity-affine controls must not be charged to that accepted fixture.

5. HOST-pi01.csv preserves 640 raw samples and both thread CPU and host wall clocks. ASan/UBSan checks pass. HOST-AUDIT independently verifies arithmetic, source identity and actual compiled per-iteration work. The host inverse is an explicit analytic diagonal model; its setup numbers do not measure the old firmware’s allocating matrix/inverse library.

## Standalone stock-VDP execution

Official unmodified VDP 2.16.0 and MOS 3.0.2 run on a privately built ARM64 Flexe runtime. Mode136 draws into the hidden page without timed swaps. Each batch sends one six-byte CALL to already resident commands, then waits for the stored graphics flush and keyboard callback. The subsequent marker readback is outside timing. Source artwork, matrix input, output allocation/replacement and callback/timer restoration are explicit.

| Case | Cached affine PRT ticks/op | Rebuilt affine PRT ticks/op | Generate + plot PRT ticks/op | Prepared plot PRT ticks/op |
| --- | ---: | ---: | ---: | ---: |
| traffic-far | 0.3672 | 2.9258 | 0.6953 | 0.3125 |
| traffic-middle | 1.4609 | 4.0586 | 2.0312 | 0.4375 |
| traffic-near | 11.7188 | 14.4102 | 14.6211 | 1.5039 |
| sign-far | 0.4648 | 3.0469 | 0.7969 | 0.3398 |
| sign-near | 1.1719 | 3.7891 | 3.0156 | 0.5273 |
| player-fixed-mirror | 12.0938 | 14.7812 | 15.8125 | 1.6328 |

**These are raw eZ80 PRT counts, not calibrated render milliseconds or Xtensa cycles.** Every drawing row uses 128 repetitions and four samples. Matrix-only rows use 1,024 repetitions, with no inverse generation inside their repeated body. Empty CALL/fence controls remain separately reported, without automatic subtraction.

The measured batches total 72,880 PRT counts versus 1,944 MOS units. Nominal conversions disagree by 4.4988×, and 13 batches have zero MOS delta. A single rescale is unjustified. PRT progresses on independently paced eZ80 cycles while MOS VSync depends on native I2S raster progress; per-method waits can therefore include host scheduling and emulation throughput. Hidden-page causation is unproved. TARGET-TIMING-AUDIT preserves the source evidence and every raw MOS/PRT row.

The full run took 83.09 host seconds including startup, warm operations, readback, file output and cleanup. It passes 124 batches/497 ordered completion/readback packets, exact inputs, zero backend faults and clean MOS return. A prior corrected smoke passes 11 batches. The earlier missing-feature smoke is excluded; two startup stalls are retained before the fresh identical smoke succeeded. No firmware, UART-buffer, clock or guest-transfer workaround was introduced.

## What the source/workload audit establishes

1. Replacing a transform matrix discards its cached inverse. The next transformed draw computes and retains another inverse; unchanged matrices reuse that cached inverse. The old affine actor helper currently rebuilds identity and six coefficients for every drawn actor.

2. In the exact 900-frame baseline replay, 3,129 of 4,867 traffic/sign rebuilds repeat the last coefficients for their matrix ID: 64.29% overall, 72.51% of traffic and 16.08% of signs. Plot position and artwork may still change, so those objects still need drawing. MATRIX-REUSE records cache ownership, warm state and invalidation constraints.

3. Omitting those repeated matrix commands would remove 84,483 resident command bytes in this native baseline, not that many bytes from the eZ80 UART. There is no measured FPS gain from that proposed change. The accepted additive actor renderer already bypasses these affine calls; this finding primarily explains the old baseline and may inform the standard-VDP path.

4. Direct affine samples every pixel in its clipped destination box, including transparent source samples. Transform-to-bitmap also allocates/replaces an image and samples its natural rectangle. An already prepared bitmap avoids that repeated transformation work; bounded reuse/caching remains a separate proposal.

No new game optimization, hardware deployment or publication was performed. All work remains uncommitted. SOURCE-ROUTES, SOURCE-MANIFEST, WORKLOAD and the two independent audits preserve implementation details and limits.
