# RALLY-28 — recover the existing lookup engine

The optimized engine is preserved and reusable. Its original headers and validated track tables are still byte-identical to the RALLY-18 delivery. A small isolated component now combines that projection with final polygon vertices calculated on eZ80 and ordinary stock-VDP drawing commands. Bounded host and sanitizer checks pass. Lookup centre evaluation is much cheaper by operation count, but conservative bands increase command traffic; we need a complete candidate timing comparison before claiming higher FPS.

LOOKUP-001-01 was released after the Author requested this subtask and a logical-group checkpoint of all dirt. Native fixture/evidence/policy was committed as `26bff68`; RALLY-28 audit/research/lookup scope as `038d27a`. Both were pushed to `origin/main`, with a clean tree verified before this assessment. New assessment/proof results are separate from those checkpoints. No product source, emulator profile, firmware or physical card changed; no emulator was launched.

Author steering,2026-10-14: the initial exact-control/precision recommendations here do not rank fidelity above pacing. The parent task now requires viable approximate methods in the first candidate shortlist and a source/decision record; historical one-pixel bounds and this proof's tolerances do not become universal gates. Present faster alternatives and their moving-image tradeoffs for Author selection, including coarser methods previously rejected under older contracts.

## What survives and what the current game runs

| Line | Road projection | Band/material selection | Final vertices / delivery |
| --- | --- | --- | --- |
| Current R27 full game | Live track sampling for121 rows/frame | Original greedy fit and per-row stripe remainder | eZ80 integer vertices; ordinary colour/PLOT |
| R15/R16 `SectionRoad` | Live projection only at requested endpoints/vehicle rows | Precomputed conservative curve and stripe tables | Historically stock-VDP buffered matrix expansion |
| R18/R22 `LookupRoad` | Preprojected screen-line coefficients with per-frame line cache; no map projection for road centre queries | Same precomputed curve/stripe tables | Historically stock-VDP buffered matrix expansion |
| R28 host feasibility, both section variants | The actual preserved `SectionRoad` or `LookupRoad` | Their actual existing tables | eZ80 integer vertices; only ordinary colour/PLOT in road stream |
| Current custom R25 helper | Related coefficient, curve and stripe tables on Xtensa | Native helper | Xtensa geometry plus VDP drawing lists; section corners use binary32 |

R16's section path was already a substantial cleanup: fewer projected rows and table-selected bands. R18 then removed the remaining road map/camera projection using coefficients. These are two useful stages, rather than a choice between every-row brute force and the full coefficient table.

The historical section matrix operations were supported by stock VDP. They were not Golem, VDPlets or custom firmware. Reusing lookup mathematics does not require keeping that matrix emitter. Conversely, replacing the emitter with direct commands does not require throwing away the lookup mathematics.

R27 deliberately replaced both parts with the original live renderer. Its [contract](../../RALLY-27.md) explicitly removed `LookupRoad`/coefficient loading as well as section programs, and its [implementation record](../../RALLY-27/RESULTS.md) confirms dense live projection and greedy bands. This assessment changes the next development choice; it does not reinterpret R27's preserved binary as a lookup build.

## Source and data lineage

| Evidence | Result |
| --- | --- |
| R18 implementation checkpoint `4e951d1`, `docs/tasks/RALLY-18/lookup_road.hpp` | SHA256 `030bd0de511eea291b1a1c5d6a11a0e43aa7e74c3ea863027e79ef08e98c5c8f` |
| Production preservation `4b1579a`, `rally-production/include/lookup_road.hpp` | Same SHA256; current preserved header still identical |
| R18 versus production headers | `lookup_road.hpp`, `lookup_format.hpp`, `section_road.hpp`, `section_protocol.hpp`, `section_phase.hpp` all byte-identical |
| Full-game implementation `91f8337`, later default-grip revision `9e75196` | Both instantiate `rally::LookupRoad`, load track `.road` files and install section startup commands |
| Restoration `a2a613f` | Instantiates `rally::DirectRoad`; later timing additions leave that choice in the maintained game |
| Fuji table |116,800 disk bytes /116,736 resident payload; SHA256 `72f835b888a79f3130e2d8c73c9ab8a80e3dcdc04991ea223038e43ce0d4269e` |
| Oval table |20,584 disk bytes /20,520 resident payload; SHA256 `a433e692f75e086bc0b20f80442cb55f5dda2b445a291fd3537bf951e02cf625` |

The R18 and production data files match one another and the saved manifest. The unchanged generator reproduces both files in an isolated directory when compiled here with **`-ffp-contract=off`**. Default ARM GCC contraction changed14 oval payload bytes at coefficient-rounding boundaries; Fuji remained identical. Disabling contraction restores both exact historical hashes. This is a host generator portability finding, not a change to runtime arithmetic or existing assets.

