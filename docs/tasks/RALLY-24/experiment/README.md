# RALLY-24 local native-renderer experiment

The complete scene-command generator compiles into one classic-ESP32 VDPlet.
Candidate B calculates road corners natively; candidate A retains the old
buffered section arithmetic as a comparison control. Both project cars and the
existing signs, finish line and crash visuals. This directory contains local
qualification tooling, not a replacement production Rally executable.

## Run from the repository root

```sh
make -C docs/tasks/RALLY-24/experiment all
make -C docs/tasks/RALLY-24/experiment sanitize
```

Dependencies: repository `.venv/bin/python` (standard library only), host GCC/G++,
and sibling `agon-vdplet` with its unchanged SDK and pinned classic-ESP32 GCC
8.4.0 / esp-2021r2-patch5 toolchain. Override `SDK` and `COMPILER` Make variables
if those locations differ. The formatter is optional; no formatter is required
to build. No command in these targets connects to hardware or an emulator.

Generated data, binaries, disassemblies, stack reports and test results are in
ignored `.work/`. `native` alone compiles/packages the Xtensa variants and runs
the SDK's image admission/relocation code locally; it does not execute Xtensa
instructions. Sanitized host libraries live separately in `.work/sanitize/`.

## Source map

1. `assets.cpp` exports explicit little-endian arrays from preserved headers and
   validated `.road` files. It generates the asset directory, checksums and
   `.work/asset_meta.h`; rerun after any source-data change.
2. `module.c` implements BIND/PREPARE using only buffer services. No heap
   allocation occurs inside the module. Single-entry private scratch is reused;
   concurrent/reentrant execution is unsupported, as in the current runtime.
3. `oracle.cpp` uses current `LookupRoad`, `prepareGameScene` and `Billboards`.
   Main-loop command emission for finish/player/actors is copied and source
   pinned; B road endpoints use an independent generic binary32 matrix product.
   `test.py` refuses changes to the pinned reference sources before comparison.
4. `protocol.py` serializes arguments/state and generates silent RUN plus guarded
   draw wrappers. `submit_parts` returns four ordered pieces; a future game
   integration inserts existing scenery/viewport/HUD commands between them.
5. `test.py` supplies a mock host with four-lease enforcement, access checking,
   fault injection, buffer aliases and deterministic current-game comparisons.
6. `protocol_test.py` independently decodes the wrapper stream, invokes the mock
   host, validates output command boundaries/terminators and tests stale-output
   suppression. It is a deliberately limited interpreter, not a VDP emulator.
7. `unit.c` probes output capacity with canaries and signed rounding under
   sanitizers. `admission.cpp` uses the actual unchanged SDK image loader.
8. `inspect_native.py` records imports, admission limits and a source-call-graph
   stack estimate checked against compiler `.su` files and disassembly.

## Ownership and input requirements

Allocate distinct, contiguous buffers with the sizes in DESIGN.md. After BIND,
the owner must keep arguments, assets, buffer allocations and identities
immutable until rebinding; update only the 112-byte state between calls. Never
mutate lookup data concurrently or overwrite a command buffer while drawing is
using it. BIND checks all buffer ranges for aliases, validates the canonical
asset hash and independently validates directory sizes/offsets. It stores IDs,
not pointers. PREPARE reacquires views and releases every lease on all paths.

Install the ready-clearing wrapper before using silent RUN. It handles failure
before native entry; the native module alone cannot clear readiness when it is
never invoked. Successful publication is last, after all three output buffers
are terminated. Failure can leave partially overwritten bytes in an output
buffer, but the wrappers skip all three outputs while ready is zero. A native
crash or infinite loop is not contained by this protocol.

ABI1 accepts current route heading ±1920 and lateral Q8 ±14260 from the frozen
route proof. Player lateral accepts ±38400. Rebind before successful sequence
wrap; failed sequences can be retried. INIT/FINI and failed BIND invalidate the
binding. This is a trusted native module, not a security sandbox.

## Qualification boundary

The host oracle verifies commands and integer coordinates, not physical pixels.
Its generic binary32 multiplication is not proof of the actual classic-ESP32
DSP implementation's rounding or negative float-to-word conversion. Physical
VDPlet execution, DSP parity, stack watermark, Canvas queue/resource lifetime,
framebuffer parity and performance remain mandatory next-stage checks.

Do not deploy the `.vdpl` packages based solely on these local results. The
current full game, firmware, SD card and emulator profiles have not been changed.
