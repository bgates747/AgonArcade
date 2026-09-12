# RALLY-08 — Scenery and road-edge review

Review the implemented procedural flat-shaded panorama, absolute-heading
scrolling, wider kerbs and white/yellow shoulder lines. The layer is effectively
at infinity, without parallax; preserve the solid blue sky and accepted visual
direction. Do not restart rejected dithering experiments.

The root checklist retains emulator review despite earlier visual iterations.
Reconcile acceptance deliberately with the user rather than infer it from an
old screenshot or implementation status. Inspect heading wrap, both alternating
buffers and lower-sky foreground cleanup; coordinate retained-scrolling behavior
with RALLY-11. Record acceptance in the dated log and then update root TODO.md.
