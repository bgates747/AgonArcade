# C integration harness results

TRF-001-27–30 are complete at host-model scope. Both ordinary and ASan/UBSan runs pass 144 scene renders across two binding maps and 138 failure/lifecycle groups. All 72 canonical Fuji command sets match the independent pinned expectations; all 72 relocated sets match the independent resource decoder. The tranche returns for Author review with generated D2 integration and target qualification still outstanding.

[Master receipt](RESULTS.json), [ordinary receipt](ordinary-results.json), [sanitized receipt](sanitized-results.json), [replay/boundary ledger](README.md) and [C model](integration_model.c) identify the implementation and limits. The checkpoint before execution was pushed as `e94f0aa`. New harness/results remain uncommitted for review.

## Evidence

| Check | Result |
| --- | --- |
| Fuji snapshots | 72:32 preserved,24 boundary,16 sign poses |
| Binding maps | 2; buffer/resource relocation and entry permutation |
| Independent command checks per build | 72 canonical sets +72 relocated sets; three lists per set |
| Completion counts | Bands/cars/signs match pinned expectations for every rendered scene |
| Failure/lifecycle groups per build | 138, including every acquire/release callback boundary and both freeing/refusing release-error behavior |
| Ordinary versus sanitized command dumps | Identical for both maps |
| Mock maximum live views | 3; root+asset+one output; publication requires helper views closed |
| Normal lifecycle leases | No leftover leases or simulated emergency cleanup |
| Refused release | Nonzero failure; explicit mock SDK cleanup before another invocation |
| Root success and failure semantics | Source/helper/publication failures suppress suffix; earlier source/output effects preserved |
| Stale result checks | All status channels, session/request/tick, entry, lengths, readiness and fresh root generation; modulo generation/request/tick wrap exercised |
| Publication ready1 followed by failure | Copy/release failures rejected by draw gate; generation unchanged |
| Root release failure after suffix | Runtime failure rejects drawing even when generation advanced |
| Stop/reset/rebind | Stops prevent rendering; reset restores binding; failed reset invalidates old binding |
| Storage boundaries | Root metadata rejections, physically short root, wrong argument root ID and allocation canaries pass |

The copy-failure seam deliberately writes the entire local completion before returning an error, retaining resident ready1. It is a synthetic host fault used to challenge the draw gate, not an additional SDK callback. Helper release errors conservatively skip publication and return for SDK cleanup, following the accepted lifetime requirement. See the boundary ledger before using this model as integration guidance.

## Remaining integration requirements

Golem must deliver actual native-only binding parsing, typed source/array marshaling, context/completion installation, lifecycle hooks, early argument release, helper/publication error propagation and root-success ordering. Concrete generated field maps/JSON and changed wrapper handle offsets must be verified from that delivery, not inferred from this fixture schema. Replay these cases against the generated composition when separately released.

The source-effect sentinel is not opponent simulation. D1a has not been integrated here; the newly received D1b foundation candidate is identity-checked only and remains pending Author review. Multiplication/division/shifts and full simulation replay remain later dependencies. Native combined text/data/stack, SDK callbacks, firmware ownership/timers/transport and synchronized drawing remain unqualified. No game/compiler/SDK/firmware edits, combined-module link, emulator/hardware run, deployment, capacity probe or target performance/pixel claim was made. The Author's own visual confirmation remains the final visual gate once a later target candidate exists.
