# Physical VDP reset investigation — 2026-09-12

The Author resumed the goal and explicitly authorized ESP32 USB serial capture
and diagnostic VDP changes/flashing to trace the production Rally startup reset.
The Agon is powered, autoexec runs oval/demo, and EMOS extender keyboard is
disabled. EMOS + official VDP boots and runs another demanding game without
Rally; the identical Rally production binary works in the stock native emulator.
The failure also occurred with custom VDP + standard MOS on another Agon.

This is an amendment to the earlier no-hardware/no-GUI contract: physical
VDP diagnostics and application deployment are authorized. Testing emulators
remain headless; launch a dedicated graphical review emulator only after the
cause is located and evidence supports a working game. Do not modify MOS,
Extender/P4 firmware, upstream reference sources, or unrelated applications.
The root TODO's R19-11-H1 through H3 are the sole new execution checklist.
Commit each completed milestone under the existing Author authorization;
retain emulator changes pending human review where that gate applies.

Start with passive 115200-baud ESP32 UART0 output during a full Agon restart.
Use a diagnostic build copied from official VDP v2.16.0 if stock output lacks
crash detail. Preserve source diffs, dependencies, ELF/map, flash hashes,
serial logs and decoded backtraces. Observe startup milestones, heap/stack
state and buffered-call nesting only as evidence demands. Logging is temporary
VDP instrumentation; do not add production game fencing or performance logs.
Do not assume the native emulator models ESP32 RAM, stack, timing, interrupts
or the physical drawing queue. Prefer fixing emitted programs/loader to making
the product depend on changed firmware. Restore the official release and
repeat the corrected production launch before claiming stock compatibility.

Deployed production binary is 95822 bytes, SHA256
2d6b0d385f1b271c77cebb37e6a253ac55b11bf11d8df91a0b2720ed1829bbee;
command `run . oval demo`. Existing deployment hashes are in
`evidence/hardware-production/oval-demo/deployment.json`.
Official VDP artifacts and full preflash backup are in repository-root
`.work/stock-vdp-2.16.0/`; all three official segments independently verified.
The active official version is 2.16.0, source tag c7ac293d2aa81ddfa693390549bcd909069c8fc3.
The failing ESP32 is locally connected; resolve its stable serial path again
before flashing. Do not use the remote Extender P4 bench for this task.

## H1 — physical fault located

Stock serial capture reports `Stack canary watchpoint triggered (processLoop)`
on Core 0, followed by reboot. The corrupted backtrace is not usable for an
exact source-line attribution. Evidence: `evidence/hardware-production/serial-stock/passive.bin`.

A separately built official-2.16.0 diagnostic changes only the processLoop stack
from 4096 to 16384 bytes and adds UART0 call-depth/high-water logging. It reports
eight nested processAllAvailable calls along:
submit2000 -> commitState2002 -> renderProof2004 -> road_fullRoad2400 ->
road_drawNextBand2701 -> road_projectRow2406 -> LoadElement guard316 ->
patched-copy315. Each additional observed interpreter level costs384 bytes.
The first completed frame leaves11956 of16384 stack bytes:4428 consumed,
including diagnostic overhead, above stock4096. At least three frame returns
were observed. This is not yet a full gameplay or stock-firmware acceptance.
The native host's stack did not expose the ESP32's small task-stack constraint.

H2 will reduce emitted call nesting while preserving stock VDP semantics and
production game inputs. Larger firmware stack is a diagnostic control only.
