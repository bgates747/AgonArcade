# Rally version and renderer catalogue — 2026-10-13

The fully eZ80-computed roadway survives in the historical `rally/` playable prototype. The complete RALLY-22 game is on main in `rally-game/`, but it retains RALLY-15 buffered VDP matrix expansion through RALLY-18's lookup renderer. Abandoning Golem did **not** remove this earlier buffered computation. No full-game/direct-eZ80 combination was found in the inspected sources. Previous descriptions of this full game as simply “eZ80-based” were incomplete and led to the wrong benchmark assumption.

The `AgonArcade-rally19` worktree contains ignored full-game binaries left over after branch cleanup; those binaries are not the Golem renderer merely because of the branch name. Extender's preserved test records also explicitly identify the later main full-game binary. Actual current hardware/SD contents were not interrogated in this read-only catalogue.

## 1. Terms that must remain distinct

1. **Direct eZ80 road geometry:** eZ80 calculates the final road/kerb/marking vertices and sends ordinary colour/PLOT commands. VDP still rasterizes them. This does not prohibit buffered bitmap storage, livery conversion, or affine scaling of cars.
2. **Resident-section renderer:** eZ80 supplies section centres and Y boundaries; buffered VDP matrix operations calculate the expanded road vertices. No Golem language is involved in this original RALLY-15 implementation.
3. **Golem renderer:** Golem-generated buffered command programs derive a larger scene from compact state. This is the abandoned RALLY-19 experiment.
4. **Native VDPlet:** executable Xtensa code performs computation on VDP. RALLY-24 A retains buffered endpoint arithmetic as a control; B replaces it with native calculation. These are currently rendering fixtures, not a playable full-game integration.

## 2. Version families

Paths below are relative to this repository unless a sibling checkout is named.

| Version / location | Completeness | Road computation and buffered API | Status / identity |
| --- | --- | --- | --- |
| Early `rally/` history: ff4ead4, e5aba12, 0e5986b | Flat-road prototype; subsequent car, controls, oval and six-car traffic | Direct eZ80 roadway; asset handling evolves separately | Historical steps, not full game |
| Scenery/handling/demo prototype: 791da51, f94ac57, a981184 | Playable driving and demo, Fuji/oval, traffic, scenery, surface handling; no qualifying/race flow | Direct eZ80 roadway | Pre-section lineage |
| Current preserved `rally/`, latest main.cpp change 4ca24dc | Driving prototype plus timing/debug switches and renderer experiments; no full-game menus/rules | `rally::Road`: projection, band selection and final vertices on eZ80; ordinary PLOT quads | The direct-road baseline sought; current local binary 129237 bytes, d08300dc… |
| RALLY-10 fixtures, `docs/tasks/RALLY-10/` | Controlled timing/geometry workloads | Full-road/band and pavement variants; inspect selected fixture, not task number alone | Benchmark evidence, not another full game |
| RALLY-13 tuning review | Handling/speed changes to review candidate | Not a new rendering architecture | Tuning carried into accepted R18 lineage |
| RALLY-15, `docs/tasks/RALLY-15/` | Task-local playable/diagnostic section candidate plus direct-reference probes | `SectionRoad`; live eZ80 centre projection, VDP buffered matrix expansion of widths/skew/vertices; 25 bytes/section | First clear buffered roadway computation boundary; checkpoint 4ca24dc preserves experiment |
| RALLY-16, `docs/tasks/RALLY-16/` | Unpaced deterministic scene batches, no interactive physics/input in measured loop | Three variants: direct full road, direct pavement-only, buffered sections | Same scene components; not full gameplay FPS |
| RALLY-17, `docs/tasks/RALLY-17/` | Compute/UART/cycle diagnostics, full/pavement/section variants | Same distinct renderer families; proxy/sink measurements are not displayed-frame measurements | Preserved experiments |
| RALLY-18, `docs/tasks/RALLY-18/` | Playable driving/demo with traffic, scenery, refined player placement; no full-game flow | `LookupRoad` interpolates projected centreline tables on eZ80, then calls buffered section renderer; live `SectionRoad` reference also remains | 182a1d0 input freeze, 4e951d1 review, d1a9e3f unfenced review, 949f618 tuning |
| RALLY-19 Golem, sibling `AgonArcade-rally19/docs/tasks/RALLY-19/` | Experimental full-scene driving renderer and production-shaped variants; not R22 qualifying/race game | `GolemRenderer`, Golem-generated buffered programs, compact scene state | Abandoned experiment closes at 5b6e3c3; later branch commits only shared guidance |
| RALLY-19 pre-Golem rollback, `rally-production/` | Accepted stripped demo/manual driving product, six cars, both tracks; no title selection/qualifier/race progression | R18 `LookupRoad` plus R15 buffered matrices, **not direct eZ80 final vertices** | 949f618 lineage + stripping script; standalone source preserved in 4b1579a |
| `rally-bench/` / BENCH-001 | Production derivative with telemetry, external driving and engine sound; no complete race game | Same lookup + buffered-section road | cc0610b; separate from full-game telemetry |
| RALLY-22 `rally-game/` | Full title/attract, track/mode selection, qualifying, grid/countdown, six oval/two Fuji race laps, time extensions, circuit/arcade traffic, scoring/saves, crash recovery, HUD/signs/audio | eZ80 rules/physics/traffic and lookup centreline; buffered matrices expand road; VDP affine car/sign drawing | Main implementation 91f8337, telemetry bd7b7e0, promotion 6cbb5a3, human default-start review ae32dab |
| RALLY-22 optional telemetry/capture/forced-flow builds | Same game with compile-time diagnostics or assisted test flows | Same road path | Not ordinary release behavior; flags/build manifest required |
| Current `rally-game/` default-grip revision | Same complete game, default grip 200% | Same buffered-section roadway; no Golem | 9e75196; local 171080-byte binary 4be88dd1… |
| RALLY-24 native A/B, `docs/tasks/RALLY-24/experiment/`, `flexe/` | Host/native scene generation and headless Flexe fixtures; **not playable game** | A native scene calculation + buffered endpoints; B native scene + endpoints; generated drawing lists still held/called in VDP buffers | 4f2bb15 local implementation; subsequent uncommitted diagnostic tranche |

