RALLY-28 native-owned state matched hardware comparison

All nine silent Oryx cases passed exact state/wire/completion/cleanup checks.
Emulator clocks are uncalibrated; Console8 and Author visual truth remain open.
Primary new candidate for comparison: coarse. No emulator FPS gain was found.
Three complete900-frame/3600-step/two-warm fixtures. Same full race, assets,
traffic overrides, geometry, sky/HUD/audio and final state. Baseline is the
ROW-001 direct-row fixture. State changes native ownership with the old guest.
Coarse also replaces four interpreted Tick CALLs with one direct native call.

All three require the supplied identical custom vdp_rally.bin (a50...).
It is the same firmware as ROW-001's paired kit. No MOS replacement requested.
No hardware has been flashed and no card has been written by this preparation.
Suggested card root: /test/arcade/rally28-native01

For each directory baseline, state and coarse:
 cd /test/arcade/rally28-native01/baseline
 load probe.bin
 run .

Use the corresponding directory name for state/coarse. Wait for RALLY-28 FULL
RACE DONE and return to MOS. Each fixture writes its own result.json, state.bin,
player.csv, stages.csv, replies.bin, ticks.bin, prt.bin. Failure writes failure.txt.
Return the card/results after all runs. Sound is enabled on hardware. Judge the
complete moving race, including road/traffic/signs/player/sky/HUD/footer.
Do not edit autoexec.txt. Keep existing fixture/results directories intact.
