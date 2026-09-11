# Secondary target: direct eZ80 GPIO VGA

Shelved by user September 11, 2026; historical ID RALLY-03. The user has built and tested the
adapter. This is a secondary target, not a replacement for standard-VDP Rally.
No adapter code or hardware configuration was changed in this investigation.

## Inspected sources

1. [Tom's linked loader](https://github.com/tomm/vga-ez80/blob/main/gpiovideodriver.asm),
   retrieved September 11: resident driver copied to 8 KB internal SRAM at
   `0xb7e000`; installs an `rst.l $20` API using MOS call `0x61`. Its comments
   require Rainbow MOS 2.5+. It includes `api.asm` and `gpiovideo.asm`.
2. [Upstream README](https://github.com/tomm/vga-ez80/blob/main/README.md):
   RGB332 pixels scanned directly from eZ80 memory using OTIRX. Typical described
   modes are 156 pixels wide, with repeated scanlines. Author reports less than
   6% application CPU in the described 480-line mode and 15% in 350-line modes.
   These are upstream measurements, not measurements of this user's setup.
3. Local read-only upstream `/home/smith/Agon/tomm/vga-ez80`, revision
   `000f67f14fa80147dd32cf68be5b7656050fd6b0`, and personal fixtures at
   `/home/smith/Agon/mystuff/tomm/vga-ez80`. Local README describes a packaged
   menu, 156x120 slideshow and a 320x240 15 kHz slideshow. Neither local tree
   has the `api.asm` included by the linked online loader: do not assume the
   local checkout and current web driver expose the same API.
4. Personal `gpiovideo.asm` has `fb_scanline_offsets`, an array of 24-bit
   addresses/offsets populated for scanline repetition. This suggests a possible
   optimization, pending inspection of actual scanout address semantics.

## Initial engineering assessment

Direct framebuffer access removes VDP command transport but makes CPU time the
critical constraint: the eZ80 also generates the signal. The current C++ VDU
renderer cannot simply be relinked. Retain motion/projection semantics and add
an independent RGB332 rendering backend adapted to the chosen display mode.

For this straight road, precomputed row patterns and changing scanline pointers
could avoid repainting every pixel. This is a proposed approach, not yet proven:
check pointer semantics, memory capacity, safe table-update timing and the cost
of geometry/input work during available blanking. Static sky/ground and only
changing kerb/dash material are useful constraints for a first demonstration.

The user's existing hardware fixtures are the starting evidence for mode choice.
Confirm the exact tested mode and MOS/driver combination before hardware work;
the online loader's Rainbow requirement is not proof it works unchanged with
our standard Platform MOS emulator profile. Keep modifications within AgonArcade
unless separately authorized to change the fixture project. Hardware validation
will be required; standard VDP emulator output does not validate GPIO timing.

Discussion refinement: precomputed perspective-correct road rows could be
selected by integer distance/phase. Sprite compositing would require handling
transparency and scaling without modifying shared road rows; scratch rows for
sprite-covered scanlines are an untested candidate. No implementation is active.
