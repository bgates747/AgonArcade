# Pole Position research source register

Sources were inspected on September 11, 2026. Stable code links use exact Git
revisions. Downloaded source bytes, sizes, UTC retrieval times and SHA-256 hashes
are recorded in [the manifest](sources/manifest.json). Original documents remain
in the ignored repository-local `.research-cache/pole-position/`; this register,
the original analytical notes, figures and calculations are durable repository
artifacts. No arcade ROM images were downloaded.

The evidence hierarchy is original documentation, inspectable implementations,
first-person accounts, then original explanatory demonstrations. Search snippets,
Wikipedia, forum speculation and later-game comparisons are not the technical
basis of the report. A reimplementation is authoritative about its own behavior;
it does not automatically establish every detail of original hardware.

## 1. Atari SP-218 schematic package

**Publisher:** Atari, licensed Namco design. **Document:** *Pole Position
Schematic Package*, SP-218, eighth printing, ©1982. **Host:** Stardust Arcade's
preservation mirror. [Original 32-page PDF](https://files.stardustarcade.com/PDF_Arcade_Atari_Kee/Pole_Position/Pole_Position_SP-218_8th_Printing.pdf).

Inspected the contents page and the video sheets below as rendered page images.
The PDF is scanned and its ordinary text extraction is empty, so search results
and text search alone are inadequate. Page labels were read from the drawings.

| Printed sheet | PDF page, one-based | Locator |
| --- | ---: | --- |
| 1A | 1 | Contents and document identity |
| 11B | 22 | Vertical-position modifiers, buffers/adders, bus interface |
| 12A | 23 | Video RAM addressing and playfield memory |
| 12B | 24 | Picture addressing and roadway circuitry |
| 13A | 25 | Playfield/color lookup portion |
| 14A | 27 | Object match and size clock |
| 15A | 29 | Object horizontal counters and line buffers |
| 15B | 30 | Output selection and RGB circuitry |

This is evidence for block organization and signal connections. It is not the
original software listing or a measured set of PROM values. Do not substitute
Pole Position II upgrade sheets or assume every Atari/Namco board revision uses
identical labels. File `schematic.pdf` and page renders are cached locally.

## 2. MAME video reconstruction

**Authors:** Ernesto Corvi, Juergen Buchmueller, Alex Pasadyn, Aaron Giles,
Nicola Salmoria and subsequent MAME contributors. **License:** BSD-3-Clause.
**Revision:** `9fc40a6475d9d8d027f1df29db607627f65f5c04`, resolved from MAME's
master branch during this research.

[Permanent source](https://github.com/mamedev/mame/blob/9fc40a6475d9d8d027f1df29db607627f65f5c04/src/mame/namco/polepos_v.cpp).

| Location | Inspect for |
| --- | --- |
| `polepos_palette`, lines 30–135 | Palette groups and vertical modifier assembly |
| `video_start`, lines 183–194 | Tilemap configuration |
| `draw_road`, lines 304–373 | Road addressing and sample expansion |
| `zoom_sprite`, lines 375–421 | Reconstructed scaling and transparency |
| `draw_sprites`, lines 423–448 | Object descriptor decoding |
| `screen_update`, lines 451–460 | Layer composition |

Caveat: use the executed expressions when a descriptive comment and implementation
appear to use different address units. Do not convert a word index directly into
a CPU byte address. The source itself marks some behavior as approximate.
Cached filename: `polepos_v.cpp`.

## 3. MAME machine driver and declarations

Same authors, license and pinned revision as source 2.
[Machine driver](https://github.com/mamedev/mame/blob/9fc40a6475d9d8d027f1df29db607627f65f5c04/src/mame/namco/polepos.cpp),
[declarations](https://github.com/mamedev/mame/blob/9fc40a6475d9d8d027f1df29db607627f65f5c04/src/mame/namco/polepos.h).

Inspect the introductory hardware/memory notes, `z8002_map`, `polepos` machine
configuration, `set_raw`, and ROM-region labels. The same driver contains
multiple games and revisions; use original `polepos`, not a sequel's extra
hardware, when describing the first arcade game. The calculated refresh rate
comes from `24,576,000 / 4 / (384 × 264)`, not from measurement.
Cached filenames: `polepos.cpp`, `polepos.h`.

## 4. Bandai Namco creator interview

**Publisher:** Bandai Namco Entertainment. **Title:** バンダイナムコ知新
「第2回 カーレースゲームの変遷 前編」. **Date:** April 25, 2019.
[Original interview](https://www.bandainamcoent.co.jp/asobimotto/page/carracinggames1.html).

Read the Pole Position discussion with Shinichiro Okamoto and Sho Osugi. The
article also discusses Final Lap; do not transfer those later-game details into
claims about Pole Position. The report paraphrases a small part of the
Japanese-language interview and does not present an unofficial translation as
an original English quotation. Cached filename: `namco-interview.html`.

## 5. Louis Gorenfeld's road-engine explanation

**Author:** Louis Gorenfeld. **Title:** *Lou's Pseudo 3D Page*.
**Displayed update:** May 3, 2013.
[Author's site](https://www.extentofthejam.com/pseudo/).

Read Road Basics, the Z Map discussion, Curves and Steering, Sprites and Data,
and the distinction between raster roads and projected segments. Used as an
original explanation of those techniques, not as evidence of Namco's program.
Some techniques deliberately bend geometry for appearance; distinguish those
artistic constructions from the report's flat-plane derivation.
Cached filename: `lou.html`.

## 6. Jake Gordon's straight-road implementation

**Author:** Jake Gordon. **Title:** *How to build a racing game — straight roads*.
**Date:** 2012.
[Author's current article](https://jakesgordon.com/writing/javascript-racer-v1-straight/).
The older Code inComplete URL redirects here.

Read the projection/coordinate discussion and rendering section. Useful as a
working example of constructing a road from projected cross-sections. Browser
Canvas drawing costs do not estimate Agon VDU transport costs.
Cached filename: `gordon-straight.html`.

## 7. Jake Gordon's curve implementation

**Author/date:** Jake Gordon, 2012.
[How to build a racing game — curves](https://jakesgordon.com/writing/javascript-racer-v2-curves/).

Read the offset/slope accumulators, interpolated base-segment correction and
curve transitions. It is an example of an intentionally approximate road model.
Its `curve` parameter is not automatically a physical inverse-radius value.
Cached filename: `gordon-curves.html`.

## 8. Agon screen-mode documentation

**Publisher:** AgonPlatform. **Local revision:**
`f9806bd3cbff6ed5d1c08bef1d51fed11764b86b`.
[Screen Modes](https://github.com/AgonPlatform/agon-docs/blob/f9806bd3cbff6ed5d1c08bef1d51fed11764b86b/docs/vdp/Screen-Modes.md).

Read mode 136, physical coordinates and screen swapping. The installed local
copy is under `~/Agon/agon-docs/docs/vdp/`. Mode support and memory availability
still need checking on the actual target; successful Defender use is useful
local evidence, not universal firmware compatibility.

## 9. Agon primitive and bitmap documentation

Same documentation revision as source 8.
[PLOT Commands](https://github.com/AgonPlatform/agon-docs/blob/f9806bd3cbff6ed5d1c08bef1d51fed11764b86b/docs/vdp/PLOT-Commands.md),
[Bitmaps API](https://github.com/AgonPlatform/agon-docs/blob/f9806bd3cbff6ed5d1c08bef1d51fed11764b86b/docs/vdp/Bitmaps-API.md).

Read absolute/relative PLOT semantics, triangle cursor history, rectangle fills,
paint modes, bitmap formats and drawing. The report's packed-quad cost is based
on the documented point history; its native seam behavior remains a benchmark
acceptance item. Ordinary bitmap plotting and activated software sprites are
separate rendering paths.

## 10. Installed VDP link configuration

**Runtime:** Fab 1.2.4, root commit
`194a5e44c36a8bb886dae1741b01c6e7a1e5ede7`.
**VDP submodule:** `tomm/agon-vdp`, revision
`7bcf28e0a2376e32328a6a5554d0df852b75c80e`.

[`video/agon.h`](https://github.com/tomm/agon-vdp/blob/7bcf28e0a2376e32328a6a5554d0df852b75c80e/video/agon.h),
[`video/vdp_protocol.h`](https://github.com/tomm/agon-vdp/blob/7bcf28e0a2376e32328a6a5554d0df852b75c80e/video/vdp_protocol.h),
[`video/version.h`](https://github.com/tomm/agon-vdp/blob/7bcf28e0a2376e32328a6a5554d0df852b75c80e/video/version.h).

The inspected header identifies Platform VDP 2.16.0, Bistromathics. The folder's
historical `vdp-console8` name is not a reliable firmware-version identifier.
`UART_BR` and `SERIAL_8N1` establish the nominal link/framing assumptions. The
manifest records the actual submodule revision, rather than pretending those
files belong directly to the Fab root commit.

## 11. Installed agondev encoders

**Publisher:** AgonPlatform. **Revision:**
`b67ab2444a63267a42193f204889d466765d8dd2`.
[VDP library directory](https://github.com/AgonPlatform/agondev/tree/b67ab2444a63267a42193f204889d466765d8dd2/src/lib/libvdp).

Read `vdp_move_to.c`, `vdp_line_to.c`, `vdp_filled_rectangle.c`,
`vdp_filled_triangle.c`, `vdp_set_graphics_colour.c`, and `vdp_swap.c`.
`vdp_gcol` is a header alias for `vdp_set_graphics_colour`.
The corresponding local files are hashed in the manifest. Their byte layouts
support the transport arithmetic; their existence does not establish achieved
VDP drawing throughput.

## 12. Agon stored-command documentation

[Buffered Commands API](https://github.com/AgonPlatform/agon-docs/blob/f9806bd3cbff6ed5d1c08bef1d51fed11764b86b/docs/vdp/Buffered-Commands-API.md),
same revision as source 8. Read “Using buffers for command sequences” and
commands 0, 1 and 5. Considered as a conditional optimization, not a mandatory
starting architecture. Update traffic must be counted as well as call traffic.

## 13. Fab UART implementation

[UART source](https://github.com/tomm/fab-agon-emulator/blob/194a5e44c36a8bb886dae1741b01c6e7a1e5ede7/agon-ez80-emulator/src/uart.rs),
Fab 1.2.4. Read `apply_ticks`, `send_byte`, and receive timing comments. Also
inspected UART0 register routing in `agon_machine.rs`. Do not claim the emulator
has an unlimited VDP pipe, or that its desktop video performance equals hardware.

## 14. Atari operator/service manual

**Publisher:** Atari. **Document:** *Pole Position Operation, Maintenance, and
Service Manual*, TM-218, seventh printing.
[Original scan](https://files.stardustarcade.com/PDF_Arcade_Atari_Kee/Pole_Position/Pole_Position_TM-218_7th_Printing.pdf).

Inspected cover and contents, PDF pages 3 and 6, to identify the document and its
scope. This manual is primarily operations, service and parts information; it
is not used to assert an undocumented graphics algorithm. Cached as `manual.pdf`.
The full scanned manual was not read cover to cover.

## 15. Local Defender evidence

[Defender platform notes](../../../defender/docs/platform.md) and
[development log](../../../defender/docs/2026-09-11.md). These record the actual
single-buffer flicker and double-buffer software-sprite experiments, the switch
to bitmap plotting, and accepted gameplay. They support the local rendering
choice, not a universal claim that every firmware's sprite implementation is
identical. No new Rally code was run during this research.

## 16. Search leads that did not establish additional facts

1. General histories and retrospective pages led to the original Namco interview
   but were not used to infer circuitry.
2. Patent searches surfaced later Namco racing patents without a verified link
   to the 1982 road generator; these were excluded.
3. FPGA-board announcements and forum threads did not provide a suitable
   independently inspectable original-game renderer for this report.
4. Chris Kilgour's first-person custom-chip analysis was inspected as a hardware
   lead. It does not establish the road projection/curve algorithm and is not
   needed for the plan: [Namco 07xx](https://www.whiterocker.com/blog/namco-07xx.html).
5. Later Pole Position II upgrade material is not a substitute for the original
   board. The pinned MAME driver covers both; relevant sections were distinguished.

## Reproduction

The manifest records nine downloaded sources and fourteen inspected local source
files. The ignored cache keeps the exact downloaded bytes, including scans;
public-facing notes link to the original publishers or preservation copies.
Hashes detect drift if a mutable article or scan is replaced. Code is pinned to
commits so it can be recovered independently of a moving branch.

Regenerate only the original analytical data and figure with:

```sh
.venv/bin/python docs/research/pole-position/calculations.py
```

The calculations use Python's standard library and do not require the cached
third-party files. There is no game implementation, ROM extraction or emulator
modification in that script.
