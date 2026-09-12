# RALLY-17 supporting files

Task contract: [../RALLY-17.md](../RALLY-17.md).

Run from repository root:

```
.venv/bin/python docs/tasks/RALLY-17/experiment.py build
.venv/bin/python docs/tasks/RALLY-17/experiment.py bench
.venv/bin/python docs/tasks/RALLY-17/test_proxy.py
.venv/bin/python docs/tasks/RALLY-17/cycles.py
```

`build` creates task-local source copies and builds them in Linux scratch
folders, running sanitizer tests. `bench` creates a task-local stock-VDP ABI
proxy and isolated canonical headless profiles. It measures unpaused wall time.
`cycles.py` reuses the exact binaries, deriving two existing instruction
addresses from Linux build artifacts, and reads the stock debugger's cycle
counter. These cycle measurements exclude host pause time and retain the
normal CPU throttle. `test_proxy.py` verifies complete byte accounting, CTS
behavior, and restoration of normal delivery against a fake VDP module.

No accepted game or upstream emulator file is changed. Generated binaries,
profiles and native modules are ignored under .work/ and .emulator/.
The prototype's fixed-pose setup and bookkeeping are included in the cost,
as is one existing physics update and traffic update per cycle. These are
not displayed-frame-rate measurements or a retimed gameplay simulation.

Boundary implementation references (installed sources, read-only):

- `/Users/bgates/Agon/fab-agon-emulator/agon-ez80-emulator/src/uart.rs`:
  `apply_ticks` transmits through the link and charges `brg_div * 16 * 10`
  clock cycles per byte; LSR TEMT waits for both empty FIFO and zero cooldown.
- `/Users/bgates/Agon/fab-agon-emulator/src/ez80_serial_links.rs`:
  UART link delegates send and CTS to the native VDP exports.
- `/Users/bgates/Agon/fab-agon-emulator/agon-ez80-emulator/src/agon_machine.rs`:
  instruction-cycle accumulation and normal millisecond throttle.
- `/Users/bgates/Agon/fab-agon-emulator/agon-light-emulator-debugger/src/lib.rs`:
  `Cycles since last break` is a difference of total emulated CPU cycles.

The measurement is not instrumentation of VDP draw duration. It intentionally
removes rendering and receiver congestion to establish the remaining CPU and
serial cost. Normal-delivery controls may still be affected by native VDP
logging and host scheduling; do not interpret their small difference from sink
as a precise VDP-time breakdown.

Computation/state-only follow-up (no VDP command generation):

```
.venv/bin/python docs/tasks/RALLY-17/compute.py build
clang++ -std=c++17 -Wall -Wextra -Werror -fsanitize=address,undefined -g -Irally/include -Idocs/tasks/RALLY-17 docs/tasks/RALLY-17/compute_reference.cpp -o docs/tasks/RALLY-17/.work/compute-reference
.venv/bin/python docs/tasks/RALLY-17/compute.py bench
```

This uses separate compute-active.json/builds and compute-results/, preserving
the earlier UART experiments. It requires the RALLY-17 proxy already built by
experiment.py bench. Startup/warmup still render, but the measured loop updates
only typed RAM state. Every measured run must have zero UART bytes and match
post-physics fixture metadata and the host reference's computed scene fields.
