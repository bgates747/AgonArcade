# GOL-000 — Current Golem suitability for Rally native VDPlets

Golem already compiles a bounded shared-language subset to actual native Xtensa VDPlets through generated C. The committed GOLEM-031 prototype is a credible foundation; production `src/golemc` is a different, smaller buffered compiler. Current functionality is **insufficient for the proposed complete component without extensions**: native indexed storage, wide fixed-point arithmetic, rendering/composition bindings, scheduling and event dispatch remain gaps. Recommend a bounded extension path with explicit prototypes and independent runtime work, rather than reviving RALLY-19 or assuming stock buffered support covers the native target. This is a read-only audit with existing evidence, not a new performance qualification.

Work-contract freeze: AgonArcade `f3196b9`, pushed 2026-10-13. Audit source identities and dirty-state boundaries are in [source-pins.json](evidence/source-pins.json). V0.2 is mutually accepted, confirmed by the Author and Golem's GOLEM-033 record. The Author subsequently released the first Rally D0/independent-D1 reference and host-scaffolding tranche. [Integration results](INTEGRATION-MAP.md) and [root-v1](ROOT-V1.md) record that bounded work; later game/firmware releases remain pending. The audit below preserves the original source state. The current D0 pin is now committed GOLEM-032 `25901e5`, verified in [dependency-receipt.json](reference/dependency-receipt.json); this supersedes its earlier uncommitted status without altering the original evidence snapshot. Arrays/wide math, actual D0 scalar artifacts and autonomous game/runtime qualification remain pending.

## Evidence and current baselines

| Reference | Observed capability | Qualification / limit |
| --- | --- | --- |
| Golem branch `feature/standardized-deployment`, commit `b37aa3c` | Committed accepted work through GOLEM-031; maintained compiler plus separate portable prototypes | Branch/HEAD alone does not identify the task-local compiler selected |
| `golem/src/golemc.cpp`, `resident_table.hpp`, `resident_drawing.hpp` | Buffered resident packages, table profile and drawing helpers | Not the native portable compiler; these profile features cannot be assumed composable |
| GOLEM-025 compiler/README | Shared typed source -> buffered output and native C -> loadable Xtensa package; named entries and packed persistent state | Task-local, production promotion explicitly outside its tranche |
| GOLEM-026 through GOLEM-031 | If/ElseIf, bounded literal Range, bool/short-circuit operators, paired uint16 divmod, checked sint16 and conversions | Parameterless named Subs; scalar globals; no native indexed collections or wide language integers |
| GOLEM-031 `portable.hpp`, `backends.hpp` | Explicit checked arithmetic, same-type comparisons and signed conversions; generated C uses wider implementation temporaries | A C temporary's int32 type does not give source-level int32 arithmetic; sint16 intermediate overflow still faults before later division/conversion |
| GOLEM-031 saved receipts | README records 14,912 host cases, sanitizer/ELF checks and actual Xtensa qualification; hybrid JIT receipt has 132 calls / 1,068 observations and zero reported backend faults | Existing receipts inspected, not rerun. Human review/commit acceptance recorded; no physical speed guarantee |
| GOLEM-032 prototype (owner-dirty at initial audit) | Binary32 + / - / *, comparisons and explicit integer conversions; native generated C and both-engine receipts | Human review was pending at the initial audit, then accepted; subsequently committed as `25901e5` for D0. No float division, trig, sqrt, floor, full IEEE exception/subnormal semantics, or promotion inferred |
| `agon-vdplet` commit `33a554c` ABI v1 | One loaded module, bounded native entry, buffer views, scoped PALETTE2 framebuffer | No arbitrary UART callback, timer/task scheduler or generic colour drawing service in host table |
| RALLY-24 experiment B | Native C geometry/scene generator using retained buffers and ordinary VDU rasterization | Existing qualified component, not Golem source or complete game; parity exceptions remain |

The broader `backend-portability.md` roadmap is an accepted language direction, not proof that all listed features are implemented. Use a pinned prototype/compiler export with a receipt; do not silently replace a task-local build with `src/golemc` or an owner-modified prototype.

## Requirements mapped to evidence

