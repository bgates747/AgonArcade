# 2026-10-30 — Complete-race bitmap-cache FPS comparison

On Oryx Flexe, the tested eight-slot prepared-bitmap cache reaches29.74nominal
MOS FPS versus29.86with cached affine. It adds no frame-rate advantage. Matrix
reuse alone improves the inherited26.18FPS control by14.04%; the accepted
additive sampler remains fastest at33.44FPS. [Full results and elapsed times](tasks/RALLY-28/custom-vdp/affine-race/RESULTS.md)
retain PRT FPS separately(25.30/28.86/28.74/32.31). This is complete-race emulator
throughput with generation/misses included, not physical hardware FPS.

1. **Checkpoint publication:** on Author instruction, all preceding dirt was
   committed in logical groups and pushed to main: a3a1ddc(static-drawing
   experiment),059f1f7(actual full-race fixture/comparison),fa7932d(affine offline
   investigation and FPS-reporting correction). RACE-001-07and the completed
   static portion of INC-001-04 now have visual acceptance plus publication;
   removed from unfinished TODO. Original archives/raw receipts remain unchanged.
2. **AFF02-01 completed:** shared guest33116db7…/motion/assets/presentation,
   native source94d92d10…, firmware8da2ebfd…and prior full-race runtime are frozen.
   Only actor drawing changes. Native span road/player/physics/panorama/HUD/footer/
   audio/diagnostic/final-render/post-swap work remains common. Rebuild/additive
   modules are preserved binaries; matrix and prepared-cache modules are new.
3. **AFF02-02 completed:** ordinary and ASan/UBSan actual generated-C replay agree
   through902renders/3600ticks. Every road pixel/player buffer/full world/actor
   position/view/reflection/clipping/order matches control. Separate command
   decoder and cache oracle agree; leases balance at four maximum, canaries
   pass, maximum actor commands348bytes fit2048. Caches reset at bind and first
   timed render3 so two page-warm renders cannot hide initial generation.
4. **AFF02-03 completed:** two60-frame smokes, then eight selected900-frame runs
   in forward/reverse order. One last reverse control stalls after LOAD token1,
   before INFO18/timing, and is independently classified as startup-only.
   Original seven successes are retained; only the missing identical control
   is retried in a separate guarded session and passes. Four separate held
   frame300/301captures are excluded from timing and each pair is pixel-identical.
5. **AFF02-04 delivered for review:** independent raw audit verifies all5624
   replies/run, complete final world and203state reads, actual per-frame swaps/
   fences, exact352768-byte timed UART streams, timer/vector restoration,
   unload0/zero backend errors and clean MOS exit. FPS is total frames divided
   by total elapsed, with nominal MOS120/PRT1000clocks separately reported.
   All original95°C guards remain intact; maximum63°C, original boost1restored,
   no emulators running. Oryx is free. New code/evidence uncommitted; stopped
   affreview01-cached-affine/prepared-bitmap profiles await Author moving review.

The last-image cache has3000hits/1867misses among4867measured actor draws. Those
hits are only16.82% of natural transformed pixel area; all263large(scaleQ8>=128)
draws miss. Thus the4.4x isolated prepared-draw result does not carry over to
full-race FPS. Generation totals1717661pixels during timed frames. Logical
retained payload peaks22400bytes; conservative eight-slot payload bound52488
plus replacement temporary/object/matrix metadata. A larger multi-size cache
would be a different policy and is not tested or silently rejected here.

The initial host harness used the wrong trace phase label('main' versus
'measured'); it failed before qualification and its output is retained in
HOST-ATTEMPT01.txt. Corrected ordinary/sanitized replay passes. Report generation
initially ran before the final control receipt and correctly refused the failed
session; audit now explicitly qualifies the seven valid successes, startup
exclusion and separate continuation. No candidate timing is hidden or replaced.
The optional preview helper lacked Pillow; existing lossless PNG encoder was
used instead, with no image resampling/edit or emulator rerun.

Author moving visual review is still the appearance gate. No hardware action,
firmware/SDK change, game merge, scheduler change or further optimization was
performed. AFF01physical timing remains open separately. Keep accepted additive
renderer; no new cache candidate is adopted from these measurements.


## Proposed follow-up: pre-generated collections

The Author distinguishes a pre-populated collection from AFF02's single last
image per actor and asks for an offline error metric to choose image counts.
AFF03-01–05 are now proposed in root TODO, with their [scope](tasks/RALLY-28/custom-vdp/prepared-bitmap-set/PROPOSAL.md).
Measure full-domain size/view/reflection combinations, screen-space size and
anchor/silhouette error, motion popping and complete RAM/metadata/setup costs.
Allocate more size choices to expensive nearby objects, generate the chosen set
inside VDP before racing and compare complete-race FPS against fresh additive
controls. Declare a hybrid separately if only near sizes are prepared. The
Author chooses acceptable stepping. Other retained proposals are protocol-query
consolidation, transparent-margin/run elimination, direct-backbuffer/copy removal
(subject to missing service support), and the Author's distant-car/skyline idea.
Only documentation was requested and changed; no new compilation, emulator run,
remote/peer/hardware action, publication or optimization adoption occurred.
