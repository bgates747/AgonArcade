from pathlib import Path
import argparse,subprocess,time,os,signal,json,hashlib,shutil,csv
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[5];sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def run(name,timeout=300):
 p=ROOT/'.emulator'/name;identity=json.loads((p/'identity.json').read_text());app=p/'sdcard/test/arcade/rally28/road';assert not any((app/n).exists() for n in ('started.txt','summary.txt','done.txt','ended.txt')); assert all(sha(p/n)==h for n,h in identity['files'].items())
 start=time.monotonic();boot=time.clock_gettime(time.CLOCK_BOOTTIME);begin=end=None;reason='timeout';boost=Path('/sys/devices/system/cpu/cpufreq/boost');assert boost.read_text().strip()=='0'
 with (p/'frontend.log').open('w') as log:
  proc=subprocess.Popen(['./'+identity['backend']+'-agon-emulator'],cwd=p,env=dict(os.environ,SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy'),stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
  try:
   while time.monotonic()-start<timeout:
    now=time.monotonic()
    if boost.read_text().strip()!='0':reason='boost-enabled';break
    if begin is None and (app/'started.txt').exists() and (app/'started.txt').stat().st_size:begin=now
    if end is None and (app/'ended.txt').exists() and (app/'ended.txt').stat().st_size:end=now
    if (app/'done.txt').exists() and (app/'done.txt').read_bytes().endswith(b'\n'):reason='guest-files';break
    if proc.poll() is not None:reason='frontend-exit';break
    time.sleep(.05)
  finally:
   if proc.poll() is None:
    os.killpg(proc.pid,signal.SIGTERM)
    try:proc.wait(timeout=5)
    except subprocess.TimeoutExpired:os.killpg(proc.pid,signal.SIGKILL);proc.wait()
 summary=dict(l.split('=',1) for l in (app/'summary.txt').read_text().splitlines() if '=' in l) if (app/'summary.txt').exists() else {}
 r={'reason':reason,'identity':identity,'summary':summary,'host_seconds':time.monotonic()-start,'host_window_seconds':end-begin if begin and end else None,'host_suspend_seconds':time.clock_gettime(time.CLOCK_BOOTTIME)-boot-(time.monotonic()-start),'forced_sdl':{'video':'dummy','audio':'dummy'},'identities_unchanged':all(sha(p/n)==h for n,h in identity['files'].items())}
 dest=HERE/'evidence'/name;dest.mkdir(parents=True)
 for f in [*app.iterdir(),p/'frontend.log',p/'identity.json']:shutil.copyfile(f,dest/f.name)
 if (app/'frames.csv').exists():
  rows=[{k:int(v) for k,v in row.items()} for row in csv.DictReader((app/'frames.csv').open())];r['row_count']=len(rows);r['sums']={k:sum(row[k] for row in rows) for k in rows[0]} if rows else {}
  if identity['diagnostic'] and rows:assert all(row['vdp_submit_us']+row['vdp_drain_us']==row['vdp_complete_us'] for row in rows)
 if (p/'last-run/stats.json').exists():r['backend_stats']=json.loads((p/'last-run/stats.json').read_text())
 (dest/'result.json').write_text(json.dumps(r,indent=2)+'\n');print(json.dumps({k:v for k,v in r.items() if k!='identity'},indent=2),flush=True)
 return reason=='guest-files' and summary.get('failure')=='none' and int(summary.get('frames',0))==identity['frames'] and summary.get('restored')=='1'
if __name__=='__main__':
 a=argparse.ArgumentParser();a.add_argument('name');a.add_argument('--timeout',type=float,default=300);x=a.parse_args();raise SystemExit(0 if run(x.name,x.timeout) else 1)
