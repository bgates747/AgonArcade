"""Bounded headless run; guest creates timing.csv, host preserves evidence."""
from pathlib import Path
import argparse,json,os,signal,subprocess,time,csv,hashlib

def run(profile,timeout):
    result=profile/'sdcard/rally/timing.csv'
    assert not result.exists(),'Preserve previous run; use a fresh profile'
    artifacts=profile/'last-run';artifacts.mkdir(exist_ok=True)
    start=time.monotonic();status='timeout'
    with (artifacts/'frontend.log').open('w') as log:
        proc=subprocess.Popen(['./flexe-agon-emulator','--renderer','sw','-z'],cwd=profile,
            env=dict(os.environ,SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy'),
            stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
        try:
            while time.monotonic()-start<timeout:
                if result.exists() and b'failure=' in result.read_bytes():status='guest-result';break
                if proc.poll() is not None:status='frontend-exit';break
                time.sleep(.25)
            # Allow normal guest cleanup before stopping this owned process group.
            if status=='guest-result':time.sleep(2)
        finally:
            if proc.poll() is None:
                os.killpg(proc.pid,signal.SIGTERM)
                try:proc.wait(timeout=5)
                except subprocess.TimeoutExpired:os.killpg(proc.pid,signal.SIGKILL);proc.wait()
    report={'status':status,'host_elapsed_seconds':time.monotonic()-start,
            'runtime':json.loads((profile/'identity.json').read_text())}
    if result.exists():
        rows=list(csv.DictReader(result.read_text().splitlines()[:2]));report['guest']=rows[0]
        r=rows[0];total=int(r['total_ticks'])
        if (r['valid']=='1' and int(r['completed'])>0 and r['completed']==r['submitted']
            and int(r['window_ticks'])>=3600
            and total==int(r['window_ticks'])+int(r['drain_ticks'])
            and 0<=int(r['simulation_ticks'])<=total):
            report['completed_fps_nominal']=int(r['completed'])*int(r['clock_hz'])/total
        report['csv_sha256']=hashlib.sha256(result.read_bytes()).hexdigest()
    (artifacts/'timing-result.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report,indent=2),flush=True)
    if 'completed_fps_nominal' not in report:raise SystemExit(1)
if __name__=='__main__':
    a=argparse.ArgumentParser();a.add_argument('profile',type=Path);a.add_argument('--timeout',type=int,default=240);args=a.parse_args();run(args.profile.resolve(),args.timeout)
