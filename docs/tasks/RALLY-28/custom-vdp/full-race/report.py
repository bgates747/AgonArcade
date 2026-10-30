"""Report two logical orders selected from unchanged original run receipts."""
from pathlib import Path
import argparse
import hashlib
import json

HERE = Path(__file__).resolve().parent


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def read(name):
    path = HERE / name
    assert path.resolve().is_relative_to(HERE), name
    return json.loads(path.read_text())


def selection(path, variants):
    path = Path(path)
    path = path if path.is_absolute() else HERE / path
    assert path.resolve().is_relative_to(HERE)
    selected = json.loads(path.read_text())
    assert selected['schema'] == 1
    order = list(variants)
    assert [row['case'] for row in selected['forward']] == order
    assert [row['case'] for row in selected['reverse']] == list(reversed(order))
    references = selected['forward'] + selected['reverse']
    assert len(references) == len({(row['campaign'], row['case']) for row in references}) == 34
    assert all(row['case'] in variants for row in references)
    for name, expected in selected['source_receipts'].items():
        source = HERE / name
        assert source.resolve().is_relative_to(HERE), name
        assert sha(source) == expected, ('Selected original receipt changed', name)
    campaigns = list(dict.fromkeys(row['campaign'] for row in references))
    for campaign in campaigns:
        assert 'CAMPAIGN-' + campaign + '.json' in selected['source_receipts']
        assert 'PROFILES-' + campaign + '.json' in selected['source_receipts']
        assert campaign in selected['source_sessions']
    counts = {name: sum(row['campaign'] == name for row in references) for name in campaigns}
    assert counts == {'raceab03': 17, 'raceba03': 12, 'racefinish01': 5}, counts
    provenance = dict(path=path.relative_to(HERE).as_posix(), sha256=sha(path),
                      source_receipts=selected['source_receipts'], source_sessions=selected['source_sessions'],
                      selected_runs_by_campaign=counts, original_successful_runs_retained=29,
                      new_finishing_runs=5, synthetic_campaigns_or_raw_copies=False)
    return selected, campaigns, provenance


