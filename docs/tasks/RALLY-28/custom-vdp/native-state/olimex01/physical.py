"""Finite Rally NAT-HW-001 physical comparison; explicit actions, no retry or assumed custody."""
import argparse,hashlib,importlib.util,json,os,re,struct,subprocess,sys,time,urllib.request
from pathlib import Path
HERE=Path(__file__).resolve().parent;ROOT=HERE.parent;EXT=Path('/Agon/mystuff/agon-extender');ENV=Path('/Agon/mystuff/agon-dev-env')
sys.path.insert(0,str(EXT/'scripts'))
from keyboard import Client as Keys,text_events
from sdcard import Client as Metadata
from passive_serial import open_passive_serial
FAST=EXT/'agents/remote009/fast-transfer-pin-r01/sdcard_staged.py'
assert hashlib.sha256(FAST.read_bytes()).hexdigest()=='f7aa43bd05d62cc1bdc051d8ae569128766cb9ec95076bd1bb951063997683ef'
spec=importlib.util.spec_from_file_location('rally_fast',FAST);fast=importlib.util.module_from_spec(spec);spec.loader.exec_module(fast)
sha=lambda b:hashlib.sha256(b).hexdigest()
def save(p,d):
 with Path(p).open('x')as f:json.dump(d,f,indent=2);f.write('\n');f.flush();os.fsync(f.fileno())
