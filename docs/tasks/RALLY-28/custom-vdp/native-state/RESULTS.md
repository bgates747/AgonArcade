# RALLY-28 — Native state implementation results

**The rewrite is correct, but this Flexe cohort shows no FPS gain.** The paired
full-race results pool to **39.52 FPS baseline,38.59 native state and38.73 native
state with coarse calls**, using the uncalibrated nominal PRT clock. The new
arms are2.35%/1.99% below baseline. Keep the preserved baseline as the performance
reference; hardware comparison is needed before adopting the new paths for speed.

| Variant | Forward PRT FPS | Reverse PRT FPS | Pooled PRT FPS | Change |
| --- | ---: | ---: | ---: | ---: |
| Exact ROW-001 direct-row baseline |39.78|39.26|**39.52**|—|
| Native-owned state, exact old guest |39.38|37.83|**38.59**|−2.35%|
| Same native module, coarse four-step calls |38.85|38.61|**38.73**|−1.99%|

Each full run is900frames/3600logical steps/two warm frames. Pooling divides
1800frames by the summed nominal PRT durations, rather than averaging FPS.
MOS reports60.00FPS in all six cases, but its duration15s disagrees with PRT
22.627–23.788s; neither is a calibrated physical clock in this cohort. No
verified60Hz, real-time120Hz or hardware speed claim. Whole emulator process
windows, including setup/cleanup, are32.434–32.737s baseline,32.625–33.533s state,
and32.924–33.032s coarse. They also do not show a speed gain, but are not pure
race FPS. No runs were discarded, retried or added to improve the result.

## What changed

- Live scalar/player/route/opponent state is native-owned and aligned. Six
  16-byte Opponent records replace five separately accessed arrays in the
  numerical functions. Exact48-byte route and514-byte sine tables are native
  const data; their values and checked integer arithmetic remain unchanged.
- Numerical functions access fields/arrays directly. The old310-byte root and
  96-byte mutable-array image are boundary diagnostic exports, not the live
  state. Init imports its compatible scalar image; Render imports the same
  two external scripted-traffic arrays at the same point and keeps their effect
  on the next Tick. The large asset remains one scoped borrow per render.
- The state-only arm uses the **exact old guest binary and timed wire**.
  The coarse arm uses the **same new native package** but issues one direct
  native entry17, executing four native Tick functions and exporting once.
  It removes the hot interpreted Tick wrapper and17unused wrapper installations.
  Each actual step retains generation/state evolution; callback/publication/
  post-swap fences and final406-byte exported state stay identical.
- The complete road/sprite/player/sky/repair/HUD/footer/audio workload remains.
  Generated stock drawing lists and their three buffered CALLs remain. This
  tranche removes the state-access pattern and hot physics wrapper; native
  composition remains the separately proposed NAT-NEXT-03. UART is synchronous
  and the fixture still couples four logical steps to each render.

[Source](source/checked.c), [preparation transform](prepare_source.py),
[state ownership/lifecycle/adapter contract](STATE-CONTRACT.md).

## Access counts, code and memory

Actual C host checks count successful service pairs over the complete scene:

| Variant | Acquire/release pairs per900frames | Mean pairs/frame |
| --- | ---: | ---: |
| Baseline |278,512|309.46|
| Native state |54,734|60.82|
| Coarse calls |35,834|39.82|

This removes80.35%/87.13% of those pairs. It does not measure their duration.
Physics contains no per-element borrow; remaining pairs include compatible
exports, external inputs, renderer preflight, actor buffers and publication.
Private diagnostic scratch is retained for the exact-state oracle, so this is
not a zero-export production protocol. The counter reduction did **not** produce
a measurable full-frame gain here. That is a limit on the earlier performance
hypothesis, not proof that shared access is free or that hardware will agree.

Native code falls25,080→18,364bytes; data/rodata/BSS rises1,004→1,880bytes.
Both retain32768/4096/2048/65536 declared text/data/stack/package limits and the
same frozen SDK10947e0/corrected PSRAM policy. Native package is
`28da013de8fc20b66c2dc3b7dd78174b8b4dd55f6f2135d5ffbb773ed460c5af`.
The new coarse AgonDev guest has empty init/fini/ctor/dtor tables.

Entry static stack624 versus baseline352 and renderer prepare720 are individual
frames, not cumulative safety proof. Actual VDP task cumulative minimum after
racing is1892baseline and1620new; this is not eZ80 compute headroom or an isolated
module stack bound. All cases return/Stop/UNLOAD successfully.

Timed eZ80→VDP bytes are291,568for baseline/state and285,268for coarse. The only
coarse recurring change is four6-byte Tick CALLs replaced with one17-byte direct
silent RUN:7bytes/frame,6300total. Startup wrapper removal/package sizes are
separate from that timed saving. All requested reply tokens/statuses remain exact.

