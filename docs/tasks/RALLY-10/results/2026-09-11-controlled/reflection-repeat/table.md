| Case | Batch ticks, including final drain | Mean geometry ticks/frame | Mean bands ticks/frame | Mean submission ticks/frame | Mean fence ticks/frame |
| --- | --- | --- | --- | --- | --- |
| full-fence | 1238, 1204 | 5.297 | 8.672 | 3.062 | 2.031 |
| mirror-fence | 1236, 1234 | 5.484 | 8.719 | 3.062 | 2.031 |

All batches render 64 fixed poses after two unmeasured warm-up frames.
120 ticks/second; per-frame timer resolution is two ticks. Values include host/emulator scheduling effects.
Baseline drain is counted in batch duration; it is not a per-frame acknowledgment or a display counter.