| Rally need | Status | Consequence |
| --- | --- | --- |
| Native VDPlet generation/loading | Supported in task-local compiler | No new native backend is needed from scratch |
| Persistent typed scalar globals, named bounded entries | Supported | Useful interface skeleton; shared state survives compatible backend changes, not arbitrary layout replacement |
| Branching and bounded six-slot iteration | Partial | Constant Range can iterate six times, but scalar globals cannot index six opponents without expansion |
| Opponent mutable collections, route/sine/track lookup | Missing in inspected native frontend | Buffered Table/Array functionality does not establish portable/native indexing |
| Signed positions, relative distances and Q8 intermediates | Partial, insufficient range | Existing sint16 and uint16 do not preserve the current game's units/semantics |
| Integer division | Partial | Paired uint16 divmod exists; signed/wide quotient and remainder contract is missing |
| Projection/rendering calls from Golem | Missing native binding | Existing renderer can be a candidate library/service, but supported compiler integration is needed |
| Autonomous fixed 120 Hz simulation and 30 Hz rendering | Missing runtime service | Native RUN currently blocks command processing until return; custom firmware scheduling needs design and owner agreement |
| Atomic sparse player snapshot + safe state ownership | Missing integrated service | Readable retained buffers exist; task publication, versioning and synchronization do not |
| Collision-only callback with VDP-owned opponent bookkeeping | Missing module/firmware integration | Existing Pingo transport is a reference, not a module UART service |
| Explosion state concurrent with continuing opponents | Partial primitives, missing integrated behavior | Must retain one simulation owner, bounded effect updates and explicit rearming/recovery |
| Package capacity and predictable execution | Unverified for combined game | Existing rendering and arithmetic proofs cannot be added as if capacity/timing were unlimited |

## Concrete numeric and resource evidence

- Fuji length is 32,768 world units. The current game stores hundredth-world-unit positions over `0..3,276,799`; even an unsigned 16-bit field is insufficient. A narrow field silently changing units would be a new physics contract.
- Route lateral integration evaluates `speed * 2 * sine / 12800`. A conservative existing operand example is `180 * 2 * 32767 = 11,796,120` before division. The source-language checked-16-bit intermediate fails even though a later reduced value can fit. Truncation toward zero, operation order and signed remainder must be explicitly preserved or reviewed.
- The native prototype's parser admits `uint16`, `sint16`, `bool` and, in GOLEM-032, `float32`; statement/expression trees have no indexed collection node, procedure call expression, source-level uint32/sint32, or drawing statement. Records and parameterized functions are not necessary as first extensions if typed arrays/SoA and bounded helper bindings cover the work.
- Float32 is not an automatic drop-in for the existing fixed-point renderer. Projection products, rounding, truncation, Bounds and route replay require an independent equivalence decision. In particular, uint16/sint16-to-float conversion support does not admit today's 32-bit game inputs.
- Current SDK tooling/validator configuration admits one active module, package <=16 KiB, text <=8,192 bytes, data+BSS/rodata envelope <=4,096 bytes, declared stack <=512 bytes, up to four simultaneous buffer leases and arguments <=32 bytes. These are implementation/admission policies, not established physical memory ceilings. The Author clarified that 8 KiB was a recommendation; the actual hard limit is unknown and the Author intends to probe it. Views/pointers expire at release/entry return. A native C address is not a transferable persistent buffer handle.
- RALLY-24's recorded B text is 7,016 bytes, leaving 1,176 bytes under the currently configured 8 KiB policy. That difference is not established hardware headroom and does not by itself justify splitting the renderer or declaring combined code infeasible. Measure combined compiler-generated simulation, renderer and dispatch and evaluate it against the Author's planned capacity-probe evidence. Repeated per-frame unload/load is not a suitable default. Options to review include link-time composition, a firmware-owned rendering service, or an explicitly justified runtime admission change.

## Enumerated gaps for the Golem/runtime owners

