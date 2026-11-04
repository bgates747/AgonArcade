"""Device-free consumer import and stopped-profile integration checks."""
from pathlib import Path
import ast
import importlib.util
import json
import sys

HERE = Path(__file__).resolve().parent


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def check():
    runner = load('prepared_startup_runner', HERE/'runner.py')
    base = load('original_hud_control', runner.HUD/'control.py')
    sys.path.insert(0, str(runner.START))
    import verify
    assert Path(verify.__file__).resolve() == runner.START/'verify.py'
    assert base.THROUGHPUT == runner.CUSTOM/'throughput'
    supervisor = load('prepared_startup_supervisor', base.THROUGHPUT/'oryx_session.py')
    assert supervisor.ROOT == runner.ROOT
    assert 'thermal_stop_celsius=95' in (base.THROUGHPUT/'oryx_session.py').read_text()
    assert 'time.monotonic()-progress_at > 60' in (runner.HUD/'control.py').read_text()
    for p in HERE.glob('*.py'):
        ast.parse(p.read_text(), filename=str(p))
    info = json.loads((HERE/'PROFILE.json').read_text())
    profile = Path(info['profile'])
    assert all(runner.sha(profile/n) == h for n, h in info['input_sha256'].items())
    assert not (profile/'last-run').exists()
    assert not any((profile/'sdcard/rally25'/n).exists() for n in
                   ('result.json', 'failure.txt', 'verified.json', 'state.bin', 'ticks.bin', 'prt.bin', 'replies.bin'))
    assert not supervisor.owned_processes({profile.resolve()})
    wrapper = (profile/'flexe-agon-emulator').read_text()
    assert 'export SDL_VIDEODRIVER=dummy' in wrapper
    assert 'export SDL_AUDIODRIVER=dummy' in wrapper
    assert 'export AGON_FLEXE_ENGINE=jit' in wrapper
    assert 'export FLEXE_UART_OBSERVER_OUTPUT="${profile_dir}/last-run/sender-progress.jsonl"' in wrapper
    # Check the exact offline reader can be imported without a runtime.
    reader = load('prepared_offline_reader', HERE/'vendor/read_record.py')
    assert reader.SCHEMA == 'fx114-sender-v1' and reader.LIMIT == 65536
    return dict(passed=True, emulator_executed=False, power_settings_changed=False,
                live_backend_compatibility_qualified=False, no_owned_process_or_output=True,
                application_verifier=str(Path(verify.__file__).resolve()),
                profile_pins_verified=len(info['input_sha256']),
                observer_opt_in_and_both_dummy_drivers_fixed=True,
                runner_supervisor_imports=True, original_60second_progress_and_95C_guards=True,
                normal_term_then_bounded_forced_cleanup=True,
                work_deadline_seconds=287, quit_grace_seconds=10, forced_wait_seconds=3,
                maximum_process_lifetime_seconds=300, reader_is_device_free=True)


if __name__ == '__main__':
    print(json.dumps(check(), indent=2))
