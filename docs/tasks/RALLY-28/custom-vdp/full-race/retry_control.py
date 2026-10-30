"""Bounded fresh-profile retries, retaining every failed attempt and raw return.

The original stage/run/stop functions and95C supervisor remain authoritative.
Only exact input-identical, fresh profiles may retry a failed case. Guard aborts
and process interrupts propagate immediately; they never start another attempt.
"""
from pathlib import Path
import argparse
import json
import shutil
import struct
import threading

import control
import oryx_session

HERE = Path(__file__).resolve().parent
MAX_ATTEMPTS = 3
_dynamic_profiles = set()
_profiles_lock = threading.Lock()


def save(name, value):
    (HERE / name).write_text(json.dumps(value, indent=2) + '\n')


def validate_profile(profile):
    path = Path(profile).resolve()
    emulator_root = (oryx_session.ROOT / '.emulator').resolve()
    assert path.parent == emulator_root and path.name.startswith('rally28-hz60-'), path
    return path


def register_profile(profile):
    path = validate_profile(profile)
    with _profiles_lock:
        _dynamic_profiles.add(path)
    return path


def copy_returns(profile, destination):
    artifact = profile / 'last-run'
    if artifact.exists():
        for path in artifact.iterdir():
            if path.is_file():
                name = path.with_suffix('.txt').name if path.suffix == '.log' else path.name
                shutil.copyfile(path, destination / name)
    app = profile / 'sdcard/rally25'
    for name in ('result.json', 'state.bin', 'ticks.bin', 'prt.bin', 'replies.bin',
                 'stages.csv', 'player.csv', 'failure.txt', 'verified.json',
                 'coverage.json', 'capture.ready'):
        if (app / name).exists():
            shutil.copyfile(app / name, destination / name)


def native_prefix(data):
    """Decode complete multiplexed packets, including strict native sequencing."""
    position, packets, total = 0, [], 0
    while position < len(data):
        assert position + 2 <= len(data), 'Incomplete multiplexed RX header'
        channel, size = data[position:position + 2]
        assert channel >= 128, ('Invalid multiplexed RX channel', position, channel)
        stop = position + 2 + size
        assert stop <= len(data), 'Incomplete multiplexed RX payload'
        payload = data[position + 2:stop]
        if payload.startswith(b'VDPL'):
            assert channel == 0x81 and size == 10, 'Invalid native packet envelope'
            magic, version, kind, token, value = struct.unpack('<4sBBHH', payload)
            assert version == 1, 'Invalid native packet version'
            packets.append(dict(kind=kind, token=token, value=value))
        position = stop
        total += 1
    return packets, total


def classify_startup_timeout(error, evidence):
    """Only a proven pre-INFO18 transport timeout can consume another attempt."""
    result = dict(retry_allowed=False, exception_type=type(error).__name__,
                  initial_stack_info_token=18, main_window_started=False)
    try:
        assert isinstance(error, TimeoutError), 'Not a transport timeout'
        assert not (evidence / 'failure.txt').exists(), 'Guest failure is present'
        assert not (evidence / 'result.json').exists(), 'Guest completed main execution'
        receipt = json.loads((evidence / 'run.json').read_text())
        stats = receipt['backend_stats']
        assert receipt['process_exit'] == 0 and isinstance(stats, dict), 'Backend did not stop cleanly'
        assert not any(stats.get(key) for key in ('failed', 'unhandled', 'unregistered', 'unmapped')), 'Backend fault'
        tx = (evidence / 'mos-to-vdp.bin').read_bytes()
        rx = (evidence / 'vdp-to-mos.bin').read_bytes()
        delivered = (evidence / 'vdp-to-mos-delivered.bin').read_bytes()
        assert rx == delivered, 'RX/delivered stream disagreement'
        assert (stats['uart_rx'], stats['uart_tx'], stats['uart_delivered']) == (len(tx), len(rx), len(delivered)), 'UART accounting mismatch'
        packets, multiplexed = native_prefix(rx)
        result.update(native_packets=packets, multiplexed_packets=multiplexed,
                      outbound_bytes=len(tx), inbound_bytes=len(rx),
                      raw_rx_sha256=control.sha(evidence / 'vdp-to-mos.bin'))
        # These are every legitimate callback before the initial timed INFO17.
        # Validating the prefix also rejects a state/protocol error masquerading
        # as an earlier transport interruption.
        expected = [(2, None), (3, 0), (4, 3246800 & 65535), (4, 3246800 >> 16), (4, 6800),
                    (3, 0), (4, 1), (4, 1), (4, 0), (4, 2), (4, 2),
                    (3, 0), (4, 1), (4, 2), (4, 0), (4, 3), (4, 3)]
        for index, packet in enumerate(packets):
            assert packet['kind'] != 5, 'Native error callback'
            if packet['token'] >= 18:
                result['main_window_started'] = True
                raise AssertionError('Initial timed-window INFO token18 or later was reached')
            assert packet['token'] == index + 1, 'Non-monotonic native callback token'
            kind, value = expected[index]
            assert packet['kind'] == kind, 'Unexpected startup callback kind'
            assert packet['value'] > 0 if value is None else packet['value'] == value, 'Unexpected startup callback value'
        result.update(retry_allowed=True,
            reason='Transport TimeoutError with no guest/backend/protocol failure; complete multiplexed native RX is a valid prefix strictly before INFO token18')
    except (AssertionError, KeyError, OSError, ValueError, IndexError) as rejected:
        result['reason'] = str(rejected) or repr(rejected)
    return result


