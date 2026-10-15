# RALLY-28 capacity/census results — 2026-10-15

**Actual standard-game physics has useful isolated capacity in Flexe; dense rendering computation is the larger immediate cost.** The next candidate should restore shared lookup/sparse projection across all positioning consumers, retain a coarser visual option, and test a simple buffered road emitter. No game scheduler or optimization was installed by this tranche.

Author released PACE-001-01 and WIRE-001-01/POS-001-01/REUSE-001-01 discovery after all-dirt publication. Prior completion-probe work was committed/pushed as `7576ceb`; pacing/transport contract/release as `552d2df`. These new results are uncommitted for review.

## Actual-player flat-out baseline

The frozen fixture runs8,192 normal game ticks, four deterministic scenarios repeated twice. It calls unchanged `input()`/`tick()` and real Motion/rules/traffic/recovery/contact/passing/rank/view functions, with original numerical conventions. **All420 actual final-state fields match an independent Python model**, and ordinary/sanitized host results agree. UART capture confirms **zero application bytes inside the timed physics window**. Each run creates its own output files; no blocking VBlank call, rendering, file I/O or print occurs in that loop. Four last-block memory snapshots are included in aggregate timing.

| Clock | Raw elapsed | Nominal elapsed | Capacity | Mean/game tick |
| --- | ---: | ---: | ---: | ---: |
| MOS, nominal120units/s |2,690units |22.4167s |365.44ticks/s |2.737ms |
| PRT, nominal1,000ticks/s |24,476ticks |24.476s |334.70ticks/s |2.988ms |

Host boot/run/save/exit total is30.04s, a separate interval. The4096-step pilot already exceeded ten MOS-reference seconds; the final count8192 exceeds that threshold comfortably in the only tested platform. Future faster platforms/candidates may require a longer common count before comparison.

| Scenario,2,048 ticks each | MOS mean ms/tick | Nominal PRT mean ms/tick |
| --- | ---: | ---: |
| Circuit, road, pass |3.361 |3.650 |
| Arcade, mixed surfaces/spawn |2.555 |2.846 |
| Off-road qualification |1.945 |2.124 |
| Circuit contact/recovery/mixed surfaces |3.084 |3.330 |

Each round exercises one pass, one explicit contact,150 recovery ticks, real motion in3,946ticks, and road/kerb/grass branches. Recovery contact is intentionally arranged, not reported as naturally observed gameplay. Short blocks keep driving active; this is representative branch coverage, not complete menu/lap/finish/manual-input qualification. Input steering/grip retain a four-tick frame convention rather than being silently rescaled to a new faster tick.

**No physics cadence is selected.** PRT and MOS differ by9.19% in this final run; PRT follows nominal emulated eZ80 instruction clocks while MOS follows the video/host timing path. Repeated earlier measurements show stable PRT instruction totals but varying MOS intervals. Preserve both readings; neither is a calibrated physical CPU budget. Even the3.65ms circuit average is below an8.333ms reference interval, but that omits geometry, real transmission, completion service and deadline tails. It does not qualify120Hz gameplay. PRT ISR/normal MOS interrupts and fixture block/reset overhead are included, with no guessed overhead subtraction. The prior timer vector/reload/control/routing are restored; backend errors are zero and runtime/input identities are unchanged.

## Dense full-scene CPU and wire

A separate900-frame/3,600-tick centerline control calls the original presentation/SDK serializers with an opaque CPU sink. It reproduces historical scrolling/traffic/sign/HUD/title/footer/audio work, distinct from the actual-player benchmark above. It creates its own summary and completion files, matches the host recurring byte total1,673,633 and final station1,202,800/phase1,600, restores PRT and exits with no backend errors. The complete host command streams match in ordinary and ASan/UBSan executions.

| CPU measurement | Result |
| --- | ---: |
| MOS total / mean frame construction |127.3833s /141.54ms |
| Nominal PRT total / mean frame construction |134.771s /149.75ms |
| Centerline advance/view, nominal PRT |4.23ms/frame |
| Dense scene/sign preparation, nominal PRT |57.19ms/frame |
| Greedy fitting/vertices/command construction/formatting/SDK serialization, nominal PRT |88.29ms/frame |

The final sink is a separate translation unit, with no LTO, so calls must construct commands as for an opaque MOS receiver. Its byte counter/call overhead is included. Setup/assets run outside the timing window; no live UART or VDP drawing is included. These figures describe this diagnostic's CPU construction cost, **not rendered FPS**, real UART stall time or physical hardware performance. The emission stage contains substantial geometry work; treating it as only transport would miss the main optimization opportunity.

The [full wire census/model](WIRE-CENSUS.md) finds1,859.59B/frame:73.69% road,17.66% traffic/signs. The nominal serial lower bound is16.14ms/frame at1,152,000baud/8N1; actual MOS/CTS waits remain unmeasured here. Simple resident road templates with a compact final-coordinate plane model662.65B/frame instead of1,370.37, a51.64% road reduction including patch headers and CALLs. This is a candidate byte model, not a tested speedup: extra VDP copy/interpreter work and resident memory may offset savings. Small standalone bitmap patch+CALL sequences can be larger than direct drawing.

## Delivered scope and next tranche

1. **PACE-001-01 baseline delivered:** reusable actual-physics fixture, long fixed count, raw PRT/MOS clocks, independent state checks, exact binaries/input/runtime receipts, self-created outputs, protected game control.
2. **WIRE-001-01 discovery delivered:** full standard control census, executable serializers, CPU construction phases, setup/recurring and complete buffered byte models. Actual UART/CTS blocked duration and completed-pipeline timing remain open for PACE-001-02; no integrated headroom conclusion is substituted for those measurements.
3. **POS-001-01 / REUSE-001-01 standard map delivered:** [producer/consumer map and cache-lifetime contract](../../research/PROJECTION-AND-REUSE.md). It covers road, all object types, finish, panorama and world-physics distinctions, plus incomplete HUD/footer/route/invariant/command optimizations. Native audit/adoption remains separate.
4. **Recommended next release:** STD-001-03/REUSE-001-02 shared lookup/sparse derivative for every compatible positioning consumer, with a coarse-band visual variant; bounded simple buffered road prototype and PACE-001-02 transport/completed-pipeline comparison. Preserve the current dense product and exact fixture controls. Choose physics pacing only after those candidate measurements; PACE-001-03 scheduler remains later work.

Final Oryx profiles `rally28-capacity-baseline02` and `rally28-wirecpu-baseline02` are stopped. Every automatic session forced dummy video **and dummy audio**. Official stockVDP2.16.0, MOS3.0.2 and copied pinned Flexe runtime were used; no firmware/compiler/SDK/game files were edited. Product binary remains `7f1620ed…` byte-identical. No graphical launch, audio output, physical SD deployment or hardware run occurred.

See [reproduction/method/limits](README.md), [raw evidence](evidence/), [verification](evidence/verification.json) and [input/tool/evidence manifest](evidence/manifest.json). Physics01 replay-derived snapshots are superseded by physics02's actual timed-block snapshots. WireCPU01 is an earlier diagnostic; only wireCPU02's opaque-sink result is reported above. Their profiles/evidence are preserved, not mixed into final timing.
