# R27-05 direct-game throughput fixture

The fixture measures completed Fuji attract-scene frames, with eZ80 pacing and VDP vblank swap waits removed. The guest bounds submission by 3,600 interrupt-updated MOS ticks, drains the last frame, and creates `timing.csv` afterwards. Detailed measurements are optional. This is completed-frame throughput, not optical display FPS.

## 1. Build and runtime

1. Build with `PATH=/path/to/agondev/bin:$PATH make -C rally-game EXTRA_GAME_FLAGS=-DRALLY_TIMING_FIXTURE`. Preserve the binary, map and `bin/build.json` under a distinct run directory before building another variant. The normal `make -C rally-game` excludes the timing assembly and instrumentation.
2. For eZ80 stage totals, additionally define `RALLY_TIMING_DETAIL`. This claims PRT1, installs/restores its MOS interrupt vector and accumulates nominal 1 ms ticks using the existing Pingo stopwatch design. `stages.csv` reports hot-loop, scene/road projection preparation and submission totals. Road final-vertex emission occurs in submission, so the geometry field does not pretend to include all arithmetic. Interrupt sampling, quantization and UART backpressure affect these intervals.
3. `build_firmware.py --donor PATH --output NEW_EXPORT` copies a previously prepared VDPlet firmware source tree and dependencies into task-owned output before applying diagnostics. It requires PlatformIO in the project venv. No upstream tree is modified and no hardware is flashed. The source base is the SDK's pinned VDP/graphics export; no Golem code or VDPlet is loaded by the game.
4. Flexe executes the resulting ESP32 firmware. `profile.py` prepares a fresh isolated guarded profile with explicit binary/firmware/ELF inputs; `run.py PROFILE` runs it headlessly and preserves logs, guest CSV and host report. Machine-specific source/profile paths stay in private chat. The launcher and binary retain Flexe names.
5. Real hardware can execute the same game binary and diagnostic ESP32 firmware after separate deployment authority. Fab needs a native VDP build of the same command handler and unpaced swap semantics; loading the ESP32 binary into ordinary Fab is unsupported. Its USERSPACE controller's explicit `waitVblank()` must also be bypassed in the diagnostic swap path. Do not claim a Fab baseline until that native backend has been built and qualified. Stock firmware fails the capability handshake rather than silently supplying paced results.

## 2. Workload and boundaries

1. Track Fuji, circuit attract traffic, player centered with speed taken from the current traffic pace record. Existing route simulation, signs, road, scenery, HUD/title panels, graphics and sound remain. The ordinary attract branch normally bypasses contact checks; the fixture explicitly calls the normal contact predicate and counts contact ticks without starting crash damage. This is an attract-derived renderer workload, not complete game-phase validation.
2. Two full scene frames warm both pages outside timing. Before measuring, the VDP drains and resets its completed counter. Physics then advances by actual elapsed MOS ticks; frames can repeat a simulation state. Initial state and runtime identities must accompany comparisons.
3. The eZ80 frame deadline is disabled. Diagnostic swaps drain drawing and directly hand off the double buffers without the queued vblank-synchronized swap primitive. Tearing is expected in this throughput mode; page ownership and retained per-page history continue to alternate. In the pinned double-buffer driver ordinary primitives execute synchronously on submission.
4. After the last submitted frame, an ordered VDP request drains drawing and reports the completed swap count. The denominator includes submission plus final completion/callback latency. Timeout/mismatch marks the run invalid. A timeout keeps the callback code resident rather than returning to MOS while a late packet could jump into released application memory.
5. No per-frame SD writes, printf or host telemetry service. CSV uses create-new semantics and refuses to overwrite prior evidence. Host tooling attaches exact runtime hashes and calculates completed FPS only from valid matching counts. Nominal MOS seconds assume 120 ticks/s; host elapsed time includes boot, setup and cleanup and is separately reported.

## 3. Reusable diagnostic protocol, R27T version 1

Task-private command: `VDU 23,0,0xDA,operation,token`. This selector is verified unused in the pinned firmware, not allocated as a public platform API. Payload: ten bytes `R27T`, operation, token, little-endian u32 value, delivered using `PACKET_KEYCODE` with the stock framing (12 bytes total). One request may be outstanding. The callback preserves registers, copies recognized packets, neutralizes synthetic keyboard fields and leaves other keys intact.

| Operation | Effect / returned value |
| --- | --- |
| 0 | Drain, disable diagnostic unpaced swaps |
| 1 | Drain, enable unpaced swaps, reset count; capability value `0x010027` |
| 2 | Drain and start an ESP32 microsecond timestamp; acknowledgement |
| 3 | Drain and return elapsed microseconds since operation 2 |
| 4 | Drain and return completed diagnostic swap count |
| 5 | Drain and reset completed count |

Start/stop markers provide subsequent elapsed VDP processing measurements. They include command starvation/scheduling, exclude callback delivery from the returned interval, and do not measure pure rasterizer CPU time. They are unused in the initial FPS-only run. Returned duration is modulo u32 microseconds; bounded 30-second runs fit. PRT totals are separately labelled and are not required for FPS.

## 4. Evidence

The normal game and diagnostic builds must pass empty CRT-table and binary separation checks. Retain test receipts, game source/build identity, firmware/graphics source identity, runtime hashes, guest output and completed-count match. Custom-firmware behavior requires Author validation; new work remains uncommitted until explicit approval. Existing renderer restoration was committed before this task began.
