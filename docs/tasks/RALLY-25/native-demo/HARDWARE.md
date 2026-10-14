# Console8 hardware run

Deployed to `/test/arcade/rally` on the Console8 SD mounted on Oryx. Firmware `vdp_rally.bin` is alongside the fixture; the Author handles flashing. [Deployment receipt](HARDWARE-DEPLOYMENT.json) records the exact files and firmware hash.

After flashing, from MOS:

```text
cd /test/arcade/rally
load probe.bin
run .
```

The fixture loads its own assets/module, then runs900 rendered frames and3600 physics steps unpaced. Expect moving Fuji road, centerline player, traffic/signs, flat background and collision checks without damage. The returned run took38.38seconds in the measured loop (23.45FPS); startup precedes it.

Success prints `RALLY-25 DONE: logs saved.` and returns to MOS. Failure may print `VDPLET proof failed`, save `failure.log`, hang or crash. Retain the files either way. The fixture creates `replies.log`, `ticks.log`, `prt.log` and `clock.log`; another run overwrites them. Return the card to Oryx after this run for retrieval/verification and physical FPS calculation.

MOS timing is nominal120units/s in this60Hz mode; PRT timing is recorded separately with nominal1ms reload72/divider256 at18.432MHz. Physical results are recorded below; external timer calibration remains pending. This is a renderer/simulation fixture; autonomous120/30Hz scheduling remains later work.

## Returned run verified

Console8 hardware qualification passes:900 frame requests/3600 physics ticks and2913 saved reply records; final source globals/all five mutable arrays match the independent reference. Unpaced aggregate fixture throughput is **23.45FPS**,4606MOS units at nominal120units/s =38.3833s, mean42.65ms/frame. PRT1 independently records38313nominal1ms ticks =38.313s/**23.49FPS**, agreeing within0.19%; previous vector restored. Stack INFO17 remains2260before/after; StopRace/UNLOAD succeed. Supplied firmware is8da2ebf...; fixture does not read back the flashed image. See [HARDWARE-RESULTS.json](HARDWARE-RESULTS.json) and evidence/hardware-*.

The timing window excludes boot/assets/init, final-state reads and log saving. It includes finite physics, renderer preparation, UART/readback checks, draw commands and swap submission; there is no separate VDP completion timestamp. Of900MOS frame intervals,394 are4units (~33.3ms),505 are6units (~50ms), and the initial interval is0. This indicates VBlank-quantized fixture cadence, without isolating its bottleneck. No autonomous120/30Hz scheduler is present; nominal clocks remain externally uncalibrated. Card contents/logs were left untouched after retrieval.

The same returned-card bytes now also pass headless Flexe on Oryx at29.02FPS. See [matched comparison](IDENTICAL-COMPARISON.md); no further physical run was necessary.
