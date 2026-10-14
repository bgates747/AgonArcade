# Native Fuji demo — Author visual review accepted

Latest matched benchmark: **Flexe29.02FPS / Console823.45FPS**, using byte-identical unpaced fixtures/firmware.900frames/3600ticks and complete final state pass. [Comparison/evidence](IDENTICAL-COMPARISON.md). These supersede the earlier comparison of paced Flexe versus unpaced hardware.

Actual Golem physics and the accepted renderer now run together on Oryx in Flexe JIT. Both the full diagnostic and viewing configurations pass900 rendered frames/3,600 physics ticks, save their own logs, return to MOS and stop cleanly. All final source globals and five mutable arrays match the independently qualified host world. The viewing run averages28.85 nominal MOS-clock FPS against a30-FPS target; the Author accepted the fixture appearance on2026-10-14; physical performance remains open.

- **TRF-001-46** [x] — Consumed real Golem candidate48eac7efe8fa51f4,17entries/root310bytes, actual source/helper hooks and corrected-clock runtime.26 present artifacts verify; missing advertised diagnostic rally-render.o reported without mutating snapshot. DELIVERY-RECEIPT.json records identity; no production/published compiler pin adoption.
- **TRF-001-47** [x] — Built actual MOS caller,58,742-byte artwork stream/149,518-byte Fuji asset and57,881-byte guest. Explicit installs, completion/fresh-generation draw gate, four physics calls per frame, centerline pace-matched player/no damage, teardown and self-created logs. Viewing mode consumes actual generated wrapper handle offsets and keeps ready/request/tick/generation checks.
- **TRF-001-48** [x] —60-frame real-module smoke passes, then full900-frame diagnostic at25.58 FPS and900-frame viewing configuration at28.85 FPS. NATIVE-RESULTS.json/REVIEW-RESULTS.json retain exact runtime/firmware/package inputs, checks, elapsed time and stack/backend observations; raw viewing logs under evidence/. Native INFO17 minfree2260 before/after, backend failure/unhandled/unregistered/unmapped counters zero. No skipped physics: final world matches independent3600-tick state.
- **TRF-001-49** [x] — Dedicated Oryx `.emulator/rally25-native-demo` staged, identity verified, stopped. Actual human launch instructions are in README.md; Author's visual confirmation is pending and remains final gate. New launcher is flexe-agon-emulator with no Fab compatibility aliases, following the relayed Author naming preference.
- **TRF-001-50** [x] — Independent PRT stopwatch progression/logs/prior-vector restoration qualified on Oryx. PRT-RESULTS.json records driver-only check; actual demo creates separate prt.log/clock.log. Nominal instruction-driven PRT time remains distinct from MOS/host/physical clock.

The old frame-gated hybrid runtime stalled paced controls; Golem twenty-two supplies the narrow independent-VSync frontend candidate. Actual900-frame deadline-paced jobs complete with it. The deadline target is30Hz but measured viewing throughput is28.85FPS; no target-cadence achievement or autonomous scheduler claim. Full diagnostic elapsed35.1833 nominal MOS seconds/44.471 host seconds including setup; viewing31.20/40.353. PRT nominal ticks differ and are not substituted for wall clock. This is a deterministic renderer/simulation demo, not the full game migration.

Preserved source/helper/reference manifests and game/production/bench trees remain unchanged. No graphical launch, physical operation or commit/push occurred. Review the stopped visual candidate next.

Golem twenty-three supplies passing owner host/sanitizer/oracle/negative controls and an appended export receipt accounting for the omitted diagnostic object. Rally verified all32 delivered file identities against that receipt; original snapshot bytes remain unchanged. Owner controls are recorded separately from Rally actual-target runs.

## Author review accepted

The Author reported that the demo looked good and explicitly understood the missing background as outside this test. [HUMAN-REVIEW.json](HUMAN-REVIEW.json) and raw human-run evidence verify900 frames/3600ticks,2913 retained reply records, final source globals/all five mutable arrays matching the independent model, PRT teardown and unchanged staged runtime identities. Human run elapsed30.7167 nominal MOS seconds (29.30FPS); this remains emulator fixture timing. Flat sky/full scenery omission is accepted for this fixture only. Keyboard was not separately reported. Visual acceptance grants no new commit/push, physical action or next implementation scope.

## Timing interpretation correction; hardware staged

Use [TIMING-CORRECTION.json](TIMING-CORRECTION.json) for the corrected120MOS-unit/s nominal interpretation of the unchanged raw receipts: human29.30FPS/30.7167s, viewing28.85FPS/31.20s, full25.58FPS/35.1833s. Prior100Hz-derived values in raw JSON and historical messages are superseded. The earlier3/3/4-unit pacer requested nominal36Hz; the current30Hz branch uses4units. No calibrated wall-clock/cadence claim follows from these numbers.

TRF-001-51 complete: ten fixture/firmware/readme files copied to the verified Console8 card at `/test/arcade/rally`, writes flushed; [receipt](HARDWARE-DEPLOYMENT.json). TRF-001-52 awaits Author flashing/manual run and returned logs. No hardware run or commit/push performed.

## Console8 returned hardware run —2026-10-14

Console8 hardware qualification passes:900 frame requests/3600 physics ticks and2913 saved reply records; final source globals/all five mutable arrays match the independent reference. Unpaced aggregate fixture throughput is **23.45FPS**,4606MOS units at nominal120units/s =38.3833s, mean42.65ms/frame. PRT1 independently records38313nominal1ms ticks =38.313s/**23.49FPS**, agreeing within0.19%; previous vector restored. Stack INFO17 remains2260before/after; StopRace/UNLOAD succeed. Supplied firmware is8da2ebf...; fixture does not read back the flashed image. See [HARDWARE-RESULTS.json](HARDWARE-RESULTS.json) and evidence/hardware-*.

The timing window excludes boot/assets/init, final-state reads and log saving. It includes finite physics, renderer preparation, UART/readback checks, draw commands and swap submission; there is no separate VDP completion timestamp. Of900MOS frame intervals,394 are4units (~33.3ms),505 are6units (~50ms), and the initial interval is0. This indicates VBlank-quantized fixture cadence, without isolating its bottleneck. No autonomous120/30Hz scheduler is present; nominal clocks remain externally uncalibrated. Card contents/logs were left untouched after retrieval.
