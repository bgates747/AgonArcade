# Rally independent references and D0 host scaffolding

This directory supplies pinned historical route/contact/lookup expectations and a labelled root-v1 host adapter. Python and frozen C++ agree under ASan/UBSan. No Golem feature, runtime scheduling, emulator behavior or physical performance is qualified by these host results. See [integration map](../INTEGRATION-MAP.md), [numeric requirements](../NUMERIC-REQUIREMENTS.md) and [accepted root](../ROOT-V1.md).

From `/Agon/mystuff/AgonArcade`:

```bash
.venv/bin/python docs/tasks/RALLY-25/reference/verify.py
.venv/bin/python docs/tasks/RALLY-25/reference/check_adapter.py
```

The first command needs a host C++17 compiler with address/undefined sanitizers, the pinned Git commit and preserved `.research-cache/rally22/builds/` archives. It verifies archive/source hashes, exports frozen sources to ignored `.work/reference/r22/`, builds a test-only observer there, compares every state row and generates the published JSON. It takes approximately seven seconds on this development host; no target timing is inferred. The second command runs nine host adapter tests in milliseconds. No emulator, network machine or bench is used by either command.

`model.py` imports no game/generator code. `oracle.cpp` includes the pinned C++ headers, observes their state and exposes the real lookup evaluator. `tables.json` preserves actual generated route/sine/track constants. `vectors.json` gives the complete 600-tick route cycle, contact/spawn cases and compact scenario checkpoints; scenario inputs and full-stream hashes allow replay of all 192,000 traffic ticks. Tick input is a complete supplied player state. There is no sparse telemetry reconstruction.

`numeric.py` uses unbounded integers and explicit C-style quotient/remainder to emit `numeric-vectors.json` and conservative `numeric-ranges.json`. Route extrema are enumerated; other bounds are explicitly classified. Future checked-arithmetic/conversion failure vectors use semantic labels until Golem freezes error codes. Actual lookup poses are checked against frozen C++; future Golem primitive support is not claimed.

`root_adapter.py` accepts a normalized internal `Interface` with caller-supplied entry IDs/bindings. It deliberately defines no compiler JSON manifest schema. Its `stub_invoke` runs a supplied fake source body and simulates declared/native-range guards, status handling and success publication. It neither acquires real leases nor calls native code. `require_success` requires an independently observed transport/runtime result; an unavailable result is never silently treated as zero. Buffered completion needs a separately agreed observation policy. `runtime_result` in the root remains host-owned; the wrapper leaves it untouched. Tests use synthetic nonsequential IDs, not production reservations.

`inputs.json` pins game/archive lineage; `dependency-receipt.json` records the verified Golem source export while explicitly listing missing D0 artifacts. Verification JSONs record counts/hashes and host-only scope. `handoff-manifest-v2.json` is the current package manifest; `handoff-manifest.json` preserves superseded revision 1. The current manifest lists final files and hashes so the peer can detect later mutation. Re-running checks refreshes elapsed-time receipts; publish a new handoff revision if any pinned artifact changes after delivery. Generated `.work/` and Python caches stay ignored.
