"""Run only the requested stopped profile headlessly; retain failures and stop it."""
from pathlib import Path
import argparse,json,os,signal,subprocess,time
from verify_run import verify

def run(profile,timeout=180):
    profile=Path(profile).resolve();app=profile/'sdcard/rally25';art=profile/'last-run'
    if art.exists():
        history=profile/'history';history.mkdir(exist_ok=True);art.rename(history/str(time.time_ns()))
    art.mkdir();env=os.environ.copy();env.update(SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy')
    for n in ('replies.log','ticks.log','prt.log','clock.log','failure.log'):(app/n).unlink(missing_ok=True)
    expected_prt=json.loads((app/'expected.json').read_text()).get('prt_instrumented',False)
    frontend='flexe-agon-emulator' if (profile/'flexe-agon-emulator').exists() else 'fab-agon-emulator'
    started=time.monotonic();proc=None;result=None;error=None
    try:
        with (art/'frontend.log').open('w') as log:
            proc=subprocess.Popen(['./'+frontend,'--renderer','sw'],cwd=profile,env=env,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
            while True:
                if (app/'failure.log').exists():raise RuntimeError('Guest reported failure')
                if proc.poll() is not None:raise RuntimeError('Frontend exited '+str(proc.returncode))
                if time.monotonic()-started>timeout:raise TimeoutError('No complete demo before '+str(timeout)+' seconds')
                if (app/'replies.log').exists() and (app/'ticks.log').exists() and (not expected_prt or ((app/'prt.log').exists() and (app/'clock.log').exists())):
                    expected=json.loads((app/'expected.json').read_text())
                    if (app/'replies.log').stat().st_size==expected['reply_bytes']:
                        time.sleep(.3);result=verify(app);break
                time.sleep(.1)
    except Exception as exc:error=repr(exc)
    finally:
        if proc and proc.poll() is None:
            for child in Path('/proc').glob('[0-9]*'):
                try:
                    if os.getpgid(int(child.name))==proc.pid and (child/'exe').resolve()==(profile/(frontend+'.bin')).resolve():os.kill(int(child.name),signal.SIGTERM)
                except OSError:pass
            try:proc.wait(timeout=10)
            except subprocess.TimeoutExpired:os.killpg(proc.pid,signal.SIGKILL);proc.wait()
    receipt=dict(error=error,host_seconds=round(time.monotonic()-started,3),process_exit=proc.returncode if proc else None,
                 result=result,runtime_identities=(profile/'.runtime.sha256').read_text())
    if not error:
        assert proc.returncode==0,proc.returncode
        stats=json.loads((art/'stats.json').read_text());receipt['backend_stats']=stats
        assert not any(stats.get(k) for k in ('failed','unhandled','unregistered','unmapped')),stats
    (art/'run.json').write_text(json.dumps(receipt,indent=2)+'\n')
    print(json.dumps({k:v for k,v in receipt.items() if k not in ('result','runtime_identities','backend_stats')},indent=2))
    if error:raise RuntimeError(error)
    return receipt
if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('profile');p.add_argument('--timeout',type=float,default=180);a=p.parse_args();run(a.profile,a.timeout)
