# Standing emulator authorization —2026-10-14

Only truly headless automated emulator sessions are authorized: no graphical
window and NO sound output. Force both SDL_VIDEODRIVER=dummy and
SDL_AUDIODRIVER=dummy for every unattended run; never inherit a real audio
backend, even for diagnosis. If visible/audible reproduction is required,
stop dependent work and ask the Author to launch it. No hidden session may
play sound through Oryx speakers. This overrides any earlier inference that
headless real-audio testing is permitted. See failed review FS-001-07.

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

TRF-001-41–45 completed after pushed `90919ad`; read
`docs/tasks/RALLY-25/scene-replay/RESULTS.md`/`README.md`. Actual generated
simulation and accepted helper joined by host-only metadata adapter/modeled
renderer wrapper pass900 independent command frames/3600ticks/30failure cases
per ordinary/sanitized/default/relocated variant. Raw shared heading mapping
is resolved; actual D2 glue/one target module remains undelivered. New scene
source/results uncommitted; stopped for Author review. Golem capacity Stage A
has returned its fuller resource measurements/numerical proposals; read the
latest PROTOTYPE-CONTRACT.md section. SDK policy remains unchanged; Stage B
awaits Author review/release. Receipt-thirty-one supplies heading/presentation
map clarification, with no new execution or publication authority.

Latest Author release (2026-10-14): build the real composed Fuji demo and stage
it on Oryx; recoverable VDP crashes are acceptable experiments. TRF-001-46–49
is now released, superseding the stop before Stage B. Golem mail thirty-two
releases SDK/bindings/runtime work; Rally owns driver/assets/profile. Read
`docs/tasks/RALLY-25/native-demo/README.md`: source physics passes3600 ticks,
assets/driver build, unpaced Oryx driver-only smoke passes. Real Golem binding/
enlarged-runtime delivery is still pending, so no native Rally demo is ready.
Old GOLEM-021 hybrid MOS clock stalls at static frames; paced driver smoke
fails, reported in thirty-five. All launched profiles are headless/stopped;
no physical action or commit/push. Do not mistake driver smoke for the game.

Golem twenty now confirms SDK/real bindings/firmware/narrow clock fix in progress;
concrete GOLEM-037/binding/native-bindings.json matches final Rally source and
50300–50305 retained IDs. Mail thirty-six accepts maps/ownership; no new user
question required. TRF-001-50 independent PRT stopwatch fixture is qualified;
read native-demo/PRT-RESULTS.json and README.md. Guest now saves prt.log and
clock.log alongside previous logs, restores idle PRT1's prior vector, and reports
nominal emulated CPU ticks separately. Frozen demo.golem unchanged. Thirty-seven
supplies results to Golem. Actual combined module/demo still awaits delivery.
Author preference: use the attention dialog when a nudge to another agent is
needed; for a blocking Author question, stop and ask one question in chat.

LATEST: actual native Fuji demo is ready for Author visual review on Oryx.
Read docs/tasks/RALLY-25/native-demo/RESULTS.md and README.md. TRF-001-46–50
complete: real candidate48eac7..., enlarged firmware8da2..., corrected-clock
Flexe frontend28f50.../adapter200f...;900 renders/3600ticks pass full diagnostic
and viewing controls, final source/arrays match independent model. Viewing
28.85FPS misses30 target; full controls25.58FPS. PRT/MOS/host clocks separate;
no full-game/autonomous cadence/hardware claim. Profile is stopped:
~/Agon/mystuff/AgonArcade/.emulator/rally25-native-demo on Oryx, launch via
./flexe-agon-emulator (Author naming preference relayed in Golem twenty-two;
no Fab compatibility aliases). Human visual review and explicit commit/push
remain pending. All baselines/manifests preserved. No graphical/physical launch.

AUTHOR VISUAL ACCEPTANCE (2026-10-14): native Fuji demo looked good; flat/missing
background is explicitly understood as outside this fixture. Retrieved human
logs verify900frames/3600ticks/2913 retained replies, exact independent final
world, PRT teardown and unchanged runtime identity. Read native-demo/
HUMAN-REVIEW.json; human nominal MOS elapsed30.7167s/29.30FPS. Do not infer separate
keyboard acceptance, full-scene/game/hardware/cadence acceptance or publication
permission. No commit/push or next implementation scope from this comment.

