from pathlib import Path
import csv

def verify(directory,job):
 s=dict(l.split('=',1) for l in (directory/'summary.txt').read_text().splitlines() if '=' in l)
 assert (directory/'done.txt').read_text().endswith('\n')
 if job.get('kind')=='physics':
  assert s['steps']=='8192' and s['vector_restored']=='1'
  assert (directory/'lifecycle.txt').read_text()=='restored=1\n'
  # Independent state reference is verified by the package's retained capacity verifier.
  import importlib.util
  reference=Path(__file__).resolve().parents[2]/'capacity/reference.py'
  spec=importlib.util.spec_from_file_location('reference',reference);r=importlib.util.module_from_spec(spec);spec.loader.exec_module(r)
  actual={(int(a),int(b)):int(c) for a,b,c in csv.reader((directory/'state.csv').open())}
  for scenario in range(4):
   values,_=r.simulate(scenario)
   for k,v in enumerate(values):assert actual[scenario,k]==v
 else:
  assert s['failure']=='none' and s['restored']=='1' and int(s['frames'])==job['frames'] and int(s['variant'])==job['variant'] and int(s['live'])==job['live'] and int(s['diagnostic'])==job['diagnostic']
  rows=list(csv.DictReader((directory/'frames.csv').open()));assert len(rows)==job['frames']
  assert [int(r['frame']) for r in rows]==list(range(job['frames']))
  if job['diagnostic']:assert all(int(r['vdp_submit_us'])+int(r['vdp_drain_us'])==int(r['vdp_complete_us']) for r in rows)
 return True
