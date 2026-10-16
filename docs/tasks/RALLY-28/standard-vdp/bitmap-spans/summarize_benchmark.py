"""Read preserved observations; never launch an emulator or contact hardware."""
from pathlib import Path
import csv
import hashlib
import importlib.util
import json
import math
import statistics

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[4]
EVIDENCE = HERE / 'SPAN-001-07/evidence'


def load(name):
    directory = EVIDENCE / name
    result = json.loads((directory / 'result.json').read_text())
    rows = [{k: int(v) for k, v in row.items()}
            for row in csv.DictReader((directory / 'frames.csv').open())] if (directory / 'frames.csv').exists() else []
    return result, rows


def distribution(values):
    ordered = sorted(values)
    return dict(mean=statistics.mean(values), median=statistics.median(values),
                p95=ordered[math.ceil(len(ordered) * .95) - 1],
                minimum=min(values), maximum=max(values))


def completed(name):
    result, rows = load(name)
    summary = result['summary']
    assert result['reason'] == 'guest-files' and summary['failure'] == 'none' and summary['restored'] == '1'
    assert len(rows) == result['identity']['frames'] == int(summary['frames'])
    assert result['identities_unchanged']
    n = len(rows)
    host = result['host_window_seconds']
    sums = {k: sum(row[k] for row in rows) for k in rows[0]}
    return dict(profile=name, frames=n, host_window_seconds=host,
                host_completed_or_cpu_frames_per_second=n / host,
                host_ms_per_frame=1000 * host / n,
                nominal_prt_ms=int(summary['prt_ticks']), mos_units=int(summary['mos_units']),
                frame_prt_ms={k: distribution([r[k] for r in rows]) for k in ('geometry', 'packing', 'submission', 'wait')},
                frame_bytes=distribution([r['bytes'] for r in rows]),
                all_explicit_bytes=int(summary['explicit_bytes']),
                bytes_outside_frame_spans=int(summary['explicit_bytes']) - sums['bytes'],
                vdp_us={k: distribution([r[k] for r in rows]) for k in ('vdp_submit_us', 'vdp_complete_us', 'vdp_drain_us')},
                vdp_sum_identities_pass=all(r['vdp_submit_us'] + r['vdp_drain_us'] == r['vdp_complete_us'] for r in rows))


def main():
    cpu = {label: completed(name) for label, name in [
        ('polygons_sparse', 'rally28-road-sparse-fab-0-final05'),
        ('polygons_common_geometry', 'rally28-road-v0-fab-0-final05'),
        ('bitmap_arithmetic', 'rally28-road-v1-fab-0-final05'),
        ('bitmap_lookup', 'rally28-road-v2-fab-0-final05')]}
    fab = {label: completed(name) for label, name in [
        ('polygons_sparse', 'rally28-road-sparse-fab-1-final05'),
        ('polygons_common_geometry', 'rally28-road-v0-fab-long05'),
        ('bitmap_arithmetic', 'rally28-road-v1-fab-long05'),
        ('bitmap_lookup', 'rally28-road-v2-fab-long05')]}
    for case in [*cpu.values(), *fab.values()]:
        assert case['host_window_seconds'] >= 10
    flexe = {label: completed(name) for label, name in [
        ('polygons_sparse', 'rally28-road-sparse-flexe-1-final05'),
        ('polygons_common_geometry', 'rally28-road-v0-fenced-probe05'),
        ('bitmap_arithmetic', 'rally28-road-v1-fenced-probe05'),
        ('bitmap_lookup', 'rally28-road-v2-fenced-probe05'),
        ('empty', 'rally28-road-v3-flexe-1-final05')]}
    failures = {}
    wire = json.loads((HERE / 'SPAN-001-07/WIRE-PROOF.json').read_text())
    for variant in range(3):
        name = f'rally28-road-v{variant}-flexe-1-final05'
        r, rows = load(name)
        assert r['reason'] == 'timeout' and r['identities_unchanged']
        failures[name] = dict(reason=r['reason'], summary=r['summary'], rows_saved=len(rows),
                              backend_stats=r['backend_stats'], wire=wire[name],
                              host_bound_seconds=r['host_seconds'])
    physics_name = 'rally28-road-physics-lifecycle02'
    physics, _ = load(physics_name)
    spec = importlib.util.spec_from_file_location('verify_results', HERE / 'SPAN-001-09/verify_results.py')
    verifier = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(verifier)
    verifier.verify(EVIDENCE / physics_name, {'kind': 'physics'})
    assert len(list(csv.reader((EVIDENCE / physics_name / 'state.csv').open()))) == 420
    physics_summary = physics['summary']
    physics_result = dict(profile=physics_name, steps=int(physics_summary['steps']), fields=420,
                          host_window_seconds=physics['host_window_seconds'],
                          host_steps_per_second=8192 / physics['host_window_seconds'],
                          nominal_prt_ticks=int(physics_summary['prt_ticks']),
                          mos_units=int(physics_summary['mos_units']),
                          lifecycle_and_independent_state_pass=True)
    audit = json.loads((HERE / 'assembly-review/evidence/AUDIT.json').read_text())
    protected = {**audit['protected_sha256'], **audit['source_sha256']}
    for name, expected in protected.items():
        assert hashlib.sha256((ROOT / name).read_bytes()).hexdigest() == expected, name
    product = hashlib.sha256((ROOT / 'rally-game/bin/rally.bin').read_bytes()).hexdigest()
    assert product == '7f1620ed8139ee779e7d50e333ef572aeaf612a154e41ec574e63a57da760293'
    result = dict(schema=1, checkpoint='94cf665', cpu=cpu, fab_stock_completed=fab,
                  flexe_short_diagnostic=flexe, flexe_full_diagnostic_failures=failures,
                  physics=physics_result, protected_files_unchanged=len(protected), product_sha256=product,
                  limits=['Road-only fixtures, separate actual physics capacity; no integrated game cadence.',
                          'Common geometry polygons redundantly compute all rows; sparse polygons are the fair CPU control.',
                          'VDP intervals include parser/buffer/matrix/normal-worker scheduling and completion, not exclusive raster or scanout.',
                          'Short Flexe probes cover 16 opening-section poses; no sustained/full-track qualification.',
                          'VDP record retrieval is outside frame spans and inside diagnostic whole windows.',
                          'Fab native and Flexe ESP32 diagnostic cases differ; not identical-byte cross-backend comparison.',
                          'PRT milliseconds and VDP microseconds are emulator-local nominal scales; no physical calibration claim.'])
    (HERE / 'BENCHMARK-RESULTS.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(dict(cpu_wall_ms={k: v['host_ms_per_frame'] for k, v in cpu.items()},
                          fab_completed_fps={k: v['host_completed_or_cpu_frames_per_second'] for k, v in fab.items()},
                          flexe_vdp_mean_ms={k: v['vdp_us']['vdp_complete_us']['mean'] / 1000 for k, v in flexe.items()},
                          physics=physics_result, protected_files_unchanged=len(protected)), indent=2))


if __name__ == '__main__':
    main()