def report(comparison_selection='COMPARISON-SELECTION.json'):
    variants = read('FIXTURES.json')
    assert len(variants) == 17
    selected, campaigns, provenance = selection(comparison_selection, variants)
    receipts = {campaign: read('CAMPAIGN-' + campaign + '.json') for campaign in campaigns}
    named_runs, by_order = [], {}
    for logical_order in ('forward', 'reverse'):
        by_order[logical_order] = {}
        for ordinal, source in enumerate(selected[logical_order], 1):
            campaign, case = source['campaign'], source['case']
            entry = receipts[campaign][case]
            assert entry['passed'] and entry['input_hashes_preserved'] and entry['process_exit'] == 0
            result = entry['result']
            assert (result['frames'], result['physics_ticks']) == (900, 3600)
            assert result['final_state_exact']
            assert result['nominal_mos_ticks'] > 0 and result['nominal_prt_ticks'] > 0
            assert abs(result['nominal_mos_fps'] - 900 * 120 / result['nominal_mos_ticks']) < 1e-9
            assert abs(result['nominal_prt_fps'] - 900 * 1000 / result['nominal_prt_ticks']) < 1e-9
            row = dict(logical_order=logical_order, ordinal=ordinal, case=case,
                       source_campaign=campaign, source_case=case,
                       source_session=selected['source_sessions'][campaign],
                       source_evidence_directory=entry.get('evidence_directory', 'evidence/' + campaign + '/' + case),
                       source_selected_attempt=entry.get('selected_attempt', 1),
                       frames=900, physics_ticks=3600,
                       nominal_mos_ticks=result['nominal_mos_ticks'],
                       nominal_prt_ticks=result['nominal_prt_ticks'],
                       nominal_mos_fps=result['nominal_mos_fps'],
                       nominal_prt_fps=result['nominal_prt_fps'],
                       host_seconds=entry['host_seconds'],
                       presentation_counters=result['presentation_counters'],
                       timed_wire_bytes=result['timed_wire_bytes'],
                       state_sha256=result['state_sha256'], module_sha256=variants[case]['module_sha256'],
                       final_state_exact=True, process_exit=0, input_hashes_preserved=True)
            named_runs.append(row)
            by_order[logical_order][case] = row
    assert len(named_runs) == 34
    rows = []
    for case, meta in variants.items():
        forward, reverse = by_order['forward'][case], by_order['reverse'][case]
        assert forward['state_sha256'] == reverse['state_sha256']
        assert forward['presentation_counters'] == reverse['presentation_counters']
        assert forward['timed_wire_bytes'] == reverse['timed_wire_bytes']
        mos = forward['nominal_mos_ticks'] + reverse['nominal_mos_ticks']
        prt = forward['nominal_prt_ticks'] + reverse['nominal_prt_ticks']
        rows.append(dict(case=case, alias_of=meta.get('alias_of'), frames=1800,
                         pooled_nominal_mos_fps=1800 * 120 / mos,
                         pooled_nominal_prt_fps=1800 * 1000 / prt,
                         nominal_mos_ticks=mos, nominal_prt_ticks=prt,
                         forward_nominal_mos_fps=forward['nominal_mos_fps'],
                         reverse_nominal_mos_fps=reverse['nominal_mos_fps'],
                         forward_nominal_prt_fps=forward['nominal_prt_fps'],
                         reverse_nominal_prt_fps=reverse['nominal_prt_fps'],
                         forward_host_seconds=forward['host_seconds'], reverse_host_seconds=reverse['host_seconds'],
                         source_runs=[{key: sample[key] for key in ('logical_order', 'source_campaign', 'source_case', 'source_session')}
                                      for sample in (forward, reverse)],
                         presentation_counters=forward['presentation_counters'],
                         timed_wire_bytes=forward['timed_wire_bytes'], state_sha256=forward['state_sha256'],
                         module_sha256=meta['module_sha256']))
    base = rows[0]
    assert base['case'] == 'baseline'
    for row in rows:
        row['nominal_mos_gain_vs_baseline_percent'] = 100 * (row['pooled_nominal_mos_fps'] / base['pooled_nominal_mos_fps'] - 1)
        row['nominal_prt_gain_vs_baseline_percent'] = 100 * (row['pooled_nominal_prt_fps'] / base['pooled_nominal_prt_fps'] - 1)
    groups = {}
    for label, cases in {'baseline': ['baseline'], 'native_spans': ['span-native', 'split-clear'],
                         'additive_sampler': ['additive', 'static']}.items():
        inputs = [variants[case]['files'] for case in cases]
        first = {key: value for key, value in inputs[0].items() if key != 'expected.json'}
        assert all({key: value for key, value in values.items() if key != 'expected.json'} == first for values in inputs)
        samples = [sample for sample in named_runs if sample['case'] in cases]
        frames = sum(sample['frames'] for sample in samples)
        mos_fps, prt_fps = ([sample[key] for sample in samples] for key in ('nominal_mos_fps', 'nominal_prt_fps'))
        groups[label] = dict(cases=cases, runs=len(samples), frames=frames,
            pooled_nominal_mos_fps=frames * 120 / sum(sample['nominal_mos_ticks'] for sample in samples),
            pooled_nominal_prt_fps=frames * 1000 / sum(sample['nominal_prt_ticks'] for sample in samples),
            nominal_mos_fps_range=[min(mos_fps), max(mos_fps)], nominal_prt_fps_range=[min(prt_fps), max(prt_fps)],
            observed_mos_range_percent=100 * (max(mos_fps) / min(mos_fps) - 1),
            observed_prt_range_percent=100 * (max(prt_fps) / min(prt_fps) - 1),
            source_runs=[dict(campaign=sample['source_campaign'], case=sample['source_case']) for sample in samples],
            executable_inputs_identical_within_group=True,
            range_is_observed_variation_not_confidence_interval=True)
    assert [group['runs'] for group in groups.values()] == [2, 4, 4]
    word = next(row for row in rows if row['case'] == 'word-fill')
    accepted = groups['additive_sampler']
    word_gain = 100 * (word['pooled_nominal_mos_fps'] / accepted['pooled_nominal_mos_fps'] - 1)
    repeat_range = max(group['observed_mos_range_percent'] for group in groups.values())
    wider_fill = dict(word_runs=2, accepted_byte_fill_runs=4,
        word_pooled_nominal_mos_fps=word['pooled_nominal_mos_fps'],
        accepted_byte_pooled_nominal_mos_fps=accepted['pooled_nominal_mos_fps'],
        nominal_mos_difference_percent=word_gain, maximum_observed_identical_input_mos_range_percent=repeat_range,
        difference_within_observed_repeat_range=abs(word_gain) <= repeat_range,
        adopted=False, disposition='Keep accepted additive sampler with byte fills; observed small difference does not establish a repeatable optimization gain')
    audit = read('RAW-AUDIT.json')
    # The independent audit publishes explicit positive qualification fields,
    # rather than a top-level passed flag. Validate its actual completed schema.
    assert audit.get('passed', True) and audit.get('error') is None
    assert audit['whole_run_count'] == len(audit['whole_runs']) == 34 and audit['variants'] == 17
    assert audit['independent_of_builder_runner_and_verifier']
    assert audit['all_runtime_and_input_identities_exact']
    assert audit['full_timed_ez80_UART_identical_across_all34']
    assert audit['comparison_selection_sha256'] == provenance['sha256']
    audited = {(row['campaign'], row['case']): row for row in audit['whole_runs']}
    assert len(audited) == 34
    for sample in named_runs:
        raw = audited[(sample['source_campaign'], sample['source_case'])]
        assert raw['frames'] == 900 and raw['native_physics_ticks'] == 3600 and raw['raw_native_replies'] == 5624
        assert raw['nominal_mos_units'] == sample['nominal_mos_ticks']
        assert raw['nominal_prt_ticks'] == sample['nominal_prt_ticks']
        assert raw['final_state_sha256'] == sample['state_sha256']
        assert raw['evidence_directory'] == sample['source_evidence_directory']
        assert not raw['timing_excluded']
        assert all(raw[field] for field in ('every_request_response_exact', 'retained_equals_all_raw_native',
            'full_final_root_and_arrays_exact', 'timer_vector_restore_guest_check', 'native_stop_unload_zero',
            'mode8_MOS_prompt_after_cleanup', 'backend_zero_errors'))
    result = dict(schema=2, campaigns=campaigns, comparison_selection=provenance,
                  variants=17, completed_runs=34, measured_frames=30600, measured_native_physics_ticks=122400,
                  named_runs=named_runs, rows=rows, equivalent_replicate_groups=groups,
                  maximum_observed_identical_input_mos_range_percent=repeat_range, wider_fill=wider_fill,
                  all_final_worlds_exact=True, shared_race_presentation=True,
                  guest_sha256=read('GUEST-BUILD.json')['files']['probe.bin'],
                  hardware_tested=False, human_visual_review_pending=True, unpaced_foreground=True,
                  historical_timings_not_pooled=True, obsolete_static_and_split_clear_are_input_identical_aliases=True,
                  flat_sky_gain_does_not_transfer_to_race_view=True,
                  clock_limit='Nominal emulated MOS 120 units/s and PRT 1,000 ticks/s retained separately; no hardware or physical scanout rate.',
                  timing_scope='Whole race workload, command transfer, checked native completion and post-swap fence; no isolated raster/physics headroom claim.')
    (HERE / 'RESULTS.json').write_text(json.dumps(result, indent=2) + '\n')
    text = ['# Full-race renderer comparison', '',
        'Every renderer runs the same race presentation: scrolling panorama, approaching/receding traffic, road/signs/player/finish, HUD/footer and engine commands. These fresh results judge complete-race workload performance; historical flat-background gains remain separate.', '',
        '| Variant | Forward MOS FPS | Reverse MOS FPS | Pooled MOS FPS | Pooled PRT FPS | MOS vs baseline |',
        '| --- | ---: | ---: | ---: | ---: | ---: |']
    for row in rows:
        text.append(f"| {row['case']} | {row['forward_nominal_mos_fps']:.2f} | {row['reverse_nominal_mos_fps']:.2f} | {row['pooled_nominal_mos_fps']:.2f} | {row['pooled_nominal_prt_fps']:.2f} | {row['nominal_mos_gain_vs_baseline_percent']:+.2f}% |")
    text += ['', 'Pool only executable-identical replicas. The range is observed run variation, not a confidence interval.', '',
             '| Engine | Runs | Pooled MOS FPS | Pooled PRT FPS | MOS FPS range | Range |',
             '| --- | ---: | ---: | ---: | ---: | ---: |']
    for label, group in groups.items():
        lo, hi = group['nominal_mos_fps_range']
        text.append(f"| {label} | {group['runs']} | {group['pooled_nominal_mos_fps']:.2f} | {group['pooled_nominal_prt_fps']:.2f} | {lo:.2f}–{hi:.2f} | {group['observed_mos_range_percent']:.2f}% |")
    text += ['',
        f"1. Executable-identical repeats span up to {repeat_range:.2f}% in nominal MOS FPS. Wider fill differs {word_gain:+.2f}% from the four accepted byte-fill runs; that small difference is assessed against this repeat spread. Keep the accepted additive sampler with byte fills.", '',
        '2. Split-clear has exactly the span-native executable inputs; corrected static has exactly the additive inputs. Their differences are replica variation, not separate optimization gains. Panorama retention and changed-cell HUD caching are common to every case. The earlier flat-sky gain does not transfer.', '',
        '3. COMPARISON-SELECTION.json preserves two logical 17-case orders, with each row pointing to its original campaign/case. It retains 17 forward and 12 reverse successes from racefullsession02, then five remaining reverse cases under racefinishsession01. An external CPU-boost change interrupted the original session after its 29 valid runs; the interrupted case is excluded. No successful original receipt or raw stream was copied into a synthetic campaign. The selector pins source receipts, and the independent raw audit qualifies the selected intervals.', '',
        '4. Every selected run completes 900 measured renders/3,600 native physics ticks after two unmeasured warm renders. All 34 pass exact final state, 5,624 retained native replies, completion/post-swap checks, timer restoration, stop/unload, zero backend errors and clean MOS return. RESULTS.json preserves all 34 named runs and their actual source references. Completed 272-frame crash/blink/recovery coverage and fenced scene captures are excluded from timing.', '',
        '5. The deterministic driving policy disables damage while checking contacts and exercises panorama repair, dynamic HUD/footer, traffic scaling and finish markings. This fixture is not interactive full-game/state-machine or autonomous physics-scheduler qualification.', '',
        '6. Runs use silent headless Oryx Flexe with the same pinned firmware/runtime, boost 0 during selected intervals and the original 95°C guard. MOS/PRT remain separate nominal emulator clocks. Host activity and observed variation limit inference; there is no physical frame-rate, monitor scanout or isolated physics-headroom claim.', '',
        '7. The earlier partial raceab02 campaign is excluded. Bounded startup transport retries preserve their original streams and qualification evidence. Guest/native/backend/state or in-window failures are not eligible silent retries. DIAGNOSTIC-ATTEMPTS.md and ATTEMPTS registries retain original outcomes; the final guest loads before mode136 and uses the corrected road/actor viewports.', '',
        'New fixture and evidence remain uncommitted for Author visual review and explicit publication approval.']
    (HERE / 'RESULTS.md').write_text('\n'.join(text) + '\n')
    print('\n'.join(text[:25]))
    return result


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--comparison-selection', default='COMPARISON-SELECTION.json')
    args = parser.parse_args()
    report(args.comparison_selection)
