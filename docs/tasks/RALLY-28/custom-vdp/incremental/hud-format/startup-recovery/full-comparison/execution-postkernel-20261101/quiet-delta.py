from pathlib import Path
import os,time,json
hz=os.sysconf('SC_CLK_TCK')
def read():
 d={}
 for p in Path('/proc').glob('[0-9]*'):
  try:
   a=(p/'stat').read_text();tail=a[a.rfind(')')+2:].split();d[int(p.name)]=(int(tail[11])+int(tail[12]),a[a.find('(')+1:a.rfind(')')],tail[0])
  except (OSError,ValueError,IndexError):pass
 return d
start=time.monotonic();a=read();time.sleep(1);b=read();elapsed=time.monotonic()-start
rows=sorted([dict(pid=pid,comm=v[1],state=v[2],cpu_seconds=(v[0]-a[pid][0])/hz,cores=(v[0]-a[pid][0])/hz/elapsed) for pid,v in b.items() if pid in a],key=lambda r:r['cores'],reverse=True)
print(json.dumps(dict(wall_seconds=elapsed,top20=rows[:20],total_cores=sum(r['cores'] for r in rows),read_only=True),indent=2))
