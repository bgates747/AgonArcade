# AgonArcade handoff

Current state: **RALLY-27** direct-eZ80 full-game restoration is implemented
and preserved in commit `a2a613f`, pushed on Author instruction. Read `TODO.md`, `docs/tasks/RALLY-27.md`,
`docs/tasks/RALLY-27/RESULTS.md` and `docs/specifications/rally-full-game.md`.
The Author reported Console8 gameplay acceptance of the exact deployed candidate
and, on 2026-10-13, that the Flexe agent fixed keyboard input. Updated-Flexe
Rally diagnostic validation remains pending; R27-05 is now authorized and in progress.
Read `docs/tasks/RALLY-27/timing/RESULTS.md` for provisional FPS and transport stalls. No qualified hardware FPS
or exhaustive phase coverage is established. Preserve all existing dirt; no
commit/push without explicit approval. Do not resume unattended development
without a new instruction. This checkout is now `/Agon/mystuff/AgonArcade`;
disregard the pasted handoff's old directory name and prohibition on renaming.
RALLY-22 and BENCH-001 evidence remain preserved.
Bounded BENCH-001 driving practice is complete; no further learning runs.
Preserve `rally-production` and `rally-bench`; new game lives in `rally-game`.
New emulator behavior still requires human review; integration/publication was
explicitly authorized on 2026-09-14.

Active native planning/integration task: **RALLY-25**. Author released the first
D0/independent-D1 Rally tranche at high effort on 2026-10-13. Read
`docs/tasks/RALLY-25.md`, its `PROTOTYPE-CONTRACT.md`, `ROOT-V1.md`,
`INTEGRATION-MAP.md` and `NUMERIC-REQUIREMENTS.md`. Historical R22 source lineage,
independent route/contact/numeric references and host-only adapter/stubs are
ready; no product/firmware/deployment changes were made. Golem compiler pin is
committed GOLEM-032 `25901e5`; immutable D0 scalar/toolchain/manifest/native/buffered
delivery is verified and consumed (TRF-001-07/09). Read the current
`docs/tasks/RALLY-25/renderer-prep/RESULTS.md` for later evidence. Coordinate through canonical agentcoms
as `rally`, thread `rally25-golem-native`; Golem owns its files. Keep R27 as the
current direct baseline. Later arrays/wide integration, renderer composition,
scheduler/snapshot/recovery choices and firmware work require their scoped
release. The Author authorized committing/pushing the reviewed state and proceeding with
TRF-001-18–22 renderer preparation on 2026-10-13, frozen at pushed `d250f43`.
Host mapping/architecture negotiation,9,120 scene fixtures and bounded parity
diagnosis are complete; new preparation results are uncommitted for review.
Author accepts current approximately 99% scene agreement for continued development;
stop further parity research. The Author’s own visual confirmation is the final
visual gate. Author subsequently authorized commit/push of preparation results
and TRF-001-23–26 concrete helper negotiation/extraction/host qualification, then
review. Read `docs/tasks/RALLY-25.md`; combined module linking/game/firmware
integration remains outside this tranche.

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

Main development now includes the latest eZ80-based full game in `rally-game/`.
Build with `make -C rally-game`; test with `make -C rally-game test`.
`rally-production/` supplies its preserved renderer headers and rollback product;
`rally-bench/` is the earlier telemetry derivative; `rally/` is historical.
Do not launch `rally/` or the BENCH-001 older binary when asked for current Rally.
The abandoned Golem experiment is retained on `rally19-golem` at `5b6e3c3`.
Its full experimental sources/evidence remain on that branch, not main.
See `docs/2026-09-14-rally-main-promotion.md` for integration provenance.

Follow `/home/smith/Agon/mystuff/agon-dev-env/codex/AGENTS.md` for Agon work.
Use repository-root `.venv/bin/python` explicitly for Python tooling.
`TODO.md` is the only authoritative task list for all games in this repository.

Agon Defender is in `defender/`. Read its `AGENTS.md`, README, platform notes and
latest development log before changing it. Build/test with `make -C defender`
and `make -C defender test`. Prepare its isolated profile with
`.venv/bin/python defender/tools/prepare_emulator.py`, then launch with
`./defender/run.sh`, which delegates to the generated profile-local entry point.

Keep new games in sibling subdirectories. This checkout is AgonArcade. Pynvaders is separate.
Leave emulator-related changes uncommitted until human validation and explicit
commit approval, as required by the canonical workflow.

Rally flat-track prototype lives in `rally/`. Read `rally/README.md`.
Build/test with `make -C rally` and `make -C rally test`. For projection background, read
`docs/plans/rally-flat-road.md` and `docs/research/pole-position/README.md`.
The report distinguishes original hardware evidence from proposed Agon geometry
and estimated performance. Root `TODO.md` remains the sole task list.

## Network access authority

For access between development machines, read the [canonical network instructions](https://github.com/bgates747/agon-dev-env/blob/feature/standardized-deployment/codex/environment.md#ssh-between-development-machines) in `~/Agon/mystuff/agon-dev-env/codex/environment.md` and its machine-local `.local/ssh-001/CONNECTIONS.md` guide. They own current hostnames, discovery, SSH identities, sudo, and LAN shares. Do not duplicate access recipes or revive old aliases, addresses, or share mappings in this project. Project-specific device/protocol and bench-safety instructions remain local.
