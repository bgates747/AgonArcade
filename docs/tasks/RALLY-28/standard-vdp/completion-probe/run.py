"""Run one owned profile with dummy video AND audio, and preserve guest evidence."""
from pathlib import Path
import argparse,hashlib,json,os,signal,subprocess,time
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
def run(profile,timeout,keys=None):
    identity=json.loads((profile/'identity.json').read_text());kind=identity['kind']
    app=profile/'sdcard/test/arcade/rally28'/kind
    assert not (app/'summary.txt').exists() and not (app/'events.csv').exists(),'Use a fresh run directory'
    for n,h in identity['files'].items():assert sha(profile/n)==h,n
    art=profile/'last-run';art.mkdir(exist_ok=True)
    env=dict(os.environ,SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy')
    if keys:
        env.update(LD_PRELOAD=str(keys.resolve()),SYNC_READY_LOG=str(art/'esp32-uart0.log'))
    started=time.monotonic();reason='timeout'
    with (art/'frontend.log').open('w') as log:
        proc=subprocess.Popen(['./flexe-agon-emulator'],cwd=profile,env=env,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
        try:
            while time.monotonic()-started<timeout:
                if (app/'done.txt').exists() and (app/'done.txt').read_bytes().endswith(b'\n'):
                    time.sleep(.5);reason='guest-files';break
                if proc.poll() is not None:reason='frontend-exit';break
                time.sleep(.2)
        finally:
            if proc.poll() is None:
                # Signal the owned frontend, allowing the generated wrapper to reap it.
                for p in Path('/proc').glob('[0-9]*'):
                    try:
                        if os.getpgid(int(p.name))==proc.pid and (p/'exe').resolve()==(profile/'flexe-agon-emulator.bin').resolve():os.kill(int(p.name),signal.SIGTERM)
                    except OSError:pass
                try:proc.wait(timeout=5)
                except subprocess.TimeoutExpired:os.killpg(proc.pid,signal.SIGKILL);proc.wait()
    report={'reason':reason,'host_seconds':time.monotonic()-started,'exit':proc.returncode,'kind':kind,'identity':identity,'forced_sdl':{'video':'dummy','audio':'dummy'}}
    if (app/'summary.txt').exists():
        report['summary']=dict(line.split('=',1) for line in (app/'summary.txt').read_text().splitlines() if '=' in line)
    report['outputs']={n:sha(app/n) for n in ('summary.txt','events.csv','done.txt') if (app/n).exists()}
    if (art/'stats.json').exists():report['backend_stats']=json.loads((art/'stats.json').read_text())
    report['identities_unchanged']=all(sha(profile/n)==h for n,h in identity['files'].items())
    (art/'result.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
    s=report.get('summary',{})
    if reason!='guest-files' or s.get('failure')!='none' or s.get('completed')!='52' or not report['identities_unchanged']:raise SystemExit(1)
if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('profile',type=Path);p.add_argument('--timeout',type=float,default=90);p.add_argument('--keys',type=Path)
    a=p.parse_args();run(a.profile.resolve(),a.timeout,a.keys)
