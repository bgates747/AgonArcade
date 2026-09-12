# RALLY-10 — Investigate Rally performance and frame pacing

## Objective and constraints

Previous temporary comparison: [pavement-only experiment](RALLY-10/pavement/README.md).
The user explicitly requires all experiment code in that task bucket, with
mainline game code untouched. It removes visible kerbs/stripes and their band
splits while retaining the existing projection and all other scene/gameplay work.
The [headless results](RALLY-10/pavement/results/README.md) give 14.01 FPS
equivalent on the oval and 13.64 on Fuji (71.35/73.31 ms), still 4.28/4.40 times
the 16.67 ms budget. Fixed-pose fixtures exclude elapsed-time physics.

Current implementation: [RALLY-15](RALLY-15.md), with all code isolated in its
own [task bucket](RALLY-15/README.md). The earlier
[VDP-resident section design](RALLY-10/sections/README.md) has become a working
stock-VDP renderer: eight endpoint bytes expand into a complete pavement/marking
section, at 25 UART bytes per update/call. Native protocol captures match an
independent direct-PLOT reference. Full-scene headless fixed-pose averages are
22.59/23.63 FPS on oval/Fuji, 44.27/42.32 ms per frame; see
[measurement scope and limits](RALLY-15/results/README.md). Human acceptance
and promotion into mainline remain pending.

The preceding band-boundary experiment is defined by the
[frozen band-boundary contract](RALLY-10/band-boundaries-contract.md).

Identify the largest costs using measurements, then improve responsiveness and
pacing one reviewed change at a time. Root [TODO.md](../../TODO.md) owns task
status; this document holds execution detail, not a second checklist.

Rally ships on stock VDP. Diagnostic custom modules belong to RALLY-14. The
clock is 120 raw ticks/second in mode 136, confirmed by the user. Preserve
current physics coefficients, three steering units per rendered update, 60%
grip, speed cap, both tracks and artwork. Autosteer changes remain deferred
under RALLY-13. No asynchronous scheduler without evidence that it is needed.

## Established work

An opt-in stock post-swap general-poll fence and bounded buffered timing records
are implemented. Mac and Linux sanitizer tests pass. Two fenced Mac samples
acknowledged all 201 submitted frames without timeouts. Baseline counts varied
from 69 to 111 versus 101/100 fenced over approximately 20 guest-clock seconds:
there is no consistent performance improvement. Coarse road-projection timing
dominates the steadier samples, but host scheduling and different demo
trajectories prevent treating this as an isolated hardware result.

The fence works on the native emulator; hardware completion ordering and
performance remain unqualified. Source ordering is evidence, not proof of
physical monitor presentation. The Author authorized a development checkpoint commit on 2026-09-12;
pending renderer and hardware acceptance tasks remain open.

## Agreed sequence

1. Qualify the stock completion signal: alternating token after swap, one
   outstanding request, terminal timeout and safe shutdown. Emulator token
   exchange is demonstrated; preserve the remaining hardware qualification.
2. Collect buffered timings for control/physics, projection, command submission,
   completion waits, frame intervals and catch-up. Existing instrumentation
   supplies a coarse baseline; distinguish CPU command preparation, backpressure
   and actual VDP execution rather than attributing them to one another.
3. Compare controlled workloads: scenery off/on, traffic absent/present, and
   player facing left/right. Use identical camera/vehicle poses or a deterministic
   pose sequence independent of rendered-frame cadence. Keep ordinary gameplay
   unchanged. Repeat in reversed order and record runtime identity, workload,
   counts, clock units, distributions and host-load limitations.
4. Optimize the measured bottleneck. Candidates include projection/interpolation
   work, precomputed mirrored car images and cached traffic scales. Narrow
   shoulders and retained scenery already exist; their hardware benefit remains
   inconclusive. Change one contributor, rerun the same fixture, inspect pixels
   and obtain human review before another optimization.
5. Try simple synchronous pacing first. Consider bounded asynchronous physics
   only if the measurements justify its additional complexity and tuning impact.

## Controlled comparison — ready for review

