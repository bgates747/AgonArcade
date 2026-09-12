# RALLY-19 delivery: stock-VDP computation works; hardware rendering is too slow

The existing C++ Golem compiler now builds the complete Rally scene as resident
stock-VDP programs fed by compact game state. The physical startup crash is
corrected. The Author confirmed the corrected oval/demo continues running after
the board reset button on restored official VDP2.16.0, but it remains visibly
slow. **This implementation is not a practical hardware accelerator.** The
native-emulator acceptance criteria and physical usefulness are separate results.

The original frozen scope and numeric thresholds remain in CONTRACT.md. Root
TODO.md owns completion state. REVIEW.md indexes final correctness/stability;
PERFORMANCE.md and its final-asset qualification retain raw timing and limits.
HARDWARE-DEBUG.md records the physical diagnosis, flash verification and exact
Author response. This delivery does not authorize new optimization, change the
accepted earlier game, or publish either branch.

Linked checkpoints: Golem implementation `f9e7d8d`, Golem delivery
`3ac500cfb1733e53d475443bfcb8217817b03603`; Rally physical startup `10b7ecb`,
review preparation `eb24628`, final correctness/stability/timing `6d574f1`.
The R19-12 commit containing this document is the Rally delivery checkpoint.
`evidence/final/delivery.json` records artifact hashes and the pre-delivery refs.

## Code, protocol and ownership

The separate compiler worktree is
`/home/smith/Agon/mystuff/golem-rally19`, branch `rally19-vdp`. Its host C++ compiler
is `src/golemc.cpp` with hosted lowering in `src/hosted.hpp`. Opt-in hosted mode
retains the legacy print/integer/loop frontend. Extensions provide typed
float/matrix arithmetic, affine reciprocal/rotation, checked signed output,
resident imports and indexing, guarded state admission, finite control flow,
bitmap/viewport/scroll operations and selective immutable-call inlining. See
Golem's `docs/design/rally19-hosted-v1.md`, `rally19-resident-v1.md`, tests and
`examples/native_*`. Python helpers generate Golem source/data; they are not a
replacement compiler.

Rally work is in `/home/smith/Agon/mystuff/AgonArcade-rally19`, branch
`rally19-golem`, under this task directory. Root `rally/` is the earlier game;
`make -C rally` does not build this candidate. `build_scenery_draw.py` composes
the resident road/vehicle/scenery program from its subordinate generators and
`admission.golem`. The resulting full source is at
`.work/frontend/hardware-inline/kernels/oval/oval-scenery-draw.golem` and its
Fuji counterpart. Edit generators, not their disposable generated files.

The eZ80 retains keyboard snapshots, input handling,120Hz physics, game rules,
traffic state and HUD. It sends80 explicitly encoded bytes of track-relative
state inside a97-byte ordered update/call packet. An additional3-byte swap makes
100 scene bytes/frame; the diagnostic fixture's17-byte HUD makes117 total.
Interactive HUD traffic is separate. Static art and track/projection coefficients
upload once. Resident VDP programs evaluate road projection, vehicle depth/order,
pose/scale/placement and retained scenery from the state; projected coordinates
are not smuggled into that packet. The independent stripe phase survives lap wrap.
ABI.md, FRONTEND.md and SCENERY.md define the details and ownership.

Hosted calls are finite and return to the VDP event loop. Guards admit a complete
bounded state before updating active buffers and page history. The compiler maps
owned IDs, retains mutable templates separately and enforces resource caps.
Checked assets use generated size/FNV-1a signatures to catch accidental mismatch
or corruption, not adversarial modification. The loader checks both bootstrap
and cleanup before installation; a full bounded cleanup stream is verified before
execution and failures remain retryable.

## Production and build

BUILDING.md is the authoritative build guide. The independently regenerated
production output is `.work/production/hardware-inline/`, byte-identical to the
card's earlier `inline-b` build. Production starts oval/demo with
`PRESS ANY KEY TO RACE`, supports `fuji`, `race` and optional `autosteer`, and
contains no game fencing, diagnostic reports, performance counters or serial logs.
It preserves the accepted30Hz scheduling deadline and120Hz physics. Research,
replay, lifecycle and timing executables are separate and must not replace it.

