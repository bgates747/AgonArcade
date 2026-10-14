# RALLY-25 / Golem native prototype contract — v0.2 planning agreement

This proposal defines the smallest shared boundary for parallel Rally and Golem work: bounded native entries, persistent indexed state, faithful game arithmetic, complete player snapshots and sparse collision events. It preserves the current SDK entry ABI and keeps scheduling/UART ownership in custom firmware. **Status: mutually accepted, confirmed by the Author and Golem GOLEM-033/accepted-contract.md.** The Author subsequently released the first Rally D0/independent-D1 reference and host-scaffolding tranche; later game/compiler/firmware integration and deployment remain separately gated. The concrete D0 envelope is [ROOT-V1.md](ROOT-V1.md). Array syntax/index semantics below are agreed requirements; exact wire offsets, binding signatures and numeric error-code details still require the specified sub-contracts. The frozen work contract is AgonArcade `f3196b9`.

The normative coordination record is the existing canonical `rally_golem` topic's new RALLY-25 branch. Published negotiation messages reside in `agentcoms`, thread `rally25-golem-native`. Historical RALLY-19's stock-only contract remains historical and is not edited into a native approval. This file promotes the v0.2 planning terms from `2026-10-13_15-06-37_golem_rally25-counterproposal-one` and Rally acceptance `2026-10-13_15-12-37_rally_rally25-contract-v02-accepted-five`. Historical messages remain immutable; later changes require explicit revision and provenance.

## Parties and ownership fences

| Owner | Boundary after implementation approval |
| --- | --- |
| Rally | Player/game-rule adapter, sparse telemetry codec, independent route/contact/reference cases, recovery foreground handling, renderer integration and labelled host stubs/fixtures |
| Golem | Shared frontend/semantics, native indexed/numeric support or agreed helpers, generated code, layout/entry manifest, bounded composition interface and compiler evidence |
| Golem agent as agon-vdplet maintainer | SDK/runtime integration proposals; actual changes require their own work release and evidence |
| Custom VDP owner | UART parsing/publication, one module invocation/drawing owner, periodic scheduler, collision packet dispatch, load/unload/exit synchronization |
| Author | Game behavior choices, scope/resource tradeoffs and final implementation/validation/publication gates |

Rally does not edit Golem/compiler/SDK source under this tranche. Neither participant may alter the other's state layout or shared semantics unilaterally. Potential collisions are recorded in the mailbox/topic before shared integration changes. A mailbox offer does not confer implementation or hardware authority.

## V0.2 delivery baseline and storage requirements

- Current D0 pin: committed GOLEM-032 `25901e52eb80a4d66847c11fbc70d1bac68ee633`, superseding GOLEM-031 `b37aa3c` after explicit Author commit/push direction to Golem. Rally verified the six frozen source exports and supplied SDK identities; [receipt](reference/dependency-receipt.json). Immutable D0 bundle `b7a6be65ce06789e` native/buffered artifacts, generated manifests and toolchain identities are now verified in [the current receipt](renderer-prep/D0-RECEIPT.json); the earlier receipt remains a published historical snapshot. This is a task-local pinned compiler closure, not inferred production `src/` promotion.
- Golem delivers a pinned compiler snapshot or promotion with source identity, shared interface/layout/initial bytes, named entries, toolchain, SDK ABI, native ELF/package and buffered artifacts. Compiler promotion is a Golem-owned delivery, distinct from the feature prototype.
- Storage comes first: bounded one-dimensional typed arrays/SoA with inclusive explicit bounds, for example `Array sint16 lateral(0:5)` and `lateral(index)`. uint16/sint16 elements come first; wider elements follow the numeric milestone. Buffer IDs/descriptors/lengths/access modes/offsets are generated; assembly/build installs state and immutable data in retained buffers.
- Index failure uses status 5, preserving the failed destination/element and adjacent storage while retaining earlier effects. Six opponents and 257 sine entries are required qualification cases, not global array-size limits. Both backends share syntax/storage/semantics; unsupported target operations reject explicitly.

## Prototype boundaries and versioning

