"""Finite Oryx test session with explicitly authorized temporary boost disable."""
import argparse
import json
import os
from pathlib import Path
import signal
import socket
import subprocess
import threading
import time
from fixtures import HERE, ROOT
from run import run_campaign
from phase_run import run as run_phase

BOOST = Path('/sys/devices/system/cpu/cpufreq/boost')


class SessionAbort(RuntimeError):
    pass


def set_boost(value):
    assert value in ('0', '1')
    subprocess.run(['sudo', '-n', 'tee', str(BOOST)], input=value + '\n',
                   text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)
    assert BOOST.read_text().strip() == value


def owned_processes(profiles):
    found = []
    for process in Path('/proc').glob('[0-9]*'):
        try:
            cwd = (process / 'cwd').resolve()
            exe = (process / 'exe').resolve()
        except OSError:
            continue
        if cwd in profiles and 'agon-emulator' in exe.name:
            found.append(int(process.name))
    return found


def stop_owned(profiles):
    pids = owned_processes(profiles)
    for pid in pids:
        try:
            os.kill(pid, signal.SIGTERM)
        except ProcessLookupError:
            pass
    deadline = time.monotonic() + 10
    while owned_processes(profiles) and time.monotonic() < deadline:
        time.sleep(.1)
    for pid in owned_processes(profiles):
        try:
            os.kill(pid, signal.SIGKILL)
        except ProcessLookupError:
            pass
    deadline = time.monotonic() + 3
    while owned_processes(profiles) and time.monotonic() < deadline:
        time.sleep(.1)
    assert not owned_processes(profiles), 'Owned emulator must stop before restoring boost'
    return pids


def temperatures():
    result = {}
    for zone in Path('/sys/class/thermal').glob('thermal_zone*'):
        try:
            value = int((zone / 'temp').read_text()) / 1000
            if 0 <= value < 150:
                result[(zone / 'type').read_text().strip() + ':' + zone.name] = value
        except (OSError, ValueError):
            pass
    return result


def session(name, campaigns, phases):
    assert socket.gethostname() == 'oryx-linuxlite', 'This supervisor is Oryx-only'
    assert name.isalnum()
    target = HERE / ('SESSION-' + name + '.json')
    assert not target.exists(), 'Use a fresh session name; preserve all earlier outcomes'
    profiles = set()
    for campaign in campaigns:
        entries = json.loads((HERE / ('PROFILES-' + campaign + '.json')).read_text())
        profiles.update(Path(item['profile']).resolve() for item in entries.values())
    phase_paths = [(ROOT / item).resolve() for item in phases]
    profiles.update(phase_paths)
    assert all(p.parent == ROOT / '.emulator' and p.name.startswith('rally28-hz60-') for p in profiles)
    assert not owned_processes(profiles), 'An owned profile is already running'
    original = BOOST.read_text().strip()
    assert original in ('0', '1')
    state = dict(session=name, author_approved_temporary_boost_disable=True,
                 original_boost=original, campaigns=campaigns, phases=phases,
                 host_boot_id=Path('/proc/sys/kernel/random/boot_id').read_text().strip(),
                 video_driver='dummy', audio_driver='dummy', samples=[], completed=[],
                 thermal_stop_celsius=95, error=None, boost_restored=False)
    target.write_text(json.dumps(state, indent=2) + '\n')
    started = time.monotonic()
    stopped = threading.Event()
    monitor = None
    changed = False

    def abort(signum, frame):
        raise SessionAbort('Session interrupted by signal ' + str(signum))

    old_handlers = {sig: signal.signal(sig, abort)
                    for sig in (signal.SIGINT, signal.SIGTERM, signal.SIGHUP, signal.SIGUSR1)}

    def watch():
        next_report = 0
        while not stopped.is_set():
            elapsed = time.monotonic() - started
            current = BOOST.read_text().strip()
            thermal = temperatures()
            state['samples'].append(dict(elapsed_seconds=round(elapsed, 3), boost=current,
                                         temperatures_celsius=thermal,
                                         load_average=list(os.getloadavg())))
            if current != '0' or (thermal and max(thermal.values()) >= 95):
                state['monitor_abort_reason'] = 'Boost changed or thermal stop reached'
                os.kill(os.getpid(), signal.SIGUSR1)
                return
            if elapsed >= next_report:
                print('Session', name, round(elapsed), 'seconds; boost=0; max temperature',
                      max(thermal.values()) if thermal else 'unavailable', flush=True)
                next_report = elapsed + 30
            stopped.wait(2)

    try:
        changed = True
        set_boost('0')
        state['boost_during_session'] = '0'
        target.write_text(json.dumps(state, indent=2) + '\n')
        monitor = threading.Thread(target=watch, daemon=True)
        monitor.start()
        for campaign in campaigns:
            run_campaign(campaign)
            state['completed'].append('campaign:' + campaign)
        for profile in phase_paths:
            run_phase(profile, 180)
            state['completed'].append('phase:' + profile.name)
    except BaseException as exc:
        state['error'] = repr(exc)
        raise
    finally:
        stopped.set()
        if monitor:
            monitor.join(timeout=3)
        try:
            state['cleanup_stopped_pids'] = stop_owned(profiles)
            if changed:
                set_boost(original)
            state['final_boost'] = BOOST.read_text().strip()
            state['boost_restored'] = state['final_boost'] == original
            state['owned_emulator_processes_after'] = owned_processes(profiles)
        finally:
            state['elapsed_host_seconds'] = round(time.monotonic() - started, 3)
            state['max_temperature_celsius'] = max((v for s in state['samples']
                for v in s['temperatures_celsius'].values()), default=None)
            target.write_text(json.dumps(state, indent=2) + '\n')
            for sig, handler in old_handlers.items():
                signal.signal(sig, handler)
            print('Session saved:', target.name, 'boost restored:', state['boost_restored'], flush=True)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--session', required=True)
    parser.add_argument('--campaigns', nargs='*', default=[])
    parser.add_argument('--phases', nargs='*', default=[])
    args = parser.parse_args()
    assert args.campaigns or args.phases
    session(args.session, args.campaigns, args.phases)
