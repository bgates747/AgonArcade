"""Fresh silent Oryx affine runs and host commands under the original boost guard.

This does not contact Oryx: invoke it on that host. Frozen target fixtures and
Pi5 tools are read-only inputs. Every profile, session and output name is fresh.
"""
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
import socket
import subprocess
import sys
import tempfile
import time

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[4]
GUARD_PATH = HERE.parent / 'throughput/oryx_session.py'
RUNTIME_MANIFEST = HERE / 'ORYX-RUNTIME-BUILD.json'
RUNTIME = HERE / '.work/oryx-flexe-source/build'
PROFILE_PREFIX = 'rally28-hz60-affine-oryx-'
STOCK_SHA = 'b807beef35823b13a0a056f11b7464cd1b1c6356dce0e4098b78ebe059ded35f'
MOS_SHA = 'd564243283972690933a4554296ad6202ca4ef54572279533a942960846bebae'
MAP_SHA = 'd69e60bbce61a7b4b3eef318ba395f11c4e1a5b585755755113992dc94edcb86'


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def save_new(path, value):
    with Path(path).open('x') as handle:
        json.dump(value, handle, indent=2)
        handle.write('\n')


def oryx_only():
    assert socket.gethostname() == 'oryx-linuxlite', 'Run this controller on Oryx Linux Lite'
    assert platform.machine() == 'x86_64', 'The Oryx runtime must be x86_64'


def valid_name(name):
    assert re.fullmatch(r'[a-z0-9][a-z0-9-]*', name), 'Use lowercase letters, digits and hyphens'
    return name


def profile_path(name):
    valid_name(name)
    path = ROOT / '.emulator' / (PROFILE_PREFIX + name)
    assert path.parent.resolve() == (ROOT / '.emulator').resolve()
    return path


def state():
    thermal = {}
    for zone in Path('/sys/class/thermal').glob('thermal_zone*'):
        try:
            value = int((zone / 'temp').read_text()) / 1000
            if 0 <= value < 150:
                thermal[(zone / 'type').read_text().strip() + ':' + zone.name] = value
        except (OSError, ValueError):
            pass
    boost = Path('/sys/devices/system/cpu/cpufreq/boost')
    return dict(host=socket.gethostname(), architecture=platform.machine(),
                temperatures_celsius=thermal, load_average=list(os.getloadavg()),
                boost=boost.read_text().strip() if boost.exists() else None)


def guard_module():
    # Load the existing supervisor unchanged, including its original 95 C limit,
    # signal handling, owned-emulator stop and actual-original-boost restoration.
    sys.path.insert(0, str(GUARD_PATH.parent))
    spec = importlib.util.spec_from_file_location('affine_original_oryx_guard', GUARD_PATH)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    module.HERE, module.ROOT = HERE, ROOT
    return module


def launch_preflight(boost_disabled=False):
    """Inspect other emulators without signalling or modifying any of them."""
    guard = guard_module()
    other = []
    for entry in Path('/proc').glob('[0-9]*'):
        try:
            executable = (entry / 'exe').resolve(strict=True)
            if 'agon-emulator' in executable.name or 'agon-ez80-emulator' in executable.name:
                try:
                    cwd = str((entry / 'cwd').resolve(strict=True))
                except OSError:
                    cwd = 'unavailable'
                other.append(dict(pid=int(entry.name), executable=str(executable), cwd=cwd))
        except (OSError, ValueError):
            pass
    assert not other, ('An emulator is already running; no unowned process was stopped', other)
    temperatures = guard.temperatures()
    assert temperatures and max(temperatures.values()) < 95, ('Original 95 C prelaunch guard', temperatures)
    if boost_disabled:
        assert guard.BOOST.read_text().strip() == '0', 'Use the guarded session action'
    return dict(temperatures_celsius=temperatures, other_emulators=other)


def runtime_build():
    manifest = json.loads(RUNTIME_MANIFEST.read_text())
    assert manifest['passed'] is True and manifest['source_changes'] is False
    assert manifest['architecture'] == 'x86_64'
    assert manifest['frontend_commit'] == 'a35b17d7dddb83d127ef4bb75f33a5808d9d8515'
    assert manifest['core_commit'] == 'fbda8e905ccff36a090e4e33b0ffc2337dd79c52'
    for name in ('flexe-agon-emulator', 'flexe-vdp.so'):
        assert sha(RUNTIME / name) == manifest['files'][name], ('Runtime build mismatch', name)
    return manifest