- Contract family: `R25-G0`, planning revision `0.2`. Interfaces have explicit version/byte length, initialized layout, logical entry names, numeric type/unit definitions, reserved fields and resource ownership. Unknown versions/lengths/entry IDs reject before game-state mutation. Numeric entry IDs and buffer reservations are generated manifests, not hard-coded assumptions.
- Retain `vdplet_host_v1` / `vdplet_request_v1` unless the runtime owner agrees a separately versioned extension. Existing native prototype arguments are two bytes containing the shared-state buffer ID. Prefer retaining that small argument binding; the compiler publishes where inputs/state/outputs and any retained-buffer descriptors live. Larger telemetry is stored in retained input buffers or state, not stuffed into the SDK's <=32-byte invocation argument limit.
- Define typed packed state/views for six opponent slots and immutable route/sine/track tables. A bounded SoA representation is sufficient; record syntax, dynamic allocation, general pointers and parameterized language functions are not prerequisites if equivalent supported bindings satisfy the contract. State/asset size and access rights are explicit in the manifest.
- The layout includes separate module/runtime status, Golem language status and successful simulation/render generation markers. They must not be conflated. Any language/runtime failure leaves that invocation unsuccessful even if prior assignments have already happened.
- Shared persistent state belongs to the application and survives compatible code unload/reload; private generated code/scratch belongs to the selected backend. Changing layouts requires explicit reinstallation/migration/reset, never reinterpretation of existing bytes. Pointers and leases expire before entry return; no cross-entry raw pointer caching.

## Required logical entries

| Logical entry | Input / action | Output / completion contract |
| --- | --- | --- |
| `InitRace` | Valid initialized state, track/mode, asset descriptors and session identity; initialize six opponents and effects | Defined initial state and success marker; no implicit host installation |
| `Tick120` | One fixed 1/120-second step and a complete player snapshot chosen by the firmware; update opponents, contacts and effect state | Advance exactly one successful simulation tick; publish at most the permitted collision episode event |
| `Render30` | A stable completed simulation state at each fourth-tick render deadline | Bounded ordinary-command output or agreed renderer-service invocation; report generation/completion separately from submission |
| `ResetRace` | Explicit new-session/recovery policy and reset state | Clear collision latch/effects as agreed; reset is not inferred from a stale packet or backend change |
| `StopRace` | Quiesce autonomous activity before callbacks/module teardown | No further scheduled invocation, event delivery or drawing references to unloaded state |

SDK INIT/RUN/FINI are loader lifecycle operations; the logical game entries above are not aliases for an unbounded scheduler running inside SDK INIT. Generated named Subs are currently parameterless and use packed state; their binding to these logical operations requires explicit code generation/adapter agreement.

`Render30` need not reimplement the retained native renderer in Golem. Prefer one linked native module containing generated Golem C plus Rally-owned renderer/helper objects behind explicit bounded C bindings. One SDK entry/dispatcher and one drawing owner are required; helpers must not recursively enter the loader or load another module. Define binding names, argument/result types, buffer views, capabilities and error mapping before adapters use them. Bindings require an agreed buffered implementation or explicit target-requirement rejection; do not advertise unsupported stock portability. A firmware rendering service is an alternative only after separate agreement under RGAP-004. The current single-slot implementation prevents assuming two concurrently resident modules. The recorded B text size does not prove that a combined module is too large: 8 KiB is a recommended/configured admission policy, not a known physical ceiling.

## Numeric contract requirements

