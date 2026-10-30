# Review the complete racing view on Oryx

These stopped profiles use the exact comparison inputs. The screen shows the
actual racing panorama and HUD/footer rather than the old diagnostic title and
flat sky. Sound is forced off. The Author's moving visual review is the final
appearance gate; automated captures do not replace it.

Run in a desktop terminal **locally on Oryx Linux Lite**:

```bash
cd /home/smith/Agon/mystuff/AgonArcade/.emulator/rally28-hz60-racereview01-static
SDL_VIDEODRIVER=x11 ./flexe-agon-emulator
```

1. Allow asset loading, then watch 900 deterministic moving race frames. Check
   panorama scrolling, horizon repair, approaching/receding traffic, roadside
   signs, player and finish markings, plus the changing race HUD and footer.
   The fixture retains the agreed centerline/no-damage policy; it is not manual
   play. There is no diagnostic title or development overlay.
2. At completion, verify mode 8, full text viewport and cursor, then
   `RALLY-28 FULL RACE DONE: logs saved.` and the MOS prompt. Close the window
   afterward so backend diagnostics finish flushing.
3. To see the original renderer with the same race sequence, close the other
   instance and run:

```bash
cd /home/smith/Agon/mystuff/AgonArcade/.emulator/rally28-hz60-racereview01-baseline
SDL_VIDEODRIVER=x11 ./flexe-agon-emulator
```

4. The separate drawing-coverage profile runs 60 normal race frames followed by
   the maintained explosion and recovery blink. Its camera/physics are frozen
   during the effect and it is excluded from renderer timing:

```bash
cd /home/smith/Agon/mystuff/AgonArcade/.emulator/rally28-hz60-raceeffectsreview01-coverage60
SDL_VIDEODRIVER=x11 ./flexe-agon-emulator
```

The corrected `static` case has exactly the additive renderer's executable
inputs: production panorama/HUD retention is common to every new case. It does
not carry a separate static-drawing speedup. `PROFILES-racereview01.json` and
`PROFILES-raceeffectsreview01.json` pin these instances. Human timing is separate
from the guarded headless comparisons. No physical card or firmware was changed;
new work remains uncommitted pending review and publication approval.
