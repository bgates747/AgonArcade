# Rally74 CTS stasis and differing clocks — source/offline review

Executive summary: three real samples record CTS returning false with no new
sends while both emulated CPUs' progress domains continue. This narrows the
transport question to a refusing gate, not a single nonreturning CTS call, but
cannot identify actual FIFO/IRQ/parser state. Separately, MOS counts delivered
VSync interrupts while PRT counts serviced guest timer interrupts. Their nominal
conversions disagree; neither is a calibrated render or wall clock here. No
repair, build, run or source change is selected by this review.

1. **Exact cohort and evidence.** Rally frontend7e7d/backend200f28cb/custom
   firmware8da2/MOSd564 and frozen71062298 runtime, postmaintenance checkout74;
   not Wolf086/8d98/943f or audio measurements. Root188/190 owns the complete
  65file freeze/auditor reproduction. This review independently reads actual
   cached sender records/stats and both901-value control clock arrays, verifies
   retained actual200f binary identity, and statically disassembles its CTS
   function with LLVM19 on Pi. No backend function is invoked. Compact evidence
   is build/fx114/rally74-review/{saved-analysis,inspected-hashes}.json and
   cts-disassembly.txt. Source82 archive/pinned7e7d patch locates frontend clock
   paths; hostfs/observer changes do not change these timer/presentation paths.
2. **What the stalled samples establish.** At57.035927/57.285981/57.535980s
   all three coherent frontend snapshots say returned_cts=false, sends241988,
   pausedfalse. Across first..third: publication+8,109,070, batches+499,
   eZ80cycles+9,198,309, VDPcycles+61,224,148, frames+15. Hence returned false
   is observed repeatedly, not just inferred from a silent file. Millions of
   publications and resumed batches are inconsistent with ONE CTS call holding
   that thread continuously throughout this sampled interval. They do not
   prove every intervening poll returnedfalse or identify its guest PC. Final
   entered_cts is a later instantaneous phase, not evidence of a new lockup.
   VDP getters are separate atomic reads, not a coherent receiver snapshot.
3. **Exact old200f gate.** Static code locks io_lock, tests ready, then failed,
   then loads host_to_vdp.size and published uart_pending; returns true only
   if ready && !failed && sum<=127. A false therefore has three possible gate
   categories; snapshots lack its actual local operands. Failedfalse/progress
   make capacity gating a plausible interpretation, NOT a recorded reason.
   Ready is unsampled. No claim actual UART2 RX FIFO=128: host queue plus
   batch-published pending is not a direct FIFO read, and UART pending can
   become stale relative to CPU/peripheral progress. Original send function
   queues/logs accepted host bytes, not firmware parser consumption.
4. **Payload meaning.** Owner/root full parsing finds ordinary buffer63800
   command0,2048declared bytes,420captured; no Init/native timed race. Partial
   upload makes later injected commands payload data, so do not append queries,
   retries or cleanup commands into it. Native LOAD success and advancing VDP
   frames do not prove this payload was consumed or serviced. Last returned
   equals delivered342 validates reply custody, not receiver health. Existing
   FX006 driver-race/timeout hypotheses remain distinct: no IRQ mask/FIFO/task
   witness here proves either, and before-Init is not proof no earlier native
   LOAD effects exist. Do not label this cached-render performance failure.
5. **MOS path counts interrupts.** Fixture fs::now reads SYSVAR.time twice
   until equal. Exactd564/map vblank handler13b7 contains LDHL(_clock),
   LDBC2,ADDHLBC and32-bit carry/store: two units PER HANDLED VSync interrupt.
   Frontend polls flexe_vdp_frames only when presenting and pulses GPIOB1 once
   if value!=last_native_frame. Unchanged counter =>no pulse; several increments
   between host presentations still produce ONE pulse. GPIO edge/IRQ pending
   and guest interrupt service are additional steps, not physical timing proof.
   This is the known FX032 dependency, still present in pinned7e7d. /120 means
   an assumption of60delivered/handled pulses per second, not a clock calibration.
