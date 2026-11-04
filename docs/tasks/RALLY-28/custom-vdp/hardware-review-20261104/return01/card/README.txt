Rally-28 compact renderer + cached HUD hardware review

Requires included custom vdp_rally.bin (not stock VDP).
Flash that firmware before running; copying does not flash it.

At the MOS prompt:
cd /test/arcade/rally28-hud-review-20261104
load probe.bin
run .

Finite deterministic 900-frame race; 3600 logical physics steps.
Watch traffic scaling, road, scrolling background, player and HUD.
Engine audio is enabled on hardware. Returns to MOS and saves logs.
Report visual results to Rally; runtime/SDK owner: VDPlet 2026-11-04.
Preserve generated files for retrieval; rerunning overwrites them.
If startup hangs, report what appeared and reset the machine.
No autoexec.txt changes. No hardware FPS claim before results.
