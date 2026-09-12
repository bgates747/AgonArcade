# VDP road-section experiment

The immutable execution contract is [RALLY-15.md](../RALLY-15.md).
[checkpoint.json](checkpoint.json) identifies the checksum-verified archive
of 126 pre-implementation files, including the contract and mainline binary.
No Git commit was made. Root `TODO.md` remains the authoritative checklist.

## Implementation

1. [section_road.hpp](section_road.hpp) merges an exact material-phase lookup
   with the existing conservative curve limits. It projects only the resulting
   boundary centres, plus explicit traffic-centre requests. It never projects
   all viewport rows or searches for geometric fits at runtime.
2. [protocol.py](protocol.py) generates [section_protocol.hpp](section_protocol.hpp).
   The VDP stores two complete pavement/kerb/marking templates and their drawing
   programs. The eZ80 sends four signed endpoints and a program selection:
   25 UART bytes per section, after an 864-byte startup upload.
3. The VDP uses a resident coefficient matrix to construct a 4×4 transform,
   transforms `(u,v,u*v)` template vertices embedded in PLOT records, and calls
   the resulting buffer. Widths, skew, strip coordinates and expanded drawing
   commands are constructed on the VDP. No runtime eZ80 floating-point math
   is introduced.
4. [experiment.py](experiment.py) copies frozen mainline inputs into isolated
   `.work/` build directories, applies four checked substitutions to the copied
   `main.cpp`, and adds task headers/tests. Linux compiles and runs sanitizer
   tests in fresh remote scratch directories. The control rebuild must reproduce
   the frozen mainline binary exactly. Mainline sources, assets and binary are
   fingerprinted and checked after every action.

The first iteration deliberately reuses conservative curve limits: typical
section counts exceed the earlier minimum-fitting audit. It preserves geometry
quality while measuring this architecture. See [geometry notes](geometry-notes.md)
and [protocol notes](protocol-notes.md) for scope and evidence.

## Reproduce

Run all commands from the repository root, using the repository Python:

```sh
.venv/bin/python docs/tasks/RALLY-15/generate_phase_table.py --check
.venv/bin/python docs/tasks/RALLY-15/protocol.py --check
.venv/bin/python docs/tasks/RALLY-15/test_protocol.py -v
.venv/bin/python docs/tasks/RALLY-15/experiment.py build --variants full probe sections
.venv/bin/python docs/tasks/RALLY-15/experiment.py probe
.venv/bin/python docs/tasks/RALLY-15/check_probe.py
.venv/bin/python docs/tasks/RALLY-15/experiment.py capture
.venv/bin/python docs/tasks/RALLY-15/experiment.py bench
.venv/bin/python docs/tasks/RALLY-15/summarize.py
.venv/bin/python docs/tasks/RALLY-15/experiment.py demo
```

Actions run serially. Generated builds and profiles are ignored. Protocol/phase
generators write only this task's headers; `--check` rejects stale output.
Every build includes the existing host tests; the sections build additionally
runs [test_sections.cpp](test_sections.cpp) under ASan/UBSan.

`probe` and `capture` use the local [SDL interposer](capture_macos.c) with dummy
video/audio. The probe compares twelve adjacent resident sections with an
independent direct-PLOT reference, including one-/two-row bands, both patterns,
strong skew and negative/clipped endpoints. Performance runs omit the interposer
and use the local [timing harness](run_timing.py). `demo` separately measures
20 seconds of ordinary moving gameplay with physics enabled on each track;
it is not the fixed-pose A/B comparison. Both helpers were copied from
RALLY-10 into this bucket, so no executable dependency on that task remains.

For the human review notification only:

```sh
.venv/bin/python docs/tasks/RALLY-15/experiment.py review
```

This generates `.emulator/review`, writes CRLF `autoexec.txt`, and starts the
canonical profile-local `./fab-agon-emulator` wrapper with a graphical window.
All other emulator actions are headless. The scene starts in demo mode; any key
takes control and Escape returns to MOS. Mainline and the pavement experiment
remain unchanged. The Author authorized committing this development checkpoint on 2026-09-12.
Human renderer acceptance and hardware qualification remain pending.
