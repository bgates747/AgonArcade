# RALLY-28 standard physics capacity and full-scene wire fixture

PACE-001-01 and the released WIRE-001-01/POS-001-01/REUSE-001-01 discovery tranche,2026-10-15. [Results](RESULTS.md), [wire models](WIRE-CENSUS.md), [shared producer/consumer audit](../../research/PROJECTION-AND-REUSE.md), [machine-readable verification](evidence/verification.json).

The task owns all new source/build/profile/evidence files here. `rally-game`, `rally-production`, `rally-bench`, native/full-scene fixtures, firmware and SDK are unchanged. Current game source is copied byte-for-byte into ignored `.work/include/product_main.cpp`; its normal `input()`/`tick()` functions are included without assisted-driver/telemetry/timing macros. AgonDev compiles the target; ordinary and ASan/UBSan host models compile the same source. The Python reference is independent, reusing the preserved independent route model and input tables.

## Actual player physics capacity

`src/workload.hpp` defines four1,024-tick blocks, repeated twice: circuit straight/road with a pass, arcade with kerb/grass movement and spawning, off-road qualification, and circuit with an explicit initial overlap exercising contact and150-tick recovery. They call the real player, traffic, contact/passing/rank, recovery and rules code. Input replay invokes the actual game `input()` every four ticks with deterministic gas/brake/steering keys. No live MOS keyboard read, printing, recurring commands, file I/O, geometry, renderer or pacing occurs in the timed loop. Resets/block dispatch, MOS/PRT interrupts and four memory-only final snapshots are included in aggregate timing. Per-block intervals exclude those final snapshots. Per-step timers are avoided.

The numerical baseline deliberately retains original120-unit rule ticks, `/100` Motion integrators, world-speed multiplier2 and one control update per four ticks. This does not choose120Hz pacing or silently fix the existing mixed numerical conventions. Benchmark capacity means game-tick throughput for these workloads, not an isolated multiplication rate or a rate qualified with rendering. Short scripted blocks keep driving phases active; they are not a complete race/qualification or trained controller.

The count is read from `count.txt` outside measurement. Pilot calibration used4,096steps; the final frozen comparison uses `2\n`, exactly8,192steps. If a later tested environment finishes this count in under ten MOS-reference seconds, choose a longer common count and remeasure every comparison; do not compare different counts as if the workload were identical.

PRT1 is borrowed only when idle/unclaimed, routes internally, and runs nominal1ms interrupts at18.432MHz/16/1152. The fixture saves/restores reload/control/routing and the prior MOS interrupt vector. It checks the removed vector is its own handler. MOS clock is read directly from sysvars with a stable double-read; no blocking VBlank wait. Counter ISR and ordinary MOS interrupts are included. PRT frequency/cycle accuracy is not calibrated against physical hardware, and the emulator clocks disagree; report both without subtracting a guessed ISR cost.

The final target captures105 explicit32-bit field values per scenario **from the last timed blocks**, with no post-measurement simulation replay. Independent checks cover420 values: player, rules, crash, pace, all six traffic slots/cursors and view outputs. Pointer/padding/host-int differences never enter the file format. Markers `CAP_BEGIN`/`CAP_END` surround timing; UART verification proves zero application bytes between them. All output files use MOS write/create-new flags6 and are written after timer teardown: `summary.txt`, `phases.csv`, `state.csv`, then `done.txt`. Fresh directories preserve older returns.

## CPU command construction and wire census

The wire control is the historical deterministic900-frame/3,600-tick Fuji centerline workload, including all six opponents, signs, scrolling panorama, title/footer, HUD and engine changes. It uses the original game presentation functions plus unchanged AgonDev C serializers. It is separate from the actual-player workloads above. `scene_workload.hpp` shares the exact schedule between host census and target CPU sink; normal and sanitized host runs capture every serialized byte by component.

The target CPU fixture executes the same scene and emits to **opaque sinks in a separate translation unit, with no LTO**. Thus normal callers must construct their command bytes. It counts bytes and times advance, scene/sign preparation, and construction/emission including greedy band fitting/vertices/formatting. It does not send them to VDP; assets/setup run before timing. The CPU fixture always runs900frames; its profile's inherited `count.txt` is unused. It creates `summary.txt` and `done.txt` after teardown. Whole byte count and final station/phase are checked against host results. Normal host capture includes every byte; target verification checks total, not full stream identity.

Actual UART/CTS blocking and VDP raster/completion remain the released-discovery gap to measure in PACE-001-02. The baud-derived wire time is a bandwidth lower bound, not measured CPU waiting. No new buffered template is implemented by this tranche. No screenshot/visual or game FPS claim follows from these sink runs.

## Reproduction

From repository root on Pi:

```bash
.venv/bin/python docs/tasks/RALLY-28/standard-vdp/capacity/build.py
```

The script copies current product source, builds isolated binaries using `/Agon/agondev/release`, checks the physics CRT tables are empty, and builds two host tools. `evidence/build.json` records all compiler inputs/SDK source identities; `evidence/timing_prt.asm` preserves the generated timer adaptation. Run both host binaries' `physics` modes and compare their CSV with `reference.py`. Run each `wire` mode in a **new empty directory**; it writes `frames.csv`, setup bytes and per-component raw byte streams. `analyze.py` consumes the recorded fresh final directories `.work/wire-final-ordinary`/`wire-final-sanitized` and final guest evidence. Existing `.work` and evidence are preserved; choose new directories for a new candidate instead of appending streams.

Oryx deployment uses canonical SSH authority and an isolated profile. Copy this task directory/build products with rsync, retaining the canonical setup helper under the completion-probe's `.work` fallback if required. `profile.py` reuses copied, hash-pinned runtime binaries from the earlier stopped `rally28-completion-poll02` profile; it does not adopt a moving live adapter. It enforces official stockVDP2.16.0 and MOS3.0.2. A fresh run example on Oryx:

```bash
.venv/bin/python docs/tasks/RALLY-28/standard-vdp/capacity/profile.py rally28-capacity-new01 --rounds 2
.venv/bin/python docs/tasks/RALLY-28/standard-vdp/capacity/run.py .emulator/rally28-capacity-new01 --timeout 90
```

For the CPU sink, use a new name and `--kind wirecpu --rounds 2`, with240-second timeout. `run.py` **forces both `SDL_VIDEODRIVER=dummy` and `SDL_AUDIODRIVER=dummy`**, starts only the generated `./flexe-agon-emulator`, validates input hashes before/after, waits for self-created completion files and terminates only its own frontend. Final tested profiles `rally28-capacity-baseline02` and `rally28-wirecpu-baseline02` are stopped. No profile, GUI, audio backend, physical card, flash or hardware session is launched for Author review by these instructions.

Frozen binaries/count/runtime identities and guest outputs are under `evidence/physics02` and `evidence/wirecpu02`. Compressed complete host wire streams are under `evidence/wire`; decompressed hashes are recorded in verification.json. `evidence/manifest.json` covers tool/reference/protected-product/evidence identities. Physics01 is superseded diagnostic evidence: its states were obtained by an untimed replay, corrected to actual timed-block captures in physics02. WireCPU01 remains stopped on Oryx as an earlier diagnostic; wireCPU02 uses the required opaque sink. Neither earlier run is combined into final timings.
