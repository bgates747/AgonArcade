"""Run a finite, sequential, silent campaign; fail before launch when boost is on."""
import argparse
import json
import os
from pathlib import Path
import shutil
import sys
from fixtures import HERE, ROOT, PRIOR, sha


def run_campaign(campaign, cases=None):
    assert campaign.isalnum()
    boost = Path('/sys/devices/system/cpu/cpufreq/boost')
    boost_value = boost.read_text().strip() if boost.exists() else None
    if boost_value is not None and boost_value != '0':
        blocked = dict(campaign=campaign, condition='CPU boost enabled', boost=boost_value,
                       emulator_launched=False, power_settings_changed=False,
                       reason='Standing thermal safeguard requires boost0 for unattended emulator runs',
                       recovery='Author disables boost using established host policy, then reruns this finite campaign')
        (HERE / ('BLOCKED-' + campaign + '.json')).write_text(json.dumps(blocked, indent=2) + '\n')
        raise RuntimeError(blocked['reason'] + '; rejected before launch or guest-output changes')
    os.environ.update(SDL_VIDEODRIVER='dummy', SDL_AUDIODRIVER='dummy')
    profiles = json.loads((HERE / ('PROFILES-' + campaign + '.json')).read_text())
    registry = json.loads((HERE / 'FIXTURES.json').read_text())
    cases = cases or [name for name in profiles if not registry[name].get('diagnostic')]
    assert set(cases) <= set(profiles) and len(cases) == len(set(cases))
    assert not any(registry[name].get('diagnostic') for name in cases), 'Use phase_run.py for short diagnostic profiles'
    for name in cases:
        profile = Path(profiles[name]['profile'])
        assert not (profile / 'last-run').exists(), 'Use a fresh campaign/profile; preserve earlier outcomes'
        assert all(sha(profile / n) == h for n, h in profiles[name]['input_sha256'].items()), name
    runner = HERE / '.work/runner'
    runner.mkdir(parents=True, exist_ok=True)
    runner_pins = json.loads((HERE / 'RUNNER-PINS.json').read_text())
    for n, digest in runner_pins.items():
        assert sha(HERE / 'support' / n) == digest, 'Runner source pin mismatch'
        shutil.copyfile(HERE / 'support' / n, runner / n)
    sys.path.insert(0, str(runner))
    from run_headless import run
    final = json.loads((PRIOR / 'CONTROL-FINAL.json').read_text())['final_buffers']
    evidence = HERE / 'evidence' / campaign
    evidence.mkdir(parents=True, exist_ok=False)
    summary = {}
    for name in cases:
        profile = Path(profiles[name]['profile'])
        app = profile / 'sdcard/rally25'
        print('Running', name, 'video=dummy audio=dummy boost=0', flush=True)
        try:
            receipt = run(profile, 180)
            result = receipt['result']
            assert result['frames'] == 900 and result['physics_ticks'] == 3600
            assert result['validated_reply_records'] == 2913
            assert result['final_buffers'] == final, 'Independent final-world control differs'
            entry = dict(passed=True, frames=result['frames'], physics_ticks=result['physics_ticks'],
                         nominal_mos_fps=result['observed_fps'], nominal_mos_seconds=result['elapsed_seconds'],
                         prt=result['prt'], host_seconds_including_startup=receipt['host_seconds'],
                         reply_sha256=result['reply_sha256'], final_world_exact=True,
                         backend_stats=receipt['backend_stats'])
        except Exception as exc:
            entry = dict(passed=False, error=repr(exc), emulator_launched=True)
        destination = evidence / name
        destination.mkdir()
        for n in ('replies', 'ticks', 'prt', 'clock', 'failure'):
            if (app / (n + '.log')).exists():
                shutil.copyfile(app / (n + '.log'), destination / (n + '.bin'))
        for n in ('stats.json', 'final.ppm', 'mos-to-vdp.bin', 'vdp-to-mos.bin',
                  'vdp-to-mos-delivered.bin', 'run.json', 'frontend.log'):
            if (profile / 'last-run' / n).exists():
                shutil.copyfile(profile / 'last-run' / n,
                                destination / ('frontend.txt' if n == 'frontend.log' else n))
        entry['input_hashes_preserved'] = all(sha(profile / n) == h
                                              for n, h in profiles[name]['input_sha256'].items())
        entry['boost_after'] = boost.read_text().strip() if boost.exists() else None
        summary[name] = entry
        (HERE / ('CAMPAIGN-' + campaign + '.json')).write_text(json.dumps(summary, indent=2) + '\n')
        if not entry['passed']:
            raise RuntimeError('Campaign stopped after preserved failed case: ' + name)
        assert entry['input_hashes_preserved'] and entry['boost_after'] in ('0', None)
        print(name, 'PASS', round(entry['nominal_mos_fps'], 3), 'nominal MOS FPS', flush=True)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--campaign', required=True)
    parser.add_argument('--cases', nargs='+')
    options = parser.parse_args()
    run_campaign(options.campaign, options.cases)
