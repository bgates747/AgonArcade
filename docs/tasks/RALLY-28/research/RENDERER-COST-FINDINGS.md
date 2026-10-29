# Rally renderer cost audit and Wolf3D comparison — 2026-10-28

Rally contains avoidable recurring work in sprite transforms, framebuffer clearing,
span filling and diagnostic round trips. These findings follow from inspecting
the actual Rally drawing path; they do not depend on Wolf being faster. Wolf
provides a concrete example of specialized additive scaling that Rally could
reuse. No speedup from these newly proposed changes has been measured. The next
useful comparison is a phase measurement of the accepted Native-span candidate,
then an isolated sprite-scaler A/B with the same scene and completion fence.

This document durably records the source/data audit requested by the Author.
Finding identifiers below are stable references, not an implementation checklist
or a release of new work. `TODO.md` remains the sole authoritative task list.
Existing controls, evidence and source files are preserved. No emulator run,
firmware change, hardware action, commit or push was performed for this writeup.

## Evidence and comparison limits

1. The Rally control is the accepted Native-format span-bitmap candidate under
   [the throughput investigation](../custom-vdp/throughput/RESULTS.md), not the
   older triangle/quad renderer and not a complete playable-game benchmark.
   Its pooled fenced result is 25.91 nominal MOS FPS. Road image construction
   already uses non-overlapping spans; the remaining findings must preserve
   that improvement.
2. Wolf uses the existing deployed application and matching custom firmware.
   The [two large-room full-turn results](wolf3d-framerate/positions/RESULTS.md)
   are 29.0064 and 29.0128 completed FPS, measured with host CLOCK_MONOTONIC.
   The application retains its nominal 30 Hz cap. Those results establish
   playable paced behavior, not maximum unpaced rendering capacity.
3. The comparisons share the pinned Flexe frontend/adapter/MOS and boost-off
   condition, but use different custom firmware/ELF and different clocks and
   timing boundaries. Do not calculate a renderer speed ratio from these FPS
   figures. Flexe remains preliminary timing evidence; hardware is decisive.
4. Below, **confirmed** means source inspection or decoding existing data;
   **proposed** means an unimplemented experiment. Operation counts are not
   measured processor time or physical memory-bus transactions.

## Confirmed findings and candidate dispositions

### RCF-001 — Visible simplicity understates Rally's pixel workload

Wolf's 256×160 viewport contains 40,960 pixels. Rally's 320×120 road image
contains 38,400, or 93.75% as many, before other scene drawing. Rally's complete
320×200 world viewport contains 64,000 pixels.

Wolf casts 256 wall rays and stops each at its first opaque wall. A larger room
can require more DDA crossings while producing shorter wall strips; proximity
to a wall can reverse that balance. It does not render every traversed tile.
Floor and ceiling are solid fills rather than perspective textures. Thus room
size, apparent detail and object counts alone do not establish pixel cost.

Source: [Wolf wall traversal](/Agon/mystuff/agon-vdp-wolf3d/video/wolf3d/render/wolf3d_draw.h:144),
[Rally image dimensions](../custom-vdp/throughput/span.inc).

### RCF-002 — Scale-only traffic/sign drawing takes the general affine path

Both Rally implementations use diagonal scale and optional horizontal reflection
for traffic/sign placement, yet rebuild an identity/full affine matrix for each
visible traffic car/sign. The buffered implementation performs general matrix
combination/allocation, and the first transformed plot obtains a cached general
inverse. The pixel loop executes `dspm_mult_3x3x1_f32` for every candidate pixel,
then bounds checks, floating-point-to-integer conversion, source lookup and alpha
testing. Transparent pixels incur the matrix work too.

This is independently identifiable unnecessary generality. General rotation,
shear and projective machinery are not required by these callers. Reducing VDU
command bytes alone would not remove this downstream raster cost.

The player is a separate case: its five views are fixed 102×77 images and its
optional reflection matrix is prepared at startup. Do not attribute per-frame
traffic matrix rebuilding to it. A mirrored player can still take the general
transformed-pixel path.

Sources: [standard matrix emission](/Agon/mystuff/AgonArcade/rally-game/src/main.cpp:132),
[native helper](../custom-vdp/paced-road/control/package/helper/render_core.inc),
[buffered affine implementation](/Agon/mystuff/agon-vdplet/build/firmware/firmware-src/video/vdu_buffered.h:1767),
[inverse cache](/Agon/mystuff/agon-vdplet/build/firmware/firmware-src/video/buffers.h:160),
[actual transformed-pixel loop](/Agon/mystuff/agon-vdplet/build/firmware/firmware-src/.pio/libdeps/esp32dev/vdp-gl/src/displaycontroller.h:2840).

### RCF-003 — Most of the tested car artwork is transparent padding

