"""Compile and time extracted stock affine kernels on the Pi5 CPU only."""
from pathlib import Path
import argparse
import csv
import hashlib
import json
import os
import platform
import statistics
import subprocess
import time

HERE = Path(__file__).resolve().parent
WORK = HERE / '.work/host'


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def host_state():
    def read(path):
        p = Path(path)
        return p.read_text().strip() if p.is_file() else None
    return dict(uname=platform.uname()._asdict(),
                temperature_millicelsius=read('/sys/class/thermal/thermal_zone0/temp'),
                cpu_frequency_khz=read('/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq'),
                cpu_governor=read('/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor'),
                load_average=os.getloadavg())


def cases():
    workload = json.loads((HERE / 'WORKLOAD.json').read_text())
    bitmaps = {row['bitmap_id']: row for row in workload['bitmaps']}
    assert len(bitmaps) == 43
    for image in bitmaps.values():
        assert sha(HERE / image['path']) == image['sha256']
    selected = []
    for row in workload['target_cases']:
        image = bitmaps[row['bitmap_id']]
        selected.append({**row, 'asset': image['path'], 'asset_sha256': image['sha256']})
    middle = next(row for row in selected if row['name'] == 'traffic-middle')
    pixels = (HERE / middle['asset']).read_bytes()
    for label, alpha in [('opaque', 0xc0), ('transparent', 0)]:
        path = WORK / ('synthetic-' + label + '.rgba2222')
        path.write_bytes(bytes((value & 63) | alpha for value in pixels))
        selected.append({**middle, 'name': 'synthetic-all-' + label,
                         'asset': str(path.relative_to(HERE)), 'asset_sha256': sha(path),
                         'provenance': 'synthetic-alpha-control',
                         'reason': 'Original RGB retained; every alpha forced to ' + label})
    lines = []
    for row in selected:
        matrix = row['matrix_q8']
        assert matrix[1] == matrix[3] == 0
        fields = [row['name'], str((HERE / row['asset']).resolve()),
                  row['source_width'], row['source_height'], matrix[0], matrix[4], matrix[2], matrix[5],
                  row['x'], row['y'], *row['clip']]
        assert all(not any(char.isspace() for char in str(value)) for value in fields)
        lines.append('\t'.join(map(str, fields)) + '\n')
    (WORK / 'cases.tsv').write_text(''.join(lines))
    data = dict(schema=1, workload_sha256=sha(HERE / 'WORKLOAD.json'),
                actual_source_assets=43, timed_cases=selected,
                no_scaled_asset_files=True, original_artwork_unchanged=True)
    (HERE / 'HOST-CASES.json').write_text(json.dumps(data, indent=2) + '\n')
    return data