From the Rally worktree, choose fresh output names; these names already exist:

```sh
export PATH=/home/smith/Agon/agondev/release/bin:$PATH
make -C /home/smith/Agon/mystuff/golem-rally19/src
.venv/bin/python docs/tasks/RALLY-19/build_frontend.py NEW
.venv/bin/python docs/tasks/RALLY-19/build_production.py NEW --frontend NEW --inline-qualified
```

The explicit inline option revalidates the exact66-pose proof, source/evidence
hashes, both qualified bootstraps and regenerated integrity header. It does not
accept arbitrary new compiler output. Changes to compiler/program/assets need
fresh qualification. The unchanged bootstrap and cleanup must accompany the
matching executable; never deploy just a new binary with old scene assets.

For oval, the complete product is `rally.bin`, `oval.vdp`, `oval.clr`. Add the
two Fuji files to select Fuji. Artwork is embedded; production needs no `.road`
files. MOS command from the directory holding these files:

```text
load rally.bin
run . oval demo
```

| File | Bytes | SHA256 |
| --- | ---: | --- |
| rally.bin |95822|`64c8b0734bcd253112d162173fc38f343eafbc96894dc1d09b4793766ed59129`|
| oval.vdp |115526|`cad8b8339151262576f9cab237a58b4b5d47e5fc49acb9ea3eb046269ad9d044`|
| oval.clr |5016|`6f686c8b6e4660d8e42c4645e87a1656fd15ad1167a0c5a1710688ee5c37fd3f`|
| fuji.vdp |236910|`b3e6bf3eb53a8b27c3cbbc74854716a86042db0bd8f1f95b895638c67ba8e8dd`|
| fuji.clr |5118|`999170b235f34c76972739a5c64a208c8ccdb678dc3531c1f6f7af131d4e2ebd`|

Host Golem compiler SHA256:
`dc432c85c7df0aa3c039de3544ae3e6d382f584209d49701d08c0a3302b8056e`.
Native research frontend SHA256:
`0401d8af5e895832371b417a12d1a455b0dfb132f772c202328ef11f3f1da64b`.
These two executables have different jobs and must not be confused with production.
The accepted oracle remains commit949f618 and executable SHA256
`03322954c8c4fe29d90eaa0706c9169b242cdd264ea3b7b287cece58a6469d79`.

## Resources and verification

| Compiler resource ledger | Oval | Fuji |
| --- | ---: | ---: |
| Owned buffer IDs |836|853|
| Static asset payload bytes |36523|157129|
| Program payload bytes |63451|63946|
| Scratch payload bytes |3301|3346|
| Resident plus bootstrap payload bytes |218801|461331|

These are compiler byte ledgers, excluding allocator metadata, VDP framebuffer,
art uploaded by the frontend and other firmware memory. They are not total
physical RAM usage. REVIEW.md distinguishes the native allocation observer.

Final-asset checks include all66 frozen scene poses;14 compiler sanitizer suites;
834 checked-loader fault cases; eight native startup failures; both210-event
admission/lifecycle suites; two602-second independently audited replays; and12
native control cases with638 independent host-state comparisons. Exact scripts,
raw reports and limits are indexed in REVIEW.md/STABILITY.md. No historical
emulator validation substitutes for a new build's checks.

Use each worktree's `.venv/bin/python` explicitly. Golem's full host suite runs
as `.venv/bin/python tests/run_hosted.py` from its worktree. Rally's builders
`build_stability.py`, `build_lifecycle.py`, `build_render_work.py` and
`build_cpu_work.py` take `NEW --frontend NEW --inline-qualified`; corresponding
probes are named in STABILITY.md/PERFORMANCE.md. The final run prefix is
`hardware-inline`. Existing output/evidence paths are immutable; use fresh names.

Final native performance uses normal18.432MHz eZ80 limiting and UART, per-track
serial ABBA with two64-pose samples/variant, a separately calibrated construction
cycle counter and the qualified external native swap observer. The audit is
`evidence/golem-performance/hardware-inline/qualification.json`. Its sample
distributions, startup scopes, memory readings and all frozen budget checks are
retained; these measurements do not predict ESP32 throughput. Benchmark commands:

