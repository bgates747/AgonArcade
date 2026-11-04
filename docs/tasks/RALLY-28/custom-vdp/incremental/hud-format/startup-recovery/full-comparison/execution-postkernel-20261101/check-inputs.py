from pathlib import Path
import json,hashlib,socket
root=Path.cwd(); f=root/'docs/tasks/RALLY-28/custom-vdp/incremental/hud-format/startup-recovery/full-comparison'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(f/'READINESS-FREEZE.json')=='71062298847fbd619c5a79324e1fb8e14f6737684726a178a7b30b9766c03279'
r=json.loads((f/'READINESS-FREEZE.json').read_text());errors=[]
for base,items in [(f,r['files']),(root,r['project_dependencies'])]:
 for n,h in items.items():
  if not (base/n).exists() or sha(base/n)!=h:errors.append(str(base/n))
remote=socket.gethostname()=='oryx-linuxlite';count=0
if remote:
 for case,p in json.loads((f/'PROFILES.json').read_text()).items():
  base=Path(p['profile'])
  for n,h in p['input_sha256'].items():
   count+=1
   if not (base/n).exists() or sha(base/n)!=h:errors.append(str(base/n))
  for n in ['last-run','.last-run']:
   if (base/n).exists():errors.append('EXISTS:'+str(base/n))
  for n in ['result.txt','failure.txt','state.bin','verified.json','capture.req']:
   if (base/'sdcard/rally25'/n).exists():errors.append('EXISTS:'+str(base/'sdcard/rally25'/n))
 for n in ['SESSION-hud900abba01.json','CAMPAIGN-hud900abba01.json','PROFILES-hud900abba01.json','evidence/hud900abba01','REPORT.json']:
  if (f/n).exists():errors.append('EXISTS:'+str(f/n))
print(json.dumps(dict(passed=not errors,errors=errors,closure_files=len(r['files'])+len(r['project_dependencies']),profile_inputs=count,host=socket.gethostname(),emulator_executed=False),indent=2))
assert not errors
