"""Fresh project-local Pi5 Flexe profiles and silent finite affine runs."""
from pathlib import Path
import argparse
import hashlib
import importlib.util
import json
import os
import platform
import re
import shutil
import signal
import subprocess
import tempfile
import time

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[4]
STOCK_SHA = 'b807beef35823b13a0a056f11b7464cd1b1c6356dce0e4098b78ebe059ded35f'


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def state():
    p = Path('/sys/class/thermal/thermal_zone0/temp')
    f = Path('/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq')
    return dict(host=platform.node(), architecture=platform.machine(),
                temperature_celsius=int(p.read_text()) / 1000 if p.exists() else None,
                cpu_frequency_khz=int(f.read_text()) if f.exists() else None,
                load_average=os.getloadavg())


def stage(name, fixture):
    assert re.fullmatch(r'[a-z0-9-]+', name)
    assert platform.machine() == 'aarch64', 'This tranche is Pi5-only'
    registry = json.loads((HERE / 'TARGET-FIXTURES.json').read_text())
    selected = registry[fixture]
    source = HERE / selected['directory']
    for filename, expected in selected['files'].items():
        assert sha(source / filename) == expected
    profile = ROOT / '.emulator' / ('rally28-affine-pi-' + name)
    assert not profile.exists(), 'Use a fresh profile; preserve old evidence'
    helper = ROOT.parent / 'agon-dev-env/scripts/setup_emulator.py'
    spec = importlib.util.spec_from_file_location('affine_setup', helper)
    setup = importlib.util.module_from_spec(spec); spec.loader.exec_module(setup)
    runtime = HERE / '.work/flexe-source/build'
    firmware = ROOT / 'docs/tasks/RALLY-28/standard-vdp/completion-probe/.work/stock-v2.16.0.bin'
    mos = ROOT.parent / 'golem/.emulator/runtime/fab-1.2.5'
    assert sha(firmware) == STOCK_SHA
    setup.verify_latest_mos(mos / 'firmware/mos_platform.bin', mos / 'firmware/mos_platform.map')
    sd = profile / 'sdcard'; sd.mkdir(parents=True)
    setup.sync_shared_bin(mos / 'sdcard/bin', sd / 'bin')
    for filename in ('mos_platform.bin', 'mos_platform.map'):
        shutil.copyfile(mos / 'firmware' / filename, profile / filename)
    setup.write_mos_identity(profile)
    shutil.copyfile(runtime / 'flexe-agon-emulator', profile / 'fab-agon-emulator.bin')
    (profile / 'fab-agon-emulator.bin').chmod(0o755)
    shutil.copyfile(runtime / 'flexe-vdp.so', profile / 'flexe-vdp.so')
    shutil.copyfile(firmware, profile / 'esp32-firmware.bin')
    app = sd / 'test/arcade/rally28/affine'
    shutil.copytree(source, app)
    (sd / 'autoexec.txt').write_bytes(b'SET KEYBOARD 1\r\nCD /test/arcade/rally28/affine\r\nLOAD probe.bin\r\nRUN .\r\n')
    (profile / '.bespoke-vdp-profile').write_text('flexe-vdp.so\n')
    with tempfile.TemporaryDirectory() as temporary:
        setup.write_profile_launcher(Path(temporary), strict_bespoke=True)
        launcher = (Path(temporary) / 'fab-agon-emulator').read_text()
    extra = '''
export SDL_AUDIODRIVER=dummy
export AGON_FLEXE_FIRMWARE="$profile_dir/esp32-firmware.bin"
unset AGON_FLEXE_ELF
export AGON_FLEXE_ENGINE=jit
export AGON_FLEXE_ARTIFACTS="$profile_dir/last-run"
mkdir -p "$AGON_FLEXE_ARTIFACTS"
'''
    assert launcher.count('\nvdp_name=') == 1
    launcher = launcher.replace('\nvdp_name=', extra + '\nvdp_name=', 1)
    (profile / 'fab-agon-emulator').write_text(launcher)
    (profile / 'fab-agon-emulator').chmod(0o755)
    setup.name_flexe_profile(profile)
    files = ['flexe-agon-emulator', 'flexe-agon-emulator.bin', 'flexe-vdp.so',
             'mos_platform.bin', 'mos_platform.map', 'esp32-firmware.bin', 'sdcard/autoexec.txt']
    files += [str((app / filename).relative_to(profile)) for filename in selected['files']]
    pins = {filename: sha(profile / filename) for filename in files}
    (profile / '.runtime.sha256').write_text(''.join(value + '  ' + key + '\n' for key, value in pins.items()))
    identity = dict(schema=1, name=name, fixture=fixture, profile=str(profile),
                    app='sdcard/test/arcade/rally28/affine', files=pins,
                    expected_batches=selected['planned_batches'], stopped=True,
                    setup_helper_sha256=sha(helper), sound='dummy', platform=state(),
                    runtime_build_sha256=sha(HERE / 'PI-RUNTIME-BUILD.json'))
    (profile / 'identity.json').write_text(json.dumps(identity, indent=2) + '\n')
    (HERE / ('TARGET-PROFILE-' + name + '.json')).write_text(json.dumps(identity, indent=2) + '\n')
    print('Prepared stopped:', profile)


