# Preserved RALLY-18 under Flexe on Oryx

The exact historical unfenced RALLY-18 review binary is staged in a fresh Oryx Flexe profile, with stock VDP2.16.0and Fuji selected. No rebuilding or gameplay alteration occurred. A separate automated startup check reached play-ready after10.63seconds with both SDL dummy drivers and stopped after five further seconds; it does not qualify frame rate, controls or the Author's visual review.

On an **Oryx desktop terminal**:

```bash
cd /home/smith/Agon/mystuff/AgonArcade/.emulator/rally18-flexe-review01
./flexe-agon-emulator
```

Sound is disabled by the guarded launcher. Allow roughly10–15seconds for startup. Fuji attract driving starts automatically; press a key to take over, arrow keys drive, minus/equal adjust grip, and Escape exits. Original four-tick presentation pacing remains, with no per-frame fence/profiling option. This is the historical playable driving prototype with scenery/traffic, not RALLY-22's full qualifying/race flow.

[Identity/startup receipt](FLEXE-REVIEW.json) pins the142,838byte binary20622e05…matching the historical review manifest and recovered source d12445e9…at `/Agon/mystuff/rally-mac-build.Hue3QQ`. The embedded artwork remains in the binary; exact original Fuji/oval road files accompany it. Official stock VDP imageb807beef…is used, not the newly flashed physical diagnostic. Flexe frontend7e78e991…/adapter108ec5b0…and official MOS3.0.2are inherited from the qualified canonical template and checksum guarded.

The review profile is fresh and stopped, without startup markers/results from the smoke run. [prepare_flexe_review.py](prepare_flexe_review.py) clones only new owned profiles, calls the canonical Flexe naming helper, retains backend/MOS/runtime guards and refuses used names. Its `--smoke` mode forces both dummy SDL drivers, monitors boost disabled and stops only its own process group. Physical startup/SD/firmware and previous games/profiles/evidence remain untouched. No graphical/audio session was launched by the agent. New recovery tooling/notes are uncommitted pending review/publication instruction.

Author subsequently reports a lower-left rendering defect under Flexe and requests Console8 comparison. [C8 receipt](C8-DEPLOYMENT.json): eight files deployed/readback verified at `/test/rally-18`, UUID8658-1C23; original binary/both road files, stock VDP2.16.0asvdp_rally.bin, commands/readme/manifest. Firmware matches the copy in `/test/rally-19` exactly. Startup and all R19files preserved, writes flushed; no flash/invocation. Fuji launch: `EXEC /test/rally-18/run-fuji.txt`. Physical review pending.
