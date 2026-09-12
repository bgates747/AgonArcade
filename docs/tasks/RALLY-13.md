# RALLY-13 — Deferred autosteer review

Explicitly deferred by the user. Preserve the current behavior during performance
work. Track-relative forward movement and camera rotation implicitly follow the
road tangent; manual steering changes lateral demand rather than an independently
integrated world heading.

When the user resumes this task, agree on the intended handling before separating
camera/track-frame rotation, vehicle heading and driver steering. Account for the
current projection's limitations. This document is not authorization to redesign
handling now. Root TODO.md records the deferral.
