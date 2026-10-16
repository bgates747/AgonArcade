# RALLY-25 native demo — fresh Oryx review, 2026-10-16

The visually accepted native Fuji fixture is copied into a fresh Oryx Flexe profile. All15immutable game/runtime/firmware/data inputs match the preserved accepted profile byte-for-byte. Only the generated launcher changes: audio is forced dummy and CPU boost must remain disabled. Old human logs and the original profile are untouched; this fresh instance contains no inherited result files.

On the Oryx desktop, close other Rally emulator windows and run:

```bash
cd /home/smith/Agon/mystuff/AgonArcade/.emulator/rally25-native-review01
./flexe-agon-emulator
```

This uses the actual custom native-Xtensa VDPlet firmware8da2ebf…with its original corrected-clock Flexe runtime, not stock VDP or R19buffered Golem rendering. Expect Fuji road, centerline scripted player, moving traffic and signs, and intentionally flat background. The fixture renders900frames/3600physics ticks, saves its logs, prints RALLY-25 DONE and returns to MOS. It is not a complete keyboard-playable game.

[Staging identity](RESTAGED-REVIEW.json) preserves both source/new checksums; [restage_review.py](restage_review.py) checks the accepted source before copying, materializes runtime links, uses the canonical Flexe naming helper and verifies all immutable copies/launcher syntax. No emulator was launched for this preparation, no firmware was flashed, and the SD cards/other profiles remain unchanged. Prior accepted visual/runtime checks remain historical evidence; new launch behavior awaits Author review. New tooling/notes uncommitted.

The Author's latest run was subsequently [retrieved and verified](RESTAGED-RUN-RESULTS.md):900frames/3600ticks/all2913replies and exact qualified final state pass, but nominal MOS rate14.37FPSis below the old29.30FPS. Input pins unchanged; slowdown cause unproven. Current post-run boost1is recorded without attributing the result to it. No rerun or host-setting change occurred.

The Author confirms boost was disabled during that measured run and intentionally reenabled afterward. The added silent boost-off launch guard then blocked human startup. [Launcher correction](LAUNCHER-FIX.json) removes it from this human review profile, retains forced dummy audio/all other identity guards, and updates the wrapper checksum. All immutable inputs and existing guest logs remain unchanged; no launch or power-setting change was performed. The automated headless helper checks boost before changing logs and reports a descriptive refusal. Future launch guards must report their rejection reason/correction to stderr, never silently exit.
