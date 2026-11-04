# NAT-HW-001 — unattended Olimex matched native-state comparison

Author selected an Olimex run on 2026-11-04 instead of manual Console8 testing.
Status: prepared reservation request; no physical grant or device access yet.

- NAT-HW-001-01 [ ] Reserve the physical Olimex FIFO and coordinate Extender grant and component compatibility.
- NAT-HW-001-02 [ ] Stage and hash-verify the exact existing hardware-kit fixtures in six fresh directories under /test/arcade/rally/native01-olimex01. Do not modify fixture binaries, assets or configuration.
- NAT-HW-001-03 [ ] Under granted custody, run baseline1/state1/coarse1/coarse2/state2/baseline2, each 900 rendered frames, 3600 logical steps, two warm frames. Stop dispatch on uncertain invocation, reset, missing completion or correctness failure; no automatic replay.
- NAT-HW-001-04 [ ] Retrieve all guest files and operational journals, restore retained components/modes/routes/input/CLI and release physical custody before lengthy analysis.
- NAT-HW-001-05 [ ] Validate exact final state/replies/cleanup and report per-arm and pooled FPS, raw MOS/PRT durations, repeat variation and differences from the same-board baseline. Preserve clock calibration limits and board differences.

## Inputs and scope

Inputs are ../hardware-kit/{baseline,state,coarse}, verified against the completed Oryx cohort. All require the same supplied ../hardware-kit/vdp_rally.bin, SHA256 a50eb23acf6b3edfb44d3c1bb44858a213be696d68c06a696da7767170ac6f9a. The stock VDP cannot run this fixture. No application build, SDK migration, async experiment, EMOS/P4 replacement or production adoption is selected.

Extender must reconcile installed EMOS/P4/native VDP identities and advise the maintained transfer, temporary native-VDP install/readback and exact restoration operations before target access. Preserve the current native firmware with validated image-length provenance and recovery evidence before temporary replacement. Restore it after the suite. Retain installed EMOS/P4/startup/listener unchanged; if incompatible, stop and coordinate rather than replacing them. Firmware installation is temporary and solely for this authorized fixture.

Never edit autoexec.txt, even temporarily. Explicit CLI invocation per fresh run directory: CD directory, LOAD probe.bin, RUN . . Fixture generates result.json, state.bin, player.csv, stages.csv, replies.bin, ticks.bin, prt.bin (or failure.txt) and returns to MOS. The Pi coordinator must verify mode/route before dispatch, preselect required native mode136 if necessary and allow at least one second settling after verified selection. Preserve/restore original per-display mode, route and visible text/cursor; application mode setup/teardown stays outside timed intervals. Use maintained Extender operations with an asserted physical lease before each operation. No test autorun or implicit reboot resume.

Budget: preparation/staging/install/verification approximately 10–20 minutes, six fixtures approximately 5–10 minutes including startup, retrieval/restoration approximately 10–15 minutes. These are estimates, not reset deadlines. Bound each run to 180 host seconds with journalled terminal evidence; on timeout stop dispatch, preserve uncertainty and use maintained recovery without replay. Engine audio is unchanged in exact fixtures; no sound/optical acceptance is claimed or requested. Extender should disclose any bench sound constraint before grant.

No physical action before Extender's explicit fresh grant. Follow central olimex-bench custody and current Extender appliance/execution/transfer/flash procedures. Report Extender failures promptly with transaction IDs and journals; do not repeat uncertain operations or recover concurrently. Restoration requires fresh physical no-workload/transfer/readers/reset-holders, CLI/input/listener/staged-job and component evidence, not an emulator process scan. Notify Extender and actual next waiter after release. Human visual acceptance remains separate.
