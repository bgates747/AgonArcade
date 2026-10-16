"""Independent fake-device failure sequences; never contacts hardware."""
import json,tempfile,shutil,copy
from pathlib import Path
from coordinator import Coordinator,CAPS,sha,validate
HERE=Path(__file__).resolve().parent
class Fake:
 def __init__(self,artifact,fault=None):self.artifact=artifact;self.fault=fault;self.actions=[];self.snap={'fresh':True,'epochs':{'agon':'a','p4':'p'},'startup_sha256':'a'*64,'runtime':{'firmware':'test'},'route':'ext','modes':{'mb':{'number':0,'width':640,'height':480,'colours':16},'ext':{'number':0,'width':640,'height':480,'colours':16}},'foreground':'cli','cli_visible':True}
 def __call__(self,req):
  act=req['action'];self.actions.append(act);r={k:req[k] for k in ('schema','run_id','sequence','action')};r['capabilities']=list(CAPS)
  if act=='select_route':self.snap['route']=req['target']
  if act=='select_mode':
   if self.fault=='restore-timeout' and self.actions.count('completion')==2:raise TimeoutError('restoration outcome unknown')
   self.snap['modes'][req['target']]=req['mode']
  if act=='notify':r['shown_targets']=['mb','ext']
  if act=='launch':self.snap.update(foreground='app',cli_visible=False);r['accepted_job']=req['job']['id']
  if act=='completion':
   if self.fault=='timeout':raise TimeoutError('missing completion')
   if self.fault=='cancel':raise KeyboardInterrupt()
   self.snap.update(foreground='cli',cli_visible=True)
   j=req['job'];r.update(job_id=j['id'],inputs_verified=True,returned=True,fixture_sha256=j['inputs'][j['binary']],artifact=str(self.artifact),outputs={p.name:sha(p) for p in self.artifact.iterdir() if p.is_file()})
   if self.fault=='reset':self.snap['epochs']['agon']='changed'
   if self.fault=='startup':self.snap['startup_sha256']='b'*64
   if self.fault=='hash':r['outputs']['summary.txt']='0'*64
   if self.fault=='foreground':self.snap.update(foreground='unknown',cli_visible=False)
   if self.fault=='receipt':r['sequence']+=1
  r['snapshot']=copy.deepcopy(self.snap);return r

def main():
 checks=[]
 for fault in (None,'timeout','cancel','reset','startup','hash','foreground','receipt','unready','double-buffer','capabilities','restore-timeout'):
  with tempfile.TemporaryDirectory(prefix='rally-chain-') as tmp:
   tmp=Path(tmp);pkg=tmp/'package';pkg.mkdir();(pkg/'roadbench.bin').write_bytes(b'known');artifact=tmp/'artifact';artifact.mkdir();(artifact/'done.txt').write_text('complete\n');(artifact/'summary.txt').write_text('variant=2\nlive=1\ndiagnostic=1\nframes=1\nrestored=1\nfailure=none\n');(artifact/'frames.csv').write_text('frame,vdp_submit_us,vdp_complete_us,vdp_drain_us\n0,5,8,3\n')
   job={'id':'one','directory':'/test/arcade/rally/testcase','package':str(pkg),'inputs':{'roadbench.bin':sha(pkg/'roadbench.bin')},'binary':'roadbench.bin','frames':1,'variant':2,'live':1,'diagnostic':1,'timeout_seconds':1}
   plan={'schema':1,'ready':fault!='unready','settle_seconds':1,'adapter':{'qualified':True},'runtime':{'firmware':'test'},'jobs':[job,{**job,'id':'two'}]};fake=Fake(artifact,fault)
   if fault=='double-buffer':fake.snap['modes']['mb']['number']=136
   transport=fake
   if fault=='capabilities':
    def transport(req):r=fake(req);r['capabilities']=[];return r
   now=[0.0];co=Coordinator(plan,transport,tmp/'out',clock=lambda:now[0],sleep=lambda n:now.__setitem__(0,now[0]+n))
   try:passed=co.run()
   except AssertionError:passed=False
   assert passed==(fault is None),(fault,passed)
   if fault=='unready':assert not fake.actions
   if fault in ('reset','startup','timeout','cancel','foreground','receipt'):assert fake.actions[-1]=='completion' and fake.actions.count('launch')==1,(fault,fake.actions)
   if fault=='restore-timeout':
    assert fake.actions[-1]=='select_mode' and fake.actions.count('launch')==2
    assert not json.loads((tmp/'out/result.json').read_text())['restored']
   if fault in ('double-buffer','capabilities'):assert fake.actions==['snapshot']
   if fault is None:assert now[0]>=2 and fake.snap['route']=='ext' and fake.snap['modes']['mb']['number']==0
   checks.append({'scenario':fault or 'pass','verified':True,'actions':fake.actions})
 (HERE/'HOST-TESTS.json').write_text(json.dumps(checks,indent=2)+'\n');print(len(checks),'coordinator failure/lifecycle scenarios passed')
if __name__=='__main__':main()
