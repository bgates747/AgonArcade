# Standalone stock affine command fixture

This finite AgonDev application measures the stock command paths using six
original Rally RGBA2222 bitmaps. It changes no game or firmware. Build from the
repository root with `.venv/bin/python
docs/tasks/RALLY-28/custom-vdp/affine-offline/target_build.py`. The builder creates
`fixtures/full`, `fixtures/smoke` and `fixtures/smoke-poll`, with SHA256 identities
in `../TARGET-FIXTURES.json` and `../TARGET-BUILD.json`. The first build, which
omitted the affine feature enable, is preserved under `../preparation`; its
completion smoke does not qualify any affine performance result.

The application selects stock double-buffered mode 136, explicitly enables
affine/matrix commands with `23,0,248,1,0,1,0`, uploads the original artwork once,
and stores the repeated command bodies and batches in VDP buffers. Timed drawing
stays on the hidden drawing page with no swap. A timed submission is one six-byte
buffered CALL. Nested buffered CALL dispatch remains part of the measured cost.
No scaled artwork is uploaded, and no sound command is sent.

The cases use observed far/middle/near traffic sizes, observed far/near sign sizes,
and one synthetic mirrored-player case at the production anchor. Each case runs:

1. `ordinary-sized`: ordinarily plot an image produced once by stock command 40
   before timing.
2. `cached-affine`: directly plot the original with a reused matrix and inverse.
3. `rebuilt-affine`: rebuild the identity and six-value Q8 matrix, then directly
   plot the original; this includes lazy inverse generation at the draw.
4. `transform40-plot`: use the cached matrix to allocate/replace the transformed
   bitmap with command 40, then ordinarily plot it on every repetition.
5. `matrix-only`: rebuild that matrix without drawing or generating its lazy
   inverse within the repeated body.
6. A separate `empty` control repeats resident no-op calls. It is reported without
   automatic subtraction.

Every batch, including `matrix-only` and `empty`, ends with the same one-pixel
marker and flush/completion command. Every measurement first clears the page,
executes one untimed warm operation and drains an untimed general-poll fence.
After its primary completion, it reads the final marker and drains another
untimed fence. The primary measurement includes ordered synchronous raster work
and the callback/poll return, not physical scanout or a host-window update.

Command 40 uses its natural flags 5 (`RESIZE|TRANSLATE`), whose output dimensions
are `max-min+1`. The direct transformed plot uses exclusive maximum raster edges.
The sized control and command-40 rows therefore have their natural extra edge;
they are not claimed to draw identical pixel footprints to the direct rows.

`config.bin` is exactly 16 little-endian bytes, equivalent to
`<4sHHHHHBB`: magic `R28A`, schema 1, draw repetitions, samples, setup repetitions,
case bitmask, poll selector, reserved zero. The full fixture uses 128 draws per
batch, four samples and 1,024 matrix setups (124 batches). Each smoke uses four
draws, one sample and 16 matrix setups for the first traffic and mirrored-player
cases (11 batches). `smoke-poll` selects the explicit general-poll control;
other fixtures use the key-zero callback. A missing or ambiguous callback is a
failure; a sequenced general-poll fallback drains work but is excluded from the
reported primary interval.

The program creates `timings.csv`, `summary.json` and `done.txt`, and creates
`failure.txt` on a detected failure. It refuses an application directory already
containing any of those outputs. MOS time is labelled nominal 120 units/second;
PRT1 is labelled nominal 1,000 ticks/second. Submission and post-submission wait
are recorded separately. PRT1 must be idle; its previous interrupt vector and the
MOS 3.0.2 keyboard callback are saved and restored. Cleanup returns to mode 8 with
the text viewport and cursor restored.

The application is suitable for fresh isolated emulator or hardware profiles.
Only the parent-controlled runner launches the emulator; build alone launches
nothing. Automated runs must force both `SDL_VIDEODRIVER=dummy` and
`SDL_AUDIODRIVER=dummy`. Local Pi5 emulator timings establish neither physical
ESP32 timing nor full-game frame rate.