CONSOLE8 STAGING (2026-10-14): TRF-001-51 complete; unpaced900-frame/3600-tick
fixture and vdp_rally.bin deployed to /test/arcade/rally (test singular) on Oryx
card UUID8658-1C23, writes flushed. Read native-demo/HARDWARE.md and
HARDWARE-DEPLOYMENT.json. Author flashes/runs; TRF-001-52 awaits returned logs.
TIMING-CORRECTION.json supersedes old100Hz receipt interpretations: nominal
120MOS units/s gives human29.30FPS, viewing28.85, full25.58. Raw receipts unchanged.
Current pacer uses4MOS units; old reviewed3/3/4 requested36Hz; hardware is unpaced.
No physical run, flash, unmount, commit or push performed.

CONSOLE8 RETURN VERIFIED (2026-10-14): TRF-001-52 complete. Read native-demo/
HARDWARE-RESULTS.json and RESULTS.md.900frames/3600ticks/2913reply records pass;
final source globals/five mutable arrays match independent model. Aggregate
unpaced hardware fixture23.45FPS/38.3833s at nominal120MOS units/s; PRT23.49FPS/
38.313s agrees within0.19%, prior vector restored. INFO17 minfree2260 unchanged;
StopRace/UNLOAD0. Includes checks/transport/drawing/swap submission, not isolated
VDP completion or an autonomous scheduler. Raw hardware returns saved in
evidence/hardware-*. Card files untouched. No further implementation release
or commit/push inferred. D3 ownership/design remains proposed, not implemented.

IDENTICAL UNPACED COMPARISON (2026-10-14): Author required the exact same bytes
on both platforms. TRF-001-53 complete; read native-demo/IDENTICAL-COMPARISON.md
and JSON. All ten returned-card input files plus supplied firmware match SHA256
before/after isolated headless Flexe run; no rebuild/metadata edit. Same MOS
directory /test/arcade/rally.900frames/3600ticks/2913reply records and full final
state match Console8 and independent model. Flexe29.0167FPS/31.0167s vs physical
23.4477FPS/38.3833s, nominal120MOS units/s. Flexe backend errors zero/clean exit.
Profile .emulator/rally25-native-hardware-identical stopped; accepted visual
profile and physical card untouched. Results are aggregate fixture timing,
not separate VDP completion/phase timings. No commit/push/new implementation.

CURRENT NEXT PRIORITY (2026-10-14): Author moved headroom/phase measurements
ahead of D3 scheduler implementation. Read RALLY-25.md current-priority section:
TRF-001-54 inventory complete;55 actual eZ80 player/input/rules CPU versus
8.333ms budget,56 native VDP physics/geometry/draw/swap and transport costs.
Existing R27-05 full-scene Fuji fixture has scrolling panorama/traffic/signs/
HUD/audio, contact checks without damage, PRT detail and VDP microsecond markers.
Detailed runtime unqualified; simplified attract player is not actual player
physics. Reuse facilities without labelling old direct renderer as native.
Same exact fixture bytes across platforms. Current turn changed priorities/
researched sources only; no new build/run/firmware delegation/publication.

FULL-SCENE TRANCHE RELEASED (2026-10-14): Author clarifies modifying the VDPlet
fixture to reproduce R27-05 full-scene workload with new processor split. Read
docs/tasks/RALLY-25/FULL-SCENE-PLAN.md (FS-001-01–06). Write task, commit/push all
Rally dirt, then execute authorized application/peer-coordination/headless Oryx
work. Preserve R27-05/current native benchmark bytes and evidence. eZ80 owns
player/control/rules/scenery/HUD/audio; VDP opponents/contact/native projection.
No autonomous scheduler/gameplay-policy/effect tranche inferred. New full-scene
profile must stop for human review; later implementation publication separate.

