"""One explicit physical action with retained monotonic duration; no chaining/retry."""
from pathlib import Path
import argparse,importlib.util,json,time,traceback
HERE=Path(__file__).resolve().parent
p=argparse.ArgumentParser();p.add_argument('context');p.add_argument('action');p.add_argument('--case');a=p.parse_args()
assert a.action in ('backup','install','run','retrieve','restore','handback')
label=a.action+('-'+a.case if a.case else '')
folder=HERE/'timings';folder.mkdir(exist_ok=True);target=folder/(label+'.json')
record=dict(action=a.action,case=a.case,start_monotonic=time.monotonic(),start_epoch=time.time(),passed=False)
with target.open('x')as f:json.dump(record,f,indent=2)
try:
 spec=importlib.util.spec_from_file_location('rallyphysical',HERE/'physical.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m);b=m.Bench(a.context)
 if a.action in ('backup','install','restore'):b.flash(a.action)
 elif a.action in ('run','retrieve'):getattr(b,a.action)(a.case)
 else:getattr(b,a.action)()
 record['passed']=True
except BaseException:
 record['error']=traceback.format_exc();raise
finally:
 record['end_monotonic']=time.monotonic();record['end_epoch']=time.time();record['elapsed_seconds']=record['end_monotonic']-record['start_monotonic']
 target.write_text(json.dumps(record,indent=2)+'\n')
