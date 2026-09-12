# RALLY-11 — Retained-scrolling qualification

Stock viewport scrolling is already implemented and was frozen as potential
progress. The historical TODO wording said “Implement”; remaining work is
qualification, not rebuilding the feature. Independent buffer offsets,
exposed-edge repaint, wrap/fallback logic and bottom-sixteen-row repair pass
host and native pixel checks. Human hardware review was inconclusive.

Preserve the [frozen contract and amendment](../contracts/rally-scenery-scroll.md).
Review retained pixels and alternating-buffer correspondence when rendering or
pacing changes. Performance acceptance remains under RALLY-10, with physical
review under RALLY-04. Record an acceptance/supersession decision before removing
this entry from root TODO.md. No confirmed speed gain is claimed.