class Bench:
 def __init__(self,context):
  self.c=json.loads(Path(context).read_text());self.out=Path(self.c['output']);self.out.mkdir(parents=True,exist_ok=True)
  self.grant=json.loads(Path(self.c['grant']).read_text());assert self.grant['owner']=='rally';self.lease=self.grant['lease']
  self.url=self.c['url'];self.port=self.c['port'];self.remote='/test/arcade/rally/native01-olimex01'
  self.package=ROOT/'hardware-kit'
  assert self.out.is_relative_to(HERE/'evidence')
  self.inventory=json.loads((HERE/'INVENTORY.json').read_text())
  for rel,digest in self.inventory['files'].items():assert sha((ROOT/rel).read_bytes())==digest,rel
 def own(self):
  subprocess.run([str(ENV/'.venv/bin/python'),str(ENV/'cross-agent/olimex-bench/bench_lease.py'),'assert-owner','--owner','rally','--lease',self.lease],check=True,stdout=subprocess.DEVNULL)
 def get(self,p):
  self.own()
  with urllib.request.urlopen(self.url+p,timeout=8)as r:return json.load(r)
 def state(self):return{k:self.get(p)for k,p in [('keyboard','/keyboard/status'),('sd','/sd/status'),('worker','/sd/fast'),('display','/display/status')]}
 def line(self,folder,label,command):
  self.own();save(folder/(label+'-issued.json'),dict(command=command,once=True,epoch=time.time()))
  c=Keys(self.url,folder/(label+'-keys.json'))
  try:
   k=c.status();assert k['ready']and k['physical_neutral']and not k['held']and not k['pending'],k;c.open(k)
   for ch in command:c.send(text_events(ch,k['locale'],k['caps']))
   c.send([(40,1),(40,0)])
   if not c.state.get('pending'):c.cancel()
  finally:c.lock.close()
 def wait_online(self,wanted,seconds=45):
  end=time.monotonic()+seconds
  while True:
   s=self.get('/sd/status')
   if bool(s['online'])==wanted and not s['pending']:return s
   if time.monotonic()>end:raise RuntimeError('Listener transition uncertain; no replay')
   time.sleep(.2)
 def metadata(self,folder,label):
  self.own();c=Metadata(self.url,folder/(label+'-metadata.json'),timeout=60);c.connect(require_fast=True);return c
 def exit(self,folder,label):
  c=self.metadata(folder,label)
  try:self.own();c.rpc(11);self.wait_online(False)
  finally:c.lock.close()
 def transfer(self,folder,label,op,remote,local):
  self.own();c=fast.Client(self.url,folder/(label+'-staged.json'),timeout=300)
  try:r=c.begin(op,remote,source=local if op=='put'else None,destination=local if op=='get'else None,activate=op=='put');save(folder/(label+'-result.json'),r);return r
  finally:c.close()
 def folder(self,name):p=self.out/name;p.mkdir(exist_ok=False);return p
 def entry(self):
  p=self.folder('entry');s=self.state();save(p/'before.json',s)
  assert not s['sd']['online']and not s['sd']['pending']and s['worker']['phase']==0
  self.own();captured=bytearray()
  with open_passive_serial(self.port,baudrate=115200,timeout=.2)as serial:
   self.line(p,'mirror','VDU 2');self.line(p,'dir','DIR')
   deadline=time.monotonic()+15
   while time.monotonic()<deadline:
    data=serial.read(8192)
    if data:captured.extend(data)
    if b'Directory:'in captured and b' *'in captured:break
  (p/'entry-cli.bin').write_bytes(captured)
  match=re.search(rb'Directory: ([^\r\n]+)',captured);assert match,captured
  (p/'cwd.txt').write_text(match[1].decode().strip())
  self.line(p,'mode-query','VDU 23 0 134')
  self.line(p,'listener','EMOS sdserve --fast /');self.wait_online(True)
  for remote,name,digest in[('/autoexec.txt','autoexec.txt','9e97ceae5489e1b6330c6a2f207d95c6566c60cac304d65e7aad54b610a5b423'),('/emos/sdserve.bin','sdserve.bin','0566e17f18747c2e625d2450ce5324a2b1097bce323a5e4d70fad6dcb41cdff2')]:
   self.transfer(p,name,'get',remote,p/name);assert sha((p/name).read_bytes())==digest
  c=self.metadata(p,'dirs')
  try:
   c.make_directory('/test/arcade/rally',parents=True)
   assert not any(x[0].lower()==self.remote.lower()for x in c.entries('/test/arcade/rally'))
   c.make_directory(self.remote,parents=True)
  finally:c.lock.close()
  batch=p/'save-entry.txt';batch.write_text('SAVE '+self.remote+'/entry-mode.bin &BC349 &1\nEMOS sdserve --fast /\n')
  self.transfer(p,'save-entry-script','put',self.remote+'/save-entry.txt',batch)
  self.exit(p,'exit-before-mode-save');self.line(p,'save-entry','EXEC '+self.remote+'/save-entry.txt');self.wait_online(True)
  self.transfer(p,'mode','get',self.remote+'/entry-mode.bin',p/'mode.bin');assert len((p/'mode.bin').read_bytes())==1
  assert not ((p/'mode.bin').read_bytes()[0]&128),'Unsupported double-buffered suite entry'
  save(p/'receipt.json',dict(actual_cli_read=True,startup_listener_verified=True,listener_online=True,entry_mode=(p/'mode.bin').read_bytes()[0],entry_cwd=(p/'cwd.txt').read_text()))
 def stage(self):
  p=self.folder('stage')
  c=self.metadata(p,'dirs')
  try:
   for case in self.inventory['order']:c.make_directory(self.remote+'/'+case,parents=True)
  finally:c.lock.close()
  for case in self.inventory['order']:
   arm=case[:-1];source=self.package/arm
   for i,n in enumerate(self.inventory['arm_files'][arm]):
    local=source/n;remote=self.remote+'/'+case+'/'+n
    self.transfer(p,f'{case}-put-{i:02}','put',remote,local)
    read=p/f'{case}-read-{i:02}.bin';self.transfer(p,f'{case}-get-{i:02}','get',remote,read)
    assert read.read_bytes()==local.read_bytes(),remote
   run=p/(case+'-run.txt');run.write_text('CD '+self.remote+'/'+case+'\nLOAD probe.bin\nRUN .\nEMOS sdserve --fast /\n')
   self.transfer(p,case+'-script','put',self.remote+'/'+case+'/invoke.txt',run)
  for case in self.inventory['order']:
   mode=p/(case+'-verify-mode.txt');mode.write_text('SAVE '+self.remote+'/'+case+'/current-mode.bin &BC349 &1\nEMOS sdserve --fast /\n');self.transfer(p,case+'-mode-script','put',self.remote+'/'+case+'/verify-mode.txt',mode)
  self.exit(p,'exit');save(p/'receipt.json',dict(passed=True,cases=self.inventory['order'],application_invoked=False))
 def flash(self,action):
  self.own();assert not self.get('/sd/status')['online'];assert self.get('/sd/fast')['phase']==0
  r=subprocess.run(['fuser',str(Path(self.port).resolve())],capture_output=True);assert r.returncode==1,r.stdout
  p=self.folder(action);prefix=[str(EXT/'.venv/bin/python'),'-m','esptool','--chip','esp32','--port',self.port,'--baud','115200','--after','hard-reset']
  def cmd(args,label):
   self.own();save(p/(label+'-issued.json'),dict(args=args,once=True,epoch=time.time()))
   with(p/(label+'.log')).open('x')as log:subprocess.run(prefix+args,stdout=log,stderr=subprocess.STDOUT,check=True,timeout=900)
  if action=='backup':
   cmd(['read-flash','--flash-size','detect','--no-progress','0','0x400000',str(p/'full.bin')],'read')
   full=(p/'full.bin').read_bytes();assert len(full)==0x400000 and sha(full)=='17caa5b0b2ede84bb627e207f10994b13dd3abfa2d04fc807ec393414fe33378'
   # ESP-IDF partition table entries32B, magic0x50AA, native app selection.
   parts=[]
   for at in range(0x8000,0x9000,32):
    magic,kind,sub,offset,size,label,flags=struct.unpack('<HBBII16sI',full[at:at+32])
    if magic!=0x50aa:break
    parts.append(dict(kind=kind,subtype=sub,offset=offset,size=size,label=label.rstrip(b'\0').decode()))
   selected=[x for x in parts if x['kind']==0 and x['offset']==0x150000];assert len(selected)==1,parts
   candidate=Path(self.c['firmware']).read_bytes();assert len(candidate)==1094384 and sha(candidate)=='a50eb23acf6b3edfb44d3c1bb44858a213be696d68c06a696da7767170ac6f9a'
   assert sha(full[0x150000:0x150000+1094512])=='8ade1e7dbc8b82cfbb20bfc92bdeb02e909c38c9f93c37723f9c9d409a9af7c4'
   span=(len(candidate)+4095)&~4095;assert span==1097728 and span<=selected[0]['size']
   composed=candidate+full[0x150000+len(candidate):0x150000+span]
   (p/'install.bin').write_bytes(composed);(p/'restore.bin').write_bytes(full[0x150000:0x150000+span]);expected=bytearray(full);expected[0x150000:0x150000+span]=composed;(p/'expected.bin').write_bytes(expected)
   save(p/'verified.json',dict(passed=True,full_sha256=sha(full),parts=parts,span=span,offset=0x150000))
  else:
   b=self.out/'backup';assert json.loads((b/'verified.json').read_text())['passed'];image=b/('install.bin'if action=='install'else'restore.bin');expected=(b/('expected.bin'if action=='install'else'full.bin')).read_bytes()
   cmd(['write-flash','--flash-mode','keep','--flash-freq','keep','--flash-size','keep','0x150000',str(image)],'write')
   cmd(['read-flash','--flash-size','detect','--no-progress','0','0x400000',str(p/'full.bin')],'read')
   assert(p/'full.bin').read_bytes()==expected
   save(p/'verified.json',dict(passed=True,full_sha256=sha(expected),outside_app_unchanged=True,original_exact=action=='restore'))
  print(action,'verified',flush=True)
 def capture_until(self,serial,raw,folder,predicate,seconds):
  end=time.monotonic()+seconds
  while time.monotonic()<end:
   data=serial.read(8192)
   if data:raw.extend(data);(folder/'serial.bin').write_bytes(raw)
   text=raw.decode(errors='replace')
   if any(x in text for x in ('Guru Meditation','Error executing','FULL RACE FAILED')):raise RuntimeError('Failure; stop dispatch, preserve raw capture')
   if predicate(raw):return
  raise RuntimeError('Observation bound reached; no automatic replay or next case')
 def run(self,case):
  assert case in self.inventory['order']
  index=self.inventory['order'].index(case)
  if index:assert json.loads((self.out/('returned-'+self.inventory['order'][index-1])/'receipt.json').read_text())['passed']
  p=self.folder('run-'+case);self.own();assert not self.get('/sd/status')['online'];assert(self.out/'install/verified.json').exists()
  began=time.monotonic();raw=bytearray()
  with open_passive_serial(self.port,baudrate=115200,timeout=.2)as serial:
   self.line(p,'mirror','VDU 2');self.line(p,'sentinel','VDU 82 65 76 76 89 72 87 13 10')
   self.capture_until(serial,raw,p,lambda b:b'RALLYHW'in b,20)
   # Set mode at CLI, then query the actual native screen byte through MOS SAVE.
   # The separate prepared command file sequences SAVE before listener entry.
   self.line(p,'mode','VDU 22 136')
   time.sleep(2)
   self.line(p,'mode-save','EXEC '+self.remote+'/'+case+'/verify-mode.txt')
   self.wait_online(True)
   self.transfer(p,'mode-read','get',self.remote+'/'+case+'/current-mode.bin',p/'mode.bin')
   assert(p/'mode.bin').read_bytes()==bytes([136]),'Native mode admission failed'
   self.exit(p,'mode-exit');time.sleep(1)
   self.line(p,'invoke','EXEC '+self.remote+'/'+case+'/invoke.txt')
   self.capture_until(serial,raw,p,lambda b:b'RALLY-28 FULL RACE DONE: logs saved.'in b and self.get('/sd/status')['online'],180)
   save(p/'receipt.json',dict(passed=True,case=case,seconds=time.monotonic()-began,application_invocations=1,listener_online=True,serial_mirror=True,mode136_verified=True))
 def retrieve(self,case):
  p=self.folder('returned-'+case);source=self.package/case[:-1]
  for n in self.inventory['outputs']:self.transfer(p,n,'get',self.remote+'/'+case+'/'+n,p/n)
  (p/'expected.json').write_bytes((source/'expected.json').read_bytes())
  # Guest-only exact state/reply/timer checker; no fabricated emulator UART log.
  spec=importlib.util.spec_from_file_location('rally_hw_verify',ROOT/'verify.py');mod=importlib.util.module_from_spec(spec);spec.loader.exec_module(mod)
  result=mod.verify(p);assert result['frames']==900 and result['retained_replies']==2025
  self.exit(p,'exit');save(p/'receipt.json',dict(passed=True,case=case,raw_verified=True,physical_clocks_uncalibrated=True))
 def handback(self):
  p=self.folder('handback');assert json.loads((self.out/'restore/verified.json').read_text())['original_exact']
  # Flash reboot completed into preserved setup-only startup; proof through actual service.
  self.line(p,'start','EMOS sdserve --fast /');self.wait_online(True)
  for n,remote in[('autoexec.txt','/autoexec.txt'),('sdserve.bin','/emos/sdserve.bin')]:
   self.transfer(p,n,'get',remote,p/n);assert(p/n).read_bytes()==(self.out/'entry'/n).read_bytes()
  self.exit(p,'exit')
  entry_mode=(self.out/'entry/mode.bin').read_bytes()[0]
  if entry_mode!=0:self.line(p,'entry-mode','VDU 22 '+str(entry_mode));time.sleep(2.5)
  # New grant detail: verify native restored mode through SAVE/GET, not P4 status.
  self.line(p,'mode-listener','EMOS sdserve --fast /');self.wait_online(True)
  script=p/'verify-handback-mode.txt';script.write_text('SAVE '+self.remote+'/handback-mode.bin &BC349 &1\nEMOS sdserve --fast /\n')
  self.transfer(p,'mode-script','put',self.remote+'/verify-handback-mode.txt',script)
  self.exit(p,'mode-script-exit');self.line(p,'mode-save','EXEC '+self.remote+'/verify-handback-mode.txt');self.wait_online(True)
  self.transfer(p,'mode-read','get',self.remote+'/handback-mode.bin',p/'mode.bin')
  assert(p/'mode.bin').read_bytes()==(self.out/'entry/mode.bin').read_bytes(),'Native entry mode not restored'
  self.exit(p,'mode-exit');self.line(p,'cwd','CD '+(self.out/'entry/cwd.txt').read_text())
  self.line(p,'cursor','VDU 4 23 1 1 23 1 3');self.line(p,'mirror-off','VDU 3')
  s=self.state();save(p/'state.json',s);k=s['keyboard'];assert k['ready']and k['physical_neutral']and not k['held']and not k['pending'];assert not s['sd']['online']and not s['sd']['pending']and s['worker']['phase']==0
  for port in self.c['ports']:
   result=subprocess.run(['fuser',str(Path(port).resolve())],capture_output=True);assert result.returncode==1,result.stdout
  components=self.c['components'];assert components['native_vdp_sha256']=='8ade1e7dbc8b82cfbb20bfc92bdeb02e909c38c9f93c37723f9c9d409a9af7c4'
  obs=dict(schema='olimex-bench-observation-v1',bench='olimex',epoch=time.time(),observer='rally',lease=self.lease,checks={k:True for k in('no_workload','no_transfer','no_serial_readers','no_reset_holders','cli_verified','input_ready_neutral','listener_offline','staged_job_idle','restoration_verified')},evidence=[str(p/'state.json'),str(self.out/'restore/verified.json'),str(self.out/'entry/receipt.json')],components=components,component_provenance={k:('Fresh full-flash compare exact original17caa/application8ade'if k=='native_vdp_sha256'else'Fresh complete file comparison at handback'if k in('startup_sha256','listener_sha256')else'Retained verified incoming grant; never modified by Rally')for k in components},disposition='Finite six-case Rally comparison; exact incoming native full flash restored; P4/EMOS/startup/listener unchanged; actual listener read/EXIT, cwd/cursor commands, neutral input/idle workers/free USB. No optical/audio qualification.')
  save(p/'observation.json',obs);print('Restored native/CLI/input/resources ready for central release.',flush=True)
if __name__=='__main__':
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('context');p.add_argument('action',choices=('entry','stage','backup','install','run','retrieve','restore','handback'));p.add_argument('--case');a=p.parse_args();b=Bench(a.context)
 if a.action in('backup','install','restore'):b.flash(a.action)
 elif a.action in('run','retrieve'):getattr(b,a.action)(a.case)
 else:getattr(b,a.action)()
