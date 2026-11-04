from pathlib import Path
import sys,json,os,subprocess
root=Path('/home/smith/Agon/mystuff/AgonArcade');m=root/'docs/tasks/RALLY-28/custom-vdp/incremental/hud-format/startup-recovery/maintained-runtime';sys.path.insert(0,str(m));import common
assert common.sha(m/'READINESS-FREEZE.json')=='c5efef1d256c636fe9084b7a0e142173fc1bf81c83fbc03f160b6ba6d29f6ca1'
r=common.frozen_inputs();info=common.profile();profile=Path(info['profile']);common.check_profile(profile,info['input_sha256']);assert (m/'STAGED.json').exists()
for n in ['CAMPAIGN-maint08601.json','PROFILES-maint08601.json','SESSION-maint08601.json','evidence/maint08601']:assert not (m/n).exists(),n
host=common.load('admission_conditions',common.FULL/'conditions.py').snapshot('prelaunch-maint08601')
assert host['kernel']=='7.1.5-76070105-generic';assert host['boot_id']=='9ba12fbc-c204-4332-9ff9-8bda03dfe2b2';assert host['governor']=='powersave';assert host['online_cpus']=='0-23';assert host['boost']=='1'
env=os.environ.copy();env['LD_LIBRARY_PATH']=str(Path.home()/'.local/lib')
libs={}
for n in ['flexe-agon-emulator.bin','flexe-vdp.so']:
 proc=subprocess.run(['ldd',str(profile/n)],env=env,text=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE,timeout=10)
 assert proc.returncode==0 and 'not found' not in proc.stdout and 'not found' not in proc.stderr,(n,proc.stdout,proc.stderr)
 libs[n]=dict(stdout=proc.stdout,stderr=proc.stderr,exit=proc.returncode)
print(json.dumps(dict(passed=True,files=len(r['files']),dependencies=len(r['project_dependencies']),profile_inputs=len(info['input_sha256']),output_absent=True,dynamic_libraries=libs,host=host,emulator_processes=0),indent=2))
