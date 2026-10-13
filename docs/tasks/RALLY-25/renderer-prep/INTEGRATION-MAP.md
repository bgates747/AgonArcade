# Renderer preparation map — TRF-001-18

The retained R24 B command generator can be prepared as a native helper in one generated Golem module. It is not a drop-in root-v1 module: its argument/config, world-state, completion and lifecycle protocols differ. No game release or shared runtime code was changed here. The mapping below and accepted architecture identify what later composition must supply; actual field layouts and bindings remain D2 work.

## State and services

| Preserved R24 input/service | R25 integration destination / owner |
| --- | --- |
| SDK BIND/PREPARE entries, 32-byte `R24A` arguments | One generated dispatcher with named InitRace/Render30/ResetRace/StopRace; SDK arguments remain the two-byte root-buffer ID. Helper bind/prepare/stop remain bounded C operations, not another loader/module |
| 112-byte `R24S` world-state input | Typed native render view assembled from coherent completed Golem simulation state and complete player snapshot. The accepted 112-byte root header is unrelated to this old packet. Never overlay either representation |
| Six opponent position/lateral/heading records | VDP-owned retained SoA after the array/wide milestone. Marshal inside the module; eZ80 no longer supplies opponent render state |
| Player position, phase, lateral, steering, visibility/perspective flags | eZ80-owned player/rules state, supplied through the later reviewed snapshot service; normalized track domain and fixed-point units already specified. Render preparation does not choose sparse prediction or final packet offsets |
| Track asset blob with ten tables | Validated retained projection lookup/tangent/band/material/bearing/heading data; immutable view IDs and directory lengths generated at installation |
| Simulation route/sine tables | Root role 3 plus generated array descriptors under the accepted storage profile; these are distinct from the old projection table blob |
| Resident car/sign artwork and matrices | Root role 4 asset-directory metadata identifies installed resources. R24 references five views per livery, signs and affine matrices; no repeated pixel upload from eZ80. Recorded numeric IDs are historical allocations, not assignments for R25 |
| Full-game scrolling sky bitmap, fonts, panel/HUD resources | Required full-scene resources beyond the benchmark's road/car/sign set. Preserve the frozen R22 sky bitmap100 and font/page behavior as reference; regenerate actual IDs/reservations through the integration manifest |
| Old 32-byte ready/status record | Separate generated helper result/completion record with matched session/request/simulation generation, three output lengths and ready published last. It is neither collision-event role 2 nor host-owned runtime_result by convention |
| Road / actors / player command buffers | Three generated retained output views, consumed only after matched success. Old capacities 20480/2048/256 bytes are fixture allocations, not proven minimal final capacities. New host maxima are observations, not universal bounds |
| Old player crash/invulnerability counters | Historical reference presentation only. New countdown/restart and struck-opponent explosion/reintroduction remain later Author/VDP ownership decisions; do not adopt the old 150/120 limits automatically |

## Drawing and lifecycle

Retain ordering: scenery and active viewport; road/finish line; depth-merged traffic/signs; player/effects; panel/HUD; swap; advance page history. The current native helper generates only the three road/actor/player lists. Scrolling sky, HUD/panels, audio and game rules are additional full-game integration work, not implicitly implemented by linking it.

Caller-owned clipping must protect the top HUD (24 rows) and active panel sky region (88 where applicable). Sign draws temporarily select the road viewport and then restore the caller's region. Activate the viewport with the existing MOVE convention. Each display page retains its own sky offsets and HUD cells; turns and unchanged values must not invalidate both histories. The host fixture verifies the retained history functions and emitted viewport bytes, not actual asynchronous Canvas or page completion.

Init/reset bind immutable descriptors and validated assets while invocation/drawing is quiescent. Each render receives one coherent completed simulation state, copies required fields and performs finite command generation. The invocation owner clears ready before RUN, including failures before helper entry, and checks separate runtime/interface/language/helper outcomes plus matched completion before drawing. Failure can leave changed output bytes and earlier source effects; no rollback is promised. The sole drawing owner finishes consuming output before reuse. Stop drains firmware work/drawing/events before helper-private binding invalidation and module unload.

## Accepted architecture and remaining contract

Golem's `2026-10-13_17-26-47_golem_rally25-helper-architecture-lease-budget-six` accepts the narrow native-only binding/intrinsic, one linked dispatcher, explicit buffered-target rejection, generated metadata, distinct helper result, ready-clearing and suppression of root success after helper failure. [Original proposal](HELPER-PROPOSAL.md) is preserved with its published hash. Exact C members/layout assertions, declaration spelling, intrinsic marshaling, helper/SDK error mapping and completion layout are not frozen by architectural agreement.

D0 actually holds argument and root leases: two base views. Simultaneously acquiring asset/output would make four. Agreed preparation direction is to copy/resolve the argument and release that view before entering the helper, then scope root+asset+output to three. This is a future composition-layer change requiring normal/error cleanup tests; stand-alone D0/D1a peak3 does not prove the combined peak. Current SDK admits four views, but no policy or loader change is made here.

The storage profile now agreed with Golem uses inclusive one-dimensional uint16/sint16 arrays, index validation before RHS evaluation/write, language 5 for index failure, ReadOnly declarations, typed Fill/Values initialization or exact external packed bytes. Arrays are generated application-owned retained buffers; their optional manifest descriptors leave root-v1's four roles unchanged. Both backend cleanups retain root/arrays. Native accesses validate actual ranges and scope one array view at a time; stock requires exact installed storage/lifetime. Wide world-state support is still a separate delivery. Language signed-division overflow is now agreed as6, zero divisor 4 and conversion/Bounds 32, with paired outputs preserved on either division error; interface status 6 remains separate.

The verified immutable D0 bundle is a scalar integration candidate, not the Rally simulation or renderer. `d0_delivery.py` reads its actual default/relocated manifests, normalizes them into the existing host adapter and constructs all named six-byte wrapper CALLs from generated IDs. It checks exports against `calls.inc`; it performs no UART calls or new target execution. Exact ABI/toolchain/source/artifact checks are in [D0-RECEIPT.json](D0-RECEIPT.json).
