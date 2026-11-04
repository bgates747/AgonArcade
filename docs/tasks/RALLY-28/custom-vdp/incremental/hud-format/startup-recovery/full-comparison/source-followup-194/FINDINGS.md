# Source explanation after the partial cohort

Golem194 relays Flexe55's source/offline findings, preserved here as separate
attributed evidence. The frozen65 results and original clock arrays are intact.
No new emulator or calibrated FPS measurement was made.

1. MOS time counts serviced VSync interrupts, two units each in exactMOSd564.
   The pinned frontend emits at most one GPIO pulse when its presentation poll
   sees a changed native frame counter; multiple increments can coalesce into
   one pulse. All900 intervals of2 fit this coupling, but do not prove exactly
   which pulses or IRQs were lost. Dividing by120 does not calibrate wall time.
2. The PRT stopwatch counts serviced guest-cycle timer interrupts, nominal1000Hz.
   Interrupt service delays can coalesce expiries; host blocking time need not
   advance executed guest cycles. It is independent of the MOS counter but also
   lacks host-time calibration. The saved35.09PRTFPS is nominal, not established
   physical performance; the saved60.00MOSFPS is likewise nominal. Neither the
   observed1.7098 ratio nor whole-process35.536s supplies a correction factor.
3. Static exact200f CTS gate is ready && !failed &&
   hostqueued+publishedpending<=127. Three returnedfalse snapshots establish
   repeated refusal while counters advance; unsampled operands/firmware FIFO/
   IRQ/PC and the cause remain unknown. Do not append commands into the partial
   artwork payload or label this a cached-render performance failure.
4. Golem is obtaining200f-vs-maintained086 source differences before choosing
   legacy diagnostics or a separately qualified new runtime. Proposed owning-
   decision records and clock calibration remain unselected. No Rally client,
   clock, source, test, retry or remaining ABBA invocation is authorized.

Next: await bounded owner source disposition. Human/default/publication gates
remain; no reply-to-ack message, Oryx contact or queue reservation is needed.