## Correctness and timing limits

1. Ordinary and ASan/UBSan actual-C comparisons pass every original single-step
   state and every coarse four-step group, independent world evolution,902road
   images/34,636,800pixels, both pages/guards/sync, all actor/scratch/command/
   completion bytes, seven row faults and session/Stop/INIT/FINI/reload checks.
   Unknown unused entries reject. The row service is a host mock; this does not
   replace moving visual acceptance. One initial harness-only ctypes bytearray
   conversion failed after its full-race checks; bytes conversion fixed it and
   the original failed log remains. No emulator retry was consumed.
2. All three60-frame smokes and six900-frame cases pass independently reconstructed
   callback schedules, every full-run2025native replies, exact final state/player,
   generation/publication/swap fences, Stop/UNLOAD, PRT restoration, clean MOS
   return and zero backend faults. Raw whole timed wire matches the original or
   the exact declared coarse replacement; no packet filtering/normalization.
3. Existing guest phase buckets remain mixed: baseline combined waits10.46–10.72s,
   state10.70–11.67s and coarse11.12–11.26s per900frames. Coarse player/rules/tick
   submission drops about1.864→1.759s, while total time does not. These are not
   exclusive native physics/render costs. Transport, overlap, Canvas/presentation,
   timer granularity and host scheduling remain entangled. A pure attribution
   requires separately scoped native timing; no single source count settles it.

[Host ordinary](HOST-ordinary.json), [sanitized](HOST-sanitized.json),
[all measured rows and phase totals](REPORT.json), [raw evidence](evidence/native01).

## Custody and publication

Audit and task/prior dirt were committed and pushed asb8f579e/2f89f20 before
implementation. Pi build generation57released08:40:33ESTafter all owned children
joined, nextnull. Source/native/eZ80 products fit without policy changes.

Oryx request9ef689742244waited behind6502/Wolf; actual Wolf generation273release
preceded fresh idle/checkout274 at08:57:41EST. All365project inputs and nine
profile manifests passed admission and remain exact. Same a50firmware/50e5ELF,
7e7dfrontend/plain086backend/MOS/JIT in all arms. Ordinary desktop applications
were present; no perfect measurement isolation is claimed. Both SDL drivers
dummy, max60C, original boost1restored1. All263retrieved hashes match.

Fresh whole-host idle/release at09:05:35ESTpreceded extended analysis. Actual
next Wolf requestca258bca56ec was immediately steered successfully. No Pi/Oryx
queue or emulator remains held. New implementation/results are uncommitted for
review; no default, hardware or Author visual acceptance is inferred.

[Readiness freeze](READINESS-FREEZE.json), [retrieval hashes](RETRIEVAL-SHA256.json),
[session](SESSION-native01.json), [release](ORYX-RELEASE01.json).
The pre-execution PLAN/inputs remain immutable; current task completion is
recorded below and in root TODO, rather than changing a frozen input checklist.

- **NAT-002-01** [x] — Task, source/control contracts and preimplementation checkpoint.
- **NAT-002-02** [x] — Native-owned state, typed access, exact tables and boundary adapters.
- **NAT-002-03** [x] — Direct coarse four-step entry and separate guest, same native module.
- **NAT-002-04** [x] — Actual-C state/pixel/lifecycle checks and frozen-policy builds.
- **NAT-002-05** [x] — Nine finite matched silent target runs, all functional gates pass.
- **NAT-002-06** [x] — Retrieved/released/notified; FPS/counts/wire/limits reported.
- **NAT-002-07** [x] — Complete local hardware kit prepared; physical/visual gates open.

## Console8 handoff

[HARDWARE-KIT.zip](HARDWARE-KIT.zip) contains the exact baseline/state/coarse
900-frame fixtures and shared required `vdp_rally.bin` (a50). Its hardware bytes
are the tested emulator fixture bytes. No card has been written or firmware
flashed. The firmware is the same as ROW-001's kit, distinct from the older
8da2hardware baseline; run all compared arms on the supplied same image.

Suggested destination: `/test/arcade/rally28-native01/{baseline,state,coarse}`.
Each directory's `load probe.bin` then `run .` executes the complete race and
creates its own telemetry files. See [instructions](hardware-kit/README.txt).
Baseline/state isolates ownership with identical guest/wire; coarse tests the
combined call change. The goal is hardware ground truth, not confirmation of
an emulator speedup that did not occur. Preserve all three results and the
Author's visual judgment. No further emulator retry, async/scheduler experiment
or native compositor change is selected by this return.
