# Standard projection/buffer results — 2026-10-15

**Fine buffered construction takes79%less CPU-only wall time than the dense control and sends26.5%fewer application command bytes. Coarse buffered construction saves41.2%of those bytes. Real-transfer runs still stall, so no qualified completed-frame FPS or physics cadence is established.** Fresh review profiles are staged and stopped, explicitly unqualified.

Prior measurement/audit and released contract were pushed as119edcd/c811998. STD-002-01/02 implementation/host proof are delivered;03/04 have concrete CPU/wire/failure evidence but completed-pipeline, target physics-service and Author motion gates remain open. New work is uncommitted for review. [Full comparison](evidence/FINAL-COMPARISON.json), [historical interruptions](HISTORY.md).

## Matched CPU-only wall measurements

| Variant | CPU-only wall ms/frame | Ratio versus dense | Application command B/frame |
| --- | ---: | ---: | ---: |
| Dense control |150.665 |1.00x |1859.59 |
| Shared fine/direct |38.725 |3.89x |2310.13 |
| Shared fine/buffered |32.066 |4.70x |1366.57 |
| Coarse/direct |35.361 |4.26x |1742.56 |
| Coarse/buffered |30.773 |4.90x |1094.31 |

All five final09CPU applications independently pass900frames, exact expected command counts, final position1202800/phase1600, timer/callback restoration, unchanged input identities and zero backend protocol errors. They share one host boot, CPU boost monitored disabled, no measured suspension, official stock VDP2.16.0/MOS3.0.2, accepted108ec5b0… adapter and interpreter engine. The coefficient/helper/application pins are unchanged. PRT totals agree with independent host windows within0.16%; raw MOS counts disagree strongly and are not used for FPS. Every CPU window exceeds ten seconds.

The host observes guest-created start/end file witnesses at50ms polling. The approximate loop window includes small witness/entry/teardown overhead. Setup, CSV saving, result flushing and process shutdown are outside it. PRT is nominal1000ticks/s; overhead is included without guessed subtraction. These are **emulator CPU construction measurements**, with an opaque sink and no real submission or VDP drawing. The scripted3,600ticks preserve the earlier Fuji presentation workload; they are not normal player/input/rules physics and do not measure installed-game FPS or physical CPU headroom.

## Actual physics baseline with an independent clock

The **unchanged8,192-step actual-game physics binary** completes in24.476435host seconds: **334.69steps/s,2.988ms/step**. All420final state fields match the independent reference; no application wire bytes occur between its existing CAP_BEGIN/CAP_END markers, and timer restoration/inputs/backend checks pass. Raw PRT24,469ticks agrees with host time within0.031%; MOS advances only558units (22.80units/host second), confirming that nominal120/s is unsuitable for this emulator timing result. [Verified physics/coverage](evidence/physics-wall-boostoff/verified.json).

This reuses the original numerical tick/control sampling and includes representative road/pass, mixed surfaces/spawn, off-road qualification and arranged contact/recovery. It is isolated normal-game computation, not integrated deadline/headroom qualification. A120Hzschedule would still need rendering/transmission costs, bounded geometry work and real-time scheduling checks; no cadence is selected. Host marker observations include the adapter's nominal250ms trace flush plus50ms polling limits; no instrumentation subtraction or physical calibration is claimed.

## Real-transfer results

| Variant | Complete requests submitted | Corresponding replies | Bytes into next frame at stall |
| --- | ---: | ---: | ---: |
| Dense control |30 |30 |1429 |
| Shared fine/direct |247 |247 |1188 |
| Shared fine/buffered |80 |80 |992 |
| Coarse/direct |716 |716 |857 |
| Coarse/buffered |23 |23 |421 |
| Shared fine/buffered + physics service |463 |463 |833 |

Each of the six final09live/service runs stops on sustained upstream inactivity. Its complete setup and captured frame prefix exactly match the independent host stream; received reply bytes equal delivered bytes and all submitted complete requests have corresponding markers. The stream then stops inside submission of the next frame. This isolates the observed boundary; **root cause remains unproven**. Backend error counters remain zero. None qualifies a900-frame FPS result. The mode2physics-service attempt has no final guest snapshot, so no target physics rate/state/debt or120Hz claim is available.

The eleven candidate runs and additional physics calibration use the same host boot; all eleven candidate runs have matching boot identity, boost disabled and no suspension. The Author reports the earlier host problem appears related to Flexe with CPU boost. The final campaign has no host interruption, but the stock submission stall persists. No CPU boost/persistent power setting, private UART firmware patch, forced RX/CTS workaround, SDK/compiler/peer source or preserved product was changed.

Two earlier fine/buffered versions independently pass900frames/full setup and drawing streams/900raw callbacks. Their raw MOS/PRT clocks disagree and they lack an independent rendering-window host clock. They remain historical evidence, not a substitute for this matched failed comparison. [Refined v3 receipt/image](evidence/lookup-buffer/live-v3-interp/verified.json).

