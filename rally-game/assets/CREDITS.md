# Asset sources and community billboards

The Author requested promotional signs for their games, Agon, Agon Jukebox
and Agon Extender, plus other community developers. Signs are single 64×64
bitmaps with their posts included; runtime rendering only applies uniform
distance scaling. No perspective transform or reference-video art is used.

1. **Aginvadors:** original sprite patterns from the Author's Aginvadors
   `pygame/pynvaders/art.py`. Pattern copies and hashes are retained in
   `signs/source/ships.json` and `signs/sources.json`. Source project:
   https://github.com/bgates747/Aginvadors .
2. **Agon Defender:** original ship from this repository's
   `defender/tools/generate_assets.py`, extracted without executing the generator
   or modifying the frozen game.
3. **Purple Nurples:** the Author's existing transparent splash logo,
   `assets/img/orig/ui/splash_logo.png` in their Nurples project. The source
   project uses the Unlicense; this reuse is also expressly Author-requested.
4. **Agon Jukebox / Agon:** the existing `src/images/logo.rgba2` bitmap from
   AgonJukebox, 80×120 RGBA2222, at commit
   `0a09cee58327ecded770d835d3f7c7ac503980de`. The project uses the Unlicense.
   Jukebox has its own labelled billboard; the same existing Agon mark appears
   on a separate Agon sign.
5. **Agon Extender:** the central mascot from the Author-owned public
   `social-preview.png` at commit `c78807b4c9b2685dc0df8917150372bd8685df9c`:
   https://github.com/bgates747/agon-extender/blob/c78807b4c9b2685dc0df8917150372bd8685df9c/social-preview.png .
   Original image, crop coordinates and hashes are retained locally with the
   generator inputs. This did not require merging Extender's remote changes.
6. **Richard Turnnidge / Starship Sentinel:** an original text tribute plate.
   https://github.com/richardturnnidge/starship_sentinel contains screenshots and
   the game binary, but no explicit permission to reuse its artwork was found.
   Actual game art remains pending permission; no third-party screenshot pixels
   are embedded in this candidate.
7. **Christian Pinder (Xian):** an original text tribute plate for his Agon
   projects, https://github.com/xianpinder . Individual ports can have different
   original artists: Foggy's Quest credits John Blythe as its creator, for
   example. Do not attribute a port's original art to its porter or copy it
   without resolving the actual permissions.

The UI font (`font.json`), lettering, sign layouts and crash bursts are original
work for this game. Existing car/scenery/track editable sources remain in the
parent `rally/assets/` and `rally/tools/`; the accepted generated runtime inputs
are reused from `rally-production/include/` and its road files. Regenerating
those older sources is not part of the new sign/font generator.

Project names, marks and other rights remain with their respective holders.
These community shoutouts do not claim third-party authorship or endorsement.
Reference Pole Position video/storyboards/manual images stay in ignored research
storage and are absent from runtime assets and source packages.
