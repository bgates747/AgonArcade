# 2026-10-29 — Isolated stock affine checks

The Author requests offline timing of affine transforms on Rally's actual
bitmaps, then restricts preparation and testing to Pi5 while Oryx is shut down.
Host checks and a stock-VDP standalone fixture are delivered. All 124 longer
emulator batches pass functional checks, but MOS/PRT disagreement prevents a
calibrated VDP-millisecond claim. The accepted game and all prior benchmark
inputs remain unchanged; there is no new optimization adoption or publication.

1. **AFF01-01 completed:** the exact source audit identifies matrix replacement,
   lazy inverse caching, direct transformed rasterization, format/alpha/clipping
   and transform-to-bitmap allocation. A changed live header was detected and
   replaced by the frozen committed source for extraction. Host diagonal inverse
   setup is explicitly a model rather than the old firmware's inverse library.
   [Source routes](tasks/RALLY-28/custom-vdp/affine-offline/SOURCE-ROUTES.md).
2. **AFF01-02 completed:** all 43 original bitmaps are extracted and hash-checked.
   Actual generated-C/helper replay reproduces the two warm renders, 900 measured
   frames and 3,600 physics calls with an independently exact final state. It
   captures 5,767 measured draws and separates observed from synthetic cases.
   [Workload](tasks/RALLY-28/custom-vdp/affine-offline/WORKLOAD.md).
3. **AFF01-03 completed:** 640 ordinary host timing samples, five trials for each
   of 16 cases/eight methods, pass source/binary/arithmetic audit and separate
   ASan/UBSan checks. A private unmodified ARM64 Flexe export is built and passes
   the existing 52-completion control, then the corrected standalone smoke and
   all 124 full batches. Timed UART is one six-byte CALL per resident batch;
   actual stock graphics flush/callback and later marker checks establish
   completion. All processes are stopped and both SDL drivers were dummy.
4. **AFF01-04 completed:** [results](tasks/RALLY-28/custom-vdp/affine-offline/RESULTS.md)
   retain raw clocks, exact commands/replies, checksums, source pins and exclusions.
   Native host times are Pi CPU costs. The full target's 72,880 PRT counts and
   1,944 MOS units disagree by 4.4988× under nominal conversions, with method
   dependent ratios and 13 zero-MOS rows. The source audit proves separately
   paced eZ80 PRT/native-raster MOS paths; it does not quantify their individual
   contributions or establish a hidden-page defect. Future target timing
   calibration/physical checks remain open under root TODO's AFF01 item.

For an observed near traffic car, host medians are 62.258 microseconds for cached
direct affine, 90.256 for generating a transformed bitmap and plotting it, and
10.838 for plotting an already prepared bitmap. The last figure excludes its
one-time generation; no pre-scaled files are loaded. Natural stock output edges
and clipping differ slightly from the direct path and remain reported, without
pixel-perfect repair work. These timings do not establish ESP32 milliseconds.

The old affine helper needlessly rebuilds unchanged coefficients in 3,129 of
4,867 measured actor draws: 64.29% overall, 72.51% of traffic and 16.08% of signs.
Matrix writes invalidate the cached inverse, so avoiding those writes is a
concrete baseline/standard-path candidate. Cars still need drawing when their
position or artwork changes. This is not a new gain for the accepted native
additive actor renderer, which already avoids those affine calls; no FPS gain
or eZ80-UART saving is claimed.

The first target harness omitted the affine-enable flag. Its inputs are archived
and its completion-only result is excluded from transform timing. The corrected
guest is frozen at c85b0fad6c24862b42daece1dc695f4eea38b2935cd8b5316482f8e4ff8a50ba.
Two identical startup attempts stalled before timing; the third passed unchanged.
Original failures and the successful raw returns remain preserved. No firmware,
buffer-size, clock or transfer-pacing workaround was introduced.

Observed Pi5 durations: private runtime build 94.74 host seconds after the
preserved warning-only build failure, completion control 22.44 seconds, host
compile/sanitizer/timing tranche 58.37 seconds, successful smoke 7.12 seconds and
full standalone suite 83.09 seconds. Each failed startup took about 126 seconds
under the 120-second no-UART-progress guard. Setup/replay/reporting are separate;
allow about two minutes for a comparable full run once staged, plus startup
retry time. Successful runs stayed below 60°C; original 95°C abort retained.