- Preserve current world units and signed fixed-point behavior unless the Author accepts a new equivalent representation. Fuji track position requires a range through 3,276,799 hundredth-world units. Intermediate route/projection products require more than 16 bits. Arithmetic must not fail at an intermediate merely because a final reduced value fits a narrow field.
- Required numeric milestone: uint32/sint32 state, checked add/subtract/compare/multiply, explicit narrowing and signed division. Signed quotient truncates toward zero; remainder is `n-q*d`, has the numerator’s sign or is zero, and satisfies `abs(r)<abs(d)`. Zero divisor uses status 4; minimum signed value divided by -1 uses language status 6 with no output writes. Conversion/Bounds uses 32. These were accepted in Rally message `2026-10-13_17-18-34_rally_rally25-d0-received-division-six-eleven` and promoted by Golem into GOLEM-036; interface status 6 is a distinct channel. Existing operator status families remain. Paired quotient/remainder stores are all-or-neither. Existing 16-bit expressions do not widen implicitly: source explicitly forms wide operands before multiplication.
- The [numeric audit](NUMERIC-REQUIREMENTS.md) establishes sufficient explicit 32-bit intermediates for the frozen route/contact kernel and selected lookup evaluator under stated domains. Direct map projection has a conservative bound beyond signed32; require a tighter proof or exact wider helper if that path is selected. This does not assert all projection code fits signed32.
- Existing checked arithmetic preserves failed destinations but retains earlier effects. Do not promise transactional tick rollback without a separate implementation. Proposed failure policy is to mark state/session unhealthy, suppress successful-generation/event publication and stop normal advancement pending an explicit reset/recovery policy; final behavior needs review.
- Float32 is available in the committed GOLEM-032 baseline; using it for additional migrated formulas remains subject to an explicit numeric-equivalence decision. Contraction, finite inputs, subnormal handling, conversions and Bounds follow the qualified profile when used. No silent float substitution for fixed-point route/collision semantics.

## Player telemetry and simulation clock

- eZ80 owns player physics/rules at fixed 120 Hz. VDP owns opponent/effect physics and world-space collision checks at fixed 120 Hz. Rendering uses absolute 30 Hz deadlines, one per four simulation ticks, rather than a fastest-possible loop.
- A snapshot carries schema/session identity, sequence and simulation time, track position, lateral position, speed/orientation as required, engine RPM and player/recovery phase. These are field requirements, not a final packet size or mandatory transmission rate. Initial full state and sparse changed-field updates may be supported; incomplete or invalid updates never become a published snapshot.
- Receiving/command code is the sole packet parser and snapshot publisher. Game code reads an immutable complete snapshot, without blocking every physics/render step on receipt. Publication requires an agreed atomic copy/double-buffer/sequence protocol, not volatile fields alone. Retained buffer acquisition does not by itself prove cross-task safety.
- Timestamp alignment and the treatment of player motion between sparse updates remain open for Author review. Collision checks cannot be called correct merely because the latest stale position was readable. Interpolation, bounded prediction, stale-input timeout and resynchronization need a chosen policy and replay evidence.
- Timer callbacks only signal work. One firmware execution owner serializes bounded module entries and drawing. A receive task can continue assembling future snapshots; it cannot mutate module-owned state concurrently. Firmware must guard load/unload, queue saturation and native-service lifetimes.
- Render and simulation overruns are counted and reported. Define catch-up/backlog behavior without dropping physics silently or rendering a burst of stale frames. The prototype needs measured per-tick/per-frame worst cases; existing 44–47 fixture FPS does not guarantee 120/30 Hz operation.

## Collision notification and recovery

- VDP selects the struck opponent, manages its removal/explosion and keeps unaffected opponents moving. Opponent IDs/generations stay internal. Do not add an eZ80 opponent-identification requirement.
- Module code publishes a collision event into a retained, bounded event slot/queue. Firmware translates it into the established keyboard-packet callback transport. A proposed compact return payload is a four-byte signature, version/event bytes, a registration token and an event sequence (ten payload bytes; twelve with existing framing). Final encoding and token/sequence rollover/drain rules await agreement. No opponent ID or mandatory detailed collision telemetry is included.
- The foreground eZ80 handles collision occurred: save its current track position on notification, begin the preset countdown and resume according to the reviewed restart policy. The MOS interrupt handler only copies recognized events, neutralizes synthetic key fields and returns; real keyboard events remain intact.
- Latch the collision episode to prevent repeated countdown resets during persistent contact. Recovery-state telemetry acknowledges player handling; define whether/when retransmission is needed, duplicate rejection, bounded queue overflow and rearming. Session reset and callback teardown must fence late events before memory is reused.
- Countdown duration, resume speed/steering/invulnerability and struck-opponent reintroduction are open choices, not defaults inferred from historical crash code.

