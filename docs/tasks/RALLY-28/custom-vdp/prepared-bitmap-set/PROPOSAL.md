# Proposed experiment: prepare multiple bitmap sizes before racing

Choose a collection of car/sign sizes offline using measurable screen-space
error and a RAM budget, then generate and retain those bitmaps in VDP RAM before
the race starts. During racing, select a prepared image and plot it ordinarily.
Compare complete-race FPS against the accepted additive sampler. Spend more of
the bitmap budget on large nearby objects, where repeated generation costs most.

**Status, 2026-10-30:** the Author requests recording a potential experiment.
This authorizes documentation only. No implementation, allocation, compile,
emulator run, hardware action, owner messaging, commit or push is released.
Root `TODO.md` owns proposed AFF03-01 through AFF03-05; this document specifies
their scope and does not maintain a second actionable checklist.

Later GOLEM-057 follow-on `golem057-rally-results-ack-four` requests preparing
and locally freezing the bounded application contract before implementation.
[CONTRACT-v1.md](CONTRACT-v1.md) and FREEZE.json record that return. This releases
the contract preparation/coordination only; no set generation or new Oryx run.

## Why this is a different experiment

The [AFF02 last-image cache](../affine-race/RESULTS.md) keeps only one size/view
per opponent and two sign slots. A size, source-view or reflection change
replaces that image during racing; moving it on screen alone does not. It does
not retain a collection of earlier sizes. Its 3,000 hits are 61.64% of actor
draws but only 16.82% of their natural transformed pixel area. All 263 large
draws at scale Q8 >= 128 miss that policy and regenerate their pixels.

That experiment reaches 29.74 nominal MOS FPS versus 29.86 with cached affine;
the accepted additive sampler reaches 33.44 in the same fresh full-race tests.
Those results do not evaluate a pre-populated multi-size collection. The new
proposal moves image generation into setup and explicitly trades RAM and visual
size quantization for steady race throughput. No frame-rate gain is assumed.

## AFF03-01 — Enumerate images and establish the RAM budget

Inventory original artwork, traffic colours, viewing angles, reflection states,
signs and the full supported projection-size range from the maintained code.
Distinguish the narrower sizes seen in the deterministic fixture from all sizes
gameplay can request. Count only required combinations; do not multiply every
asset by every state without checking whether that state is reachable. Ordinary
full-size player images need no redundant size variants; audit any reflected
player path separately before deciding to precompute it.

Produce per-family and total counts and actual bitmap dimensions. Budget pixel
payloads, bitmap/buffer IDs, matrix/index/anchor metadata, allocator overhead,
temporary generation/replacement storage and both DRAM and PSRAM pressure.
Include existing framebuffers, panorama, artwork, native module and road/state
buffers in available-memory measurements. Record largest required contiguous
allocation and peak setup use as well as steady retained memory. Use measured
capacity; the historical 8 KiB recommendation is not a hard global RAM limit.

## AFF03-02 — Select sizes offline from an error-versus-RAM curve

Generate candidate scaled images offline for analysis, then evaluate requests
against available prepared sizes. Compare the following separately:

1. Maximum apparent width/height and silhouette-edge displacement in screen
   pixels, including clipped and reflected views.
2. Car centre, tyre/ground contact and sign anchor displacement. A different
   selected scale must preserve the intended world-space anchor; blindly
   plotting the substituted size at the old top-left coordinate is insufficient.
3. Alpha-mask/silhouette disagreement, with colour-pixel differences as supporting
   evidence. A global percentage alone can hide a visibly displaced small car.
4. Size-step popping during approach/recession at representative speeds and
   render cadences. Keep a monotonic size choice as distance changes. Prefer a
   simple lookup rule; any hysteresis should be an explicit separate variant.
5. Retained bytes and entries required at several error tolerances, for example
   exact sizes versus maximum one- or two-pixel edge error. These are options
   for review, not silently chosen acceptance thresholds.

Optimize placement of size entries rather than requiring uniform scale steps.
Allocate greater density to expensive near-player images; distant images may
share more widely spaced sizes if their screen-space error and motion look
acceptable. Weight potential benefit by avoided generation work and bytes, not
only frequency: many tiny cache hits did not help AFF02 enough. Check the full
supported domain, both tracks and all relevant artwork/reflections, using the
deterministic race as representative evidence rather than the sole design input.

