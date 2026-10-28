"""Summarize preserved finite campaigns without launching or modifying fixtures."""
import json
from collections import defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent


def summarize():
    rows = []
    failures = []
    groups = defaultdict(list)
    for campaign in ('hzbase01', 'hzcandidate01', 'hzretry01', 'hznative01', 'hzrepeat01'):
        for name, result in json.loads((HERE / ('CAMPAIGN-' + campaign + '.json')).read_text()).items():
            if not result['passed']:
                failures.append(dict(campaign=campaign, case=name, error=result['error']))
                continue
            assert result['frames'] == 900 and result['physics_ticks'] == 3600
            assert result['final_world_exact'] and result['input_hashes_preserved']
            assert result['boost_after'] == '0'
            stats = result['backend_stats']
            assert not stats['failed'] and not any(stats[k] for k in ('unhandled', 'unregistered', 'unmapped'))
            prt = result['prt']
            assert prt['timer_borrowed'] and prt['previous_vector_restored']
            run = json.loads((HERE / 'evidence' / campaign / name / 'run.json').read_text())
            assert run['error'] is None and run['process_exit'] == 0
            guest = run['result']
            assert guest['validated_reply_records'] == 2913
            watermark = {o['label']: o['value'] for o in guest['observations']
                         if o['label'] in ('stack before', 'stack after')}
            row = dict(campaign=campaign, case=name, frames=900, physics_ticks=3600,
                nominal_mos_seconds=result['nominal_mos_seconds'],
                nominal_mos_fps=result['nominal_mos_fps'],
                nominal_prt_seconds=prt['nominal_seconds_at_18432000_hz'],
                nominal_prt_fps=prt['nominal_fps_at_18432000_hz'],
                host_seconds_including_startup=result['host_seconds_including_startup'],
                stack_minfree_observations=watermark,
                retained_reply_records=2913, final_world_exact=True,
                inputs_preserved=True, prt_vector_restored=True, backend_errors=0)
            assert abs(row['nominal_mos_fps'] * row['nominal_mos_seconds'] - 900) < 1e-7
            rows.append(row)
            if name.endswith('-fenced-unpaced'):
                groups[name].append(row)
    pooled = {}
    for name, records in groups.items():
        frames = sum(r['frames'] for r in records)
        mos_seconds = sum(r['nominal_mos_seconds'] for r in records)
        prt_seconds = sum(r['nominal_prt_seconds'] for r in records)
        pooled[name] = dict(runs=len(records), frames=frames,
            nominal_mos_seconds=mos_seconds, nominal_mos_fps=frames / mos_seconds,
            nominal_prt_seconds=prt_seconds, nominal_prt_fps=frames / prt_seconds,
            individual_nominal_mos_fps=[r['nominal_mos_fps'] for r in records])
    best = pooled['native-span-native-fenced-unpaced']
    quad = pooled['float-quad-layered-fenced-unpaced']
    rgba = pooled['native-span-rgba2222-fenced-unpaced']
    sessions = []
    for name in ('hzsession01', 'hzsession02', 'hzsession03'):
        session = json.loads((HERE / ('SESSION-' + name + '.json')).read_text())
        assert session['original_boost'] == session['final_boost'] == '1'
        assert session['boost_restored'] and not session['owned_emulator_processes_after']
        assert session['boost_during_session'] == '0'
        assert session['video_driver'] == session['audio_driver'] == 'dummy'
        sessions.append({k: session[k] for k in ('session', 'host_boot_id', 'error', 'boost_restored',
            'original_boost', 'final_boost', 'max_temperature_celsius', 'owned_emulator_processes_after')})
    assert len({s['host_boot_id'] for s in sessions}) == 1, 'Host boot changed between comparisons'
    report = dict(checkpoint='39a546a', workload='Finite native Fuji fixture, flat background, 900 frames/3600 ticks',
        successful_900_frame_runs=len(rows), rows=rows, preserved_failures=failures,
        completion_fenced_pooled=pooled,
        best_vs_quad_nominal_mos_gain_percent=(best['nominal_mos_fps'] / quad['nominal_mos_fps'] - 1) * 100,
        best_vs_quad_nominal_prt_gain_percent=(best['nominal_prt_fps'] / quad['nominal_prt_fps'] - 1) * 100,
        best_vs_rgba_nominal_mos_gain_percent=(best['nominal_mos_fps'] / rgba['nominal_mos_fps'] - 1) * 100,
        sessions=sessions,
        pooling='Sum completed frames / sum elapsed seconds; do not average FPS',
        clock_limits='MOS nominal120 units/s; PRT nominal18.432MHz instruction-driven emulator timer. '
                     'Host durations include startup/teardown. No physical ESP32/hardware calibration.',
        fence_limit='Prior ordered drawing and controller swap completed; includes extra transaction/transport. '
                    'Does not observe physical monitor scanout.',
        hardware_qualified=False, author_motion_accepted=False, new_implementation_committed=False)
    (HERE / 'EMULATOR-RESULTS.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps({k: report[k] for k in ('successful_900_frame_runs',
        'best_vs_quad_nominal_mos_gain_percent', 'best_vs_rgba_nominal_mos_gain_percent')}, indent=2))
    for name, result in pooled.items():
        print(name, result['runs'], round(result['nominal_mos_fps'], 3), round(result['nominal_prt_fps'], 3))


if __name__ == '__main__':
    summarize()
