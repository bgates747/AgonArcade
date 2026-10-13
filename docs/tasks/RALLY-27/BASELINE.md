# RALLY-27 baseline and integration decisions

The preserved direct `Road` geometry is identical in the historical and production headers; production's changes are in Motion/tuning. Reusing that Road through a game-owned adapter preserves current physics while restoring the original live projection, greedy bands and direct final-vertex arithmetic. Inputs were frozen at19d54c9 after three scoped commits were pushed; the tracked tree was clean. Exact hashes are in inputs.json; baseline binary/map/manifest are preserved in ignored .work/baseline.

| Interface | Decision |
| --- | --- |
| project | Delegate to preserved Road; live track sampling on eZ80; keep original truncation |
| centre queries | Existing rendered rows use projected centres; traffic row103 computes the same formula separately; rows at/before horizon return160 |
| bands | Original default greedy one-pixel-fit bands; no new tuning or precomputed centreline lookup |
| emit | Same colour/quad order and coordinates; bounded4KiB chunks between bands instead of risking full-frame overflow |
| track load | Select embedded track and initialize depth tables; no external projection coefficient files |
| physics/gameplay | Existing Motion, rules, player anchors, signs and traffic remain |
| startup | Remove only road section program upload; retain car/sign bitmap transforms |
| lifecycle | No lookup allocation/destructor; empty CRT initializer/finalizer tables still required |

Host command oracle uses the preserved Road projection/strip implementation, independent of DirectRoad's new emission loop. Chunk concatenation must equal the donor command stream exactly, including a synthetic maximal-fragmentation scene requiring multiple chunks. Geometry source was not changed. No visual parity with the old buffered matrix rounding is presumed.

The local compiler is agondev's eZ80 Clang via its release/bin directory on PATH. Use repository .venv/bin/python. The new separately maintained flexe-agon-emulator runtime on the review host is selected, not the former GOLEM-021 executable.
