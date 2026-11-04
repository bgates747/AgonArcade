# Original-control startup fixture prepared

No new game FPS is available: this preparation has not launched an emulator.
The one-frame fixture is a startup/cleanup check and its timing is excluded from
performance comparisons. The HUD implementation remains fixed.

The checkpoint was pushed to `origin/main` in three logical commits: `39df4bc`
(offline timing/assembly findings), `191a1e8` (HUD cache and failed startup), and
`dec22d0` (this recovery contract). All preparation below is new, uncommitted work.

## START-001-01 [x] — Owner findings and runtime boundary

Flexe's FX-113 review establishes no fix or root cause. Our saved outbound UART
stream records host enqueue, not firmware consumption; it cannot distinguish
CTS rejection, a blocked send or a stalled receiver. A watchdog must not call the
lock-taking CTS implementation or inspect unsynchronized model state. The
proposed observation uses bounded atomic reads of owning-thread progress.

FX-114 reproduces frontend `82e84922…` byte-for-byte from its declared source,
toolchain and existing hostfs patch. This differs from Rally's old `28f50e87…`.
Golem's compatibility intake accepts checking whether the observer can use the
old `200f28cb…` adapter while retaining `8da2ebfd…` firmware. Public symbol
presence alone does not prove compatibility; unavailable observations must be
marked unavailable. Saved owner findings and exact origins are in `reference/`.

No compatible observer binary/schema/reader contract has been returned yet.
Observer preparation belongs to Flexe; Rally has neither duplicated it nor
changed peer source. A nonreproduction with instrumentation would not prove a
fix. Any new runtime cohort must be common to both fresh HUD benchmark arms;
its absolute FPS must not be pooled with the old runtime's results.

## START-001-02 [ ] — Application inputs ready; runtime integration pending

`prepare.py` copies the exact original control guest `685f4b4c…` and its failed
60-frame fixture inputs. Only configuration byte6 changes, reducing the frame
count to one; `expected.json` changes accordingly. The original artwork, native
module, geometry, motion and presentation streams remain byte-identical.

The guest performs original setup, two warm-page renders, one rendered frame
and four physics steps, then its normal Stop/UNLOAD, timer restoration and MOS
exit. It is not a zero-frame startup harness. There is no new eZ80 binary.

Ordinary and ASan/UBSan actual-C host checks agree on all final buffers. An
independent model checks each physics step and the accepted first motion row.
Final player station is3248240, render phase240, native generation8, request3
and world ticks4. Four buffer leases balance and canaries pass. Host libraries
are private analysis artifacts; they are not substituted for target code.

`predict.py` freezes226 ordered native requests/replies. The first20 replies
match a previously qualified raw control capture, and the first frame's311
outbound bytes are extracted from that immutable capture. Only stack-watermark
reply values remain unspecified. The complete final-state oracle is separate
from timing; `audit.py` checks successful target captures against this protocol,
the exact311-byte frame and the normal guest result/state/cleanup checks.

A provisional metadata copy initially retained three900-frame counters. That
local preparation was preserved in `preparation-01/` and corrected before any
freeze, staging or target run. The corrected copy starts from the actual failed
60-frame metadata and explicitly sets the one-frame counters. Guest/source
inputs did not change.

`APPLICATION-FREEZE.json` pins this application preparation and its dependencies.
It is not full target readiness: observer/runtime identity, its reader and fresh
profile launch contract remain required. There is no queue reservation.

## START-001-03 [ ] — Integration and finite target plan still required

Before staging a runnable profile, obtain and pin the owner's immutable binary,
source closure, schema, bounded reader and explicit old-adapter availability
answer. Never invent missing fields, read guessed offsets, or call lock-taking
CTS from a guard. Record how samples distinguish entered/returned CTS/send,
last CTS result, completed sends, eZ80 batches/paused progress and whatever
public atomic VDP progress the selected adapter actually supplies.

Freeze a separate target-readiness record with exact profile inputs, observer
sampling cadence, success/failure boundaries and owned teardown. The existing
60-second UART guard in historical profiles is immutable. A new observation
window, if needed to collect a post-stall sample, must be justified and frozen
before launch; it must remain within300host seconds per process and the original
95°C thermal guard. Both SDL drivers are dummy; restore actual initial boost.

The initial tranche permits at most two specified processes and stops at the
first unexpected failure. Select their exact runtime/observer roles after the
owner contract is available. Reserve FIFO only when ready; assert ownership
before each launch. Retrieve all raw evidence, stop owned processes, inspect
fresh whole-host idle state, release and immediately notify the next agent
before analysis. No original failed profile is retried blindly.

Only actual startup/normal MOS exit qualification permits the separately
reserved fresh HUD smoke and matched900-frame comparison in `PLAN.md`.