No Oryx access, graphical/audible launch, physical card, firmware flash, game
source change, commit or push occurred. The separate full-race moving visual
acceptance remains recorded; all new diagnostic work stays uncommitted.

## Oryx continuation released

The Author subsequently says “ok you can do the same tests on oryx now.” This
supersedes the Pi-only/shutdown restriction for the same isolated checks. The
Pi results and exact five-file guest fixtures are frozen. The continuation uses
an x86 build of the same frontend/core commits, official stock VDP and MOS,
separate host CPU and emulated timer records, both SDL dummy drivers, fresh
profiles and the original95°C guard with temporary boost disable/restoration.
There is no game/firmware change, physical operation or commit/push release.

The first read-only SSH availability check was rejected by automatic review
because it applied the preceding Pi-only restriction. After recording the new
explicit Author authorization, the same check was approved. Oryx was available,
no emulator was running, original boost was1 and CPU temperature was60°C.
All81 transferred frozen inputs/Pi evidence files and official stock firmware
were hash-verified before execution.


## Oryx continuation returned

The same124-batch stock suite passes on Oryx with497required ordered replies,
124zero-key completion callbacks, clean MOS return and exact timer/callback
restoration. Original guest c85b0fad… and official VDP b807beef… stay unchanged.
All source/artwork/config/MOS pins match Pi; native runtimes use the exact same
a35b17d…frontend/fbda8e90…core source with architecture-specific builds. Both
complete UART directions are byte-identical across hosts, including startup and
cleanup; the application slice is110240bytes. Independent cross-host audit
also passes all128host case/method groups,640trial checksums and16geometry cases.
[Results](tasks/RALLY-28/custom-vdp/affine-offline/ORYX-RESULTS.md).

Oryx near-traffic host medians are38.522µs cached affine,63.386µs generate+plot,
8.663µs prepared ordinary plot(excluding generation). Source/assembly/raw audits
pass; actual calls remain within timed loop backedges. Empty controls cap at
8.37–9.09ms instead of40ms; no baseline subtraction occurs. Nonempty batch times
span37.319–83.900ms. Native host CPUs/compilers differ and do not model physical
ESP32 timing. Source host inverse setup remains an explicit analytic model.

Target PRT total39309versus MOS1958 gives nominal disagreement2.4091×; Pi was
72880/1944and4.4988×. Oryx reduces PRT46.06% while MOS changes+0.72%; ten rows
have zero MOS delta. Per-method ratios also differ. This confirms that faster
host execution does not supply a fixed correction or calibrated VDP milliseconds.
The new investigation establishes relative mechanism costs; physical timing
remains open. The original Pi report/audits have not been rewritten.

Durations: private runtime build56.51host seconds(all four test executables
pass), host compile/sanitizer/timing55.00s, smoke7.12s and full49.17s. Both emulator
attempts pass first try. All four original95°C guarded sessions keep boost0,
reach62°C maximum and restore original1. Every owned emulator is stopped; final
read-only process check finds none. All81frozen inputs/Pi evidence files are
unchanged on both machines. Oryx is free. Source/build/controller/verifier and
independent audit receipts remain separate from qualified game fixtures.

The first archive transfer needed a missing private parent directory; rsync
created only that parent on retry. No build/test or input change resulted.
No game/firmware change, physical operation, graphical/audio launch, commit or
push occurred. AFF01 implementation/test scope is complete; review and unresolved
physical timing remain tracked in root TODO. No next optimization is released.


## 2026-10-30 — Framerate reporting correction

The Author points out that the latest report again omitted FPS, their primary
performance metric. Corrected ORYX-RESULTS and its generator now lead with the
missing result: this probe draws isolated objects, not complete race frames, so
bitmap-cache versus cached-affine game FPS is unmeasured. The4.4× host draw ratio
cannot be called a game-framerate improvement. Prior full-race reference FPS
(14.45baseline/25.73native spans/31.76accepted additive, nominal MOS; PRT separate)
is included explicitly as historical context, with frames and calculation.
Future performance comparisons must lead with completed frames, elapsed time,
FPS and FPS change versus control. An actual matched full-race cache comparison
is the missing experiment, including generation/misses/memory and final fence.
This correction makes no new implementation, emulator or publication release.
No timings, raw receipts or frozen Pi evidence are changed.
