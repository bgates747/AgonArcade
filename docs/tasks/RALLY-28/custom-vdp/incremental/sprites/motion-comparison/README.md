# Matched moving-traffic baseline comparison

The Author accepted the sampler's moving visuals and clean MOS return, then
requested the same deterministic pattern against the baseline before further
work. Compare the existing split-clear affine baseline with the accepted additive
sampler, without adding another optimization. Preserve previous evidence.

**Completed:** the exact moving pattern gives28.46→35.35nominal MOS FPS
(+24.22%); PRT+24.26%. All four900-frame runs pass and their entire timed UART
streams match byte for byte. [Results and limits](RESULTS.md). The Author's
visual acceptance is recorded separately; physical hardware remains untested.

- **INC-001-02-CMP01** [x] — Build isolated matched900-frame/3600-tick fixtures
  using the accepted review's exact motion table, fixed lanes and cleaned-up
  driver. Keep module/firmware/physics/artwork/final fence fixed to their existing
  versions. Both variants are foreground-unpaced; stock swap/VSync remains.
  Verify the candidate differs from the accepted paced review only by removal
  of the foreground deadline. Timed tapes and347outbound UARTbytes/frame match.
- **INC-001-02-CMP02** [x] — Run baseline/candidate then candidate/baseline in
  fresh silent Oryx Flexe profiles under the existing boost/thermal supervisor.
  All runs must pass retained replies, scripted positions/lanes, independent
  player station, full final-state equality, unchanged inputs, timer restoration,
  native stop/unload, clean MOS return and zero backend errors.
- **INC-001-02-CMP03** [x] — Report each run and pooled completed-frame MOS/PRT
  timing separately, exact workload identities and limits. Preserve raw returns
  and portable inputs. Do not pool paced review or old equal-speed results with
  this workload. No hardware or next optimization is released by this request.

All automated runs force both SDL dummy drivers. Runtime/resource admission
differences required by the sampler remain part of its implementation; setup is
outside the measured frame interval. Firmware and SDK remain unchanged. New work
stays uncommitted until explicitly approved.

The first affine attempt passed; its sampler partner stalled during startup,
before timed frames. Guarded interruption preserved both returns and restored
boost. Exclude that incomplete pair. The qualified plan uses fresh `motionab02`
and `motionba02` profiles with byte-identical input fixtures, no source change or
firmware workaround. Preserve the unrun original reverse profiles as well.

**Preserved thermal interruption:** session02's monitor observed95°C at startup and
aborted before launching an emulator. Boost was restored and no owned emulator
remained. Read [thermal receipt](SESSION-motioncmpsession02.json). Two unrelated
CPU-heavy `agon-6502/experiments/vdp005/target` jobs were active (`vectors.py`
and `long_run.py`); they were inspected read-only and left running. A clean
matched comparison needed a cooler/idle host and Author coordination before
resuming. The first affine run passed at27.68nominal MOS FPS but was unpaired
and is excluded. No change to the95°C guard or other agents' work was made.

The Author subsequently reports those jobs finished. Read-only verification
finds them absent, no emulator running and49°C. Session03 completed the unchanged
fresh02profiles under the original guard, restored boost1and stopped all owned
emulators. The earlier gate/receipts remain
historical evidence; do not classify the aborted attempts as completed timings.

The inherited `comparison_scope` field in expected.json names an older
bitmap-format experiment. It is preserved with its original lineage; the current
`timing_scope`, [MATCH-PROOF.json](MATCH-PROOF.json), module identities and actual
transmitted streams define this comparison. No runtime behavior uses that field.