def mos_paths(seed):
    seed = Path(seed)
    firmware = seed / 'firmware' if (seed / 'firmware/mos_platform.bin').is_file() else seed
    binary, mapping, commands = firmware / 'mos_platform.bin', firmware / 'mos_platform.map', seed / 'sdcard/bin'
    assert sha(binary) == MOS_SHA and sha(mapping) == MAP_SHA, 'Expected official MOS 3.0.2 and matching map'
    assert commands.is_dir(), 'MOS command directory is absent'
    return binary, mapping, commands


def stage(name, fixture, mos_seed=None, firmware=None):
    oryx_only(); valid_name(name)
    manifest = runtime_build()
    registry = json.loads((HERE / 'TARGET-FIXTURES.json').read_text())
    selected = registry[fixture]
    source = HERE / selected['directory']
    for filename, expected in selected['files'].items():
        assert Path(filename).name == filename
        assert sha(source / filename) == expected, ('Frozen fixture mismatch', filename)
    profile = profile_path(name)
    receipt = HERE / ('ORYX-PROFILE-' + name + '.json')
    guard_receipt = HERE / ('PROFILES-oryx-' + name + '.json')
    assert not profile.exists() and not receipt.exists() and not guard_receipt.exists(), 'Use a fresh profile name'
    if mos_seed is None:
        candidates = [ROOT / '.emulator/rally25-native-review01', ROOT.parent / 'golem/.emulator/runtime/fab-1.2.5']
        mos_seed = next((path for path in candidates if path.exists()), candidates[0])
    mos_binary, mos_map, commands = mos_paths(mos_seed)
    firmware = Path(firmware) if firmware else ROOT / 'docs/tasks/RALLY-28/standard-vdp/completion-probe/.work/stock-v2.16.0.bin'
    assert sha(firmware) == STOCK_SHA, 'Stock VDP 2.16.0 identity mismatch'
    helper = ROOT.parent / 'agon-dev-env/scripts/setup_emulator.py'
    spec = importlib.util.spec_from_file_location('affine_oryx_setup', helper)
    setup = importlib.util.module_from_spec(spec); spec.loader.exec_module(setup)
    setup.verify_latest_mos(mos_binary, mos_map)
    sd = profile / 'sdcard'; sd.mkdir(parents=True)
    setup.sync_shared_bin(commands, sd / 'bin')
    shutil.copyfile(mos_binary, profile / 'mos_platform.bin')
    shutil.copyfile(mos_map, profile / 'mos_platform.map')
    setup.write_mos_identity(profile)
    shutil.copyfile(RUNTIME / 'flexe-agon-emulator', profile / 'fab-agon-emulator.bin')
    (profile / 'fab-agon-emulator.bin').chmod(0o755)
    shutil.copyfile(RUNTIME / 'flexe-vdp.so', profile / 'flexe-vdp.so')
    shutil.copyfile(firmware, profile / 'esp32-firmware.bin')
    app = sd / 'test/arcade/rally28/affine'
    shutil.copytree(source, app)
    (sd / 'autoexec.txt').write_bytes(b'SET KEYBOARD 1\r\nCD /test/arcade/rally28/affine\r\nLOAD probe.bin\r\nRUN .\r\n')
    (profile / '.bespoke-vdp-profile').write_text('flexe-vdp.so\n')
    with tempfile.TemporaryDirectory() as temporary:
        setup.write_profile_launcher(Path(temporary), strict_bespoke=True)
        launcher = (Path(temporary) / 'fab-agon-emulator').read_text()
    extra = '''
export SDL_VIDEODRIVER=dummy
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
    subprocess.run(['bash', '-n', str(profile / 'flexe-agon-emulator')], check=True)
    files = ['flexe-agon-emulator', 'flexe-agon-emulator.bin', 'flexe-vdp.so',
             'mos_platform.bin', 'mos_platform.map', 'esp32-firmware.bin', 'sdcard/autoexec.txt']
    files += [str((app / filename).relative_to(profile)) for filename in selected['files']]
    pins = {filename: sha(profile / filename) for filename in files}
    assert pins['flexe-agon-emulator.bin'] == manifest['files']['flexe-agon-emulator']
    assert pins['flexe-vdp.so'] == manifest['files']['flexe-vdp.so']
    (profile / '.runtime.sha256').write_text(''.join(value + '  ' + key + '\n' for key, value in pins.items()))
    identity = dict(schema=1, name=name, fixture=fixture, profile=str(profile),
        app='sdcard/test/arcade/rally28/affine', files=pins, expected_batches=selected['planned_batches'],
        stopped=True, setup_helper_sha256=sha(helper), sound='dummy', video='dummy', platform=state(),
        runtime_build_manifest='ORYX-RUNTIME-BUILD.json', runtime_build_sha256=sha(RUNTIME_MANIFEST),
        controller_sha256=sha(Path(__file__)), original_guard_sha256=sha(GUARD_PATH),
        frozen_target_registry_sha256=sha(HERE / 'TARGET-FIXTURES.json'),
        source_fixture=str(source.relative_to(HERE)), fixture_files=selected['files'])
    save_new(profile / 'identity.json', identity)
    save_new(receipt, identity)
    save_new(guard_receipt, {name: dict(profile=str(profile), input_sha256=pins, stopped=True)})
    print('Prepared stopped Oryx profile:', profile, flush=True)
    return identity


def stop(proc, profile):
    if proc is None or proc.poll() is not None:
        return
    for child in Path('/proc').glob('[0-9]*'):
        try:
            if os.getpgid(int(child.name)) == proc.pid and (child / 'exe').resolve() == (profile / 'flexe-agon-emulator.bin').resolve():
                os.kill(int(child.name), signal.SIGTERM)
        except (OSError, ValueError):
            pass
    try:
        proc.wait(timeout=10)
    except subprocess.TimeoutExpired:
        os.killpg(proc.pid, signal.SIGKILL); proc.wait()


def run_one(name, timeout):
    oryx_only(); profile = profile_path(name)
    identity = json.loads((profile / 'identity.json').read_text())
    assert identity['profile'] == str(profile)
    assert identity['runtime_build_sha256'] == sha(RUNTIME_MANIFEST)
    runtime_build()
    assert all(sha(profile / key) == value for key, value in identity['files'].items())
    preflight = launch_preflight(boost_disabled=True)
    app, artifact = profile / identity['app'], profile / 'last-run'
    destination = HERE / 'evidence/oryx' / name
    receipt = HERE / ('ORYX-RUN-' + name + '.json')
    assert not artifact.exists() and not destination.exists() and not receipt.exists(), 'Preserve all previous attempts'
    assert not any((app / key).exists() for key in ('summary.json', 'timings.csv', 'done.txt', 'failure.txt'))
    artifact.mkdir()
    env = dict(os.environ, SDL_VIDEODRIVER='dummy', SDL_AUDIODRIVER='dummy')
    started = time.monotonic(); progress_at = started; previous = None; proc = None; caught = None
    report = dict(schema=1, name=name, fixture=identity['fixture'], identity=identity, host_before=state(),
                  forced_sdl=dict(video='dummy', audio='dummy'), preflight=preflight, samples=[], passed=False)
    try:
        with (artifact / 'frontend.log').open('w') as log:
            proc = subprocess.Popen(['./flexe-agon-emulator', '--renderer', 'sw'], cwd=profile,
                env=env, stdout=log, stderr=subprocess.STDOUT, start_new_session=True)
            while time.monotonic() - started < timeout:
                sample = state(); report['samples'].append(dict(elapsed=time.monotonic() - started, **sample))
                sizes = tuple((artifact / key).stat().st_size if (artifact / key).exists() else 0
                              for key in ('mos-to-vdp.bin', 'vdp-to-mos.bin'))
                if sizes != previous:
                    previous, progress_at = sizes, time.monotonic()
                elif time.monotonic() - progress_at > 120:
                    raise TimeoutError('No UART progress for 120 host seconds')
                if (app / 'done.txt').exists() and (app / 'done.txt').read_bytes().endswith(b'\n'):
                    time.sleep(1); report['reason'] = 'guest-files'; break
                if proc.poll() is not None:
                    raise RuntimeError('Emulator exited before guest results')
                if len(report['samples']) % 15 == 0:
                    print(name, round(time.monotonic() - started), 'host seconds; boost=0', flush=True)
                time.sleep(2)
            else:
                raise TimeoutError('Finite host bound exceeded')
        summary = json.loads((app / 'summary.json').read_text())
        assert summary['valid'] and summary['failure'] == 'none', summary
        assert summary['completed_batches'] == summary['planned_batches'] == identity['expected_batches']
        assert summary['callback_restored'] and summary['prt_restored'] and not summary['fallback_used']
        assert (app / 'done.txt').read_text().strip() == 'PASS'
        report.update(passed=True, summary=summary)
    except BaseException as error:
        caught = error; report['error'] = repr(error)
    finally:
        stop(proc, profile)
        report.update(elapsed_host_seconds=time.monotonic() - started,
            process_exit=proc.returncode if proc else None, exit=proc.returncode if proc else None,
            input_identities_unchanged=all(sha(profile / key) == value for key, value in identity['files'].items()),
            host_after=state())
        report['identities_unchanged'] = report['input_identities_unchanged']
        if (artifact / 'stats.json').exists():
            report['backend_stats'] = json.loads((artifact / 'stats.json').read_text())
        report['outputs'] = {key: sha(app / key) for key in ('summary.json', 'timings.csv', 'done.txt', 'failure.txt') if (app / key).exists()}
        stats = report.get('backend_stats')
        if not (report['process_exit'] == 0 and report['input_identities_unchanged'] and stats
                and not any(stats.get(key) for key in ('failed', 'unhandled', 'unregistered', 'unmapped'))):
            report['passed'] = False
            report.setdefault('error', 'Runtime exit, backend statistics or input identities failed')
        save_new(artifact / 'result.json', report)
        shutil.copytree(artifact, destination / 'runtime')
        for key in report['outputs']:
            shutil.copyfile(app / key, destination / key)
        shutil.copyfile(profile / 'identity.json', destination / 'identity.json')
        save_new(receipt, report)
    print(json.dumps({key: report.get(key) for key in ('passed', 'error', 'elapsed_host_seconds', 'outputs')}, indent=2), flush=True)
    if caught is not None:
        raise caught
    assert report['passed'], report.get('error')
    return report


def session(name, runs, timeout):
    oryx_only()
    assert name.isalnum(), 'The original guard requires an alphanumeric session name'
    assert runs and len(runs) == len(set(runs))
    for run in runs:
        valid_name(run)
        assert (HERE / ('PROFILES-oryx-' + run + '.json')).is_file()
    launch_preflight()
    guard = guard_module()
    guard.run_campaign = lambda campaign: run_one(campaign.removeprefix('oryx-'), timeout)
    guard.session(name, ['oryx-' + run for run in runs], [])


def stop_host(proc):
    if proc is None or proc.poll() is not None:
        return
    try:
        os.killpg(proc.pid, signal.SIGTERM)
    except ProcessLookupError:
        pass
    try:
        proc.wait(timeout=10)
    except subprocess.TimeoutExpired:
        os.killpg(proc.pid, signal.SIGKILL); proc.wait()


def host_command(name, argv):
    """Guard a finite build/host benchmark, stopping its group before boost restore."""
    oryx_only()
    assert name.isalnum() and argv, 'Supply a fresh alphanumeric session and a command after --'
    campaign = 'oryx-host-' + name
    campaign_receipt = HERE / ('PROFILES-' + campaign + '.json')
    receipt = HERE / ('ORYX-HOST-' + name + '.json')
    output = HERE / ('ORYX-HOST-' + name + '.txt')
    assert not receipt.exists() and not output.exists() and not (HERE / ('SESSION-' + name + '.json')).exists()
    launch_preflight()
    save_new(campaign_receipt, {})
    guard = guard_module()

    def execute(ignored):
        preflight = launch_preflight(boost_disabled=True)
        proc = None; started = time.monotonic()
        report = dict(schema=1, session=name, argv=argv, cwd=str(ROOT), host_before=state(),
            controller_sha256=sha(Path(__file__)), original_guard_sha256=sha(GUARD_PATH),
            forced_sdl=dict(video='dummy', audio='dummy'), preflight=preflight, passed=False)
        try:
            with output.open('x') as log:
                proc = subprocess.Popen(argv, cwd=ROOT, stdout=log, stderr=subprocess.STDOUT,
                    env=dict(os.environ, SDL_VIDEODRIVER='dummy', SDL_AUDIODRIVER='dummy'), start_new_session=True)
                while proc.poll() is None:
                    time.sleep(.2)
            assert proc.returncode == 0, 'Host command failed: ' + str(proc.returncode)
            report['passed'] = True
        except BaseException as error:
            report['error'] = repr(error)
            raise
        finally:
            stop_host(proc)
            report.update(exit=proc.returncode if proc else None, host_after=state(),
                elapsed_host_seconds=time.monotonic() - started, output_sha256=sha(output) if output.exists() else None)
            save_new(receipt, report)

    guard.run_campaign = execute
    guard.session(name, [campaign], [])


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    actions = parser.add_subparsers(dest='action', required=True)
    prepare = actions.add_parser('stage')
    prepare.add_argument('name'); prepare.add_argument('--fixture', choices=('smoke', 'smoke-poll', 'full'), default='smoke')
    prepare.add_argument('--mos-seed', type=Path); prepare.add_argument('--firmware', type=Path)
    run = actions.add_parser('session')
    run.add_argument('name'); run.add_argument('runs', nargs='+'); run.add_argument('--timeout', type=float, default=900)
    host = actions.add_parser('host')
    host.add_argument('name'); host.add_argument('command', nargs=argparse.REMAINDER)
    args = parser.parse_args()
    if args.action == 'stage':
        stage(args.name, args.fixture, args.mos_seed, args.firmware)
    elif args.action == 'session':
        assert args.timeout > 0
        session(args.name, args.runs, args.timeout)
    else:
        command = args.command[1:] if args.command[:1] == ['--'] else args.command
        host_command(args.name, command)
