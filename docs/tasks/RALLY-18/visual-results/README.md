# RALLY-18 native visual results

Final suite: [run-v8f_9x50/manifest.json](run-v8f_9x50/manifest.json).
These are functional captures with the native emulator and stock VDP, run
headlessly. The SDL capture/input interposer is excluded from performance runs
and interactive review profiles.

All six live/lookup scene pairs were pixel-identical at native 640×480 output.
They cover oval left/centre/right, a Fuji bend in control and perspective modes,
and a late-lap Fuji view. Saved road states remain identical across lateral
position/steering changes at the same progress and phase. The player moves
across that fixed road. Full lap/stripe seam coverage comes from the exhaustive
geometry tests; the late-lap image is not itself a lap-seam proof.

The agent inspected the lookup scene images and both three-image driving
sequences. Pavement, kerbs, shoulders, centreline, traffic, scenery and HUD
remain intact, with no visible holes at section joins. The perspective scene
shows the expected side view for a car displaced right of the camera; the
straight centred car retains its rear view. This inspection is separate from
the user's visual acceptance.

Both scripted driving runs leave demo mode, accelerate, respond to steering
and exit through the game's Escape path. Guest exit markers are present. The
oval run finishes with lateral=246.05 world units, speed=90 and 80 frames; Fuji
finishes with lateral=198.62, speed=90 and 102 frames. The last captured images
show the GRASS state and the player fully outside the viewport. This is the
intentional clipping specified by the fixed-camera contract: physics lateral
state is not clamped to the screen and the camera does not chase an off-road
car. Steering remains available to drive back. Numerical tyre/kerb/grass
threshold checks are recorded in [vehicle notes](../vehicle-notes.md).

Representative native images:

- [Oval player left](run-v8f_9x50/oval-p00-lm35-s0-control-lookup/frame-000010.png)
  and [right](run-v8f_9x50/oval-p00-l35-s0-control-lookup/frame-000010.png), with unchanged road.
- [Fuji perspective view](run-v8f_9x50/fuji-p16-l35-s0-perspective-lookup/frame-000010.png).
- Oval driving: [centred](run-v8f_9x50/controls-oval-control/frame-000030.png),
  [steering right](run-v8f_9x50/controls-oval-control/frame-000090.png),
  [grass/off-screen](run-v8f_9x50/controls-oval-control/frame-000170.png).
- Fuji driving: [centred](run-v8f_9x50/controls-fuji-perspective/frame-000030.png),
  [right side](run-v8f_9x50/controls-fuji-perspective/frame-000090.png),
  [grass/off-screen](run-v8f_9x50/controls-fuji-perspective/frame-000170.png).

All 48 timed guest scenes also matched their exact same-variant host scene
calculations: [final-scene-validation.json](../final-scene-validation.json).
These state comparisons and image pairs complement the exhaustive one-pixel
geometry bound; they do not replace it.
