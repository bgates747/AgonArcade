# R27-05 throughput fixture results — 2026-10-13

The current direct-eZ80 Fuji fixture runs headlessly on Oryx with both processors unpaced and creates its own result file after VDP completion. Two final-fixture runs completed 366 frames in 3,604 MOS ticks and 373 in 3,610 ticks: **12.19–12.40 nominal completed FPS in Flexe interpreter mode**. JIT mode produced one 5.29 FPS result but also stalled repeatedly in MOS UART CTS waiting; it is not a qualified repeatable baseline. These are emulator measurements, not hardware or displayed FPS. New diagnostic work remains uncommitted for Author validation and explicit approval.

## 1. Preserved checkpoint and implementation

1. On explicit Author instruction, all prior tracked/untracked dirt was committed as `a2a613f` and pushed to main before fixture implementation. The normal direct-road restoration is preserved there. No other project's uncommitted runtime changes were committed or modified.
2. A separate `RALLY_TIMING_FIXTURE` game build keeps the maintained renderer/scene and uses Fuji circuit attract traffic. It matches player speed to the route pace, holds the centerline, invokes normal contact checks and suppresses crash damage. It warms two pages, then advances simulation from elapsed MOS ticks with no eZ80 frame deadline.
3. Task-owned diagnostic ESP32 firmware adds R27T capability/elapsed-timer/completed-count commands. It drains drawing and directly swaps the double buffers without the ordinary vblank-synchronized queue primitive. Its completed swap counter must match the guest's frame count. There is no per-frame timing callback in the FPS-only run.
4. The guest creates `timing.csv` with create-new semantics after completion, with no per-frame disk or host service. Optional `RALLY_TIMING_DETAIL` builds add PRT1 stage totals and `stages.csv`; those builds compile but detailed runtime measurements are not qualified here. Ordered VDP start/stop markers are available for subsequent drill-down and unused in these FPS runs.

## 2. Headless observations

| Run | Fixture / engine | Outcome | Completed frames | MOS ticks including drain | Nominal completed FPS |
| --- | --- | --- | ---: | ---: | ---: |
| 01 | Initial / JIT | 240 s host timeout; incomplete drawing stream, no guest result | unavailable | unavailable | invalid |
| 01 diagnostic replay | Initial / JIT, debugger enabled | Guest CSV produced; retained separately, not primary timing evidence | 163 | 3600 | excluded |
| 02 | Callback safety update / JIT | Complete, matching counts | 159 | 3606 | 5.2912 |
| 03 | Fixed-state warm-up / JIT | 180 s host timeout, no guest result | unavailable | unavailable | invalid |
| 04 diagnostic | Final / JIT, debugger paused | Two snapshots stuck at MOS CTS wait, unchanged stream | unavailable | unavailable | excluded |
| 05 | Final / interpreter | Complete, matching counts | 366 | 3604 | 12.1865 |
| 06 | Final / interpreter repeat | Complete, matching counts | 373 | 3610 | 12.3989 |

Run 02 included 3,580 simulation/contact-check ticks; run 05 included 3,594. Run 06 included 3,598 simulation/contact-check ticks. All three recorded zero contact ticks, as expected for the fixed traffic spacing in these sampled scenes. This demonstrates collision-check execution, not a deliberately induced-contact test. Final drain cost rounded to zero MOS ticks; it was not zero measured microseconds. The last rendered frame may finish after the 3,600-tick threshold; actual elapsed counts, not a forced 30.000-second divisor, determine FPS.

The initial run's UART traces were replaced during diagnostic replay in the same profile; its original host timeout report is preserved, while that profile's later trace/CSV is labelled replay evidence. Subsequent runs use distinct profiles and preserve evidence independently.

## 3. Transport finding and interpretation

