"""Run an isolated full-scene profile headlessly and retain all diagnostics."""
from pathlib import Path
import argparse,hashlib,json,os,signal,subprocess,time
from verify import verify

def run(profile,timeout):
    profile=Path(profile).resolve();app=profile/'sdcard/rally25';art=profile/'last-run'
    assert not (app/'result.json').exists() and not (app/'failure.txt').exists(),'Use a fresh profile; preserve old results'
    art.mkdir(exist_ok=True);started=time.monotonic();proc=None;error=None;result=None
    try:
        with (art/'frontend.log').open('w') as log:
            proc=subprocess.Popen(['./flexe-agon-emulator'],cwd=profile,env=dict(os.environ,SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy'),stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
            while time.monotonic()-started<timeout:
                if (app/'failure.txt').exists():raise RuntimeError((app/'failure.txt').read_text())
                if (app/'result.json').exists():
                    try:json.loads((app/'result.json').read_text())
                    except json.JSONDecodeError:time.sleep(.1);continue
                    time.sleep(.5);result=verify(app);break
                if proc.poll() is not None:raise RuntimeError('Frontend exited '+str(proc.returncode))
                time.sleep(.1)
            if result is None:raise TimeoutError('No complete full-scene result before '+str(timeout)+' seconds')
    except Exception as exc:error=repr(exc)
    finally:
        if proc and proc.poll() is None:
            for child in Path('/proc').glob('[0-9]*'):
                try:
                    if os.getpgid(int(child.name))==proc.pid and (child/'exe').resolve()==(profile/'flexe-agon-emulator.bin').resolve():os.kill(int(child.name),signal.SIGTERM)
                except OSError:pass
            try:proc.wait(timeout=10)
            except subprocess.TimeoutExpired:os.killpg(proc.pid,signal.SIGKILL);proc.wait()
    stats=json.loads((art/'stats.json').read_text()) if (art/'stats.json').exists() else None
    receipt=dict(error=error,host_seconds=round(time.monotonic()-started,3),process_exit=proc.returncode if proc else None,result=result,backend_stats=stats,runtime_identities=(profile/'.runtime.sha256').read_text())
    (art/'run.json').write_text(json.dumps(receipt,indent=2)+'\n')
    print(json.dumps({k:v for k,v in receipt.items() if k not in ('runtime_identities','backend_stats')},indent=2))
    if error:raise RuntimeError(error)
    assert proc.returncode==0 and stats and not any(stats.get(k) for k in ('failed','unhandled','unregistered','unmapped'))
    return receipt
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('profile');p.add_argument('--timeout',type=float,default=180);a=p.parse_args();run(a.profile,a.timeout)
