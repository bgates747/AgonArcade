# SPAN-001-03 — Straight-road bitmap demo

A working isolated proof of two resident35×1road bitmaps, one parameter buffer and a resident plotting sequence on stock Fab. Six views pass64pixel readbacks; a fresh stopped Oryx profile is ready for Author visual review. This is a drawing mechanism test, not a throughput benchmark or game replacement.

## Run on Oryx

```bash
cd ~/Agon/mystuff/AgonArcade/.emulator/rally28-span03-single-write-review
./fab-agon-emulator
```

It shows six views for approximately two seconds each: centred road, road shifted left, road shifted right, then the same three with the stripe phase inverted. It returns to the centred first view and holds. Press SPACE to cycle views manually; Q or Escape exits. Audio is always dummy. A used profile refuses another launch to preserve self-created logs; prepare a fresh profile to repeat.

Look for continuous road coverage, normal perspective widening/stripe spacing, two alternating kerb/marking patterns, correct centring and left/right clipping. Thin markings are visibly broadened by the deliberately small source bitmap. This is for the Author to assess; automated pixel checks do not replace that review.

## Representation and wire bytes

1. Two35×1opaque RGBA2222 bitmaps contain a symmetric cross-section:3kerb,1asphalt,1shoulder,12asphalt,1centre dash,12asphalt,1shoulder,1asphalt,3kerb. Unpainted replaces the dash with asphalt. Both shoulder lines and centre dash are one source pixel wide. Horizontal scale retains its original32pixel reference; translation centres the35pixel canvas about pixel17's centre. The added asphalt pixel is distributed symmetrically, moving the shoulders/kerbs outward by half a scaled source pixel relative to the prior34pixel sample. Grass remains a separate viewport clear.
2. Each scanline104–223 has its original integer half-width `floor((y−96)*106/50)` and a preloaded horizontal scale/centering matrix. Matrices are signed16Q6 inputs, exact for these scales/translations, with vertical scale1. No per-frame floating point or matrix construction runs on eZ80.
3. The original depth/stripe formula and distant unpainted cutoff116 determine material. `DESIGN.json` lists the normal straight-road material-band boundaries. One1pixel-high plot fills each scanline inside those bands; this preserves coverage and perspective widening rather than stretching a rectangular strip over a tall trapezoid. The existing dense renderer's straight-centre greedy bands split at precisely these material changes. It does not use a new arbitrary road-stripe cadence.
4. A single720byte parameter plane holds120records of bitmap ID, centre X and scale-matrix ID (three16bit fields). Y resides in the drawing buffer. The resident command sequence copies those fields into draw commands, then CALLs the patched plot buffer. Centring is part of the matrix; the eZ80 sends centre positions directly.
5. Each road update is **11byte parameter-patch header +720byte payload +6byte CALL =737wire bytes**. This proof deliberately includes row-specific scale IDs even though they are static; later experiments can reduce that redundancy. It is one parameter update, not120upstream plot commands.
6. The resident run tail resets the transform, flushes and requests a GP completion reply. Its7completion-command bytes are part of resident setup, not additional recurring upstream bytes. The proof also sends a separate7byte GP fence per view, labels, a15byte grass clear, and verification requests; those are outside737. No claim that737is total application traffic. `summary.txt` records the complete pre-save explicit-send count (printf labels are excluded from that byte counter); the final run records17092bytes. The diagnostic check traffic must not be used as a future benchmark payload.
7. Setup commands total11585bytes, including bitmap installation,720byte initial parameter plane,120matrices,2040byte draw buffer and5419byte resident run buffer. Setup is separate from recurring updates. Firmware also allocates inverse matrices/caches; no physical peak-memory claim is made.

## Qualification and limits

`evidence/rally28-span03-test04/` preserves the final exact22473byte executable (SHA256`f101a2010b966d1389e97734f5e00158fe70bdc8d666f59a633fe7b1c7e48d76`), identity, summary and64pixel rows. All six views complete without failure. Eight centre samples per view verify normal phase/distant cutoff; available inside/outside edge samples verify scale, placement and background. Both SDL drivers were forced dummy, boost stayed0, input/runtime hashes match, the owned emulator was stopped. Initial test01 passed48centre samples on the preceding binary; test02 added edge checks on the prior pattern; test03 incorporates Author-requested outward kerb widening and one-pixel centre dash ; test04 adds the Author-selected symmetric35pixel layout and is the current review pin. No raw UART capture or whole-frame screenshot proof is claimed.

Fab uses the preserved1.2.5stock native host VDP module and official MOS3.0.2; it does not execute Flexe's ESP32image. The review profile pins the exact same application/module/MOS as test04. Mode8is single-buffered320×240; the test draws six static pictures, with labels and intentional viewing pauses. Its roughly13second run is not FPS evidence. Completion is a GP-polled fence; no timer/vector/callback is installed by this demo. Finish line, traffic, physics, sound and gameplay are outside scope. Existing products and fixture bytes are preserved.

## Reproduction

From the project root, using its Python environment:

```bash
.venv/bin/python docs/tasks/RALLY-28/standard-vdp/bitmap-spans/SPAN-001-03/build.py
```

The tiny standalone build uses the existing AgonDev installation on the Pi. Source assets/commands and DESIGN.json regenerate with generate.py. Empty constructor/destructor tables were inspected in the target map. No SDK changes.

On Oryx, with the source and exact `.work/bin/spans.bin` staged, use a **fresh** profile name:

```bash
.venv/bin/python docs/tasks/RALLY-28/standard-vdp/bitmap-spans/SPAN-001-03/profile.py rally28-span03-next
.venv/bin/python docs/tasks/RALLY-28/standard-vdp/bitmap-spans/SPAN-001-03/run.py rally28-span03-next
```

The profile generator uses the canonical setup helper; launch goes through generated `./fab-agon-emulator`, strict module/MOS/input hashes and no fallback. The automated runner always forces both SDL dummy drivers, bounds its run and stops only its owned process group. Never automate a graphical/audible launch.

The previous all-dirt/scope checkpoint was9a2e3e8; demo/planning was subsequently checkpointed at50acc3c before this tranche. New demo work is uncommitted for Author visual review. No further benchmark/integration/physical/firmware work is inferred.


## Single-write implementation and assembly review — current candidate

SPAN-001-04/05 were released and are delivered in [results](../assembly-review/RESULTS.md). The sample now embeds a writable initialized737byte RoadCommand, patches bitmap/centre fields in its middle, leaves matrix IDs/header/CALL untouched and sends the whole envelope in one MOS call. Current binary is23266bytes, SHA25640a992b93bc6c164877859ed3beab6b90d559a486a098f8a96d47399485b2e75; linked array0x457b2in.data, constructor tables empty. Current evidence is `evidence/rally28-span03-single-write-test01/`, including command.bin: six views/64pixel readbacks match test04exactly, expected737byte envelope verified, six road writes, both SDL dummy and runtime identities intact. The historical qualification paragraphs above describe test04; the launch command now selects the new fresh stopped single-write profile.

The compiler emitted assembly with comments under real flags, exposing remaining stripe arithmetic and actual-game stack/addressing costs. No additional optimization or throughput benchmark has been applied. No commit/push or game change; stopped for Author review.
