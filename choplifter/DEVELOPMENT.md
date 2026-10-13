# Choplifter development — 2026-10-06

CHOP-001 implementation is complete: a standalone Pygame rescue game is in this
directory, with an 848×480 canvas, RGB222 color palette and binary alpha. It
implements the original-style single battlefield, 64 hostages in four camps,
16 seats, three helicopters, scrolling flight, automatic rescue transfers,
guns/bombs, tanks/jets, crash/respawn, pause, mission results and restart.
Research provenance and version differences are recorded in RESEARCH.md.

1. `make -C choplifter test`: six tests passed. Includes full rescue, casualties,
   game over, landing, combat, pause/flight and 16 rendered-frame palette/alpha
   audits across four states and four camera positions.
2. Headless CLI launch: three frames and PNG capture passed at 848×480.
3. Deterministic stress check: 24,000 fixed simulation steps with changing
   controls, enemy activity, crashes and restarts passed accounting bounds.
4. Title and gameplay screenshots were visually inspected. Human keyboard play
   and difficulty have not been validated. No audio is implemented.

The repository's pre-existing `.venv` contained a broken Python symlink to an
unavailable x86-64 interpreter. It was preserved intact at
`/tmp/agonarcade-venv-before-choplifter-20261006`; a working Python 3.13.5
repository-root environment was created and Pygame 2.6.1 installed. The new
environment contains this game's dependency, not the old environment's other
packages. No emulator, Rally source, Defender source or Git commit was changed.
