# Final RALLY-19 experiment on Oryx Flexe

The exact final RALLY-19 Golem buffered-command production build is staged for Author play on Fuji with stock VDP2.16.0and sound disabled. This is still a driving prototype; the complete title/qualify/race game starts with RALLY-22. Recorded physical R19 performance was slow. No corner-defect fix or current Flexe gameplay/FPS acceptance is asserted from staging.

Close the RALLY-18 window, then run in an Oryx desktop terminal:

```bash
cd /home/smith/Agon/mystuff/AgonArcade/.emulator/rally19-flexe-review01
./flexe-agon-emulator
```

Fuji demo starts automatically; a key takes over, arrows drive and Escape exits. This is the actual final hardware-inline Golem experiment, not its post-experiment pre-Golem rollback or a native Xtensa VDPlet. Both tracks' exact `.vdp` programs and `.clr` cleanup files are included.

[Input provenance](FLEXE-INPUTS.json) verifies all five files against the preserved final delivery in the separate rally19worktree. The95,822byte binary is64c8b073…; matching Fuji bootstrapb3e6bf3e…and cleanup999170b2…are unchanged. [Staging receipt](FLEXE-REVIEW.json) pins all runtime/MOS/firmware/input files. Stock imageb807beef…is used; no diagnostic or physical firmware change. No rebuild or owner/source edit occurred.

Preparation calls the canonical Flexe naming helper and preserves existing backend/MOS/runtime checksum guards and dummy audio. Input and shell-syntax checks pass, profile stopped. No emulator was launched for this preparation; current Flexe rendering/controls require the Author's review. The R18 lower-left rendering defect is recorded as the Author's observation, not assumed to be fixed in R19. Both profiles and physical/card evidence remain preserved; new staging code/docs uncommitted.

Author reports R19runs worse than R18underFlexe and requests Console8 deployment. [C8 receipt](C8-DEPLOYMENT.json): ten files deployed/readback verified at `/test/rally-19`, UUID8658-1C23; all five game artifacts match final delivery. Required stock VDP2.16.0included asvdp_rally.bin, identical to the R18folder copy. Startup unchanged, writes flushed; no flash/invocation. Fuji launch: `EXEC /test/rally-19/run-fuji.txt`. Physical review pending.
