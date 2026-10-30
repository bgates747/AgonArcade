# Independent Oryx host affine audit

HOST-oryx01 passes: 640 raw samples cover 16 cases, eight operations and five trials. All 128 medians and ranges recompute from the CSV. All 81 frozen inputs and all 12 host-source pins remain unchanged; the host sources match the Pi run exactly. Pixel-check CSV bytes are identical to Pi.

The saved x86_64 machine code retains the work inside every timed loop. GCC unrolls loops by two, with both required calls and the loop backedge present. The transformed raster still performs float multiplication/addition, float-to-integer coordinate conversion and indirect pixel-setter dispatch. Matrix-model multiplication and analytic division also remain. No hoisting was found.

The empty controls hit their iteration cap at 8.371–9.091 ms, below the 40 ms calibration target. Nonempty measured CPU batches span 37.319–83.900 ms. No baseline subtraction occurs. The guard records a 60 °C sampled maximum, boost disabled throughout and original boost restored.

Interpretation limits remain the same as the Pi extraction: host inverse setup is an analytic model; transform-to-buffer includes host allocation but omits stock command services and precomputed natural bounds; repeated Set draws use a warm framebuffer; cached pretransformed plotting excludes its preparation cost; full-size originals use a different footprint. Player affine cases are deliberate probes because the actual replay player uses ordinary plotting.

The three stock footprint differences remain 11 pixels at the right clip, 15 at the bottom clip and 53 for synthetic opaque artwork. Those differences are retained and do not invalidate the matching-path checks. Neither host timing run establishes ESP32 render milliseconds, hardware FPS or firmware cold-inverse cost.

The Oryx guarded subprocess exited successfully after sanitizer and ordinary 16-case sequences. The sanitizer CSVs and executable ELF were not supplied locally; this audit checks the retained process/host reports and saved assembly, rather than independently replaying sanitizers or comparing the ELF bytes.

Detailed limits, all input hashes, recomputed group ranges and exact loop addresses are in ORYX-HOST-AUDIT.json. No compile, benchmark, emulator or remote action was performed by this audit; Pi evidence and all test inputs/outputs remain unchanged.
