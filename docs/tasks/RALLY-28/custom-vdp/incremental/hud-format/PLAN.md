# Cache formatted race HUD values

Avoid rebuilding unchanged HUD/footer strings while preserving every displayed
cell and drawing operation. The Author's2026-10-31 "alright, go" releases this
single change, verification and a silent matched Oryx benchmark. Existing research
and all other dirt remain preserved/uncommitted; no checkpoint was requested.

Root TODO owns HUD-001-01–04. Implement a shared, constant-initialized formatted
field cache for the standard game and the new isolated native full-race fixture.
Use the existing formats, widths, arithmetic and truncation behavior. Keys must
cover the actual displayed value, including mode/lap/policy changes. Keep the
two-page HUD cell/color cache and redraw footer after its existing clear. Do not
change physics, sky, primitive commands, native module, firmware or pacing.

Verify actual old/new presentation through host C++ execution across phases,
policies, records, clock/speed/score/rank values, invalidation and page alternation.
Count cache formatting work outside performance fixtures. Preserve the accepted
control binary/inputs; build a separate candidate from its exact guest with only
the presentation change. Compile the standard game and inspect candidate assembly.

Prepare six fresh profiles: control/candidate60-frame smoke, then control/candidate
900-frame/3,600-tick comparison and reverse. Two warm pages, same full-race motion,
assets, generated state, checked module and original final swap fence in both.
Smoke must pass before full runs; failure stops this tranche without automatic
retry. Preserve all failed/unrun cases. Original300host-second per-run limit,
60second UART-progress guard,95°C session stop and actual initial boost restoration
remain. Expected host occupancy is roughly5–8minutes including setup/teardown;
this estimate does not change the finite guards.

Use the current shared FIFO scheduling README: prepare/reserve, fresh inspection,
checkout when first, per-process assertion, both SDL dummy drivers, retrieve/stop/
fresh inspect/release, then immediately steer the next agent before analysis.
No GUI launched by the agent. Return FPS first with frames/elapsed MOS and
separate PRT, both-order comparison, byte/state/reply evidence and clock limits.
Leave a fresh candidate review profile stopped; human launch requires its own
custodian checkout when the Author is ready. Visual acceptance and explicit
commit/push remain later gates; no further optimization follows automatically.
