# Moving review of the HUD string cache

**Not cleared for human launch:** the first unchanged-control smoke stalled in
original artwork setup; the cached candidate has not run. Preserve this stopped
profile until a new bounded target qualification and review checkout are ready.
See [RESULTS.md](RESULTS.md).

The candidate preserves the full race scene and changes when strings are
formatted. Automated checks and timing are separate from the Author's moving
visual acceptance. The profile is staged **stopped**, sound disabled. Do not
launch until Rally has reserved/checked out Oryx as review custodian and announced
readiness under the current shared FIFO policy.

On Oryx, after that checkout:

```sh
cd /home/smith/Agon/mystuff/AgonArcade/.emulator/rally28-hz60-hudreview01-cached
./flexe-agon-emulator
```

1. Allow the original asset startup. Confirm the complete road/panorama/traffic/
   signs/player, HUD and footer appear.
2. Watch speed, lap clock, countdown, score and rank update without flicker or
   stale values on alternating display pages. The footer must remain visible.
3. The finite900-frame run returns to a clean MOS prompt. It is a deterministic
   race fixture, not manual play. Close the emulator and tell Rally so it can
   retrieve evidence, inspect/release the checkout and steer the next agent.

Never reuse timed benchmark profiles for visual inspection. A review creates
its own result files and is excluded from the comparison. No firmware flashing
or physical hardware change is involved.