## Resource and lifecycle acceptance

The current SDK configuration has one active module; text <=8,192 bytes, data envelope <=4,096 bytes, package <=16 KiB, declared stack <=512 bytes, invocation arguments <=32 bytes and at most four live leases. These describe current tooling/validator behavior, not proven physical ceilings. The Author clarified that the 8 KiB recommendation is not a hard hardware limit; the actual limit is unknown and will be probed by the Author. RALLY-24 B's recorded text allocation is 7,016 bytes. Treat capacity as an empirical question; do not require module splitting solely to stay below the recommendation. Tooling/validator changes must accompany any larger admitted package and be qualified against the resulting capacity evidence. This clarification does not start a probe or authorize runtime changes. Place large immutable assets/state in retained buffers where supported; they still consume real VDP memory and access costs.

Copy invocation descriptors and release their lease before acquiring other views when necessary. Release all views on every normal/error return, with no retained raw pointer or temporary framebuffer ownership. Module completion, UART/parser completion, completed drawing and optical presentation are different boundaries. Loading must bind a fresh handle; stopping must quiesce timer work, drain invocations/events/drawing and unregister callbacks before unload.

## Parallel implementation and deliverables

| Delivery | Required agreement / artifact | Rally can then develop, after Author release |
| --- | --- | --- |
| D0 — compiler/interface identity | RGAP-001/007: selected source/hash, versioned layout/entries, arithmetic/error conventions | Manifest reader, initialized state, packet/schema checks and lifecycle stubs |
| D1 — indexed numeric kernel | RGAP-002/003: bounded collection/math prototype and independent cases | Route/contact reference, adapters and tick replay fixtures without claiming generated-code readiness |
| D2 — graphics composition | RGAP-004: helper/service binding, module composition and size/stack budget | World-state/render adapter and command/pixel cases reusing RALLY-24 |
| D3 — scheduler/snapshots/events | RGAP-005/006: runtime/firmware owner agreement and lifecycle/interface fixtures | Telemetry and recovery client; autonomous timing/collision integration only when services exist |
| D4 — actual joint qualification | Generated code and services replacing faithful stubs, fixed source/runtime identities | Measured end-to-end functional and timing evidence for review |

D0 pins the contract/baseline and a reproducible scalar artifact. D1 supplies indexed storage then faithful numeric primitives, exercised by eZ80-triggered bounded entries against independent Rally oracles. D2 links the retained renderer and qualifies combined resources/state/pixels. D3 requires a separately released firmware scheduler/snapshot/event implementation. D0/D1 use complete explicitly tick-aligned supplied snapshots or labelled synchronous fixtures; they do not qualify autonomous sparse-telemetry collisions.

Compiler layout/status semantics and stub behavior must match. A stub never serves as a compiler acceptance oracle calling the same code under test. Negotiation may amend these milestones; changes require explicit revision and provenance. No implementation begins solely because this planning agreement exists.

## Joint qualification plan — planning portion of GOL-000-11

| Acceptance case | Independent expectation / failure checked |
| --- | --- |
| Compiler/package identity | Correct compiler/source/ABI, one shared-source meaning across selected backends, no task-local/production mix-up |
| Index bounds and persistence | Six slots and first/last table entries, out-of-range writes rejected, no adjacent mutation, state retained across compatible lifecycle |
| Numeric edges | Fuji range, lap wrap, negative lateral values, route large intermediates, signed division/narrowing and precise failure effects |
| Route/contact replay | Fixed-step reference agrees across a full route cycle, near misses, overlaps, lap seams, spawn/despawn and unaffected-opponent motion |
| Sparse snapshots | Partial/out-of-order/stale/session-mismatched inputs, clock alignment and selected interpolation/prediction policy |
| Collision/recovery | Exactly one player recovery per episode, correct VDP opponent/effect state, duplicate/lost-event behavior, clean rearming |
| Module/lifecycle limits | Real combined ELF text/data/stack, bounded leases, load/init failure, no use after unload or event-after-return |
| Cadence and throughput | 120 Hz successful tick accounting, 30 Hz frame deadlines, measured tails/backlog/overruns, completed FPS and host/emulated/physical clock separation |
| Graphics/input | Known RALLY-24 parity exceptions resolved or explicitly reviewed; retained HUD/page histories and genuine keyboard behavior |

