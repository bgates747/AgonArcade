# Two retained pages: independent history and clipping proof

The accepted generated renderer passes the complete 900-frame moving workload
with the candidate's retained title, sky and lower strip. Across three different
initial dirt patterns, **2,700 presented pages match** the control. After each
page has been used once, **2,697 comparisons of both physical pages match**.
The first use of each page also matches, and the two setup swaps preserve the
original drawing-page parity. [Machine-readable evidence](PAGE-PROOF.json)
records hashes, actual coverage and limits.

1. [page_proof.py](page_proof.py) independently decodes the actual control and
   candidate tapes, including motion opcode 13. It derives expected VDU bytes
   without importing the builder's constants. Every record except the changed
   paint SEND and new setup SEND is byte-identical; every input other than
   script/metadata is identical. The candidate's 184-byte setup precedes the
   existing checked INFO17 reply and initial time mark. Two stock swaps return
   to the original page before timing. Paint falls from 122 to 49 bytes; the
   recurring stream saves 73 bytes/frame. Setup adds 187 tape bytes including
   the SEND header and 184 outbound UART bytes.
2. A private host library compiles the actual accepted additive/byte-fill source
   from the authoritative sampler export, module `31077964…`. It calls the real
   generated Tick120 four times per frame, installs the unchanged motion row and
   lane data, and calls Render30. The proof composes its actual road bitmap,
   sampled actor buffers and road/actor/player output commands. Complete final
   root and mutable arrays match the accepted independent final-world reference;
   leases balance and buffer canaries pass. Earlier independent world/sampler
   qualifications remain separate and are not counted again as new tests here.
3. The compositor keeps two distinct physical page histories for each of three
   arbitrary initial dirt patterns. It executes the real setup, per-frame VDU
   state, viewport changes, PLOT4 activation, filled rectangles, bitmap plots,
   painter order and swaps. Alpha-zero pixels retain the previous page pixel;
   each nonzero RGBA2222 alpha pattern writes its colour, matching the pinned
   stock `genericRawDrawBitmap_RGBA2222` rule. All four alpha values are
   exercised. Pending VDU24 clipping must be activated by PLOT4 before plotting.
4. Every effective native write remains in rows 100–223. The opaque road
   covers rows 104–223 and the retained recurring clear covers rows 100–103.
   Actual actor plot clips are checked independently of the sampler planner.
   The unchanged native lower rectangle at rows 224–239 produces no writes:
   the playfield clip ends at row 223. Thus neither moving actors nor the road,
   player or finish drawing can disturb retained sky rows 24–99, title rows
   0–15 or lower-strip rows 224–239. Untouched rows 16–23 retain the same
   initial contents in both versions.
5. Negative controls demonstrate that these checks reject the relevant defects.
   Two swaps with only one initialized page fail on frame 2. Omitting the
   100–103 clear leaves an old actor pixel through a transparent current pixel.
   Missing PLOT4 activation of a new clip is rejected. These are separate proof
   regressions; they do not alter the qualified candidate fixture.

This is a **retained-region and page-history proof**, not an exact stock-font
or physical VGA emulator. Actor/player source images are synthetic, exercise
every alpha value and feed the actual sampler. Title cells use an arbitrary
stable 8×8 pattern instead of reimplementing the stock font. Because the title
bytes, font state and invariant support are unchanged, the proof does not depend
on a particular glyph raster. Actual artwork/font appearance needs separate
scene captures and the Author's visual review. Shutdown screenshots showing the
MOS prompt do not provide that moving-scene evidence. No emulator timings or
physical performance claims come from this host proof.

Run from the repository root with:

```sh
.venv/bin/python -B docs/tasks/RALLY-28/custom-vdp/incremental/static-drawing/page_proof.py
```

The private workspace preserves two preliminary attempts: an interrupted slow
per-pixel implementation and a completed replay stopped by an overly strict
coverage assertion that incorrectly required every actor scratch slot to be
visible. The final report records the slots actually exercised; no fixture or
geometry changes were made to obtain a pass. The qualified compositor uses
equivalent row operations to avoid millions of unnecessary Python point calls.
