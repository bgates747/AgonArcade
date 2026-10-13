# Local Rally source-copy inventory

Read-only scan on 2026-10-13: 218 source copies, including ignored build archives. These are copies, not 218 independently designed games. Classification follows the instantiated renderer in main.cpp; full_game identifies rules.hpp/GameState use. Binary hashes identify files on disk, not freshly reproduced builds.

Scanned AgonArcade, AgonArcade-rally19 and sibling rally-* scratch directories; excluded .git, .venv, node_modules, .emulator and Python caches. Native RALLY-24 modules are separately catalogued in README because they have no src/main.cpp.

## GolemRenderer

| Source copy | Full game | Binary SHA256 (if present) |
| --- | --- | --- |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/lifecycle/hardware-inline/src/main.cpp` | no | `226e3cf536b95cb28983abf308fcfafc8748267146d466c6d585599036d59c86` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/lifecycle/checked-cleanup/src/main.cpp` | no | `ca7c69ca29f664c55396deeccf867d9ea5e0744edcbf7f55419e2ed7fe7ab964` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/lifecycle/initial/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/lifecycle/initial-status/src/main.cpp` | no | `2c6cdf98e654f6f3218c30be61749558d3e3a162130b72db1223a5f5d44c47cc` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/cpu-calibration/hardware-inline/src/main.cpp` | no | `d6d4b1d4c2238c8eb39b1e54b8793b3a51c2c718509ec36400976a0cc1b680de` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/cpu-calibration/initial/src/main.cpp` | no | `83dff445fc60870f14dd5dc5cb271ddd7cef1f86c2b3c17ccf67938df29d8451` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/stability/hardware-inline/src/main.cpp` | no | `00d39198706527d4e3392c739f6b04eff01374c4c1dada3cac528a41fa8aabe6` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/stability/corrected-host/src/main.cpp` | no | `628732c8be7b41b148573e6468ab39ee25949b9d80b7fa097f2e5769987633a0` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/stability/checked-assets/src/main.cpp` | no | `6f26bd112ebbb43921594f578cb9218d32dd32c0b3bd4381a56ff3209617a06f` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/stability/initial/src/main.cpp` | no | `628732c8be7b41b148573e6468ab39ee25949b9d80b7fa097f2e5769987633a0` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/failure/released-art-tags/src/main.cpp` | no | `73ee3c517fd8264aeb22fdb50db16544e2cf7ea224ece7f8a2a19c0d63252a69` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/failure/hardware-inline-oval-missing-vdp/src/main.cpp` | no | `3ccd185dc8f187b63a3a3582f31298148429b9825520a3e63c0ac275fd7394ab` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/failure/retained-art/src/main.cpp` | no | `25c801f06fee57f8766ea3e816640ab4155456c332f47d652605cd421da5e018` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/failure/hardware-inline-oval-missing-clr/src/main.cpp` | no | `3ccd185dc8f187b63a3a3582f31298148429b9825520a3e63c0ac275fd7394ab` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/failure/hardware-inline-oval-corrupt-vdp/src/main.cpp` | no | `3ccd185dc8f187b63a3a3582f31298148429b9825520a3e63c0ac275fd7394ab` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/failure/hardware-inline-fuji-corrupt-vdp/src/main.cpp` | no | `3ccd185dc8f187b63a3a3582f31298148429b9825520a3e63c0ac275fd7394ab` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/failure/hardware-inline-fuji-missing-clr/src/main.cpp` | no | `3ccd185dc8f187b63a3a3582f31298148429b9825520a3e63c0ac275fd7394ab` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/failure/hardware-inline-fuji-missing-vdp/src/main.cpp` | no | `3ccd185dc8f187b63a3a3582f31298148429b9825520a3e63c0ac275fd7394ab` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/failure/released-art/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/failure/hardware-inline-fuji-corrupt-clr/src/main.cpp` | no | `3ccd185dc8f187b63a3a3582f31298148429b9825520a3e63c0ac275fd7394ab` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/failure/hardware-inline-oval-corrupt-clr/src/main.cpp` | no | `3ccd185dc8f187b63a3a3582f31298148429b9825520a3e63c0ac275fd7394ab` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/production/hardware-inline/src/main.cpp` | no | `64c8b0734bcd253112d162173fc38f343eafbc96894dc1d09b4793766ed59129` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/production/hardware-oval/src/main.cpp` | no | `2d6b0d385f1b271c77cebb37e6a253ac55b11bf11d8df91a0b2720ed1829bbee` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/production/inline-b/src/main.cpp` | no | `64c8b0734bcd253112d162173fc38f343eafbc96894dc1d09b4793766ed59129` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/production/inline-a/src/main.cpp` | no | `beb265e284968ee5d45578e4d9adeff37465e164110cd2d9dd5bcc00b053147f` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/render-work/hardware-inline/src/main.cpp` | no | `bf54f5b43e854cf0c6a5a4878a856b503988167cf772b9181eed2514c6701333` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/render-work/checked-cleanup/src/main.cpp` | no | `b708f88a424944f0eed65c4dff5087d52b8cd6040bf00191966804f8322eaca9` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/render-work/initial/src/main.cpp` | no | `6814b136ba789762e635908d4a6741d2001423469687be3620ed0bd07f240518` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/cpu-work/hardware-inline/src/main.cpp` | no | `4c56cc3f5c9a8b7904037a3ac79b338601fd11685c18593a57bf7d017773f54d` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/cpu-work/both-outputs/src/main.cpp` | no | `4afecd5821502daf49cfd3118bc3ed00d3684ccef349df25db75876e6dc8c2f9` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/cpu-work/initial/src/main.cpp` | no | `c1c6d8ead70e4898eb31406595271b3101463ffb77610defa4b51d8d7b8b5ffd` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/frontend/hardware-inline/src/main.cpp` | no | `0401d8af5e895832371b417a12d1a455b0dfb132f772c202328ef11f3f1da64b` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/frontend/checked-cleanup/src/main.cpp` | no | `aac631bc1bbf8f694c0dc94fba0413c7ac4eab1d64f7b503ea5ee3ebbb3989e1` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/frontend/checked-assets/src/main.cpp` | no | `f39646ce4f38258cf31529c7d504a8c29b24ac9c6284cb83a9b17a4fe210caed` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/frontend/controls/src/main.cpp` | no | `77e80f791d73a1180f987e94646a99d90068c1e839539a17c45b3555f5122c7f` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/frontend/initial/src/main.cpp` | no | `23cca88a560c9a0f47de85e388845e5d7526c993a82065d30f3e27a36c055f50` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/frontend/fixed-default/src/main.cpp` | no | `4ca98475b52277d0899d528425995c5f4bd2428d11677eccc1c873f76d6de84a` |

## LookupRoad

| Source copy | Full game | Binary SHA256 (if present) |
| --- | --- | --- |
| `.research-cache/rally22/builds/4be88dd1c8efbb6f7cddbdce1b98ee8805572f47550cda5d8c0ef3207189395b/source/rally-game/src/main.cpp` | yes | `absent` |
| `rally-production/src/main.cpp` | no | `absent` |
| `rally-game/src/main.cpp` | yes | `4be88dd1c8efbb6f7cddbdce1b98ee8805572f47550cda5d8c0ef3207189395b` |
| `rally-bench/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/road-visual/covered-clear-smoke/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/road-visual/covered-clear-smoke/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/road-visual/covered-clear-oval/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/road-visual/covered-clear-oval/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/road-visual/admitted-loader-oval/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/road-visual/admitted-loader-oval/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/road-visual/clipped-clear-fuji-a/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/road-visual/clipped-clear-fuji-a/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/road-visual/admitted-fuji-a/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/road-visual/admitted-fuji-a/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/road-visual/initial-oval/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/road-visual/initial-oval/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/road-visual/complete-fuji-a/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/road-visual/complete-fuji-a/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/road-visual/complete-oval/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/road-visual/complete-oval/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/road-visual/covered-clear-fuji-a/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/road-visual/covered-clear-fuji-a/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/road-visual/covered-clear-fuji-b/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/road-visual/covered-clear-fuji-b/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/road-visual/clipped-clear-oval-smoke/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/road-visual/clipped-clear-oval-smoke/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/road-visual/admitted-first-oval/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/road-visual/admitted-oval/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/road-visual/admitted-oval/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/road-visual/clipped-clear-oval/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/road-visual/clipped-clear-oval/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/production/pre-golem-oval/src/main.cpp` | no | `e14e5c0f155a4f035e925b1da5971e8f7202fe47c7147e24a5726ef937d4fe5f` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/vehicle-visual/player-views-fuji/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/vehicle-visual/player-views-fuji/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/vehicle-visual/raw-trace-oval/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/vehicle-visual/raw-trace-oval/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/vehicle-visual/raw-trace-include-oval/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/vehicle-visual/raw-trace-include-oval/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/vehicle-visual/initial-oval/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/vehicle-visual/initial-oval/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/vehicle-visual/complete-fuji-a/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/vehicle-visual/complete-fuji-a/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/vehicle-visual/complete-oval/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/vehicle-visual/complete-oval/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/vehicle-visual/player-views-oval/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/vehicle-visual/player-views-oval/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/vehicle-visual/complete-fuji-b/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/vehicle-visual/complete-fuji-b/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/oracle/src/main.cpp` | no | `03322954c8c4fe29d90eaa0706c9169b242cdd264ea3b7b287cece58a6469d79` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/section-visual/initial-oval/oval-oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/section-visual/quantized-fuji-b/fuji-oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/section-visual/quantized-fuji-b/fuji-candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/section-visual/loader-oval/oval-candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/section-visual/loader-oval/oval-oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/section-visual/quantized-oval/oval-candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/section-visual/quantized-oval/oval-oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/section-visual/quantized-fuji-a/fuji-oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/section-visual/quantized-fuji-a/fuji-candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/section-visual/exact-centres-oval/oval-candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/section-visual/exact-centres-oval/oval-oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/section-visual/packed-fuji-b/fuji-oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/section-visual/packed-fuji-b/fuji-candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/smoke-oval/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/smoke-oval/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-fuji-40/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-fuji-40/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-fuji-8/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-fuji-8/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/hardware-inline-oval-8/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/hardware-inline-oval-8/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/hardware-inline-fuji-32/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/hardware-inline-fuji-32/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/hardware-inline-fuji/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/hardware-inline-fuji/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/frozen-fuji-32/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/frozen-fuji-32/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-fuji-0/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-fuji-0/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-oval-0/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-oval-0/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-oval-16/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-oval-16/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/hardware-inline-fuji-8/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/hardware-inline-fuji-8/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/frozen-oval-8/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/frozen-oval-8/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/frozen-oval-0/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/frozen-oval-0/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/frozen-fuji-24/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/frozen-fuji-24/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/frozen-fuji-16/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/frozen-fuji-16/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-oval-8/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-oval-8/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-oval-56/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-oval-56/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-oval-32/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-oval-32/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/frozen-oval-16/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/frozen-oval-16/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-oval-40/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-oval-40/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/hardware-inline-fuji-16/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/hardware-inline-fuji-16/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-fuji-16/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-fuji-16/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/frozen-fuji-0/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/frozen-fuji-0/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/hardware-inline-oval-16/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/hardware-inline-oval-16/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-fuji-56/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-fuji-56/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-fuji-24/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-fuji-24/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/hardware-inline-oval/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/hardware-inline-oval/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-fuji-32/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-fuji-32/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-fuji-48/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-fuji-48/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/frozen-fuji-40/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/frozen-fuji-40/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-smoke-oval/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-smoke-oval/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/hardware-inline-fuji-40/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/hardware-inline-fuji-40/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/frozen-fuji-8/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/frozen-fuji-8/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-oval-48/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-oval-48/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-oval-24/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/history-oval-24/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/hardware-inline-fuji-24/oracle/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/scenery-visual/hardware-inline-fuji-24/candidate/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/docs/tasks/RALLY-19/.work/fixture/src/main.cpp` | no | `9a27f17637dff37a0442c7e4abfe1361d9049798b01050b0910a7fe17d409d41` |
| `~/Agon/mystuff/AgonArcade-rally19/.research-cache/rally22/package-check01/project_files/.research-cache/rally22/builds/364e9187a4170abe714a7ca98f7207b3272fa13a97053b929543d9f555f98bf8/source/rally-game/src/main.cpp` | yes | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/.research-cache/rally22/package-check01/project_files/rally-game/src/main.cpp` | yes | `364e9187a4170abe714a7ca98f7207b3272fa13a97053b929543d9f555f98bf8` |
| `~/Agon/mystuff/AgonArcade-rally19/.research-cache/rally22/builds/a7e29e1090ad15237179cb332a79ff89fb39a44bb68006c9b5cb6ec08d860d16/source/rally-game/src/main.cpp` | yes | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/.research-cache/rally22/builds/03e588e065439a29c56c46b18e83a18583c6935455d40775b4b8a031728f171b/source/rally-game/src/main.cpp` | yes | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/.research-cache/rally22/builds/3d9a5751abe4b0747370bd4dd9fb10c6d6bf6ed2ba24886ec35d12f92ad9383b/source/rally-game/src/main.cpp` | yes | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/.research-cache/rally22/builds/51802b9b0e3cb880ee702fed7712aca557de3c1483f5a3c30e8182b38dd2ee9c/source/rally-game/src/main.cpp` | yes | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/.research-cache/rally22/builds/89a0bdddec4bb347b9446278d55a25e8f279f93189bedb6850a7e06293811b24/source/rally-game/src/main.cpp` | yes | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/.research-cache/rally22/builds/cbbfff74c360b896e324d5c6e046ec2b6174e0df3fc11b8a38d8ec4e52012e52/source/rally-game/src/main.cpp` | yes | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/.research-cache/rally22/builds/091d2a2a6d1635df81811540d34a5984fbae67018a6ca40a9fb7b07ebda8c771/source/rally-game/src/main.cpp` | yes | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/.research-cache/rally22/builds/5f9a81a796568726e7bfa805037ee87f08a321439a10ce9e716b4f614c18e349/source/rally-game/src/main.cpp` | yes | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/.research-cache/rally22/builds/aed5f951c4954d5d4b225548347bd73c410ce5631a9dce0afd7ec6e41dee53d0/source/rally-game/src/main.cpp` | yes | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/.research-cache/rally22/builds/c32a5c51f354fe6806ab8114f781fede20ba309af5408a57191267e553498546/source/rally-game/src/main.cpp` | yes | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/.research-cache/rally22/builds/364e9187a4170abe714a7ca98f7207b3272fa13a97053b929543d9f555f98bf8/source/rally-game/src/main.cpp` | yes | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/.research-cache/rally22/builds/45de26d01ec1826e8649cfcd36d2c1f28e62fdc3b7a7103c2d9056f7ef028946/source/rally-game/src/main.cpp` | yes | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/.research-cache/rally22/builds/3ac79285f327bbb0bfe6a56cae7b839f124486a0fbd253647278b8bfa5a40434/source/rally-game/src/main.cpp` | yes | `absent` |
| `~/Agon/mystuff/AgonArcade-rally19/.research-cache/rally22/builds/9ce657cd9df7b2302ec5aa7e975f992c0e2bd93430a25df687ee63de82725cc1/source/rally-game/src/main.cpp` | yes | `absent` |
| `~/Agon/mystuff/rally-mac-build.8tuevN/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/rally-mac-build.Hue3QQ/src/main.cpp` | no | `20622e05c82431b58552be533a749779e30a7e2cfdb7b3352e582896fdf2ab70` |
| `~/Agon/mystuff/rally-mac-build.iVqcYV/src/main.cpp` | no | `07c026f32242a1fca4d5a4d41e84430bb4c06439acbeae33af52e7e051d5f95d` |
| `~/Agon/mystuff/rally-mac-build.yVdOx4/src/main.cpp` | no | `03322954c8c4fe29d90eaa0706c9169b242cdd264ea3b7b287cece58a6469d79` |
| `~/Agon/mystuff/rally-mac-build.zQra2b/src/main.cpp` | no | `475ceb6e51ba52748f3c6e10f882853a6b86e9957f1722b0e99aea0c59e7172c` |

