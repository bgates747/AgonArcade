# Functional guest passes; frozen raw audit misses three legacy reads

Both finite60-frame/240-tick processes pass the frozen functional verifier.
The prepared guest installs901images, reports the expected counters/state and
cleans up to MOS. Its measured command-task stack minimum is1972bytes. Full
independent qualification is OPEN: the frozen raw schedule omitted three pose
reads already present in the unchanged control. No FPS campaign or expectation
change has occurred; Oryx is stopped and released.

1. **First strict-audit mismatch.** At token16647the oracle expects RUN15, but
   immutable control and prepared main both first call
   `read32(Root,PlayerStation)` and `read16(Root,RenderPhase)`. Actual captured
   reads are token16647/offset198/value35536,16648/offset200/value49 and
   16649/offset304/value6800, all kind4. The two station words reconstruct
   3,246,800. These are unchanged initial-pose guards before the warm pages,
   not unexpected guest operations or a native failure. The original compact
   raw auditor already lists them. New raw_audit.py and HOST-FIXTURE prediction
   forgot them; the prepared transcript contains17946rather than17943replies.
2. **Disposition.** Preserve READINESS-FREEZE and the failed audit exactly.
   RAW-AUDIT-FIRST-MISMATCH.json records the source/packet mismatch;
   FIRST-FUNCTIONAL-WITNESS.json pins both returned runs and receipts. No
   source/oracle/prediction/pin has been changed and no rerun requested. Return
   to Golem for a separately preserved audit-only correction adding those three
   source-required reads and correcting the prediction by3, using these same
   immutable logs. Do not claim the full raw audit passed beforehand.
3. **Reported functional results.** The controller verifies exact independent
   final state, setup before Init, all901registration witnesses,963pixel checks,
   cold/steady timer restoration, Stop/UNLOAD and all private cleanup. Target
   counters match417lookups/416plots/one clipped/zero missing/generation/
   allocation/replacement/fallback. Both cleanly return to MOS, backend errors
   are zero. Success never takes the failure-generation-resync path. These
   results do not by themselves close the strict raw-schedule gate above.
4. **Task watermarks individually confirmed in raw INFO17.**

   | Phase | Remaining command-task stack |
   | --- | ---: |
   | After LOAD | 2424 B |
   | After install | 2196 B |
   | After warm pages | 2196 B |
   | After steady work | 1972 B |
   | After cleanup | 1972 B |

   Compact reports2260→1988Bover its warm/steady checkpoints. Prepared's observed
   minimum is16Blower, consistent with the compiled entry-frame increase. These
   are measured minima in the finite smoke, not an exhaustive gameplay bound or
   the1280Bmodule-only call-path estimate.
5. **Guest memory/durations, pending complete raw audit.** Main-entry cold setup
   through warm pages38.5667nominal MOS seconds; install34.1500; verified install
   alone32.7833MOS/33.929separate PRT seconds. This includes verification/logging,
   excludes MOS binary loading/BSS startup before main, and establishes no FPS.
   BaselinePSRAM3442367B, installed/race-ready1012947B, delta2429420B. Race-ready
   internal59944B/largest29684B. Cleanup buffer count90matches baseline; PSRAM
   residual10960B. Internal memory is984Bhigher than baseline AFTER module
   UNLOAD, so this is not a standalone cache-leak comparison with the older
   pre-UNLOAD52Bresidual. Boundary minima remain observations, no transient or
   largest-PSRAM claim.
6. **Guard and release.** Compact11.956host seconds/prepared48.897; session61.722
   including supervision. Original95°Cguard, sampled maximum70°Cat start then
   cooler, bothSDLdummy, initialboost1restored1, all owned emulators stopped.
   Fresh whole-host inspection and explicit generation24release precede analysis;
   Golem release-eighteen notified immediately. No GUI/audio device/hardware,
   full900benchmark, appearance/default/publication acceptance or commit/push.
