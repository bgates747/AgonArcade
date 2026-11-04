# Console8 return01 — 2026-11-04

The Author-run complete-race candidate achieves **24.68 FPS by MOS** and
**24.73 FPS by PRT**. The 900-frame measured interval is36.467/36.396seconds,
respectively; durations agree within0.194%. Mean PRT frame time is40.44ms.
These are completed fixture-frame rates on physical Console8 with nominal
clock conversions, not an external optical scanout measurement.

All900frames/3,600logical physics steps complete. The unchanged existing
HUD verifier passes the independent final root/array state, player state,
all2,024native reply identities/values, every frame's completion and post-swap
generation fence, timer restoration, native unload and clean text-mode exit.
There is no failure.txt. This establishes program-reported clean teardown;
no independent CLI capture or human visual acceptance was supplied yet.

| Measured component | Total seconds | Mean ms/frame |
| --- | ---: | ---: |
| Player/rules and native tick submission |1.869|2.077|
| Presentation CPU estimate |5.757|6.397|
| Synchronous command submission |2.672|2.969|
| Reply waits |25.130|27.922|
| Complete measured loop |36.396|40.440|

These rows are not an exclusive additive partition. The player/tick bucket
includes its send calls; the presentation estimate subtracts its measured I/O.
Reply waits occupy69.05% of measured loop time but combine transport, native
work, queued drawing and swap/presentation ordering. They do not isolate pure
VDP rendering. The workload sends291,568timed outbound bytes,323.96/frame.

The coupled four-steps-per-render fixture therefore advances98.91logical
steps per wall second by PRT. This is not an independently scheduled120Hz
physics test or a measurement of flat-out isolated physics capacity.

The card is AGONC8 UUID8658-1C23. The original long deployment directory was
found renamed to `/test/arcade/rally-28`. All12supplied files match the
deployment manifest. All20returned card files were copied and individually
matched against fresh remote hashes. Retrieval changed no card files, firmware,
startup or settings. Filesystem dates are not used as timing evidence.

The supplied VDP firmware remains8da2ebfd…; no physical flash readback or MOS
identity was captured by this fixture. File identity is not installed-firmware
proof. The generic verifier's emulation-oriented `clock_limit` wording is
preserved in its output; REPORT.json explicitly supplies this cohort's physical
platform and nominal clock limits instead of altering that shared verifier.

This is the hardware baseline for subsequent discussion. It is not a matched
HUD-cache speedup comparison or an async-UART result. The near-agreement of the
physical clocks contrasts with the earlier maintained086emulator's uncalibrated
60.00MOS/36.15PRTFPS; do not use that emulator's MOS60as hardware performance.

Evidence: [report](REPORT.json), [source hashes](REMOTE-SHA256SUMS),
[original guest results](card/result.json), [existing verifier output](card/verified.json).
