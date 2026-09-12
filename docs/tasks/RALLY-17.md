# RALLY-17

Measure one existing physics update plus complete scene command generation and
UART transmission, with normal 18.432 MHz eZ80 throttling and no application
frame pacing. User authorized the byte-sink alternative on 2026-09-12.

All code and generated builds belong in [RALLY-17/](RALLY-17/). Do not alter the
accepted rally/ sources, previous experiments, or upstream emulator. No commit
is authorized. Root TODO.md remains the task checklist.

The task-local VDP ABI proxy loads the installed stock VDP. Startup, assets and
warmup render normally. A filesystem handshake outside measurement activates
count-and-forward or count-and-discard mode. In discard mode receiver CTS stays
ready; UART transmit FIFO and baud cooldown remain in the unchanged emulator.
The intercepted send occurs in UART apply_ticks, after its transmit scheduling.
This removes VDP queue backpressure while retaining CPU and serial costs.

Each of 64 deterministic poses calls the existing Motion::tick and Traffic::tick,
then renders background, road, cars, player and HUD and emits the usual swap.
There are no per-frame clock reads or fences. Timing encloses the batch and a
final UART TEMT drain. Start/stop handshakes, filesystem reporting and final VDP
poll occur outside that measured interval. Report physics/render/transmit cycles
per second, not displayed FPS. This is fixed-input diagnostic work, not gameplay
with elapsed-time physics catch-up. Fixture bookkeeping remains included.

Compare full-road, pavement-only and resident-section variants on both tracks,
once forwarding and twice sinking, checking identical byte counts, FNV-1a hashes,
pose hashes and road counts per case. Build in isolated Linux scratch directories
and run existing sanitizer tests. Use canonical profile launchers with an explicit
bespoke-module marker, dummy SDL drivers, normal CPU flags and retained runtime
hashes. Verify mainline fingerprints before and after. Report ms/cycle and the
16.67 ms budget; MOS clock resolution limits precision. Preserve raw results.

Printer mode is unsuitable: VDU 2 is handled by VDP and copies printable text;
it does not divert the full graphics byte stream away from VDP.

Wall-clock sink results showed substantial host variance. The follow-up
`cycles.py` uses the stock debugger's total_cycles_elapsed counter, with two
breakpoints at existing rawClock call instructions bracketing the batch and UART
TEMT drain. Addresses are derived from each isolated Linux object disassembly
and link map, checked against binary opcodes, and retained as evidence. No guest
code is added. Read state and continue at each boundary; the second cycle delta
is the primary CPU-plus-UART cost, converted at 18.432 MHz. Paused wall time is
not a valid benchmark metric in these debugger runs. The original unpaused wall
results remain separately retained under results/.

## Computation and state-only follow-up

User clarified: do not construct or buffer VDP commands. Measure calculation
and updates to ordinary RAM state, with no command creation or transmission.
`compute.py`, `computation.hpp`, and `compute_reference.cpp` implement this
isolated follow-up for the current section renderer. Preserve earlier evidence.

Retain deterministic pose setup, one physics/traffic update, section/material
boundary selection and projection, scenery heading/history, traffic sorting,
visibility/projection/scaling/orientation and player view/position calculations.
Store calculated scene values as typed RAM state, with volatile writes to prevent
compiler removal of results. Road projection also updates its ordinary arrays.
Remove road emission, command packing, VDP API calls, text output and UART sends
from the measured loop. Fixture frame/car counters and pose hashing remain.
The final TEMT check remains as a common batch boundary; with no bytes sent it
has nothing to drain. Startup and original rendered warmup remain outside timing.

Use the same stock debugger cycle counter and normal eZ80 throttle, two runs per
track. The native proxy must observe zero measured UART bytes. Match existing
post-physics pose hashes, car counts and frame counts, and compare final computed
scene fields against a sanitizer-enabled host reference. Report computation-only
cost separately from the residual command construction/API/transmission cost;
the difference is not pure wire time, and the two paths differ in typed RAM
stores versus command packing. Keep everything inside RALLY-17, uncommitted.