```sh
.venv/bin/python docs/tasks/RALLY-19/calibrate_cpu_work.py hardware-inline --build hardware-inline
.venv/bin/python docs/tasks/RALLY-19/probe_cpu_work.py NAME --build hardware-inline --track oval --renderer golem --cycles
.venv/bin/python docs/tasks/RALLY-19/measure_render_work.py hardware-inline-bridge --build hardware-inline --phase bridge
.venv/bin/python docs/tasks/RALLY-19/measure_render_work.py hardware-inline-abba --build hardware-inline --phase abba
.venv/bin/python docs/tasks/RALLY-19/qualify_inline_performance.py hardware-inline
```

These are exact historical invocation shapes, not permission to overwrite their
existing outputs. CPU probe names follow
`PREFIX-abba-TRACK-INDEX-VARIANT`, with oracle/golem/golem/oracle order on both
tracks. Run timing jobs serially without other emulators, captures or builds.

## Hardware conclusion and environment limits

The stock physical reset was a VDP `processLoop` stack-canary failure at4096
bytes. The selective inline correction reduces observed nested buffered execution
from eight to six. It completed120 logged returns on a stock-sized diagnostic
stack, minimum reported164 bytes spare including instrumentation. This is a
small measured margin and not a universal stack-safety guarantee. Official
VDP2.16.0 was restored and verified before the Author's successful reset test.
Cold power-cycle equivalence and full physical Fuji/manual-path validation are
not established by that test.

The corrected diagnostic observed approximately1.186 root-call returns/sec,
roughly0.84 seconds/call. This is sparse serial timing, not a scanout FPS counter.
The original ten-minute diagnostic emitted only1127 bytes, about0.098 seconds of
serial wire time; bulk logging traffic cannot explain the slow renderer. The
Author also reports slow operation with diagnostics removed. Buffering saves
transmission/host construction, while the same stock primitives retain their
drawing cost. This scalar/matrix/byte-manipulation lowering adds too much
interpreter work on the ESP32. Future acceleration claims need small physical
measurements before another full renderer effort.

The native VDP runs as a Linux host library; Fab's eZ80 limiter does not make it
an ESP32 timing model. The recorded native swap/vblank path is specific to the
pinned userspace implementation, not a universal30Hz double-buffering limit.
DEBRIEF-2026-09-12.md preserves that analysis. The production30Hz deadline is a
separate inherited gameplay choice.

Headless runners use canonical task-local profiles and their real generated
`./fab-agon-emulator` entrypoints, Fab1.2.4/MOS3.0.2/native VDP2.16.0 from the
AgonJukebox runtime. Never directly invoke the linked raw Fab executable or map
a containing tree into its own nested SD. Physical instrumentation uses a separate
official-derived build, not that native module. The current Agon has official
release VDP, unchanged MOS and the existing production card; extender keyboard
input remains commented out in autoexec. Passive serial capture is closed.

Reproduction currently assumes Linux paths, `/proc`, `LD_PRELOAD`, SDL3 headers
and libraries under `~/.local`, the installed agondev toolchain and local venvs.
Mac migration needs explicit tool/path/observer adaptation and new human emulator
validation; old native timings cannot validate that new environment. Generated
artifacts/profiles remain ignored. Full physical flash backup and official
artifacts are preserved in repository-root `.work/stock-vdp-2.16.0/`; diagnostic
ELF/map/bin and SD backups are under task `.work/`. Keep these local backups out
of indiscriminate staging. Original AgonDefender, Golem and Pynvaders worktrees
and remote refs are preserved.


## Final result recorded

Final native median intervals are31.7115ms oval and31.3037ms Fuji, with p95
36.7886/36.0928ms. Conservative eZ80 construction reductions are91.9637%/91.0078%;
scene UART reductions are88.5305%/86.6944%. All unchanged frozen checks pass.
The final evidence index rechecks644 files and explicitly records physical
performance as unaccepted. The experiment ends here with its hardware limitation
preserved; source and remote mainlines have not been replaced with this candidate.
