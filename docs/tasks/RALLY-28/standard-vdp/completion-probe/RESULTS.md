# Stock completion probe results — 2026-10-14

**Both stock-firmware mechanisms work in the tested Flexe environment.** The keyboard probe obtains a callback by requesting virtual key zero after a drawing flush; the general-poll control obtains a token without a keyboard callback. Each final application completes 52 requests and creates its own result files. The foreground counter continues during heavier VDP drawing. Author launch is recorded below; broader input and physical Console8 confirmation remain open.

**Author launch, reported 2026-10-15:** Author ran the callback profile and accepts the mechanism as the basis for further planning; its picture was not informative. Returned records previously inspected show 52/52 completions, no failure, callback restored, empty before/after key maps and counter/elapsed both 578 nominal MOS units. Heavy completion turnaround averaged about 47 ms and exceeded the old 33.3 ms reference on 21/24 frames. This paced, one-outstanding-frame fixture is not a sustained VDP saturation test. Broader input and physical confirmation remain open; no game physics rate is qualified. New candidate pacing/transport requirements are in the [RALLY-28 policy](../../../RALLY-28.md#measured-pacing-asynchronous-rendering-and-wire-traffic--2026-10-15).

## Final qualified candidates

| Application | SHA-256 | Frames | Primary signal | Counter ticks while pending |
| --- | --- | ---: | --- | ---: |
| Callback, with ordinary input | `498f56de37b2d2002a406f46b262a9e4c17f501a4e833f30410d00810705dae7` | 52/52 | 48 zero-key callbacks; 4 F12 comparison callbacks | 120 |
| General-poll control | `053d70da6b53540e952f54a6bd16766f3322d6e495fe706510b5d5a9314d06ce` | 52/52 | 52 distinct primary tokens | 120 |

The stored completion tail is exactly seven bytes after the drawing-buffer call. The foreground sends **no additional VDU command until the primary completion arrives**. It then verifies the alternating final pixel and drains those verification commands with a separate token. Independent UART parsing confirms primary completion precedes readback and verification poll for every frame. This eliminates dependence on a later poll/readback as the cause of the callback.

## Checks and practical meaning

1. Both binaries build with AgonDev and empty CRT initialization/finalization tables. Exact tested binaries, source/build receipt, guest summary/CSV/done markers, runtime reports, UART bytes and captured final images are retained in [evidence/](evidence/).
2. All 52 final pixel readbacks match the alternating expected colours. Raw transmitted and delivered VDP protocol streams agree byte for byte. All captured key packets match the corresponding wire packets. No backend failure, unhandled operation, unregistered operation or unmapped access was reported; both frontends exit cleanly.
3. The callback input run includes eight SDL down/up events for Up, Left, A and F12, passed through Flexe's PS/2 model and actual firmware. All eight appear in the captured packets, alongside the expected 52 requested packets. Both before/after held-key maps are empty; neither request-free control receives a zero-key marker. This is bounded automated coverage, not exhaustive keyboard acceptance.
4. The final callback run counts 566 nominal MOS units over its measured window and exactly 566 foreground counter units; the poll run counts 564/564. Each advances 120 counter units while the primary completion is outstanding, all in the heavier draw cases. Source-backed elapsed-time accounting and foreground progress are demonstrated; the cheap counter does not measure actual game physics or establish a 120 Hz CPU budget. MOS units are nominally 120/s, updated two at a time per VBlank. Light completion intervals are below this clock's resolution; heavy intervals span 2–6 units. These are notification turnaround intervals, not isolated rasterizer timings.
5. The prior callback pointer is restored and only owned buffers are cleared. The callback does not modify any keyboard packet. The normal game, prior fixtures and their evidence remain unchanged.

## Exact environment

The firmware is the [official VDP 2.16.0 release binary](https://github.com/AgonPlatform/agon-vdp/releases/tag/v2.16.0), downloaded without rebuilding or modification: SHA-256 `b807beef35823b13a0a056f11b7464cd1b1c6356dce0e4098b78ebe059ded35f`. Official MOS 3.0.2 ROM/map identities are enforced by the generated launcher. The callback-slot read is specific to that published MOS map. No firmware, MOS, compiler or emulator source was changed.

Both final runs use copied Flexe frontend `7e78e991…`, adapter `200f28cb…`, JIT mode, and forced `SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy`. Inputs match their hashes before/after execution. Setup/boot/measurement/guest file saves/cleanup total approximately 11.18 seconds for the callback run and 10.98 seconds for the poll run; those host totals are separate from the guest measurement window. Full identities and hashes are in the evidence reports.

## Review and remaining decisions

Fresh profiles `.emulator/rally28-completion-review` and `.emulator/rally28-completion-poll-review` are prepared and **stopped** on Oryx. They contain the same final application bytes and stock firmware used above; no preload/input injection is enabled. [Launch and expected behavior](README.md#author-visualinput-review-on-oryx).

Virtual key zero avoids reserving a physical key in the tested normal PS/2 path. It has no sequence token, and console-mode serial input can also report key zero. Retain one outstanding request and define explicit input/marker ownership before any game integration. F12 is a comparison only: a real F12 event while it is the active marker is inherently ambiguous. General poll supplies a token but is polled through MOS `gp` and is documented as an internal synchronization command.

The probe uses single-buffer mode 8, drawing flush and no swap/VBlank wait. It demonstrates drawing completion notification, not presentation timing. Physical ordering, mode 136/double-buffer integration and the real game's independent 120/30 Hz scheduler are not qualified here. No card deployment, flash or physical execution occurred. New probe changes remain uncommitted for Author review; the pre-implementation all-dirt checkpoint was pushed as `aee0aad` and `01f6333`.

## Earlier diagnostic iterations

The first draft received 52 callbacks but could not create files because its create-new flags omitted `FA_WRITE`; it is not qualified evidence. A later draft included setup time in the counter total, corrected before final candidates. Earlier pixel/poll checks were inside the stored frame; final candidates move them after the primary signal to test the seven-byte mechanism alone. Those owned profiles remain stopped and preserved on Oryx. Final evidence above identifies exact final binaries and does not combine their timing with earlier drafts.
