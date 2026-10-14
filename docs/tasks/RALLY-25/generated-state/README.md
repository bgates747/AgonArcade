# Generated Rally state qualification

This tranche replaces the earlier modeled source/storage with actual C emitted by Golem's accepted 32-bit foundation compiler. A Rally-owned source fixture represents six slots, full-range Fuji station/lateral values and exact route/sine tables; independent Python expectations check every root and array byte after each invocation. This qualifies a host integration surface, leaving complete numeric simulation, renderer composition and target services for later work.

Replay from the repository root:

```bash
.venv/bin/python docs/tasks/RALLY-25/generated-state/verify.py
```

The script verifies the two immutable sibling Golem deliveries, copies their exported foundation source into Rally's ignored `../.work/generated-state/foundation-source/`, compiles that exact source and generates default/relocated fixture packages there. It never runs Golem builders in their repository or reads its latest compiler as the execution baseline. `g++`/`cc`, the sibling SDK header, and the recorded tool installations must match the receipt. SDK sources/tools are read only.

Generated packages, C/shared libraries and repeated-generation controls live under `../.work/generated-state/`. Every generated `.json/.inc/.bin/.c` artifact has its size/hash recorded in [RESULTS.json](RESULTS.json). This source/table/script package regenerates them; the large private buffered-program installation is kept in the ignored work directory. Result files are created automatically: [dependency receipt](DEPENDENCY-RECEIPT.json), [ordinary](ordinary-results.json), [sanitized](sanitized-results.json) and the master receipt. The script removes older receipts before a new run so a failed run cannot reuse an old master result. Replay changes elapsed-time/library identities; the published manifest is a historical snapshot.

## Inputs and independent expectations

[fixture.golem](fixture.golem) is Rally-owned qualification source. Its finite named Subs have familiar lifecycle names but do not perform game physics, drawing or scheduling. Init/Stop changes a running flag; Tick increments a counter; Render reads four slot fields; Reset deliberately overwrites six slots from supplied fixture inputs. Those reset values are fixture semantics, not a decision about player recovery or opponent reintroduction.

[adapter.py](adapter.py) consumes the actual generated root/interface/backend metadata and retained images. It validates source/global coverage, array names/types/IDs/offsets/counts/inclusive bounds/permissions/ownership, wrapper mappings, common and array initialization, and cleanup ownership. Its installation decoder supports generated CLEAR/WRITE packets only. It defines no new Golem JSON or UART schema. Actual compiler metadata supplies every state/buffer/entry offset and ID.

[oracle.py](oracle.py) hand-defines the authored fixture's semantics using unbounded Python arithmetic and explicit checked widths/Bounds. It imports no Golem AST, reference machine or emitter. [host.py](host.py) exposes persistent bounded/canary-protected buffers to the actual generated C through ctypes SDK callbacks. Expected state is never installed over the actual arrays between invocations. The driver writes only test input globals/wrapper metadata; after each return it compares every root/array byte against an independent expected copy.

Mutable array initial images are checked against the authored Values/Fill literals. Scalar declarations/types/initial literals are checked using a separate restricted declaration reader. Read-only [routes.bin](routes.bin) and [sine.bin](sine.bin) are packed directly from the original [tables](../reference/tables.json): six exact four-field route records and257 sine values. Both generated installation bytes and every table lookup are checked against those pinned inputs.

[binding inputs](bindings.json) use generated allocator reservation prefixes and four explicitly labeled role-range placeholders. These roles test admission only, not a player/table/event wire payload. Actual source tables are separate generated retained arrays. The relocated package changes both fixed role IDs/offsets and generated root/array/private IDs. Root-v1's four roles remain unchanged; no bindings are edited while in use.

## What is and is not qualified

| Boundary | Evidence here | Later qualification |
| --- | --- | --- |
| Delivery identity |261 files,44 exported sources versus published commits, six packages/installation images, five local tool hashes | Owner target/human evidence is recorded rather than rerun |
| Source compilation | Actual accepted exported compiler generates fixture C/metadata/initial data; repeat generation identical | Multiplication/division compiler pins remain separately selected dependencies |
| State/units | Six slots; stations0..3,276,799; signed Q8 laterals±38,400; signed headings; narrow active flags | Tick120 physics, collisions and full route/contact replay |
| Retained tables | Exact24 route fields and257 sine entries, first/last and invalid access | Arithmetic that consumes them in real route/projection kernels |
| Arithmetic | Supported add/subtract, six comparisons, integer casts/Bounds and explicit widening order; published independent vector subset | Wide multiply/divmod/shifts/wider helpers and their joint replay |
| Lifecycle | Actual repeated C calls; FINI/INIT; generated private cleanup ownership preserves arrays/root | Actual stock execution, firmware cancellation/drain and combined module lifetime |
| Failure effects | Index before overflowing RHS, failed destinations/elements unchanged, earlier effects retained, root success suppressed | Concurrency/event/snapshot policies and D2 publication glue |
| Resource views | Mock peak3 is argument+root+one array, no leaked leases | D2 must release argument before helper; actual combined native memory/stack/admission |

The fixture has no renderer helper linked. Ordinary versus sanitized complete-state digests match for each layout; full-state digests differ across relocated layouts because root bindings contain different IDs. ctypes uses the host C/pointer ABI, not an Xtensa execution engine. Native memory sanitizers cover generated C accesses; the mock also checks lease ranges, permissions, canaries and balanced granted leases. It counts rejected acquisition attempts separately. Physical fault cases advertise missing/short/long/busy buffers without pretending the mock is the real SDK.

The source-independent conversion vector set contains two input values outside all delivered source32-bit domains; these are explicitly deferred, not coerced. Identity cases use explicit same-type casts. No float substitution, implicit widening, rollback, autonomous cadence, physical FPS or pixel claim follows. Earlier renderer manifests/oracles and the Author's final visual gate remain preserved.
