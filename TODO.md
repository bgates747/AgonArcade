# AgonArcade TODO

This is the authoritative task checklist. Details are in `docs/tasks/<ID>.md`;
task-specific supporting files belong in `docs/tasks/<ID>/`.

17. [ ] [RALLY-18](docs/tasks/RALLY-18.md): Review isolated centreline-camera/road-lookup candidate; headless validation passed. Lookup computation 67.0/71.4 FPS equivalent (oval/Fuji), commands+UART 37.0/41.2; perspective option measured separately. Unfenced 30 Hz review baseline accepted as a working assumption, not a verified guarantee; mainline integration and hardware qualification pending; [results](docs/tasks/RALLY-18/results/README.md).

16. [ ] [RALLY-17](docs/tasks/RALLY-17.md): Review isolated benchmarks: computation/state only 19.73/17.51 ms versus 32.10/27.94 ms including command construction/UART (oval/Fuji); accepted game unchanged.

15. [ ] [RALLY-16](docs/tasks/RALLY-16.md): Review unpaced normal-eZ80 benchmark: resident sections 29.7/29.9 FPS; native VDP swap path contains two vertical-blank waits.

14. [ ] [RALLY-15](docs/tasks/RALLY-15.md): Review isolated VDP-resident full-road renderer — implemented; headless fixed fixture 22.6/23.6 FPS, ordinary demo 18.8/25.2 FPS (oval/Fuji); mainline unchanged.
9. [ ] [RALLY-10](docs/tasks/RALLY-10.md): Investigate performance and frame pacing — pavement experiment measured at 13.6–14.0 FPS; full-road VDP section experiment proceeds as RALLY-15.
13. [ ] [RALLY-14](docs/tasks/RALLY-14.md): Instrument emulator/VDP draw operations and MOS timing callbacks — supports RALLY-10.
3. [ ] [RALLY-04](docs/tasks/RALLY-04.md): Validate the selected Rally build on physical hardware.
8. [ ] [RALLY-09](docs/tasks/RALLY-09.md): Review kerb/grass handling and inset shoulder lines.
7. [ ] [RALLY-08](docs/tasks/RALLY-08.md): Complete scenery and road-edge emulator review.
10. [ ] [RALLY-11](docs/tasks/RALLY-11.md): Qualify implemented retained scenery scrolling; performance remains unaccepted.
2. [ ] [STUNT-01](docs/tasks/STUNT-01.md): Future separate 3D stunt racer.

Completed milestones and acceptance evidence remain in the dated development
logs: [Rally](docs/2026-09-11-rally.md), [Mac continuation](docs/2026-09-11-rally-macos.md),
[Defender](defender/docs/2026-09-11.md), and [research](docs/2026-09-11-research.md).