def run_campaign(master):
    assert master.isalnum()
    profiles_path = HERE / ('PROFILES-' + master + '.json')
    original_profiles = json.loads(profiles_path.read_text())
    profiles = dict(original_profiles)
    registry = json.loads((HERE / 'FIXTURES.json').read_text())
    order = list(original_profiles)
    assert len(order) == 17 and set(order) == set(registry), 'Stage the complete ordered renderer matrix'
    campaign_path = HERE / ('CAMPAIGN-' + master + '.json')
    attempts_path = HERE / ('ATTEMPTS-' + master + '.json')
    initial_path = HERE / ('PROFILES-' + master + '-INITIAL.json')
    assert not campaign_path.exists() and not attempts_path.exists() and not initial_path.exists(), 'Use a fresh master campaign'
    initial_path.write_bytes(profiles_path.read_bytes())
    attempts = dict(schema=1, campaign=master, max_attempts_per_case=MAX_ATTEMPTS,
                    ordered_cases=order, initial_profiles_receipt=initial_path.name,
                    initial_profiles_sha256=control.sha(initial_path), attempts={}, selected={})
    summary, retry_sequence = {}, 0
    for case_index, case in enumerate(order, 1):
        attempts['attempts'][case] = []
        for number in range(1, MAX_ATTEMPTS + 1):
            assert oryx_session.BOOST.read_text().strip() == '0'
            profile_campaign = master
            if number == 1:
                info = original_profiles[case]
            else:
                retry_sequence += 1
                profile_campaign = master + 'r' + str(retry_sequence)
                assert not (HERE / ('PROFILES-' + profile_campaign + '.json')).exists(), 'Fresh retry campaign required'
                control.stage(profile_campaign, [case])
                retry_profiles = json.loads((HERE / ('PROFILES-' + profile_campaign + '.json')).read_text())
                assert list(retry_profiles) == [case]
                info = retry_profiles[case]
            profile = register_profile(info['profile'])
            assert not (profile / 'last-run').exists(), 'Never reuse a failed or completed profile'
            assert all(control.sha(profile / name) == wanted for name, wanted in info['input_sha256'].items())
            for name, wanted in registry[case]['files'].items():
                assert info['input_sha256']['sdcard/rally25/' + name] == wanted
            evidence = HERE / 'evidence' / master / (case + '-attempt' + str(number))
            evidence.mkdir(parents=True, exist_ok=False)
            print(f'[{case_index}/17] {master} {case}, attempt{number}/{MAX_ATTEMPTS}: video=dummy audio=dummy boost=0', flush=True)
            entry = dict(attempt=number, profile_campaign=profile_campaign,
                         profile=str(profile), profiles_receipt='PROFILES-' + profile_campaign + '.json',
                         evidence_directory=str(evidence.relative_to(HERE)), passed=False)
            interrupt = None
            failure_error = None
            try:
                receipt = control.run_one(profile)
                entry.update(passed=True, **{key: receipt[key] for key in
                    ('host_seconds', 'process_exit', 'backend_stats', 'result')})
            except oryx_session.SessionAbort as error:
                entry.update(error=repr(error), session_abort=True)
                interrupt = error
            except Exception as error:
                entry['error'] = repr(error)
                failure_error = error
            except BaseException as error:
                entry.update(error=repr(error), interrupted=True)
                interrupt = error
            finally:
                # control.run_one() owns launch/stop; its finally block must have
                # completed before any receipt is accepted or retry is staged.
                copy_returns(profile, evidence)
                entry['input_hashes_preserved'] = all(control.sha(profile / name) == wanted
                    for name, wanted in info['input_sha256'].items())
                entry['boost_after'] = oryx_session.BOOST.read_text().strip()
                if not entry['input_hashes_preserved']:
                    entry.update(passed=False, error='Input hashes changed; retries prohibited')
                if entry['boost_after'] != '0':
                    entry.update(passed=False, error='Boost changed; retries prohibited')
                if not entry['passed'] and interrupt is None:
                    entry['retry_classification'] = classify_startup_timeout(failure_error, evidence)
                attempts['attempts'][case].append(dict(entry))
                save(attempts_path.name, attempts)
                save(str(evidence.relative_to(HERE) / 'ATTEMPT.json'), entry)
            if interrupt is not None:
                raise interrupt
            assert entry['input_hashes_preserved'], entry
            assert entry['boost_after'] == '0', entry
            if entry['passed']:
                attempts['selected'][case] = dict(attempt=number, profile=str(profile),
                    profile_campaign=profile_campaign, evidence_directory=entry['evidence_directory'])
                selected = dict(entry, selected_attempt=number,
                                attempts=list(attempts['attempts'][case]))
                summary[case] = selected
                profiles[case] = dict(info, selected_attempt=number,
                                     evidence_directory=entry['evidence_directory'])
                save(profiles_path.name, profiles)
                save(attempts_path.name, attempts)
                save(campaign_path.name, summary)
                print(case, 'PASS', round(entry['result']['nominal_mos_fps'], 3),
                      'nominal MOS FPS; selected attempt', number, flush=True)
                break
            if not entry['retry_classification']['retry_allowed']:
                summary[case] = dict(entry, attempts=list(attempts['attempts'][case]))
                save(campaign_path.name, summary)
                raise RuntimeError('Failure is not a retryable startup transport timeout: ' + case + ': ' + entry['retry_classification']['reason'])
            if number == MAX_ATTEMPTS:
                summary[case] = dict(entry, attempts=list(attempts['attempts'][case]))
                save(campaign_path.name, summary)
                raise RuntimeError('All bounded fresh-profile attempts failed: ' + case)


