# Real composed Fuji demo — visual accepted; hardware staged

**2026-10-16 review correction:** the preserved human/C8 review binary still uses the older3/3/4MOS-unit pacer, requesting nominal36FPS at120units/s despite its30-Hz label. Current guest source uses4units/30FPS. [Recovered-byte evidence and comparison policy](../../RALLY-28/custom-vdp/paced-road/PACER-CORRECTION.md). Latest preserved paced returns are29.57FPS Flexe/26.84FPS Console8; their120-unit clock conversions remain correct. The older unpaced comparison below is a separate fixture.

Latest matched benchmark: **Flexe29.02FPS / Console823.45FPS**, using byte-identical unpaced fixtures/firmware.900frames/3600ticks and complete final state pass. [Comparison/evidence](IDENTICAL-COMPARISON.md). These supersede the earlier comparison of paced Flexe versus unpaced hardware.

The real composed Fuji demo is built, qualified headlessly and staged stopped on Oryx. Actual Golem physics and the accepted native renderer pass900 rendered frames/3,600 physics ticks; final source globals and all five mutable arrays match the independent model. The viewing configuration averages28.85 nominal MOS-clock FPS in Flexe JIT, below its30-FPS target. This is experimental fixture evidence, not hardware FPS or a full playable game. The Author accepted this fixture's appearance, including the intentionally flat background; the saved human run is verified. No commit/push has occurred.

`compose.py` derives `demo.golem` from preserved route-kernel fragments without modifying them. It adds explicit presentation globals and fixture init/reset/render/stop entries. A supplied centerline player advances with traffic; all six opponents stay active, collision predicates run, and damage is omitted. This is fixture behavior, not a new recovery/telemetry contract. All earlier conformance entries remain except fixture-specific ResetRace/StopRace are replaced once, giving17 entries and310 source-root bytes.

`check_source.py` runs actual generated C using the prior host SDK-service fixture and checks independent route/player/complete opponent/contact state for3,600 ticks. `SOURCE-RESULTS.json` records that result. Real renderer hooks and target execution are now exercised by the delivered candidate below; complete gameplay/scheduler integration remains later work.

`build.py` accepts the **actual delivered** Golem package and agreed resource configuration. It builds artwork/Fuji assets and a compact MOS invocation loop. Every native physics/render call is checked; before drawing, the guest checks completion readiness/session/request/tick, fresh root generation and interface/language success. It saves replies.log/ticks.log itself and failure.log on a guest check failure. `verify_run.py` validates/reconstructs the selected receipts and final root/arrays. Profile launches clear prior logs so a failed rerun cannot inherit success.

Build assets/guest independently:

```bash
.venv/bin/python docs/tasks/RALLY-25/native-demo/build.py --assets-only
```

Rebuild the consumed integration candidate:

```bash
.venv/bin/python docs/tasks/RALLY-25/native-demo/build.py --package /Agon/mystuff/golem/docs/tasks/GOLEM-037/binding/delivery/candidate-48eac7efe8fa51f4 --resources docs/tasks/RALLY-25/native-demo/resources-proposal.json --frames 900 --review-fast
```

`resources-proposal.json` is a Rally-local proposed driver configuration, not an implemented Golem binding schema. Output buffers start at zero so the ordinary buffered CALL consumes the helper's RETURN-terminated command lists. Root session is explicitly7; compiler-generated argument storage retains the root ID. Bootstrap uses separate untimed external streams, with u16 upload chunks/consolidation for149,518-byte contiguous assets.

`profile.py` uses the canonical setup tool and an explicit firmware/ELF/runtime in a dedicated repository-root `.emulator/` profile. `run_headless.py` runs only through the profile-local launcher, preserves failures, records runtime identities/stats and stops the process. Oryx is the human review host; no graphical instance or physical flash is launched by these tools. Actual native staging/headless qualification are complete; visual review remains with the Author.

The current old GOLEM-021 hybrid runtime gates eZ80 VSync on changes to its native-frame counter. Its MOS clock stops during static intervals: a foreground deadline wait can deadlock even after a swap. Unpaced three-repeat driver smoke completed on Oryx in8.631 host seconds including boot, while paced variants timed out. Therefore use `--unpaced` with that runtime and claim no30-Hz wall-clock cadence or FPS from its stalled clock. Golem was notified in mail thirty-five to supply a corrected/newer runtime. Four physics steps per frame remain count alignment; autonomous120/30-Hz scheduling is not implemented here.

No commit/push is authorized by the build request. Keep new emulator-related files uncommitted until the Author's visual review and explicit publication instruction.

## Independent PRT fixture timing

TRF-001-50 adapts the Author's PRT stopwatch in `prt.inc`. The driver borrows idle PRT1, installs its IRQ handler through MOS, samples an atomic24-bit counter, stops the timer and restores the previous vector before saving files. A running PRT1 is left untouched. `prt.log` holds one24-bit PRT sample per MOS timing mark; `clock.log` records reload/divider/nominal clock and vector-restoration status. Both files are created by the fixture and cleared before a rerun. A single ADL counter load needs no repeated interrupt masking.

