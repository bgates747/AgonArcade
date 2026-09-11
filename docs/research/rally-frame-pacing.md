# Rally frame pacing investigation — 2026-09-11

## Result and limits

Progress checkpoint: `791da51`, following traffic milestone `0e5986b`.
The deployed 96,333-byte scenery/surface build is **not performance accepted**.
User reports lag and backwards-motion strobing at speed 224 on hardware, with
less severe deterioration in the emulator. These symptoms establish a regression;
they do not by themselves distinguish dropped presentations, long frame intervals,
queue latency, or temporal aliasing. No measured hardware FPS is claimed here.

Research conclusion: begin with clock calibration, completion instrumentation and
avoidable raster work. Pingo's callback design is a useful donor, but its existing
notification is not a generic completion event for Rally's 2D drawing. A stock
post-swap echo fence is a promising smaller experiment before custom firmware or
a fully asynchronous simulation loop. The initial research made no timing/render changes; the subsequent first
remediation attempt is recorded below.

## Evidence: Rally timing and work

1. `rally/src/main.cpp` samples `clock()`, sets `next=now+4`, snapshots held keys,
   executes one steering update, runs `elapsed` physics iterations, draws the
   scene, and sends `vdp_swap()`. There is no returned completion wait and no
   bound on physics catch-up. Its four-clock-unit interval regulates submission
   attempts, not completed frames. Backpressure may block transmission, but is
   not an explicit presentation fence. Inputs sampled before a long submission
   can become stale; multiple queued frames can increase latency.
2. agondev `src/lib/libc/clock.src` jumps directly to `_getsysvar_time`.
   `src/lib/libmos/mos_getsysvar_time.src` reads MOS's raw four-byte counter.
   Despite `release/include/time.h` declaring `CLOCKS_PER_SEC=100`, official MOS
   **v3.0.2** `src/interrupts.asm:42` increments `_clock` by **two per VBlank**.
   Rally mode 136 is 60 Hz: expect **120 counter units/second**, not 100.
   Thus four raw units nominally mean 30 Hz, not the previously documented 25.
   Physics advances 120 nominal hundredth-second iterations per real second if
   all elapsed ticks are serviced; nominal world speed is then 1.2× wall-time
   speed. This predates the latest regression and cannot alone explain it.
   Confirm the physical MOS/VDP mode identity and actual counter rate before
   changing tuning. Correcting time units will alter the currently tuned feel.
3. The clock is VBlank-derived, not a fine wall clock: counter changes occur in
   twos in this mode. The SDK reads 24 low bits then the high byte without an
   atomic snapshot. A rollover between those reads is an additional rare audit
   item. Use wrap-safe subtraction and a qualified clock snapshot; do not simply
   rename its ticks to milliseconds.
4. Shoulder lines increased the sampled road stream from 1,125 to 2,043 bytes
   at 17 bands. The implementation draws kerb area ±106, asphalt ±90, shoulder
   colour ±86, then asphalt ±84, effectively repainting most asphalt four times
   including the initial kerb fill. **Two narrow shoulder quads** can replace
   the two broad overdraw quads at the same command count, avoiding most of that
   extra fill. The grass rectangle also covers the whole road before road paint.
5. The panorama replaces a cheap solid rectangle with up to 320×103 visible
   bitmap pixels (32,960) each frame. It is already resident; its 52,736-byte
   startup upload is not recurring frame traffic. The 1024-wide image is clipped,
   so do not assume every draw paints all 105,472 source pixels. The solid sky
   allows a future rectangle plus compact cloud/mountain/foothill assets, but
   benchmark that trade before adding draw calls.