FULL-SCENE NATIVE FIXTURE READY (2026-10-14): pre-implementation all-dirt/task
checkpointc96a55d pushed; FS-001-01–06 executed. Read RALLY-25/full-scene/README.md.
R27 presentation functions reused separately: scrolling panorama/fonts/title/
HUD/audio; eZ80 centerline player/control/rules and snapshot producer; VDP
opponents/contact/native road/car/sign/finish rendering. Golem sourcec62aee...,
module5a3ef7...;33export files verified against published4beafb0; client package
byte-identical. Firmware8da2ebf... unchanged, no compiler/SDK/helper edits.
60-frame smoke and two900-frame/3600-tick headless runs pass independent final
world/player/arrays, timer restoration/stop/unload/backend checks. Final candidate
28.51FPS/31.5667nominal MOS seconds,397scrolls/399repaints/24engine changes; prior
run29.09FPS. Input/runtime hashes verified; INFO17 minfree2260 unchanged.
Oryx stopped review profile .emulator/rally25-full-scene-review, launch via
./flexe-agon-emulator from profile. Ten candidate input files/firmware prepared
under full-scene/.work/fixture-900 on Pi/Oryx, not copied to physical SD.
New work uncommitted pending Author visual review and publication instruction.
R27-05 and old native benchmark sources/bytes/evidence unchanged. PRT stage
outputs are nominal emulator intervals, not qualified physical or interactive
player CPU headroom. Native phase isolation/real player measurement55/56 and
autonomous120/30Hz scheduling remain later work.

NATIVE CHECKPOINT PUBLICATION AUTHORIZED (2026-10-14): Author explicitly asks
commit/push of ALL current dirt in logical groups before lookup-engine research.
This includes the unfinished full-scene native fixture and strict silent-headless
policy. FS-001-07 remains failed/pending correction; publication is a checkpoint,
not visual acceptance or a release of further native implementation.

RENDERER EXPLORATION (2026-10-14): Author requested new RALLY-28 task document
and reading Lou Gorenfeld https://www.extentofthejam.com/pseudo/ after supplying
POLE26.S/AtariAge references. Task/research notes in docs/tasks/RALLY-28.md; root
TODO registers it. Research/documentation only, no implementation/run release.
Separate geometry preparation from dispatch/raster cost; initial candidate is
specializing current bilinear section corners, then filler A/B on same geometry.
Existing depth/stripe tables already cover much tutorial advice. Direct mode136
span service unverified; no new track/camera/physics semantics. Preserve all
old fixture inputs; silent headless constraints remain. FS-001-07 black startup
review failure still unresolved and is not fixed by this exploration task.

OPTIMIZATION ORGANIZATION (2026-10-14): Author supersedes separate29/30 tasks:
ALL optimization falls under RALLY-28. Read docs/tasks/RALLY-28.md. Subdirectories
RALLY-28/research, standard-vdp and custom-vdp separate shared findings and each
version's code/fixtures/results. Standard VDP/eZ80 version FIRST; custom
Golem/VDPlet version SECOND. Existing MATH/FAST/STD/NATIVE IDs retained in parent
task. Single root TODO entry; no independent29/30 task docs/register entries.
Standard projection is an active target. Native startup FS-001-07 does not block
standard research/planning. Current changes are documentation/structure only;
no implementation/runs/peer edits/commit/push. Silent-headless policy unchanged.

RALLY-28 HOT-LOOP REVIEW (2026-10-14): Author released first research item with
“go”; MATH-001-01 complete. Read RALLY-28/research/HOT-LOOP-REVIEW.md and
AUDIT.json. Unchanged-source standard/native eZ80 inspection objects reproduce
preserved objects byte for byte;226 protected files unchanged. int/pointers24,
short16,long32; narrowing storage does not guarantee narrower arithmetic.
Standard dense rows847 software-wide multiplies/frame,242 for unused tangents;
endpoint/edge reuse and other candidates documented. Costs are static evidence,
not measured cycles/speedup/headroom. Actual manual Motion and simplified fixture
player are distinguished; native Xtensa responsibilities mapped separately.
Next research MATH-001-02 bounds/rounding. No game implementation, emulator run,
firmware/profile/deployment/peer change, commit or push. Silent headless authority
and separate FS-001-07 visual failure remain in force.

