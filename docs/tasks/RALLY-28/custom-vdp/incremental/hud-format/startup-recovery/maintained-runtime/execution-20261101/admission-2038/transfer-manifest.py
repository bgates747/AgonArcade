from pathlib import Path
import json,sys
root=Path('/home/smith/Agon/mystuff/AgonArcade');m=root/'docs/tasks/RALLY-28/custom-vdp/incremental/hud-format/startup-recovery/maintained-runtime';sys.path.insert(0,str(m));import common
r=common.frozen_inputs();info=common.profile();profile=Path(info['profile']);common.check_profile(profile,info['input_sha256'],require_stopped=False)
dest=m/'evidence/maint08601/cached';errors=[];count=0
for p in (profile/'last-run').iterdir():
 if p.is_file():
  q=dest/(p.with_suffix('.txt').name if p.suffix=='.log' else p.name)
  if not q.is_file() or common.sha(q)!=common.sha(p):errors.append(str(p))
  count+=1
files={str(p.relative_to(m)):common.sha(p) for p in (m/'evidence/maint08601').rglob('*') if p.is_file()}
for n in ['SESSION-maint08601.json','CAMPAIGN-maint08601.json','PROFILES-maint08601.json','STAGED.json']:files[n]=common.sha(m/n)
print(json.dumps(dict(passed=not errors,errors=errors,files=files,preparation_files=len(r['files']),project_dependencies=len(r['project_dependencies']),profile_inputs=22,preserved_last_run_files=count,final_boost=Path('/sys/devices/system/cpu/cpufreq/boost').read_text().strip()),indent=2));assert not errors
