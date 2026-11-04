from pathlib import Path
import json,hashlib
root=Path.cwd();f=root/'docs/tasks/RALLY-28/custom-vdp/incremental/hud-format/startup-recovery/full-comparison';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
files={str(p.relative_to(f)):sha(p) for p in (f/'evidence/hud900abba01').rglob('*') if p.is_file()}
for n in ['SESSION-hud900abba01.json','CAMPAIGN-hud900abba01.json','PROFILES-hud900abba01.json']:files[n]=sha(f/n)
errors=[];pins=0;preserved=0
for case,info in json.loads((f/'PROFILES.json').read_text()).items():
 profile=Path(info['profile']);dest=f/'evidence/hud900abba01'/case
 for n,h in info['input_sha256'].items():
  pins+=1
  if sha(profile/n)!=h:errors.append('PIN:'+str(profile/n))
 if (profile/'last-run').exists():
  for p in (profile/'last-run').iterdir():
   if p.is_file():
    target=dest/(p.with_suffix('.txt').name if p.suffix=='.log' else p.name)
    if not target.exists() or sha(target)!=sha(p):errors.append('MISSING_CAPTURE:'+str(p))
    preserved+=1
r=json.loads((f/'READINESS-FREEZE.json').read_text());closure=0
for base,items in [(f,r['files']),(root,r['project_dependencies'])]:
 for n,h in items.items():
  closure+=1
  if sha(base/n)!=h:errors.append('SOURCE:'+str(base/n))
print(json.dumps(dict(files=files,profile_inputs=pins,closure_files=closure,last_run_files_preserved=preserved,initial_boost_restored=Path('/sys/devices/system/cpu/cpufreq/boost').read_text().strip(),errors=errors,passed=not errors),indent=2));assert not errors