RALLY-28 LOOKUP PRIORITY RELEASE (2026-10-14): Author requests preserving lookup
assessment as LOOKUP-001-01, checkpointing/pushing all dirt in logical groups,
then execution. Read RALLY-28.md immediate subtask. Assess R16/R18/R22 lineage,
source/tables/codegen/performance evidence and a stock-compatible direct-emission
reuse path before live-path micro-optimization/MATH-001-02. Bounded host research
is within scope; preserve controls, no full-game replacement or emulator/hardware
launch inferred. Existing native visual defect remains separate.

RALLY-28 LOOKUP ASSESSMENT COMPLETE (2026-10-14): all pre-execution dirt committed
and pushed in logical groups26bff68(native fixture/evidence/silent policy) and
038d27a(research/audit/lookup scope), clean tree verified before execution.
LOOKUP-001-01 now complete: read RALLY-28/research/LOOKUP-ENGINE-REVIEW.md and
LOOKUP-STUDY.json. R18 original headers/data preserved; generator reproduces exact
bytes with -ffp-contract=off (default ARM contraction changed14oval payload bytes).
Isolated direct integer emitter works with LookupRoad or live endpoint-only
SectionRoad;9,930 ordinary/sanitized host poses pass, eZ80 codegen inspected,
627 protected files unchanged. Fuji900-frame centre math57.79wide multiplies/frame
versus847dense row multiplies; conservative bands add32.88%road command bytes.
No target timing/FPS gain established. Next range workMATH-001-02 targets recovered
projection and residual player/scene arithmetic; proposed STD tranche is separate
full-scene lookup/live-section A/B, current R27 control preserved. New research/
proof/results uncommitted; no product/profile/firmware/deployment change or
emulator launch. FS-001-07 visual startup defect remains open separately.

RALLY-28 SHARED OPTIMIZATION TASK AMENDMENT (2026-10-14): Author requests the
positioning audit prominently and explicit identification/rectification of partial
optimizations. RALLY-28.md now opens with POS-001-01 and REUSE-001-01–04; root TODO
prioritizes them. Audit all road/traffic/sign/player/finish/background consumers,
then broader sampling/invariant/wrap/formatting/command families. Apply selected
fixes to every compatible active standard consumer, document concrete exceptions,
then independently apply suitable native findings and verify coverage/performance.
Preserve prior wins through backend changes; only requested rows need shared
projection results. MATH-001-02 supports range/rounding proofs. Existing IDs and
single RALLY-28 umbrella retained. This turn edits task/handoff documentation;
no implementation, test/emulator run, commit or push.

AUTHOR PERFORMANCE/COMMUNICATION STEERING (2026-10-14): use explicit numbered
items in future human discussions/recommendations; immutable ID/checkbox task
paragraphs remain. All five frame/architecture/physics/memory/motion considerations
are recorded near the top of RALLY-28.md. Faster coherent motion may beat more
accurate frames. In POLE26.S/AtariAge/Lou review, retain deliberate speed/accuracy
shortcuts as first-class initial candidates, including coarse/low-precision/fewer
band/approximate depth or curvature options. Record candidates/dispositions and
reasons; do not silently reject for inaccurate pixels, jitter or historical
one-pixel/99% thresholds. Author selects visible motion tradeoffs. Exact controls
and unchanged world/contact checks remain comparison/behavior evidence. Previous
exact-first/defer-approximation recommendation superseded. Task/evidence notes
updated only; no new code/build/emulator run, commit or push.

RALLY-28 STOCK COMPLETION PROBE PROPOSED (2026-10-14): Author requests a minimal
standalone test of the stock buffered-command notification mechanism, then pause
for review. SYNC-001-01 is recorded in RALLY-28.md and root TODO: simple drawing,
flush plus key-state request, existing MOS keyboard callback and independent
foreground clock counter; self-created logs, input/ordering checks and general-
poll fallback. No custom firmware or game integration. Planning only: stop for
Author review; no implementation/build/emulator/hardware run, commit or push.