6. Up to six opponents receive freshly reset/rebuilt Q8 affine matrices every
   frame, followed by transformed draws. In the vendored FabGL implementation,
   `genericRawDrawTransformedBitmap_RGBA2222` performs a floating-point 3×3
   inverse-matrix multiply for each destination pixel, then samples source alpha.
   A small UART command does not make this cheap on ESP32. Player right-facing
   mirroring also takes this path over a near-car-size rectangle; left-facing
   ordinary bitmap drawing does not. Test left/right timing independently.
   Cache quantized scale matrices; consider VDP-generated mirrored player views
   or bounded pre-scaled traffic caches if profiling justifies the RAM cost.
7. UART_BR is 1,152,000 in the pinned VDP. At nominal 8N1, 2,043 bytes alone
   require about 17.7 ms on the wire, excluding HUD, bitmaps/matrices, flow-control
   stalls and processing. At 30 attempts/sec that road sample alone is roughly
   53% of theoretical payload capacity. It is a sampled workload, not an
   exhaustive maximum or an end-to-end duration measurement.
8. Steering/grip adjustments are explicitly once per submitted rendered-frame
   iteration, as requested by the user. Lower frame rate slows their real-time
   response. Do not silently move steering into every physics tick. Any later
   conversion to time-based steering needs deliberate agreement about preserving
   the accepted three-tick-per-frame response.

## Stock completion route: smaller candidate

The agondev `vdp_swap.c` sends only `23,0,0xC3`; it does not wait for MOS to hear
anything back. On the VDP, `vdu_sys.h` calls `switchBuffer()`; `agon_screen.h`
then calls `canvas->swapBuffers()`. The pinned FabGL `canvas.cpp:647` queues a
SwapBuffers primitive and calls `primitivesExecutionWait()`. This is a VDP-side
wait, not an eZ80-side acknowledgement.

A following `23,0,0x80,token` general poll is handled by `sendGeneralPoll()` and
returns that token through the stock general-poll system variable. In this
serialized implementation, putting the echo **after swap** should acknowledge
that preceding drawing/swap has completed. An echo after arbitrary drawing alone
may merely acknowledge command processing while primitives remain queued.

Qualification needed: establish this ordering on the actual stock hardware
firmware and native emulator, alternate tokens so stale values cannot satisfy a
wait, fence startup uploads before starting timings, and distinguish submitted,
swapped, acknowledged and physically displayed events. General poll is a
system synchronization mechanism rather than a dedicated app frame API; isolate
it behind a backend helper. Source reasoning is not a hardware proof.

A synchronous one-frame-at-a-time loop with this fence is the first candidate.
It removes unbounded presentation queuing, but cannot manufacture rendering
throughput and may reduce CPU/VDP overlap. Measure it. A nonblocking poll mailbox
can later permit bounded simulation while the previous frame is outstanding,
without introducing the Pingo keyboard callback or custom firmware.

## Pingo donor: verified completion versus presentation

The local `agon-vdp` working tree is currently on `audio_fix`, so Pingo source
was inspected read-only with `git show pingowolf:...`, not by switching branches.
Reference revision: `1a78d9886005b7bdc5eee759d24150a16a22a321`.

- `docs/pingo-render-completion.md` defines opt-in command
  `23,0,0xA0,sid;0x49,41,mode,token;` (mode 1 enables).
- `video/pingo_3d.h` emits `81 0A 50 33 44 52 01 01 tt tt ss ss` after successful
  render-to-bitmap subcommand 38: ten-byte P3DR payload, twelve-byte wire packet.
  Fields are magic, version, event, 16-bit caller token and 16-bit sequence.
- Completion follows renderer work/output conversion and private-pointer
  restoration. **It says the target bitmap is ready, not that a screen swap
  or monitor presentation has occurred.** Rally does not invoke this renderer;
  enabling its notification would not acknowledge Rally's ordinary 2D frame.
- Transport is `PACKET_KEYCODE`, intercepted with MOS `mos_setkbvector` (0x1D),
  not a spare bit in the held-key map. MOS supplies DEU pointing at its packet
  buffer. Callback copies data to a mailbox, preserves registers, sets a ready
  flag after copying, and clears the first four source bytes so MOS does not
  treat P3DR as phantom keys. No MOS/VDU/file operations in the interrupt handler.
