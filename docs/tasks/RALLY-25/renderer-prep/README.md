# Rally renderer preparation host fixtures

This is isolated host preparation for later native composition. Preserved R24 B commands match an independent frozen R22/R24 oracle; it does not run an emulator or qualify physical pixels/performance. Read [results](RESULTS.md) for limits, Author visual gate and remaining binding work.

From `/Agon/mystuff/AgonArcade`:

```bash
.venv/bin/python docs/tasks/RALLY-25/renderer-prep/d0_delivery.py
.venv/bin/python docs/tasks/RALLY-25/renderer-prep/fixtures.py
```

The D0 consumer needs the immutable peer bundle, exact committed source identities and pinned SDK/tools present on this host. It checks 76 bundle files, real default/relocated manifests, source/artifact/initial-root consistency and 20 named CALL exports; it does not transmit those CALLs. `parse()` and `named_call()` are the actual delivered-manifest adapter functions. Existing public root/reference/handoff files are imported without modification.

The scene harness needs host GCC/G++ with ASan/UBSan and repository Python. It exports exact committed R24 files to ignored `.work/renderer-prep/`, uses the already frozen pre-R27 headers/assets, and builds only there. It creates its own case/history/receipt JSON files after comparisons and clears old success files before a run. About 8–9 seconds covers compilation/setup plus execution on this development host; no target timing is inferred. The capacity/history checks are sanitized; the command comparison library is ordinary native host code. Private compiled scratch remains ignored; deterministic inputs/output hashes are retained in the published fixture data.

`parity.py` preserves the completed read-only analysis of old captures and matrix words. It is not a next work item: the Author accepted the measured scene agreement for continued development and stopped further pixel investigation, reserving their own visual confirmation as the final gate. Its existing receipt remains available for traceability. No renderer correction, new tolerance for unmeasured scenes, emulator or physical action is implied.