1. In diagnostic run 04, two debugger snapshots showed PC `0x001532`, `BIT 4,A`, in the MOS loop reading UART modem status at port `0xC6` and waiting for CTS. Registers and the transmitted stream remained unchanged between snapshots: 198,999 bytes, 42 swap command markers including warm-up. This identifies the eZ80 waiting for transport credit; it does not by itself identify why the receiver stopped consuming. The application was partway through command submission, not waiting for vblank.
2. Flexe reported `failed=false`, zero unhandled instructions, zero unregistered ROM calls and zero unmapped accesses for that diagnostic run. Keep the firmware/adapter interaction under investigation; absence of faults does not establish correct UART/queue behavior. No emulator source changes or artificial sender delays were introduced to conceal it.
3. The differing JIT/interpreter results cannot be presented as a renderer speedup: CPU/VDP scheduling and emulated clocks differ, the earlier fixture warm-up differs, and JIT has unresolved hangs. Raw clock counts, exact identities and host elapsed time accompany results. Host elapsed includes boot/setup and cannot simply replace the guest denominator.

## 4. Identities and reproducibility

1. Final FPS-only fixture: 165293 bytes, SHA256 `c2436c9f33b321fc157700efed518553c478e10c4c7723a8d67cec3ecce9a53c`. The normal release was rebuilt afterwards and retains its separate manifest/archive.
2. Diagnostic firmware: SHA256 `75388e4e59fee8177551d626b13029a5428788c4dbec61e3fe98d01d6569ba7c`; ELF `2f92b25b334bf9251911f02af1464f3bda505d9230a3d2cc5881872a49817ddd`. It derives from the VDPlet SDK's prepared VDP pin `1056ee38ec1cc68ed327bd32ee47d04b1c30597c` and graphics pin `ac2dd5986daf496c43ae8e7fe41836274aec54a0`; no VDPlet or Golem renderer is invoked.
3. Repaired Flexe frontend SHA256 `7e78e991a32c7bc94e84d70e8ad1792e3b840c48adc2e3aae7f635a88f4878ad`; adapter `200f28cbe399b1fdc60cba1e5fed4c2bb86042b5e92f6e422539a5388c079a30`. These are owner-uncommitted builds; the repository HEAD alone does not identify their input fix. Full per-profile runtime hashes are in the evidence JSON.
4. Source/build/binary preservation is under ignored task `.work/` and the content-addressed build archive. Portable source-inclusive fixture bundle `.work/rally27-timing03-source.zip`: SHA256 `78bc6fc56f45b0747cd5e6fd7be4742dfcadf3f98da14f11f3fd5cd1a89f3d4b`. It contains game source/build identity, diagnostic firmware/ELF, exact patched firmware headers and protocol/tooling.
5. Durable compact evidence is in `timing/evidence/`; raw traces and machine-specific profile paths remain local. See [fixture instructions and protocol](README.md) for the reproducible workload and capability requirements.

## 5. Validation and remaining limits

1. Current host geometry/rules/traffic/route replay/records/scenery tests pass. FPS-only, optional PRT-detail and normal builds pass empty CRT-table and release/fixture separation checks. Python tools compile and whitespace checks pass. No new driving-learning run, graphics launch or physical deployment was performed.
2. Flexe is the only exercised backend. The same guest/ESP32 firmware can be staged on physical hardware under later authority. Fab requires a native diagnostic VDP build with the same protocol and an immediate host buffer handoff; that backend is not yet built or qualified. Neither stock firmware nor a Fab scanout counter supplies an equivalent result.
3. Optional PRT runtime/calibration, VDP elapsed-marker validation, all-game-phase input regression, physical timing and human review of diagnostic swaps remain open. Repeatable JIT operation needs investigation before that engine is used for comparisons. This fixture does not close the full R27-04 regression matrix or all R27-05 acceptance criteria.

The final interpreter review profile is freshly prepared and stopped with no prior result files. Completed-run profiles, raw traces and output remain preserved separately. Profile guards and every runtime hash were verified after preparation; machine-specific launch commands belong in chat.