The joint qualification matrix remains future compiler/runtime/game acceptance. The released reference tranche performed host-only frozen C++/Python replay and adapter/stub checks, recorded in the integration map; these do not qualify Golem arrays/wide math, actual SDK invocation, autonomous cadence or firmware. Later implementation releases and Author gameplay decisions remain pending.

## Renderer-preparation and storage addendum — 2026-10-13

Golem D0 delivery-four was independently consumed as immutable bundle `b7a6be65ce06789e`, with actual default/relocated manifests and call exports verified. Golem subsequently reports Author visual/keyboard acceptance and committed publication through `1a1f303`; bundle identity unchanged. [Preparation results](renderer-prep/RESULTS.md) supersede earlier pending-delivery descriptions without mutating the published reference handoff.

D1a retained storage profile from `2026-10-13_17-19-49_golem_rally25-d1a-storage-profile-five` was accepted in Rally acceptance-thirteen: inclusive ascending uint16/sint16 arrays and indices with numeric meaning preserved; check index before RHS then single write; language 5 failure, ReadOnly declarations, typed Fill/Values or exact external packed initialization. Generated application-owned per-array buffers/descriptors supplement the manifest without changing root-v1's four roles; native range/access admission versus stock installation/lifetime invariant remains explicit. Initial 32767-element policy is not a physical ceiling. Wide source state/simulation remains undelivered.

The [R25-RENDER proposal](renderer-prep/HELPER-PROPOSAL.md) and Golem architecture/lease-budget-six establish architectural agreement only: native-only declared helper binding/intrinsic, one linked dispatcher, explicit buffered rejection, separate helper result/readiness and early return before root-success suffix on helper failure. Exact names/types/layout/source spelling/error mapping await TRF-001-14. D0 holds argument+root views; future composition should release copied argument before helper entry to target root+asset+output peak3 and qualify cleanup afresh. It is not already a D0 capability.

The Author accepts the existing final-scene99.36% Fuji/99.91% oval agreement for continued development and directed an end to further parity research. Preserve the measured differences and original oracles; the Author’s own later visual confirmation is the final visual gate. This does not grant visual acceptance of an unreviewed integrated game or establish a universal numeric tolerance. Later module/game/firmware release remains separate.

## Concrete helper tranche — 2026-10-13

Checkpoint `314efe6` freezes the reviewed renderer-preparation results and Author-released TRF-001-23–26 scope. [Isolated helper results](renderer-helper/RESULTS.md) now provide 9,120 ordinary/sanitized scene comparisons and 79 failure/lifecycle cases per build, with generated resource bindings and per-context state. [Current v0.3 proposal](renderer-helper/CONTRACT-V03.md) specifies the typed native ABI and compiler hook proposal; final Golem acceptance remains pending. Original v0.2 header/proposal are archived with their published hashes. No compiler-binding implementation or combined linking is implied.

Golem delivery-seven proposed a separate generated application-owned 48-byte completion buffer; Rally accepted that refinement. This avoids a non-source root footer and preserves root/global-byte semantics. Native helper completion is a local record; retained publication is separate and can fail after local helper ready. Runtime/interface/language/helper outcomes, matched completion and fresh root success are all required before drawing; publication failure skips root-success suffix. Retained ready alone never authorizes drawing.

The proposed private context grew from 84 to 464 bytes to move snapshot/actor scratch off the call stack. Host prepare frame dropped from 1008 to 496 bytes; these are individual host compiler frames, not native/composed chain proof. Target callbacks/generated callers, context/private data and text/admission require later qualification. No configured stack/text limit was changed or probed. The D1a array candidate bundle is received, not integrated or qualified by this helper work; wide simulation/recovery/scheduler/visual gates remain as above.

## Exact v0.3 acceptance

