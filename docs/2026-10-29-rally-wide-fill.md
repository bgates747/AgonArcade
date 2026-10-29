# 2026-10-29 — Wider native road fills

The Author authorizes committing/pushing all current work, then testing aligned
32-bit road-span stores against the accepted additive sampler control. Scope is
[INC-001-03](tasks/RALLY-28/custom-vdp/incremental/wide-fill/README.md); no projected
speedup is treated as measured. New implementation begins after the checkpoint.

Accepted INC-001-02, RV01/RV02 and CMP01–03 are removed from unfinished TODO:
the sampler and clean MOS return passed Author visual review; matched moving
traffic gives28.46→35.35nominal MOS FPS (+24.22%), PRT+24.26%,6.85nominal ms/frame
saved. All four actual timed UART streams and complete final worlds match.
[Evidence](tasks/RALLY-28/custom-vdp/incremental/sprites/motion-comparison/RESULTS.md).
Earlier constant-gap42.4%gain and actor-counter studies remain separate. Their
publication is expressly authorized now; no hardware acceptance is inferred.
AFF01 remains pending research and no scaled pixels are uploaded in the hot loop.