Sources: [preserved lookup](../../../../rally-production/include/lookup_road.hpp), [live sections](../../../../rally-production/include/section_road.hpp), [format](../../../../rally-production/include/lookup_format.hpp), [offline generator](../../RALLY-18/generate_road.cpp), [saved data identities](../../RALLY-18/data/manifest.json). The earlier [version catalogue](../../../research/rally-versions/README.md) describes the state before R27; its “current” entries are historical.

## What the lookup actually computes

For each64-world-unit camera interval, the file stores19 possible ahead-interval records. A12-byte record contains five projected screen-line coefficients; four are signed16 and one is signed32. Runtime derives a Q12 progress fraction and its square once/frame, selects curve/stripe endpoints from tables, then evaluates only requested centres.

The first query to an ahead interval fills its cached intercept/slope using three wide multiplies. Every centre query needs one additional slope-times-row multiply. Thus centre evaluation uses **`3*K + N`** wide multiplies for `N` requested centres touching `K` distinct ahead intervals, plus frame setup. It does not call `trackSample`, calculate camera directions, cross map coordinates with tangents or run greedy band searches. Physics, scenery and vehicle yaw remain separate track-sampling consumers.

Actual AgonDev `-Oz` inspection confirms four `__lmulu` sites in `centerQ8At`: three conditional cache-fill sites and one per query. Four signed-wide divide sites remain, despite power-of-two divisors. Dividing by4096 or16 is not automatically free with this compiler. Index/pointer work uses native24-bit operations. No floating-point arithmetic appears in the inspected eZ80 probe.

The intermediate `SectionRoad` alternative performs the current live centre formula only for requested rows. Emitted code retains three direct wide multiplies plus four in the out-of-line sampler per centre, with a camera sample once/frame. It also avoids dense projection and greedy scans, without allocating the116,736-byte Fuji coefficient payload. It is a useful control for separating savings from endpoint selection versus coefficient lookup.

## Bounded feasibility evidence

[study_lookup.py](study_lookup.py) regenerates private table copies, compiles/runs the host study in ordinary and ASan/UBSan modes, and compiles the eZ80 probe to assembly/IR/object only. [LOOKUP-STUDY.json](LOOKUP-STUDY.json) preserves commands, source/artifact hashes, table comparisons, function/helper inventories, target sizes, host results and627 unchanged protected inputs/artifacts. Host elapsed durations are reproduction information, not eZ80 performance.

```bash
.venv/bin/python docs/tasks/RALLY-28/research/study_lookup.py
```

The isolated [direct emitter](../standard-vdp/lookup_direct.hpp) is shared by both preserved projection implementations. It converts each band endpoint once, reuses the preceding endpoint and emits four/five integer quads. It preserves bounded4KiB chunks between bands. It is not integrated into the full game and is not a deployable fixture.

| Host cases | Poses | Maximum lookup Q8 centre deviation | Maximum integer `centerAt` deviation | Largest direct road stream |
| --- | ---: | ---: | ---: | ---: |
| Fuji, before/on/after every track seam, five stripe phases |7,680|35/256px|1px|3,756B |
| Oval, same seam/phase coverage |1,350|31/256px|1px|3,405B |
| Fuji,900frames × four pace ticks using current scene/sign preparation |900|25/256px|1px|3,189B |

All9,930 poses pass in both host modes. Live sections reproduce the current dense renderer's Q8 centres exactly at their requested endpoints. Lookup/live-section band rows and material assignments match, cover rows104–223 without gaps, terminate at224 and match stripe material for every covered row. Both direct emitters match an independent command serializer. Road streams contain only colour/PLOT; synthetic maximal fragmentation passes multi-chunk output, including negative endpoints. Row103 queries, player contact row214, signs, real current scene preparation and both tracks are covered. The900-frame player ends at station1,202,800/phase1,600, matching the established pace workload.

This is numerical/command feasibility, not a new visual acceptance or an exhaustive pixel comparison. The sampled maximum lookup error matches the prior selected-table error range. Existing [R18 exhaustive results](../../RALLY-18/road-results/README.md) and their raw logs remain preserved; they were not rerun. Their final matrix/raster edge bound does not automatically qualify a new direct emitter.

## CPU work versus wire traffic

In the900-frame Fuji census, road endpoints plus actual scene/sign requests average23.99 centre queries touching11.27 cached lines. Lookup centre evaluation therefore averages **57.79 wide multiplies/frame**, excluding setup and other scene/physics work. Current dense road rows alone execute847. These are source/code-generation operation counts, not measured CPU milliseconds or a14.7× game speedup.