- There is one global user keyboard-vector slot. Foreground code atomically
  snapshots the mailbox, validates token/version/event/sequence, accepts the
  first sequence as-is, and uses modulo-65536 succession. One render in flight.
- On shutdown, drain outstanding completion before disabling notification and
  removing the callback. Do not return to MOS with a possible callback targeting
  freed application code. Oversized packet handling and vector ownership matter.

`pingoasm/benchmarks/render-async/README.md` documents a hardware-qualified run:
36 fixed simulation steps yielded 17 submitted renders by coalescing poses.
Its 192.849–214.143 ms renderer timings describe that cube fixture, **not Rally**,
and exclude full presentation latency. An initially false timeout was caused
by startup command backlog; a general-poll setup barrier resolved it.

The existing `pingoasm/emulator` launcher is an old direct symlink in this
checkout, so it was not launched or repaired. Research notification uses Rally's
existing canonical generated wrapper instead.

## Fsim donor: bounded fixed-step work, opportunistic rendering

Relevant implementation is retained under:
`pingoasm/apps/fsim/application/fixtures/terrain-manager-survey/src/terrain-manager-regular-lod-survey.asm`
and `../berkeley-flight-fdm/src/render-async.inc`.

The foreground loop samples inputs, accumulates elapsed clock units, runs a
bounded simulation batch even when rendering is outstanding, consumes completion,
and only submits new render/idle-only work when `render_in_flight` is clear.
The mailbox consumption draws the completed bitmap and flips separately.

Scheduler constants are four MOS units per physics step, four steps maximum per
pass, and 32 units maximum backlog (eight steps). At a qualified 60 Hz mode this
means 30 Hz simulation and ~267 ms backlog. Excess elapsed time is deliberately
discarded rather than taking a giant integration step; it causes simulation
slowdown under sustained overload. Input is refreshed between steps. Newest
absolute poses replace intermediate unrendered poses; physics steps are not
conflated with render requests.

The modern `agon-fsim/agon/02-design-discussion.md` Q07 retains this policy.
Its newer `agon/03-legacy-donor-audit.md:160` corrects the earlier unconditional
“120 Hz” wording: mode refresh controls MOS counter rate. Modern tasks
FLIGHT-006, AGON-005 and PERF-001 are **Not started** in this checkout. They are
plans for shared C++ scheduling/target binding/profiling, not implementations or
new hardware qualifications. Do not cite them as completed features.

## Recommended next experiment (implementation not yet performed)

1. Add compact buffered timing diagnostics: physics/projection time, UART submit
   time, swap-fence round trip, completed frames, interval histogram/max gap,
   bytes, bands, visible cars, catch-up steps and discarded-time counts. Dump
   after the run; avoid per-frame console/SD logging. Fence initialization.
2. Qualify the raw clock and stock post-swap fence on emulator then hardware.
   Run fixed route/input workloads with no traffic, six traffic cars, scenery
   off/on, and player left/right. Emulator SDL presentations are not necessarily
   unique game frames and cannot be counted blindly as Rally FPS.
3. Remove broad shoulder overdraw and remeasure. Next compare cached mirrors/
   traffic scale bins and a cheaper solid-sky draw. Preserve the visual result.
4. Keep one frame outstanding. If synchronous pacing plus the reduced work meets
   responsiveness needs, stop there. Only add bounded physics/render overlap if
   measurements demonstrate a benefit, adapting fsim's invariants rather than
   copying its 30 Hz coefficients into Rally's existing nominal 100 Hz model.
5. Requalify steering feel and temporal aliasing on hardware. A lower speed cap
   can hide aliasing at one frame rate; it is not a frame-pacing fix. Do not claim
   the existing backwards-motion symptom is solved without a hardware retest.

