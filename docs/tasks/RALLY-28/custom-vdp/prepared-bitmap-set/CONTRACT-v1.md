# Prepared-image experiment: application contract v1

Prepare a bounded collection of car/sign images before racing, then measure
ordinary bitmap plots against fresh additive controls. Image count, setup cost,
peak memory and visible size error are explicit outputs. This contract releases
no implementation or emulator run: Golem requested a local freeze and return
first in `2026-10-30_18-52-37_golem_golem057-rally-results-ack-four`.

## Preserved comparison boundary

1. Base is the checked/compact INC-001-05 candidate: guest SHA256
   `685f4b4c6bd6959aac330a5c6c361b8e86b4967656bfb049df777b5a74ae3d1d`,
   module `479fe1ac99bb2895af8a8b6cca49b90cb5c346a56a5f9e4020cab0b23c933918`.
   FREEZE.json records the complete baseline fixture/source/runtime pins. Those
   exact accepted defaults remain unchanged; derived controls use fresh paths.
2. New comparison arms preserve compact RUN/error handling, native full
   publication checks, final swap fence, two warm pages, full race presentation,
   900 completed frames, 3,600 ticks and exact world/motion. Do not compare a
   prepared compact case against an old six-reply control. Retain a rich
   diagnostic path separately and prove checked/compact publication parity.
3. Reuse the current firmware/SDK buffer ABI. No native bitmap-creation, generic
   pixels, audio, background task or new service is requested. Preparation and
   plotting remain Rally-owned application work. New module/binary pins follow
   actual qualification; this freeze does not pretend those artifacts exist.

## Offline recipe interface

The proposed application artifact is `prepared-set.json`, schema
`rally.prepared-images.v1`. It is a recipe and index, never pre-scaled pixel
files. Its fields are:

| Field | Meaning |
| --- | --- |
| source pins | Original artwork/asset metadata hashes and full supported domain, both tracks; representative fixture coverage is listed separately. |
| policy | `exact`, `quantized`, or explicitly named `near-prepared-far-additive`; no automatic fallback from one to another. |
| entries | Source bitmap/view/livery, all six signed Q8 matrix coefficients including reflection/translation, destination bitmap ID, natural output dimensions and anchor offset. |
| selection | Finite ordered size intervals per source/reflection; each legal request maps to one entry or a declared hybrid domain. Screen position never belongs in the image key. |
| anchors | Ground-contact/centre or sign attachment point, declared source convention and signed Q8 offsets in the generated image. Preserve the world anchor when substituting a size. |
| error report | Maximum width/height, edge, anchor and silhouette errors; representative approach/recession size jumps and full-domain coverage. |
| budgets | Hard recipe-selected entry/pixel limits, ID ownership, retained bytes, largest block and peak setup upper bound including metadata/temporary images. Actual measured allocator overhead is additional evidence. |
| identity | Deterministic recipe hash, generator/source pins, selected error policy and explicit uncovered-domain disposition. |

Enumerate all reachable artwork/size/reflection combinations before fixing
field ranges or the packed in-VDP lookup layout. Do not silently discard matrix
translation from a key. Start with an exact reference plus one-/two-pixel error
alternatives for analysis; neither approximate threshold is human-accepted yet.
Choose denser nearby sizes when the error/RAM tradeoff supports them. A recipe
that fits only the 900-frame trace is not full gameplay coverage.

## Installation, lifetime and failure behavior

1. Load original artwork once. Generate the selected images inside VDP during
   setup using existing stock transform-to-bitmap commands or an explicitly
   qualified Rally sampler. The eZ80 sends recipes/commands, not scaled pixels.
   Initial preference is existing stock generation to avoid a new native
   startup entry; any generator change is named and qualified separately.
2. Allocate IDs from a checked application-owned range after inventorying all
   existing buffers; the concrete interval/count is a preparation finding,
   not an assumed free namespace. Preflight source hashes, lookup coverage,
   dimension/offset overflow, destination aliases and every recipe budget.
3. Measure startup MOS/PRT/host domains separately; discover free/largest
   internal/PSRAM memory before installation, at observed peak, after setup and
   cleanup. Include original art, bitmaps/indices/objects, current module, both
   pages, panorama, road/scratch buffers and generation temporaries. INFO17 is
   a stack watermark. Neither an 8 KiB recommendation nor admission ceilings
   establish available RAM. Source availability of INFO18–21 must be verified
   against the frozen firmware before relying on its values.
4. Finish all generation and checked installation before warming/timing. Keep
   the images immutable through the final draw fence; clear partially installed
   resources on failure and owned resources on normal exit. No pointer into a
   scoped native lease survives its return. Record successful installed count,
   bytes and final index identity instead of assuming emitted commands succeeded.
5. Fully covered timed frames perform zero generation, replacement or image
   allocation. A missing key is a diagnostic failure with its source/scale,
   never an invisible cache fill. Hybrid fallback is explicitly counted and
   separately timed; the original fully additive case remains the rollback.

## Qualification, ownership and next review

Rally owns domain/error analysis, recipes/IDs, setup and cleanup, lookup/anchors,
sampler/plot changes and full-race evidence. Golem owns central coordination and
any actual generic runtime gap; none is requested here. Source must fit the
preserved module policy with measured stack/resource receipts. If it cannot,
return the actual admission failure before changing SDK/runtime limits.

Next preparation, after dispatch: enumerate and report exact/quantized coverage,
RAM/setup bounds and worst transitions; freeze any packed lookup layout before
its producer/consumer implementation. Estimated host preparation 45–90 minutes;
full implementation/testing depends on the selected set's fit and visual policy.
No Oryx time is requested now. Later runs need a new central lease, silent SDL
drivers, unchanged thermal guard and fresh forward/reverse additive controls.
Lead with separate MOS/PRT FPS and report setup/peak RAM beside throughput.
Author moving review/publication and later hardware qualification remain gates.