RALLY-28 STOCK COMPLETION PROBES BUILT (2026-10-14): Author released all-dirt
commit/push then implementation. Checkpoint aee0aad/01f6333 pushed; clean tree
verified before execution. Read RALLY-28/standard-vdp/completion-probe/RESULTS.md
and README.md. Two standalone applications pass 52/52 completions against the
exact official stock VDP 2.16.0 binary and official MOS 3.0.2, no firmware edits.
Seven stored bytes flush drawing then request VK_NONE zero (callback) or a GP
token (polled control). Foreground sends verification pixel/poll commands only
AFTER primary completion; raw UART order/readbacks pass. Key run preserves eight
SDL/PS2 input events, 48 zero-key callbacks/four F12 comparison replies; no idle
marker, empty before/after maps, prior callback restored, own summary/CSV/done
files. Both counters advance 120 nominal MOS units while heavy drawing is pending;
not actual Rally physics/headroom or hardware timing. Final apps/evidence pinned;
all automated runs forced BOTH dummy SDL drivers and stopped cleanly. Fresh Oryx
.emulator/rally28-completion-review and rally28-completion-poll-review are STOPPED
for Author launch; audio always dummy. Human/input/Console8 acceptance open.
MOS callback-slot read is pinned to official 3.0.2 map; marker zero has no token
and console-mode serial input can also use zero. One request outstanding. F12 is
only a comparison, inherently ambiguous with real F12 events. Existing games,
fixtures and upstream trees untouched. New probe work uncommitted for review;
no card/flash/physical run or game/scheduler integration.

RALLY-28 PACING/TRANSPORT PLANNING AMENDMENT (2026-10-15): Author requests all
recent scheduling/benchmark/wire considerations recorded, then next-work advice.
Read RALLY-28.md measured-pacing/transport section; RALLY-25/26 and root TODO
cross-reference it. 120 Hz is unqualified. Benchmark each actual physics candidate
flat out at a fixed count lasting >=10 wall-clock seconds on the fastest tested
platform; raw PRT/MOS counts, timestep, calibration and instrumentation limits.
Then include real command generation, UART/CTS stalls and completed pipeline/CPU-
VDP overlap before selecting fixed physics cadence with headroom and matching dt.
Render opportunistically, one frame outstanding, fresh snapshots, skipped visual
states, no catch-up renders or physics blocking on completion. Geometry and
blocking MOS/UART writes also need bounded/cooperative work. Old mandatory 30 Hz
cap superseded for new candidates; historical fixtures/contracts stay unchanged.
WIRE-001-01 inventories resident assets/simple drawing templates, changed-parameter
patches and batched calls; count all headers/payloads/CALLs/replies/fences, setup
amortization, memory and page/buffer lifetimes. Keep complex math on its assigned
processor and retain POS/REUSE family-wide optimization requirements.
Next PROPOSED tranche: PACE-001-01 actual standard physics benchmark plus WIRE-001-01
census alongside POS-001-01/REUSE-001-01 audits. PACE-001-02 integrated measurement
and PACE-001-03 scheduler are later scoped work; native qualification follows
standard independently, with owner coordination before changing native contracts.
Author ran the callback probe; returned data previously read shows 52/52, no
failure, callback restored and counter/elapsed both578 MOS units. It is mechanism
evidence, not a physics/saturation benchmark or exhaustive human input acceptance.
This turn changes task/handoff/log documentation only. Preserve all probe dirt;
no new implementation/build/emulator run, peer mail, commit or push authorized.

AUTHOR RELEASE — 2026-10-15: commit/push all current dirt, then execute
RALLY-28 PACE-001-01 actual standard physics capacity and WIRE-001-01 wire
census, with POS-001-01/REUSE-001-01 discovery. Extra-high reasoning; preserve
game/old fixture bytes. PACE-001-02/03 and selected optimization implementation
remain later work. Every automated session forces both SDL dummy drivers.
