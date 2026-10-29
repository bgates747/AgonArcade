# Wider-fill host replay

The candidate produces the same road, actor and player output as the accepted
moving additive control. Both ordinary and address/undefined-behaviour sanitizer
builds pass 900 frames/3,600 physics ticks per package. These are host correctness
checks; they do not establish target speed or displayed-frame completion.

1. `replay.py` compiles the actual generated `native.c` and renderer helper from
   `.work/control/package` and `.work/candidate/package`, without editing either.
   Control code and ABI files match `sprites/PORTABLE.zip`'s authoritative
   `source/candidate/` bytes. Results and complete package/source hashes are in
   `replay-ordinary.json` and `replay-sanitized.json`; their source/package hashes,
   output digests and final buffers agree. Host flags are `-shared -fPIC -O1
   -fno-builtin -ffp-contract=off`, with `-fsanitize=address,undefined
   -fno-omit-frame-pointer` for the sanitizer build. Leak detection is disabled
   for the Python/ctypes process; explicit lease balancing remains enabled.
2. Each fourth physics tick is followed by the accepted 21,600-byte `motion.bin`
   positions and fixed lanes, immediately before `Render30`. An independent
   integer route/traffic/contact/player model checks every physics tick, carrying
   injected positions into later ticks. The accepted motion table is separately
   regenerated from its approach/recede formula. All tick/render root and array
   bytes match between packages. The full final root and all five mutable arrays
   also match the accepted moving comparison's `CONTROL-FINAL.json`.
3. All 900 road bitmaps, all 48-byte completion records, all three output
   allocations including unused tails, all eight actor descriptor records and
   all eight actor scratch allocations are exact. Command totals per package
   are 40,860 road bytes, 244,416 actor bytes and 26,100 player bytes. The concatenated
   road-pixel SHA256 is
   `4736f1f03fcd3b2d7e23cb698366e8daeb53bb88471fe3296a301cc1123327af`.
   Both packages peak at four simultaneous leases, with 278,575 grants and 278,575
   releases each. Every invocation checks all installed buffer canaries;
   `StopRace` and finalization succeed with no live leases.
4. `span-inputs.bin` and `span-inputs.json` preserve 11,788 actual fill calls from
   frames 1, 60, 120, 180, 240, 300, 450, 600, 750 and 900. The 94,304-byte binary SHA256 is
   `12bc72f453c33f26dcfbc1c802bebd57c865d76c0913f8e7a15e91acb4af5378`.
   Each little-endian 8-byte record is `<HHHBB`: road-row byte offset, clipped
   left, clipped exclusive right, colour and zero padding. Empty calls are
   retained; the separate first grass-row `memset` is excluded. The row stride
   is 320 bytes within 38,400 road bytes. The manifest identifies every frame's first
   record, count and SHA256.
5. Capture instrumentation exists only in `.work/host/capture-package`: rename
   the accepted fill function, insert a recording wrapper and call the original
   fill. Before each selected render, copy the actual uninstrumented control's
   root/arrays/output/scratch snapshot into the capture runtime. Its resulting
   full world, outputs and scratch bytes match the uninstrumented control. The
   main ordinary/sanitizer pair uses the untouched package sources. Synthetic
   retained actor artwork comes from the established `SpriteRuntime`; these
   checks compare exact actor behaviour but do not validate real-artwork display.

The checked candidate fill include SHA256 is
`34e8845ec7e3d550fcc99dbcd47474c58a41a3ebde9c2a149440e3e9f04601c8`;
its containing render core SHA256 is
`db23c7cd14d767631884d81b5f2cecf8a741db588cd518573bf2df86de0707d7`.
Both package trees remain unchanged during replay. No emulator, SSH, hardware,
firmware change, performance claim, commit or push is part of this host work.

Execution used repository-root `.venv/bin/python`:

```bash
PYTHONDONTWRITEBYTECODE=1 .venv/bin/python docs/tasks/RALLY-28/custom-vdp/incremental/wide-fill/replay.py
```

The complete invocation preserves a fresh capture workspace by failing if
`.work/host/capture-package` already exists. Existing compiled packages can be
rechecked individually with `--worker ordinary` or, for the sanitizer worker,
the recorded sanitizer preload/environment from `replay.py`.
