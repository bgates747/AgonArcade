"""Finish only four remaining already-selected cases; stop on first uncertainty."""
from pathlib import Path
import json,subprocess,sys,time
HERE=Path(__file__).resolve().parent
assert json.loads((HERE/'evidence/returned-state1/receipt.json').read_text())['passed']
assert all(not(HERE/'timings'/('run-'+case+'.json')).exists()for case in ('coarse1','coarse2','state2','baseline2'))
record=dict(start_monotonic=time.monotonic(),completed=[],passed=False)
path=HERE/'REMAINING-CAMPAIGN.json'
with path.open('x')as f:json.dump(record,f,indent=2)
try:
 for case in ('coarse1','coarse2','state2','baseline2'):
  for action,label in (('run','RUN'),('retrieve','GET')):
   print(action,case,flush=True)
   with(HERE/(label+'-'+case+'.log')).open('x')as log:
    subprocess.run([sys.executable,str(HERE/'action.py'),str(HERE/'context.local.json'),action,'--case',case],stdout=log,stderr=subprocess.STDOUT,check=True)
   assert json.loads((HERE/'timings'/(action+'-'+case+'.json')).read_text())['passed']
  assert json.loads((HERE/'evidence'/('returned-'+case)/'receipt.json').read_text())['passed']
  record['completed'].append(case);path.write_text(json.dumps(record,indent=2)+'\n')
 record['passed']=True
finally:
 record['end_monotonic']=time.monotonic();path.write_text(json.dumps(record,indent=2)+'\n')
