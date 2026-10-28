# Native road candidate review on Oryx

Three recommended isolated profiles are prepared and stopped. All use the exact reviewed R25 workload, driver, assets, four physics ticks per update and old3/3/4-unit pacer. They retain the native firmware already used for that demo. Sound is forced off; only the Author launches a visible window. Boost may be enabled for human runs; automated timing used boost disabled.

The startup-only third-line status was removed from all four human review profiles after the Author reported flashing. Its text is replaced with equal-length spaces, preserving cursor movement, every script byte and the timed drawing loop. Only the review artwork and its checksum metadata changed; existing outputs and frozen benchmark inputs are preserved. [Change receipt](REVIEW-STARTUP.json). Relaunch with the same commands below; no agent emulator run was needed for this correction. Visual confirmation remains the Author's gate.

1. **Best observed drawing candidate:** shared original float endpoints and one stock four-corner fill per layered material. Same geometry and sampled pixels as control.

```bash
cd /home/smith/Agon/mystuff/AgonArcade/.emulator/rally28-native-review01
./flexe-agon-emulator
```

2. **Provisional segment-aligned experiment:** the same faster float/quad/layered path, with polygon boundaries at every projected track-segment change plus stripe transitions. This isolates the proposed geometry; it completed at13.63FPSwith boost disabled, compared with14.24–14.84for the original control and15.22–15.66for the faster unchanged partition. Judge this geometry in motion before deciding whether the extra bands are useful.

```bash
cd /home/smith/Agon/mystuff/AgonArcade/.emulator/rally28-native-aligned-review01
./flexe-agon-emulator
```

3. **Preserved control, if needed for comparison:** original renderer rebuilt byte-for-byte.

```bash
cd /home/smith/Agon/mystuff/AgonArcade/.emulator/rally28-native-control-review01
./flexe-agon-emulator
```

Run one window at a time. Expect900frames of scripted Fuji driving, traffic/signs, a centered player and intentionally flat background, then result files and return to MOS. Judge motion, edge continuity, markings and shape changes. This is a finite fixture, not the playable game. Each run creates its own logs in its profile's `sdcard/rally25`; the agent retrieves them afterward. No card deployment or flashing has occurred. The firmware binary for a later C8 comparison is byte-identical to the previous Rally-25 firmware.

The combined integer/quad/disjoint/segment variant is also preserved at `.emulator/rally28-native-segments-review01`; it was slower still (9.30FPS). It is not the recommended geometry review profile. One automated attempt stalled during initial module upload before rendering; its unchanged fresh retry passed. Report a static startup if it recurs in review; it is distinct from the measured drawing costs.
