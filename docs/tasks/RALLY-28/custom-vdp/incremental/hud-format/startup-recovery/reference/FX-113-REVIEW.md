# Ordinary-upload stasis: separate sender progress from receiver progress

Executive summary: the new full-MOS report stops during stock font upload,
before any native RENDER. This warrants transport triage, but the current
outbound-file evidence cannot say whether the sender, CTS boundary, receive
interrupt path or firmware parser stopped. Preserve the first failed run and
start with a small progress discriminator, not another paced/retried upload.
This is source advice only; no instrumentation, build, attach or run is released.

1. **Primary evidence and limits.** Owner 15:07:57 reports exact cohort
   host frontend82e849, eZ80 application9b7290bd, firmwaref30b/ELF3ea6,
   maintained backend086/574 SDK, COLD/mode21,
   APPLE_HOST_LOADING, 1,063,166 visible MOS-to-VDP bytes in a partial 1,536-byte
   stock font upload to 0x6509. No chooser/native RENDER yet. Startup 600s and
   overall 900s+30s quit remain the owner's existing limits. I did not inspect
   or attach to its live process, alter its files, send bytes or request a retry.
   Before-RENDER is not proof that all earlier INIT/module/driver effects are
   absent. Prior native art/poison stalls, Rally's owner claim and FSIM's earlier
   bulk stall remain distinct cohorts; Rally needs its own raw primary witness.
2. **Visible file is a sender-side prefix.** Adapter `z80_send_to_vdp` queues
   the byte, writes buffered host trace and increments host RX count. It does
   not mean firmware consumed the byte. Normal trace flushing is once per
   roughly 250ms of adapter-loop wall progress. A live visible tail need not be
   the final accepted offset until normal shutdown flushes it. Silence in
   the opposite reply stream is not a missing expected reply during raw payload.
3. **CTS is not the hardware FIFO read.** Maintained adapter `z80_uart0_is_cts`
   takes io_lock and tests ready/not-failed plus host queue size and atomic,
   batch-published UART2 pending against 128. `feed_queues` injects into the
   modeled 128-byte RX FIFO and republishes pending before running the next
   core batch. Thus a stalled CTS call, a returned false, stale publication and
   a truly unconsumed FIFO are different observations. Final zero fault counters
   cannot distinguish them. Never call this lock-taking API from a watchdog
   and assume the watchdog itself is guaranteed to return.
4. **The MOS sender adds another layer.** The maintained Rust SerialLink passes
   CTS/send/receive calls to this backend. Its eZ80 UART samples CTS but shifts
   already-accepted TX bytes regardless of later CTS; FIFO/shift state is not
   captured in the outbound file. The stable MOS v3.0.2 reference separately
   waits on modem-status CTS and transmit-holding empty. Identify an exact
   current frontend/MOS wait PC from its own map/source before naming a driver
   fault. At that review the host frontend had not yet been source-closed; maintained
   Rust/stable MOS sources are path evidence, not a verified PC claim for82e849.
5. **Receiver layers remain separate.** Source closure corresponding to x86
   backend 086/adapter 5b07 has descriptor-selected UART full threshold and
   RAW/ENA gating, clock/reset gating and per-CPU routing/masking. Its integration
   patch arms baud-clock receive timeout on remaining bytes. Adapter VDP cycle
   publication occurs after the core/post-batch/ULP work; eZ80 execution runs on
   a different thread. Native frame progress is not proof of eZ80 instruction
   or command-parser progress. GPIO VSync coupling can affect MOS timing but
   does not establish that it caused this payload stall.
6. **Immediate use of existing evidence.** Let the owner finish the already-
   frozen first-failure/normal cleanup. Use its final flushed command prefix,
   replies, process exit/cleanup, final atomic statistics and exact sender/source
   pins to locate the boundary. Do not append a barrier/UNLOAD/other command
   into an incomplete payload; it would be payload data. Do not change chunking,
   timing, firmware or retry the same workload in this review.
7. **Smallest proposed first-stage discriminator, not selected code.** On a
   separately approved future reproduction, keep the exact failed history and
   payload. Publish only a fixed atomic frontend serial record: phase entering/
   returning CTS or send, CTS result, completed-send count, owning eZ80 cycle
   progress/paused state and sequence. Combine with existing public atomic VDP
   cycles/frames/failed and outbound count. Read a small bounded sample series
   only after the existing no-progress deadline, then preserve/normal-stop under
   the original timeout. Avoid per-byte logging, extra firmware bytes and
   lock-taking watchdog calls. All record updates happen on their owning thread;
   this needs an explicit preparation/build/run contract and may perturb timing.
8. **How that discriminates.** An entered CTS/send that never returns points to
   that boundary, not an inferred false result. CTS returns false while VDP
   cycles advance justifies inspecting actual receive/IRQ state next. CTS returns
   true but eZ80 progress is absent points toward sender execution/pause/wait;
   moving eZ80 progress without completed sends needs mapped MOS/app wait context.
   No VDP progress makes published pending potentially stale. None is itself a
   model or firmware fault verdict, and nonreproduction under added observation
   does not repair the original run.
9. **Conditional second stage only.** If first-stage evidence warrants it,
   reuse the earlier owner-thread coherent snapshot proposal: host queue /
   published pending versus actual UART2 RX count, clock/reset, CONF1, RAW/ENA,
   descriptor routes and per-CPU IRQ/enable/PS/PC plus timeout deadline when
   available. Publish once at an emulator-owned batch boundary, never inspect
   plain model fields concurrently from the host. If no boundary is reached,
   record unavailable. Do not read FIFO MMIO, write INT_CLR, force IRQs or reset.
   No earlier ARM offsets may be reused on this x86 cohort without verification.

Source anchors: owned adapter 5b07 (`feed_queues`, `vdp_loop`, CTS/send APIs),
`src/ez80_serial_links.rs`, `agon-ez80-emulator/src/uart.rs` and machine loop,
MOS tag v3.0.2 `src/serial.asm`, and frozen maintained closure
`build/fx072/arm64-prep/closure-r02/closure-manifest.json` plus base source/
`patches/flexe-integration.patch`. Manifest identifies equivalent x86 library
0866265b and qualified peripherals source 9905994d; raw upstream archive alone
lacks the maintained timeout patch. Existing
[UART-state proposal](../FX-072/uart-state-witness-proposal.md) retains the detailed
conditional state schema. No private/sibling source, active profile or FX-106
frozen input was changed. No new run, fix or shared-cause conclusion is implied.

Root97 later supplied byte-verified static sender context7ab6c7f1 and clarified
artifact roles above. Firmwaref30b/ELF3ea6 is distinct from app9b7290 and host82e849.
Use signed-byte JR edges, not objdump2.45 displayed negative targets (+0x100).
No live PC/CTS is inferred; FX114 now reproduces the actual host baseline exactly.
