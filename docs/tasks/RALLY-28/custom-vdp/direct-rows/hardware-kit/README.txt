RALLY-28: bitmap versus direct-row road rendering

LOCAL PREPARATION ONLY: not deployed or flashed.
Copy this folder to /test/arcade/rally28-rows01 on the C8 card.
Do not change autoexec.txt.

Both cases REQUIRE the included custom vdp_rally.bin.
This is a different VDP image from the earlier rally-28 fixture.
Flash it by your normal procedure; no MOS flash is requested.
The existing MOS must support standard MOS3 mode-flag APIs.

Run bitmap control first at MOS:
cd /test/arcade/rally28-rows01/bitmap
load probe.bin
run .

Then the direct-row candidate:
cd /test/arcade/rally28-rows01/rows
load probe.bin
run .

Each runs 900 deterministic frames / 3600 logical physics steps,
returns to MOS and creates its own result/clock/state files.
Engine audio is enabled on hardware. Watch the complete race:
road, finish line, traffic/player, scrolling sky and HUD/footer.
Report visual results to Rally and return the card for analysis.
Rerunning a case overwrites its own result files.
Do not mix logs between the two case directories.

Emulator source-clock estimate: bitmap36.28, rows39.16FPS.
This is not a hardware speed claim; physical comparison is next.
UART stays synchronous; physics/render scheduling is unchanged.
Runtime/SDK owner: VDPlet 2026-11-04.