def run(name, minimum_ms, trials):
    assert name.isalnum(), 'Fresh short run name'
    prefix = HERE / ('HOST-' + name)
    assert not any(path.exists() for path in (prefix.with_suffix('.csv'), prefix.with_suffix('.json'),
                                             HERE / ('HOST-' + name + '-build.log'))), 'Preserve old timing runs'
    WORK.mkdir(parents=True, exist_ok=True)
    plan = cases()
    sources = [HERE / 'benchmark.cpp', *sorted((HERE / 'stock').glob('*.cpp'))]
    assert len(sources) >= 2 and (HERE / 'stock/stock.hpp').is_file()
    # DSP C routines may already be included by stock.cpp; only standalone
    # files placed at the stock root are separate translation units.
    sources += sorted((HERE / 'stock').glob('*.c'))
    ordinary = WORK / 'benchmark'
    sanitized = WORK / 'benchmark-sanitized'
    common = ['g++', '-std=c++17', '-ffp-contract=off', '-fno-lto', '-Wall', '-Wextra',
              '-I', str(HERE), *map(str, sources)]
    commands = [common + ['-O2', '-o', str(ordinary)],
                common + ['-O1', '-g', '-fsanitize=address,undefined', '-fno-omit-frame-pointer',
                          '-o', str(sanitized)]]
    report = dict(schema=1, name=name, host_before=host_state(),
                  timing_scope='Host CPU executes stock pixel kernels; no ESP32/PSRAM/VDP-cycle claim',
                  matrix_model_limit='Analytic diagonal inverse is a host model, not firmware inverse/setup cost; see SOURCE-MANIFEST.json',
                  minimum_calibration_cpu_ms=minimum_ms, trials=trials,
                  case_manifest_sha256=sha(HERE / 'HOST-CASES.json'),
                  commands=[], clock_cpu='CLOCK_THREAD_CPUTIME_ID', clock_wall='CLOCK_MONOTONIC_RAW',
                  compiler=subprocess.check_output(['g++', '--version'], text=True).splitlines()[0],
                  checksums_observed=True, whole_case_order='Input order; method order reverses on alternate trials',
                  no_baseline_subtraction=True, emulator_launched=False)
    started = time.monotonic()
    log = HERE / ('HOST-' + name + '-build.log')
    try:
        with log.open('w') as stream:
            for command in commands:
                stream.write(repr(command) + '\n'); stream.flush()
                subprocess.run(command, stdout=stream, stderr=subprocess.STDOUT, check=True)
                report['commands'].append(command)
        env = dict(os.environ, ASAN_OPTIONS='detect_leaks=0:halt_on_error=1',
                   UBSAN_OPTIONS='halt_on_error=1')
        validation_prefix = WORK / ('sanitized-' + name)
        subprocess.run([str(sanitized), str(WORK / 'cases.tsv'), str(validation_prefix), '.01', '1'],
                       check=True, env=env)
        report['sanitizer_checked_cases'] = len(plan['timed_cases'])
        subprocess.run([str(ordinary), str(WORK / 'cases.tsv'), str(prefix), str(minimum_ms), str(trials)],
                       check=True)
        with prefix.with_suffix('.csv').open() as stream:
            rows = list(csv.DictReader(stream))
        assert len(rows) == len(plan['timed_cases']) * trials * 8
        summaries = []
        for case in plan['timed_cases']:
            for operation in dict.fromkeys(row['operation'] for row in rows):
                samples = [row for row in rows if row['case'] == case['name'] and row['operation'] == operation]
                cpu = [float(row['cpu_ns_per_operation']) for row in samples]
                wall = [float(row['wall_ns_per_operation']) for row in samples]
                assert len(samples) == trials and min(cpu) > 0 and min(wall) > 0
                summaries.append(dict(case=case['name'], operation=operation,
                                      median_cpu_us=statistics.median(cpu) / 1000,
                                      cpu_us_range=[min(cpu) / 1000, max(cpu) / 1000],
                                      median_wall_us=statistics.median(wall) / 1000))
        report.update(passed=True, samples=len(rows), summaries=summaries,
                      output_sha256={p.name: sha(p) for p in [prefix.with_suffix('.csv'),
                                                          HERE / ('HOST-' + name + '-checks.csv')]})
    except Exception as error:
        report.update(passed=False, error=repr(error))
        raise
    finally:
        report.update(elapsed_host_seconds=time.monotonic() - started, host_after=host_state(),
                      source_sha256={str(p.relative_to(HERE)): sha(p) for p in
                                     [HERE / 'benchmark.cpp', HERE / 'host_run.py', *sources[1:],
                                      *sorted((HERE / 'stock').glob('*.hpp')),
                                      *sorted((HERE / 'stock').glob('*.inc')),
                                      HERE / 'SOURCE-MANIFEST.json']})
        (HERE / ('HOST-' + name + '.json')).write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps({key: report[key] for key in ('passed', 'samples', 'elapsed_host_seconds')}, indent=2))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--name', default='pi01')
    parser.add_argument('--minimum-ms', type=float, default=40)
    parser.add_argument('--trials', type=int, default=5)
    args = parser.parse_args()
    run(args.name, args.minimum_ms, args.trials)
