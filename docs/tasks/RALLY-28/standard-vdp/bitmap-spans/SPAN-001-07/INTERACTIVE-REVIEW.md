# Visible, silent Flexe suite on Oryx

The full ten-case portable suite is staged for the Author to launch on the Oryx desktop. Every case uses a separate fresh Flexe profile and the frozen app/config/table/diagnostic image bytes. Sound is forced off. Preparation verified all inputs and shell syntax; no emulator was launched. Interactive timing is a separately identified human run, not silently pooled with the earlier headless measurements.

In a terminal on **Oryx Linux Lite**:

```bash
cd /home/smith/Agon/mystuff/AgonArcade/.emulator/rally28-road-suite-review01
./run-suite.sh
```

1. The first five cases measure actual physics or CPU preparation and show text rather than a road. They are physics, common-geometry polygon CPU, original bitmap CPU, lookup bitmap CPU and on-demand polygon CPU. The terminal prints the case name and progress.
2. The empty timing control follows, then four visible road cases: on-demand polygons, common-geometry polygons, original bitmap spans and lookup bitmap spans. Each opens its own visible window; the runner closes it after completion and opens the next. No shortened frame count or rebuilt fixture is substituted.
3. The prior long Flexe drawing cases stalled. Each road case has a five-minute host bound; a timed-out case is recorded and the next starts in a fresh emulator. Allow roughly25minutes if all four road cases hit that bound. This is a desktop/emulator suite policy, not the physical hardware coordinator's failure policy.
4. Close a window or press Ctrl-C in the launching terminal to stop the entire suite. Closing the terminal also terminates its owned active emulator. Sound is always `SDL_AUDIODRIVER=dummy`; visible video explicitly selects the desktop's X11/Wayland backend. CPU boost must remain disabled, as it was during staging.
5. Suite results are in `human-suite.json` beside run-suite.sh. Each case's `human-result.json`, frontend log, raw UART/backend artifacts and guest summary/CSV remain under its own `.emulator/rally28-road-suite-review01-CASE/` directory. Inputs and old evidence are preserved. A second invocation refuses used output paths; stage a new suite name for another run.

The human launcher requires a local desktop terminal. Agent automated testing remains authorized only with **both** SDL dummy drivers. Nothing here launches a visible emulator through agent tools or changes hardware, the normal game, existing profiles or the accepted headless-run evidence. The hardware PLAN.ready flag remains false.

Reproduction: use repository `.venv/bin/python` with `interactive_suite.py --prepare FRESH-NAME` (name must start `rally28-road-suite-`), then `--check PROFILE-DIRECTORY`. Preparation imports the existing canonical-profile factory; every child is launched from its own directory via `./flexe-agon-emulator`, never the raw runtime. `INTERACTIVE-PROFILES.json` records the actual staged input sets; `INTERACTIVE-STAGING.json` records verification. New changes are uncommitted pending human review.