## Complete wire accounting

The CPU table counts all recurring application commands, including road patch headers/payloads/CALLs and existing scene/audio work. Live mode adds seven upstream completion bytes/frame. **Six bytes/frame is only the primary completion reply**, not all return traffic. A fully verified historical v3run records63,696returned bytes between setup fence and last frame callback:900six-byte callbacks,24four-byte type5packets and5,820ten-byte type6packets. [Exact accounting](evidence/COMPLETE-WIRE-ACCOUNTING.json).

For that complete fine/buffered stream:12initial configuration bytes +125,910asset/template setup bytes +7setup-fence bytes +1,236,209timed command/completion bytes +6post-timing mute bytes =1,362,144application upstream bytes. Boot/autoexec traffic is separate. The final failed09prefixes do not establish whole-run return totals. Reported26.5%/41.2%savings refer to application command bytes, not total bidirectional traffic. All variants preserve397panorama scrolls/399repaints and retained HUD/panel/audio behavior.

## Reuse, approximation and code generation

Normal and ASan/UBSan host models pass9,632poses/two tracks,10,677object cases, all1,037depth values and exact direct/buffered primitive equivalence for the same geometry. Ten whole-scene serializers agree. Independent actual-physics reference checks cover3,780fields in36partial-prefix cases. Five target physics objects are identical. Road/traffic/sign/player/finish/panorama share appropriate projection/depth/edge/tangent/sign invariants. [Range and consumer coverage](RANGES-AND-COVERAGE.md).

Fine centres use consistent nearest-pixel rounding; some legacy objects truncated instead. Coarse preserves material transitions, removes optional subdivisions and aligns objects with its polygonal centre; sampled differences reach28pixels. It remains an eligible motion/speed tradeoff for the Author, with no accuracy-only rejection. Other audited optimization families remain pending. Template bodies total1,379bytes plus70setup headers, excluding allocator overhead; Fuji coefficients require116,800bytes and executables193–207kB.

Shared v4is rejected: generated eZ80 code clobbered comparison flags while constructingy0, issuing399extra panorama draws. Corrected v5uses a one-argument helper; generated flags and all five final target command counts are checked. [Diagnosis and correction](CODEGEN-DEFECT.md). No compiler repair was adopted. Exact versions and rejected cases remain labelled separately in [VERSIONS.json](evidence/VERSIONS.json).

## Deliverables and remaining gate

1. [Portable v5inputs](PORTABLE.md) contain eleven exact CPU/live/service input sets and hashes. They are undeployed: no physical card write, flash or hardware run. They support a later byte-identical physical comparison after its release.
2. Fresh stopped profiles on Oryx are `.emulator/rally28-fine-v5-review` and `.emulator/rally28-coarse-v5-review`. They contain exact portable live inputs and are marked **STAGED ONLY / NOT READY FOR NORMAL MOTION REVIEW** because repeated stock submission stalls remain. No Author launch is requested yet. The launcher refuses used fixtures and CPU boost enabled; audio is always dummy. [Staging receipt](evidence/REVIEW-STAGING.json).
3. [Reusable tools](README.md) build/pin/package/run/collect/check full and failed streams, preserve timer phases/physics hooks, create output files and separate host/PRT/MOS clocks. Completed outputs are flushed before reporting success. Additional heavy builds belong on Oryx under the Author's latest instruction.
4. Further useful work requires resolving the stock submission boundary with its owner or releasing an identical hardware comparison. Evidence and portable inputs are ready for that decision. SDK/firmware repair, physical deployment, gameplay scheduler/cadence selection and normal-product adoption remain outside this tranche.

Every automatic run forced **both SDL video/audio dummy**. All owned emulators/supervisors are stopped, the temporary Rally sleep inhibitor is released, and boost remains0: [final stop receipt](evidence/STOPPED.json). Protected product SHA remains7f1620ed8139ee779e7d50e333ef572aeaf612a154e41ec574e63a57da760293. [Manifest](evidence/MANIFEST.json) inventories exact sources/artifacts; packed raw trace hashes are retained. No graphical/audio or physical launch occurred.

## Fab comparison — 2026-10-15

On Author instruction, identical v5 guest fixtures were run on Fab1.2.5's stock host VDP module. All five completed900frames without failure: dense5.60FPS, fine/direct14.15, fine/buffered18.06, coarse/direct15.67, coarse/buffered19.93 by host frame-loop windows. Separate fine/buffered physics diagnostic also completed and matched105reference state fields. See [FAB-RESULTS.md](FAB-RESULTS.md) for runtime differences, provisional timing limits and evidence. This does not qualify the failed Flexe runs or physical behavior.
