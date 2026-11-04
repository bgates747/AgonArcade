# Shared VDPlet performance question — follow-up after ROW-001

The Author reports6502and FSIM underperforming expectations, especially FSIM
running nearly2×faster with bespoke VDP functionality than with VDPlets.
Treat that as motivation to compare the actual paths; no matched FSIM artifacts
or cause were independently audited in this Rally tranche.

Rally's current fixture invokes four native Tick120entries plus one Render30
per frame. The generated native entry's common admission/shape-validation
prefix contains nine `buffer_acquire` call sites before its dispatch switch,
including argument/root and bound-array checks. The five ordinary RUN entries
therefore execute45such prefix acquisitions per frame, in addition to the
actual numerical and renderer work. The Tick120case has16additional acquisition
sites and one loop; site count is not dynamic invocation count or duration.
Render has its own helper preflight/lease work. These are source observations,
not evidence that validation or the generic runtime explains the measured gap.

The first PSRAM-policy native builds also exposed unrelated retained diagnostic
entry code: narrowing both task-local packages to actually called entries
reduced their text from35,728/35,912bytes to24,876/25,080bytes. That is a
resident-size result, not a measured frame-time improvement. The corrected
compiler policy and runtime migration are shared by both comparison arms.

After the direct-row result, useful distinct questions are cost of generic RUN
admission versus module-specific repeated validation; repeated array-service
calls versus scoped bulk access; code/data placement and memory barriers;
output generation/copies; Canvas synchronization and native-to-stock command
submission. An identical finite kernel/scene and completion boundary in bespoke
and VDPlet paths would distinguish these better than comparing project labels.

No second optimization or cross-project benchmark is selected here. First
measure the already prepared direct-row road output change, including its
required Canvas drain and per-row calls. Keep async UART and independent
physics/render scheduling deferred as the Author requested.