6. **PRT path counts service.** Fixture programs PRT1 ports83/84/85, reload
   0x0480=1152, control0x57 (enabled,continuous,divide16,IRQ), software24-bit
   _ticks cleared then incremented once per handler; stop adds one pending IRQ
   correction. Nominal18.432MHz/(16*1152)=1000expiries per guest-clock second.
   Frontend timer model advances from executed eZ80 cycle accounting and a
   latched IRQ flag/delayed assertion; guest ISR service is required. Masking/
   higher-priority interrupts can coalesce expiries. Hostfs work excludes guest
   cycles; blocking host time need not advance timer counts. Host pacing tries
   nominal eZ80 timeslices but is not physical calibration. Thus PRT is an
   independent guest-cycle/interrupt-service stopwatch, not a host monotonic
   clock or guaranteed count of all underflows.
7. **Control numbers and limit.** Independently decoded901 little-endian32-bit
   values: all900MOSdeltas2,total1800; PRT24..41,total25647. The post-swap/fence
   complete-frame boundaries agree semantically, but assumptions yield15s/60FPS
   versus25.647s/35.0918FPS (ratio1.7098). Fixed2 strongly fits the known
   presentation/VSync coupling; it does not prove a particular missed-edge or
   IRQ-coalescing history. No aligned host timestamps for THESE timed race
   boundaries exist in these arrays;35.536s whole process includes setup/
   teardown. Do not divide by1.7098 as a clock fix, call60FPS calibrated, pool
   cached failure with control timing, or use stalled-process counters to
   calibrate the different successful process.
8. **Smallest next TRANSPORT preparation proposal, not selected.** Reconstruct
   exact200f source/object/toolchain closure and byte-identical unmodified old
   backend FIRST; existing086 build proof is not200f closure. Return drift before
   instrumentation. Add only a fixed owning-CTS last-decision record, published
   as part of its ORIGINAL io_lock-held decision, with branch-reason enum and
   the exact local ready/failed/hostsize/publishedpending values ACTUALLY read.
   Preserve original short-circuit: fields not read are unavailable, no extra
   getter loads/calls or watchdog taking this lock. Original branch/return/
   ordering unchanged, bounded atomic reader/few stalled samples, no files per
   poll or new firmware bytes. This distinguishes not-ready/failed/capacity
   refusal without pretending to inspect FIFO. Only if it records capacity
   refusal should a later separately scoped VDP-owner snapshot capture actual
   UART2 FIFO/clock-reset/RAW-ENA/routes/IRQ state, avoiding side-effect MMIO and
   plain concurrent reads. No rescue, forced IRQ, clear/reset or chunk changes.
9. **Separate smallest CLOCK proposal, not selected.** First finish exactMOS/
   source/pins/frame-gate mapping offline (no clock patch). If runtime evidence
   is later needed, use ONE short explicit calibration fixture/contract with
   two paired MOS+PRT readings around each of a static-display and known-frame-
   activity interval, aligned host monotonic boundaries and bounded owner-
   published GPIO-pulse/native-counter/eZ80cycle/PRTunderflow+service counts
   only where available. Preserve unavailable counters; no timer register read
   that clears pending or diagnostic ISR work inserted silently. External finite
   timeout independent of MOS/PRT is mandatory. This separates missing source
   pulses versus interrupt service versus guest-cycle rate; it must be labelled
   a NEW calibration cohort, not continuing/replacing the aborted ABBA or
   qualifying cached gain. No automatic calibration run or transport retry.

No build/lease/emulator/device/transport/timer/rate/default/publication action
performed. Root190's deeper audit completion is acknowledged as OWNER/root
provenance; this review does not claim independently rerunning that entire audit.
No current guest source/profile or immutable runtime was edited. Next free
local immutable task identifier remains FX-134 pending new plan selection.
