"""Report the returned Oryx continuation without changing the Pi reports."""
from pathlib import Path
import csv
import hashlib
import json
import statistics

HERE = Path(__file__).resolve().parent
CASES = ('traffic-far', 'traffic-middle', 'traffic-near', 'sign-far',
         'sign-near', 'player-fixed-mirror')


def read(name):
    return json.loads((HERE / name).read_text())


def sha(name):
    return hashlib.sha256((HERE / name).read_bytes()).hexdigest()


def main():
    audit = read('ORYX-COMPARISON-AUDIT.json')
    assert audit['passed'] and read('ORYX-HOST-AUDIT.json')['passed']
    final = read('ORYX-FINAL-CONTROL.json')
    assert final['boost'] == '1' and not final['emulator_processes']
    assert final['frozen_files_unchanged'] and final['frozen_files_checked'] == 81
    sessions = {name: read('SESSION-' + name + '.json') for name in
                ('oryxbuild01', 'oryxhost01', 'oryxsmoke01', 'oryxfull01')}
    for session in sessions.values():
        assert session['error'] is None and session['boost_restored']
        assert session['original_boost'] == session['final_boost'] == '1'
        assert not session['owned_emulator_processes_after']
        assert session['thermal_stop_celsius'] == 95
        assert all(sample['boost'] == '0' for sample in session['samples'])
    run = read('ORYX-RUN-full01.json')
    smoke = read('ORYX-RUN-smoke01.json')
    assert run['passed'] and smoke['passed']
    assert run['summary']['completed_batches'] == 124
    host = read('HOST-oryx01.json')
    assert host['passed'] and host['samples'] == 640
    index = {(r['case'], r['operation']): r for r in host['summaries']}
    rows = list(csv.DictReader((HERE / 'evidence/oryx/full01/timings.csv').open()))
    prt = sum(int(r['prt_ticks']) for r in rows)
    mos = sum(int(r['mos_ticks']) for r in rows)
    ratio = (prt / 1000) / (mos / 120)
    target = []
    for case in dict.fromkeys(r['case'] for r in rows):
        for method in dict.fromkeys(r['method'] for r in rows if r['case'] == case):
            samples = [r for r in rows if r['case'] == case and r['method'] == method]
            assert len(samples) == 4
            target.append(dict(case=case, method=method,
                raw_prt_ticks=[int(r['prt_ticks']) for r in samples],
                raw_mos_units=[int(r['mos_ticks']) for r in samples],
                operations=int(samples[0]['operations']),
                median_raw_prt_ticks_per_operation=statistics.median(
                    int(r['prt_ticks']) / int(r['operations']) for r in samples)))
    ti = {(r['case'], r['method']): r for r in target}
    sources = ['ORYX-COMPARISON-AUDIT.json', 'ORYX-HOST-AUDIT.json',
        'ORYX-FINAL-CONTROL.json', 'ORYX-FROZEN-INPUTS.json', 'HOST-oryx01.json',
        'HOST-oryx01.csv', 'ORYX-RUNTIME-BUILD.json', 'ORYX-RUN-full01.json',
        'ORYX-RUN-smoke01.json', 'evidence/oryx/full01/runtime/verified.json',
        'evidence/oryx/smoke01/runtime/verified.json', 'evidence/oryx/full01/timings.csv',
        'TARGET-FIXTURES.json', 'RESULTS.json', 'MATRIX-REUSE.json', '../full-race/RESULTS.json']
    sources += ['SESSION-' + name + '.json' for name in sessions]
    race = read('../full-race/RESULTS.json')['equivalent_replicate_groups']
    framerate = {key: {field: race[key][field] for field in
        ('frames', 'runs', 'pooled_nominal_mos_fps', 'pooled_nominal_prt_fps')}
        for key in ('baseline', 'native_spans', 'additive_sampler')}
    data = dict(full_race_reference_framerates=framerate,
        prepared_bitmap_full_race_fps=None, reused_matrix_full_race_fps=None,
        affine_probe_completed_race_frames=0,
        missing_metric='No complete-race FPS comparison of prepared bitmap caching versus cached affine has been run',
        schema=1, passed=True, scope='Identical affine checks on Oryx after Pi5',
        target_batches=124, smoke_batches=11, host_samples=640,
        target_inputs_identical=True, application_tx_bytes=110240,
        required_ordered_replies=497, host_pixels_identical_across_architectures=True,
        source_runtime_pins_identical=True, runtime_binary_architectures_different=True,
        host_cpu_microseconds=host['summaries'], raw_target_counts=target,
        target_total_prt_ticks=prt, target_total_mos_units=mos,
        target_nominal_prt_to_mos_ratio=ratio,
        zero_mos_delta_batches=sum(int(r['mos_ticks']) == 0 for r in rows),
        clock_agreement_passed=False, physical_render_milliseconds_qualified=False,
        full_run_host_seconds=run['elapsed_host_seconds'],
        maximum_temperature_celsius=max(s['max_temperature_celsius'] for s in sessions.values()),
        all_sessions_boost_restored=True, all_emulators_stopped=True,
        pi_evidence_unchanged=True, game_changed=False, firmware_changed=False,
        hardware_tested=False, commit_or_push=False, candidate_adopted=False,
        source_sha256={name: sha(name) for name in sources})
    (HERE / 'ORYX-RESULTS.json').write_text(json.dumps(data, indent=2) + '\n')
    text = ['# Same affine checks on Oryx', '',
        'The identical stock-VDP suite passes on Oryx: 124 full batches, 497 required replies and the same 110,240-byte application command stream as Pi. All 640 native host samples also pass, with identical cross-architecture pixels/checksums. Rebuilding matrices adds avoidable setup work; generating a transformed bitmap for every draw costs more than cached direct affine in these tests. This does not establish that the stock API is generally inefficient.', '',
        'The two emulator clocks still disagree. Keep the native host CPU costs and raw emulator counts below separate; neither measures physical ESP32 milliseconds. No game or firmware change is adopted.', '',
        '## Framerate — the primary result', '',
        '**This affine investigation did not measure complete-race FPS. It draws isolated objects repeatedly, with no complete race frames or timed swaps. Therefore cached-bitmap FPS, cached-affine FPS and their game-framerate difference remain unmeasured.** The reported 4.4× near-car host draw advantage is not a 4.4× game FPS improvement.', '',
        'The latest existing complete-race Oryx Flexe measurements are below. These are prior comparison results, not new outcomes of this affine probe:', '',
        '| Complete-race renderer | Measured frames | Nominal MOS FPS | Nominal PRT FPS |',
        '| --- | ---: | ---: | ---: |',
        *[f'| {label} | {race[key]["frames"]:,} | {race[key]["pooled_nominal_mos_fps"]:.2f} | {race[key]["pooled_nominal_prt_fps"]:.2f} |'
          for key, label in [('baseline', 'Original full-race baseline'),
            ('native_spans', 'Native road spans'), ('additive_sampler', 'Accepted additive actor sampler / byte fills')]], '',
        '**Calculation:** completed frames ÷ elapsed seconds; each row pools executable-identical repeats by total frames/total elapsed, rather than averaging FPS. Elapsed seconds are MOS units/120 or PRT counts/1000, reported separately. [Original full-race data and clock limits](../full-race/RESULTS.md). These are nominal emulator throughput measurements, not physical hardware FPS.', '',
        'The missing comparison is the same complete-race workload with cached direct affine versus retained prepared bitmaps, including size changes, cache misses/generation, memory use and the final rendering fence. Report completed frames, elapsed time, FPS and FPS change first; isolated draw costs support that result. This is a proposed next experiment, not an implemented candidate or a new test release.', '',
        '## Native Oryx CPU checks', '',
        'Median microseconds per operation, five samples per method/case. These execute extracted stock kernels on the x86 host with GCC 15.2, boost disabled; they are not emulated VDP times. The inverse setup is an analytic diagonal host model, not the old firmware library. The original artwork, source and methods are unchanged from Pi.', '',
        '| Case | Cached direct affine µs | Generate + ordinary plot µs | Ordinary prepared bitmap µs |',
        '| --- | ---: | ---: | ---: |']
    for case in CASES:
        values = [index[case, m]['median_cpu_us'] for m in
                  ('cached_affine', 'transform_then_plot', 'ordinary_pretransformed')]
        text.append('| ' + case + ' | ' + ' | '.join(f'{v:.3f}' for v in values) + ' |')
    text += ['',
        'The prepared-image column excludes its one-time generation. No pre-scaled files or timed pixel uploads are used. Stock transform-to-bitmap has its natural extra output border and generates the full rectangle before plotting clips it; the near sign is mostly offscreen. The player mirror is synthetic: the actual recorded player draws are ordinary identity plots. ASan/UBSan and the independent raw/assembly audit pass. The empty-loop controls hit the repetition cap at 8.37–9.09 ms rather than the 40 ms calibration target; nonempty batches span 37.32–83.90 ms. No automatic empty-loop subtraction is used. The Pi measurements remain in [their unchanged report](RESULTS.md).', '',
        '## Stock-VDP completion-fenced batches', '',
        'Official VDP 2.16.0, MOS 3.0.2, guest/config/artwork and operation order are byte-identical. ARM and x86 runtime binaries are built privately from the same pinned frontend/core source. Each timed batch sends one six-byte resident CALL and includes stock flush/keyboard-callback completion; warm drawing and marker readback are outside the timed interval. No timed swaps occur.', '',
        '| Case | Prepared plot PRT counts/op | Cached affine | Rebuilt affine | Generate + plot | Matrix only |',
        '| --- | ---: | ---: | ---: | ---: | ---: |']
    for case in CASES:
        values = [ti[case, m]['median_raw_prt_ticks_per_operation'] for m in
                  ('ordinary-sized', 'cached-affine', 'rebuilt-affine', 'transform40-plot', 'matrix-only')]
        text.append('| ' + case + ' | ' + ' | '.join(f'{v:.4f}' for v in values) + ' |')
    text += ['',
        f'**These are raw PRT IRQ counts, not milliseconds or Xtensa cycles.** Drawing batches use 128 operations/four samples; matrix-only batches use 1,024. The separate empty control has median {ti["empty", "empty"]["median_raw_prt_ticks_per_operation"]:.4f} counts/op and is not automatically subtracted.', '',
        f'Full-run timed totals are {prt:,} PRT counts and {mos:,} MOS units. Nominal conversions disagree by {ratio:.4f}×, versus 4.4988× on Pi; {data["zero_mos_delta_batches"]} batches have zero MOS delta. The source audit establishes separately scheduled eZ80 PRT and native-raster/MOS progress. Faster host execution reduces the discrepancy but does not calibrate either clock. Whole-run host elapsed is {run["elapsed_host_seconds"]:.2f} seconds versus 83.09 on Pi, including startup/loading/warming/readback/files/cleanup; it is not isolated draw time. [Independent cross-host audit](ORYX-COMPARISON-AUDIT.md).', '',
        '## Practical findings and remaining limit', '',
        '1. Reuse unchanged matrices. Replacing one invalidates its cached inverse; the next affine draw rebuilds it. The frozen baseline audit finds 64.29% of actor rebuilds repeat the previous coefficients. The accepted additive native renderer already avoids those affine calls; no new game FPS gain or UART saving is claimed.', '',
        '2. Rendering cost grows with the sampled destination rectangle, including transparent samples. Cached direct affine avoids repeated output allocation and can clip before sampling. Regenerating a transformed image on every draw adds work; reusing a prepared image moves that work outside the repeated draw. Bounded caching remains a separate proposal.', '',
        '3. Exact physical drawing time remains open. Preserve this same portable fixture for a later authorized hardware run; do not infer physical timing or a 60 Hz game result from host timings or these emulated raw counts.', '',
        f'Both Oryx emulator attempts pass first try: smoke {smoke["elapsed_host_seconds"]:.2f} seconds/full {run["elapsed_host_seconds"]:.2f} seconds. Private runtime build takes 56.51 host seconds; host compile/sanitizer/timing takes 55.00 seconds. Every guarded session keeps boost0 and restores original1; maximum temperature is {data["maximum_temperature_celsius"]:.0f}°C under the original95°C limit. Both SDL drivers are dummy, every emulator is stopped and all 81 frozen inputs/Pi evidence files remain unchanged. Oryx is free. No graphical/audio launch, hardware operation, game/firmware edit, commit or push occurred.']
    (HERE / 'ORYX-RESULTS.md').write_text('\n'.join(text) + '\n')
    print(json.dumps({k: data[k] for k in ('passed', 'target_batches', 'host_samples',
        'target_nominal_prt_to_mos_ratio', 'all_emulators_stopped')}, indent=2))


if __name__ == '__main__':
    main()
