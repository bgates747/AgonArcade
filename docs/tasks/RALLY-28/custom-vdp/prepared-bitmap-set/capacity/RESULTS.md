# First capacity probe stopped on a harness protocol error

The small setup test failed before generating any cached image. The new harness
expected the wrong reply kind for a deliberately out-of-bounds read. The VDP
returned the correct error. The full901-image case was not started, so capacity,
bitmap registration and page semantics remain untested. No new FPS was measured;
the preserved compact race control remains36.57nominal MOS FPS.

1. **Exact failure.** Native request227 reads index51999 at offset10627, one
   byte beyond the last legal two-byte read of its10628-byte allocation. Correct
   return is kind5 (`VDPL_REPLY_ERROR`), code3 (`VDPL_E_BOUNDS`). The new
   `capacity.hpp::errorRead` wrongly asks `fs::transaction` for kind3
   (`VDPL_REPLY_DONE`), then diagnoses `VDPL reply identity`. This is a Rally
   harness bug, not an allocation failure, missing VDP feature or bitmap limit.
   Frozen SDK constants and actual serial bytes independently agree.
2. **Cleanup limitation.** The harness emits clears for all901private image IDs
   and index51999. Its first absence check, request238/ID52000/offset0, correctly
   returns kind5/code2 (`VDPL_E_BUFFER`) and hits the same wrong-kind assertion.
   Subsequent memory/absence checks do not execute successfully. Therefore the
   guest's zero cleanup/minimum-memory fields are INVALID measurements, not zero
   free RAM. Remaining image absence and exact resource cleanup are unqualified.
   Owned processes are stopped; no peer process was touched.
3. **Useful limited measurements.** Before the table, with real mode136 race
   assets/fonts/panorama/HUD/footer, two warm pages and fixed telemetry buffer:

   | Quantity | Bytes/count |
   | --- | ---: |
   | Free internal memory | 61,100 B |
   | Largest free internal block | 29,684 B |
   | Free PSRAM | 3,442,911 B |
   | Active buffers | 89 |
   | Free PSRAM after table allocation | 3,432,151 B |
   | Table allocation delta | 10,760 B |

   The table's final legal word is readable; full installed-table admission
   stops at the expected-error check. There are zero cached-image generations,
   zero registration probes and no page-semantics result. Do not infer that the
   2,211,975-byte image payload fits from these baseline measurements alone.
4. **Independent raw audit.** `FAILURE-AUDIT.json` decodes all378multiplexed
   packets/240native replies and matches every monotonic request. Two correct
   expected-error packets are absent from the retained transcript because the
   harness rejects them before recording; complete raw UART retains both.
   Exact901clear sequence is present; no48-byte cached generation command is
   present. Native Stop and UNLOAD return0, mode8 restoration and the MOS prompt
   follow. Backend errors are zero and all3537return bytes were delivered.
5. **Duration and release.** The owned session lasts12.184host seconds, including
   startup/warm pages/output/teardown; this is not frame rendering time. Guest
   interval38MOS units/336PRT units is partial, not successful901-image setup.
   Original95°C guard retained, sampled maximum57°C, boost1restored1, both SDL
   drivers dummy. Fresh whole-host inspection is empty and generation16 lease
   `ae560dd212de4bc7a61d6e6f1719d550` was explicitly released before analysis.
   Release mail `2026-10-30_20-03-35_rally_golem057-rally-capacity-release-eleven`
   notified Golem immediately; Oryx is free.
6. **Disposition.** Preserve this first witness and exact build. Proposed
   correction is to use the frozen protocol's error kind5 for expected length/
   absence errors, exercise both branches locally, then run a fresh small case
   before any full allocation under a NEW central grant. No retry or code fix
   has been made after the unexpected failure. No narrower domain, firmware,
   SDK/allowance change, separate prepared runtime, appearance acceptance,
   performance run, hardware action, commit or push occurred. Golem owns the
   next release; human review remains centrally deferred.

`evidence/capacity01/small/`, raw protocol audit, session/profile receipts and
lease inspection/release form the preserved witness. This experiment does not
supply the separate missing current road/traffic/player/sky rendering profile.