Deliver a table of image counts, RAM, maximum/typical error, largest size step
and coverage for each budget. Let the Author select the visual tradeoff; do not
reject a faster approximate option solely for differing from exact scaling.

## AFF03-03 — Build the selected set before the timed race

The production candidate loads original full-size artwork once and generates
prepared images inside VDP during setup. The offline output is a size/selection
recipe and error report, not a requirement to load pre-scaled artwork files.
This preserves the Author's existing preference against uploading scaled files.

Either the specialized additive sampler or stock affine commands can generate
the set; preparation algorithm and retained-image reuse are independent choices.
Record which generator is used and verify its pixels/anchors. Once setup is
complete, fence generation and validate the index before starting race timing.
Report startup duration and peak memory separately from steady FPS.

Keep images immutable while queued draws can reference them. Choose by original
artwork/view, reflection and selected size; screen position is a plot parameter.
For a fully covered set, the timed-loop requirement is zero image generation,
image replacement or image allocation. Count unexpected uncovered requests and fail the
diagnostic instead of silently preparing more images during timing.

If full coverage does not fit the selected budget, present a separate hybrid:
precompute the expensive near sizes and use the additive sampler for a declared
far-size domain. Count and time that fallback explicitly. It is not equivalent
to the fully prepared case and must have its own FPS row. No unlimited memory
table, mandatory cache size or physical capacity is assumed in advance.

## AFF03-04 — Compare actual complete-race FPS

Use fresh matched full-race controls, not the isolated 4.4x host draw ratio or
historical FPS. Preserve the real scrolling panorama, road, traffic, signs,
player, HUD/footer, audio commands, world/physics progression, input work and
final rendering/post-swap fences. Change only the actor image-selection and
generation policy. Keep physics independent of image-size quantization.

Compare accepted additive sampling, the chosen fully prepared set and any
separately declared hybrid. Keep the previous last-image and affine results as
reference; do not substitute them for fresh controls. Measure forward/reverse
orders with common firmware/runtime and deterministic motion. Automated runs
would remain silent/headless with both SDL dummy drivers and the existing Oryx
temperature/boost guard; new execution still requires a release.

Lead the result with completed frames, elapsed time, FPS and change versus the
matched additive control. Report MOS and PRT domains separately, plus per-run
variation and any clock disagreement. Include startup cost, RAM and generation/
fallback counts alongside the FPS table. Confirm actual command traffic and
render completion; retain all failures and original evidence. Flexe results
do not establish physical ESP32 FPS; hardware comparison is a later gate.

## AFF03-05 — Author moving review and disposition

Offer moving comparisons showing nearby cars, approach/recession through size
boundaries, angle/reflection changes, signs and clipping. The Author judges
whether stepping is acceptable. Include worst-error transitions, not just a
favourable stationary view. Preserve exact geometry/physics references and prior
fixtures; visual agreement need not be exact if the tradeoff is accepted.

Keep a candidate only if its FPS, memory/setup cost and accepted appearance
justify it. The existing additive renderer remains the control and rollback.
No game integration or publication follows automatically from a promising test.

## Other independent optimization candidates

1. **INC-001-05:** consolidate per-frame diagnostic queries into a sequenced
   completion/status response, retaining errors and the final drawing fence.
   Count actual wire bytes and waits. This is the next separate protocol A/B;
   do not combine it with bitmap preparation or a new physics scheduler.
2. **INC-001-06:** trim transparent image margins or skip transparent runs,
   preserving anchors, reflection and clipping. Measure sampler work, ordinary
   plot cost and RAM separately before choosing a format or compositor.
3. **INC-001-06:** investigate removing the intermediate road bitmap copy by
   drawing into the hidden framebuffer. The current native service does not
   support this mode-136 path; any extension requires owner coordination and
   resource/lifecycle qualification before implementation.
4. **Existing Author suggestion:** test a shorter distant-car draw range so
   actors stay below the skyline and examine whether this actually removes sky
   restoration work. Treat this as a visibility/appearance tradeoff, separate
   from bitmap-size quantization. Existing production panorama/HUD retention
   already runs in all current race controls and is not a new optimization.
