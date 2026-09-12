# R19-11 final-candidate correctness and stability review

The current production executable is SHA256
`64c8b0734bcd253112d162173fc38f343eafbc96894dc1d09b4793766ed59129`.
It is reproduced from the `hardware-inline` research frontend and uses the
same scene assets as the card's `inline-b` candidate. The compiler correction is
Golem commit `f9e7d8d0d0d105c26cc2ee8c2f30a2267a905895`; Rally's physical startup
checkpoint is `10b7ecb`, followed by controls/replay checkpoint `eb24628`.
This review records independent raw-evidence audits and source inspection by the
same agent, not an external reviewer's approval. Root TODO owns completion status.

## Correctness and stability evidence

| Requirement | Final-asset evidence | Result and limits |
| --- | --- | --- |
| Frozen scene geometry and regional pixels | `evidence/hardware-production/inline-candidate/frozen-qualification.json` | All66 frozen poses:24 oval,42 Fuji. Recomputed road-boundary and per-object/material comparisons pass the unchanged thresholds. Includes Fuji tight bends; does not reuse old bootstrap results. |
| Unchanged host simulation/control/render boundary | `frontend_bridge.py`; `evidence/golem-frontend/hardware-inline-qualification.json` | Exact accepted input/physics/HUD and art/projection headers; only the documented failure cleanup and checked-loader changes are admitted. The explicit inline bridge requires exact newly qualified bootstraps and regenerated integrity constants. |
| Long replay | `evidence/golem-stability/hardware-inline-audit/qualification.json` | Both tracks18064 frames/72256 ticks,602.133 guest seconds and over602 wall seconds. Every80-byte accepted state matches the independent sanitized host replay; final92-byte readback matches. Zero sequence/protocol/nonfinite errors. |
| Memory and boundary coverage | Same replay audit and raw soak captures | All surfaces, both steering/lateral extremes, speed0..300, grip25..200,59 natural lap crossings and4659 nearby vehicle-depth poses. Oval stays3698 tracked allocations/745263 bytes. Fuji adds one16-byte cache at frame8, then stays3772/868137 for18055 frames. Both clean down to26/174986. These are native tracked allocations, not physical ESP32 heap totals. |
| Admission, rejection and lifecycle | `evidence/golem-lifecycle/hardware-inline-{oval,fuji}/results.json` | Each210 events,27 admissions,198 observed calls; exact96-byte readbacks, sequence wrap, unchanged geometry/history on rejected packets. Three teardown/reload cycles release every836/853 owned IDs, preserve a foreign canary and reproduce equivalent allocation states. |
| Loader faults | `evidence/golem-loader/hardware-inline/results.json` |834 ASan/UBSan cases using actual assets: absent/truncated/corrupt/oversize data, read/seek/close faults, retries and ownership. |
| Native startup failure | Eight `evidence/golem-failure/hardware-inline-*` cases | Missing/corrupt bootstrap or cleanup on both tracks returns31; queried scene/art/bootstrap buffers are absent afterward. |
| Actual native input and MOS return | Twelve `evidence/golem-frontend/*-hardware-inline` runs and their qualifier | Demo, left/right held input, takeover, autosteer and explicit oracle on both tracks;638 independently checked host state records, zero invalid states, cleanup and armed Escape return. |
| Compiler regression | Golem `docs/evidence/rally19-hardware-inline/` | All14 ASan/UBSan/golden/negative suites. Source hashes were rechecked before the compiler checkpoint. Inline byte equivalence is tested against explicitly expanded source, including nested/repeated calls, conditional/finite-loop retention, cleanup and bounded rejection. |

## Source and generated-command review

1. `frontend_state.hpp` maps motion and six competitors into raw track-relative
   state. `scene_protocol.hpp` explicitly encodes little-endian80-byte state,
   avoiding eZ80's24-bit `int` and host padding. The97-byte ordered update/trigger
   contains neither road screen coordinates nor precomputed vehicle geometry.
   Its old introductory "not integrated" comment is historical; the build and
   qualified frontend demonstrate current integration.
2. `admission.golem` validates version, size, reserved fields, track, sequence,
   seal and numeric bounds before copying staging to active state. Rejection
   cannot partially advance scene history. The protocol preserves independent
   stripe phase across lap wrapping and keeps input, physics and rules on eZ80.
3. `build_scenery_draw.py` and its road/vehicle/scenery generators produce typed
   Golem source. The existing C++ compiler lowers that source; Python is source
   and data generation, not an alternate hidden command compiler. Resident
   coefficient/table evaluation, signed conversion, indexing, sorting and bitmap
   placement execute on VDP. Scenery uses its qualified retained-page history.
4. The compiler's new `InlineCalls` expansion uses recorded unconditional call
   offsets after original call-graph validation. Immutable program entrypoints,
   storage IDs, mutable command templates, guards and finite repeat back edges
   remain. Expanded size/resource caps still apply. No raw payload scan or new
   VDP opcode is introduced. Inlining can remove tail-call opportunities and is
   not a general static ESP32 stack proof.
5. `golem_renderer.hpp` checks file size/hash before installation, verifies the
   streamed bootstrap again, and validates the complete bounded cleanup stream
   before sending it. Failed cleanup remains retryable. FNV-1a detects accidental
   mismatch/corruption; it is not authentication. Recurring prepare/submit remains
   exact across the accepted frontend bridge.
6. `build_production.py` extracts the accepted art/input/physics/HUD, removes
   research options/reports and per-frame counters, and retains only the gameplay
   clock. Its output contains no diagnostic fencing or measurement logs. The
   reconstructed source, headers, executable and both tracks match the deployed
   candidate byte-for-byte. Separate measured/replay executables are not products.

## Physical result and remaining limits

The original physical failure was the official VDP's4096-byte `processLoop`
stack canary. A larger diagnostic stack exposed an eight-level buffered-call
chain. Selective inlining reduced observed maximum nesting to six and completed
120 logged returns on a4096-byte diagnostic stack. Minimum reported headroom was
164 bytes including instrumentation: a narrow observed margin, not every-path
safety. Both diagnostic firmware artifacts are retained locally, not installed.

Official VDP2.16.0 was restored and all three flash segments verified. The Author
then confirmed visible continued operation after the board reset button, still
slow. The cold power-cycle behavior was not tested. The sparse diagnostic rate
was about1.186 root-call returns/sec; it is not direct physical display FPS.
The official slow run rules out diagnostic firmware as a sufficient explanation.
The current arithmetic lowering has not produced a practical hardware speedup.
See HARDWARE-DEBUG.md and PERFORMANCE.md for raw evidence and interpretation.

The native emulator executes its VDP implementation on the host CPU and does not
model ESP32 execution speed or stack limits. Its finite-job, viewport-swap and
memory observations retain only their documented scope. Final-asset timing is
audited separately before final delivery; no original frozen budget is relaxed.


## Final audit completion

All final-asset native timing budgets also passed. The independent results above
are bound by `audit_final_candidate.py` and `evidence/final/qualification.json`,
which rechecks644 source/evidence files and the fresh production/card equivalence.
The initial indexer's replay-ledger key error is preserved separately; the
corrected index uses that auditor's actual source_hashes field and verifies its
identity. This is an evidence-index repair, not a gameplay or threshold change.
R19-11 is complete for the frozen correctness/stability scope. Physical startup
acceptance remains limited to the documented reset test; physical speed remains
unaccepted. No additional emulators or physical actions are needed for this review.
