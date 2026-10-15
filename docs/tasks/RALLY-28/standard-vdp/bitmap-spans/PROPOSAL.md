# RALLY-28 — Resident bitmap spans with stock VDP transforms

Explore whether preloaded one-pixel-high road bitmaps, horizontally scaled by the stock VDP and driven by one uploaded parameter buffer, can outperform the current buffered polygon renderer. The central question is whether reduced eZ80 work and wire traffic outweigh buffered-command interpretation and transformed-bitmap drawing costs. This document captures the discussion only. The Author will release individual small steps one at a time; no implementation or testing is currently authorized.

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

Root TODO.md owns the actionable register, under immutable ID **SPAN-001-01**. This proposal is the discussion/specification record, not a second task list. No sequence of later subtasks is frozen: agree and execute one small step at a time. Stop after this documentation change. No build, emulator run, deployment, peer modification, commit or push is authorized by this request. Any future unattended run must force both SDL_VIDEODRIVER=dummy and SDL_AUDIODRIVER=dummy; visible/audible review belongs to the Author.

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
