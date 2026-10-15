# Full-scene native Fuji fixture

The VDPlet fixture now exercises the R27-05 attract workload: scrolling panorama, native road/cars/signs/finish, retained title/HUD, centerline player at traffic pace and engine sound. eZ80 owns the player/controller/rules and scenery/HUD/audio command production; VDP owns opponents, contact checks and native visual projection. Old R27-05 and flat-background native fixtures remain unchanged. Headless qualification passes900frames/3600physics ticks; the Author visual launch failed with a black screen/startup stall; FS-001-07 is investigating it. The failed run is preserved; do not rerun this profile until a correction is staged.

On Oryx:

```bash
cd ~/Agon/mystuff/AgonArcade/.emulator/rally25-full-scene-review
./flexe-agon-emulator
```

Expect original title/HUD, Fuji scenery scrolling through curves, six route-driven opponents, road signs and engine sound. Player stays centered; contact checks run without crash damage. Two warm pages precede900unpaced measured frames. Allow about45seconds including startup, then `RALLY-25 FULL SCENE DONE: logs saved.` and a return to MOS. Report appearance, motion, sound and any corruption; the Author's visual confirmation is the gate. Normal game menus/driving/recovery are outside this attract fixture. No graphical instance was launched by the agent.

The guest creates `result.json`, `state.bin`, `player.csv`, `ticks.bin`, `prt.bin`, `replies.bin` and `stages.csv` itself after the measured loop. It clears old outputs on startup; preserve a completed run before relaunching. `failure.txt` records guest failure, with host diagnostics retained. Human-review output lives under this profile's `sdcard/test/arcade/rally`.

## Workload and ownership mapping

| R27-05 work | Full-scene native fixture |
| --- | --- |
| Deterministic Fuji centerline/traffic-pace player | eZ80 `player.hpp`;3600-step independent host check against existing pace implementation |
| Poll keyboard map; tick attract rules | eZ80; unchanged no-input/no-race attract fixture policy |
| Six opponents/shared route/contact predicates | Finite Golem `Tick120` on VDP; eZ80 supplies complete player snapshot before each tick |
| Road/car/sign/finish projection and command generation | Accepted native helper behind Golem `Render30` on VDP |
| Panorama upload, track-tangent heading and two-page scroll/edge repair | Maintained R27 functions on eZ80, ordinary VDP drawing/scroll commands |
| Fonts/title/HUD/bottom text and engine pitch | Maintained R27 functions on eZ80; VDP performs graphics/audio |
| Collision response | Checks retained on VDP, no crash damage/effects/recovery |
| Pacing/duration | Both processors unpaced; fixed900frames/3600simulated ticks here versus old R2730-second wall window |

`build.py` extracts maintained presentation functions into a separate ignored build directory, removes eZ80 road/traffic state and uses the existing AgonDev toolchain. Protected sources are read-only. The generated310-byte source root and stable entries/resources come from the actual delivered package, not invented offsets. No old renderer executes in the timed driver. This uses the simplified R27 centerline player driver; it does not establish normal interactive `Motion.tick` headroom.

## Results and identities

[Final-candidate results](HEADLESS02-RESULTS.json):900frames/3600ticks, **28.51FPS** over31.5667nominal MOS seconds,397background scrolls/399repaints/24engine pitch changes. All final world/array/player state matches the independent model. Previous900-frame run measured29.09FPS before adding startup output clearing; final world/reply bytes are identical. The numerical range is not a hardware prediction.

[Delivery receipt](DELIVERY-RECEIPT.json) verifies33Golem export files and their committed Git content at4beafb0. The peer module5a3ef7... is identical to Rally's client build through the existing delivery tool:30240code/980private data/32776image bytes,43relative relocations; no shared compiler/SDK/helper/firmware source changes. Existing firmware8da2ebf... is reused. [Candidate hashes](CANDIDATE.json) and [profile receipt](PROFILE-RECEIPT.json) verify all ten input files and runtime identities after headless execution and in the stopped review profile.

[Run receipt](HEADLESS02-RUN.json) retains exact frontend/adapter/MOS/firmware identities and backend counters. INFO17 minimum free2260before/after; PRT vector restoration verified, native stop/unload succeed, backend failure/unhandled/unregistered/unmapped are clear and process exits cleanly. Compact raw evidence for smoke/two full runs is under `evidence/`; larger traces and failed preparation attempts remain in ignored workspace/profile history. [Captured full scene](review-screen.png).

## Timing limits and remaining measurements

MOS elapsed uses nominal120units/s. The timing window starts after assets/init/two warm pages and ends after900draw/swap submissions; final state retrieval and SD writes are outside it. Native preparation readiness and fresh generation are checked every frame; there is no separate displayed-swap completion timestamp. This is aggregate fixture throughput.

PRT stages distinguish simplified player/rules CPU, scenery heading math, estimated HUD CPU excluding measured send calls, MOS submission elapsed and reply waiting. Submission includes CPU/backpressure and graphics/audio command traffic; readback waiting includes VDP work/transport. PRT is a quantized nominal1ms IRQ clock; emulator instruction-clock behavior and interrupt overhead prevent treating it as calibrated physical headroom. Stage sums are not an exhaustive mutually exclusive accounting of every instruction. Native physics versus geometry versus drawing/swap costs remain unisolated (TRF-001-56); actual interactive player-physics cost remains TRF-001-55. Four ticks per frame do not establish autonomous120Hz physics/30Hz rendering.

The candidate is prepared on Pi/Oryx in `full-scene/.work/fixture-900`, including `vdp_rally.bin` and CRLF readme. It has not replaced the Console8 card fixture. Future physical comparison must use these exact same input bytes/firmware as Flexe. Author explicitly authorized checkpoint commit/push of all current dirt on2026-10-14. This preserves the unfinished fixture; visual validation still fails/is pending under FS-001-07. The pre-implementation contract/evidence checkpoint is pushed `c96a55d`.

## Author review defect and headless authorization

The initial Author graphical run stopped transmitting at121112bytes inside a2048-byte sign-art upload before native installation/first draw. The stream exactly matches the passing headless prefix; backend scans continued without reported faults. FS-001-07 and Golem mail fifty-two track diagnosis. A subsequent video-dummy/real-audio diagnostic completed, but audible output without a window was NOT authorized and must never be repeated. That test has ended. All automated runs must force both video and audio dummy drivers; visible/audible diagnosis belongs to the Author. The runner again enforces silent dummy audio regardless of environment.
