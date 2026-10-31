# Current full-race work and what the saved timers measure

The existing compact control completed **900 frames in 24.8667 nominal MOS
seconds: 36.1930 FPS**. Its separate PRT result is 900/25.743 = **34.9610 FPS**.
There is no new performance run in this audit and no new road/actor/sky timing
breakdown. The source map below explains how to obtain one without mislabeling
the current counters. See [existing records](EXISTING-EVIDENCE.json).

## Inputs and identities

The accepted guest is `685f4b4c…`, the checked additive native image
`479fe1ac…`, and the firmware `8da2ebfd…`. [INPUTS.json](INPUTS.json) pins
163 files, including all 97 frozen control inputs, seven protected
archives/sources, 28 reviewed package members, compiler-emitted dependencies,
the original SDK and six stock graphics inputs. The actual compiled unit is
`round-trips/source/checked.c`. Use `round-trips/target/` disassembly; the older
compiled files carried inside `round-trips/source/` belong to a different image.

Five maintained stock graphics files still match the old manifest. The sixth,
`vdu_buffered.h`, has changed in the shared firmware build tree. Its exact old
bytes were recovered read-only from the local upstream Git object at
`1056ee38…`, verified against the historical hash, and saved in
[stock/](stock/PROVENANCE.json). Do not treat the newer maintained firmware
runtime as the runtime inside the preserved executable. No other project was
changed by this audit.

## Source map

Paths in this table are relative to
`docs/tasks/RALLY-28/custom-vdp/incremental/round-trips/`.

| Work | Source boundary and actual behavior | What remains unmeasured |
| --- | --- | --- |
| eZ80 player/rules/input | `guest/src/main.cpp:140–151`: 16 key-map reads per frame, four `RouteCursor`/position/phase/rules updates and four Tick-wrapper submissions, scripted opponent placement, rank and engine update | Pure player CPU cost, serial-free physics capacity and autonomous cadence |
| VDP simulation | Tick wrapper 13 calls native entry 3; `source/checked.c` runs generated argument/root/range checks and opponent/contact simulation | Simulation arithmetic versus admission/lease overhead |
| Sky calculation and execution | `guest/src/main.cpp:66–72`, `guest/include/presentation-functions.inc:1–19`: track heading, per-page panorama history, scroll/repaint/repair commands **before** native render preparation | eZ80 heading calculation, serial time and VDP scroll/bitmap time separately |
| Native admission and snapshot | `source/checked.c:53–105`, `renderer_hook:23–50`, `helper/rally_render.c:141–165`: generated root/shape checks, array copies, snapshot/state/asset validation and preflight | How much is necessary arithmetic versus repeated admission work |
| Road preparation | `helper/rally_render.c:172–177`, `helper/render_core.inc:145–250`: shared curve polynomial, band boundaries, endpoint/edge setup, road-image byte fills and output commands | Geometry and raster fill are interleaved; no exclusive current totals |
| Traffic/sign preparation | `helper/rally_render.c:179–193`: project/order/build output, release its output lease, **then sample car/sign images** through `sprite_io.inc` | Planning, source/destination leases and pixel sampling separately |
| Fixed player preparation | `helper/rally_render.c:180`, `helper/render_core.inc:372`: choose existing artwork/reflection and construct plotting commands | This is not the traffic scaling workload |
| Publication | `source/publication.inc` and `checked.c` verify completion/output publication before successful RUN reply | Validation cost; no checks may be removed based on this audit |
| Road plotting | `guest/src/main.cpp:76`: execute output 50301 | This output includes the road bitmap **plus footer clear and finish checker**, so its execution time is not road-only |
| Traffic/sign plotting | `guest/src/main.cpp:78`: output 50302 plots prepared images in painter order | Stock bitmap reads/transparency/clipping and command dispatch; traffic/signs are mixed in this stream |
| Player plotting | Same line, output 50303 | Fixed-size bitmap and possible reflection execution |
| HUD/footer | `presentation-functions.inc:20–57`, `rally-game/include/hud.hpp`: format strings, construct image, compare both-page retained cells, emit changed glyph runs; redraw footer | Formatting versus cached-cell comparison versus actual VDP text drawing |
| Presentation completion | `guest/src/main.cpp:83`: stock swap, page-history update, checked Root-generation READ16 | Swap/VSync wait separately from rendering and callback transit |

Four physics steps per rendered frame are a deterministic workload ratio. They
do **not** establish a separately scheduled 120 Hz physics loop. At this control's
nominal MOS throughput the ratio is 144.77 steps/second, but the steps are
clustered around rendering/waits; it is not evidence of real-time 120 Hz headroom.

The saved coverage confirms real scene work: 382 sky scrolls/repaints, 900 sky
repairs, 17,056 HUD bytes, 900 footer calls, 24 engine-frequency changes and 16
finish-visible frames. Keep those tasks in any comparison. Separate explosion,
blink and recovery coverage is excluded from throughput, as in the preserved
control.

## Existing PRT fields overlap

The latest `stages.csv` contains the following **nominal PRT units**, named
`*_ms` by the historical writer. MOS and PRT disagree in the emulator, so these
are not calibrated physical milliseconds.

| Saved field | Aggregate | Mean per frame | Interpretation |
| --- | ---: | ---: | --- |
| Player/rules and Tick submission | 1,874 | 2.0822 | Includes serial submission of four Tick wrappers |
| Presentation CPU estimate | 7,967 | 8.8522 | Paint elapsed minus measured send/wait deltas, clamped by the writer; an estimate, not a CPU profiler |
| Submission | 2,751 | 3.0567 | `mos_puts` elapsed, including sends already counted in player/rules |
| Reply wait | 12,191 | 13.5456 | Transport/backlog/native work/swap/callback delay, not pure VDP raster time |
| Entire loop | 25,743 | 28.6033 | Includes work absent from the above brackets and timer/bookkeeping overhead |

`guest/include/native.hpp:32–46` measures every short send with two PRT reads
and every requested reply with a separate wait bracket. `main.cpp:145–149`
defines the overlapping outer brackets. Do not add these rows into a phase
budget or infer that reply wait is the renderer's share. The broad presentation
estimate does not identify how much belongs to HUD formatting.

## Completion semantics of the preserved graphics path

1. Native RUN15 finishes validation, road-image generation, actor sampling and
   command construction. Its reply precedes the eZ80's later output-buffer calls;
   it cannot measure their bitmap/text execution.
2. The pinned `BitmappedDisplayController::addPrimitive`, line 525, executes
   ordinary primitives inline when double-buffered. Fixed mode 136 therefore
   does not defer every ordinary plot into a background queue.
3. Swap is different: `Canvas::swapBuffers:647` queues its primitive and waits;
   the controller notifies after executing the swap. Stock
   `agon_screen.h:481` explicitly says this waits for VSync. The final checked
   READ16 comes afterward in command order. It fences controller presentation,
   not an entire monitor scanout.
4. Stock `VDU 23,0,&CA` drains drawing through `waitPlotCompletion(false)` and
   `Canvas::waitCompletion(false) → processPrimitives()`. It is available without
   another firmware service. The pinned SDK's ordinary RUN/READ16 handlers do
   not implicitly call that drain. A different single-buffer/background mode
   needs its own declared drain policy.

The current fixture is unpaced by an extra game delay, but its stock swap still
waits for VSync. Keep swap waiting out of the requested hot-loop/drawing metric,
and keep completed-frame FPS inclusive of presentation. The proposed hooks are
in [TIMING-CONTRACT.md](TIMING-CONTRACT.md).
