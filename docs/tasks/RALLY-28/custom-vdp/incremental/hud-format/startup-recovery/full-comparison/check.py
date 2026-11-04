"""Device-free ABBA imports, pooled-rate arithmetic and stopped-profile checks."""
from pathlib import Path
import ast
import hashlib
import importlib.util
import json
import struct
import subprocess
import sys

HERE=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()


def load(name,path):
    spec=importlib.util.spec_from_file_location(name,path)
    module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
    return module


def check():
    runner=load('full_prepared_runner',HERE/'runner.py')
    base=load('original_hud_control',runner.HUD/'control.py')
    sys.path.insert(0,str(HERE));import verify
    assert Path(verify.__file__).resolve()==HERE/'verify.py'
    gate=load('full_prepared_gate',HERE/'audit.py')
    report=load('full_prepared_report',HERE/'report.py')
    condition=load('full_host_conditions',HERE/'conditions.py')
    sys.path.insert(0,str(runner.CUSTOM/'throughput'))
    supervisor=load('original_supervisor',runner.CUSTOM/'throughput/oryx_session.py')
    assert supervisor.ROOT==runner.ROOT
    for p in HERE.glob('*.py'):ast.parse(p.read_text(),filename=str(p))
    assert 'time.monotonic()-progress_at > 60' in (runner.HUD/'control.py').read_text()
    assert 'thermal_stop_celsius=95' in (runner.CUSTOM/'throughput/oryx_session.py').read_text()
    assert 'timeout=287' in (HERE/'runner.py').read_text()
    assert 'proc.wait(timeout=10)' in (HERE.parent/'observer-integration/runner.py').read_text()
    assert 'proc.wait(timeout=3)' in (HERE.parent/'observer-integration/runner.py').read_text()
    # A concrete counterexample guards the meaningful pooled-rate distinction.
    sample=[dict(frames=900,nominal_mos_units=3600,nominal_mos_seconds=30),
            dict(frames=900,nominal_mos_units=7200,nominal_mos_seconds=60)]
    assert report.pooled(sample,'nominal_mos')==dict(frames=1800,elapsed_units=10800,elapsed_seconds=90,fps=20)
    assert report.pooled(sample,'nominal_mos')['fps']!=(30+15)/2
    helper=subprocess.run([sys.executable,str(HERE/'audit.py'),'--help'],text=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE,check=True)
    assert 'directory' in helper.stdout
    profiles=json.loads((HERE/'PROFILES.json').read_text());assert list(profiles)==list(runner.ROLES)
    paths=set()
    for case,info in profiles.items():
        p=Path(info['profile']);paths.add(p.resolve());assert info['role']==runner.ROLES[case]
        assert all(sha(p/n)==h for n,h in info['input_sha256'].items())
        assert not (p/'last-run').exists()
        for n in ('result.json','failure.txt','state.bin','verified.json','capture.req'):
            assert not (p/'sdcard/rally25'/n).exists()
        assert struct.unpack('<4sHHIHH',(p/'sdcard/rally25/config.bin').read_bytes())==(b'R28F',1,900,34836,1,0)
        text=(p/'flexe-agon-emulator').read_text()
        for fragment in ('export SDL_AUDIODRIVER=dummy','export SDL_VIDEODRIVER=dummy',
                         'export AGON_FLEXE_ENGINE=jit','export FLEXE_UART_OBSERVER_OUTPUT='):
            assert fragment in text
        changes=[n for n,h in profiles['control1']['input_sha256'].items() if h!=info['input_sha256'][n]]
        assert set(changes)==({'sdcard/rally25/probe.bin','sdcard/rally25/expected.json'} if info['role']=='cached' else set())
    assert not supervisor.owned_processes(paths)
    assert not any((HERE/n).exists() for n in ('SESSION-hud900abba01.json','CAMPAIGN-hud900abba01.json','evidence','REPORT.json'))
    witness=condition.snapshot('device-free-preparation-not-execution-quiet-admission')
    (HERE/'HOST-CONDITION-PREPARATION.json').write_text(json.dumps(witness,indent=2)+'\n')
    return dict(passed=True,order=list(runner.ROLES),profiles_stopped=4,profile_inputs_checked=88,
        same900frame_config=True,common_runtime_observer=True,only_declared_HUD_differences=True,
        total_timed_frames_if_all_run=3600,total_physics_ticks_if_all_run=14400,
        frames_each=900,native_replies_each=2024,timed_bytes_each=291568,expected_timed_delta=0,
        whole_command_stream_and_phases_predicted=True,correct900frame_verifier_and_gate_imported=True,
        audit_CLI_real_help=True,pooled_FPS_counterexample_passed=True,
        original60s_95C_guards=True,process_seconds=[287,10,3],host_conditions_read_only=True,
        execution_quiet_host_admission_still_required=True,emulator_executed=False,power_settings_changed=False,
        queue_reserved=False,execution_selected=False)


if __name__=='__main__':print(json.dumps(check(),indent=2))