Step 3 now has a fixed 64-pose fixture and repeated headless comparisons.
Sixteen runs use identical poses and road bytes, with 896 successful measured
frame acknowledgments and no timeouts. Road-band generation/stream construction
is the largest measured Mac stage, followed by geometry; together they account
for about 74% of full-scene fenced batch time. Traffic has a smaller measurable
submission cost. Scenery and reflection do not show a large consistent effect
in these samples; hardware VDP costs remain unresolved.

Read the [results and limitations](RALLY-10/results/2026-09-11-controlled/README.md).
The strongest measured CPU target is road-band generation/stream construction.
Separating greedy band search from encoding would refine that attribution;
the alternatives below may instead remove most of this runtime work outright.
RALLY-14 remains the route for high-resolution VDP execution timing and callbacks
to MOS. The user subsequently authorized the band-boundary experiment below.

All performance and automated visual runs must be headless, per the user.
A graphical emulator launch is reserved for the human review notification.

## Precomputed band experiment

The [frozen contract](RALLY-10/band-boundaries-contract.md) defines this iteration.
Before renderer edits, 59 files, including all changed/new files and the existing
binary, were included in a checksum-verified archive at repository-relative
`.research-cache/checkpoints/rally-before-band-table-20260911-222616/`.
Its manifest records HEAD and individual file hashes; worktree and index patches
are also retained. Archive SHA-256:
`eacaa0ea794ab11415dca1ab4aeb1c9a07184bba02c1caf2ce1103002fce7cab`.
This preserves the prior work without committing unreviewed emulator changes.

A universal screen-row table required 65 geometric bands at the selected
conservative error tolerance. The 4 KiB road-command buffer is an application
RAM allocation, not a VDP limit: it could be enlarged. The concern is the extra
construction, transmission and drawing work as well as capacity. Within the
same precomputed-boundary experiment, shorter track sections avoid paying for
the sharpest distant curve in every view. No larger-buffer universal-table
timing comparison was performed.

The candidate has 2,408 boundary lists, one per 16-world-unit section of each
track. Lists and offsets occupy 22,725 bytes. Runtime selects a list, splits it
at existing material transitions, and uses the unchanged strip emitter. The
`fixedbands` option selects this path; greedy remains the default comparison.
The runtime adds no floating-point maths and retains per-row projection.

The [host generator](RALLY-10/generate_band_table.cpp) uses the existing integer
projection at quarter-unit intervals plus the final hundredth of each section.
A 112/256-pixel full-segment tolerance leaves room for material splits. Separate
validation uses 0.37-unit spacing, both sides of section/lap seams and camera
offsets of -100, 0 and +100 world units. On both Mac and Linux, 334,053 tested
views have maximum centreline error 0.449707 pixels. All 202 distinct material
patterns against every table fit: at most 32 emitted bands and 3,945 bytes in
the 4,096-byte buffer. These are sampled geometry bounds, not exhaustive proof
over every possible position and offset. Generated output reproduces exactly.

Use [compare_bands.py](RALLY-10/compare_bands.py) for serial headless ABBA timing
on each track, and [capture_bands.py](RALLY-10/capture_bands.py) for separate
headless native stills. Both variants share one binary and identical fixture
poses. Command volume is expected to differ and is reported with timing.

The [eight-run comparison](RALLY-10/results/2026-09-11-bands/README.md) shows
about 25% less full-fixture time on each track, with a 55–61% reduction in the
band stage. Road-command bytes rise 52% on the oval and 28% on Fuji; actual VDP
operation timing and physical-hardware performance remain unqualified.

### Next discussion: buffered VDP commands and UART traffic

Following the striping/scanline discussion, the user requested exactly 120 road
rows. `RoadTop` is now 104, with `Bottom` still 223 and horizon still 96. The
scenery was extended to 104 rows while preserving its original pixels. Both
generated band tables and scenery assets were regenerated; band tables now use
21,619 bytes. The earlier timing results below/linked above describe the prior
121-row build and have not been rerun for this small viewport adjustment.

