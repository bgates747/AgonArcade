"""Pi finite-suite coordinator. No reset, startup writes, flash or automatic replay."""
from pathlib import Path
import argparse,hashlib,json,os,subprocess,time,uuid,fcntl
CAPS={'fresh-mode','resident-foreground','peer-boot-identities','cli-handback','input-pins','readonly-startup','completion','persistent-notification'}
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
def save(p,value):
 p=Path(p);p.parent.mkdir(parents=True,exist_ok=True);tmp=p.with_suffix('.tmp')
 with tmp.open('w') as f:json.dump(value,f,indent=2);f.write('\n');f.flush();os.fsync(f.fileno())
 tmp.replace(p)
def validate(plan):
 assert plan['schema']==1 and plan['settle_seconds']>=1 and plan['jobs']
 for job in plan['jobs']:
  assert job['directory'].startswith('/test/arcade/rally/') and '..' not in job['directory'].split('/')
  for name,h in job['inputs'].items():assert Path(name).name==name and sha(Path(job['package'])/name)==h
 assert len({j['id'] for j in plan['jobs']})==len(plan['jobs'])
class Coordinator:
 def __init__(self,plan,transport,out,clock=time.monotonic,sleep=time.sleep):self.plan=plan;self.transport=transport;self.out=Path(out);self.clock=clock;self.sleep=sleep;self.seq=0;self.run_id=str(uuid.uuid4());self.baseline=None;self.current=None;self.journal=[];self.safe=False
 def call(self,action,**data):
  self.safe=False;self.seq+=1;req=dict(schema=1,run_id=self.run_id,sequence=self.seq,action=action,**data);self.journal.append({'intent':req});save(self.out/'journal.json',self.journal)
  reply=self.transport(req)
  assert all(reply.get(k)==req[k] for k in ('schema','run_id','sequence','action')),'Mismatched receipt'
  s=reply['snapshot'];self.current=s;assert s['fresh'] and s['epochs']['agon'] and s['epochs']['p4']
  assert len(s['startup_sha256'])==64 and set(s['modes'])=={'mb','ext'}
  for m in s['modes'].values():assert 0<=m['number']<128 and all(m[k]>0 for k in ('width','height','colours')),'Unsupported entry mode'
  if self.baseline:assert s['epochs']==self.baseline['epochs'] and s['startup_sha256']==self.baseline['startup_sha256'],'Reset/startup changed; dispatch stopped'
  assert s.get('runtime')==self.plan['runtime'],'Wrong runtime pin'
  self.safe=s['foreground']=='cli' and s['cli_visible'];self.journal[-1]['receipt']=reply;save(self.out/'journal.json',self.journal);return reply
 def idle(self):assert self.current['foreground']=='cli' and self.current['cli_visible'],'CLI handback unverified'
 def settle(self):
  end=self.clock()+self.plan['settle_seconds']
  while self.clock()<end:self.sleep(end-self.clock())
 def select(self,target,mode):
  self.idle()
  if self.current['route']!=target:self.call('select_route',target=target,command='EMOS '+('LEGACY' if target=='mb' else 'EXCOM')+' --keep-display');self.idle();assert self.current['route']==target
  if self.current['modes'][target]!=mode:
   self.call('select_mode',target=target,mode=mode,command='VDU 22 '+str(mode['number']));self.idle();assert self.current['modes'][target]==mode;self.settle()
  self.call('snapshot');self.idle();assert self.current['route']==target and self.current['modes'][target]==mode
 def run(self):
  validate(self.plan);assert self.plan['ready'] and self.plan['adapter']['qualified'],'Unqualified plan/adapter: no operations'
  self.out.mkdir(parents=True,exist_ok=False);error=None;completed=[];restored=False
  try:
   r=self.call('snapshot');self.safe=False;assert CAPS<=set(r['capabilities']);self.safe=True;self.idle();self.baseline=json.loads(json.dumps(self.current))
   for j in self.plan['jobs']:
    self.select('mb',dict(number=8,width=320,height=240,colours=64))
    before=json.loads(json.dumps(self.current));cue=self.call('notify',targets=['mb','ext'],outcome='starting',job=j['id']);self.idle();assert set(cue['shown_targets'])=={'mb','ext'} and self.current['modes']==before['modes'] and self.current['route']==before['route']
    r=self.call('launch',job=j,commands=['CD '+j['directory'],'LOAD '+j['binary'],'RUN .']);assert r['accepted_job']==j['id']
    r=self.call('completion',job=j,timeout_seconds=j['timeout_seconds']);self.idle();assert r['job_id']==j['id'] and r['inputs_verified'] and r['returned']
    assert r['fixture_sha256']==j['inputs'][j['binary']]
    directory=Path(r['artifact'])
    required={'summary.txt','done.txt','lifecycle.txt','state.csv'} if j.get('kind')=='physics' else {'summary.txt','done.txt','frames.csv'}
    assert required<=set(r['outputs']),'Missing output hashes'
    for name,h in r['outputs'].items():assert Path(name).name==name and sha(directory/name)==h
    from verify_results import verify
    verify(Path(r['artifact']),j)
    completed.append(j['id']);save(self.out/'completed.json',completed)
  except (Exception,KeyboardInterrupt) as e:error=str(e) or type(e).__name__
  # Epoch/startup or uncertain foreground forbids any recovery/extra input.
  safe=self.safe and self.baseline and self.current and self.current['epochs']==self.baseline['epochs'] and self.current['startup_sha256']==self.baseline['startup_sha256'] and self.current['foreground']=='cli' and self.current['cli_visible']
  if safe:
   try:
    for target in ('mb','ext'):self.select(target,self.baseline['modes'][target])
    if self.current['route']!=self.baseline['route']:self.call('select_route',target=self.baseline['route'],command='EMOS '+('LEGACY' if self.baseline['route']=='mb' else 'EXCOM')+' --keep-display')
    self.call('snapshot');self.idle();assert self.current['modes']==self.baseline['modes'] and self.current['route']==self.baseline['route'];cue=self.call('notify',targets=['mb','ext'],outcome='failed' if error else 'complete');self.idle();assert set(cue['shown_targets'])=={'mb','ext'} and self.current['modes']==self.baseline['modes'] and self.current['route']==self.baseline['route'];restored=True
   except (Exception,KeyboardInterrupt) as e:error=(error or '')+'; restoration '+str(e)
  save(self.out/'result.json',{'completed':completed,'restored':restored,'error':error,'hardware_pass':not error and restored});return not error and restored
class Adapter:
 def __init__(self,plan):self.a=plan['adapter']
 def __call__(self,request):
  assert self.a['qualified']
  for p,h in self.a['inputs'].items():assert sha(p)==h
  r=subprocess.run(self.a['argv'],input=json.dumps(request),text=True,capture_output=True,timeout=request.get('timeout_seconds',30),check=True)
  return json.loads(r.stdout)
if __name__=='__main__':
 a=argparse.ArgumentParser();a.add_argument('plan',type=Path);a.add_argument('--check',action='store_true');a.add_argument('--output',type=Path);x=a.parse_args();p=json.loads(x.plan.read_text());validate(p)
 if x.check:print('Plan/input hashes valid; ready='+str(p['ready'])+'; no adapter invoked')
 else:
  assert x.output and p['ready'] and p['adapter']['qualified']
  with open(p['bench_lock'],'a') as lock:
   fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB);raise SystemExit(0 if Coordinator(p,Adapter(p),x.output).run() else 1)
