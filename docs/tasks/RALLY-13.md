# RALLY-13

Resumed by explicit user instruction. Implement manual cornering on the RALLY-18
lookup candidate, isolated in this task bucket. Preserve autosteer as a launch
option, off by default for manual driving; demo retains assistance.

Manual steering must supply cornering demand, subject to existing grip limits.
Zero steering must produce outward drift in a bend. Use centreline curvature
across the whole road width; no inside/outside radius adjustment. Retain existing
steering increments, speed, surfaces, rendering and 30 Hz pacing, without polls.
Perspective vehicle views remain optional and off by default.

Qualify both bend signs, steering compensation and grip saturation headlessly,
then launch a stock-emulator review. This is arcade tuning, not a heading/yaw
simulation. No mainline changes or commits before review and explicit approval.

The user accepted and authorized freezing this tuning checkpoint. See
[RALLY-13/FREEZE.md](RALLY-13/FREEZE.md) for the final settings and review record.
