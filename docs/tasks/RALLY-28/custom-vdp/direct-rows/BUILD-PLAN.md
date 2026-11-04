# ROW-001 serial build and bounded source checks

Author2026-11-04 selected this direct-row experiment and ordered task/commit/push before execution; contract pushed0715d5f.

Finite scope: compile/link two native modules (bitmap and rows) with SDK10947e0, same corrected PSRAM policy and declared32768/4096/2048/65536limits. Serial children only, 180s timeout each. Expected under2min and512MiB RAM. Preserve errors/ELF/map/stack reports. A failed admission does not raise allowances or select legacy flags. Any necessary source correction is recorded separately before rebuilding.

Ordinary source qualification may compile three small host shared libraries in ordinary and ASan/UBSan modes and run the finite900-frame/3600-step correctness comparison plus bounded row/error probes. These are source checks, not timing/stress/emulator work. No eZ80 guest, generic firmware, emulator, hardware or remote operation in this reservation. If native size blocks the experiment, retain that concrete result; no target run.

Cleanup: join every owned compiler/check child, preserve logs, assert/release the shared build token using work-stopped/cleanup-complete. At most one build process at a time. No manager approval or CPU quota under current canonical serial-build policy. Read thermal sensor before launches and stop at80C or missing sensor; native compiler subprocesses are finite.
