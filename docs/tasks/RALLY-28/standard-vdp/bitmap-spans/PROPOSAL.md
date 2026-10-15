# RALLY-28 — Resident bitmap spans with stock VDP transforms

Explore whether preloaded one-pixel-high road bitmaps, horizontally scaled by the stock VDP and driven by one uploaded parameter buffer, can outperform the current buffered polygon renderer. The central question is whether reduced eZ80 work and wire traffic outweigh buffered-command interpretation and transformed-bitmap drawing costs. This document captures the discussion only. The Author will release individual small steps one at a time; implementation/testing was initially unreleased; subsequent scoped Author releases are recorded below.

## Motivation and current evidence

The current exact v5 rendering fixtures complete under Fab1.2.5: dense5.60FPS, fine lookup/direct14.15, fine buffered18.06, coarse/direct15.67 and coarse buffered19.93. They remain below the discussed30-rendered-FPS target. See [Fab results](../candidates/FAB-RESULTS.md); these are provisional emulator observations, not hardware performance. Flexe submission stalls remain a separate unresolved issue.

Original Pole Position used two16-bit Z8002s and one Z80, all at3.072MHz, plus specialized road/sprite video circuitry, at256×224visible pixels and approximately60.606Hz raster refresh. Its CPUs updated shared memory-mapped video parameters; road circuitry consumed road ROM patterns and per-scanline horizontal offsets. Refresh alone does not establish the original physics/update cadence. Summing CPU clocks is only a rough comparison: eZ80 pipelining and instruction cycle counts matter. The useful inspiration here is a cheap resident road representation, rather than attributing all performance differences to processor age or count.

