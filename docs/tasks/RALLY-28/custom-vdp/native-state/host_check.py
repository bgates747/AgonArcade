"""Actual C control/state/coarse comparison; explicit mocked framebuffer service."""
from pathlib import Path
import argparse,ctypes as C,hashlib,json,os,shutil,struct,subprocess,sys
HERE=Path(__file__).resolve().parent
DIRECT=HERE.parent/'direct-rows'
sys.path.insert(0,str(DIRECT))
from importlib.util import spec_from_file_location,module_from_spec
_spec=spec_from_file_location("rows_host_check",DIRECT/"host_check.py");_base=module_from_spec(_spec);_spec.loader.exec_module(_base)
RowsRuntime,specification,snapshot,independent,BASE,Traffic=(_base.RowsRuntime,_base.specification,_base.snapshot,_base.independent,_base.BASE,_base.Traffic)


def worker(mode):
 work=HERE/'.work/host'
 reference=RowsRuntime(specification(DIRECT/'source/rows'),work/('control-'+mode+'.so'))
 state=RowsRuntime(specification(HERE/'source'),work/('state-'+mode+'.so'))
 coarse=RowsRuntime(specification(HERE/'source'),work/('coarse-'+mode+'.so'))
 runtimes=[reference,state,coarse]
 for r in runtimes:assert r.invoke('InitRace')==0
 def compare():
  expected=snapshot(reference)
  for r in runtimes[1:]:
   actual=snapshot(r)
   if actual!=expected:
    for id,hexbytes in expected.items():
     if hexbytes!=actual[id]:
      a,b=bytes.fromhex(hexbytes),bytes.fromhex(actual[id]);raise AssertionError((id,[(i,x,y) for i,(x,y) in enumerate(zip(a,b)) if x!=y][:20]))
  for id in (50301,50302,50303,50304,*range(50710,50718)):
   assert reference.data(id)==state.data(id)==coarse.data(id),id
  rgba=bytearray()
  for row in reference.pages[reference.page]:
   raw=bytes(row[16:336]);logical=bytearray(320)
   logical[0::4],logical[1::4]=raw[2::4],raw[3::4]
   logical[2::4],logical[3::4]=raw[0::4],raw[1::4];rgba+=logical
  for r in runtimes:r.compare_road(bytes(rgba))
 for i in range(2):
  for r in runtimes:assert r.invoke('Render30')==0
  compare()
 fixture=DIRECT/'fixtures/rows900';meta=json.loads((fixture/'expected.json').read_text());motion=(fixture/'motion.bin').read_bytes()
 lanes=struct.pack('<6i',*meta['fixed_display_lanes'])
 tables=json.loads((BASE/'reference/tables.json').read_text())
 model=Traffic(tables,'circuit',3276800,1,99);player=3246800
 for car,gap in zip(model.cars,[0,3199,3200,6400,18000,80000]):car.active,car.progress,car.position,car.lateral=1,player+gap,(player+gap)%model.lap,0
 counts={k:{'ticks':[],'render':[]} for k in ('control','state','coarse')}
 for frame in range(900):
  for step in range(4):
   tick=frame*4+step+1;record=(model.pace.record+1)%6 if model.pace.remaining==0 else model.pace.record
   player+=tables['records'][record][1]*2;model.advance(player,tick)
   for name,r in [('control',reference),('state',state)]:
    before=r.acquires;assert r.invoke('Tick120')==0;counts[name]['ticks'].append(r.acquires-before)
   assert snapshot(reference)==snapshot(state),('per-step',tick)
   independent(state,model,player,tick)
  before=coarse.acquires;assert coarse.invoke(entry=17)==0;counts['coarse']['ticks'].append(coarse.acquires-before)
  assert snapshot(reference)==snapshot(coarse),('coarse',frame)
  independent(coarse,model,player,(frame+1)*4)
  data=motion[frame*24:(frame+1)*24]
  for r in runtimes:r.store(4,0,data);r.store(5,0,lanes)
  for car,pos,lat in zip(model.cars,struct.unpack('<6I',data),meta['fixed_display_lanes']):car.position,car.lateral=pos,lat
  for name,r in zip(counts,runtimes):
   before=r.acquires;assert r.invoke('Render30')==0;counts[name]['render'].append(r.acquires-before)
  compare()
 assert snapshot(state)==json.loads((DIRECT/'EXPECTED-FINAL-900.json').read_text())
 # Test root/session failure, recovery and finite row-service failures without
 # altering the accepted race workload. Each lifetime reset is explicit.
 faults=['begin','layout','null','short',('row',0),('row',59),('row',119)]
 for r in (state,coarse):
  for fault in faults:
   assert r.invoke('InitRace')==0;r.row_fault=fault
   assert r.invoke('Render30')!=0
   assert not r.active and r.begins==r.ends and not r.live
   assert struct.unpack_from('<H',r.data(50304),44)[0]==0
   r.row_fault=None
  # Stop, reinitialize in the same loaded module, generic FINI/INIT reload.
  assert r.invoke('InitRace')==0 and r.invoke('StopRace')==0
  assert r.invoke(operation=3)==0
  assert r.invoke('Tick120')!=0
  assert r.invoke(operation=1)==0 and r.invoke('InitRace')==0
  assert r.invoke('Tick120')==0
  root=bytearray(r.data(1));struct.pack_into('<I',root,8,8);r.store(1,0,bytes(root))
  assert r.invoke('Tick120')!=0
  struct.pack_into('<I',root,8,7);r.store(1,0,bytes(root))
  assert r.invoke('InitRace')==0
  for entry in set(range(17))-{3,13,15,16}:assert r.invoke(entry=entry)!=0
 for r in runtimes:
  assert r.invoke('StopRace')==r.invoke(operation=3)==0
  assert not r.live and r.grants==r.releases;r.canaries()
 totals={}
 for name,c in counts.items():
  total=sum(c['ticks'])+sum(c['render']);totals[name]={'pairs_per_900_frames':total,'mean_pairs_per_frame':total/900,'tick_min':min(c['ticks']),'tick_max':max(c['ticks']),'render_min':min(c['render']),'render_max':max(c['render'])}
 result=dict(passed=True,mode=mode,frames=900,physics_ticks=3600,warm_frames=2,exact_per_step_state=True,coarse_group_state_exact=True,independent_world_each_tick=True,full_road_pixels=902*38400,both_pages_and_sync=True,actor_command_completion_bytes_exact=True,service_counts=totals,row_faults=list(map(str,faults)),reload_stop_session_checks=True,max_live_views=max(r.peak for r in runtimes),limitation='Mocked row service, not target Canvas or FPS evidence')
 (HERE/('HOST-'+mode+'.json')).write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))