## PavementRoad

| Source copy | Full game | Binary SHA256 (if present) |
| --- | --- | --- |
| `~/Agon/mystuff/rally-mac-build.2sHBce/src/main.cpp` | no | `3d1cd73f959f8a2fef16307fded730f2741b40d10be2621e7649aecd96160ef5` |
| `~/Agon/mystuff/rally-mac-build.U8fEAG/src/main.cpp` | no | `a83db9a54ad2c22f8aed4d81ab093ef114d34b53ff38232830386fffa13ac506` |
| `~/Agon/mystuff/rally-mac-build.riIHr9/src/main.cpp` | no | `fb27f734e737b017578213451b19fb905d9649a6c6b1687eeede0dcb2aad4102` |

## Road

| Source copy | Full game | Binary SHA256 (if present) |
| --- | --- | --- |
| `rally/src/main.cpp` | no | `d08300dc7c0b4ab9b55dbbafc7cf3ba02c1f6e9cb42b8b828385751e1e6aa920` |
| `~/Agon/mystuff/AgonArcade-rally19/rally/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/rally-mac-build.043dYu/src/main.cpp` | no | `10a2068f71972e58da77d1407d5f1fc3963a32edeec57ae536fd50bde94e90c1` |
| `~/Agon/mystuff/rally-mac-build.0zXKEy/src/main.cpp` | no | `2f683dc2ff412b7aadc828fd6778e70f6ba765f0b5810213de5f46fcadbeed84` |
| `~/Agon/mystuff/rally-mac-build.8hxS8U/src/main.cpp` | no | `d08300dc7c0b4ab9b55dbbafc7cf3ba02c1f6e9cb42b8b828385751e1e6aa920` |
| `~/Agon/mystuff/rally-mac-build.I7gyHd/src/main.cpp` | no | `5a6749f16ff6e7de9a17932771c8cf7454bdebf3c8bd117c5d3afb1c4477f684` |
| `~/Agon/mystuff/rally-mac-build.Lt4HLJ/src/main.cpp` | no | `154e61756a7dc19ab219f486e4e107c735a56110a336dcd6b86c85894d7fad8b` |
| `~/Agon/mystuff/rally-mac-build.N6fsne/src/main.cpp` | no | `2f683dc2ff412b7aadc828fd6778e70f6ba765f0b5810213de5f46fcadbeed84` |
| `~/Agon/mystuff/rally-mac-build.NIMiM0/src/main.cpp` | no | `013859c67219ef3b1c0de75204dfae65204fba5271245c4653add4e75b5b8ba2` |
| `~/Agon/mystuff/rally-mac-build.XraBnF/src/main.cpp` | no | `2ca804042731898cd33d66d973d1fe2ae1a9d0d040deaa6760e56056993e0424` |
| `~/Agon/mystuff/rally-mac-build.cNhnEA/src/main.cpp` | no | `d08300dc7c0b4ab9b55dbbafc7cf3ba02c1f6e9cb42b8b828385751e1e6aa920` |
| `~/Agon/mystuff/rally-mac-build.iLWcpn/src/main.cpp` | no | `absent` |
| `~/Agon/mystuff/rally-mac-build.tF9d3j/src/main.cpp` | no | `d08300dc7c0b4ab9b55dbbafc7cf3ba02c1f6e9cb42b8b828385751e1e6aa920` |

