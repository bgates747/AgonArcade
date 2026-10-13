# Rally isolated native renderer helper

The extracted C helper reproduces the preserved R24 B command lists and uses an explicit caller-owned context, typed snapshots, generated buffer/resource bindings and separate completion. [Results](RESULTS.md) record host qualification and remaining compiler-contract work. It is not a playable game or a linked Golem module. The Author's own visual confirmation remains the final visual gate; no pixel research is performed here.

From `/Agon/mystuff/AgonArcade`:

```bash
.venv/bin/python docs/tasks/RALLY-25/renderer-helper/verify.py
```

The script requires the repository Python, host GCC/G++/ASan/UBSan, SDK-v1 header, frozen pre-R27 Git commit and preserved R22 build archive. It recreates exact assets privately from the pinned exporter, compares them against preserved preparation hashes, compiles ordinary/sanitized helper libraries and runs all 9,120 scenes plus 79 failure/lifecycle/metadata cases per build. Expected outputs are the already-published independent fixture hashes; the helper does not generate its own expectations. Resource relocation uses a separate command decoder. No existing handoff/source file is regenerated or modified. Compiled scratch lives under ignored `.work/renderer-helper/`.

The run clears prior result JSONs first and produces `ordinary-results.json`, `sanitized-results.json` and final `RESULTS.json` with source, library, asset-exporter, fixture and compiler identities. Only the final master receipt establishes a completed run. Ordinary and sanitizer execution take roughly one and two seconds respectively; setup/compilation adds several seconds, recorded separately by the total host duration. No target frame rate, stack admission, drawing completion or physical timing is implied.

`rally_render.h` is the current proposed v0.3 native ABI: 76-byte bindings, 108-byte state, 48-byte completion and 464-byte pointer-free context. `rally_render.c` owns validation/lifetimes/failure publication; `render_core.inc` preserves the native B math and command ordering while using typed inputs, bound resource IDs and per-context scratch. `asset_meta.inc` is checked against the pinned R22 exporter. All retained allocation/asset identities remain stable while bound; calls/drawing have one serialized owner. Views never persist past an entry.

The C helper returns an SDK-compatible result and a separate helper reason/service result. Valid completion storage is cleared on entry; success ready is written after all output generation and releases. A failed release invalidates context and remains a failure; a callback that retains the lease requires SDK entry cleanup. Invalid native object/shape preconditions can return without writes, so callers must check return/status rather than read a ready bit alone. Runtime rejection before helper entry likewise needs the invocation-owner readiness clear.

Golem's separate application-owned completion buffer refinement is included in [CONTRACT-V03.md](CONTRACT-V03.md). Exact compiler/build binding acceptance is pending; no `--native-bindings` implementation is claimed. Original v0.2 proposal/header are archived byte for byte. Native stack/resource admission, generated glue and combined linking remain later work. The historical presentation profile exists only to replay old crash/invulnerability cases, not to decide new gameplay recovery.
