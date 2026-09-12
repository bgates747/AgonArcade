# RALLY-13 tuning checkpoint

The user reviewed the manual-cornering build, requested a 300 speed cap and
2x world-distance scaling, then authorized freezing it as a satisfactory tuning
checkpoint. Their observation was that it now feels like a racing game and no
longer produces the earlier reverse-motion strobing sensation. These are human
play observations, not a new frame-time measurement.

Accepted configuration:

1. Manual cornering by default; autosteer remains an optional launch setting.
2. Demo keeps its existing assistance and conservative speed policy.
3. Perspective vehicle-angle correction remains optional, disabled by default.
4. Player speed cap 300; world-distance multiplier 2 for player and opponents.
5. Centreline curvature applies across the road width, without lane-radius math.
6. Existing 30 Hz pacing; no general-poll waits or per-frame profiling.

The final reviewed binary and isolated profile are identified in review.json.
Focused handling/movement tests and the Linux build's existing sanitizer suite
passed. Historical distance fixtures explicitly use 1x; focused tests verify
production 2x advancement. Mainline and upstream runtime remain unchanged.

RALLY-13's requested handling/options experiment is accepted at this checkpoint.
Integration into the main game, removal of remaining startup/exit diagnostic
artifacts, hardware qualification and comparisons against original-game videos
are separate future work. No further speed increase is made now.
