# Identical-fixture Console8 / Flexe comparison

Both platforms ran the same ten input files byte for byte, including the unpaced guest/script, assets, native module installation and supplied VDP firmware. All900 frame requests/3600 physics ticks pass; saved reply transcripts and complete final state are identical and match the independent reference. Flexe on Oryx measures29.02FPS; Console8 measures23.45FPS. This replaces the earlier comparison between differently paced configurations.

| Platform | Frames | Measured loop time | Aggregate FPS |
| --- | ---: | ---: | ---: |
| Console8 |900|38.3833s|23.4477|
| Flexe JIT on Oryx |900|31.0167s|29.0167|

The guest and resources were copied directly from the returned card, with every input SHA-256 checked against the original hardware deployment receipt and again after Flexe execution. No guest, script, module, assets or metadata was rebuilt or edited. Both guests use `/test/arcade/rally`. Hardware-tagged metadata remains unchanged in the emulator; only host-generated result labels identify the emulator platform. Supplied firmware8da2ebf... is also the exact Flexe-loaded firmware; flashed hardware bytes are not read back by this fixture.

Evidence: [comparison and hashes](IDENTICAL-COMPARISON.json), [Flexe saved-log verification](IDENTICAL-FLEXE-RESULTS.json), [Flexe run/runtime/backend receipt](IDENTICAL-FLEXE-RUN.json), [physical verification](HARDWARE-RESULTS.json), raw evidence/identical-flexe-* and evidence/hardware-*. Independent final globals/five mutable arrays match;2913saved reply records match byte for byte. Flexe backend failure/unhandled/unregistered/unmapped counters are clear, process exits cleanly. Existing accepted visual profile and card contents/results were preserved.

The window includes physics, renderer preparation, transport/readback checks, drawing commands and swap submission. It excludes startup, final-state retrieval and log saving. There is no separate VDP completion timestamp, phase isolation or autonomous120/30Hz scheduler. Both FPS figures use nominal120MOS units/s in the60Hz mode. Hardware PRT agrees within0.19%; Flexe PRT is instruction-clock timing and is not substituted for emulator wall time. Flexe host runtime40.304s includes startup/teardown and is separate from the measured loop.

Reproduction tool: `run_identical_flexe.py --card <returned card /test/arcade/rally directory> --name <unused isolated profile name>`. It copies existing deployed bytes, validates identities, generates a profile with the canonical launcher, runs headlessly and compares against the verified hardware transcript/state. No physical rerun, commit/push or additional optimization was performed.