After reviewing this band-table iteration, the user wants to discuss the stock
VDP buffered-command API as a way to reduce UART byte traffic. Keep this as the
next discussion, not a second implementation in the current experiment.
Assess which road commands can remain resident on the VDP, how changing
coordinates/materials would be updated or selected, and the cost of uploads,
patches and execution requests. Compare net wire bytes and measured time;
storing a command sequence does not by itself establish that it is reusable
across the required road views.

## Design discussion — replacing computation with stored data

Recorded after the controlled comparisons. The band-boundary experiment above
is now authorized; the other alternatives remain discussion, with no permission
to replace either track or its handling.

### What the measurements mean

Geometry and band construction operate on the eZ80: they calculate positions and
write commands into RAM, without UART or VDP drawing inside those timed stages.
The user emphasized that Fab's calibrated eZ80 instruction timing is substantially
more reliable than its VDP/I/O timing. Treat the results as strong evidence of an
eZ80 computation bottleneck, rather than dismissing them as desktop VDP effects.
Host-load outliers still need care. Actual VDP operation timing remains RALLY-14.

The approximately 74% figure identifies the affected computation budget in the
controlled fixture; it is not a promised saving or a measurement of VDP raster
time. Loading, decoding, interpolation, patching and remaining rendering all cost
time. No speedup estimate has yet been established for the proposals below.

### Current method and original-game lesson

The runtime looks up/interpolates track points, projects a road centre for each
screen row, derives edges and materials, then greedily searches for rows that can
share a trapezoid within a one-pixel error bound. Bands already span multiple
rows; the repeated search for their boundaries is a leading suspect within the
largest measured stage. Its cost has not yet been isolated from command encoding.
The renderer uses integer/fixed-point arithmetic, not floating point. Explicit
32-bit products/divisions can nevertheless be expensive on a 24-bit eZ80.
Generated assembly and numeric bounds could identify helper calls, narrower
safe intermediates or calculations that can be eliminated.

