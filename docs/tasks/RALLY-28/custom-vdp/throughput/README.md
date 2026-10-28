# RALLY-28 — Native renderer throughput experiment

The new native span/Native-bitmap candidate improves completion-fenced Flexe throughput from **15.33 to 25.91 nominal MOS FPS (+69.05%)** over the prior quad renderer. Fifteen 900-frame runs and two short phase diagnostics pass. The 60 Hz target, Author motion gate and identical-byte hardware comparison remain open. [Results and limitations](RESULTS.md), [visual-review launch](HUMAN-REVIEW.md).

The work contract and all prior dirt were pushed as 39a546a before implementation. New code/evidence remains uncommitted. All work is isolated here; the original controls, firmware, SDK/compiler and production game remain unchanged. [Contract](PLAN.md), [verification](EMULATOR-VERIFICATION.json).

1. **Workload.** Finite native Fuji renderer fixture: 900 frames, 3,600 generated simulation ticks, traffic/signs/player/finish and intentionally flat background. This is not the complete playable game or a real-time physics scheduler. Foreground-unpaced copies remove exactly one deadline opcode while retaining the stock swap and all other workload/checks.
2. **Candidate.** Native horizontal spans fill a resident 320×120 bitmap; the stock buffered drawing path plots it. The RGBA2222 and Native variants share the exact module and pixel bytes. Format 3 is valid only for this pinned mode/palette/sync/opaque drawing setup. See [span proof](span-README.md) and [Native proof](native-FORMAT-PROOF.json).
3. **Tools.** fixtures.py, package.py and native_cases.py prepare isolated inputs; stage.py creates fresh stopped profiles; run.py performs finite silent comparisons; phase_run.py runs separate diagnostics; collect.py preserves returned evidence; report.py derives pooled timing from actual returns. oryx_session.py implements the Author-approved temporary boost disable/restore and records temperatures. Both SDL drivers must be dummy for every automated launch. Used profiles cannot be silently replayed.
4. **Evidence.** [EMULATOR-RESULTS.json](EMULATOR-RESULTS.json) reports individual/pooled clocks, exact-state checks and observed stack watermarks. [Phase interpretation](phase_INTERPRETATION.md) separates native preparation, dispatch/drawing and swap waiting. Raw session/campaign files and [evidence](evidence/) preserve successful runs and one startup-upload failure. The unchanged fresh retry passed.
5. **Packages.** [PORTABLE.zip](PORTABLE.zip) / [manifest](PACKAGE.json) contain the initial eleven control/RGBA/phase fixtures, modules and unchanged required firmware. [NATIVE-PORTABLE.zip](NATIVE-PORTABLE.zip) / [manifest](NATIVE-CASES.json) add the three exact Native-format fixtures. No card deployment, flashing or physical invocation occurred.

To regenerate the summary from preserved returns, without running an emulator:

```bash
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/throughput/report.py
```

Do not run fixture preparation over the preserved registry casually: package.py prepares the first eleven cases; native_cases.py then appends the three Native cases. Existing preflight/package receipts retain their creation-time facts; they are not statements that later authorized runs did not occur.
