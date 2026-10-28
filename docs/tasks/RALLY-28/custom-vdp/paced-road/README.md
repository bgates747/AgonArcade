# Paced native Rally renderer comparison

The exact Rally-25 control and eleven road variants, including the control now build and pass host/target qualification. Stock four-corner fills give the best observed Flexe result; reduced overdraw and integer arithmetic did not improve this native workload. Fresh silent Oryx review profiles are stopped for the Author. Hardware gains and motion acceptance remain unqualified.

The Author released the first logical tranche after the all-dirt checkpoint pushed as `bb20c48`. NATIVE-AB-001-01/02 are complete. Author subsequently released continuation:03/04 are delivered,05 has headless qualification and stopped review profiles, with its human gate still open in the [parent task](../../../RALLY-28.md). Every automated run forced both SDL dummy drivers with boost disabled; no physical run/deployment or host power-setting change was performed here.

1. [Control manifest](CONTROL.json) freezes the application, native package, helper, accepted SDK builder, source and raw returns. [Target rebuild](TARGET-REBUILD.json) proves the actual native module and ELF files rebuild byte for byte. The recovered assembly also rebuilds the exact tested eZ80 binary, rather than the newer source's different pacer.
2. [Stock-path findings](STOCK-PATH.md) identify the available command, vertex order, clipping, rasterization and completion behaviour. [Probe receipt](STOCK-PATH.json) records 360 ordinary and 360 ASan/UBSan cases using functions extracted unchanged from the pinned firmware sources.
3. [Pacer correction](PACER-CORRECTION.md) distinguishes the tested 3/3/4-unit sequence from the source's later four-unit pacer. Both control and renderer candidate must retain the tested binary for the requested first apples-to-apples comparison. The upstream documentation correction is [PR #86](https://github.com/AgonPlatform/agon-docs/pull/86); firmware behaviour is unchanged.

From the project root, reproduce this work with:

```bash
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/paced-road/freeze_control.py
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/paced-road/rebuild_control.py
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/paced-road/inspect_stock.py
```

These commands use the documented pinned local deliveries/toolchain, run only host checks/compilers, and never launch an emulator. Build artifacts are isolated in ignored `.work/`. `control/returns/` preserves guest logs as `.bin` so the repository-wide `*.log` rule does not discard raw evidence.

Subsequent native candidates can reuse the frozen generated `native.c` and build-level bindings while replacing the Rally-owned helper include. This first geometry/drawing change needs no compiler, SDK ABI, runtime or firmware change. If those assumptions change during implementation, coordinate the concrete dependency through the established Golem mailbox; no peer files have been changed or live compiler adopted.

Candidate results are in [CANDIDATE-RESULTS.md](CANDIDATE-RESULTS.md), with source in `road_candidate.inc`, independent axes in `build_candidates.py`, annotated target assembly in `assembly/`, and immutable fixture/module bytes in [CANDIDATES.zip](CANDIDATES.zip). All existing simulation/generated C/ABI/runtime/firmware bytes remain unchanged. Each candidate patches only its native setup image and LOAD length in the script; every per-frame tape record and the eZ80 driver are byte-identical to the control.

Reproduce the candidate work after the initial control steps:

```bash
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/paced-road/build_candidates.py
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/paced-road/qualify_candidates.py
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/paced-road/check_failures.py
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/paced-road/check_raster.py
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/paced-road/inspect_codegen.py
```

Profile staging and finite campaigns are separate explicit operations on Oryx. Use a fresh suffix, preserve all existing runs and force both SDL dummy drivers for automation; `run_campaign.py` rejects enabled boost before launch. Human profile commands and expected behaviour are in [HUMAN-REVIEW.md](HUMAN-REVIEW.md). The preserved startup failure and bounded fresh retry are documented in [STARTUP-FAILURE.json](STARTUP-FAILURE.json), raw evidence under `evidence/auto01/integer-quad-strips/`; transfer stopped428bytes into the module-upload record, before LOAD/rendering. The same candidate completed in a fresh `finish01` profile without any byte change.

Human review copies now blank the startup-only `30-Hz target / foreground fixture` line, which flashed because per-frame painting repeats only the first two title lines. Equal-length spaces preserve the artwork length, cursor position and entire driver tape. `quiet_startup.py` applied this cosmetic change to the four stopped human profiles, preserving previous files in ignored `.work/review-startup-backup/`; all other profile files, including existing outputs, were hash-checked unchanged. See [REVIEW-STARTUP.json](REVIEW-STARTUP.json). Frozen controls, the candidate archive and recorded benchmark inputs remain unchanged. For future human profiles, pass `--hide-startup-status` to `stage_profiles.py`; benchmark staging keeps its original default.
