# Independent host affine audit

HOST-pi01 passes source, timing and compiler checks: 640 samples covering 16 cases, eight operations and five trials. All 128 reported medians/ranges reproduce from the raw CSV. Ordinary and ASan/UBSan checks agree. This qualifies a Pi5 host microbenchmark; it does not establish VDP or physical ESP32 timing.

All frozen host files still match the run hashes. The original 43 RGBA2222 images were independently recovered from the frozen stock artwork upload and palette maps and agree byte for byte. Every extracted function/region occurs verbatim in its pinned source, including the VGA64 std::function setter path. The old committed VDP header is used; later live-header additions are not silently substituted.

The actual aarch64 binary retains every per-iteration affine/plain/buffer-transform/matrix call and loop backedge. Its transformed inner loop retains float multiply/add sampling and indirect pixel-setter dispatch. No drawing or setup hoisting was found. The analytic host inverse retains division; it is explicitly not the firmware cold-inverse implementation.

The raw results preserve the natural stock edge differences: direct affine and command40-plus-plot differ by 11 pixels at the right clip, 15 at the bottom clip and 53 for the synthetic fully opaque image. The other 13 cases match. Cached/rebuilt affine and prepared/rebuilt buffer-plot checks agree.

The 40 ms option is a calibration target. The empty-control cap yields 35.047–35.187 ms samples; actual nonempty sample durations span 39.956–79.556 ms. No baseline is subtracted. Host endpoints were 48.5→54.55 °C at 2.4 GHz with the ondemand governor; intermediate frequency/temperature were not sampled.

The following limits govern interpretation:

1. Pi5 aarch64 host CPU timing only: no ESP32, PSRAM, UART, VDP command service, scanout or full-game frame-rate claim.
2. make_affine/rebuilt_affine_host_model use a diagonal analytic inverse and an exact separately identified ESP-DSP 1.8.0 ANSI multiply; neither measures the old firmware Mat inverse, target-selected optimized DSP, allocations or cold matrix command cost.
3. Transform-to-buffer methods include host vector allocation, initialization and destruction; surrounding stock command40 buffer-service allocation/lookup/registration is absent. The kernel label does not mean allocation-free.
4. natural_buffer_size is prepared outside timing: transform_bitmap_kernel/transform_then_plot omit command40 natural bounds computation, matrix cache checks and command parser overhead. Full direct affine retains draw-time transformed bounds/clipping dispatch.
5. ordinary_pretransformed prepares stock command40 output once outside timing; it illustrates reuse after preparation and is not an adoption or new scaled-asset file path.
6. ordinary_original_size draws a different unscaled footprint; it is a control, not an equal-work scaling comparison.
7. All timed draws reuse the same source, transform, destination and framebuffer in Set mode, with one clear outside each timed batch. This is a warm repeated-draw test without scene motion, background repaint, queue contention, VSync or realistic framebuffer working-set churn.
8. Source alpha 0/3 and synthetic all-opaque/all-transparent are covered; partial alpha 1/2, blend modes, sprites and other source pixel formats are outside this fixture.
9. Direct affine clipping excludes its drawingRect X2/Y2 while natural command40 fills all resized pixels. The three observed footprint differences are retained, not treated as correctness failures or equal-pixel comparisons.
10. The observed player uses ordinary/no-transform plotting in all 900 replay frames. Affine/identity and mirror player cases deliberately probe alternate stock paths and do not imply those affine costs occur in the current player hot loop.
11. Fourteen selected workload/coverage cases plus two alpha controls are timed, not every observed artwork/matrix combination. Case order is fixed and method order reverses on alternate trials; there is no process affinity or fixed-frequency enforcement.
12. The 40 ms setting is a calibration target. Capped empty controls measure about 35 ms and later samples can vary slightly from calibration. No empty baseline is subtracted.
13. Only before/after host temperature, governor, frequency and load are recorded. These bound observed endpoints, not continuous peak temperature, scheduling load or frequency.
14. Run records final source hashes rather than an automatic before/after source-immutability check; separate agreed source freeze and this audit match every final pin. Original runtime snapshots are not byte-rebuilt firmware proofs.
15. Sanitizers cover the 16 selected cases and checksum checks; they do not prove the correctness of all affine matrices or make target hardware performance claims.

The JSON retains exact input hashes, independent checks, arithmetic counts and the inspected machine-code excerpts. No host timing input/output, stock file, game, firmware or existing fixture was changed by this audit. No emulator or additional timing run was launched.
