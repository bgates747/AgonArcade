# Retaining static drawing improves completed-frame throughput

The candidate delivers **42.77 versus35.95 nominal MOS FPS**, a pooled18.97%
improvement in fresh matched Oryx Flexe runs. Both orders improve by about19%.
Actual scene snapshots match exactly on both page parities, and all completed-
frame state/transport/cleanup checks pass. The candidate is ready for the
Author's moving visual review; physical performance remains untested.

All prior wider-fill work, its rejection and this scope were committed/pushed
as `aab566d` before implementation. The accepted additive sampler with byte
road fills is unchanged. This tranche changes only drawing commands in the
fixture tape; there is no native rebuild, scaled-image cache or firmware change.
New work remains uncommitted for Author review/publication.

## What changed

1. Initialize the existing two-line title, sky and lower strip on both physical
   display pages before timing. Two stock swaps restore the original page phase;
   the unchanged checked INFO17 query follows them before the initial timer
   mark. Setup adds184 outbound UART bytes and187 tape bytes, including its
   record header. It clears61,440 pixels once. Startup wall time is not isolated.
2. Preserve invariant sky rows24–99 and lower rows224–239 on each page. Restore
   sky rows100–103 every frame: admitted opponent images can reach row100.
   Road pixels replace104–223, and other native drawing stays within100–223.
   This saves29,440 logical clear pixel writes/frame; it is not a measured count
   of physical memory transactions. See [bounds](SKY-BOUNDS.md).
3. Remove per-frame title printing and the lower-strip clear. The paint SEND
   shrinks122→49bytes; complete frame UART falls347→274bytes, saving73/frame
   and65,700 over900 frames. Native output buffers, including their existing
   clipped lower rectangle, remain exact. UART/dispatch savings are included in
   measured frame time. Two-page initialization is outside that timing interval.
4. Retain VDU26, GCOL16, the playfield viewport and PLOT4 activation on every
   frame. Text cursor ends at row0 instead of row2; no loop text uses that state
   before the unchanged MOS cleanup. The claim is equal displayed pixels and
   relevant graphics state, not identical internal text-context fields.

## Completion-fenced comparison

All four runs use900 renders/3,600 authoritative physics ticks/2,913 retained
replies, identical original artwork, motion, driver, module, runtime, checks,
stock swap/VSync and post-swap fence. Foreground pacing remains absent. Four
physics steps per render describe this fixture, not an autonomous120Hz scheduler
or a new player-physics headroom result. No waits or diagnostic checks were
removed to obtain the gain.

| Run order | Control MOS FPS | Static candidate MOS FPS | Change |
|---|---:|---:|---:|
| Control then candidate | 35.4098 | 42.1546 | +19.05% |
| Candidate then control | 36.5112 | 43.4084 | +18.89% |
| Pooled frames / summed elapsed | **35.9521** | **42.7723** | **+18.97%** |

Nominal MOS time falls27.8148→23.3796ms/frame, saving4.4352ms. PRT independently
gives34.7350→41.3242nominal FPS, also+18.97%. Use fresh matched controls rather
than pooling previous sessions or this fixture's older constant-gap results.

MOS assumes nominal120units/s; PRT uses the emulated18.432MHz instruction clock
and18,432cycles/IRQ. PRT durations are about3.5% longer than MOS, so clocks remain
separate. This is completed drawing/controller-swap pipeline timing including
physics, commands, wire/check overhead and fences. It does not isolate VDP CPU
time, physical scanout or calibrated hardware frame rate. Host elapsed times
include startup/teardown:35.328/31.108/30.511/34.518seconds in run order.

One reverse-order control frame has a zero MOS interval (frame47); its PRT
counter advances. Full-run endpoints are positive. INFO17 before is2260 on all
runs; after values are1972 on the first three and2004 on the last control.
Available runtime source identifies this as remaining stack high-water bytes;
do not interpret it as heap free space or infer a leak from the32byte variation.
The source corroboration is distinct from byte-matched firmware provenance.

The full session ran131.909host seconds, maximum56°C. Both SDL drivers were
dummy, boost0 throughout, original95°C guard unchanged. Boost1 was restored
after all owned emulators stopped. Preflight found no competing heavy jobs.

## Correctness and actual scene evidence

1. The independent tape review reconstructs the entire accepted control by
   removing the one setup SEND and replacing the changed paint SEND. Only
   `script.bin` and explanatory metadata differ. Accepted native module SHA256
   is `310779643769adde8413b93ea282115990dfebfe873e3395ac5545ac9d506702`
   on both sides. No resources, allocations, SDK or geometry changed.
2. The actual generated-C900-frame/3,600-tick page-history proof passes2,700
   presented-page comparisons across three dirty-page scenarios, plus2,697
   comparisons of both retained pages after their first use. All root/arrays
   match the independent final-world reference;278,575 leases balance, peak
   four. Negative controls catch one-page setup, missing100–103 restoration and
   missing PLOT4 clipping activation. Synthetic alpha-bearing actor/player
   images and surrogate title glyphs make this a region/history proof, not an
   exact stock-font emulator. [Method and limits](PAGE-PROOF.md).
3. Four separate silent30/31-frame scene-hold diagnostics use the actual artwork
   and pinned renderer/runtime. Both control/candidate scene pairs are pixel-
   identical across all76,800 RGB pixels. They capture the scene before MOS
   clears it, on consecutive physical-page parities. Holds and deliberate
   interruption are excluded from performance and cleanup qualification.
   [Actual snapshots and hashes](CAPTURE-RESULTS.json),
   [frame30](captures/scene-f030.png), [frame31](captures/scene-f031.png).
4. All four full benchmark runs pass exact final root/five mutable arrays,
   scripted positions/lanes/player, all raw native replies including suppressed
   completions, timer restoration, StopRace, UNLOAD, mode8/full-text cleanup,
   MOS prompt and zero backend errors. Full control timed UART retains its prior
   SHA256; both candidate streams are identical after precisely the authorized
   paint change. [Raw audit](RAW-AUDIT.json), [timing report](RESULTS.json).

The two preliminary host-proof attempts are preserved: one interrupted slow
Python compositor and one completed replay stopped by an overly strict coverage
assertion. The qualified proof records actual participating slots rather than
requiring all scratch slots to be visible. No fixture change was used to pass.
No emulator attempt failed in this tranche.

## Disposition and review

Retain this as a promising isolated candidate, pending the Author's visual gate.
The accepted review profile and byte-fill module remain untouched. A fresh
stopped Oryx instance contains the exact tested candidate; see
[HUMAN-REVIEW.md](HUMAN-REVIEW.md). Review title stability on both pages, horizon
trails, approaching/receding cars and clean return to MOS. No hardware timing,
full-game integration, bitmap caching, affine investigation or next optimization
is released by these measurements.

`PORTABLE.zip`/`PACKAGE.json` preserve exact fixtures, actual scene/benchmark raw
returns, proof/review tools, authoritative unchanged module/source/target and
firmware with member hashes and CRC/readback checks. The pinned SDK/toolchain
and emulator environment remain external dependencies. Recompute results without
launching anything using the repository's `.venv/bin/python` with `report.py`,
`capture_report.py` or `raw_audit.py` in this directory.
