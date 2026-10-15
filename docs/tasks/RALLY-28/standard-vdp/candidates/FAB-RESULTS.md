# RALLY-28 — same v5 fixtures on Fab 1.2.5

All five rendering candidates and the separate physics-service diagnostic completed900frames under Fab. None reproduced the Flexe submission stalls in these single runs. Exact guest binary/mode/table hashes match PORTABLE-V5; no application rebuild or preserved product change. This narrows the failure to a difference between runtime paths without establishing its cause or physical behavior.

| Candidate | Host frame-loop seconds | Completed FPS |
|---|---:|---:|
| Dense control |160.602|5.60|
| Fine lookup/direct |63.615|14.15|
| Fine lookup/buffered |49.828|18.06|
| Coarse lookup/direct |57.441|15.67|
| Coarse lookup/buffered |45.151|19.93|

Each run has900CSV rows, no guest-reported failure, restored timer/callback, expected final scripted position/phase and independently expected application-plus-fence byte totals. These are deterministic full-scene fixtures, not full-game or hardware FPS. Host windows use50ms file polling; PRT agrees within0.05%. No suspension was detected; boost remained disabled. Host load was not controlled, so these are provisional single-run observations.

The fine-buffered independent physics diagnostic also completed900frames and serviced9456actual numerical ticks with zero final debt and maximum observed debt4. All105saved final state fields match the independent reference. Nominal PRT duration78.823s and MOS9456units are consistent with the120Hz reference here, but this is not integrated gameplay or physical cadence qualification. The post-run reference check initially failed on an absent Oryx reference source; local checking passed on retrieved outputs. That exception occurred before its host interval was persisted, so no measured host FPS is reported for this case and no emulator rerun was made.

## Runtime and limits

Oryx used the existing Fab1.2.5 executable and stock `vdp_platform.so` from the preserved runtime, with official MOS3.0.2. Profiles copy/hash the module and use a canonical generated `./fab-agon-emulator` launcher with strict module selection and no fallback. Every launch forces BOTH SDL dummy drivers; all six owned sessions are stopped. No visible/audible run, hardware deployment, upstream edit, commit or push occurred.

Fab executes a native host VDP module; Flexe executes the ESP32 release image. The application inputs are identical, but the VDP execution implementation is different. Fab provides no equivalent captured UART stream in this campaign: saved guest callback/frame results and byte totals pass, while raw packet/command equality and a new framebuffer/motion review are not independently established here. Existing host serializer proofs remain separate. The observed success does not prove the suspected ESP32 UART recovery race.

Evidence: `evidence/fab-v5/COMPARISON.json` and each variant's input files, summary, frame CSV, identity and frontend log. `fab_compare.py` preserves the sequential fresh-profile workflow; its fixed profile names are consumed. All work remains uncommitted for review.