RALLY-20 is a paused optimization **plan**, not an additional renderer implementation. RALLY-21 describes traffic planning/hooks; its gameplay work was incorporated in RALLY-22. RALLY-25/26 are future offload/effects plans, not available game versions.

## 3. Checkouts, branches, and misleading leftovers

1. `AgonArcade`: actual AgonArcade checkout, main at 4f2bb15. Maintained complete-game source is `rally-game/`. Existing R24 dirty work was preserved; this audit changed no game code.
2. `AgonArcade-rally19`: branch `rally19-golem`, HEAD cea0120. Last experiment commit 5b6e3c3, followed by documentation commits 47f7f91 and cea0120. Its tracked `rally/src/main.cpp` still instantiates ordinary `Road`; Golem candidates are task-local, not inferred from the root directory.
3. Its `rally-game/`, `rally-production/`, and `rally-bench/` directories now contain ignored build outputs, **no tracked sources on that branch**. They survived moving the post-Golem work to main.
4. `archive/rally-before-main-promotion` preserves the old full-game tip cc88f6a. Original commits a1d83e5/904edd7/c3f2478 correspond to standalone production/full-game/telemetry work subsequently cherry-picked as 4b1579a/91f8337/bd7b7e0.
5. Comparing archived full-game main.cpp with current main shows one change: `motion.grip=200`. Thus this is the same full-game implementation lineage, not a second renderer rewrite.
6. Sibling `rally-mac-build.*` directories are scratch copies, not independent release branches. The attached inventory distinguishes Road, PavementRoad, SectionRoad, LookupRoad, GolemRenderer, and direct-versus-buffered probes.

The old worktree binary hashes checked in this audit:

| Path under AgonArcade-rally19 | Bytes | SHA256 |
| --- | ---: | --- |
| rally-game/bin/rally.bin | 171072 | 3ac79285f327bbb0bfe6a56cae7b839f124486a0fbd253647278b8bfa5a40434 |
| rally-production/bin/rally.bin | 131731 | e14e5c0f155a4f035e925b1da5971e8f7202fe47c7147e24a5726ef937d4fe5f |
| rally-bench/bin/rally.bin | 135899 | 20fde9ace4aa56298c5648985a6f3fa0eccdd6c50d527c62045c393c421e37c1 |

