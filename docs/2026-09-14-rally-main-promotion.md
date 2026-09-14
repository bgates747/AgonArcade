# Current Rally promoted to main

The Author authorized putting the latest eZ80-based full game on main and
ending rally19-golem at its experimental closeout. Eight post-closeout commits
from 4731f57 through cc88f6a were cherry-picked onto remote main 7313ecc.
Remote main's six previously absent commits are retained. Golem implementation
and bulk experiment evidence are not imported into main.

The full-game, production and bench source directories match the old tip exactly
before documentation clarification. The normal full-game build reproduces the
hardware-tested 171072-byte binary, SHA256
3ac79285f327bbb0bfe6a56cae7b839f124486a0fbd253647278b8bfa5a40434.
All rally-game host tests pass. This is build verification, not fresh human
emulator acceptance. No gameplay, balancing, firmware or hardware change.

Current entry point: rally-game/README.md and make -C rally-game.
Its existing dependency on rally-production/include remains explicit; no
unnecessary source relocation changes the accepted build. The old rally/
prototype and production rollback are preserved.

The original tip cc88f6a is preserved by archive/rally-before-main-promotion.
The rally19-golem branch ends at 5b6e3c3, the closed Golem experiment.
Only the integration branch is temporary. Historical task records describing
uncommitted status remain historical; this record supersedes that status.
The main checkout's pre-existing untracked handoff.md is preserved unchanged.

## Default startup emulator acceptance

On 2026-09-14 the Author tested the current full game from main and confirmed
“alright that works,” explicitly authorizing closure, commit and push.
The fresh rally22-main-default-review profile launched the normal 171072-byte
binary identified above with `RUN .` and no game arguments, official Fab 1.2.4
and stock platform MOS/VDP. Default startup review passes. The emulator process
had already exited when closing the review; no other emulator was stopped.

This accepts the reviewed default-startup behavior. It does not establish new
physical frame-rate measurements, resolve previously noted difficulty, or
validate the separate optional UART1 transmit-interrupt emulator model.
The profile and runtime outputs remain ignored; no game source changed.
