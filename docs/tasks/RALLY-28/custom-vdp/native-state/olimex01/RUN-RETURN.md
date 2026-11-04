# Olimex run return — six cases complete

All six exact900-frame/3600-step/two-warm fixtures passed state, reply, player, timer-restoration, UNLOAD and completion-fence checks. Original firmware restoration is in progress; custody remains held. No new timing guidance has been implemented.

| Case | MOS FPS | Nominal PRT FPS | MOS ticks | PRT ticks | Replies |
|---|---:|---:|---:|---:|---:|
| baseline1 | 30.000 | 30.058 | 3600 | 29942 | 2025 |
| state1 | 30.000 | 30.058 | 3600 | 29942 | 2025 |
| coarse1 | 30.000 | 30.058 | 3600 | 29942 | 2025 |
| coarse2 | 30.000 | 30.058 | 3600 | 29942 | 2025 |
| state2 | 30.000 | 30.058 | 3600 | 29942 | 2025 |
| baseline2 | 30.000 | 30.058 | 3600 | 29942 | 2025 |

The paired Flexe results are already durably recorded in ../RESULTS.md and ../REPORT.json: pooled nominalPRTFPS39.5179baseline,38.5902state,38.7305coarse. Its MOS clock reports60FPS for allarms and disagrees with PRT; do not relabel that as60physicalFPS. Hardware results use the exact same application/asset/config/module/firmware inputs; hardware Eirene differs from emulator MOS and printermirror is enabled for hardware completion observation. This is an end-to-end cohort comparison, not an isolated renderer or calibrated emulator clock measurement.

All final406-byte state images match the independent expected state. Raw self-generated data and independent checks are in evidence/returned-CASE/. No cases retried or discarded. Engine audio remains enabled/unassessed; no human optical pass claimed.

Complete restoration/readback, native entry-mode/cwd/CLI/input verification and central release remain prerequisites for closing this hardware task.
