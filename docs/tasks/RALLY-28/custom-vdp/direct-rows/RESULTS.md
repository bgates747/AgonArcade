# Direct-row road rendering — first comparison

The direct-row candidate improves matched full-race throughput by **7.92% on
the nominal PRT clock:36.28→39.16FPS**, pooled over two900-frame runs per arm.
The direction holds in both orders. This is a modest improvement; it does not
explain a cross-project2×bespoke-versus-VDPlet gap or establish physical speed.

| Run order | Bitmap PRT FPS | Direct-row PRT FPS | Gain |
| --- | ---: | ---: | ---: |
| Bitmap then rows |36.12|39.25|8.66%|
| Rows then bitmap |36.44|39.06|7.18%|
| Weighted pooled,1,800frames/arm |**36.28**|**39.16**|**7.92%**|

Mean nominal PRT frame time falls27.56→25.54ms, a2.02ms reduction. MOS reports
60.00FPS in three runs and60.07in one; those counters remain uncalibrated and
do not prove physical60FPS. Entire emulator process intervals, including
setup/teardown, are34.632–34.732s for bitmap and32.724–32.828s for rows; their
direction corroborates the gain, but they are not isolated race windows.
Hardware remains the deciding measurement. Do not extrapolate the old C8's
24.7FPS by this emulator factor or pool it into this matched comparison.

## What changed

The road now writes its final opaque RGB222spans directly into the hidden
SBGR2222drawing page through a finite BEGIN/ROW/END scope. It resolves each row
independently, uses the actual XOR2layout, preserves high sync bits and closes
before ordinary actor/Canvas work. The320×120intermediate road image is not
written or plotted. Its old38,400-byte allocation/registration remains in both
arms for this first matched allocation history; removing that unused resource
is separate from this timing comparison.

Geometry/edge stepping, traffic, additive actor sampler, player, scrolling and
repairing sky, HUD/footer/audio, four logical physics steps per render, UART
submission and final post-swap fence remain the same. Async UART and independent
physics/render scheduling are not implemented. The eZ80timed command stream is
identical in both arms:291,568bytes/900frames. Removing18internal VDU bytes per
road output does not reduce that application-to-VDP traffic.

Both new arms share VDPlet's existing a50row-enabled UART-repaired firmware,
7e7dfrontend/plain086backend, the same common guest and corrected PSRAM compiler
policy. New code initially exceeded the32KiBtext guard. Both packages were
narrowed to the race's actually used entries3/13/15/16, retaining exact case
bodies and rejecting unused stand-alone test entry IDs. Final bitmap/rows text
is24,876/25,080bytes, data1,004each. Neither compiler policy nor resource limits
were relaxed. The unmodified479/8da2native/firmware pair stays the historical
anchor, rather than being mislabeled the new bitmap control.

The common guest additionally receives/validates mode136/320×240before taking
the private callback and LOADing, then checks capability subset273. The new
startup INFO query shifts tokens by1. Independent audit checks that exact
change and every subsequent expected request/reply; no captured bytes are
discarded to make the old setup freeze fit. Ordinary UART fonts remain supported
by a50; this application does not require native font/profile6or resources7.

## Correctness and limits

1. Ordinary and ASan/UBSan actual-C checks each match902roadimages and
   **34,636,800pixels**, both page parities, sync/guard preservation, balanced
   row scopes, seven row failures and3,600independent world steps. Original
   state and actor commands match; direct rows leaves its scratch image untouched.
   The host row service is an explicit mock, not target display evidence.
2. Both60-frame smokes and all four900-frame runs pass native statuses,
   exact expected world/player state, all2025legacy native replies per full
   run, timed-wire equality, every completion/post-swap fence, Stop/UNLOAD,
   timer restoration, clean text exit/MOS prompt and zero backend faults.
   Both SDL drivers are dummy. This is not an Author moving visual acceptance.
3. Combined reply-wait buckets fall from14.72–14.99to11.93–12.06ms/frame.
   Presentation CPU estimates move upward despite identical guest code, so
   those bucket differences must not be treated as exclusive processor costs.
   They combine timer granularity/emulator scheduling, transport, native work,
   drawing and swap/presentation ordering. No isolated pure-raster claim.
4. Existing generic row source/mechanism qualification supports the service;
   this is Rally's finite consumer qualification. It does not independently
   identify every row pixel in a live screen capture, repair all old UART stalls,
   establish allocator safety or qualify another consumer/default image.

## Resource custody and evidence

Task/prior dirt checkpoint-pushed through0715d5f before implementation. Native
build/source checks and the common guest used shared Pi generations41/44;
children joined and leases released. Generation41's automatic next6502owner
was immediately steered. An aggregate freeze-writing path error was corrected
after Oryx reservation; actual source/profile pins existed before reservation
and no checkout/process preceded the corrected manifest. That chronology is
explicit in READINESS-FREEZE.json rather than restamped.

Oryx checkout267used the exact six-process first-failure cohort. All inputs
remain exact. Max observed temperature58°C, both SDLdummy, initial boost1
restored1. All176retrieved artifact hashes match. Fresh whole-host idle proof
and release occurred at07:11:22EST2026-11-04, before extended analysis;
next_request=null. No queue/emulator or physical operation remains owned.

[Report](REPORT.json), [retrieval hashes](RETRIEVAL-SHA256.json),
[source/host checks](HOST-ordinary.json), [sanitized checks](HOST-sanitized.json),
[session](SESSION-rows01.json), [release](ORYX-RELEASE01.json),
[shared-cost notes](SHARED-COST-NOTES.md).

## Next handoff

A complete paired [hardware kit](HARDWARE-KIT.zip) is prepared locally, including
the required new `vdp_rally.bin` and both900-frame fixture directories. It is
not deployed or flashed. Run both arms on C8and inspect the actual full scene
before deciding adoption or any subsequent async/scheduler experiment. The
Author's own visual confirmation remains the visual gate.