def build():
 work=HERE/'.work/host';work.mkdir(parents=True,exist_ok=True)
 for mode in ('ordinary','sanitized'):
  for name in ('control','state','coarse'):
   src=DIRECT/'source/rows/checked.c' if name=='control' else HERE/'source/checked.c'
   export=work/(name+'.c');export.write_text('#include "'+str(src)+'"\nvoid host_actor(unsigned n,int32_t*out){memcpy(out,n<6?&renderer.cars[n]:&renderer.signs[n-6],28);}\n')
   flags=[] if mode=='ordinary' else ['-fsanitize=address,undefined','-fno-omit-frame-pointer']
   run=subprocess.run(['cc','-shared','-fPIC','-O1','-fno-builtin','-ffp-contract=off',*flags,'-I'+str(DIRECT/'sdk/include'),str(export),'-o',str(work/(name+'-'+mode+'.so'))],text=True,capture_output=True,timeout=180)
   (HERE/('COMPILE-'+name+'-'+mode+'.txt')).write_text(run.stdout+run.stderr)
   if run.returncode:print(run.stdout+run.stderr);raise SystemExit(run.returncode)
  env=dict(os.environ)
  if mode=='sanitized':env.update(LD_PRELOAD=subprocess.check_output(['cc','-print-file-name=libasan.so'],text=True).strip(),ASAN_OPTIONS='detect_leaks=0:halt_on_error=1',UBSAN_OPTIONS='halt_on_error=1')
  r=subprocess.run([sys.executable,__file__,'--worker',mode],env=env,text=True,capture_output=True,timeout=180)
  (HERE/('HOST-'+mode+'.txt')).write_text(r.stdout+r.stderr);print(r.stdout+r.stderr)
  if r.returncode:raise SystemExit(r.returncode)

if __name__=='__main__':
 p=argparse.ArgumentParser();p.add_argument('--worker');a=p.parse_args()
 worker(a.worker) if a.worker else build()
