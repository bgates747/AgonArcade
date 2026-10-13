# RALLY-27 first-tranche results

The full game now computes its road entirely on the eZ80 and emits ordinary colour/PLOT commands. Host geometry and existing gameplay tests pass, and the new Flexe runtime renders both tracks' title/demo scenes. **Update, 2026-10-13:** after authorized Console8 SD deployment, the Author reported that all three deployed games worked as expected, establishing reported physical gameplay acceptance of this exact Rally candidate. The Author also reports that the Flexe agent fixed keyboard input. The earlier input failure below is historical evidence; Rally has not yet been requalified with the updated emulator. No measured game FPS or exhaustive physical phase coverage is claimed. New implementation remains uncommitted pending explicit commit/push direction.

## 1. Work delivered

| Step | Status | Evidence |
| --- | --- | --- |
| R27-01 | Complete | BASELINE.md, inputs.json, preserved binary/map/manifest in ignored .work/baseline |
| R27-02 | Complete | direct_road.hpp; 34,005 exact donor-command cases; sanitizer and multi-chunk stress |
| R27-03 | Implemented | Normal full game uses DirectRoad, no section startup or lookup load/destruction; standalone binary |
| R27-04 | Partial | Host tests/builds and both-track demo captures pass; Console8 gameplay accepted by Author; remaining phase coverage and updated-Flexe input validation pending |
| R27-05 | Not started | No frame-rate claim or live-eZ80 benchmark in this tranche |
| R27-06 | Partial | Console8 gameplay accepted; Flexe input fix reported, updated-runtime review and explicit commit/push approval pending |

Prior work was committed and pushed before editing:067f88c (VDPlet/Flexe evidence), e33da22 (version catalogue),19d54c9 (restoration plan). Clean tracked-tree state was verified before this tranche. New implementation remains uncommitted for review. Production, bench, historical renderer and R24 source files were not changed.

## 2. Implementation

`rally-game/include/direct_road.hpp` adapts the existing direct Road in the preserved production header. Its geometry matches historical rally/include/road.hpp; the shared production header retains today's Motion tuning. It computes every visible row's centreline by live track sampling, uses the original greedy band fitter, calculates final vertices and emits ordinary colour/PLOT quads. No lookup interpolation or buffered matrix computation remains in the full-game road path.

The adapter supplies centerAt for player/traffic/sign/finish-line consumers. Row103, above the projected road, is computed explicitly rather than reading uninitialized row storage. Original signed/truncating geometry is retained. The full game's physics, two-tick held steering, default200% grip, race rules, retained HUD, traffic, signs, effects and audio were not replaced by prototype code.

Output flushes occur between complete road bands using the existing4096-byte Stream. A band reserves five27-byte quads; the footer reserves15bytes. The sampled tracks need at most1947road bytes/frame, but synthetic maximal fragmentation exercises multiple chunks. No new large stack buffer or dynamic road allocation was introduced. Removal of the lookup removes its track-file dependency; only rally.bin is needed at startup. Bitmap buffers and affine car/sign drawing remain intentionally supported.

## 3. Verification

1. 34,005 deterministic host poses across both tracks, five stripe phases and three camera offsets (-150,0,+150world units) match the independent preserved donor's final road command stream exactly. Negative/offscreen geometry, road rows104–224 and explicit traffic row103 are covered. Command decoding permits only colour and PLOT, not buffered API opcodes. Synthetic alternating geometry/material fragmentation tests bounded multi-chunk emission.
2. AddressSanitizer and UndefinedBehaviorSanitizer pass the direct component suite.
3. Existing rules/deadlines/reset/catch-up/HUD, route/grid/wrap/spawn/finish,600-tick Python/C++ route replay, and record corruption/activation/backup tests pass.
4. Sign coverage now uses DirectRoad: all eight signs remain visible,4541oval and25707Fuji projected sign instances stay within road-refreshed rows. The previous lookup result was25706Fuji; the one-instance visibility difference is recorded, not hidden as pixel-exact old-renderer parity.
5. Ordinary and optional RALLY_HOST_TELEMETRY builds pass. Empty CRT initializer/finalizer tables and release/fixture/private-gateway separation checks pass. Existing packet protocol was unchanged; telemetry runtime on hardware was not tested.
6. Source-inclusive standalone review archive is generated and verified through package.py. Old products and earlier candidate archives are retained. Current identities and logs are under .work and the final build/evidence summary.

These tests preserve component semantics; they do not substitute for interactive qualification, physical timing, or complete visual coverage. No all-phase in-emulator success is claimed. R27-04 qualifier/race/crash/save input-driven emulator runs remain pending validation with the reported input repair.

## 4. Historical Flexe evidence and input failure