The [original Pole Position research](../research/pole-position/README.md#2-what-the-original-hardware-establishes)
found dedicated raster hardware driven by vertical PROM lookups, separate
scanline horizontal offsets, road-position address changes, compact ROM patterns
expanded in eight-pixel groups, and separate object-scaling hardware. It did not
recover the original software's curve equations or exact PROM values. Our greedy
band search is an Agon design choice, not a discovered original-game technique.

The user questioned why a lookup-oriented research conclusion led to expensive
per-frame computation. Retain the existing row renderer as an offline correctness
reference; evaluate moving its expensive work out of the runtime. Agon lacks the
original road circuitry, but compact descriptions expanded from stored data are
still applicable. The existing track itself is already sampled lookup data; we
are not scanning a track image during play. Projection and band construction are
the remaining repeated work.

### Assembly maths reference

Consult sibling `mystuff/agon-fsim` before implementing new arithmetic kernels.
The user reports useful assembly maths there: multiplication/division primitives
include hand-written work by them and other humans, and numerous 3D matrix
transforms work well in that project. The
[fsim assembly reachability audit](../../../agon-fsim/agon/04-assembly-reachability-audit.md)
identifies exact `pingoasm` and AgonMaths donor sources, including
`p3d_umul16x16_32`, `p3d_smul16x16_32`, and `p3d_mat3_mul_vec3_16`.
Follow those donor references rather than assuming the assembly is vendored in fsim.

Reusing selected arithmetic or transform routines is another option alongside
precomputation. First establish which Rally operations dominate, then check each
candidate's fixed-point format, signedness, overflow bounds, rounding, register
use, C/C++ ABI and provenance. Benchmark the adapted operation and full geometry
stage headlessly; successful use in fsim does not establish a Rally speedup.
Avoid importing an entire 3D library for a few useful primitives.

### Wolf3D rendering references

The user supplied two more local references. Inspection of the current checkouts
shows that **AgonWolf3D is the precomputed-view example; Wolf3dOrig is the live
raycasting example** (the names were reversed in the conversational description).

1. **AgonWolf3D: move view construction into the build.** The
   [map build format](../../../AgonWolf3D/docs/map-design-manual/appendix-b-map-build-format.md)
   describes stage 07 testing projected panels for occlusion for each cell and
   four orientations. Up to 48 panels are represented by six-byte visibility
   masks: 256 cells × 4 orientations × 6 bytes = 6,144 bytes, excluding bitmap
   assets and other tables. These masks serve rendering and enemy awareness.
   Inspect [panel generation](../../../AgonWolf3D/build/scripts/build_07_polys_make_map_panels.py),
   [mask generation](../../../AgonWolf3D/build/scripts/build_91c_asm_map_masks.py),
   and [runtime rendering](../../../AgonWolf3D/src/asm/render.asm): `render_panel`
   selects a bitmap buffer and retrieves screen coordinates from
   `polys_lookup_plot`. For Rally, the transferable idea is stored view structure
   plus cheap runtime selection. Continuous movement, lateral displacement and
   material phase still require explicit handling; four discrete directions
   do not establish sufficient sampling for a driving game.
2. **Wolf3dOrig: live rendering with selected precomputation.** Its
   [architecture](../../../Wolf3dOrig/README.md) puts simulation on the eZ80 and
   column DDA raycasting, sprite projection and composition in a custom ESP32
   VDP, implemented in the separate `agon-vdp-wolf3d` repository. Its
   [first rendering milestone](../../../Wolf3dOrig/agonport/doc/first_correct_render_success_story.md)
   records a 360-entry fixed-point movement table eliminating runtime trig and
   multiplication for that fixed-speed fixture, and a cached projection
   numerator incorporating the original quarter-pixel height conversion.
   It also records compact changed-state commands and one callback-gated render
   in flight. These illustrate removing invariant arithmetic even in a live
   renderer. The original Wolf3D source is its behavior reference; the current
   port credits Codex implementation and human direction, so do not attribute
   this port's code directly to John Carmack. Its bespoke VDP architecture is
   not a drop-in option for Rally's stock-VDP target.

These references support comparing precomputed data, focused arithmetic kernels
and live computation at the level of individual hot operations. They do not
provide a measured Rally speedup or select the next implementation by themselves.

### Alternatives discussed

| Alternative | Potential benefit | Questions and trade-offs |
| --- | --- | --- |
| Small row lookup tables | Replace repeated edge-width/scale arithmetic with indexed values; depth is already precomputed. | Measure which arithmetic remains significant and bound table types. Preserve rounding and output. |
| Material-phase tables | Precompute repeating kerb/marking classifications or transition rows. | Choose phase resolution without strobing or visible stepping; couple phase to travelled distance. |
| Predetermined multi-row bands | Remove the greedy merge search; each band is a trapezoid, not necessarily one pixel high. | Account for curves and material transitions. Fixed boundaries may require more commands or permit more error. Compare pixels and UART byte counts. |
| Straight and circular-arc track sections | Store radius/length and use heading/position tables; constant-radius interiors offer reusable camera-relative road shapes. | Circular geometry alone does not remove band search. Views spanning section transitions require special treatment; changing the course needs agreement. Preserve Fuji and current source geometry. |
| Precomputed views of existing tracks | Store projected centres, edges or complete bands for sampled track positions, retaining the arbitrary track shapes. | Quantization, interpolation, lateral camera displacement, marking phase and lap seams must remain smooth. No circular-track redesign is required to try this. |
| Offline binary road data | Run expensive computations on the host, then store geometry, bands or ready-to-send VDP command streams in an indexed binary file. | Size, loading latency, decoding/patching costs and RAM/VDP residency determine whether this beats computation. Serial transfer and VDP drawing costs remain. |

Within a constant-radius section, the camera-relative shape of an interior view
can repeat, but the distance to the next section changes and affects the visible
road ahead. Reusing a single bend template across transitions would be incorrect.
Straight/arc construction is an option to simplify the representation, not a
requirement for precomputing the existing courses.

### Offline binary data and loading strategy

The user's brute-force proposal is to perform the computations offline, write
the results to a binary file, and load records from disk as needed. Candidate
record levels range from projected centres to complete VDP command streams.
At runtime, select the track-position record, apply any necessary small camera/
material adjustments, and submit it. Neither the cheapness of those adjustments
nor the feasibility of eliminating them should be assumed before measuring.

1. Size alternatives explicitly: track-position samples × independent phase
   variants × camera-offset variants × bytes per record, plus indexing. Avoid
   multiplying dimensions that are deterministically related; also check lap
   wrapping, where continuous marking phase may not follow wrapped position.
2. Compare full precomputation against compact base geometry plus inexpensive
   adjustments. Preserving continuous lateral camera motion is a key constraint;
   exhaustive offset tables can become large, while interpolation restores some
   runtime arithmetic and may change band boundaries.
3. Consider loading the complete dataset when it fits; otherwise read sequential
   chunks ahead into a RAM cache. Do not put an unpredictable SD read on every
   rendered frame. A look-ahead cache does not require an asynchronous physics
   redesign, but read scheduling, startup position, lap wrap and cache misses
   need an explicit policy and measured worst-case latency.
4. For ready-made commands, compare sending stored bytes from RAM with retaining
   and invoking command buffers on the stock VDP. Count coordinate-patching and
   upload overhead; stored commands do not eliminate VDP execution costs.
5. Define a versioned format tied to track/camera/material parameters, with
   explicit widths, byte order, bounds and validation. Decide whether external
   data is a development experiment or a new deployment dependency; the current
   self-contained binary should not silently become dependent on missing files.

### Evidence needed to choose an implementation

Use task-owned offline generators and sizing experiments under `RALLY-10/` to
compare a small-table approach, predetermined/precomputed bands and indexed
binary records. Report storage/RAM costs, eZ80 work, command bytes, native pixels,
phase/offset resolution and SD/cache latency. Keep the current renderer as the
reference for straight sections, bends, transitions, lateral offsets and lap
seams. Use the same controlled poses and headless tests, then launch a graphical
emulator only when a concrete candidate is ready for human review. Select one
approach deliberately before changing track design or deployment requirements.

## Acceptance for the next review

1. Each comparison uses the same scene or pose sequence, with exactly one
   documented workload difference and no per-frame file/console logging.
2. Reports distinguish submitted, acknowledged and displayed events, and CPU,
   UART/queue and VDP costs wherever measured. Unknown quantities stay explicit.
3. Repeated samples and an instrumentation-overhead comparison support a ranked
   list of costs, or explicitly explain why a ranking remains unresolved.
4. Relevant host checks and native visual checks pass. Launch the prepared
   graphical emulator for the user's review, preserving their current handling.
5. Do not claim hardware improvement from Mac samples. No physical SD write
   without a deployment request; preserve autoexec.txt on any physical card.

## Files and evidence

Task-specific scripts and new results belong under [RALLY-10/](RALLY-10/).
The existing A/B helper is [run_timing.py](RALLY-10/run_timing.py):

```sh
.venv/bin/python docs/tasks/RALLY-10/run_timing.py
.venv/bin/python docs/tasks/RALLY-10/run_timing.py --reverse
```

For the controlled suite and its focused reflection repeat:

```sh
.venv/bin/python docs/tasks/RALLY-10/run_timing.py --workloads --passes 2
.venv/bin/python docs/tasks/RALLY-10/run_timing.py --workloads --cases full-fence mirror-fence --passes 2
```

Without `--workloads`, the helper retains the older 20-second demo comparison.
[Visual checks](RALLY-10/capture_workloads.py) run headlessly and separately from
timings; [summarize_timing.py](RALLY-10/summarize_timing.py) regenerates the tables.
Generated profiles/results remain under
ignored `rally/.emulator/benchmarks/`; promote selected evidence into the task
folder with its provenance. Reusable build/profile tools stay in `rally/tools/`.

References: [original research](../research/rally-frame-pacing.md),
[first Mac measurements](../research/rally-timing-2026-09-11/README.md),
[Mac development log](../2026-09-11-rally-macos.md),
[diagnostic instrumentation task](RALLY-14.md).
