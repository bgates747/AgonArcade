| Case | Batch ticks, including final drain | Mean geometry ticks/frame | Mean bands ticks/frame | Mean submission ticks/frame | Mean fence ticks/frame |
| --- | --- | --- | --- | --- | --- |
| full-free | 1188, 1188 | 6.219 | 9.344 | 2.766 | 0.000 |
| full-fence | 1258, 1244 | 5.516 | 8.938 | 3.094 | 2.000 |
| nosky-fence | 1242, 1246 | 5.703 | 8.891 | 2.859 | 1.984 |
| notraffic-fence | 1174, 1228 | 5.703 | 9.062 | 1.938 | 2.000 |
| mirror-fence | 1260, 1602 | 6.469 | 10.109 | 3.703 | 2.047 |
| light-fence | 1268, 1258 | not sampled | not sampled | not sampled | not sampled |

All batches render 64 fixed poses after two unmeasured warm-up frames.
120 ticks/second; per-frame timer resolution is two ticks. Values include host/emulator scheduling effects.
Baseline drain is counted in batch duration; it is not a per-frame acknowledgment or a display counter.
