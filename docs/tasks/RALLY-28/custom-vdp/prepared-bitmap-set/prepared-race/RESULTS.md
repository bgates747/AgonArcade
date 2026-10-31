# Prepared race functional qualification passes

The original compact and prepared60-frame/240-tick captures now pass the full
independent audit. No emulator was rerun. The correction adds only three pose
reads already present in both unchanged guest sources to a separately frozen
oracle; the original oracle, first mismatch, predictions and captures remain.
This closes functional qualification, with no new FPS or appearance claim.

1. **Audit provenance.** Golem correction-eighteen authorized the same-capture
   correction. `POSE-AUDIT-FREEZE.json` pins the revised oracle, exact diff,
   source/outbound/reply witness and separate +3 predictions before execution.
   Revised oracle SHA256 is
   `e9f1f3e3bfd93bc3ab4f27dc16d35d9b51c6bc6ed8753b3b75642435be7065ae`.
   It adds Root READ16 offsets198/200/304 after Init, before warm pages; observed
   values35536/49/6800 reconstruct station3246800 and render phase6800.
   `FUNCTIONAL-IMMUTABILITY.json` confirms all75 readiness inputs,46 first-witness
   files and4 correction files unchanged. Removing exactly these three added
   oracle lines reproduces the original oracle byte for byte.
2. **Full raw qualification.** `RAW-FUNCTIONAL-AUDIT.json`
   (`dad0e0bea9028cf2e9051fdb333a5df7cacd5b0f2d5a2fdc4fe73d3be7c9f876`)
   passes all17,946native replies and21,137multiplexed packets: every request,
   token, kind, status and value,909memory samples,963pixel witnesses,5314table
   words, setup before Init, independent initial/final world and all private
   cleanup queries. No further mismatch occurred. The original compact auditor
   separately passes344native replies/1606multiplexed packets and exact state.
   Captured and delivered UART streams/stats agree and backend errors are zero.
3. **Same work across the wire.** `SAME-CAPTURE-AUDIT.json` confirms240physics
   calls and60swaps. All18,317timed outbound bytes match after changing only
   the120native reply tokens displaced by prepared setup. Normalized SHA256 is
   `a666b1b6b8e6660a5e588c332abb8b9e60feffbb468231c30c6633aaa02f9cbb`.
   Actual panorama/HUD/footer/audio work, finite motion, final fence and world
   agree. These checks do not establish identical rendered actor pixels.
4. **Loaded stack and ownership.** Actual INFO17 remaining command-task stack:

   | Phase | Remaining bytes |
   | --- | ---: |
   | After LOAD | 2424 |
   | After install | 2196 |
   | After warm pages | 2196 |
   | After steady work | 1972 |
   | After cleanup | 1972 |

   Compact warm/steady values are2260/1988B. The prepared minimum is16B lower
   than control in this finite run. It is a measured task watermark, distinct
   from the earlier1280Bmodule-only stack calculation and not a universal bound.
   Prepared counters are417lookups,416plots,1clipped and zero missing keys,
   generation, allocation, replacement and fallback; counts include two warm
   renders. The table/images remain owned and immutable through the last fence.
5. **Memory and cleanup.** Baseline PSRAM3,442,367B; installed and race-ready
   PSRAM1,012,947B, retained delta2,429,420B. Race-ready internal59,944B and
   largest internal block29,684B. All901images and private table/matrix/
   telemetry/stats are absent after Stop→UNLOAD→cleanup; buffer count90 matches
   baseline. Cleanup PSRAM3,431,407B leaves10,960B residual. Cleanup internal
  61,088B is984B above baseline after module UNLOAD, so it cannot be interpreted
   as the earlier pre-UNLOAD cache-only52B residual. Boundary minima do not
   measure transient peaks; largest PSRAM allocation is unavailable. No broad
   leak-free or stack-safety guarantee follows.
6. **Cold cost, separate from throughput.** Main entry through warm pages takes
  38.5667nominal MOS seconds, install34.1500; verified install alone32.7833MOS
   versus33.929separate PRT seconds. This includes extensive verification and
   logging and excludes MOS binary loading/BSS startup before main. The original
   steady timer is restarted after setup. Functional60-frame results establish
   no FPS; full900prediction is19,626native replies/196,260B, not yet observed.
7. **Guard and release.** Original generation24compact→prepared processes took
  11.956/48.897host seconds; session61.722seconds. Both SDL drivers were dummy,
   original95°Cguard retained, maximum70°C at initial sampling, initial boost1
   restored1. All owned emulators stopped; fresh whole-host inspection and
   explicit lease release preceded analysis. This correction used no Oryx or
   emulator process. There is no GUI, audio output, hardware or commit/push.
8. **Rendering fairness.** Control samples original requested sizes using the
   additive sampler. Prepared901 selects monotone two-pixel representatives and
   stock command40/options3 generated images. Original centre/ground anchors
   and depth/order survive, but selected dimensions, anchor offsets, raster
   origin and sampling can differ. Thus future compact/prepared timing measures
   a bundled caching/size/sampling tradeoff, not an isolated cache gain or exact
   raster match. A separate matched generation/retention control is proposed
   in `FAIRNESS-REQUEST.json`; appearance/default acceptance remains human.

The historical `FIRST-FUNCTIONAL.md`, `RAW-AUDIT-FIRST-MISMATCH.json`, original
`raw_audit.py`, readiness freeze and first-witness pins remain intact. Full audit
return to Golem precedes the separately authorized benchmark preparation.
