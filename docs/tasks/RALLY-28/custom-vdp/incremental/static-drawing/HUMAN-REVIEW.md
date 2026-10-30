# Review the retained-static drawing candidate on Oryx

The candidate improves matched emulator throughput about19% and passes two-page
proofs and exact actual scene comparisons. The Author's moving visual review
remains the final appearance gate. This is the finite deterministic fixture,
not the full playable game. The instance is prepared and stopped; sound is
forced off by its launcher.

Run these commands in a desktop terminal on **Oryx Linux Lite**:

```bash
cd /home/smith/Agon/mystuff/AgonArcade/.emulator/rally28-hz60-staticreview01-static
SDL_VIDEODRIVER=x11 ./flexe-agon-emulator
```

1. Allow asset loading, then watch900 moving frames (roughly20–25seconds of
   racing after startup on this host). Traffic approaches/recedes through its
   existing scale pattern. The two title lines should remain stable on both
   pages; the sky above the horizon and the lower strip should remain clean.
2. Check the horizon for stale car pixels/trails as cars change size and pass.
   Rows100–103 are still cleared each frame; rows24–99 are retained.
3. At completion, verify a normal single-buffered MOS screen, full text viewport,
   visible cursor and `RALLY-25 DONE: logs saved.` followed by the prompt. Close
   the emulator window afterward so diagnostics finish flushing.

No physical SD card or firmware was changed. Human timing is separate from the
guarded headless measurements; it must not be pooled into that matched result.
`PROFILES-staticreview01.json` pins the exact inputs. Automated runs already
verified900frames/3,600ticks/2,913 retained replies and full cleanup on the same
candidate bytes. New implementation/evidence remains uncommitted for review.