def stop(proc, profile):
    if proc.poll() is not None:
        return
    for child in Path('/proc').glob('[0-9]*'):
        try:
            pid = int(child.name)
            if os.getpgid(pid) == proc.pid and (child / 'exe').resolve() == (profile / 'flexe-agon-emulator.bin').resolve():
                os.kill(pid, signal.SIGTERM)
        except (OSError, ValueError):
            pass
    try:
        proc.wait(timeout=10)
    except subprocess.TimeoutExpired:
        os.killpg(proc.pid, signal.SIGKILL); proc.wait()


def run(name, timeout):
    profile = ROOT / '.emulator' / ('rally28-affine-pi-' + name)
    identity = json.loads((profile / 'identity.json').read_text())
    assert all(sha(profile / key) == value for key, value in identity['files'].items())
    app, artifact = profile / identity['app'], profile / 'last-run'
    assert not artifact.exists() and not (app / 'summary.json').exists(), 'Preserve earlier runs'
    artifact.mkdir()
    env = dict(os.environ, SDL_VIDEODRIVER='dummy', SDL_AUDIODRIVER='dummy')
    started = time.monotonic(); progress_at = started; previous = None; proc = None
    report = dict(schema=1, name=name, fixture=identity['fixture'], identity=identity, host_before=state(),
                  forced_sdl=dict(video='dummy', audio='dummy'), samples=[], passed=False)
    try:
        with (artifact / 'frontend.log').open('w') as log:
            proc = subprocess.Popen(['./flexe-agon-emulator', '--renderer', 'sw'], cwd=profile,
                                    env=env, stdout=log, stderr=subprocess.STDOUT, start_new_session=True)
            while time.monotonic() - started < timeout:
                sample = state(); report['samples'].append(dict(elapsed=time.monotonic() - started, **sample))
                if sample['temperature_celsius'] is not None and sample['temperature_celsius'] >= 95:
                    raise RuntimeError('Original95C guard tripped')
                sizes = tuple((artifact / key).stat().st_size if (artifact / key).exists() else 0
                              for key in ('mos-to-vdp.bin', 'vdp-to-mos.bin'))
                if sizes != previous:
                    previous, progress_at = sizes, time.monotonic()
                elif time.monotonic() - progress_at > 120:
                    raise TimeoutError('No UART progress for120host seconds')
                if (app / 'done.txt').exists() and (app / 'done.txt').read_bytes().endswith(b'\n'):
                    time.sleep(1)
                    report['reason'] = 'guest-files'; break
                if proc.poll() is not None:
                    raise RuntimeError('Emulator exited before guest results')
                if len(report['samples']) % 15 == 0:
                    print(name, round(time.monotonic() - started), 'host seconds;', sample['temperature_celsius'], 'C', flush=True)
                time.sleep(2)
            else:
                raise TimeoutError('Finite host bound exceeded')
        summary = json.loads((app / 'summary.json').read_text())
        assert summary['valid'] and summary['failure'] == 'none', summary
        assert summary['completed_batches'] == summary['planned_batches'] == identity['expected_batches']
        assert summary['callback_restored'] and summary['prt_restored'] and not summary['fallback_used']
        assert (app / 'done.txt').read_text().strip() == 'PASS'
        report.update(passed=True, summary=summary)
    except Exception as error:
        report['error'] = repr(error)
    finally:
        if proc is not None:
            stop(proc, profile)
        report.update(elapsed_host_seconds=time.monotonic() - started,
                      process_exit=proc.returncode if proc else None,
                      exit=proc.returncode if proc else None,
                      input_identities_unchanged=all(sha(profile / key) == value for key, value in identity['files'].items()),
                      host_after=state())
        report['identities_unchanged'] = report['input_identities_unchanged']
        if (artifact / 'stats.json').exists():
            report['backend_stats'] = json.loads((artifact / 'stats.json').read_text())
        report['outputs'] = {key: sha(app / key) for key in ('summary.json', 'timings.csv', 'done.txt', 'failure.txt') if (app / key).exists()}
        (artifact / 'result.json').write_text(json.dumps(report, indent=2) + '\n')
        destination = HERE / 'evidence' / name
        assert not destination.exists()
        shutil.copytree(artifact, destination / 'runtime')
        for key in report['outputs']:
            shutil.copyfile(app / key, destination / key)
        shutil.copyfile(profile / 'identity.json', destination / 'identity.json')
        (HERE / ('TARGET-RUN-' + name + '.json')).write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps({key: report.get(key) for key in ('passed', 'error', 'elapsed_host_seconds', 'outputs')}, indent=2))
    assert report['passed'], report.get('error')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest='action', required=True)
    prepare = sub.add_parser('stage'); prepare.add_argument('name'); prepare.add_argument('--fixture', default='smoke')
    execute = sub.add_parser('run'); execute.add_argument('name'); execute.add_argument('--timeout', type=float, default=900)
    args = parser.parse_args()
    if args.action == 'stage': stage(args.name, args.fixture)
    else: run(args.name, args.timeout)