Golem acceptance `2026-10-13_18-34-30_golem_rally25-helper-v03-contract-accepted-eight` closes TRF-001-23/14 and supersedes pending-agreement text above. [Acceptance record](renderer-helper/ACCEPTANCE.md) plus the hash-verified current header/CONTRACT-V03.md are normative. No compiler flag, marshaling/linking implementation, generated JSON instance or combined native qualification is implied; later release remains required. D1a is owner-reported accepted/pushed as93bf1e4; first D1b foundation work is in progress, with multiplication/division/shifts/full replay later.

## Host invocation model and D1b candidate receipt — 2026-10-13

TRF-001-27–30 deliver a host C model under [integration-harness](integration-harness/README.md), not generated D2 support. It follows the accepted v0.3 contract, including return for SDK cleanup before publication on a helper release error; refused release cannot be assumed to have freed a lease. Fixture mapping JSON/source counters/copy-failure seams remain explicitly modeled, not additions to the shared compiler/SDK contract. Published original contract/handoff artifacts remain unchanged.

Golem candidate-nine supplies first D1b foundation bundle `94e72ff56649079472a59b33ae9ba1514b49dcb5c8c919ace369de6e46fb2c6a`. Rally verified only bundle.json identity and acknowledged receipt in nineteen; no independent122-file qualification, integration or acceptance is claimed. Candidate is uncommitted pending Author review; wide multiplication/division/shifts and full replay remain deferred. D2 remains unimplemented/unreleased by Golem.

## Later peer status — accepted foundation and multiplication candidate

Foundation human-accepted-ten records the Author's acceptance and publication authorization; local Golem history contains foundation commit `4a62c1d` and receipt checkpoint `d362376`. This supersedes the pending-review status of foundation candidate-nine without rewriting its immutable bundle. Multiplication-candidate-eleven reports checked uint32/sint32 multiplication with overflow language3, explicit operand widening and failed-store/earlier-effect semantics preserved. Bundle `964c43f564dfdca6165702f3d40da4d6e581a7202c7ce4c084c60418ce3477fc` identity matches; Rally receipt-twenty-one claims no independent qualification or acceptance. Multiplication remains uncommitted pending Author human review; divmod/shifts/helpers/full replay remain open. Golem hash-verified Rally's harness and confirms its release-refusal/publication/runtime draw rules agree with v0.3, with no ABI amendment. D2 remains unreleased.

## Later peer status — published multiplication and paired division candidate

Human-accepted-twelve followed by divmod-candidate-thirteen supersedes the multiplication pending-review/publication status above: multiplication is human accepted/published `1ddfd64`. Division bundle `cd0e922475d08ad4848ec6c044f4c4851cf0148a7b209b8f5fd095f75ec8ed5e` identity matches; Rally receipt-twenty-two claims no independent qualification/acceptance. It adds matching uint32/sint32 global paired divmod destinations (and existing uint16), arguments once left to right, alias support, both result Bounds before either store, signed quotient truncation, numerator-sign remainder, zero language4 and minimum-signed/-1 language6 with both outputs preserved. Signed16/array pair destinations, shifts/wider helpers/full replay and D2 remain separate. Candidate is uncommitted/pending Author visual review. Owner records one initially incomplete parallel default JIT run with no saved result/failure, then passing serialized JIT/interpreter checks; cause remains unestablished. Planned Rally scope retains the accepted foundation baseline; no later candidate is silently adopted.

## Independent generated-state host qualification — 2026-10-13

After pushed checkpoint `4489f58`, TRF-001-31–35 verified accepted D1a/foundation bundles (261files/44exported sources/six packages/five tool identities), actual generated metadata/images/cleanup and a Rally-owned six-slot/full-Fuji-range fixture. Actual pinned generated C passes2,924 host invocations across default/relocated layouts and ordinary/ASan+UBSan builds, with full root/array comparisons against independent expectations; [results](generated-state/RESULTS.md). No multiplication/division compiler was adopted. This advances storage and supported numeric host evidence without closing full TRF-001-12/13/backend/target integration or D2. The earlier helper/completion/draw contract and all published manifests remain unchanged. Golem's later human-accepted-fourteen records Author division visual acceptance, explicit commit/push approval still pending; receipt only, no independent division qualification.
