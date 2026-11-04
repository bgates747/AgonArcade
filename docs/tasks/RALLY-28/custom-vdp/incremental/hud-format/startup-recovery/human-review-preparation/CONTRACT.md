# Rally: fresh review preparation for the accepted functional candidate

Prepare a readable stopped human review of the already-qualified moving Rally
candidate, so its remaining visual gate can be reviewed once the Author is
ready. Reuse accepted code and evidence; do not repeat the full qualification
merely to refresh a screenshot. Rally owns the application and preparation.

## Selection and limits

This follows root283/owner18's existing-gate inventory under GOLEM-057. The
specific compact/HUD moving review remains open although older race reviews
and source checkpoint publication are accepted. Existing maintained086
900-frame/3600-step functional qualification is the baseline; this is not a
new SDK-image migration, timing experiment, old-stall repair or product/default
adoption. Direct Author work retains priority.

1. Identify the exact already-qualified module, application, assets, firmware
   and engine that the review will exercise. State whether one combined view
   meaningfully covers both compact and HUD visual changes; preserve any gate
   it cannot cover. Do not transfer old race acceptance silently.
2. Reuse an existing finite human frontend when suitable. Identify what code
   is actually being shown, expected track/car/HUD movement, completion and
   exit instructions onscreen. Restore the cursor and return cleanly to MOS.
   No calibrated FPS comparison or hidden extra drawing is required.
3. Preserve all old inputs/failed attempts and accepted functional results.
   Freeze any necessary frontend/profile-only differences before preparing a
   new isolated project .emulator profile using canonical wrapper/preflight
   rules. No native service, physics, renderer or timing-policy change.
4. Source/build/stopped staging are selected. No target process is selected by
   this preparation contract. If a new frontend needs a bounded correctness
   check, return the concrete difference and existing-evidence gap rather
   than automatically repeating900 frames or launching an old profile.
5. Return exact stopped readiness and the remaining human gates. Do not prompt
   the Author, take a human slot, run a GUI or retain Oryx while preparing.
   The current PCM human review remains under Golem custody. Any later actual
   test/review uses self-service FIFO and preserves normal ownership gates.

## Owner items

- RHP-001 [ ] Map the selected qualified candidate to the specific open gates.
- RHP-002 [ ] Freeze and prepare only needed frontend/profile differences.
- RHP-003 [ ] Verify stopped source/runtime/wrapper and readable instructions.
- RHP-004 [ ] Return readiness or the smallest concrete missing qualification.

Rally's authoritative TODO owns consumer status; this is a bounded delegation
contract, not a competing queue. Consumer publication remains separately owned.