## SectionRoad

| Source copy | Full game | Binary SHA256 (if present) |
| --- | --- | --- |
| `~/Agon/mystuff/rally-mac-build.5hKtNr/src/main.cpp` | no | `7066fe202aa8117ddecb2c331ff00f00e4ff7c6049752cd2f605f2cdfee2c92f` |
| `~/Agon/mystuff/rally-mac-build.HnnZdS/src/main.cpp` | no | `e20924abcf693f898198e4222d84bcd9c2a71fad465b7ac4368c49335aeb3d95` |
| `~/Agon/mystuff/rally-mac-build.JMg6cj/src/main.cpp` | no | `ba9c8f1290ecbee3f68ea773c88af383281d2d5946af3ea783f3a4e3d53e6982` |
| `~/Agon/mystuff/rally-mac-build.OtSnlE/src/main.cpp` | no | `372c0cba84743cff1504288c1688d947c45e5aaed77e3fd21f9d3d98cd2168a2` |
| `~/Agon/mystuff/rally-mac-build.WkgeE6/src/main.cpp` | no | `0081dc8164dbfb259f97f6cde29a3f0cc47d599cf1a76c8b218d74bab8c4cfaf` |
| `~/Agon/mystuff/rally-mac-build.doVkad/src/main.cpp` | no | `88e121214037693850ad24e97420399e32ff20b26a722dcb07544847d6d5c6f8` |
| `~/Agon/mystuff/rally-mac-build.qR8aoM/src/main.cpp` | no | `1258dfbc6f3754afebc0d51712ba0b8b7bb7fcd361d8b4209f04609ac182cb9e` |

## direct-versus-buffered section probe

| Source copy | Full game | Binary SHA256 (if present) |
| --- | --- | --- |
| `~/Agon/mystuff/rally-mac-build.DMq8Qy/src/main.cpp` | no | `df01a0835e5b2f9378441f71379d6c504619a9516045e182889b61860f0a6446` |
| `~/Agon/mystuff/rally-mac-build.iiQgl7/src/main.cpp` | no | `2903e1e58a8ff272b606d19fda1b300b5dafb840e5260fdc61ba7992faaa70a7` |


Paths within this checkout are relative to the repository root. Renaming the
checkout does not change the historical inventory hashes or revision identities.
