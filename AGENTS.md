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
integration remains outside this tranche. Preparation/scope was then committed
and pushed as `314efe6`; isolated helper and ordinary/sanitized host qualification
are delivered under `docs/tasks/RALLY-25/renderer-helper/RESULTS.md`. TRF-001-23/14
are complete: Golem accepted exact v0.3 ABI/build-hook contract; read
`docs/tasks/RALLY-25/renderer-helper/ACCEPTANCE.md`. Compiler bindings/combined
linking remain unimplemented; helper results/accepted contract are frozen at
pushed checkpoint `e94f0aa`.
Native/composed stack/resource admission and combined linking remain unqualified.

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

Author released TRF-001-27–30 on 2026-10-13: checkpoint current work, then a
Rally-owned host C invocation/completion-publication harness and portable Fuji
scene package, returning for review. Read RALLY-25; combined linking and target
work remain outside this tranche.

TRF-001-27–30 completed after pushed checkpoint `e94f0aa`; read
`docs/tasks/RALLY-25/integration-harness/RESULTS.md` and `README.md`. Ordinary and
ASan/UBSan host C models pass144 scene renders/two mappings and138 failure
groups each; exact helper/published manifests preserved. New harness results
remain uncommitted; stopped for Author review. D1b foundation candidate-nine
was received/identity-checked and acknowledged, not integrated or accepted.

Next concrete scope TRF-001-31–35 is written for Author review before execution:
accepted D1a/foundation bundle qualification, actual generated array adapter,
six-slot/full-range Fuji fixture and independent generated-C host checks.
Golem foundation human acceptance/publication4a62c1d is confirmed by its mail;
multiplication candidate-eleven is identity checked only and pending human
review/publication. Do not silently adopt its live compiler or close deferred
divmod/shift/full replay work. No new compile/run or commit/push has occurred.

Latest mailbox status (twenty-two receipt): multiplication human accepted and
published `1ddfd64`; division candidate-thirteen bundle identity verified,
uncommitted/pending Author visual review. Planned TRF-001-31–35 scope and
foundation baseline remain unchanged; no independent multiplication/division
qualification or new execution is implied.

Author released TRF-001-31–35 with commit/push of all current dirt before
execution. Qualify the accepted immutable D1a/foundation deliveries in Rally-owned
host workspaces, then return for review. No candidate pin expansion or target work.

TRF-001-31–35 completed after pushed checkpoint `4489f58`; read
`docs/tasks/RALLY-25/generated-state/RESULTS.md` and `README.md`. Immutable
D1a/foundation files and exported Git lineage verified;2,924 actual generated-C
host checks pass across two layouts/ordinary+ASan/UBSan, full root/array states
match and granted leases balance. New generated-state results are uncommitted;
stopped for Author review. Broader indexed/complete numeric target integration,
D2 combined linking and firmware remain open. Latest division human-accepted-
fourteen records Author acceptance with commit/push approval pending; fixed
foundation compiler pin was preserved.

Author released TRF-001-36–40: write scope, commit/push current dirt, then
Rally-owned historical route/contact Golem kernels and deterministic host replay
using accepted multiplication/division/right-shift exports. Read RALLY-25.
Golem supplies primitives/fixes; Rally owns game-specific replay. Keep actual
spawn/removal/recovery/scheduling/renderer/target integration separately gated.

TRF-001-36–40 completed after pushed `a31c2ce`; read
`docs/tasks/RALLY-25/route-kernels/RESULTS.md`/`README.md`. Actual generated C
passes319,072 host invocations with accepted published right-shift compiler:
full sine domain, exact route cycles, six-slot motion and contact/reference
replay, primitive failure semantics. New route source/results uncommitted;
stopped for Author review. Golem D2 was separately released and its resource
gate fails before real glue: tiny combined text8224/8192, stack576/512 before
callbacks. Owner evidence identity-checked only; see D2-RESOURCE-RECEIPT.json.
SDK budget review/helper reduction needs separate release; no limit/source
change is implied. Right-shift publicationb32c596 supersedes pending status.

Latest Author decision: raising max allowable size is agreed. Mail twenty-five
asks Golem for exact text/data/image terms, separate stack allowance coverage
and policy/build/runtime delivery identities. No values were supplied here;
do not infer them or reopen the agreed size-increase decision. Prior fit failure
is historical evidence; implementation and full-workload qualification remain
pending. No helper rewrite or new Rally execution is implied.

Golem seventeen clarifies the agreed increase covers both text AND stack.
Numerical limits are not selected/implemented; data/image require assessment.
GOLEM-002 CAP-001–009 records future capacity/service protocol work only.
SDK pin remains33a554c; four advertised source/header/builder hashes match.
Rally acknowledged in twenty-six; no helper rewrite, new execution/pin adoption
or reopening of the agreed increase-versus-reduction decision.

Author released TRF-001-41–45: commit/push all dirt and the formal scope, then
host simulation-to-renderer integration with deterministic Fuji command replay,
four physics ticks per frame and completion/error checks, returning for review.
Read RALLY-25; real generated D2 glue/target linking/runtime work is excluded.
Golem Stage A is separately authorized through mail twenty-nine.
