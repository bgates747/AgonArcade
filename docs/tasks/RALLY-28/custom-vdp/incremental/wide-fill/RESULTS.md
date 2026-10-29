# Wider road fills: no demonstrated whole-frame gain

Keep the accepted additive sampler's byte-fill renderer. Aligned word stores
produce identical output and improve the separate fill microprobe, but the four
matched completion-fenced game runs do not establish a frame-rate benefit.
All prior dirt and this scope were committed/pushed as `84fa64d` before work.
This experiment and its evidence remain uncommitted for Author review.

## Full completed frames

Fresh Oryx Flexe runs use the accepted deterministic approaching/receding traffic
pattern, 900 completed frames, 3,600 physics ticks and 2,913 retained replies
each. Both versions use the additive actor sampler and split clear. The only
renderer change is the road-span fill primitive. Mode, stock swap/VSync,
post-render checks and final completion fence are unchanged; the foreground is
unpaced, with four physics steps per render. This is not an independent gameplay
scheduler or a 120Hz physics-capacity measurement.

| Run order | Byte fill, nominal MOS FPS | Word fill, nominal MOS FPS | Change |
|---|---:|---:|---:|
| Byte then word | 37.3961 | 35.1105 | -6.11% |
| Word then byte | 36.6102 | 37.6307 | +2.79% |
| Pooled frames / summed elapsed | **36.9990** | **36.3269** | **-1.82%** |

The pooled nominal MOS cost is27.0278→27.5278ms/frame, an increase of0.5000ms.
PRT gives35.7405→35.0788nominal FPS (-1.85%). Opposite-sign pairs and run-to-run
variation prevent a confident claim that the candidate is faster or slower.
Do not compare these absolute rates with another session's35.35FPS as though
that were a controlled gain; the fresh matched byte-fill runs are the controls.

MOS durations use the fixture's nominal120units/s; PRT uses nominal18.432MHz
instruction-clock timing with18,432cycles/IRQ. PRT durations are about3.5–3.6%
longer than MOS here, so retain the separate clock results. Neither is calibrated
hardware timing. Host durations include startup/teardown. The full session used
both SDL dummy drivers, boost0 and the original95°C guard: maximum55°C, clean
exit, no owned emulators left, original boost1 restored.

All four entire347×900byte timed UART streams are identical to the accepted
moving control, SHA256
`370d42da5e5f05c6824e65862e5f1d5cec531e8f473deaa15cbb0014d8a88f45`.
That includes all900 motion packets. Player/traffic final root and all mutable
arrays match the independent reference. Timer restoration, StopRace, UNLOAD,
input/runtime hashes, MOS prompt and zero backend errors pass. Final screenshots
show the MOS prompt; they are not moving-road pixel evidence.

All5,613 raw native replies per run also pass independent request/token/value
checks, including the suppressed ready/generation/post-swap responses. One
single-frame MOS interval is zero (frame258, reverse-order byte control); its
PRT interval advances. Preserve that clock-resolution/jitter observation while
using the full-run endpoints. INFO17 is2260 before either module, then2004 for
byte/1972 for word. Available runtime source identifies this diagnostic as
remaining task-stack high-water bytes, not heap free space; that source is
corroboration rather than a byte-matched firmware-source proof. No stack/leak
conclusion is inferred solely from the32byte difference.

`RESULTS.json`, `FULL-FRAME-AUDIT.json`, both `CAMPAIGN-*.json`,
`SESSION-widesession01.json` and `evidence/` retain raw observations and checks.
`report.py` reconstructs the clock windows and pooled results without rerunning
an emulator. The extra final timestamp is excluded from the900-frame interval.

## Exact implementation and correctness

The control is the accepted additive module
`310779643769adde8413b93ea282115990dfebfe873e3395ac5545ac9d506702`.
The candidate is
`af6e8a137f65d52434649c0886f005274316a8983a126c1711b3fb638b010303`.
Only the original fill body is replaced by `wide_fill.inc`: scalar prefix to
actual address alignment, alias-safe replicated32-bit stores, scalar tail.
Clipping remains at callers, with half-open bounds0..320. The first grass-row
clear and global `memset`/`memcpy` remain unchanged. No new retained memory,
hot-loop upload, buffer lease, geometry, physics, actor, player or wire work.

