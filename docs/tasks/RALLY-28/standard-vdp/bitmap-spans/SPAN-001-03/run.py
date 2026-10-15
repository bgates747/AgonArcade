"""Bounded silent Fab qualification; never opens a window or audio backend."""
from pathlib import Path
import argparse,os,subprocess,time,signal,json,hashlib,shutil,csv
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[5]
def run(name):
 p=ROOT/'.emulator'/name;app=p/'sdcard/test/arcade/rally28/spans'
 assert not (app/'summary.txt').exists();identity=json.loads((p/'identity.json').read_text())
 sha=lambda f:hashlib.sha256(f.read_bytes()).hexdigest()
 assert all(sha(p/n)==h for n,h in identity['files'].items())
 boost=Path('/sys/devices/system/cpu/cpufreq/boost');assert boost.read_text().strip()=='0'
 start=time.monotonic();reason='timeout'
 with (p/'frontend.log').open('w') as log:
  proc=subprocess.Popen(['./fab-agon-emulator'],cwd=p,env=dict(os.environ,SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy'),stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
  try:
   while time.monotonic()-start<90:
    if boost.read_text().strip()!='0':reason='boost-enabled';break
    if (app/'done.txt').exists() and (app/'done.txt').read_bytes().endswith(b'\n'):reason='guest-files';break
    if proc.poll() is not None:reason='frontend-exit';break
    time.sleep(.05)
  finally:
   if proc.poll() is None:
    os.killpg(proc.pid,signal.SIGTERM)
    try:proc.wait(timeout=5)
    except subprocess.TimeoutExpired:os.killpg(proc.pid,signal.SIGKILL);proc.wait()
 dest=HERE/'evidence'/name;dest.mkdir(parents=True)
 for f in [*app.iterdir(),p/'identity.json',p/'frontend.log']:shutil.copyfile(f,dest/f.name)
 summary=dict(l.split('=',1) for l in (app/'summary.txt').read_text().splitlines() if '=' in l) if (app/'summary.txt').exists() else {}
 result={'reason':reason,'summary':summary,'host_seconds':time.monotonic()-start,'forced_sdl':{'video':'dummy','audio':'dummy'},'identities_unchanged':all(sha(p/n)==h for n,h in identity['files'].items()),'inputs':identity}
 (dest/'result.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
 assert reason=='guest-files' and summary['views']=='6' and summary['pixel_checks']=='64' and summary['failure']=='none' and result['identities_unchanged']
 assert summary['road_writes']=='6'
 initial=(HERE/'INITIAL-COMMAND.bin').read_bytes();actual=(app/'command.bin').read_bytes()
 expected=bytearray(initial)
 for i in range(120):
  y=i+104;paint=y>=116 and ((800000//(y-96)+4000)%8000)<4000
  at=11+i*6
  expected[at:at+2]=(55100+int(paint)).to_bytes(2,'little')
  expected[at+2:at+4]=(280).to_bytes(2,'little')
 assert actual==expected,'Saved submitted command differs from independent expected envelope'
 result['command_verified']={'bytes':737,'sha256':sha(app/'command.bin'),'header_and_call_unchanged':actual[:11]==initial[:11] and actual[-6:]==initial[-6:],'static_matrix_ids_unchanged':all(actual[11+i*6+4:11+i*6+6]==initial[11+i*6+4:11+i*6+6] for i in range(120)),'road_writes':6}
 (dest/'result.json').write_text(json.dumps(result,indent=2)+'\n')
 rows=list(csv.DictReader((app/'pixels.csv').open()));assert len(rows)==64 and all(r['expected']==r['actual'] for r in rows)
if __name__=='__main__':
 a=argparse.ArgumentParser();a.add_argument('name');run(a.parse_args().name)
