# RALLY-11: retained scenery scrolling — frozen implementation contract

Scope: remediation attempt 2, following narrow shoulder strips. Shipping uses
stock VDP only. Preserve current resolution, scenery pixels, absolute heading,
road/traffic rendering, physics, steering and tuning. No firmware changes.

1. Retain independent valid flags and panorama offsets for the two alternating
   draw buffers. Initially both invalid. First use draws the full sky region.
   Advance the software buffer slot only when submitting the existing swap.
   Ordered VDU processing preserves correspondence; this is not a completion
   acknowledgement and makes no frame-pacing fix by itself.
2. Restrict scrolling to graphics viewport x=0..319, y=0..102. Its origin and
   width satisfy the stock 64-colour fast-path four-pixel alignment. Restore the
   full-screen graphics viewport before any road, traffic, player or HUD work.
3. Compute shortest signed panorama displacement modulo 1024 from the current
   draw buffer's own retained offset. Positive heading delta means pixels move
   left. Negative delta means pixels move right. Never scroll by zero: stock
   movement=0 means one character, not no movement.
4. For nonzero displacement of magnitude at most 255 pixels, scroll once using
   stock VDU 23,7, graphics-viewport extent 2. Repaint only the exposed strip by
   clipping ordinary panorama bitmap draws to it. Account for panorama wrap.
   For invalid buffers or larger deltas, redraw the whole sky without scrolling.
5. A zero displacement on a valid buffer performs no scenery draw or scroll.
   Clouds, peak and hills remain one layer at infinity, with no lateral parallax.
6. Tests cover independent buffer history, zero motion, both scroll directions,
   wrap, first use, large-jump fallback and viewport/strip geometry. Native
   emulator inspection must cover turns and both alternating buffers without
   stale bands or corruption of road/HUD. Performance gains require hardware
   comparison; no inferred FPS claims from host tests or SDL frame counts.
7. Record implementation and validation in the research document and dated log.
   Launch the canonical Rally emulator for human review. Do not deploy to the
   SD card or commit the implementation until separately requested/approved.

Root TODO.md is the authoritative task register. This document freezes behaviour
and acceptance criteria, not a second task queue.

Implementation qualification amendment: native captures exposed road raster
coverage on sky row 102, and distant traffic can extend above the horizon.
Retained pixels must not preserve foreground debris. After scrolling, refresh
the bottom sixteen sky rows (87..102), including zero-heading frames; the
upper 87 rows still need no work when unchanged. A full redraw already covers
this band. This supersedes the zero-work clause only for the overlap band and
preserves existing foreground appearance rather than clipping cars differently.
