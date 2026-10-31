# First pair qualified; four-run comparison incomplete

This measures caching together with two-pixel actor-size approximation and
stock-versus-additive sampling. It cannot isolate cache benefit or establish
identical actor pixels. The first900-frame pair passes the full raw audit, but
the third process stalled before cache installation and the fourth was skipped.
There is no qualified four-run gain, reversed-order result or default decision.

| Completed case, first order | Nominal MOS FPS | Separate PRT FPS | MOS units | PRT units |
| --- | ---: | ---: | ---: | ---: |
| Accepted compact control | 36.1930 | 34.9610 | 2984 | 25743 |
| Prepared901 candidate | 36.2173 | 34.9949 | 2982 | 25718 |

Each completed case renders900frames/3600physics ticks plus two untimed warm
pages. The single pair differs by+0.0671% nominal MOS /+0.0972% PRT. That does
not establish a useful gain. Four-run pooling, within-candidate variation and
order effects are unavailable; no missing samples or older cohorts were added.
These are emulator completion rates, not physical ESP32 scanout or autonomous
120Hz physics headroom.

1. **Exact first-pair qualification.** Frozen `audit.py` passes2,024compact and
   19,626prepared native replies, every request/token/kind/status/value, final
   independent root/arrays, timers, source/runtime pins, counters, cleanup and
   MOS return. Prepared includes909memory samples,963pixel witnesses and all
   5314table words. All291,568timed command bytes match after changing only
   1800native tokens; normalized SHA256 is
   `1d84519a7348393493399b199c81fe9671c5bdda7e3f757959cee707c443418d`.
   Each stream has3600tick submissions and900swaps. Actual panorama/HUD/footer/
   engine/input/motion work and final checked swap fence match. No actor-image
   equality follows from wire/world equality.
2. **Finite stack and memory observations.** Prepared remaining command-task
   stack after LOAD/install/warm/steady/cleanup is2424/2196/2196/1940/1940B;
   compact warm/steady is2260/1956B. The prepared minimum is16B lower in this
   finite full race, not an exhaustive bound. Prepared counters, including warm
   pages, are4873lookups/4871plots/2clipped and zero missing/generation/
   allocation/replacement/fallback. The original collection/table remain owned
   and immutable through the final fence. Retained PSRAM delta2,429,420B leaves
   1,012,947B; race-ready internal59,944B/largest29,684B. After successful
   Stop→UNLOAD→counter-read→cleanup all901images/private resources are absent,
   baseline90buffers restored, PSRAM residual10,960B. Internal is984B above
   baseline AFTER module UNLOAD; this is not the earlier pre-UNLOAD cache-only
   residual. Boundary samples do not establish transient peaks, largest PSRAM
   or general leak/stack guarantees.
3. **Cold cost outside steady timing.** Prepared main entry through warm pages
   is38.9667nominal MOS seconds; install34.5500, verified install33.1833MOS/
   34.344separate PRT seconds. These include verification/probes/logging and
   exclude MOS program loading/BSS startup before main. No cold cost was folded
   into the FPS table. The original steady stopwatch starts after setup.
4. **Third process boundary.** `FAILED-TRIAGE.json` independently matches all
   six early native requests/replies: LOADhandle1, then INFO17=2424,
   INFO13/14=58716/0 and INFO15/16=36852/0. All108multiplexed packets decode.
   Host-enqueued capture ends at233,974B: complete149,554B `assets.vdu` starting
   at35780, then an exact48,640B prefix of58,780B `artwork.vdu` at185334.
   `ARTWORK-BOUNDARY.json` locates the expected original-art block in that
   reference stream: clear63800at48249, write header48255declares2048B,
   payload48263;377payload bytes captured,1671not captured. This identifies
   the expected block around the captured boundary, not firmware parser state.
   No prepared installer, Init, warm or timed race request was reached. The
   fourth compact profile has no last-run or result and was never launched.
5. **Transport and quiet-time limits.** Adapter stats `uart_rx=233974` reconcile
   host enqueue calls, not firmware consumption or even modeled FIFO delivery.
   Historical exported-base adapter source pins the enqueue/trace and reverse
   delivery definitions in `ADAPTER-COUNTER-SOURCE.json`; the old adapter was
   copied from the maintained Oryx build, so this is not a new reconstructed
   source-to-binary proof. Returned/emitted/dequeued streams match405B. The six
   ordered native replies prove early diagnostics consumed; they do not prove
   consumption of subsequent artwork. No native callback is expected while
   sending these asset files. `file()` reads1024B then sends, with no deliberate
   quiet interval inside that source function. The guard observed both trace
   sizes unchanged60host seconds. No live CTS/queue/FIFO/IRQ/task/model-PC state
   or progress samples during that interval were captured; firmware consumption,
   legitimate processing time and exact stall cause remain unqualified. Zero
   backend failed/unhandled/unregistered/unmapped counters do not prove forward
   progress or exclude a wait/loop. No shared-cause claim with the separate ARM
   FSIM observation is made.
6. **Teardown and immutable evidence.** The failed process exits0under the
   host guard after67.483host seconds, with no guest result/Stop/UNLOAD/MOS
   cleanup witness. Host shutdown is distinct from guest cleanup. Session
   177.899seconds, original95°Cguard/max61°C, both SDL dummy, actual boost1
   restored1, all owned emulators stopped. Raw retrieval, fresh whole-host empty
   inspection and explicit generation28release occurred BEFORE analysis;
   immediate release-twentyfive notified Golem. Post-check confirms all four
   profile input maps unchanged; frozen46inputs/41source dependencies remain.
   No retry, source/expectation change, fourth launch or cohort expansion.
7. **Disposition.** Golem partial-response-twentythree and boundary-received-
   twentyfour release only this offline report. The first meaningful boundary
   was sent promptly in Rally twenty-six and forwarded by Golem to Flexe for
   source review. Preserve first successes, third failure, fourth unrun and
   every earlier functional/capacity/archive witness. Candidate appearance,
   default, human review, further emulator work and publication remain held.
   No hardware, GUI, sound output or commit/push.

`PARTIAL-RESULTS.json` supplies the scoped numbers; `RAW-AUDIT-prace900ab01.json`
supplies the independent success proof. The immutable readiness README remains
the pre-execution four-run plan; this report and root TODO own its later state.
