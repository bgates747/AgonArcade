# Declared differences from failed cached1

The old fixture/profile, all generation74 captures and the two ABBA successors
remain untouched. `PROFILE.json` and the original `full-comparison/PROFILES.json`
identify both cohorts with full hashes.

| Item | Failed cached1 | Prepared candidate |
| --- | --- | --- |
|Backend|`200f28cbe399b1fdc60cba1e5fed4c2bb86042b5e92f6e422539a5388c079a30`|`0866265bd6f3d73ad572f31dc1bb954f308ed9a5d857efa9414d37e1ade13374`|
|Profile suffix|`hud900abba01-cached1`|`maint08601-cached`|
|Evidence/campaign|Partial four-case ABBA|New single `maint08601/cached` qualification|
|`.runtime.sha256`|Original22 pins|Same22 names; only backend digest changes|
|Admission metadata|ABBA cached arm|Explicit maintained086 single-case admission|

No other pinned profile file changes: wrapper, frontend7e7d, firmware8da2,
firmware ELFb41e, MOSd564/mapd69e and tags, isolated SD boot commands, original
cached guestc6d75022, config900, expected metadata, motion, module/assets/
artwork/presentation/common/native streams and run text all retain their hashes.
The observer file is the same relative `last-run/sender-progress.jsonl` under
the new profile; the wrapper itself is byte-identical41fab20a. The source reader
remains12817411. No game/native/firmware rebuild or Pi emulator substitution.

The new orchestrator is a single-case adapter, not an edit of existing frozen
guards: it invokes original `control.py:run_one(timeout=287)`, the qualified
original stop function, original supervisor and original full verifier/auditor.
Its only added gate checks the complete new-runtime identity before calling the
unchanged functional/raw gate. A separate `qualification.json` explicitly
excludes calibrated timing, comparison, repair and visual/hardware claims.
The original nominal MOS/PRT data are retained, without a ratio correction.
`DEVICE-FREE-CHECK.json` pins these actual reused sources. There is no proposed
change to an existing guard or application/transmitted command.

The original complete-wire audit remains strict: prefix426498/timed291568/
suffix4135 bytes, with exact expected content. Preliminary boot/sysvar polling
can vary (the old failure differed by4 bytes); this preparation does not relax
or normalize that gate. Any later mismatch, even if plausibly polling-related,
is preserved as a failed qualification for separate disposition, not silently
accepted or retried. SD-file byte identity predicts unchanged application
commands; it is not an observation of a future actual stream or its consumption.

New staging/source/manifest/output paths are explicitly separate. `stage.py`
requires later FIFO custody, validates every archive member before creating a
new profile, and refuses an existing or partially staged destination. It does
not run an emulator. `runner.py` permits one fresh process only; existing
campaign/evidence/output prevents reuse. Neither command is selected now.
