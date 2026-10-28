# Author-selected big-room rotations

Measure one complete 360° clockwise turn at E1L1 cell (34,33), then at (34,36). Both are unobstructed floor in the same large room. Preserve the deployed playable application, firmware, assets, 30 Hz policy and actual AI/combat. These cells are measured at their centers, (34.5,33.5) and (34.5,36.5).

The Author's explicit full-turn request supersedes the proposed two30-second windows here. One complete turn also avoids allowing the room's live guard to turn a long stationary benchmark into death/fizzle testing. If a death interrupts the turn, retain the failure and report it rather than silently disabling game behavior.

1. Copy the previous pinned stopped profile into two fresh profiles. Change only the isolated medium-state player coordinates and the host input/trace shim. Never modify Wolf source, original assets, firmware or previous evidence.
2. Add CLOCK_MONOTONIC timestamps to existing UART trace writes via the SDL input preload library. Observe player-pose commands, render requests, completed W3DR packets and C3 presentation commands without altering those bytes. This removes the previous250ms trace-file flush uncertainty for a four-second turn. The extra tracing cost belongs to the measurement.
3. Navigate the unchanged menus, hold Right, and measure from the first completed moving heading until that heading returns after exactly360°. Pair every completion with its requested pose, verify all120headings and no translation, and report frame intervals/time. Retain normal combat and disclose any changes during the turn.
4. Force both SDLdummy drivers. Temporarily disable boost using the established approved procedure, restore its original value after owned processes stop, preserve complete raw/timed captures, verify matching event counts and final scenes, then report. The existing30Hz cap means these are capped gameplay results, not maximum renderer capacity or hardware timing.
