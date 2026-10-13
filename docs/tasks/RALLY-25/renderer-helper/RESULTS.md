# Isolated renderer helper results — 2026-10-13

Reviewed preparation results and this tranche's scope were committed/pushed as `314efe6` before work. Rally's extracted helper passes all 9,120 preserved scenes in ordinary and ASan/UBSan builds, plus 79 failure/lifecycle/metadata cases per build. It supports generated buffer/graphics IDs and independent contexts without a dispatcher or hidden singleton. The exact v0.3 compiler/helper contract is proposed to Golem and remains awaiting acceptance; combined linking and a playable visual-review candidate are outside this tranche. New implementation/results remain uncommitted for review.

## Implementation and reproducible evidence

`rally_render.c` supplies finite bind/prepare/stop operations against SDK-v1 buffer services. `render_core.inc` is extracted from R24 B source SHA256 `8f37b406b2cc6ec2770548e041653fd39b5aeba8bd3003c6dd647530199e3473`, preserving fixed-point divisions, signed shifts, binary32 operation order and ordinary drawing semantics. The old 32-byte config/112-byte packet/SDK dispatcher are replaced by native typed inputs/context/completion. Bitmap/matrix IDs are bound inputs; sentinel 65535 retains its existing command meaning. Canonical projection assets are exported privately from the frozen R22 headers/tables and match the preserved hashes.

The C header asserts exact native layouts: bindings 76, state 108, six 12-byte opponents, completion 48/ready offset 44 and context 464. Context contains bindings, a copied coherent snapshot and private actor/order scratch; no pointer/lease is retained. All flags/ranges/assets/resources are validated before output. Bind verifies checksum and directory shape; prepare relies on the caller's immutable asset/allocation lifetime and reacquires validated views. No checksum scan is added to every frame. Normal presentation rejects nonzero historical effect counters; the reference profile only preserves old fixture behavior. New opponent explosion/recovery semantics remain undecided.

| Check | Ordinary host | ASan/UBSan host |
| --- | ---: | ---: |
| Fuji command comparisons | 6388 | 6388 |
| Oval command comparisons | 2732 | 2732 |
| Failure/lifecycle/metadata cases | 79 | 79 |
| Peak views including one simulated generated root | 3 | 3 |

Every command-list hash and bands/cars/signs count agrees with the published independent scene fixture. Additional cases relocate buffer IDs and bitmap/matrix IDs, checking resource operands through a separate VDU decoder, and interleave two contexts without interference. Failure cases cover bad ABI/schema/session/pose/flags, invalid resources/descriptors, asset identity/checksum, all acquisition/release stages, partial capacity writes with canaries, cross-ID and native-object aliases, safe disjoint ranges in one allocation, stop/rebind, request/tick wrapping and stale successful readiness followed by failure. Failure can leave output bytes/earlier effects changed, but ready stays false and errors remain separate from language arithmetic.

The mock also tests a callback refusing release: helper reports failure, invalidates context and does not falsely claim that lease was freed. Subsequent runtime entry cleanup is explicitly outside the helper. Leaving the argument lease live alongside root makes the intended 3-view limit fail; releasing it before helper entry is a real generated-glue requirement, not something this library can perform for the caller. Malformed completion storage returns without unsafe writes; a previous ready value in that invalid object is not success evidence.

[RESULTS.json](RESULTS.json) pins sources, libraries, compiler, exact fixture hashes and timings; [README](README.md) gives the single reproducible command. The harness recreates private assets and never mutates the published reference/preparation handoffs. No compiler-generated binding, SDK native execution, emulator, framebuffer or cadence is qualified by these host checks.

## Stack and ABI revision

Host static-frame inspection found 1008 bytes in prepare with local snapshot/actor scratch. The proposed context was revised from 84 to 464 bytes before acceptance, moving those value arrays into explicit private context storage. The same host compiler now reports 496 bytes for prepare, 176 for preflight and 240 for bind. These are **individual host frames, not complete call-chain maxima or ESP32 figures**; prepare plus preflight already requires more than 496, and callbacks/generated glue add further use. Target/composed stack and data/text admission still require actual native builds before linking/qualification. No 512-byte stack or 8-KiB text policy was changed, probed or asserted sufficient. The larger context counts toward combined private data. Original v0.2 files/hashes remain archived under `proposals/v02/`.

## Contract state and next boundary

Rally message `2026-10-13_17-49-57_rally_rally25-concrete-helper-contract-fifteen` proposed exact structures/functions, SDK-compatible errors, separate completion, native-only build hooks and generated metadata. Golem's D1a delivery-seven confirms reading/hash-verifying v0.2 and queues final review in GOLEM-037; it proposes a separate app-owned 48-byte completion buffer. Rally accepted that refinement in `2026-10-13_18-02-47_rally_rally25-completion-buffer-refinement-sixteen`, then sent the context-storage revision in `2026-10-13_18-06-47_rally_rally25-helper-v03-storage-seventeen`.

Current proposed details are in [CONTRACT-V03.md](CONTRACT-V03.md): preserve root-v1, use native locals/context, publish into a separately generated completion range after helper views close, and early-return before root success on helper or publication failure. Local ready marks helper success; retained publication can itself fail. Runtime/interface/language/helper results, matched completion AND fresh root successful-generation are all required before drawing. A ready bit alone is insufficient. `--native-bindings`, `after_source_before_success`, generated manifest/marshaling declarations and exact v0.3 acceptance remain peer decisions; these are not existing compiler flags. The concrete agreement is still TRF-001-23/TRF-001-14's outstanding portion.

TRF-001-24/25 are delivered; TRF-001-26 returns this implementation and evidence for review while the remaining contract reply is pending. Golem's immutable D1a array bundle has arrived and was acknowledged, but was not qualified or integrated in this helper tranche; wide state/simulation is a separate dependency. No combined-module link, game/firmware edit, deployment, capacity probe or further pixel research occurred. The Author's own visual confirmation remains the final visual gate after a later integrated candidate exists.
