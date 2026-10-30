"""Join audited host timings, standalone target checks and exact source findings."""
from pathlib import Path
import csv
import hashlib
import json
import statistics

HERE = Path(__file__).resolve().parent


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def read(name):
    return json.loads((HERE / name).read_text())


def report():
    host = read('HOST-pi01.json')
    assert host['passed'] and host['samples'] == 640
    assert read('HOST-AUDIT.json')['passed']
    clocks = read('TARGET-TIMING-AUDIT.json')
    assert clocks['passed'] and not clocks['clock_agreement_passed']
    run = read('TARGET-RUN-full01.json')
    assert run['passed'] and run['summary']['completed_batches'] == 124
    assert run['input_identities_unchanged'] and run['process_exit'] == 0
    checked = read('evidence/full01/runtime/verified.json')
    assert checked['passed']
    with (HERE / 'evidence/full01/timings.csv').open() as source:
        rows = list(csv.DictReader(source))
    assert len(rows) == 124 and all(int(row['valid']) == 1 for row in rows)
    target = []
    for case in dict.fromkeys(row['case'] for row in rows):
        for method in dict.fromkeys(row['method'] for row in rows if row['case'] == case):
            samples = [row for row in rows if row['case'] == case and row['method'] == method]
            assert len(samples) == 4
            operations = {int(row['operations']) for row in samples}
            assert len(operations) == 1
            n = operations.pop()
            prt = [int(row['prt_ticks']) for row in samples]
            mos = [int(row['mos_ticks']) for row in samples]
            target.append(dict(case=case, method=method, samples=4, operations_per_batch=n,
                               raw_prt_ticks=prt, raw_mos_ticks=mos,
                               median_prt_ticks_per_operation=statistics.median(prt) / n,
                               median_mos_units_per_operation=statistics.median(mos) / n,
                               calibrated_physical_time=False))
    total_prt = sum(int(row['prt_ticks']) for row in rows)
    total_mos = sum(int(row['mos_ticks']) for row in rows)
    ratio = (total_prt / 1000) / (total_mos / 120)
    assert total_prt == 72880 and total_mos == 1944
    source_names = ['HOST-pi01.json', 'HOST-AUDIT.json', 'TARGET-TIMING-AUDIT.json',
                    'TARGET-RUN-full01.json', 'evidence/full01/runtime/verified.json',
                    'evidence/full01/timings.csv', 'WORKLOAD.json', 'SOURCE-MANIFEST.json',
                    'MATRIX-REUSE.json', 'TARGET-FIXTURES.json', 'TARGET-BUILD.json',
                    'PI-RUNTIME-BUILD.json']
    data = dict(schema=1, scope='Isolated stock affine costs using real Rally artwork; Pi5 only',
                host_samples=640, host_cases=16, host_trials=5, host_cpu_microseconds=host['summaries'],
                stock_target_batches=124, target_functional_audit_passed=True,
                target_raw_counts=target, target_clock_agreement_passed=False,
                target_sum_prt_ticks=total_prt, target_sum_mos_units=total_mos,
                nominal_clock_ratio=ratio, physical_VDP_milliseconds_qualified=False,
                runtime_frontend_commit=read('PI-RUNTIME-BUILD.json')['frontend_commit'],
                original_artwork_count=43, observed_measured_draws=5767,
                no_new_game_or_firmware_code=True, Oryx_contacted=False,
                candidate_adopted=False, hardware_tested=False, all_emulators_stopped=True,
                historical_controls_and_archives_unchanged=True,
                excluded_runs={'smoke01': 'Missing affine feature enable; harness-only result, timing excluded',
                               'smoke02': 'UART startup stall before timed batches',
                               'smoke03': 'UART startup stall before timed batches'},
                successful_runs=['pi-runtime01', 'smoke04', 'full01'],
                matrix_setup_host_values_are_analytic_model=True,
                current_additive_renderer_already_avoids_actor_affine=True,
                source_sha256={name: sha(HERE / name) for name in source_names})
    (HERE / 'RESULTS.json').write_text(json.dumps(data, indent=2) + '\n')
    host_index = {(row['case'], row['operation']): row['median_cpu_us'] for row in host['summaries']}
    selected = ['traffic-far', 'traffic-middle', 'traffic-near', 'sign-far', 'sign-near', 'player-fixed-mirror']
    text = ['# Isolated affine results on Pi5', '',
            'Stock direct affine plotting is measurably more work than an ordinary plot of an already resized image. Generating that image afresh and then plotting it is slower than cached direct affine in these host checks. Reusing a prepared image is a different workload. The stock API itself is not judged generally inefficient.', '',
            'All 124 standalone stock-VDP batches pass their independent command/reply and cleanup audit. The Pi emulator’s independently scheduled clocks disagree, so this test does not establish calibrated VDP milliseconds. Host CPU times below are valid for this Pi5 process; they are not ESP32 timings. No game change is adopted.', '',
            '## Actual host CPU cost', '',
            'Median microseconds per operation, five samples per case; actual original artwork and observed placements, except the explicitly forced player reflection. Stock cached matrix, clipping, alpha and VGA64 pixel setter paths execute in the extracted host code. Each method reverses order on alternate trials.', '',
            '| Case | Cached direct affine | Generate bitmap + ordinary plot | Ordinary prepared bitmap |',
            '| --- | ---: | ---: | ---: |']
    for case in selected:
        values = [host_index[case, method] for method in ('cached_affine', 'transform_then_plot', 'ordinary_pretransformed')]
        text.append('| ' + case + ' | ' + ' | '.join(f'{value:.3f}' for value in values) + ' |')
    text += ['',
             '1. The prepared-image column excludes its one-time generation; the generate-and-plot column includes host allocation, sampling and plotting on every operation. Original full-size art is loaded once; no pre-scaled artwork files or timed pixel uploads are introduced.', '',
             '2. Direct plotting clips before sampling. Natural transform-to-bitmap generates the whole resized rectangle before the ordinary plot clips it. The observed near sign is mostly off the left edge, making that distinction especially visible.', '',
             '3. Stock natural output has an extra border relative to direct affine bounds. Thirteen selected cases agree exactly; right/bottom clipping and the synthetic all-opaque case differ by 11/15/53 pixels respectively. These are reported stock edge conventions, not a reason to pursue pixel-exact repair in this investigation.', '',
             '4. All 43 original images were recovered and hash-checked. Timings cover 14 selected real/synthetic poses plus opaque/transparent controls, not every one of the 2,737 unique measured draw combinations. All 900 observed player draws are ordinary untransformed plots; the forced mirror and identity-affine controls must not be charged to that accepted fixture.', '',
             '5. HOST-pi01.csv preserves 640 raw samples and both thread CPU and host wall clocks. ASan/UBSan checks pass. HOST-AUDIT independently verifies arithmetic, source identity and actual compiled per-iteration work. The host inverse is an explicit analytic diagonal model; its setup numbers do not measure the old firmware’s allocating matrix/inverse library.', '',
             '## Standalone stock-VDP execution', '',
             'Official unmodified VDP 2.16.0 and MOS 3.0.2 run on a privately built ARM64 Flexe runtime. Mode136 draws into the hidden page without timed swaps. Each batch sends one six-byte CALL to already resident commands, then waits for the stored graphics flush and keyboard callback. The subsequent marker readback is outside timing. Source artwork, matrix input, output allocation/replacement and callback/timer restoration are explicit.', '',
             '| Case | Cached affine PRT ticks/op | Rebuilt affine PRT ticks/op | Generate + plot PRT ticks/op | Prepared plot PRT ticks/op |',
             '| --- | ---: | ---: | ---: | ---: |']
    index = {(row['case'], row['method']): row for row in target}
    for case in selected:
        values = [index[case, method]['median_prt_ticks_per_operation'] for method in
                  ('cached-affine', 'rebuilt-affine', 'transform40-plot', 'ordinary-sized')]
        text.append('| ' + case + ' | ' + ' | '.join(f'{value:.4f}' for value in values) + ' |')
    text += ['',
             '**These are raw eZ80 PRT counts, not calibrated render milliseconds or Xtensa cycles.** Every drawing row uses 128 repetitions and four samples. Matrix-only rows use 1,024 repetitions, with no inverse generation inside their repeated body. Empty CALL/fence controls remain separately reported, without automatic subtraction.', '',
             f'The measured batches total {total_prt:,} PRT counts versus {total_mos:,} MOS units. Nominal conversions disagree by {ratio:.4f}×, and 13 batches have zero MOS delta. A single rescale is unjustified. PRT progresses on independently paced eZ80 cycles while MOS VSync depends on native I2S raster progress; per-method waits can therefore include host scheduling and emulation throughput. Hidden-page causation is unproved. TARGET-TIMING-AUDIT preserves the source evidence and every raw MOS/PRT row.', '',
             f'The full run took {run["elapsed_host_seconds"]:.2f} host seconds including startup, warm operations, readback, file output and cleanup. It passes 124 batches/497 ordered completion/readback packets, exact inputs, zero backend faults and clean MOS return. A prior corrected smoke passes 11 batches. The earlier missing-feature smoke is excluded; two startup stalls are retained before the fresh identical smoke succeeded. No firmware, UART-buffer, clock or guest-transfer workaround was introduced.', '',
             '## What the source/workload audit establishes', '',
             '1. Replacing a transform matrix discards its cached inverse. The next transformed draw computes and retains another inverse; unchanged matrices reuse that cached inverse. The old affine actor helper currently rebuilds identity and six coefficients for every drawn actor.', '',
             '2. In the exact 900-frame baseline replay, 3,129 of 4,867 traffic/sign rebuilds repeat the last coefficients for their matrix ID: 64.29% overall, 72.51% of traffic and 16.08% of signs. Plot position and artwork may still change, so those objects still need drawing. MATRIX-REUSE records cache ownership, warm state and invalidation constraints.', '',
             '3. Omitting those repeated matrix commands would remove 84,483 resident command bytes in this native baseline, not that many bytes from the eZ80 UART. There is no measured FPS gain from that proposed change. The accepted additive actor renderer already bypasses these affine calls; this finding primarily explains the old baseline and may inform the standard-VDP path.', '',
             '4. Direct affine samples every pixel in its clipped destination box, including transparent source samples. Transform-to-bitmap also allocates/replaces an image and samples its natural rectangle. An already prepared bitmap avoids that repeated transformation work; bounded reuse/caching remains a separate proposal.', '',
             'No new game optimization, hardware deployment or publication was performed. All work remains uncommitted. SOURCE-ROUTES, SOURCE-MANIFEST, WORKLOAD and the two independent audits preserve implementation details and limits.']
    (HERE / 'RESULTS.md').write_text('\n'.join(text) + '\n')
    print(json.dumps(dict(host_samples=640, target_batches=124, functional_pass=True,
                          clock_agreement=False, hardware_tested=False), indent=2))


if __name__ == '__main__':
    report()