Actual Xtensa GCC output contains an aligned `s32i.n` loop with byte prefix/tail
stores and no helper call. Text increases72bytes to31,916, resident data stays
1,004, packaged image increases84bytes to34,500. Existing stack frames are
unchanged: preparation672bytes, outlined fill32bytes in place of a32byte
`memset` callee path. Capacity/SDK/runtime limits are unchanged. See
`BUILD.json`, `CODEGEN-REVIEW.json` and `CODEGEN-SNIPPETS.txt`. Authoritative
target objects are in the archive's `target/`, rather than inherited build
artifacts inside the source delivery.

Ordinary and ASan/UBSan unit builds each pass2,720,392 guarded cases across
alignments, endpoints, short/empty spans, colours and canaries. Ordinary and
sanitized actual generated-C replays each pass900frames/3,600ticks per package,
including an independent world model and the exact accepted motion table.
All road pixels, complete command outputs, descriptors, scratch buffers and
final world bytes match;278,575 leases per package balance, peak four. Host
synthetic actor artwork is not a real-artwork display qualification.
`HOST-RESULTS.md` and the raw JSON reports preserve detail. LeakSanitizer's sandbox
failure is retained; qualified runs keep address/undefined checks and explicit
lease/canary checks, with unsupported leak detection disabled.

## Separate fill replay

`phase/` preserves a small separate native module. It replays11,788 actual
clipped fill calls captured from ten accepted-control frames, at four actual
buffer alignments, in both orders, eight repeats per window:80 paired windows,
zero physics ticks and no drawing. It excludes initial grass-row `memset`.
Both paths include the same input decoding, replay loop and indirect dispatch;
leases, reset, full byte comparison, CRC and guard checks are outside timing.

The summed byte/word raw CCOUNT deltas are123,639,649 /58,540,570: **52.65% fewer
raw counter units**, median window reduction52.62%. Empty dispatch contributes
17,829,473 raw units separately and is not subtracted. Every counter interval
is positive and below2^31, with maximum1,559,640. The raw output validates all
alignments/orders, matching host CRCs, zero byte mismatches/guard failures,
unchanged core identity, teardown and timer restoration.

This phase session overlapped two other CPU-heavy jobs on Oryx, confirmed in
`phase/POST-RUN-WORKLOAD.txt`. Its monitored temperature was92–94°C, below the
unchanged95°C abort threshold. Both dummy drivers/boost0 applied; the run
completed, all owned emulators stopped and boost1 was restored. Treat it as
provisional emulated-counter evidence, not a quiet-host benchmark, physical
cycles, milliseconds or a percentage of total frame time. No additional
emulator test was run. The full-frame comparison is a different, earlier55°C
session. See `phase_PROBE.md`, `phase/TARGET-AUDIT.json` and raw phase evidence.

## Disposition

The local fill improvement is real within this probe's emulated-counter scope;
its contribution to completed-frame performance is unresolved. Preserve the
candidate without adopting it. No hardware run, new visual acceptance or later
optimization is inferred. The accepted byte-fill review profile is untouched.
INC-001-04 static drawing/caching and INC-001-02-AFF01 affine investigation
remain separately proposed work.

`PORTABLE.zip` preserves both exact fixtures, authoritative source/target pairs,
the isolated probe, raw returns and unchanged firmware; `PACKAGE.json` hashes
every member. Inherited old compiler artifacts are excluded from source folders.
All archive paths are relative; original reports retain historical provenance.
Reconstruct the summary without running an emulator using the repository's
`.venv/bin/python docs/tasks/RALLY-28/custom-vdp/incremental/wide-fill/report.py`.
The frozen SDK/toolchain and pinned repository runner remain external build/run
dependencies, rather than new firmware or peer-source copies.