| Same sampled state workload | Table-selected direct road bytes/frame | Current greedy direct road bytes/frame | Difference |
| --- | ---: | ---: | ---: |
| Fuji900-frame pace |1,820.91|1,370.37|+32.88% |
| Fuji seam cases |1,839.98|1,388.79|+32.49% |
| Oval seam cases |2,338.96|1,501.62|+55.76% |

The conservative precomputed bands were selected under the R18 geometry budget. They create more quads here than the current runtime greedy fitter. This affects both reused projection variants. The old resident emitter needed25 bytes/band; direct final vertices need108/135. Therefore old lookup FPS cannot predict the direct-lookup candidate's end-to-end speed. CPU savings and extra submission/raster work must be measured together.

## Memory, rounding and integration requirements

| Item | Actual target layout/data |
| --- | ---: |
| Current `DirectRoad` object |2,191B |
| Preserved `SectionRoad` object |759B |
| Preserved `LookupRoad` object |938B, excluding loaded coefficients |
| Selected Fuji coefficient allocation |116,736B =114KiB |
| Selected oval coefficient allocation |20,520B |
| Curve offsets/ends |4,816 +16,803B; already referenced by the current road implementation |
| Stripe index/offsets/rows and depth constants |4,000 +202 +1,060 +516B |

Only one track's coefficients are loaded. Existing loader identity/checksum/exact-length checks can be reused. Full candidate code/image/stack cost still needs a real link map; these are measured type/table sizes, not a complete replacement memory budget. No extra VDP lookup allocation is needed for the direct road emitter.

The proof uses R18's nearest-pixel band-centre rounding, with ties away from zero. Traffic/player `centerAt` retains truncation. Widths use the current direct renderer's signed integer division rule. Old buffered binary32 vertex expansion can round a corner differently from “rounded centre + truncated integer width”; existing matrix-output parity is not transferred. Compared with the R27 control, lookup error, endpoint rounding and changed bands can each affect pixels. These are disclosed rendering choices for the Author's visual gate, not changes to collision/physics space.

A full standard derivative must retain current Motion/rules/traffic/recovery/input/audio/presentation, change only its roadway backend, handle track-load errors and coefficient teardown, and package the matching `.road` assets. The historical no-destroy/global plus explicit destructor pattern is available for AgonDev's C++ lifetime limitations. It must keep the current centreline camera, row103/224 queries and player contact anchor. None of these full-game changes were made by this assessment.

## Historical timing and recommended next experiment

| Preserved measurement | What it actually supports |
| --- | --- |
| R16 section rendering, Fuji29.88FPS | Deterministic64-pose unpaced emulator rendering batch, normal CPU throttle, buffered final vertices; no ordinary physics/input |
| R18 Fuji lookup computation14.01ms versus live sections17.43ms | Matched historical instruction-cycle workload: about19.6% lower computation cost after endpoint tables already existed |
| R18 Fuji completed stock-VDP lookup28.55FPS versus live27.33FPS | Historical emulator scene workload with buffered matrix expansion, distinct from current full game/direct commands/hardware |
| R24 native44–47 nominalFPS | Native diagnostic fixtures, not this lookup/direct CPU path or a full game |

See [R16 records](../../RALLY-16/results/table.md), [R18 stage results](../../RALLY-18/results/README.md), [R24 limits](../../RALLY-24/flexe/RESULTS.md). R27's later diagnostic interpreter throughput is also a different runtime/workload. No historical ratio is promoted as a current hardware speedup.

**Recommendation:** use the recovered lookup mathematics as the primary standard candidate, with live endpoint-only sections as its matched control and the unchanged R27 game/fixture as rollback. The shared direct emitter keeps final road geometry on eZ80 and stock VDP compatibility. This avoids spending the next implementation tranche optimizing every-row live projection we can largely remove.

The smallest useful next STD tranche is a separately built full-scene derivative with those two selectable projection backends, preserved current game semantics and shared final-vertex emission. Include a declared cheaper/coarser candidate from the reference research alongside the preserved projection controls in the initial comparison; measure projection CPU, band/quad/byte counts and actual submission/completed-frame cost. Author's later steering explicitly allows changing conservative bands/precision even when the image exceeds historical error bounds. Reuse the established timers and saved outputs, keeping transport/VBlank waits separate from CPU work. Any cross-platform comparison uses byte-identical candidate inputs, and the Author launches visual/hardware review. No30FPS/120Hz headroom guarantee follows from this host assessment.

MATH-001-02 should now prioritize the recovered interpolation/cache/index arithmetic and integer edge construction, alongside actual player/scene work. Exact endpoint/edge reuse is already represented in the feasibility emitter. Binary16 and native-specific adoption remain later research; no library/compiler/runtime changes are needed to begin this standard candidate.
