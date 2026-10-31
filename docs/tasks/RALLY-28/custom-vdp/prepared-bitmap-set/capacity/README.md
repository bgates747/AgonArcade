# Two-pixel prepared-image capacity experiment

This experiment checks whether the complete 901-image collection fits alongside
the real race resources. It generates images inside the existing VDP, proves
that they can be plotted, measures available memory and cleans up its resources.
There is no new game FPS result or acceptance of approximate appearance yet.
The preserved checked/compact full-race control remains 36.57 nominal MOS FPS.

Latest: the first leased small case failed in the new harness's expected-error
reply kind before any cached image generation. Full allocation did not start.
See RESULTS.md and FAILURE-AUDIT.json. The first witness is preserved, Oryx is
released, and a correction/retest requires central review and a new grant.
The preparation status below describes the inputs before that failed run.

Golem's delegated release is
`2026-10-30_19-44-52_golem_golem057-rally-capacity-experiment-eight`.
The Author's standing delegation authority is recorded in root AGENTS.md.
Root TODO.md remains the only actionable checklist (AFF03-03 through05).

1. The selected recipe is exactly the preparation's `two-pixel-stock-model`
   full-domain policy: 901 images, 2,211,975 pixel bytes and a 10,628-byte table.
   The accepted private interface SHA256 is
   `306f3486643e8508f8c50a041903e2440eb5c1e37c6af1ad8b1e6ee14a16fa53`.
   `RECIPE-FREEZE.json` pins the producer, recipe, table, registration-probe plan,
   exact generation stream, frozen stock source and original control before
   any capacity/runtime implementation. This selects a test candidate, not a
   production default or an error threshold accepted by the Author.
2. Original artwork loads once. Generation uses stock buffered command40,
   options3 with explicit width/height; the host sends transforms and metadata,
   never resized pixel data. Index51999, matrix51998, telemetry51997 and
   images52000..52900 are private and do not overlap current race resources.
3. Setup retains the unchanged checked native module, real mode136 race art,
   panorama/fonts/HUD/footer and two warm rendered pages. A one-image fixture
   first proves standard screen-pixel readback, contrasting backgrounds and
   double-buffer page behavior. Full-set allocation cannot precede that proof.
   Full setup probes one useful opaque pixel per image and extra points on
   representative large geometry families; there is no bulk image readback.
4. Existing INFO13..16 supplies free/largest internal memory; stock variables
   0210/0211 via buffered command48 supplies free PSRAM with high/low/high
   consistency. Largest PSRAM block is not exposed. Stage-boundary minima are
   observed setup peaks, not a guarantee about transient allocations inside
   command40. Buffer length and successful contrasting plots distinguish
   backing storage from Bitmap registration. Preserve before/after native state.
5. Partial allocation/registration failure ends normally and cleans owned
   resources; report the failed ID, actual memory and cleanup residual. No
   smaller domain, hidden fallback or firmware/SDK/allowance increase follows.
   Buffer counts and absence checks accompany heap measurements; map buckets
   may remain allocated after clearing entries, so heap residual alone does
   not establish leaked image ownership.
6. Preparation, builds and host checks stay local. A fresh central exclusive
   Oryx grant is mandatory for each launch; both SDL drivers are dummy, original
   95°C guard and actual initial boost restoration remain. The small case must
   pass before the full901-image fixture. No other project's files or processes
   are changed and no hardware/GUI/sound operation is released.
7. Only a measured full-set fit releases a separately named prepared runtime
   image under this same frozen interface. It must fit existing declared limits,
   prove scoped four-lease ownership, preserve full race/world/anchors/clipping/
   depth/error/publication/final-swap semantics and fail on missing keys. Timed
   generation/allocation/replacement/fallback counts must be zero. Return actual
   capacity and concrete runtime/host pins before requesting performance runs.
   Human moving review and publication remain centrally deferred; no commit/push.

The Author separately asked for road versus traffic/player versus scrolling
sky/repair timing. The current build lacks those isolated measurements. Older
quad-renderer CCOUNT shares and broad guest brackets are historical evidence;
this capacity experiment does not substitute for that missing profile.

Local preparation status: guest `f57b978d...` compiles with BSS ending611140,
below the preserved0xa0000 bound. HOST-CHECK.json decodes all901generation
recipes and6,927full-domain lookups, checking97preserved control inputs and
seven protected archives/sources. Dedicated `small` and `full` fixtures share
that guest and the unchanged native module. No target capacity is established.
Central request `56ff79c3e643` is queued; exact pins/profile paths are in
SLOT-REQUEST.md and its canonical mailbox receipt. No Oryx contact or emulator
launch has occurred. Grant, fresh canonical staging, small-case proof and full
capacity are still required in that order. Work remains uncommitted.
