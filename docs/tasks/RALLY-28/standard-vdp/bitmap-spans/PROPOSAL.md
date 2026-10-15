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

**SPAN-001-02** — Enumerate the road-pattern combinations required by the current standard renderer. Trace material/stripe selection, colours, lane markings, road edges and any track-specific variants; distinguish independent choices from coupled phases so impossible combinations are not counted as required. Record evidence and the resulting catalogue here, with enlarged bitmap previews (approximately200pixels wide and8pixels high). These are documentation assets, not game assets or a renderer implementation. First checkpoint/push all current dirt and this scope, then perform enumeration and return for review. No emulator/build/deployment work is released.
