# Unpaced, normal-clock eZ80 results

Repeated 64-pose rendering batches; complete time includes final drain.

| Track / renderer | Completed FPS | ms/frame | 60 Hz budget | ms over budget | Per-run FPS range | Mean final drain |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| oval / full | 8.57 | 116.67 | 7.00× | 100.00 | 8.48–8.67 | 16.67 ms |
| oval / pavement | 13.94 | 71.74 | 4.30× | 55.08 | 13.43–14.49 | 16.67 ms |
| oval / sections | 29.65 | 33.72 | 2.02× | 17.06 | 29.31–30.00 | 25.00 ms |
| fuji / full | 9.95 | 100.52 | 6.03× | 83.85 | 9.60–10.32 | 16.67 ms |
| fuji / pavement | 16.34 | 61.20 | 3.67× | 44.53 | 16.13–16.55 | 16.67 ms |
| fuji / sections | 29.88 | 33.46 | 2.01× | 16.80 | 29.77–30.00 | 16.67 ms |

All 768 frames submitted; all 12 batches completed their final poll without a timeout. Pose hashes and road-byte totals match the previous renderer fixtures. Normal CPU flags were verified from each running process.

One-minute host load range: 2.44–3.90. Individual timestamps have two-raw-tick granularity (16.67 ms). These are batch-throughput equivalents, not physical display FPS. Ordinary gameplay physics and keyboard input are excluded. No application frame cap or per-frame completion wait remains.
