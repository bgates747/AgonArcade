# Pavement, vehicles and background — headless results

Removing kerbs and road lines produces **14.01 FPS equivalent on the oval** and
**13.64 FPS equivalent on Fuji**, with all vehicles and background retained.

| Track | Full markings | No kerbs/road lines | No-markings frame time | 60 Hz budget used |
| --- | ---: | ---: | ---: | ---: |
| Tri-oval | 7.81 FPS | 14.01 FPS | 71.35 ms | 4.28× |
| Fuji | 8.74 FPS | 13.64 FPS | 73.31 ms | 4.40× |

The target budget is **16.67 ms/frame**. This candidate is still 54.69–56.64 ms
over that budget. These are equivalent rates from headless, fixed-pose batch
times, not measured physical-display FPS or ordinary gameplay rates. The
fixture includes six opponents, the player and scenery, but excludes elapsed-time
physics. Both variants use the precomputed band option and stock post-swap poll.

## Method and findings

1. Both binaries came from the same current 120-row source snapshot, compiled
   on Linux in separate scratch directories. Only the temporary renderer type
   and its test are injected into the candidate copy. Mainline source and its
   binary hashes were verified unchanged after builds and timing.
2. Each track uses full/pavement/pavement/full order, 64 fixed poses per run,
   plus two unmeasured warm-up frames. All 512 measured frames were acknowledged;
   no timeouts or omitted samples. Pose hashes match within each track, and
   road-byte totals repeat exactly within each track/variant.
3. The candidate removes four marking/kerb strips and material-driven band
   splits. It keeps the gray-pavement trapezoids. Road payload per 64 frames
   falls from 145,992 to 20,820 bytes on the oval, and 112,809 to 12,180 on Fuji.
   These byte counts exclude vehicles, scenery, HUD and control traffic.
4. Existing projection is retained, including its currently unused paint-flag
   calculations. The candidate's geometry stage still costs roughly 38–46 ms
   per frame. Its pavement band/emission stage is about 2–4 ms. This experiment
   does not implement bitmap road strips or resident VDP command sequences.
5. All timings used dummy SDL video/audio and the canonical software-renderer
   profile wrapper, without capture instrumentation or graphical review windows.
   One-minute host load ranged approximately 4.9–8.1; runtime identities and
   individual load samples are in the manifest. Timing resolution is two raw
   ticks, 16.67 ms, so individual stage samples are coarse; tables average them.
6. Both isolated builds pass existing Linux ASan/UBSan checks. The candidate
   also checks gray-only quad encoding, independence from material phase,
   geometric error and stream capacity across both tracks and band modes.
   The sampled pavement maximum is 651 bytes and 23 bands.

See the [stage table](table.md), [manifest](manifest.json), and adjacent original
CSVs for the measurements. Binary SHA-256:

1. Full: `d08300dc7c0b4ab9b55dbbafc7cf3ba02c1f6e9cb42b8b828385751e1e6aa920`
2. Pavement: `fb27f734e737b017578213451b19fb905d9649a6c6b1687eeede0dcb2aad4102`

Implementation, isolation rules and reproduction commands are in the
[experiment bucket](../README.md). Human review and hardware qualification
remain pending; these changes have not been promoted into mainline.

## Native captures

Separate headless runs show [oval demo](visuals/oval-frame-600.png),
[manual steering](visuals/oval-frame-720.png),
[Fuji demo](visuals/fuji-frame-600.png), and
[Escape to MOS](visuals/fuji-frame-900.png). Pavement, cars and background remain;
kerbs and road lines are absent. These captures are excluded from timing evidence.

Both runs saved all four expected frames. After the in-game return to MOS,
the harness's requested emulator quit ended with SIGABRT and the known mutex
message on the oval, and SIGSEGV without a diagnostic message on Fuji. Similar
native shutdown failures predate this experiment; their cause is not established
by these runs. This does not change the successful host checks or completed
timing reports, but is not a clean emulator-shutdown result.
