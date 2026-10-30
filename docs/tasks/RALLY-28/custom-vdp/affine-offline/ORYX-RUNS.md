# Oryx qualification of the frozen affine fixture

`oryx_control.py` prepares new profiles and runs the same frozen command fixtures
on Oryx. It leaves the Pi5 controller, fixtures and receipts unchanged. It does
not connect to Oryx; run it from the repository root on Oryx Linux Lite.

The controller imports the existing `throughput/oryx_session.py` supervisor
unchanged. Each supervised session records and temporarily disables CPU boost,
retains the original 95°C thermal limit, stops its owned processes, and restores
the actual initial boost setting. A read-only preflight refuses any already
running Agon emulator and checks the same temperature limit before launching a
child. It never stops competing or unowned processes. Both the generated
profile-local launcher and controller force SDL video and audio to `dummy`.

The runtime is built separately from the same published frontend/core pins.
Staging requires a successful, unchanged-source, x86-64
`ORYX-RUNTIME-BUILD.json`, and verifies both binaries under
`.work/oryx-flexe-source/build/`. It also verifies the official MOS 3.0.2 binary
and map, stock VDP 2.16.0 firmware, and every frozen fixture file before creating
a fresh profile. It does not compile or change the target application.

Run the finite runtime builder under the original supervisor, after its source
archives have been prepared and transferred:

```bash
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/affine-offline/oryx_control.py host affineoryxbuild01 -- .venv/bin/python docs/tasks/RALLY-28/custom-vdp/affine-offline/oryx_runtime_build.py
```

Prepare and run the small callback smoke before a full measurement. The explicit
MOS seed below must exist on Oryx; `--mos-seed` also accepts a profile with its
MOS binary/map at the profile root and commands under `sdcard/bin`.

```bash
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/affine-offline/oryx_control.py stage smoke01 --fixture smoke --mos-seed ../golem/.emulator/runtime/fab-1.2.5
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/affine-offline/oryx_control.py session affineoryxsmoke01 smoke01
```

After that run passes independent verification, use a new profile and session:

```bash
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/affine-offline/oryx_control.py stage full01 --fixture full --mos-seed ../golem/.emulator/runtime/fab-1.2.5
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/affine-offline/oryx_control.py session affineoryxfull01 full01 --timeout 900
```

Profile names are `.emulator/rally28-hz60-affine-oryx-NAME`. Each attempt gets
fresh `ORYX-PROFILE-NAME.json`, `ORYX-RUN-NAME.json` and `evidence/oryx/NAME/`
outputs. The existing guard creates its own `SESSION-SESSIONNAME.json`; session
names are alphanumeric because that is the guard's unchanged contract. Stage
names may also contain hyphens. No profile or output is reused or overwritten.
Startup failures are retained; this controller performs no automatic retry.

For independent verification, pass the Oryx runtime manifest explicitly:

```bash
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/affine-offline/target_verify.py --profile .emulator/rally28-hz60-affine-oryx-full01 --fixture full --runtime-manifest docs/tasks/RALLY-28/custom-vdp/affine-offline/ORYX-RUNTIME-BUILD.json --evidence docs/tasks/RALLY-28/custom-vdp/affine-offline/evidence/oryx/full01
```

The `host SESSION -- COMMAND...` action also supervises a finite host benchmark
or compiler command, recording its exact arguments and output hash in fresh
`ORYX-HOST-SESSION.json` and `.txt` files. It stops that command's process group
on interruption before the original supervisor restores boost. This action is
for the explicitly authorized build/benchmark commands; it is not an emulator
launch shortcut.

Oryx measurements remain emulator measurements. Preserve host elapsed time,
nominal guest MOS/PRT clocks and any future physical measurements separately.
