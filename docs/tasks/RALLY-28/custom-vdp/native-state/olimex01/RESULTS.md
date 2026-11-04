# Olimex matched native-state results

All six exact fixtures passed guest validation. **All three variants sustain30.00MOSFPS /30.058nominalPRTFPS; no FPS gain is observed from the native-state/coarse-call rewrite.** The exact original native firmware is restored and generation25 released10:10:14EST2026-11-04, before this analysis. ActualnextWolf andExtender immediately notified.

| Arm | MOS FPS | PRT FPS | PRT ms/frame | PRT FPS vs baseline |
|---|---:|---:|---:|---:|
| baseline | 30.00 | 30.06 | 33.269 | +0.00% |
| state | 30.00 | 30.06 | 33.269 | +0.00% |
| coarse | 30.00 | 30.06 | 33.269 | +0.00% |

MOS120 units/sec and PRT1000 units/sec nominal. On-device counters; agreement is reported, no scanout/optical/calibration claim. Do not pool with Oryx or Console8.

Full race 900 rendered frames,3600 logical steps,two warm frames; fixed four physics steps/render comparison, not independent real-time scheduler. Printer mirror instrumentation enabled.

Sound remains enabled and unassessed. Counters do not grant human visual acceptance.

| Case | MOS seconds | PRT seconds | MOS FPS | PRT FPS |
|---|---:|---:|---:|---:|
| baseline1 | 30.000 | 29.942 | 30.00 | 30.06 |
| state1 | 30.000 | 29.942 | 30.00 | 30.06 |
| coarse1 | 30.000 | 29.942 | 30.00 | 30.06 |
| coarse2 | 30.000 | 29.942 | 30.00 | 30.06 |
| state2 | 30.000 | 29.942 | 30.00 | 30.06 |
| baseline2 | 30.000 | 29.942 | 30.00 | 30.06 |

## Same-byte Flexe comparison

| Variant | Olimex MOS FPS | Olimex nominal PRT FPS | Flexe nominal PRT FPS | Nominal Flexe PRT excess |
|---|---:|---:|---:|---:|
| baseline | 30.00 | 30.06 | 39.52 | +31.5% |
| state | 30.00 | 30.06 | 38.59 | +28.4% |
| coarse | 30.00 | 30.06 | 38.73 | +28.9% |

Exact application/module/config/assets/a50 native firmware; physical Eirene EMOS differs from emulator MOS and hardware printer mirror is enabled. Emulator PRT is not calibrated wall time and MOS disagrees there. Nominal FPS contrast, not a calibrated emulator speed ratio or pure renderer cost. Hardware clocks differ in duration by only0.1933%; Flexe reports60MOSFPS for every case despite lowerPRTFPS. Physical scanout/headroom/native-stage attribution are not measured here. Both reverse repeats retain exactly the same aggregate hardware clocks; no repeat discarded.

## Restoration and evidence

Original4MiB flash17caa5b0... independently restored exactly; native application8ade1e7d... at0x150000, Eirene/P4/startup/listener retained. Fresh native mode SAVE/GET matches entry0, CLI/listener/read/EXIT, entry cwd/text/cursor commands, neutral/offline idle and bothports free verified. See evidence/restore/verified.json, evidence/handback/observation.json and RELEASE.json. No optical/audio qualification is implied.

Original shared verifier has an inherited emulator wording in its clock_limit field; REPORT.json explicitly supplies the physical context and retains all raw counts. Entry/staging have wallclock journals; backup/install/run/retrieval/restore/handback have explicit monotonic action durations under timings/. Setup and teardown are outside the guest measured race. Hardware frame-time distributions are retained in each ticks.bin/prt.bin rather than inferred from process duration. Existing stages.csv buckets overlap; no exclusive attribution claimed.

- NAT-HW-001-01 [x] — Actual generation25 grant and compatibility reconciliation.
- NAT-HW-001-02 [x] — Six fresh directories exact fullfile readbacks.
- NAT-HW-001-03 [x] — Exactlysix selected cases, each900/3600/warm2, all checks pass/no replay.
- NAT-HW-001-04 [x] — Results retrieved, exact incoming restoration/handback and centralrelease; nextagent notified.
- NAT-HW-001-05 [x] — Hardware/Flexe comparison recorded, timing guidance unchanged.
