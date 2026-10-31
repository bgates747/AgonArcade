# Moving review of reduced serial waits

A fresh compact candidate profile is stopped on Oryx at
`/home/smith/Agon/mystuff/AgonArcade/.emulator/rally28-hz60-rlyrtreview01-compact`.
It uses the exact benchmark guest/module/config/artwork/runtime. Only the
human launcher differs: video uses the desktop, sound remains forced dummy.
It never launched during preparation; review timing is excluded from benchmarks.

1. Arrange an exclusive central Author Oryx slot with Golem before reviewing;
   the rollout register covers human sessions too. The launcher requires a live
   `author` lease in RALLY_ORYX_LEASE and rejects missing/wrong ownership with
   a clear message. Provide the exact launch command after that slot is granted.
   Do not reuse the released Rally qualification lease or another owner's slot.
2. Expected display: actual race panorama, approaching/receding traffic, signs,
   road, player, HUD/footer and clean return to MOS after900frames. Check for
   stale frames, trails, mismatched traffic/road placement or a stalled exit.
3. Close the emulator, verify no emulator/library process remains and release
   the Author slot through the central protocol. Preserve benchmark profiles
   and results. No hardware flashing is needed for this visual review.

No GUI or audible session was launched by Rally. Moving acceptance and explicit
commit/push remain pending; headless state/command parity alone does not close
those gates. PROFILES-rlyrtreview01.json records all review input identities.