Authoritative work remains RALLY-10 in root TODO.md. Resolution experiment stays
deferred. Signage and explosions are not implemented as part of this research.

## Local source identities

- Rally progress: `791da51` (current deployed binary unchanged by research).
- Pingo branch: `agon-vdp` pingowolf `1a78d9886005b7bdc5eee759d24150a16a22a321`.
- PingoASM: `a6e3ec95ff18e6878d7549cf11b1a8d3450ab02b` (working-tree donor files read).
- agon-fsim: `dc9552d31f57f8926c4f8b0bd3f4ff165fd7f4c5`.
- Official MOS reference: `/home/smith/Agon/agon-mos`, tag v3.0.2.
- Stock runtime source: `/home/smith/Agon/mystuff/AgonJukebox/.emulator/runtime/fab-1.2.4/src/vdp/`.
- SDK reference: `/home/smith/Agon/agondev/src/lib/` and `release/include/time.h`.

## Remediation attempt 1 — narrow shoulder strips

User authorized September 11, 2026, after reviewing the overdraw explanation.
Changed `rally/include/road.hpp`, `Road::render`, from wide shoulder-colour fill
[-86,+86] followed by asphalt fill [-84,+84], to two shoulder-colour strips
[-86,-84] and [+84,+86]. The initial asphalt fill remains. Stripe position,
width, phase and colours retain their intended geometry; native edge rounding
may differ by a boundary pixel from the former overpaint method.

The two shoulder passes now span four rather than 340 world-width units in
aggregate before clipping (about 98.8% less geometric area for these two passes,
not a measured reduction in whole-frame cost). Still two quads/54 bytes per
band: this targets VDP pixel work, not UART traffic. No clock, physics, input,
frame-pacing, firmware, artwork or surface-contact changes are included.

Native build and ASan/UBSan tests pass. Sampled command budgets are unchanged:
2,043 bytes for the Fuji sweep and 1,908 for tri-oval/offsets. Native capture
is used for visual shoulder verification, not FPS measurement. Hardware
performance improvement is **unmeasured and pending retest**.
User subsequently authorized hardware deployment: the 96,344-byte build was
written to AGON:/mystuff/arcade/rally/rally.bin and flushed; autoexec.txt untouched.

Shipping constraint clarified by user: **stock VDP is mandatory**. Custom Pingo
completion callbacks may be used for diagnostics only, not as a shipped game
dependency. Any proposed shipping completion mechanism must use stock features
and be qualified independently.

## Follow-up: stock viewport scrolling (research only)

VDU 23,7,extent,direction,movement supports graphics viewport extent 2, with
0=right and 1=left. Movement zero means one character width, not no movement;
skip the command for zero delta. Set the graphics viewport to x=0..319,
y=0..102 to isolate the panorama, then restore it before road rendering.
The stock Context::scrollRegion uses the text background brush to fill newly
exposed pixels; it does not wrap panorama pixels. Repaint only exposed strips
with clipped panorama draws.

Pinned VGA64Controller::HScroll has a fast path when X origin and width are
multiples of four pixels: Rally's x=0,width=320 qualifies. It moves framebuffer
words, not merely a display-origin register. Large or non-four-multiple shifts
can require additional passes, so benchmark against ordinary bitmap plotting.

Double buffering requires two retained panorama offsets/valid flags, one per
physical buffer. Scroll the current back buffer from its own last offset,
which usually belongs to two presentations ago, to the new heading. Initialise
both, track flips, redraw on invalidation or a shift too large for the viewport.
Never apply the previous displayed frame's delta blindly to the other buffer.
At zero delta leave that buffer's sky untouched. This is a candidate for stock
VDP only, not implemented or performance-qualified.

Sources: agon-docs/docs/vdp/VDU-Commands.md section vdu-23-7; pinned VDP
context/graphics.h:396, context.h:45; pinned FabGL
dispdrivers/vga64controller.cpp:361.
