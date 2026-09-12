# RALLY-13

Manual cornering experiment based on the frozen RALLY-18 lookup renderer.
Autosteer is retained as an option; it is disabled during manual play by default.
Demo driving keeps the previous assistance. The transition happens when a key
hands control to the player.

Previously the tyre-force request included the entire centreline cornering
requirement automatically. Manual mode omits that automatic contribution. The
existing steering demand and lateral damping must now supply it, within the
same grip limit. Neutral steering drifts outward in bends, and steering into
the bend can balance that drift. Inside and outside lanes use exactly the same
centreline curvature. This remains an arcade model with no independent yaw.

The player speed cap is restored to 300. Demo retains its conservative
224 target and bend braking.

Steering retains its existing incremental controls: releasing an arrow holds
the current setting; opposite steering unwinds it. The HUD shows the setting.

Build and launch from the repository root:

```
.venv/bin/python docs/tasks/RALLY-13/build_review.py --launch
```

Add `--autosteer` to restore assisted manual play, or `--track fuji` for Fuji.
The guest option is `autosteer`. Vehicle perspective remains off by default;
the RALLY-18 `perspective` guest option still exists. Review uses 30 Hz pacing,
no poll/profiling flags, and the stock canonical emulator and VDP.

Generated copies, binaries and profiles stay in this task bucket's ignored
`.work/` and `.emulator/`. No mainline or prior experiment code is modified.
The focused host test checks both bend directions, zero-input outward drift,
steering balance, grip saturation, straight driving and retained assistance.
Linux builds also run the existing sanitizer suite. Human handling review was accepted at this checkpoint; see FREEZE.md.
No new FPS guarantee is claimed.

World movement is now scaled by `WorldSpeedMultiplier` in `tuning.hpp`, set to
2. Player progress, stripe phase and opponents use it; displayed speed,
acceleration, lateral handling and corner-force tuning retain their prior
values. Historical distance fixtures run at 1x; focused tests verify the
production 2x player/stripe/opponent advancement.
