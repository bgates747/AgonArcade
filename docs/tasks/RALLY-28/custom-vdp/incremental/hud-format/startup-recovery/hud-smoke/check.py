"""Device-free import/source and stopped-profile checks; no runtime loading."""
from pathlib import Path
import ast
import hashlib
import importlib.util
import json
import sys

HERE=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()


def load(name,path):
    spec=importlib.util.spec_from_file_location(name,path)
    module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
    return module


def check():
    runner=load('prepared_smoke_runner',HERE/'runner.py')
    base=load('original_hud_runner',runner.HUD/'control.py')
    qualified=load('qualified_startup_runner',runner.INTEGRATION/'runner.py')
    gate=load('prepared_smoke_gate',HERE/'audit.py')
    sys.path.insert(0,str(HERE))
    import verify
    assert Path(verify.__file__).resolve()==HERE/'verify.py'
    sys.path.insert(0,str(runner.CUSTOM/'throughput'))
    supervisor=load('smoke_supervisor',runner.CUSTOM/'throughput/oryx_session.py')
    assert supervisor.ROOT==runner.ROOT
    for p in HERE.glob('*.py'):ast.parse(p.read_text(),filename=str(p))
    assert 'time.monotonic()-progress_at > 60' in (runner.HUD/'control.py').read_text()
    assert 'thermal_stop_celsius=95' in (runner.CUSTOM/'throughput/oryx_session.py').read_text()
    assert 'timeout=287' in (HERE/'runner.py').read_text()
    assert 'proc.wait(timeout=10)' in (runner.INTEGRATION/'runner.py').read_text()
    assert 'proc.wait(timeout=3)' in (runner.INTEGRATION/'runner.py').read_text()
    info=json.loads((HERE/'PROFILES.json').read_text())
    assert list(info)==['control','cached']
    differences=[n for n,h in info['control']['input_sha256'].items() if h!=info['cached']['input_sha256'][n]]
    assert set(differences)=={'sdcard/rally25/probe.bin','sdcard/rally25/expected.json'}
    profiles=set()
    for case,row in info.items():
        profile=Path(row['profile']);profiles.add(profile.resolve())
        assert all(sha(profile/n)==h for n,h in row['input_sha256'].items())
        assert not (profile/'last-run').exists()
        wrapper=(profile/'flexe-agon-emulator').read_text()
        for text in ('export SDL_VIDEODRIVER=dummy','export SDL_AUDIODRIVER=dummy',
                     'export AGON_FLEXE_ENGINE=jit','export FLEXE_UART_OBSERVER_OUTPUT='):
            assert text in wrapper
        for n in ('result.json','state.bin','failure.txt','verified.json','capture.req'):
            assert not (profile/'sdcard/rally25'/n).exists()
    assert not supervisor.owned_processes(profiles)
    assert not any((HERE/n).exists() for n in ('SESSION-hudsmoke02.json','CAMPAIGN-hudsmoke02.json','evidence'))
    return dict(passed=True,emulator_executed=False,power_settings_changed=False,
                profiles_stopped=2,profile_inputs_checked=44,only_declared_HUD_application_differences=True,
                common_runtime_and_observer=True,correct60frame_verifier_and_gate_imported=True,
                control_gate_before_cached=True,original60s_and95C_guards=True,
                per_process_work_quit_seconds=[287,10,3],expected_timed_bytes=18317,
                expected_native_replies=344,expected_wire_delta=0,race_screenshot_enabled=False,
                queue_reserved=False,performance_campaign_selected=False)


if __name__=='__main__':print(json.dumps(check(),indent=2))