Independent decoding of the actual Native-fenced fixture's `artwork.bin`
buffers 64000–64004 gives 7,854 pixels per 102×77 view:

| View | Transparent pixels | Opaque pixels | Opaque proportion |
| --- | ---: | ---: | ---: |
| 0 | 5,864 | 1,990 | 25.34% |
| 1 | 5,720 | 2,134 | 27.17% |
| 2 | 5,655 | 2,199 | 28.00% |
| 3 | 5,549 | 2,305 | 29.35% |
| 4 | 5,488 | 2,366 | 30.12% |

All decoded alpha values are zero or three (`pixel >> 6`). Thus approximately
70–75% of source pixels are transparent. This is source-art occupancy, not an
exact count of sampled destination pixels at every scale/clip. Combined with
RCF-002, it identifies waste worth measuring.

Reproduction inputs: `throughput/.work/fixtures/native-span-native-fenced-unpaced/`
as located by [FIXTURES.json](../custom-vdp/throughput/FIXTURES.json); locate each
VDU buffer upload for the five IDs and decode its 7,854 payload bytes.

### RCF-004 — Wolf supplies a directly reusable restricted scaler

[Wolf's `SampleSprite`](/Agon/mystuff/agon-vdp-wolf3d/video/wolf3d/render/wolf3d_draw.h:415)
computes horizontal/vertical fixed-point increments once per sprite and advances
source coordinates with additions and shifts. Destination clipping precedes
sampling. `SampleWallColumn` uses the same incremental principle for strips.
The sampled result is plotted as an ordinary bitmap.

**Retained proposals:** a clipped additive scale/mirror routine for native Rally;
precomputed opaque row runs to skip empty padding; bounded pre-scaled size buckets
and mirrored variants for stock-compatible ordinary plots. Opaque-run skipping
is our additional proposal, not a claim about Wolf's existing implementation.
Prepare the player's five mirrored views at startup where worthwhile.

Stock caches must budget PSRAM, setup cost and selector/binding limits. The
current helper's short bitmap selectors and base-resource validation use 256
entries; the stock long-ID selector also supports retained buffer bitmap IDs
above255 (as used by road50700 and the new scratch50710–50717). Thus256 is not a
universal stock-VDP bitmap ceiling. Do not assume every view/livery/size/mirror combination fits. Avoid
per-frame pixel uploads from eZ80. Size buckets deliberately trade visual size
smoothness for speed and must be offered for Author motion review.

Wolf still allocates/copies scratch images and dispatches many column plots;
it is not a zero-copy ideal. Its fixed-point helpers also include wide arithmetic.
The transferable finding is specialization, not a universal fixed-point speedup.

**INC-001-02 follow-up:** the isolated native implementation uses an additive
sampled image per queued traffic/sign object and ordinary plots, with fixed
retained backing buffers and explicitly activated canvas clipping. Sampling
occurs after releasing the command-output lease, fitting the actual four-slot
limit including the generated root lease. Player drawing remains unchanged.
The standard-VDP cache alternative remains separate work. See
[implementation and qualification](../custom-vdp/incremental/sprites/RESULTS.md).

### RCF-005 — The frame clear redundantly covers the opaque road image

The [frame tape builder](../../RALLY-25/native-demo/build.py) clears x=0..319,
y=24..239 every frame: 69,120 framebuffer pixels. The opaque road bitmap then
overwrites all 38,400 pixels of its own region. Removing that portion of the
clear would save 38,400 framebuffer clear writes per frame, independently of
Wolf. The lower 16 rows account for another 5,120 pixels potentially initialized
once on both pages if they remain static.

The basic logical accounting is 69,120 clear writes + 38,400 image writes +
38,400 image reads + 38,400 destination writes = 184,320 byte accesses before
actors/title/finish. This is not measured bus traffic and excludes scanout,
cache behavior and other work.

**Retained proposal:** clear only regions that need restoration, and initialize
static title/HUD elements on both buffers. Preserve sky restoration: traffic
can extend above the road bitmap's y=104 top, to approximately y=100. Blindly
compositing all actors into the present 120-row image would clip that traffic.
Expand the compositor region or retain an upper layer. The helper's HUD black
rectangle at y=224..239 is outside the active y=24..223 viewport; inspect its
dispatch cost rather than count it as visible fill work.

**Measured follow-up INC-001-01, 2026-10-28:** the isolated split clear passes
four900-frame Flexe runs with exact final state and identical shutdown captures.
Pooled25.96→26.33nominal MOS FPS (+1.41%), with pairwise0.15–2.69%variation:
a small preliminary effect, not a stable or substantial gain. The extra12wire
bytes/frame are included. [Results](../custom-vdp/incremental/RESULTS.md).

### RCF-006 — Native span filling is a byte loop

The isolated native module's custom `memset` is a byte store/increment/branch
loop. Inspection of the target disassembly confirms that the `-Os -fno-builtin`
build does not replace it with a wider optimized fill.

**Retained proposal:** compare aligned replicated-color word stores with short
prefix/tail handling. Preserve exact span endpoints and output bytes. Do not
predict a fourfold speedup from store width; PSRAM/cache/alignment and complete
frame costs require measurement.

**INC-001-03 measured2026-10-29:** aligned word stores preserve exact output and
reduce a separate fill replay's raw emulated CCOUNT52.65%, but fresh completed
frames give36.999→36.327nominal MOS FPS with opposite-sign pairwise changes.
No whole-frame gain is established; keep the byte-fill/additive control. The
phase result has competing-host-work/thermal limits and is not physical timing.
Preserve this negative outcome before proposing wider fills again.
[Exact fixtures, codegen, results and limits](../custom-vdp/incremental/wide-fill/RESULTS.md).

Sources: [native support functions](../custom-vdp/paced-road/control/package/native.c:20),
[span fill](../custom-vdp/throughput/span.inc:37), target disassembly under
`throughput/.work/span-candidate/target/rally-render.disassembly.txt` (`memset`).

### RCF-007 — Rally's diagnostic frame protocol serializes six checks

Decoding the actual fenced Native fixture gives 265 outbound bytes/frame and
six checked transactions: Render30 acknowledgment, ready, request, tick,
generation, and final post-swap generation. Four Tick120 wrapper CALLs are
separate silent operations, not four additional checked transactions. The
unfenced variant is 248 bytes/five checked transactions. Preserve old receipts;
an earlier preflight description naming five transactions does not describe
the final fenced tape.

For each Wolf full turn, the 120 request intervals contain 16,542 outbound bytes,
or 137.85 bytes/frame, with one 12-byte W3DR completion per frame. At nominal
1.152 Mbaud, 8N1, outbound serialization floors are approximately 2.30 ms Rally
versus 1.20 ms Wolf. These floors do not explain the complete frame duration;
round trips, dispatch and waits must be measured separately.

**Retained proposal:** resident batched state updates and one sequenced frame
completion/status response, while retaining publication/error semantics, the
final rendering fence and a rich diagnostic control. Do not simply disable
checks. Wolf's persistent dirty-state mirror and one-frame-outstanding protocol
are useful precedents. Rally's four-physics-steps-per-render diagnostic fixture
is not the independently scheduled gameplay architecture we ultimately want.

Reproduction: decode loop records with `paced-road/freeze_control.py::records`
using the fixture registry above. Wolf UART captures are under
`wolf3d-framerate/positions/evidence/center` and `southretry`; use render sequences
4→124 and 3→123 respectively, counting outbound offsets between those requests.

### RCF-008 — Direct drawing/composition has interface constraints

A native compositor could avoid repeated actor bitmap dispatch and exploit
opaque runs, but needs the bounds treatment in RCF-005. Direct hidden-framebuffer
drawing could remove the road image copy; the accepted VDPL framebuffer service
does not presently support this mode-136 double-buffered path. Its presence in
the SDK is not evidence that the proposed use is supported. Any extension needs
owner coordination and separate qualification.

Source: [current service restrictions](/Agon/mystuff/agon-vdplet/build/firmware/firmware-src/video/vdplet_runtime.h:73).

## Experimental interpretation and recommended order

1. Phase-profile the current accepted Native-span candidate. Old quad phase
   shares (road 42.56%, actors 34.54%, clear/title 14.08%, four physics ticks plus
   preparation 4.39%, excluding swap) are historical evidence, not current
   bottleneck percentages. Retain raw clocks, timer limits and final fence.
2. Compare the specialized additive sprite scaler against the general affine
   path on identical traffic/sign scenes. Separate player reflection, clipping,
   transparent padding and cache allocation costs. Measure completed full frames
   as well as isolated phases and inspect moving output.
3. Compare redundant-clear removal and wider span fills separately for attribution.
   Then consider bounded size caches, opaque-run composition and protocol changes
   as independent axes, preserving diagnostics and processor overlap.
4. Carry suitable findings to both implementations across every compatible
   caller under POS/REUSE/VDP audit requirements. Stock compatibility, native
   services and cache budgets differ; do not silently optimize only one car path.
5. Preserve negative evidence: integer quad was 15.18 versus float quad 15.66 FPS;
   disjoint quad strips reduced material writes approximately 48.7% but reached
   only 11.56 FPS while increasing fill count/dispatch. Native spans have already
   addressed that road-material overdraw. Fewer calculations, fewer pixels or
   fixed-point arithmetic alone do not select a winning implementation.

These are proposed experiments, not new task releases or measured gains. The
Author's motion review chooses acceptable approximation tradeoffs; identical
physics/world checks and complete rendering fences remain comparison evidence.
