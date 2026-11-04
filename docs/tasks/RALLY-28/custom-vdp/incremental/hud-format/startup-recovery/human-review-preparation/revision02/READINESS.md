# Corrected human custody and guide — revision02

Golem292 selects this wrapper/text correction and file-only staging of the NEW
Oryx profile. It selects no emulator, desktop probe, queue, checkout, human
prompt or publication. The PCM review remains under Golem custody. Original
19ba22ef preparation/local profile are preserved unchanged.

The qualified cached900 game, compact config, native module, runtime, firmware,
MOS, assets, engine and timing/physics/render policy remain exact. The combined
compact/HUD gate mapping and live desktop/manual-start limitation remain as
specified in ../READINESS.md. No new game frontend or900-frame repeat is needed
by these changes; no such process is selected. The startup text still makes
this a separate human profile, not a repeat of the strict benchmark wire audit.

## Correction and checks

The Author no longer supplies or exports a lease. The generated wrapper calls
its pinned profile-local review_custody.py before reaching the emulator. The
helper reads ignored .review-custody.json, validates owner=rally, exact resolved
profile and a32-hex UUID, then invokes canonical shared assert-owner on Pi.
It validates all three fields again in the returned LIVE checkout, rejecting
any mismatch or failed/stale ownership. There is no time-based ownership
assumption, fallback token, archived checkout or hardcoded live lease.
Missing/invalid custody and desktop failures explain themselves and direct
feedback to Golem. Audio stays dummy; no RALLY_ORYX_LEASE export is required.

The custodian, after a later real FIFO checkout when review is selected, feeds
the freshly returned full checkout JSON to review_custody.py save on Oryx. The
helper binds it to its own exact profile and writes atomically with0600 mode.
The whole .emulator tree is ignored. The actual custody file is absent now and
excluded from archive/hashes; it must never be copied from this preparation.
The custodian removes it after review release. Runtime output guards separately
prevent reusing the first completed or interrupted review history.

The guide now says to report successful completion and any stall back in
Golem. Ordinary eventual Author handout remains cd to the named profile and
./flexe-agon-emulator; no custody setup is delegated to the Author. There is
no handout/prompt issued by this preparation. MOS guide/manual LOAD/RUN and
finite clean-exit instructions otherwise retain the first preparation's scope.

Compared with19ba: only wrapper and review.txt change; review_custody.py is
added. There are24 pinned files plus derived runtime manifest. The new local
stopped profile is .emulator/rally28-hz60-rhp02-cached. Its planned NEW Oryx
profile remains /home/smith/Agon/mystuff/AgonArcade/.emulator/rally28-hz60-rhp01-cached;
that previously planned destination was never deployed by the first tranche.
All old profiles and shared runtime stay untouched.

Actual proportional checks run real custody save/check functions against
synthetic replies and temporary files: missing file; matching owner/profile/
UUID; invalid-save preservation; actual malformed/wrong-owner/wrong-profile
files; live owner/profile/UUID mismatches and stale-checkout failure. No SSH,
human launcher, emulator or desktop is invoked by tests.0600/ignore/no-custody-
in-archive, canonical executable preflight, shell syntax, guide dimensions,
24pins/25archive members and first preparation preservation also pass.

Later file-only staging must preserve modes and verify all24 final hashes,
manifest, executable preflight, absence of custody/history and no extra files.
It does not acquire or assert emulator custody and does not inspect/change the
PCM profile or shared runtime. The staged profile must remain unlaunchable
without a later fresh owner/profile/UUID match. Actual human appearance,
review-close/cleanup and consumer publication/default/hardware remain open.
