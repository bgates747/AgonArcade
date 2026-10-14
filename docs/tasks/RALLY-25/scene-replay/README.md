# Host simulation-to-renderer replay

The actual generated Rally simulation now feeds the unchanged accepted renderer through a typed host adapter. Each of four variants passes 3,600 simulation ticks, 900 independent command comparisons and 30 failure/lifecycle cases. This provides an end-to-end host workload for capacity and D2 development; the renderer wrapper/publication remains modeled, and no combined target module, real-time cadence or visual acceptance is claimed.

From the repository root:

```bash
.venv/bin/python docs/tasks/RALLY-25/scene-replay/verify.py
```

The verifier checks all six previous published manifests and the accepted immutable right-shift compiler export, builds that compiler in Rally's ignored workspace, and regenerates the exact earlier route packages. It requires every generated source/layout/installation hash to match the preserved route-kernel receipt. The helper and previous C integration model are compiled unchanged with [bridge.c](bridge.c). A separate sanitized C++ oracle is exported from Git `d250f43` and built against the frozen R22 headers; no helper code is linked into it.

The fixture creates output directories under `../.work/scene-replay/`. Each ordinary/sanitized default/relocated run writes `simulation.jsonl`, `reference.bin`, `states.bin`, `commands.bin` and `frames.json`. The first is a per-tick world trace; reference states are the old 112-byte oracle packets; mapped states are native 108-byte accepted helper values. Each command frame has six LE u32 values (three list lengths, bands, cars, signs), followed by road/actor/player lists. These are ordinary VDU commands, not a new transport format. The master/variant result receipts record all sizes and SHA256 values. Older master receipts are removed before replay; successful results cannot be inferred from an earlier run.

The reusable package is [REPLAY.json](REPLAY.json), [fuji-reference.bin](fuji-reference.bin) and [FIELD-MAPS.json](FIELD-MAPS.json), plus pinned source/assets/scripts. Reference data is 100,800 bytes for 900 frames. Commands and detailed traces remain in the ignored run directories, with identities in [RESULTS.json](RESULTS.json). Replay rewrites result/package receipts; keep the published manifest as the historical snapshot rather than editing it to conceal a new run. No earlier published receipts are regenerated or modified.

## Real and modeled boundaries

| Component | What executes here | Qualification still needed |
| --- | --- | --- |
| Tick120 source | Actual generated C from the accepted compiler and unchanged Rally route kernels | Actual stock/Xtensa game execution and complete traffic lifecycle |
| Input sampling | Supplied complete player snapshots; independent frozen model computes expected worlds | Real eZ80 producer, sparse telemetry and clock alignment |
| Field adapter | New C reads actual generated global/array metadata through SDK-service views | Golem's actual source-field glue and generated binding declarations |
| Rendering | Exact accepted helper C/context/asset data | One combined target module, resource admission and services |
| Render wrapper | Previously qualified C integration model with its own synthetic root/source-effect sentinel | Actual generated Render30 hooks and root-success/publication ordering |
| Completion/owner | Separate retained record, observed errors, matched identity and fresh modeled success; serialized test owner | Runtime transport, quiescence, cancellation and synchronized drawing owner |
| Oracle | Frozen independent R22/R24 C++ command emitter and independent Python world reference | Target raster/HUD/page execution and Author visual confirmation |

The two roots are an explicit test arrangement: one belongs to the actual generated simulation; the other belongs to the modeled renderer wrapper. They are not a proposal for two production modules or two application roots. They let us exercise actual simulation/helper state flow while leaving Golem's D2 composition ownership intact. No modeled Render source counter substitutes for actual physics. Future D2 must join them behind one real dispatcher and publish root success only after successful helper/completion handling.

The same host service registry owns every buffer and serializes phases. Actual simulation closes argument/root/array views before adapter entry; mapping holds source root plus one array at a time; those close before rendering, where the model holds renderer root plus asset and one output. Publication occurs afterward with renderer root plus completion. Peak observed views are three. Normal paths require no emergency cleanup. A deliberately refused completion release separately records one lease reclaimed by explicit mock SDK-entry cleanup; it is never credited as a successful helper/glue release.

## Field map and heading provenance

[FIELD-MAPS.json](FIELD-MAPS.json) records the actual generated offsets/IDs/types for `worldTick`, `routeHeading`, `playerStation`, `playerLateral`, and the `active`, `position`, `lateral` arrays. [bridge.h](bridge.h)'s `SceneLayout` is local host FFI metadata, not the future Golem JSON schema or UART packet. C validates shape/range, source result/status/success session/entry/generation/tick, coherent array shapes and admitted state domains. Fixed bindings/allocations and all native object lifetimes remain immutable while invoked; the fixture provides serialization rather than claiming leases synchronize concurrent publication.

R22 `race_traffic.hpp::place()` copies the shared pace cursor into each active car. R22 `game_scene.hpp` applies the alternating slot sign to that cursor heading; accepted `render_core.inc` does the same. Consequently every active renderer input receives the same raw shared `routeHeading`. The adapter must not negate odd slots a second time. Inactive inputs are entirely zeroed even though their retained simulation positions/laterals may be old. Positions are normalized hundredths; lateral remains signed Q8; heading is signed16 turn units after checked narrowing. Active positions/laterals and the shared heading are validated against the accepted helper domain.

Player station/lateral come from actual generated source globals after the fourth tick. Request/session/generation/tick observations belong to the host invocation owner. Phase, steering and draw flags are supplied presentation inputs; legacy counters stay zero under NORMAL. The adapter changes no helper ABI, source units or recovery behavior.

## Replay and frame ownership

The centerline player starts 30,000 hundredths before the Fuji seam and advances by the next frozen route-record speed, matching traffic pace. Initial opponent gaps are 0, 3,199, 3,200, 6,400, 18,000 and 80,000. The fixture deliberately includes near/contact geometry and visible traffic; contacts are observed, with no damage, removal or countdown logic. At tick 1,801 a supplied active mask disables odd slots; this is an explicit fixture input change, not a new despawn/reintroduction policy. Renderer-only rebind occurs before frame 451 while simulation continues.

All 3,600 ticks compare retained active/progress/position/lateral/contact arrays and meaningful shared route state with the independent model. Every fourth tick maps state, checks all 108 typed bytes against an independently encoded reference snapshot, prepares commands, publishes completion, passes the fresh draw gate and consumes the output before reuse. Every 900-frame command stream matches the independent C++ oracle, with relocated graphics IDs checked through the previously qualified independent VDU decoder. Ordinary/sanitized world/state/command artifacts match for each layout. Both layouts produce identical world/reference/state files; command differences reflect resource relocation only.

The test owner also revalidates source identity/state at the draw gate, catching physics work or source mutation after preparation. This is host qualification logic, not production checksum machinery or a requirement to read all arrays twice in future glue. Synthetic completion copy failure can leave ready1, and publication release failure can leave ready1 plus an unreleased lease; observed failure and unchanged success generation reject drawing in both cases. Failed source arithmetic, stale proofs and non-four-tick cadence attempts also cannot reuse old output.

Thirty seconds is simulated time at the proposed tick convention: no wall-clock timer, VBlank pacing or runtime scheduler executes here. Host run durations are verification times, not Agon FPS. The player producer is supplied input, not migrated eZ80 physics. This package does not include complete sprite/HUD/sky installation or a deployable/visually reviewable game. Golem's separately authorized capacity Stage A remains responsible for its resource proposal; real D2 glue, revised limits, full composition, firmware services and Author review remain later gates. Existing pixel exceptions are preserved and no further raster research was done.
