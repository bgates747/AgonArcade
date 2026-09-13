# AgonArcade handoff

Current state: **RALLY-22** and BENCH-001 work frozen in local commits at the
Author's request. Do not resume unattended development without a new instruction.
Read `docs/tasks/RALLY-22.md` and `docs/specifications/rally-full-game.md`.
Bounded BENCH-001 driving practice is complete; no further learning runs.
Preserve `rally-production` and `rally-bench`; new game lives in `rally-game`.
Tests are headless; leave experimental changes local pending Author review.

Separate paused task: **RALLY-20**, planning frozen for Author review. Read
`docs/tasks/RALLY-20.md`, its `CONTRACT.md`, and
`docs/2026-09-12-rally-autonomous.md` first. Optimize the accepted stripped
pre-Golem hardware product, not the full-scene Golem renderer. The accepted
binary's reproducible lineage is in that contract; root `make -C rally` is not
yet established as its build command. Do not start RALLY-20 implementation until its planning review gate is released.
That restriction does not block the later authorized BENCH-001/RALLY-22 work.
The planning emulator summons is expressly authorized; all later test runs are
headless except an unavoidable human physical-intervention summons. Root TODO
owns the cross-project register. Preserve prior dirty production/bench evidence.

This is the isolated RALLY-19 execution worktree, branch `rally19-golem`, at
`/home/smith/Agon/mystuff/AgonArcade-rally19`. Root `rally/` is the earlier game;
`make -C rally` does not build the current Golem candidate. Start RALLY-19 work
with `docs/tasks/RALLY-19/DELIVERY.md`, BUILDING.md, the frozen CONTRACT.md, and
HARDWARE-DEBUG.md/REVIEW.md in that directory. The root TODO owns all execution
checkboxes. Final native criteria pass and the observed physical startup crash
is corrected, but hardware rendering remains too slow; this is a bounded research
delivery, not a practical acceleration. Further optimization needs a new task
decision. The corresponding C++ compiler is in the
separate `../golem-rally19` worktree. Preserve the original AgonDefender and Golem
checkouts. Later Author hardware/serial permissions are recorded in HARDWARE-DEBUG.md;
the original contract's no-hardware wording is not the current complete scope.

Follow `/home/smith/Agon/mystuff/agon-dev-env/codex/AGENTS.md` for Agon work.
Use repository-root `.venv/bin/python` explicitly for Python tooling.
`TODO.md` is the only authoritative task list for all games in this repository.

Agon Defender is in `defender/`. Read its `AGENTS.md`, README, platform notes and
latest development log before changing it. Build/test with `make -C defender`
and `make -C defender test`. Prepare its isolated profile with
`.venv/bin/python defender/tools/prepare_emulator.py`, then launch with
`./defender/run.sh`, which delegates to the generated profile-local entry point.

Keep new games in sibling subdirectories. This checkout is AgonArcade even
though its existing local directory is named AgonDefender. Pynvaders is separate.
Leave emulator-related changes uncommitted until human validation and explicit
commit approval, as required by the canonical workflow.

Rally flat-track prototype lives in `rally/`. Read `rally/README.md`.
Build/test with `make -C rally` and `make -C rally test`. For projection background, read
`docs/plans/rally-flat-road.md` and `docs/research/pole-position/README.md`.
The report distinguishes original hardware evidence from proposed Agon geometry
and estimated performance. Root `TODO.md` remains the sole task list.
