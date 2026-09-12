# RALLY-16

Run the rendering hot loop without application pacing, per-frame completion
waits or per-frame timing instrumentation. Keep Fab's default 18.432 MHz eZ80
throttle enabled: no `-u` or clock override. Authorized 2026-09-12 after
checkpoint commit `4ca24dc`.

Compare the full-road, pavement-only and RALLY-15 resident-section renderers
using the same 64 fixed poses, six traffic cars, player, scenery and HUD.
Keep all experiment code in [RALLY-16/](RALLY-16/). Build isolated source copies;
preserve the committed game and earlier evidence.

The measured loop contains no clock reads, deadline checks, sleeps, per-frame
poll barriers or elapsed-time physics. These are deterministic rendering
fixtures, not normal gameplay speed measurements. Retain ordinary buffer swaps
and unavoidable device/UART backpressure. Read the clock only around the whole
batch; drain queued work once afterward and include it in completed-batch FPS.
Separately report submission time and final drain, so queue accumulation cannot
masquerade as completed rendering. Startup/warm-up barriers occur outside the
measurement loop.

Build through the existing isolated Linux fallback and run applicable sanitizer
tests. Run repeated headless cases on both tracks with reversed renderer order,
checking binary/runtime identity, pose hashes, road bytes, car counts, completed
batch acknowledgement and normal CPU flags. Report ms/frame, FPS and the
16.67 ms budget, preserving limits of emulator VDP timing and coarse MOS ticks.
Root TODO.md remains the sole task checklist. No commit or push is included.
