# 2026-10-29 — Static drawing on both pages

The Author agrees to retain the accepted byte-fill/additive sampler and releases
the next bounded experiment after committing/pushing all current dirt. Retain
invariant text and the lower strip on both display pages; preserve moving content
and compare against the same deterministic moving control. Bitmap caching is
not part of this first tranche.

The [contract](tasks/RALLY-28/custom-vdp/incremental/static-drawing/README.md)
defines INC-001-04-01–05, owned by root TODO. Full-frame timing includes saved
UART traffic and dispatch. Initialization and page/swap phase must be qualified;
sky clearing is retained wherever old actors/signs need erasure. New work stays
uncommitted for Author motion review; physical testing and later work remain open.

All prior work and this scope were committed/pushed as `aab566d`; the tree was
clean before implementation. INC-001-04-01–04 are complete and removed from
unfinished TODO: accepted module/bytefill/physics/driver/artwork remain exact;
one184B setup SEND initializes both pages before the unchanged checkedINFO17
and initial timer mark. Title, sky24–99 and lower224–239 are retained;100–103
is restored to erase oldtraffic. FrameUART347→274B; no newnativecompile.

Fresh900frame/3600tick pairs give35.9521→42.7723nominal MOS FPS(+18.9703%),
PRT+18.9701%,4.4352nominalms/frame saved. Both pair directions improve~19%.
All22452native replies/fullfinalworld/timer/StopRace/UNLOAD/MOSexit pass.
Three-history900frame page proof passes and actual30/31heldscene pairs are
pixel-identical. Captures deliberately interrupt a long hold, excluded from
timing/cleanup. No emulator attempt failed; two host-proof tooling attempts
are retained and disclosed. Both sessionsmax56°C, original95guard/bothSDLdummy,
boostrestored1/ownedemulatorsstopped.

INC-001-04-05 is ready for the Author's moving visual gate. Fresh stopped
Oryxprofile `.emulator/rally28-hz60-staticreview01-static` has exact tested bytes,
soundforceddummy, normal MOSreturn. [Review](tasks/RALLY-28/custom-vdp/incremental/static-drawing/HUMAN-REVIEW.md),
[results](tasks/RALLY-28/custom-vdp/incremental/static-drawing/RESULTS.md).
New implementation/evidence remains uncommitted; no hardware, caching, affine
investigation, scheduler or next optimization release is inferred.

The Author subsequently reports “looks good.” INC-001-04-05 moving visual review
is accepted and removed from unfinished TODO. The separate acceptance receipt
records the reviewed script/module/archive identities without rewriting the
frozen benchmark archive. New work remains uncommitted pending explicit
publication approval; no subsequent implementation is released by this feedback.
