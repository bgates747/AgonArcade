# RALLY-24 portable native-rendering fixtures

The fixtures execute real Xtensa VDPlets in the runtime-enabled classic ESP32
VDP. They run from an ordinary MOS prompt and save measurements in their own
SD directories. These are diagnostic scenes, not an integrated playable Rally
build. See [RESULTS.md](RESULTS.md) for the remaining pixel-parity exception.

## 1. Build and reproduce

From the AgonArcade checkout root:

```bash
make -C docs/tasks/RALLY-24/experiment all
.venv/bin/python docs/tasks/RALLY-24/flexe/build.py
.venv/bin/python docs/tasks/RALLY-24/flexe/stage.py --host oryx-linuxlite
```

The local builder uses the sibling `agon-vdplet` SDK/toolchain and the owned
GOLEM-021 MOS runner's API include/assembler. This reuses the native emulator
integration, not the abandoned Golem graphics experiment. `probe.asm` is a
Rally-owned adaptation of that assembly runner; no external sources change.
The SDK firmware export must already exist under
`../agon-vdplet/build/firmware/firmware-src/.pio/build/esp32dev/`.

On Oryx, after staging:

```bash
.venv/bin/python docs/tasks/RALLY-24/flexe/remote.py --case oval-b --engine jit --timeout 180
```

Cases: `fuji-replay`, `fuji-a`, `fuji-b`, `oval-replay`, `oval-a`, `oval-b`,
`matrix`. Repeat with `--engine interp`. This script uses the generated
profile-local launcher with dummy SDL video/audio and normal eZ80 limiting;
it does not launch a GUI. Canonical network guidance owns the SSH setup.

Profiles live under the Oryx project's `.emulator/rally24/CASE-ENGINE/`.
Each has local firmware snapshots, a copied adapter, SD contents and a
`.runtime.sha256` manifest. Older `last-run` artifacts move into profile
`history/`; task evidence is copied before stopping. The emulator's raw binary
is never the launch entry point.

## 2. Run on the physical Agon

1. Use the matching **VDPlet-enabled** VDP firmware; stock VDP cannot execute
   these modules. The archive includes the tested firmware image and hashes
   for your firmware/deployment agent. No physical firmware was changed here.
   The emulator used MOS 3.0.2. Run in mainboard/legacy mode, not EDP/excom.
2. Copy the archive's `r24` directory to the SD root. Keep each fixture intact.
3. At MOS, use these commands for each case:

   ```text
   cd /r24/oval-b
   exec run.txt
   ```

4. Wait for `RALLY-24 DONE: logs saved.` and the MOS prompt. The scene is retained
   on the front page; the text can land on the back page in double-buffered
   mode. For an individual run, type `mode 0` after it returns to restore a visible
   MOS console, then `dir` to inspect the logs. Scenes advance through
   32 fixed poses; this is not interactive driving.
5. Copy `replies.log`, `ticks.log`, and `failure.log` if present, **together with
   `expected.json`**, from that same fixture directory. Copy results aside before
   rerunning: the runner deletes old logs at startup so a failed run cannot
   masquerade as an earlier success.
6. Run all six scene cases on the same firmware, then `matrix`. Record firmware
   identity, device, CPU frequency and run order with the returned logs.

No `autoexec.txt` replacement is necessary. The fixture does not alter production
Rally, scores or assets outside its own directory. It returns to MOS and unloads
its module after a successful run. Allow roughly a minute per first physical
run; the emulator's 10–16-second host durations do not establish hardware runtime.

## 3. Decode results

On the development host, point the decoder at the copied fixture directory:

```bash
.venv/bin/python docs/tasks/RALLY-24/flexe/decode.py /absolute/path/to/copied/oval-b
```

It verifies every reply's token/type/value, command hashes and log lengths,
then writes `timings.json` beside the logs. For `matrix`, it writes `matrix.json`.
A `failure.log` is a compact binary record: completed transaction count u24,
reply flags u8, expected kind u8, expected token/value/handle u16 each, then
10-byte live mailbox and 10-byte snapshot. The expected manifest identifies
which check failed. A hang during upload may precede any saved guest log;
retain the visible state and the host/emulator transport trace if available.

## 4. What the measurements mean

1. `replay` transmits the current renderer's **precomputed** commands. It measures
   submission/drawing, excluding the eZ80's projection calculations.
2. A generates the same buffered-matrix commands natively. B computes road
   endpoints natively and emits ordinary PLOT commands. Traffic, signs and the
   player use the same resident artwork and existing VDP bitmap transformations.
3. Each batch has 32 deterministic world states; timing percentiles omit the
   first four. The scene covers both tracks, material boundaries, signed lateral
   offsets, steering and six traffic cars. It clears the page each frame rather
   than running the game's scrolling-sky/HUD/audio/history/physics workload.
4. CCOUNT starts before native generation (or replay submission) and is sampled
   after normal synchronous `swapBuffers`. Entry 1 generates; entry 2 records
   completion and hashes; entry 3 begins a replay interval. Metrics buffer31012
   contains 32 records of eight little-endian u32 values: sample, generation
   cycles, start cycles, end cycles, three command FNV hashes, status.
5. Hashing occurs **after** the end timestamp. It and the diagnostic native calls
   still add overhead between samples/in the batch. There are no per-frame
   replies or SD writes. After the batch, READ16 extracts the buffered records
   through the normal callback mechanism and MOS writes the logs.
6. `ticks.log` contains atomic u24 MOS clock samples: batch start, then before/
   after submission for each frame, then completion after an ordered INFO reply.
   Displayed milliseconds assume 240 MHz ESP32 and 120 MOS ticks/s. The legacy
   include's “centiseconds” comment is not the conversion used here. Preserve
   raw counts to recalibrate when testing a different mode/clock.
7. Completed swaps are not optical presentation measurements. Emulator CCOUNT
   and MOS clocks are modelled; different host/JIT scheduling affects aggregate
   pacing. Neither those numbers nor replay FPS establish actual game FPS.

## 5. Resource and protocol safeguards

Startup streams exceed the 16-bit RST18 byte count and are sent in 32 KiB chunks.
The tape is loaded at050000 (maximum030000 bytes), startup at080000 (at most
040000 bytes; current largest209200). Logs and runner stay below050000. The
builder enforces limits on tape, observations and tick samples.

The diagnostic wrapper keeps only one module resident, uses at most three
simultaneous leases and splits its finish helper from native generation to
keep its estimated module-only stack chain within512 bytes. Runtime callback,
interrupt and register-window spill overhead is additional; the fixture also
records the command-task minimum free stack. The SDK/runtime is unchanged.

The draw guard compares ready against the immutable argument ABI-version byte
using buffered equality (`0x22`). A literal comparison fails in the pinned VDP
because its one-byte operand read preserves upper bytes of an int32 initialized
to-1. See the source-backed findings in RESULTS.md. The three draw wrappers
remain six-byte recurring CALLs; their slightly larger installation is untimed.

Run the commands above from the checkout root. The staging script requires
`--remote-root` with the destination checkout path; it does not assume a local
directory name on the remote machine.
