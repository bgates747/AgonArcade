RALLY-28 OLIMEX ROAD/PHYSICS TESTS

Ten frozen finite cases. Mainboard Legacy rendering, mode 8 (320x240).
Requires the supplied NON-STOCK diagnostic VDP for fenced live timing.
Image: vdp_rally_benchmark.bin
VDP SHA256: 36edc736c992502367489c8ccea677d7aebb11d20371cd58cb0b91ef61df9f99
Install/verify that image separately from the Pi before live tests.
No VDP/MOS/P4 firmware was flashed by SD deployment. Existing EMOS retained.
autoexec.txt was not edited. Reset does not invoke this suite.

MANUAL INVOCATION (positive visible MOS CLI required):
EMOS LEGACY --keep-display
VDU 22 8
Wait at least one whole second after the monitor has switched, then:
EXEC /test/arcade/rally/r28-road/suite.txt

The master command file explicitly invokes each independently reusable case.
It is a simple MOS command chain, NOT the Pi coordinator's result-gated chain.
A stalled program blocks this chain. There is no automatic reset/retry/resume.
If execution fails or the prompt is not responsive, stop and preserve evidence.
Do not apply the interactive emulator's five-minute timeout as a hardware reset.
Each appliance restores its single-buffered entry mode; double-buffer entry
is refused. Manual mode preselection means mode 8 is that entry mode.

First five cases: physics and CPU preparation; no animated road is expected.
Sixth: empty timing control. Last four: road drawing on deterministic Fuji poses.
Each CPU case: 1024 frames. Drawing cases: 128 frames. Empty: 32 frames.
Physics: 8192 actual numerical ticks/four scenarios, independently checkable.
Previous emulation suggests roughly 20-45 seconds per CPU/physics workload;
physical elapsed times remain unqualified. Live Flexe cases stalled, so no
reliable physical whole-suite duration or timeout is claimed.

Results are CREATE-NEW in each case directory: summary.txt, frames.csv, done.txt;
physics additionally state.csv, phases.csv, lifecycle.txt, physics-done.txt.
PASS requires complete planned counts, restored state and no failure in the
saved summary plus independent verification after retrieval. A done file alone
does not establish a pass. Terminal results identify the running candidate.
Do not rerun into old outputs. Preserve/collect them, then redeploy fresh cases.

INDIVIDUAL CASES (same explicit mode preselection/settling):
EXEC /test/arcade/rally/r28-road/physics.txt
EXEC /test/arcade/rally/r28-road/polygons-cpu.txt
EXEC /test/arcade/rally/r28-road/bitmap-arithmetic-cpu.txt
EXEC /test/arcade/rally/r28-road/bitmap-lookup-cpu.txt
EXEC /test/arcade/rally/r28-road/polygons-sparse-cpu.txt
EXEC /test/arcade/rally/r28-road/empty-live.txt
EXEC /test/arcade/rally/r28-road/polygons-sparse-live.txt
EXEC /test/arcade/rally/r28-road/polygons-live.txt
EXEC /test/arcade/rally/r28-road/bitmap-arithmetic-live.txt
EXEC /test/arcade/rally/r28-road/bitmap-lookup-live.txt

This directory contains all binaries, configuration, Fuji coefficient data,
individual MOS commands, master commands and the exact diagnostic VDP image.
No game assets, startup modifications, physical runner or MOS upgrade required
by this package. The Pi live coordinator remains unqualified/not ready.
