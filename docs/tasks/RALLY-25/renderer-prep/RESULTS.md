# Rally renderer preparation results — 2026-10-13

The reviewed contract/reference state was committed and pushed as `d250f43` before this tranche. Renderer mapping and helper architecture are ready for concrete D2 binding negotiation; 9,120 host scenes match the preserved command oracle and retained-page checks pass. Golem's immutable D0 delivery is verified and its actual manifest mappings are consumed. The Author accepts the present roughly 99% scene agreement for continued development and explicitly retains **their own visual confirmation as the final gate**. Exact pixel parity is no longer a blocker or further research objective for this tranche. New preparation artifacts remain uncommitted for review; no game/firmware/deployment changes or emulator runs occurred.

## Delivered mapping and coordination

[Integration map](INTEGRATION-MAP.md) covers old R24 inputs/assets/outputs versus root-v1, missing full-scene responsibilities, page/HUD protection, drawing order and stop/reset. [Helper proposal](HELPER-PROPOSAL.md) is preserved as sent. Golem accepts its architecture, including native-only binding, explicit unsupported-buffered rejection, one dispatcher, distinct helper failure and no successful-generation publication on helper failure. Exact signatures/structure members/source spelling/error mapping remain D2 agreement items. Release the copied argument lease before helper entry to target three composed views; current D0 holds two base leases and does not already implement that change.

`d0_delivery.py` verifies the immutable bundle SHA256 `b7a6be65ce06789e837c986a1af4968aa83e0cc43a5e5a0a976338241be3b08f`, all 76 files, both package manifests, their artifacts, six source exports against committed GOLEM-032 and the SDK source/builder identities. All five local tool executable hashes match the supplied host/Xtensa toolchain receipt. Fourteen malformed manifests reject; both initial root headers match the existing adapter, and all 20 default/relocated native/buffered CALL exports match generated `calls.inc`. The handle patch location is generated at 24, not an assumed old offset 11. No absolute old build path is used to resolve an artifact. [D0 receipt](D0-RECEIPT.json) keeps peer target evidence distinct from these independent host checks.

Golem reports Author visual/keyboard acceptance and publication through `1a1f303`, with bundle identity unchanged; that is recorded as owner-reported human acceptance, not a new review performed by Rally. The initial scalar bundle contains no array/wide/renderer/scheduler implementation. The newly accepted D1a storage profile and language division-overflow mapping are summarized in the integration map; their actual compiler support remains separate Golem work.

## Host fixture coverage

| Track | Preserved poses | Added boundary/sign poses | Total | Observed output maxima: road / actors / player |
| --- | ---: | ---: | ---: | --- |
| Fuji | 4608 | 1780 | 6388 | 3762 / 350 / 141 bytes |
| Oval | 1232 | 1500 | 2732 | 3411 / 350 / 141 bytes |

All three command lists match the separately frozen R22/R24 oracle byte for byte for every pose. Added cases cover lap/6400-unit fractional boundaries, four material-phase edges, all eight visibility/panel/perspective flags, signed lateral extremes/zero neighbors, steering/views/mirroring, equal-depth opponent slots, exact visibility thresholds, sign approach/retirement and lap seams. The preserved deterministic set also includes historical effect-age cases as reference, without selecting new recovery behavior. Both tracks exercise zero through six visible cars, zero/one signs, and band counts 10–30 Fuji / 10–28 oval. The default approximately480-world-unit sign spacing and 64..500 visibility interval prevent two signs being simultaneously visible; capacity 2 is retained rather than fabricated as exercised coverage.

Twenty sequential alternating-page steps independently check the actual frozen HUD/sky history functions: initial draws on both pages, unchanged values emitting zero HUD bytes, value changes on each page, cyclic scroll wrap, large-turn repaint and explicit invalidation/reset. Emitted sky viewport clamps to HUD height 24. These are host command/cache observations, not VDP framebuffer, concurrent scheduler or physical display qualification.

ASan/UBSan checks cover the actual candidate capacity/rounding leaf and retained histories. The 9,120 scene comparisons use an ordinary host shared library with four-view enforcement, access checks and release accounting; peak3 is the old R24 helper's observation, not combined Golem proof. [Fixture receipt](FIXTURE-RECEIPT.json) records source/input hashes, counts and approximately 8–9 seconds total host setup/execution. Generated [scene cases](scene-cases.json) preserve input bytes/output hashes; the harness clears prior result files before rerunning. No completed-FPS or120/30-Hz target performance is inferred from host duration.

## Bounded parity diagnosis and Author disposition

Saved JIT/interpreter captures still agree within each renderer path; A remains exactly equal to replay for the two final poses. B changes 442 of 69120 scene pixels on Fuji (**99.3605% identical**) and 63 on oval (**99.9089% identical**), excluding the top 24 status rows exactly as the original comparison did. All differences are in road rows. Fuji bounds are x0..241/y120..195; oval x0..222/y121..187. These are two saved final scenes, not an exhaustive whole-game visual score. [Parity receipt](PARITY-RECEIPT.json) pins original capture/reply/trace/expected hashes against the preserved provenance.

The saved probe has 460 coordinates with 53 differences from B's separate-operation/signed-conversion reference: 44 negative conversions and 9 positive rounding changes. A host binary32 model with fused accumulation and the **observed** negative unsigned-conversion behavior reproduces all 460 saved words. The conversion model is not portable C++ semantics or a proven physical ESP32 guarantee. Minimal examples:

- Check 62, Fuji band 11, parameters `(155,155,130,136)`: separated accumulation gives 82.99999237060547 and truncates to 82; fused gives 83 and matches the saved word 83.
- Check 126, Fuji band 15, parameters `(157,158,163,196)`: both arithmetic models give-54; B emits -54, while the saved matrix path emits -1.

This explains the saved endpoint discrepancy classes, not every rasterized pixel. Three changed Fuji pixels on rows 120–121 lie outside the affected band ranges covered by the original probe; no complete software raster proof or physical conversion proof was performed. That limit remains recorded. On Author direction, further pixel research is stopped: retain the differences and proceed with integration preparation. **Only the Author's later visual confirmation closes the visual gate.** Neither a99% comparison nor this host model substitutes for that confirmation; no existing normal renderer or expected output was changed to mimic the quirks.

## Next review boundary

TRF-001-18–21 have delivered their mapping, proposal/architectural agreement, fixtures and bounded parity disposition. TRF-001-07/09's previously missing scalar/artifact/manifest delivery is now consumed. TRF-001-22 returns these results for review and stops. Next useful work requires the concrete D2 helper binding/marshaling/status agreement and, for real traffic simulation integration, Golem array/wide deliveries. Later telemetry timing, steering/grip, recovery, scheduling and firmware choices remain separately gated. No automatic full-module linking, emulator run, deployment or further commit/push is part of this closeout.
