# Independent target timing audit

The full01 functional test remains valid: 124 batches and 497 checked completion packets pass. Its clocks disagree and are not calibrated render stopwatches. Across timed batches, 1944 MOS ticks and 72880 PRT ticks correspond to diagnostic nominal totals of 16.200 versus 72.880 seconds, a 4.4988× difference. Thirteen batches recorded zero MOS ticks.

The exact privately built frontend still gates eZ80 VSync pulses on changes in the native I2S raster counter. PRT advances from separately paced eZ80 instruction cycles. The adapter counts complete raster frames without checking image content or page swaps. That establishes a clock-domain mismatch; it does not prove that hidden-page drawing itself causes the observed slowdown.

| Method | Batches | MOS ticks | PRT ticks | Nominal PRT/MOS ratio | Zero-MOS batches |
| --- | ---: | ---: | ---: | ---: | ---: |
| empty | 4 | 2 | 94 | 5.6400 | 3 |
| ordinary-sized | 24 | 88 | 2439 | 3.3259 | 5 |
| cached-affine | 24 | 370 | 13981 | 4.5344 | 5 |
| rebuilt-affine | 24 | 526 | 22019 | 5.0233 | 0 |
| transform40-plot | 24 | 648 | 18916 | 3.5030 | 0 |
| matrix-only | 24 | 310 | 15431 | 5.9733 | 0 |

The pinned MOS handler bytes confirm an increment of 2 per VBlank pulse. All 124 observed MOS deltas are even and every submission/wait PRT split adds exactly to its total. The ratio varies from 1.44× to 7.78× among rows with nonzero MOS time, so a single conversion-factor adjustment cannot reconcile these columns.

The whole session produced 1312 native raster frames over 83.086 host seconds. The backend counted 5504323239 modeled native cycles, equivalent to 22.935 seconds only under its nominal 240 MHz conversion. These totals include setup, untimed checks and teardown; they do not timestamp individual measured batches.

The demonstrated source behavior is:

1. The exact frontend emits an eZ80 GPIO VSync pulse only when its periodically sampled native_frame_count differs from the preceding sample. It emits at most one pulse per presentation-loop iteration, even if multiple native frames elapsed.
2. The exact adapter increments native_frame_count when I2S data forms a complete scan raster with the selected modeline geometry. This code contains no image-change, swap or displayed/hidden-page condition.
3. The pinned MOS binary VBlank handler adds 2 to its 32-bit clock variable for each handled pulse; map addresses and exact instruction bytes were checked.
4. The exact eZ80 model applies emulated instruction cycles to PRT and UART and independently paces that CPU against host millisecond slices. Default 18.432 MHz is selected because the recorded launch has no unlimited-CPU option.
5. The guest configures PRT1 reload 1152/divide 16 and counts its IRQs. This is nominally 1000 interrupts per second of 18.432 MHz eZ80 progress, subject to interrupt servicing and quantization.
6. The native ESP32 worker separately advances its modeled CPUs and limits modeled 240 MHz progress from exceeding host real time; on a slow host native progress can be slower. Its clock is not locked to eZ80 PRT or the host presentation loop.
7. Full01 measured rows therefore sample clock domains with different progress rules while the eZ80 waits on VDP work. They cannot be treated as two calibrated wall stopwatches.

Interpretation limits:

1. The observed nominal-clock disagreement is real and cannot be explained by changing only one seconds-per-tick constant: aggregate ratios differ by method and 13 rows have zero MOS ticks.
2. The source establishes native-frame coupling and independent CPU pacing. Full01 contains no per-batch native-cycle/frame timestamps, eZ80-cycle snapshots or synchronized cross-direction UART timestamps, so the exact contribution of gating, coalescing, CPU emulation throughput and host scheduling is not measured.
3. Hidden-page/no-swap is a fixture difference, not a demonstrated root cause. Complete native scan frames are counted independently of page changes, and full01 produced 1312 native frames.
4. PRT counts are eZ80 timer IRQ counts while waiting for the separately scheduled VDP worker; they are neither Xtensa cycles nor physical milliseconds. Within-fixture raw comparisons are descriptive of this runtime/host session and may include host scheduling effects.
5. MOS ticks in this runtime are coupled to native frame delivery and are unsuitable for converting these batches to render milliseconds or FPS. Timeout deadlines based on that clock can also stretch, although no full01 timeout/fallback was used.
6. The 72.880 and 16.200 nominal-second totals cover only timed batches, whereas 83.086 host seconds and native backend totals cover the whole session. Their comparison is diagnostic only, not interval-matched calibration.
7. The successful independent verifier qualifies exact command/completion order, final marker writes, logs, identities and clean MOS exit. It does not qualify clock calibration, scanout rate, full-game throughput or physical ESP32 speed.
8. Prior full-race results used a different preserved runtime lineage. Their earlier clock agreement does not calibrate this newly compiled maintained frontend or justify pooling these timings.
9. No source correction, emulator run or calibration experiment was performed by this audit. Host-native HOST-pi01 timings remain a separate measurement.

Use raw target ticks for descriptive comparisons within this exact fixture/runtime session, with the host-scheduling limit attached. Keep HOST-pi01 native host timings separate. Do not report these columns as physical rendering milliseconds, hardware FPS or calibrated Xtensa cycles. The audit preserves source hashes, exact MOS bytes and arithmetic in TARGET-TIMING-AUDIT.json. No inputs were changed and no emulator or additional experiment was launched.
