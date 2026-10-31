# Corrected expected-error capacity harness

The new revision fixes the small probe's reply classification and passes local
branch checks. It is ready for another capacity-only small test, then the full
901-image collection if that succeeds. Both new Oryx profiles are stopped;
no emulator has run this revision and no capacity or FPS result is established.

Golem released this correction in
`2026-10-30_20-06-37_golem_golem057-rally-error-kind-correction-eleven`.
Root TODO.md owns AFF03-03. The parent experiment's original scope and first
failure remain in sibling `capacity/README.md` and `capacity/RESULTS.md`.

1. The only capacity-function change replaces the incorrect DONEkind3 with the
   frozen SDK's `VDPL_REPLY_ERROR`kind5 in `errorRead`. `protocol.hpp` copies
   exact existing SDK constants without importing ESP32-specific ABI structures
   into eZ80. No firmware/SDK/native module/timer/audio/scheduler change occurs.
   SOURCE-DIFF.patch and CORRECTION-SCOPE.json prove the narrow source change.
2. `local_branches.py` compiles the actual guest transaction/errorRead/length/
   cleanup function bodies with fake UART and buffer storage. All17cases pass
   ordinary and ASan/UBSan builds: positive read, deliberate bounds/missing,
   length mismatch, wrong kind/token/magic/version/status, timeout/pending and
   successful/failed/unexpected/pending cleanup. The first failed LeakSanitizer
   invocation is preserved; this executor uses ptrace, which LSan rejects.
   Address/UB sanitizers remain enabled with leak detection disabled. Resource
   ownership is asserted directly, not claimed from a leak-sanitizer result.
3. Frozen recipe/index/plan/generation are byte-identical to the accepted
   two-pixel901-image experiment. Host decoding still covers all6927keys.
   All76first-failure frozen files,97current-control inputs and seven protected
   archives/sources match. New small/full fixture inputs differ from their first
   versions only in `probe.bin` and the expected guest identity. There are no
   resized pixel uploads or narrower coverage. All original art loads once.
4. New guest SHA256 is
   `6d7231bd6a18691d4ad21082f89ef710d3fff89e8ccee373c7accb160d49a7b9`;
   BSS ends611136 below the preserved0xa0000bound. Checked native module remains
   `479fe1ac99bb2895af8a8b6cca49b90cb5c346a56a5f9e4020cab0b23c933918`.
   PROFILES-capacity02.json pins fresh canonical `capacity02-small` and `-full`
   profiles under `.emulator/rally28-hz60-` on Oryx. READINESS-FREEZE.json pins
   source/local proof/build/fixtures/profile metadata before the new request.
5. A NEW central grant is mandatory before each instantiation. Start small;
   only successful page/registration/state/cleanup proof permits full901.
   Existing95°Cguard/bothSDLdummy/actualboostrestoration remain. Preserve the
   first unexpected failure, stop remaining cases, inspect/release before
   analysis; no blind retry/domain shrink/ceiling changes. No prior token reuse.
6. This revision changes neither the missing current road/traffic/player/sky
   profile nor the preserved36.57nominal MOS FPS control. Actual collection
   capacity and a separately admitted prepared runtime must be returned before
   performance runs. Human approximate-appearance review/publication remain
   centrally deferred. No GUI, hardware, commit or push.