[PRT-RESULTS.json](PRT-RESULTS.json) records a passing Oryx static-screen driver check: samples0,82,95,107,107, prior vector restored,8.686 host seconds including boot and clean shutdown. MOS samples844,852,852,854,854 show an interval with unchanged MOS time while PRT advances. This is no native Rally module/FPS or physical calibration claim. Emulator PRTs follow eZ80 instruction clocks;72×256=18,432 clock cycles per IRQ is nominal1ms at18.432MHz. Interrupt coalescing/host speed remain separate from that nominal timebase.

Recreate the bounded driver-only timing fixture without launching it:

```bash
.venv/bin/python docs/tasks/RALLY-25/native-demo/prepare_timer_check.py
```

Initial unbounded/interrupt-masked timing waits timed out; failure artifacts remain in the ignored Oryx profile history. The qualification-only PRT wait is bounded and requires observed progress before passing. This does not replace Golem's independent eZ80 VSync fix or implement the final autonomous scheduler. New guest is57,881bytes, below the script load address; frozen demo source/helper/binding maps are unchanged.

## Oryx visual review — real native candidate

On Oryx, run:

```bash
cd ~/Agon/mystuff/AgonArcade/.emulator/rally25-native-demo
./flexe-agon-emulator
```

The corrected-clock frontend/adapter, enlarged firmware and actual module are already installed and identity checked. This new Flexe profile has no Fab compatibility launcher aliases, honoring the Author's naming preference relayed in Golem twenty-two. It uses the canonical generated fallback-free launcher with its Flexe filenames substituted. Leave all candidate files uncommitted until human validation and explicit publication approval.

Expect the Fuji road moving through its curves, a centerline player, pace-matched traffic and signs. Collision predicates run without damage. The demo performs900 frames/four physics steps each, taking about31.20 nominal MOS seconds plus startup on the tested host. It then prints RALLY-25 DONE and returns to MOS. Type `dir` to check keyboard input if desired, then close the window and report the visual result. Reply/timing/PRT/clock files are generated in the profile's sdcard/rally25 directory; the agent retrieves/verifies them, so the Author need not run a verifier.

`--review-fast` uses the real generated/patched silent Tick120 wrappers and observed Render30; it retains per-frame ready/request/tick/fresh-generation checks before drawing. Full diagnostic mode additionally observes every Tick120 runtime reply and extra source/status/session fields. [NATIVE-RESULTS.json](NATIVE-RESULTS.json) records the full900-frame check at25.58 nominal FPS; [REVIEW-RESULTS.json](REVIEW-RESULTS.json) records the same world in the viewing configuration at28.85. Both pass final independent world comparison and backend controls.30Hz is the foreground deadline target; this workload overruns it. No autonomous120/30-Hz scheduler, complete game/recovery policy or physical capacity/performance claim is implied.

Consumed module code30,428/private data980/image32,964 bytes, with selected declarations32KiB/4KiB/2KiB. Native stack INFO17 remains2260 bytes minimum free before/after these runs. See DELIVERY-RECEIPT.json for exact candidate identities:26 present artifacts verify; one advertised diagnostic object rally-render.o is missing and was reported to Golem without blocking execution. The candidate snapshot was not edited. Firmware and corrected-clock frontend/adapter hashes are in the run receipts. Screenshot: [review-screen.png](review-screen.png).

Golem twenty-three supplies passing owner host/sanitizer/oracle/negative controls and an appended export receipt accounting for the omitted diagnostic object. Rally verified all32 delivered file identities against that receipt; original snapshot bytes remain unchanged. Owner controls are recorded separately from Rally actual-target runs.

Author visual review is accepted on2026-10-14. The human900-frame run passes saved-log/independent-world verification; see HUMAN-REVIEW.json. Complete background/scenery remains outside this fixture.

## Timing correction and Console8 deployment

[TIMING-CORRECTION.json](TIMING-CORRECTION.json) supersedes the earlier100Hz interpretation in saved raw receipts and historical mail/log entries. The exact MOS v3.0.2 ROM adds two units per VBlank; mode136 is nominal60Hz, hence120MOS units/s. Corrected human throughput is29.30FPS, automated viewing28.85FPS, full diagnostic25.58FPS. Raw logs/receipts remain unchanged. These are nominal emulator measurements including fixture checks/transport/drawing. The old reviewed guest's3/3/4-unit pacing pattern requested nominal36Hz; the current guest uses4units for30Hz. The hardware fixture is unpaced, so neither pacing branch affects that run.

The Console8 card now contains the unpaced900-frame/3600-tick fixture and exact firmware at `/test/arcade/rally`. See [hardware instructions](HARDWARE.md) and [deployment receipt](HARDWARE-DEPLOYMENT.json). Returned hardware logs verify900 frames/3600ticks and the independent final world: **23.45FPS** unpaced (PRT23.49). See [hardware results](HARDWARE-RESULTS.json); aggregate fixture timing includes transport/checks/drawing and swap submission.
