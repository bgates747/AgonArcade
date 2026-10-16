from pathlib import Path
import profiles,run,json
HERE=Path(__file__).resolve().parent
results=[]
# Distinct CPU capacity and frame-completion counts; matched within each axis.
for v,live,diag,frames,backend in [(0,0,0,1024,'fab'),(1,0,0,1024,'fab'),(2,0,0,1024,'fab'),(3,1,1,32,'flexe'),(0,1,1,128,'flexe'),(1,1,1,128,'flexe'),(2,1,1,128,'flexe'),(0,1,0,128,'fab'),(1,1,0,128,'fab'),(2,1,0,128,'fab')]:
 name=f'rally28-road-v{v}-{backend}-{live}-final05';profiles.prepare(name,v,live,diag,frames,backend)
 ok=run.run(name,timeout=300);results.append({'name':name,'ok':ok});print(json.dumps(results[-1]),flush=True)
(HERE/'evidence/CAMPAIGN.json').write_text(json.dumps(results,indent=2)+'\n')