Sources: [MAME machine/memory implementation](https://github.com/mamedev/mame/blob/master/src/mame/namco/polepos.cpp), [MAME road/sprite implementation](https://github.com/mamedev/mame/blob/master/src/mame/namco/polepos_v.cpp).

## Author's proposal

1. Preload road-span bitmaps that are one pixel high. The initial proposed source width is the smallest width rendered, corresponding to the most distant span. VDP horizontal matrix scaling expands these for nearer spans.
2. Associate each span with a bitmap ID, centre position and scale. A bitmap can potentially encode several road regions at once—surface, kerbs and markings—replacing several drawing primitives. Exact pattern content remains to be decided.
3. Upload changing parameters into a **single parameter buffer**. A **pre-built resident command buffer** reads those parameters and performs plotting. Do not send a separate verbose transform/draw sequence over the wire for every span.
4. Keep static assets and command sequences resident. Fixed row positions and perspective scales may also be precomputed/resident when the camera permits. This is an option to investigate, not a frozen requirement that scale must be transmitted each frame.
5. Use the stock buffered command and bitmap-transform APIs. This experiment stays under RALLY-28's standard-VDP area; custom firmware, Golem adoption and full-game integration are separate work.

Stock bitmap PLOT supports affine transforms, including scale: [PLOT commands](https://agonplatform.github.io/agon-docs/vdp/PLOT-Commands/). The [buffered API](https://agonplatform.github.io/agon-docs/vdp/Buffered-Commands-API/) documents matrix creation and buffer-fetched arguments. The exact supported parameter-fetch/patch sequence and its costs still require source review and a bounded proof. Firmware support does not imply hardware-accelerated scaling. Drawing with a transform and creating a newly transformed bitmap are different operations; the proposal is to reuse resident source bitmaps for plotting, without assuming per-frame asset creation.

## Open questions and measurement criteria

1. Can the actual pinned stock API express the resident parameter-driven sequence efficiently, including matrix selection/update, bitmap selection, centring and plot coordinates? What data formats and command bytes are required?
2. Is the smallest-width source adequate for useful kerb/marking proportions after expansion? Keep it as the initial candidate; a wider source is an optional measured alternative. Approximation is a tradeoff for Author review, not an automatic rejection.
3. Does one transformed plot per scanline cost less than the present polygon/band path? Count API interpretation, parameter reads/copies, transform work, pixel drawing, clipping and overdraw. A scanline method may issue more calls than coarse bands even with fewer primitives per row.
4. What are the eZ80 preparation/serialization cost, complete recurring wire byte count and completed-render time? Include parameter update headers/payloads/CALLs/replies/fences, setup cost and resident memory. Fewer transmitted bytes alone do not establish a net gain.
5. Can a small road-only comparison use identical poses and the existing completion mechanism against buffered polygons? Distinguish CPU-only, real transmission and completed drawing; avoid adding overlapping timings. This is a proposed eventual comparison, not authorization to build it now.
6. Preserve actual physics/rules, current candidate bytes and old fixtures. Any eventual full-scene integration must retain shared positioning consistency for road/traffic/sign/player/finish consumers. Physics cadence is chosen from measured capacity; this rendering experiment does not select120Hz or implement a scheduler.

## Execution boundary

Root TODO.md owns the actionable register, under immutable ID **SPAN-001-01**. This proposal is the discussion/specification record, not a second task list. No sequence of later subtasks is frozen: agree and execute one small step at a time. At the initial proposal gate, stop after documentation; subsequent releases below supersede that gate only within their stated scope. Any future unattended run must force both SDL_VIDEODRIVER=dummy and SDL_AUDIODRIVER=dummy; visible/audible review belongs to the Author.

## First released subtask — 2026-10-15

**SPAN-001-02** [x] — Enumerate the road-pattern combinations required by the current standard renderer. Trace material/stripe selection, colours, lane markings, road edges and any track-specific variants; distinguish independent choices from coupled phases so impossible combinations are not counted as required. Record evidence and the resulting catalogue here, with enlarged bitmap previews (approximately200pixels wide and8pixels high). These are documentation assets, not game assets or a renderer implementation. First checkpoint/push all current dirt and this scope, then perform enumeration and return for review. No emulator/build/deployment work is released.

## SPAN-001-02 finding — complete current road-pattern catalogue

**Finding: two base road patterns are required.** If the finish line also uses bitmap spans, it adds **two alternating checker overlays**. Kerb colour, shoulder-line colour and centre-dash visibility share one Boolean material phase; they are not independent switches. Both tracks and all current dense/fine/coarse/direct/buffered variants use the same two base colour layouts. There are no current extra road palettes for corners, grass/kerb contact, damage or different race phases.

The checkpoint preceding this enumeration is pushed commit `38fa5f4`. This finding and its previews are new, uncommitted documentation. No game asset, renderer, build, emulator session or deployment was changed.

### Base patterns

Previews below are actual200×8PNG images, with green margins to show the boundaries. They preserve conceptual lateral proportions, with approximate standard colours: logical2green grass,8dark-grey asphalt,9red kerbs,11yellow markings and15white. They are enlarged schematic cross-sections, not screenshots or final smallest-width VDP assets. Raster edge/endpoint rounding and transform sampling are deliberately not specified by these previews.

| Pattern | Left/right kerbs | Left/right shoulder lines | Centre dash | Asphalt |
|---|---|---|---|---|
| ROAD-0: unpainted | White15 | White15 | Absent | Grey8 |
| ROAD-1: painted | Red9 | Yellow11 | Yellow11 | Grey8 |

**ROAD-0 — unpainted**

![ROAD-0 unpainted,200×8](patterns/unpainted.png)

**ROAD-1 — painted**

![ROAD-1 painted,200×8](patterns/painted.png)

The exact authored lateral boundaries, before perspective scaling, are:

| Feature | Lateral coordinates relative to road centre |
|---|---|
| Outer kerb envelope | −106 to+106 |
| Asphalt overwriting that envelope | −90 to+90 |
| Left shoulder line | −86 to−84 |
| Right shoulder line | +84 to+86 |
| Centre dash, painted only | −2 to+2 |
| Grass | Outside outer kerbs |

Evidence: `rally-game/include/direct_road.hpp` emits the outer envelope, asphalt, both shoulder strips and optional centre strip with `paint[y]` controlling all changes. `rally-production/include/road.hpp` defines the same geometry/colours and `paint[y] = y >=116 && painted(y,phase)`, where `painted` compares `(depth+phase) %8000` with4000. Thus rows104–115 always use ROAD-0: the distant region does **not** require a third pattern. `lookup_road.hpp` starts material false, then switches at generated stripe boundaries; candidates/projection.hpp and buffered.hpp preserve these two layouts. Curvature, player lateral offset, track choice and perspective change placement/width, not the base pattern identity.

### Finish-line patterns

The existing finish is a separate overlay, drawn after the road. `rally-game/src/main.cpp:424` uses12equal-width alternating black0/white15cells across the asphalt width, in two successive vertical bands. The second band inverts the first. It uses the road centre at each band's top, band height `max(1,(y−96)/16)`, and clips at row223. Exact12cell edge rounding is done at the final width in the current renderer; scaling a small bitmap may approximate it.

**FINISH-0 — first band: black cell at the left edge**

![FINISH-0,200×8](patterns/finish-0.png)

**FINISH-1 — second band: white cell at the left edge**

![FINISH-1,200×8](patterns/finish-1.png)

These overlays replace the asphalt/markings under them, while kerbs and grass remain visible. If the finish continues using its existing rectangles, **only the two base bitmap assets are needed**. If represented as separate bitmap overlays, the catalogue is **two base assets plus two finish assets**. Combining finish and road in one plot instead gives the four composite layouts below, in addition to the two ordinary layouts. This is a complete cross-product of representation choices, not a claim that all combinations are reachable in every preserved fixture or an instruction to allocate six assets.

| Base | Finish band | Composite preview |
|---|---|---|
| ROAD-0 | FINISH-0 | ![Unpainted plus first checker band](patterns/unpainted-finish-0.png) |
| ROAD-0 | FINISH-1 | ![Unpainted plus second checker band](patterns/unpainted-finish-1.png) |
| ROAD-1 | FINISH-0 | ![Painted plus first checker band](patterns/painted-finish-0.png) |
| ROAD-1 | FINISH-1 | ![Painted plus second checker band](patterns/painted-finish-1.png) |

### Combination exclusions and remaining choices

1. Red kerbs with white shoulder lines, white kerbs with yellow shoulder lines, or a centre dash with white kerbs are **not current patterns**. Independently toggling three choices would wrongly create eight base variants; there are only two coupled states.
2. Fuji versus Tri-oval, left/right bends, straight road, near/far rows and left/right clipping require no additional colour patterns. Clipping is geometry; both shoulders have the same phase. Cars, signs, crash explosions, scenery, title/HUD and the black lower panel are separate scene elements, not road-span variants.
3. Grass is currently cleared across the whole road viewport before strips are drawn. The previews include it for context; whether bitmap margins include grass or use transparency remains an implementation choice. No transparent asset format or background-clear removal is selected here.
4. A narrow source must still represent narrow shoulder lines, the four-unit centre dash and, if included, twelve finish cells. At the top road row104, the current perspective factor is8/50: the outer-envelope geometric width is about33.9pixels and asphalt about28.8pixels. Authored two-unit lines become subpixel there. This is a width/quality decision for the next step, not a reason to multiply the pattern catalogue or reject the proposed smallest-width approach.
5. Fixed pattern identity does not imply identical raster output at every width. Current integer boundary rounding and transform sampling differ; source width, endpoint convention, clipping and possible width-specific assets remain unselected. No automatic pixel-accuracy gate is imposed.

Reproduction: run repository `.venv/bin/python docs/tasks/RALLY-28/standard-vdp/bitmap-spans/pattern_previews.py`. It writes only documentation PNGs and a source-hash catalogue. Scope is complete; stop for Author review before the next small step.

## SPAN-001-03 — straight-road sample demo, released 2026-10-15

Build an isolated sample in `bitmap-spans/SPAN-001-03/`, using the normal renderer's straight-road vertical span boundaries, perspective widths and stripe phase. Preload two one-pixel-high road patterns, a single mutable parameter buffer and a resident command buffer which fetches/patches parameters and plots transformed bitmaps. Demonstrate normal centred road plus bounded left/right clipping cases, with clear labels. Preserve all game/fixture inputs and keep finish/physics/full-scene integration outside this proof. Record actual command/data bytes and any representation/API limitations; this is mechanism/visual proof, not a speed benchmark. Headlessly qualify with both SDL dummy drivers on Oryx Fab and leave a fresh stopped visual profile for Author launch. Write scope and commit/push all existing dirt before implementation; return for review with new work uncommitted.


## SPAN-001-03 finding — demo ready for visual review

The isolated [sample and results](SPAN-001-03/README.md) demonstrate the proposed mechanism: two32×1road bitmaps, one720byte parameter plane and resident commands selecting preloaded per-row horizontal scale/centering matrices and plotting120one-pixel rows. Current straight-road stripe boundaries/perspective widths are retained; thin lines are deliberately quantized by the small source width. Both centre positions and scale selectors are fetched from the parameter buffer; y coordinates stay resident. Recurring road patch+CALL costs737upstream bytes before separate clear/labels/diagnostic traffic. This is not a speed measurement.

Final headless Oryx Fab test02 passes six views and64centre/edge/background pixel checks; exact input/runtime identities preserved, both SDL dummy drivers forced, owned process stopped. Fresh profile `.emulator/rally28-span03-review` is staged/stopped for Author launch via `./fab-agon-emulator`; audio always dummy. Prior dirt/scope pushed9a2e3e8. New demo/findings uncommitted; Author visual gate remains open. No further substep is started.

Author visual amendment: source bitmaps now34×1; each kerb gains one pixel outward (three pixels per side), and the centre dash is one pixel wide like each shoulder line. Original asphalt/shoulder positions and scale reference are preserved. Final silent Fab test03 passes all six views/64checks; fresh stopped review profile is rally28-span03-review02. Prior profiles/evidence preserved; no commit/push.

Author selects odd-width symmetric source: now35×1, with12asphalt pixels on both sides of the single centre dash; three-pixel kerbs and one-pixel shoulders retained. Canvas is centred about the centre pixel. Silent test04 passes6views/64checks; fresh stopped Oryx review profile rally28-span03-review03. No commit/push or further substep.


## Latest design discussion and proposed next steps — 2026-10-15

The Author approves the direction of the symmetric35×1source layout. Keep the two-pattern design and source widths:3kerb,1asphalt gap,1shoulder line,12asphalt,1centre dash,12asphalt,1shoulder line,1asphalt gap,3kerb. The unpainted bitmap replaces the centre dash with asphalt. Source symmetry removes the old built-in12/11imbalance; final scaling/placement can still produce pixel-rounding differences on the screen. Do not infer performance qualification or exhaustive visual acceptance from this discussion.

### Actual current wire representation

Each of120scanlines contributes three little-endian16bit fields: bitmap ID, centre X and scale-matrix ID. Y and the matrix coefficients are resident. Example for row104at centre160, unpainted: `3C D7 A0 00 A0 D7` (55100,160,55200). All records form one720byte parameter payload.

The current application sends three MOS writes: an11byte buffer-update header, the720byte payload in one write, then a6byte resident-buffer CALL. Header and CALL are constant, but must still be transmitted to delimit the update and trigger rendering in the current protocol. Only the payload changes. Road update+CALL totals737bytes; separate clearing/labels/completion/diagnostic traffic remains additional. Buffered commands are the rendering mechanism; C++ or Golem can produce them, and using Golem to generate equivalent blocks would not by itself change their runtime cost. The current sample and actual game are C++ compiled with AgonDev; Python generates the sample's asset/command header, while some existing fixtures use assembly timing/callback/UART helpers.

### SPAN-001-04 — proposed single application-resident submission buffer

Author's preferred implementation is one writable737byte command array embedded in the application binary:

```text
[constant11byte update header][mutable720byte span parameters][constant6byte CALL]
```

Initialize the complete array at build time. During the hot loop patch only the middle payload, then submit the whole array with **one MOS write**. Do not regenerate/copy the constant prefix/suffix each frame or construct the envelope on the stack. Keep one frame outstanding so parameter-buffer reuse remains safe. This changes application packaging/writer-call overhead, not wire bytes or VDP drawing semantics. Ensure the writable initialized array is present in the binary and its final memory placement is understood; a const array or compiler-inserted runtime initialization is not the intended design. Preserve the current sample as comparison evidence. This step is proposed for review, **not released for implementation**.

### SPAN-001-05 — proposed compiler-emitted assembly review

Inspect generated eZ80 instructions in the sample's recurring parameter-update/submission path and the actual standard game's hot loop. Keep those workloads clearly separate: six static demonstration views do not constitute an integrated gameplay hot-loop benchmark. Coordinate this review with RALLY-28's existing MATH/POS/REUSE audit rather than creating an independent optimization project.

1. Emit assembly with AgonDev's underlying Clang `-S`, retaining the actual build's optimization flags, target/ABI settings, defines and include paths. Verify the installed compiler's support for `-fverbose-asm` and useful debug/source annotations before promising a particular comment format. Preserve assembly and the exact invocation/toolchain/source identities as evidence. The current discussion has not performed that compiler capability check.
2. Trace parameter generation, packing and MOS submission back to source. Inspect repeated loads/stores, address/index calculations, sign/zero extensions, wide arithmetic helper calls, register spills and unnecessary function calls. Check that the proposed constant envelope remains static and only parameter bytes are rewritten, with one submission call.
3. Assess table/loop-invariant reuse and bounded16/24bit arithmetic opportunities across compatible consumers. Preserve existing range/rounding proofs, actual physics semantics and shared-positioning requirements. Identify potential gains; do not silently implement each observation or reject approximate-rendering candidates on accuracy alone.
4. Compiler-emitted assembly is the first inspection artifact, avoiding a mandatory disassembly step. Use the linked map/binary when final placement, called library implementations, linker effects or suspicious code generation need confirmation; emitted source assembly alone does not establish what every linked routine does.
5. Static instruction observations are not cycle measurements or FPS. Record selected changes and expected costs before any separately released implementation/comparison. Any eventual performance test must include real wire traffic and completed rendering, retain independent physics service, and avoid treating diagnostic pauses/readbacks as useful render work.

Root TODO owns proposed SPAN-001-04/05 checkboxes. Both await Author review/release; the one-small-step-at-a-time workflow remains in force. This update is documentation only. No source changes, compile/assembly emission, benchmark/emulator run, deployment, peer mail, commit or push is authorized by this documentation request. Stop for review.


## SPAN-001-04/05 released tranche returned — 2026-10-15

Author selected high reasoning and released the proposed packaging/assembly/headless-qualification tranche. Both technical deliverables are complete: [results, evidence and ranked next candidates](assembly-review/RESULTS.md). The737byte command is now a writable initialized array embedded in the binary, with only bitmap/centre fields patched and one road-envelope MOS write. Fixed matrix IDs also remain initialized rather than rewritten. Drawing function's static listing shrinks99to72instructions and local frame44to23bytes; this is not measured speedup. Six headless Fab views/64pixel records match the previous35pixel sample exactly, and saved737byte command/linked initialization independently verify. Fresh stopped Oryx profile: rally28-span03-single-write-review; Author visual gate remains open.

Assembly uses actual build flags with `-S -fverbose-asm`. Compiler function/block/spill comments work; `-gline-tables-only` emits no usable line tables/debug sections on this pin and changes the game's text, so ordinary assembly is authoritative. Current sample and standard-game ordinary inspection text match existing objects.98protected files remain unchanged. Ranked findings include row-phase precomputation instead of108recurring wide remainders, simplifying packing after those calls are removed, dropping static wire fields in a separately scoped protocol, and the actual game's4264byte frame containing an inlined startup-only4096byte temporary. Existing shared lookup/consumer optimizations remain separately preserved; no extra fixes or performance campaign were applied.

SPAN-001-05 research is complete and recorded in the development log; root TODO retains SPAN-001-04's Author review gate. New code/evidence/docs remain uncommitted. No commit/push, physical/firmware/SDK change, graphical/audio launch, additional optimization or next substep is inferred. Stop for Author review.


Author accepts single-write demo and releases [SPAN-001-06–10 independent benchmark plan](BENCHMARK-PLAN.md). Required separation: actual physics capacity, eZ80 preparation/transmission, VDP-local fenced frame execution/completion, and overlapped completed throughput. Final truth on Olimex mainboard using admitted Extender input and Legacy route; follow normative test lifecycle/coordinator rules. Commit/push all dirt first, then independent work without hardware takeover or Author attention. No graphical/audio launch.