| Gap | Functionality requested and concrete use | Priority / proposed owner | Existing workaround and acceptance |
| --- | --- | --- | --- |
| RGAP-001 | Pin the supported portable native compiler and reproducible generated artifacts; select an immutable prototype baseline without ambiguity (current D0 selection: committed 032) | Blocking interface baseline / Golem | Task-local pinned export; compile receipts must identify source hash, shared layout, entries, backend, toolchain and ABI |
| RGAP-002 | Bounded typed indexing for six opponent states, six route records, 257 sine values and embedded track tables; read-only data + mutable SoA is sufficient initially | Blocking reusable gameplay / Golem | Expanded scalar code only as explicit temporary fixture; prove endpoint/out-of-range handling, indexed writes, persistent state and no adjacent corruption on both supported backends |
| RGAP-003 | Sufficient signed/wide numeric operations, intermediates and division to preserve game units and replay; explicit narrowing/overflow/truncation rules | Blocking faithful math / Golem; Rally supplies bounds/oracles | Reviewed helper binding or split representation could substitute for language types. Do not silently float-convert/wrap. Verify negative division, boundary positions, route loops and intermediate products |
| RGAP-004 | Bounded native helper/link interface to retained renderer and assets; specify composition with generated entry and package budget | Blocking full-scene integration / Golem + SDK + Rally | Firmware renderer service is an alternative requiring its own owner approval; combined ELF/admission/stack proof and actual target command/pixel comparisons required |
| RGAP-005 | Serialized timer/task-driven invocation, atomic player snapshots, time alignment, lifetime/cancellation and drawing ownership | Blocking autonomous design / custom VDP/runtime | eZ80-triggered synchronous calls can test entries but do not satisfy autonomous scheduling. Validate 120/30 Hz, telemetry while drawing, backlog/overrun and clean teardown |
| RGAP-006 | Module event publication and firmware collision-only keyboard packet, sequence/session/recovery latch | Blocking crash behavior / custom VDP/runtime; Golem exposes state writes | Retained event mailbox + firmware dispatcher avoids unrestricted module UART. Verify one recovery per contact episode, unaffected opponents/effects, duplicates/stale events and no real-key contamination |
| RGAP-007 | Versioned common packet/state/entry layout, bounded admission, separate language/runtime status, resource and integration receipts | Blocking parallel coding / joint ownership | Host stubs only against agreed semantics. Failure must not be treated as successful tick completion; entry language errors preserve prior effects today and are not transactional rollback |

Priority does not mean the Golem agent must own every gap. Scheduler/transport/firmware work is distinct from compiler implementation. Capacity probing is planned by the Author; no probe or tooling-limit change is authorized by this clarification. No native-only language dialect is selected by this audit; the accepted common-source/backend-portability direction remains relevant.

## Recommendation and parallel work

Proceed to review with a **usable foundation requiring bounded extensions** recommendation. Prefer typed indexed state/data, faithful wider arithmetic or explicitly specified helpers, and a narrow composition interface over a broad language rewrite. Preserve existing arithmetic/error semantics. The v0.2 terms select storage first, explicit wide arithmetic, one linked native module and separately released firmware services. Concrete task items are in RALLY-25. V0.2 is accepted and the first Rally D0/independent-D1 tranche is released; later integration/gameplay/firmware releases remain pending.

After the Author releases implementation and the relevant prototype contracts are agreed, Rally can build host-side packet codecs, independent route/contact models, adapters and explicitly labelled stubs; Golem can deliver compiler/native artifacts behind those interfaces. Firmware ownership and services must be agreed separately. Runtime availability, visual correctness, timebase behavior and full-game performance remain independent acceptance gates.

Open Author choices for the later review include player-state interpolation/extrapolation between sparse updates, recovery countdown/restart policy, steering/grip timebase, and any resource/interface tradeoff the owners cannot resolve. The current tranche does not invent answers to those gameplay questions.

## Mailbox provenance and acceptance state

Thread `rally25-golem-native`, branch `native-v1`, participants `rally` and `golem`, in the canonical `agentcoms` mailbox. Published messages:

- `2026-10-13_14-40-46_rally_rally25-capability-contract-one`: authority boundary, capability inquiry and required functionality.
- `2026-10-13_14-42-56_rally_rally25-gap-prototype-two`: RGAP-001–007, numeric/resource evidence and proposed ownership/interface negotiation.

- `2026-10-13_14-50-00_rally_rally25-audit-draft-three`: full report/contract handoff and explicit request for baseline/interface agreement or counterproposal.

Initial audit drafting preceded the peer response. Golem subsequently proposed v0.2 in `2026-10-13_15-06-37_golem_rally25-counterproposal-one`; Rally accepted every clause in `2026-10-13_15-12-37_rally_rally25-contract-v02-accepted-five`. These are promoted into the prototype contract. The Author and GOLEM-033 confirm mutual acceptance. The later explicit first-tranche release and delivered host references are recorded in the integration map; planning acceptance alone did not imply delivered compiler/runtime functionality.

Capacity clarification was sent as `2026-10-13_14-53-38_rally_rally25-capacity-clarification-four`, replying to the draft handoff. Earlier mailbox messages are immutable; this correction supersedes any physical-limit interpretation.

At the acceptance checkpoint, the owner’s GOLEM-032 README recorded accepted human review with 637 observations / 6,289 bytes and pending commit approval. That code was subsequently committed/pushed on Author direction as `25901e5` and exported for D0. The original source-pin receipt is preserved as the initial audit snapshot; later owner changes are not silently substituted into it.