def session(name, campaigns):
    assert campaigns and name.isalnum()
    original_owned = oryx_session.owned_processes
    original_run = oryx_session.run_campaign
    original_here = oryx_session.HERE
    source_pins = {str(path.relative_to(HERE)): control.sha(path)
                   for path in (HERE / 'retry_control.py', HERE / 'control.py')}
    for campaign in campaigns:
        for entry in json.loads((HERE / ('PROFILES-' + campaign + '.json')).read_text()).values():
            register_profile(entry['profile'])

    def owned_with_retries(profiles):
        with _profiles_lock:
            additional = set(_dynamic_profiles)
        combined = {validate_profile(profile) for profile in profiles} | additional
        return original_owned(combined)

    oryx_session.owned_processes = owned_with_retries
    oryx_session.run_campaign = run_campaign
    oryx_session.HERE = HERE
    try:
        oryx_session.session(name, campaigns, [])
    finally:
        # stop_owned() in the original supervisor uses the wrapped ownership
        # query during all TERM/KILL/wait passes, covering every retry profile.
        oryx_session.owned_processes = original_owned
        oryx_session.run_campaign = original_run
        oryx_session.HERE = original_here
        with _profiles_lock:
            owned = sorted(str(path) for path in _dynamic_profiles)
        save('RETRY-SESSION-' + name + '.json', dict(schema=1, session=name,
             campaigns=campaigns, dynamic_owned_profiles=owned,
             original_guard_unchanged=True, thermal_stop_celsius=95,
             original_run_one_reused=True, max_attempts_per_case=MAX_ATTEMPTS,
             automatic_retry_only_before_info_token18=True,
             source_pins=source_pins,
             sources_unchanged=all(control.sha(HERE / relative) == wanted
                                   for relative, wanted in source_pins.items())))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=['session'])
    parser.add_argument('name')
    parser.add_argument('campaigns', nargs='+')
    arguments = parser.parse_args()
    session(arguments.name, arguments.campaigns)
