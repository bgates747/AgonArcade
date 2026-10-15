"""Run one owned profile with dummy video AND audio, and preserve guest evidence."""
from pathlib import Path
import argparse,hashlib,json,os,signal,subprocess,time
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
def run(profile,timeout,keys=None,stall_seconds=None,uart_markers=None):
    identity=json.loads((profile/'identity.json').read_text());kind=identity['kind']
    app=profile/'sdcard/test/arcade/rally28'/kind
    assert not any((app/n).exists() for n in ('summary.txt','state.csv','started.txt','ended.txt','done.txt')),'Use a fresh run directory'
    for n,h in identity['files'].items():assert sha(profile/n)==h,n
    art=profile/'last-run';art.mkdir(exist_ok=True)
    env=dict(os.environ,SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy')
    if keys:
        env.update(LD_PRELOAD=str(keys.resolve()),SYNC_READY_LOG=str(art/'esp32-uart0.log'))
    boost=Path('/sys/devices/system/cpu/cpufreq/boost')
    assert boost.exists() and boost.read_text().strip()=='0','Resumed Oryx runs require CPU boost disabled'
    started=time.monotonic();boot_start=time.clock_gettime(time.CLOCK_BOOTTIME);boot_id=Path('/proc/sys/kernel/random/boot_id').read_text().strip();reason='timeout';last_progress=started;size=0;host_begin=None;host_end=None
    with (art/'frontend.log').open('w') as log:
        proc=subprocess.Popen(['./flexe-agon-emulator'],cwd=profile,env=env,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
        try:
            while time.monotonic()-started<timeout:
                now=time.monotonic()
                if boost.read_text().strip()!='0':reason='cpu-boost-enabled';break
                if uart_markers and (art/'mos-to-vdp.bin').exists():
                    captured=(art/'mos-to-vdp.bin').read_bytes()
                    if host_begin is None and uart_markers[0] in captured:host_begin=now
                    if host_end is None and uart_markers[1] in captured:host_end=now
                if host_begin is None and (app/'started.txt').exists() and (app/'started.txt').stat().st_size:host_begin=now
                if host_end is None and (app/'ended.txt').exists() and (app/'ended.txt').stat().st_size:host_end=now
                if (app/'done.txt').exists() and (app/'done.txt').read_bytes().endswith(b'\n'):
                    time.sleep(.5);reason='guest-files';break
                progress=art/'mos-to-vdp.bin'
                if stall_seconds and progress.exists():
                    current=progress.stat().st_size
                    if current!=size:
                        size=current;last_progress=time.monotonic()
                    if current and time.monotonic()-last_progress>stall_seconds:
                        reason='no-uart-progress';break
                if proc.poll() is not None:reason='frontend-exit';break
                time.sleep(.05)
        finally:
            if proc.poll() is None:
                # Signal the owned frontend, allowing the generated wrapper to reap it.
                for p in Path('/proc').glob('[0-9]*'):
                    try:
                        if os.getpgid(int(p.name))==proc.pid and (p/'exe').resolve()==(profile/'flexe-agon-emulator.bin').resolve():os.kill(int(p.name),signal.SIGTERM)
                    except OSError:pass
                try:proc.wait(timeout=5)
                except subprocess.TimeoutExpired:os.killpg(proc.pid,signal.SIGKILL);proc.wait()
    report={'reason':reason,'host_seconds':time.monotonic()-started,'exit':proc.returncode,'kind':kind,'identity':identity,'forced_sdl':{'video':'dummy','audio':'dummy'},'host_window_seconds':host_end-host_begin if host_begin is not None and host_end is not None else None,'host_marker_poll_seconds':0.05,'host_window_source':'uart-markers' if uart_markers else 'guest-files','host_boot_id':boot_id,'host_cpu_boost':'0','host_boost_monitored':True,'host_suspend_seconds':(time.clock_gettime(time.CLOCK_BOOTTIME)-boot_start)-(time.monotonic()-started)}
    if (app/'summary.txt').exists():
        report['summary']=dict(line.split('=',1) for line in (app/'summary.txt').read_text().splitlines() if '=' in line)
    report['outputs']={n:sha(app/n) for n in ('summary.txt','state.csv','frames.csv','phases.csv','started.txt','ended.txt','done.txt') if (app/n).exists()}
    if (art/'stats.json').exists():report['backend_stats']=json.loads((art/'stats.json').read_text())
    report['identities_unchanged']=all(sha(profile/n)==h for n,h in identity['files'].items())
    # Guest files and shutdown captures are flushed after the timed window.
    for path in [*app.iterdir(),*art.iterdir()]:
        if path.is_file():
            with path.open('rb') as f:os.fsync(f.fileno())
    result=art/'result.json';result.write_text(json.dumps(report,indent=2)+'\n')
    with result.open('rb') as f:os.fsync(f.fileno())
    for path in (app,art):
        fd=os.open(path,os.O_RDONLY|os.O_DIRECTORY)
        try:os.fsync(fd)
        finally:os.close(fd)
    print(json.dumps(report,indent=2))
    s=report.get('summary',{})
    expected_ok=(s.get('steps')==str(identity['rounds']*4096)) if kind=='capacity' else (s.get('callback_restored')=='1' and s.get('failure')=='none' and s.get('frames')=='900')
    if reason!='guest-files' or s.get('vector_restored')!='1' or not expected_ok or not report['identities_unchanged']:raise SystemExit(1)
if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('profile',type=Path);p.add_argument('--timeout',type=float,default=90);p.add_argument('--keys',type=Path);p.add_argument('--stall-seconds',type=float)
    a=p.parse_args();run(a.profile.resolve(),a.timeout,a.keys,a.stall_seconds)
