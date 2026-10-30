# Isolated affine costs for Rally artwork

**Framerate reporting correction, 2026-10-30:** cached-bitmap versus cached-affine
complete-race FPS has not been measured. The isolated host draw ratio does not
establish a game FPS gain. [Framerate status and prior full-race reference](ORYX-RESULTS.md#framerate--the-primary-result) now lead the results before the microbenchmarks.
Future comparisons must report completed frames/elapsed time/FPS and change
versus the same complete-race control first.

Measure what applying the stock affine commands to Rally's actual bitmaps costs,
separately from running the game. Compare matrix setup/inverse caching, direct
transformed plotting and transform-to-bitmap followed by ordinary plotting.
Use real traffic/sign sizes and explicit player-mirror coverage. These checks
must explain our usage before attributing a general cost to the stock API.

**Pi results preserved:** [results](RESULTS.md) and independent host/target audits are ready.
The host checks pass 640 timing samples; stock-VDP execution passes all 124
longer batches. The Pi emulator's clock domains disagree, so calibrated target
milliseconds remain open. [Exact matrix reuse analysis](MATRIX-REUSE.md) finds
64.29% repeated baseline rebuilds, with no game/FPS gain claimed. All emulators
are stopped. [Completed scope and attempt history](../../../../2026-10-29-rally-affine-offline.md).

The Author released this investigation on2026-10-29, then restricted all work
to the Pi5 because Oryx is shutting down. Local Flexe checks are authorized, with
both SDL video and audio dummy. No Oryx access, physical operation, production
change, firmware modification, commit or push is part of this tranche.

**Oryx continuation:** the Author subsequently says “ok you can do the
same tests on oryx now.” That explicitly supersedes the earlier Pi-only/no-Oryx
restriction for identical host/Flexe tests. Keep the Pi evidence frozen, transfer
the same guest/asset/config/stock-firmware bytes, and use the original Oryx guard.
Build the host runtime from the same recorded source for its architecture; do
not infer byte equality between ARM and x86 executables. No commit/push.

The Oryx runs have returned: all124 full batches/497 required replies and640
host samples pass, with the same110240-byte application stream and identical
source/artwork/pixels. [Oryx results](ORYX-RESULTS.md) keep host timings and raw
PRT/MOS counts separate. Both emulator clocks still disagree; physical rendering
milliseconds remain open. Both SDL drivers were dummy, maximum temperature62°C,
boost restored1 and all emulators stopped. Oryx is free. [Run instructions](ORYX-RUNS.md).

Root `TODO.md` owns the work under INC-001-02-AFF01. This is the released scope,
not an independent task register:

1. **AFF01-01:** identify the exact stock source and actual command route,
   including matrix rebuilds, inverse reuse, pixel formats, clipping, alpha and
   drawing completion. Preserve extraction hashes and source/version differences.
2. **AFF01-02:** recover original car/sign artwork and observed affine commands
   from the frozen deterministic race replay. Separate real workload from
   synthetic size/reflection/alpha/clipping coverage.
3. **AFF01-03:** compile faithful stock-function host checks and compare costs
   using repeated timed batches. Prepare a standalone target-command fixture
   with self-created result files and completion fencing; attempt silent Pi5
   Flexe qualification. Preserve failures and keep host timings, emulated target
   timings and any later physical timings distinct.
4. **AFF01-04:** report measured setup/draw costs and limits, preserve exact
   inputs and a reproducible test. Existing accepted full-race and historical
   controls remain unchanged. No optimization adoption follows automatically.

Host compilation executes the extracted code on the Pi5 CPU. Those elapsed
times are useful for checking algorithm behavior and relative host costs; they
are not ESP32 cycle counts or physical VDP timings. A Pi5 Flexe run is a separate
measurement and may run slower in host wall time than the previous Oryx runs.
No fixture should hide UART/backpressure or completion cost in a claimed game
speedup. Resident command batches will isolate drawing from repeated byte
transfer; setup/loading and the final rendering fence remain explicit.

## Reproduce on Pi5

Use fresh run/profile names so previous results remain preserved. Host timings
are CPU microseconds; the standalone target stores raw MOS/PRT counts separately.

```bash
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/affine-offline/host_run.py --name pinew
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/affine-offline/target_control.py stage full-new --fixture full
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/affine-offline/target_control.py run full-new --timeout 900
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/affine-offline/target_verify.py --profile /Agon/mystuff/AgonArcade/.emulator/rally28-affine-pi-full-new --fixture full --evidence /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/affine-offline/evidence/full-new/runtime
```

`runtime_build.py` creates the private ARM64 runtime from recorded source
commits if that generated workspace is absent. It needs local source objects,
the existing compiler/SDL/Cargo dependencies and no network fetch. The recorded
build relaxes one GCC truncation warning from error to warning, without changing
emulator source; its first failed build log remains preserved. Runtime binaries
and generated build trees stay private under `.work/` and profiles.

The target fixtures contain `probe.bin`, `artwork.vdu`, `config.bin`, `run.txt`
and `expected.json`. They use **official stock VDP 2.16.0**, with no Golem module
or custom firmware. Loading/asset setup, warm operations and marker readback are
outside the repeated timed bodies. The page stays hidden during timing; this
is a data-producing diagnostic, not a visual race review or playable game.