The first matches the archived R22 build.json, source main.cpp hash 0dbb3593…, and the promotion record's hardware-tested release. It is **not** a Golem executable. Current main's full-game binary is SHA256 `4be88dd1c8efbb6f7cddbdce1b98ee8805572f47550cda5d8c0ef3207189395b`.

## 4. Source evidence for the architectural distinction

1. `rally/src/main.cpp` instantiates `rally::Road`. `rally/include/road.hpp::strip` calculates both sides of each section and calls `Stream::quad`; quad emits colour and PLOT commands directly. The complete road geometry is prepared on eZ80.
2. `rally-production/src/main.cpp`, `rally-bench/src/main.cpp`, and `rally-game/src/main.cpp` instantiate `rally::LookupRoad`. `lookup_road.hpp::emit` calls `section::draw`.
3. `rally-production/include/section_protocol.hpp::draw` updates buffer30000 with four coordinates and calls buffer30008/30009. Its generated startup contains matrix construction/multiplication/transform operations. The generator and explanation in `docs/tasks/RALLY-15/protocol.py` and README establish what the opaque byte array does.
4. `docs/tasks/RALLY-18/IMPLEMENTATION.md` explicitly says live and lookup references share VDP resident programs. Lookup optimization did not revert the section arithmetic to eZ80.
5. `docs/tasks/RALLY-19/build_pre_golem_production.py` copies the R18 oracle headers and instantiates LookupRoad. The Golem branch's separate `build_production.py` instead includes `golem_renderer.hpp` and instantiates GolemRenderer. These similarly named builders create different products.
6. `docs/2026-09-14-rally-main-promotion.md` states that full-game, production and bench source matched the old tip when promoted. Removing Golem experiment files was not a roadway rewrite.

## 5. What Extender has actually tested

Preserved Extender documents provide more precise evidence than checkout names:

1. `agon-extender/docs/tasks/QUAL-003/rally-excom/PLAN.md` pins main commit9e75196 and full-game SHA2564be88dd1… .
2. `QUAL-003/rally-excom/fixture-r03/provenance.json` identifies the resident `rally-production/include/section_protocol.hpp` protocol directly.
3. `PORT-004/audio-framing/results/rally-observation.json`, `BENCH-002/DEPLOYMENT.json`, and `SCAN-001/S01-BASELINE.md` also identify 4be88dd1… . The last explicitly names `rally-game/` as its source.

These establish use of the main full game in those tests. They do not establish what a newer agent currently launches, or what is installed on the physical SD card today. No bench/network session, rebuild, launch, branch update, or deployment was performed for this catalogue.

## 6. Completeness and next benchmark decision

The requested pure-eZ80 baseline exists, but its playable incarnation lacks the full game's later features. A fair renderer comparison can reuse identical deterministic states/artwork while measuring its actual eZ80 geometry and UART work against VDPlets. A fair **full-game** comparison would require an explicitly implemented direct-road backend in the current game; none was found ready-made.

The latest R24 replay numbers are not that comparison: replay excludes live eZ80 calculations and retains the buffered endpoint path. Keep those measurements labelled accordingly. Do not present the preserved prototype as the modern full game, or the R18 rollback as entirely eZ80 geometry.

## 7. Audit coverage and supporting inventory

[LOCAL-COPIES.md](LOCAL-COPIES.md) and [local-inventory.json](local-inventory.json) enumerate 218 local source copies and available binary identities across both checkouts and sibling rally-* scratch directories, including ignored task/build caches. All full-game source copies identified by rules.hpp/GameState use LookupRoad. The two small initially unclassified programs were manually identified as section comparison probes.

This is a family catalogue plus a per-copy filesystem inventory, not fresh validation of every historic binary. Git history and the archive tag were inspected for lineage. Remote-only branches, other machines, mounted physical SD contents, and copies outside the stated scan roots were not exhaustively searched. No claim is made that an undiscovered private copy cannot exist. No fresh builds or timing tests were run. Existing R24 changes remain uncommitted; this catalogue is also uncommitted for review.

Paths within this checkout are relative to the repository root. Renaming the
checkout does not change the historical inventory hashes or revision identities.
