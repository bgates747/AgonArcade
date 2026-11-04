# Olimex comparison preparation

The six-run adapter is prepared without device contact. The existing fixture bytes remain unchanged. Extender's actual grant is still required.

- NAT-HW-001-01 [x] Physical reservation68cc81defe48 is first after generation24 release; no token accepted yet.
- NAT-HW-001-02 [ ] Physical staging/readbacks require grant. Host inventory and adapter preparation complete.
- NAT-HW-001-03 [ ] Six explicit physical invocations remain unrun.
- NAT-HW-001-04 [ ] Retrieval/restoration/release remain unrun.
- NAT-HW-001-05 [ ] Physical comparison pending.

## Compatibility reconciliation

1. All three exact compiled probe.bin files contain the AgDev mos_setkbvector wrapper exactly once: load A=0x1D, RST.LIL0x08. Source installs fs_callback with addresslength0 and clears it through the same MOS API. No guest patch to Arthur's0xBC42B is used. Installed Eirene setter resolves its own _user_kbvector0xBC38E. Full ten-byte callback captures VDPL; only READ16 is used, never READ8. Source and installed EMOS vdp_protocol_KEY length10 guards are compatible by inspection; physical compatibility remains to be qualified.
2. The frozen expected.json firmware_sha2568da2 labels are inherited from the older full-race oracle. They are stale metadata, not the firmware selected by the completed Oryx profiles or this hardware cohort. Do not rewrite them. INVENTORY.json separately pins actual1094384-byte a50 firmware and exact thirty fixture input files. The state/reply oracle is independent of that string; verifier does not use it to identify installed firmware. Physical backup/installation readback must establish the actual a50 application in the preserved full-flash composition.
3. Source guest entry always emits mode136 and checks its MOS response before callback takeover; runner preselects/verifies native mode136 and waits>=1second before invocation. Guest then performs its unchanged setup/assets outside the measured interval. This preserves byte comparison despite the inherited redundant same-mode selection. RestoreText leaves native mode8; runner owns restoration of the true pre-suite native mode, cwd and text/cursor. P4 mode is untouched. Entry double-buffered native modes are rejected rather than silently substituted.
4. Mode-save operation uses installed Eirene _sysvars0xBC322 +scrMode0x27 =0xBC349; this is a read through MOS SAVE, not a write to firmware/vector memory. Real listener/read/EXIT sequences establish CLI completion. Printer mirror is admitted and recorded as instrumentation, not optical proof.

## Adapter and preflight

physical.py is an owned adaptation of the inspected successful CPU003 helper, with Rally paths/owner, exact a50 image length, six independent case directories, explicit per-case mode SAVE/verification/settling, full per-file GET comparison, strict completion and raw guest verification. It does not execute the old helper. The pinned staged client is f7aa43bd... and native baud115200. Fresh4MiB backup validates the real app partition at0x150000 and original17caa/full8ade app. Both application images round to1097728bytes. Original sector tails are retained. Install and restore each require complete independent4MiB comparison, with original exact comparison at restoration. The900second esptool operation bound accommodates115200 reads; no automatic retry.

PREFLIGHT.txt records device-free checks of all31hashes, six staged/readback/script flows, real retained-flash partition/composition parser, outside-range preservation, exact restoration and consumed-action replay refusal. Temporary synthetic state was confined to a temporary host directory and cannot grant device custody. No device was opened. Guest verify.py checks all2025retained replies, final406Bstate, clocks, player and counters; emulator whole-wire audit is not fabricated on hardware.

Expected session includes three full4MiB reads at115200 plus independent staged file downloads. Allow approximately30–50minutes for preparation/transfers/flash verification,5–10minutes for six applications and15–25minutes for retrieval/restoration. These estimates are not automatic resets. No Pi CPU-heavy compile/emulator is needed; clients are light control/IO. No source publication or human visual/audio acceptance selected.

Read current central Olimex procedure and Extender dispatch/appliance/execution/constraints/transfer/keyboard/serial/install/rollback/reset/layout guides before operation. Use actual supplied grant and fresh Extender readiness; no target access from reservation alone. No autoexec changes, EMOS/P4 replacement, parallel-upload trial, route experiment, async experiment or firmware adoption. Sound remains enabled and unassessed. No current sound restriction was reported by Extender.
