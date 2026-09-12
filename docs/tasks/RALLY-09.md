# RALLY-09 — Surface handling and shoulder review

Review car-width kerb/grass contact, slowdown and inset shoulder lines. Current
road/kerb extents are ±90/±106 world units, with a 12-unit car half-width;
contact thresholds are therefore centre magnitudes above 78 and 94. Kerb drag
is milder than grass drag, kerb grip is multiplied by 1.15 and grass grip by 0.5.
Shoulder stripes occupy magnitudes 84–86. HUD surface labels and host checks
are implemented; formal hardware acceptance remains pending.

Review symmetry, transitions, full-throttle slowdown and braking to zero without
changing accepted tuning incidentally. Record user acceptance and evidence in
the dated log before removing the entry from root TODO.md. Coordinate physical
review with RALLY-04; no deployment is implied by this document.
