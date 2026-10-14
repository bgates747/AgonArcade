# Rally C integration harness

This host C harness exercises the accepted v0.3 helper through modeled invocation-owner and generated-glue boundaries. It provides lifecycle/publication failure checks and 72 portable Fuji snapshots with independent command expectations. It prepares D2 integration; generated Golem glue, a target package and a visual candidate are still required.

From the repository root, replay with:

```bash
.venv/bin/python docs/tasks/RALLY-25/integration-harness/verify.py
```

The script builds ordinary and ASan/UBSan C executables, creates its own output directories and writes command dumps under `../.work/integration-harness/{ordinary,sanitized}/map-{0,1}.commands`. Each dump is ordered by scene, then road/actors/player; each list has a four-byte little-endian byte count followed by ordinary VDU bytes. It also replaces this directory's ordinary/sanitized/master result JSON files after a successful run. Failed runs cannot leave an old master receipt looking current. Existing published helper/preparation/reference receipts are read only.

The supplied SDK header is read from the sibling `agon-vdplet/include`; no SDK modifications are needed. Source and tool identities are in [RESULTS.json](RESULTS.json). Replaying will change elapsed-time/executable receipts; preserve the published [manifest](MANIFEST.json) as a historical snapshot rather than editing it to conceal a changed run.

## Model boundaries

| Component | What runs here | What still requires D2/target qualification |
| --- | --- | --- |
| Renderer | Exact accepted helper C/header and private context | Linked Xtensa code, stack/admission and firmware calls |
| Source execution | Explicit counter effect at fixture globals offset112; optional language failure | Real Golem source, field/array marshaling and arithmetic |
| Entry/root bindings | Fixture-provided IDs, packed root-v1 envelope and four fixed descriptor ranges | Actual generated manifest/installation and wrapper code |
| Lifecycle glue | Init/Reset bind, Render prepare, Stop stop after source and before success | Compiler hooks and one combined native dispatcher |
| Invocation owner | Ready clearing, observed result, matching completion and fresh root generation | Actual transport, cancellation/drain and synchronized drawing owner |
| SDK services | Host buffer/range/overlap checks, three-view admission and injected callback failures | Real SDK views, entry cleanup and concurrency/lifetime guarantees |
| Publication | Separate 48-byte completion copy and acquire/release failures | Generated publication code; copy-failure seam is synthetic, not an SDK API |
| Scene drawing | Independent VDU byte hashes/resource relocation decoder | Actual rasterization, HUD/page history, installed artwork and Author visual acceptance |

The host mock writes `runtime_result` after observing return and explicitly performs simulated SDK entry cleanup. These are owner operations, not compiler writes. Successful normal paths require no cleanup of leaked leases. Failed release tests separately record the need for cleanup; they do not credit helper/glue with freeing a refused lease.

The model conservatively returns for entry cleanup on any helper release error before attempting publication. This follows the accepted requirement to resolve a failed release before continuing: it cannot assume that a nonzero release result freed the view. Resident failure diagnostics may therefore remain old with ready cleared; observed runtime failure prevents drawing. On other helper errors, a safely obtained local completion may be published, but root success remains unchanged.

Publication release failure may leave resident ready1. A later root-view release failure may occur after the root-success suffix has already run. Both remain failed invocations: observed runtime status prevents drawing. The model promises no rollback of output bytes, source effects or already-written success fields.

`model_can_draw` requires the next modulo-32-bit generation relative to the serialized invocation's saved generation, successful observed/root runtime, interface/language/helper/service status, the Render entry, matching session/request/tick and valid output lengths. This exercises wrap without inventing a production episode/session policy. Buffer identities and allocations remain fixed while bound; no live remapping or concurrent scheduling is modeled.

## Portable Fuji package

[fuji/scenes.json](fuji/scenes.json) holds 32 preserved poses, 24 boundary poses and 16 sign poses selected deterministically from the frozen 9,120-scene set. Each includes the original reference packet, an explicit 108-byte little-endian helper fixture encoding, hashes, output-list hashes and expected band/car/sign counts. The fixture encoding is local test data, not a new telemetry packet. Replay verifies each expectation against the original pinned scene entry before running the candidate.

[fuji/fuji.r24](fuji/fuji.r24) is the exact pinned 149,518-byte Fuji geometry/lookup asset blob. [fuji/mappings.json](fuji/mappings.json) supplies two host-only binding maps: relocated buffer/resource IDs and permuted entry IDs exercise independence from historical constants. This JSON is expressly not the future Golem D2 binding schema. The first map retains canonical historical resource IDs solely to compare independent expected bytes; the second is checked through an independent ordinary-command relocation decoder.

The ordered fixture stops/resets midway, renders every supplied snapshot and ends with Tick/Stop rejection of drawing. It is a synchronous scene sequence, not a paced game/demo or a 30-second benchmark. Source artwork, sky/HUD/page integration, generated glue/installation and actual target admission must accompany it before target or visual review. The Author's own visual confirmation remains the final visual gate. No further pixel research is included.

`--create-package` exists only to reproduce the original package from the pinned Git asset exporter and reference inputs. Normal replay consumes and verifies the saved package and does not rebuild assets or rewrite scenes.