Selected runtime is the separately maintained `flexe-agon-emulator`, commit81fd40e9d404d30bcce4a6150d1948345a41a79c. It is not the old GOLEM-021 frontend. Tested executable hash412089a89a5adccb3c1c0fc4b121472da28f2d3d48c435c88a660028d7cd84d9, adapter77b3cbf76564d54628c2bb876aa96ef3834c6b363d53df4892b8a3ab4248e5cd. Each isolated profile pins its MOS, actual ESP32 image/ELF, frontend, adapter and game identities. The frozen ESP32 image is copied from the previously qualified MOS Flexe consumer; no VDPlet is loaded or invoked by this game. This is not a fresh stock-firmware qualification claim.

| Check | Outcome | Host duration |
| --- | --- | ---: |
| Initial profile preparation | Launcher rejected missing runtime manifest before guest execution; helper corrected | Immediate |
| Oval title/demo | Rendered road/kerbs/markings/cars/signs/HUD; clean engine exit, no unmapped/unhandled faults |35.12s |
| Fuji title/demo with Space injection | Rendered correctly; Space down/up twice logged by SDL harness, two key bytes accepted by adapter, title remained active |21.75s |

Capture counters in Flexe are scanout counters, **not Rally FPS**. Host duration includes startup. Test hooks are only the SDL capture interposer; the game binaries in these smokes have no test defines. Captures are machine-inspected, not Author acceptance.

The reusable visual_capture_frontend.c produced both key-down and key-up SDL events at host presents660/690 and780/810. Flexe adapter source `sendPS2KbEventToFabgl` returns immediately for !down and maps supported key-down events to ASCII; `feed_queues` injects that queue into ESP32 UART0. It does not model the key-state PS/2 path needed for MOS getKeyMap. CLI typing acceptance therefore did not establish game-control compatibility. Do not work around this by changing Rally to ASCII controls: that loses held/release behavior and alters the requested game.

On 2026-10-13 the Author reported that the Flexe agent fixed keyboard input. The runtime identities above describe the earlier tested runtime, not the repaired version. Updated runtime identity and R27-04 results through the real held-key input path remain to be recorded. No emulator source was modified in this Rally task; preserve the earlier failure evidence and correct held-key controls.

## 5. Human review status

The normal Flexe review candidate was prepared and left stopped, displaying the full-game oval title/demo in the earlier checks. The Author reports the input fix, but no updated-runtime Rally review is recorded. No graphical emulator was launched by the agent.

After the initial results, the Author authorized Console8 SD deployment. The receipt at `.work/console8-deployment.json` records copied, synced and hash-verified Rally (164315 bytes, SHA256 `7f1620ed8139ee779e7d50e333ef572aeaf612a154e41ec574e63a57da760293`), Defender and Aginvadors binaries. The Author then reported: “everything worked as expected, though Rally is the one we really wanted to work.” This establishes reported Console8 gameplay acceptance of the direct-eZ80 full game. Defender and Aginvadors were rebuilt from existing source without source changes; Aginvadors belongs to separate Pynvaders. This acceptance does not establish measured FPS, telemetry hardware qualification or an exhaustive game-phase matrix.

Machine-specific profile locations and launch instructions are provided privately in chat. The public record retains runtime identities, results and acceptance limits. Detailed timing remains unstarted R27-05 work, outside the authorized first tranche. Console8 acceptance does not imply emulator review or commit/publication approval.

## 6. Final candidate identity

Normal binary:164315bytes, SHA2567f1620ed8139ee779e7d50e333ef572aeaf612a154e41ec574e63a57da760293; baseline171080bytes. Final Fuji smoke ran25.12s; final no-switch oval smoke ran25.07s and exited cleanly, with no Flexe unmapped/unhandled faults. Detailed identities are in verification.json.

| Linked section | Preserved baseline bytes | Direct candidate bytes |
| --- | ---: | ---: |
| text |44992|43842|
| rodata |123621|116753|
| data |1986|3239|
| bss |14940|14940|

The static Road arrays increase data by1253bytes while removing the startup coefficient-table allocation. No additional4096-byte stream is allocated; output reuses the existing one. Build/image checks establish empty CRT tables, not a measured worst-case runtime stack watermark.

Verified source-inclusive archive: `.research-cache/rally22/rally27-direct-review02.zip`, SHA256f64dee5406a7155a5dd79431510d33a5f1fac60819155e5d151c515f35ab11a2. It includes only rally.bin and player readme at runtime root, with build/source material under project_files. Earlier smoke/package variants remain preserved, not relabelled as this final binary.

## 7. Flexe launcher naming correction

The active review profile and preparation helper now use `flexe-agon-emulator` and `flexe-agon-emulator.bin` directly. No Fab-named compatibility launcher or executable alias is installed in new profiles. Canonical MOS validation and runtime identity guards are retained. Earlier test identities preserve their historical names; the underlying executable was already Flexe. Machine-specific launch paths remain private.
