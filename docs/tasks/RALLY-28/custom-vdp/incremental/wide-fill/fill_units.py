"""Qualify the actual wide fill with strict aliasing and ASan/UBSan on the host.

The immutable accepted helper supplies the baseline and unchanged clip function.
The C harness independently predicts every byte; no emulator or timing claim.
"""
from pathlib import Path
import hashlib
import json
import os
import subprocess

HERE = Path(__file__).resolve().parent
BASELINE = HERE.parent / 'sprites/.work/candidate-clipfix/package/helper/render_core.inc'
BASELINE_SHA256 = '0e1c47f3776b1a01ed123d7eb82214cbea1d5b435f2eb98d7cc85c59d83d4ad8'
WORK = HERE / '.work/fill-units'


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def main():
    assert sha(BASELINE) == BASELINE_SHA256, 'accepted baseline changed'
    raw = BASELINE.read_text()
    start = raw.index('static int r28_span_clip(')
    end = raw.index('static void r28_span_edges(', start)
    extracted = raw[start:end]
    assert extracted.count('static void r28_span_fill(') == 1
    assert 'if (left < right) memset(row + left, colour, (unsigned)(right - left));' in extracted
    WORK.mkdir(parents=True, exist_ok=True)
    (WORK / 'baseline_fill.inc').write_text(extracted)
    compiler = subprocess.check_output(['cc', '--version'], text=True).splitlines()[0]
    common = ['cc', '-std=c11', '-fstrict-aliasing', '-Wstrict-aliasing=2',
              '-fno-builtin', '-Wall', '-Wextra', '-Werror',
              '-I' + str(HERE), '-I' + str(WORK)]
    sources = {p.name: sha(p) for p in (HERE / 'wide_fill.inc', HERE / 'fill_units.c', Path(__file__).resolve())}
    results = {}
    for mode, extra in (
        ('ordinary', ['-O3']),
        ('sanitized', ['-O2', '-fsanitize=address,undefined', '-fno-omit-frame-pointer']),
    ):
        binary = WORK / ('fill-units-' + mode)
        command = [*common, *extra, str(HERE / 'fill_units.c'), '-o', str(binary)]
        subprocess.run(command, check=True)
        env = os.environ.copy()
        # The tool runner uses ptrace; LeakSanitizer cannot inspect its threads.
        # ASan address checks and UBSan remain active. The fill allocates nothing.
        env['ASAN_OPTIONS'] = 'detect_leaks=0:halt_on_error=1'
        env['UBSAN_OPTIONS'] = 'halt_on_error=1:print_stacktrace=1'
        completed = subprocess.run([str(binary)], env=env, text=True, capture_output=True)
        (WORK / (mode + '.stdout.json')).write_text(completed.stdout)
        (WORK / (mode + '.stderr.txt')).write_text(completed.stderr)
        completed.check_returncode()
        result = json.loads(completed.stdout)
        result.update(compiler=compiler, compile_command=command, binary_sha256=sha(binary),
                      sources=sources, baseline_core_sha256=BASELINE_SHA256,
                      extracted_baseline_sha256=sha(WORK / 'baseline_fill.inc'),
                      sanitizer_environment={name: env[name] for name in ('ASAN_OPTIONS', 'UBSAN_OPTIONS')})
        (HERE / ('fill_units_' + mode + '.json')).write_text(json.dumps(result, indent=2) + '\n')
        results[mode] = result
        print(json.dumps(dict(mode=mode, passed=result['passed'],
                              total_guarded_cases=result['total_guarded_cases'])), flush=True)
    keys = ('exhaustive_endpoint_cases', 'all_colour_boundary_cases', 'clipped_endpoint_cases',
            'total_guarded_cases', 'expected_word_stores', 'bytes_compared_per_implementation')
    assert all(results['ordinary'][key] == results['sanitized'][key] for key in keys)
    assert sha(BASELINE) == BASELINE_SHA256, 'baseline changed during qualification'
    assert all(sha(HERE / name) == digest for name, digest in sources.items()), 'test source changed during qualification'


if __name__ == '__main__':
    main()
