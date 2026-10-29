# Car scaling and MOS return review

This separate visual fixture addresses the Author's review: equal-speed traffic
did not reveal changing car sizes, and leaving the double-buffered graphics mode
active hid the MOS prompt. The measured benchmark fixtures remain unchanged.

- **INC-001-02-RV01** [x] — Cars approach and pass in both directions: three
  slower and three faster, staggered through three lanes. Each cycle sweeps
  relative station from behind the player to110000units ahead over300frames.
  Scripted positions and display lanes replace only the review scene immediately
  before rendering. This is an artificial visual exercise, not new game physics.
- **INC-001-02-RV02** [x] — The review driver restores single-buffered mode8,
  normal graphics coordinates, full text viewport and cursor before returning
  to MOS. Preserve logging, timer restoration and native StopRace/UNLOAD.

The existing corrected native sampler module and firmware are unchanged. This
900-frame review targets30Hz and can take longer under load; it is separate from performance
evidence. Source, motion table and driver can be rebuilt with the local build.py.
Motion table lives at0xA8000..0xAD45F, above the actual startup streams; the builder
checks that the ranges remain disjoint. Automated tests require both SDL dummy
drivers and the existing Oryx thermal/boost supervisor.

Run in Oryx Linux Lite's terminal:

```bash
cd /home/smith/Agon/mystuff/AgonArcade/.emulator/rally28-hz60-motionreview02-motion
./flexe-agon-emulator
```

The Author accepted the moving visuals and clean MOS exit. This profile has
sound disabled and exits to MOS after900frames. No graphical/audio launch was
performed by an agent. All new work remains uncommitted. The next requested
step is a [matched baseline comparison](../motion-comparison/README.md) using
the same deterministic traffic pattern.

The final silent check passes900frames/3600ticks/2913retained replies, exact
scripted final positions/lanes and independent player station, input hashes,
PRT-vector restoration and backend checks. The VDU trace shows single-buffered
mode8 restored before DONE, followed by `/rally25 *` from MOS. Every car exercises
62 distinct scale values,14..246 in256ths. See [range proof](SCALE-DOMAIN.json),
[final run](CAMPAIGN-motiontest04.json) and [verification](VERIFICATION.json).
The [exit capture](MOS-RETURN.png) shows the clean MOS prompt. Exact current and
rejected input sets are preserved in [REVIEW-INPUTS.zip](REVIEW-INPUTS.zip), with
per-file hashes in [PACKAGE.json](PACKAGE.json).

The first attempt failed before rendering while loading the review motion table
near the MOS stack. Its source/input/failure records are preserved. Relocating
the table lower passes; the exact internal failure cause is not qualified. An
intermediate successful run still used the old two-row completion window; the
final driver resets the full window and clears the saving-message remnants.
Scripted scene updates add70UARTbytes/frame, another reason these are not
performance-comparison inputs. These review runs are excluded from the
unchanged benchmark comparison. Both SDL drivers were dummy; boost was restored
and all emulators stopped after testing.
