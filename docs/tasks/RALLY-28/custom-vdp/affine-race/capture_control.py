"""Silent post-swap scene captures, deliberately interrupted outside timing."""
from pathlib import Path
import argparse
import json
import os
import shutil
import subprocess
import time
import control

HERE = Path(__file__).resolve().parent


def run_campaign(campaign):
    assert Path('/sys/devices/system/cpu/cpufreq/boost').read_text().strip() == '0'
    entries = json.loads((HERE/('PROFILES-'+campaign+'.json')).read_text())
    fixtures = json.loads((HERE/'CAPTURE-FIXTURES.json').read_text())
    summary = {}
    for name, info in entries.items():
        profile = Path(info['profile'])
        app, artifact = profile/'sdcard/rally25', profile/'last-run'
        assert not artifact.exists() and not (app/'capture.ready').exists()
        assert all(control.sha(profile/n) == h for n,h in info['input_sha256'].items())
        artifact.mkdir()
        dest = HERE/'captures/evidence'/campaign/name
        dest.mkdir(parents=True, exist_ok=False)
        env = os.environ.copy()
        env.update(SDL_VIDEODRIVER='dummy', SDL_AUDIODRIVER='dummy')
        proc, error, ready = None, None, None
        started = time.monotonic()
        progress_at, previous_sizes = started, None
        try:
            print('Capture', name, 'video=dummy audio=dummy boost=0', flush=True)
            with (artifact/'frontend.log').open('w') as log:
                proc = subprocess.Popen(['./flexe-agon-emulator', '--renderer', 'sw'], cwd=profile,
                                        env=env, stdout=log, stderr=subprocess.STDOUT, start_new_session=True)
                while time.monotonic()-started < 300:
                    sizes = tuple((artifact/n).stat().st_size if (artifact/n).exists() else 0
                                  for n in ('mos-to-vdp.bin','vdp-to-mos.bin'))
                    if sizes != previous_sizes:
                        progress_at, previous_sizes = time.monotonic(), sizes
                    elif time.monotonic()-progress_at > 60:
                        raise TimeoutError('UART streams unchanged for60 host seconds; preserve fresh retry')
                    assert not (app/'failure.txt').exists(), (app/'failure.txt').read_text() if (app/'failure.txt').exists() else ''
                    assert proc.poll() is None, 'Frontend exited before capture'
                    if (app/'capture.ready').exists():
                        try:
                            ready = json.loads((app/'capture.ready').read_text())
                        except json.JSONDecodeError:
                            time.sleep(.1)
                            continue
                        assert ready == fixtures[name]['expected_capture_ready'], ready
                        time.sleep(.5)
                        break
                    time.sleep(.1)
                assert ready, 'No ordered post-swap capture within300 host seconds'
        except BaseException as exc:
            error = repr(exc)
            raise
        finally:
            control.stop(proc, profile)
            state = dict(error=error, capture_ready=ready, video_driver='dummy', audio_driver='dummy',
                         intentional_interruption_during_hold=True, timing_excluded=True,
                         game_cleanup_validated=False, host_seconds=round(time.monotonic()-started,3),
                         runtime_identities=(profile/'.runtime.sha256').read_text(),
                         process_exit=proc.returncode if proc else None,
                         input_hashes_preserved=all(control.sha(profile/n)==h for n,h in info['input_sha256'].items()))
            if error is None:
                stats = json.loads((artifact/'stats.json').read_text())
                assert proc.returncode == 0 and (artifact/'final.ppm').exists()
                assert not any(stats.get(k) for k in ('failed','unhandled','unregistered','unmapped'))
                state.update(backend_stats=stats, scene_ppm_sha256=control.sha(artifact/'final.ppm'))
            (artifact/'capture.json').write_text(json.dumps(state,indent=2)+'\n')
            for p in artifact.iterdir():
                if p.is_file():
                    shutil.copyfile(p,dest/(p.with_suffix('.txt').name if p.suffix=='.log' else p.name))
            for n in ('capture.ready','failure.txt'):
                if (app/n).exists():
                    shutil.copyfile(app/n,dest/n)
            summary[name]=state
            (HERE/('CAPTURE-CAMPAIGN-'+campaign+'.json')).write_text(json.dumps(summary,indent=2)+'\n')


if __name__ == '__main__':
    p=argparse.ArgumentParser(); p.add_argument('session'); p.add_argument('campaign'); a=p.parse_args()
    import oryx_session
    oryx_session.HERE=HERE; oryx_session.run_campaign=run_campaign
    oryx_session.session(a.session,[a.campaign],[])
