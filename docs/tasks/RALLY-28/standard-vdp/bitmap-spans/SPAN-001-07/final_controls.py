import profiles,run,json
from pathlib import Path
HERE=Path(__file__).resolve().parent;results=[]
for live,diag,frames,backend in [(0,0,1024,'fab'),(1,0,512,'fab'),(1,1,16,'flexe')]:
 name=f'rally28-road-sparse-{backend}-{live}-final05';profiles.prepare(name,0,live,diag,frames,backend,HERE/'.work/sparse/bin/roadbench.bin');results.append({'name':name,'ok':run.run(name,180)})
for v in range(3):
 name=f'rally28-road-v{v}-fab-long05';profiles.prepare(name,v,1,0,512,'fab');results.append({'name':name,'ok':run.run(name,180)})
(HERE/'evidence/FINAL-CONTROLS.json').write_text(json.dumps(results,indent=2)+'\n')
