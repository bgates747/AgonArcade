# Agon Defender handoff

Read `/home/smith/Agon/mystuff/agon-dev-env/codex/AGENTS.md` first for Agon work.
This is the `defender/` subproject of the AgonArcade repository.
Use the repository-root `.venv/bin/python` for Python tooling
(`../.venv/bin/python` when working inside this directory).

This is a native C++17 game built with installed agondev. `make` creates
`bin/defender.bin`; `make test` runs host gameplay checks under ASan/UBSan.
`src/game.cpp` contains platform-independent fixed-point simulation.
`src/main.cpp` owns stock-VDP bitmap rendering, audio, MOS keyboard decoding, and timing.
Use ordinary bitmap plots with mode 136 double buffering; do not enable software
sprites in this renderer.
`tools/generate_assets.py` creates original RGBA2222 sprites in `include/assets.hpp`.
Read `README.md`, `docs/platform.md`, and the latest development log before changes.

`../TODO.md` is the sole authoritative task list for the shared repository. The canonical setup tool generates
`.emulator/` via `../.venv/bin/python tools/prepare_emulator.py`. Its SD tree links
only the native binary, never the containing project. `./run.sh` delegates to
`cd .emulator && ./fab-agon-emulator`. `--demo` on the preparation script selects
autoplay; the normal profile starts at the interactive title screen.

The user validated gameplay and explicitly approved the AgonArcade migration
and initial commit/publication. Keep emulator-related changes
uncommitted until the user has validated the emulator and explicitly approved
committing, per the canonical workflow.

## Network access authority

For access between development machines, read the [canonical network instructions](https://github.com/bgates747/agon-dev-env/blob/feature/standardized-deployment/codex/environment.md#ssh-between-development-machines) in `~/Agon/mystuff/agon-dev-env/codex/environment.md` and its machine-local `.local/ssh-001/CONNECTIONS.md` guide. They own current hostnames, discovery, SSH identities, sudo, and LAN shares. Do not duplicate access recipes or revive old aliases, addresses, or share mappings in this project. Project-specific device/protocol and bench-safety instructions remain local.
