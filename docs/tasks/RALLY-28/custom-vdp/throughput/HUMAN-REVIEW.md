# Native bitmap road — Author motion review

The strongest tested candidate is staged and **stopped** on Oryx. From a graphical terminal on the Oryx laptop:

```bash
cd /home/smith/Agon/mystuff/AgonArcade/.emulator/rally28-hz60-hzview01-native-span-native-fenced-unpaced
./flexe-agon-emulator
```

Sound is forced off. The misleading/flashing startup status line is blanked with equal-length spaces in this review copy. This changes only artwork and its metadata/hash; the tested Native-format fenced-unpaced script, driver, module, assets and firmware are otherwise identical. [Exact profile inputs](PROFILES-hzview01.json).

1. The test drives Fuji automatically for 900 rendered frames / 3,600 physics steps, then finishes. Expect road, traffic, player, signs and finish presentation. The flat background is intentional. Review motion and obvious drawing errors; this is a finite renderer fixture, not a playable game.
2. The two matching headless runs measured 26.05 and 25.78 nominal MOS FPS with boost disabled. This stopped human launcher permits the current host boost setting, so visible-run speed need not reproduce that pair. Its returned logs will be analyzed separately.
3. After it finishes, close the emulator. Self-created timing/reply logs remain under sdcard/rally25/; the Author's review is the visual gate. All automated runs remain silent and headless.

Hardware has not been deployed. After motion review, an identical-byte quad-control/Native-candidate hardware comparison is the next performance gate. The required custom firmware is unchanged and is included in the portable archives; no new VDP build is needed.
