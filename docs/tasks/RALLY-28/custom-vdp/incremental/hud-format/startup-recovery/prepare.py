"""Prepare original-guest startup plus one frame; no target or peer mutation."""
from pathlib import Path
import argparse,ctypes as C,hashlib,json,os,shutil,struct,subprocess,sys
HERE=Path(__file__).resolve().parent
HUD=HERE.parent;CONTROL=HUD.parent/'round-trips';CUSTOM=HUD.parents[1]
ROOT=CUSTOM.parents[3];WORK=HERE/'.work'
sys.path.insert(0,str(CUSTOM/'full-race'))
from host_reference import SpriteRuntime,specification,snapshot,independent,Traffic,BASE
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()

def write(path,data):
    path.parent.mkdir(parents=True,exist_ok=True)
    if path.exists():assert path.read_bytes()==data,('Preserve existing file',str(path))
    else:path.write_bytes(data)

def worker(mode):
    package=CONTROL/'.work/package'
    runtime=SpriteRuntime(specification(package),WORK/('reference-'+mode+'.so'))
    assert runtime.invoke('InitRace')==0
    for _ in range(2):assert runtime.invoke('Render30')==0
    tables=json.loads((BASE/'reference/tables.json').read_text())
    model=Traffic(tables,'circuit',3276800,1,99);player=3246800
    for car,gap in zip(model.cars,[0,3199,3200,6400,18000,80000]):
        car.active=1;car.progress=player+gap;car.position=car.progress%model.lap;car.lateral=0
    for tick in range(1,5):
        record=(model.pace.record+1)%6 if model.pace.remaining==0 else model.pace.record
        player+=tables['records'][record][1]*2;model.advance(player,tick)
        assert runtime.invoke('Tick120')==0;independent(runtime,model,player,tick)
    source=HUD/'fixtures-smoke60/control'
    metadata=json.loads((source/'expected.json').read_text())
    row=(source/'motion.bin').read_bytes()[:24]
    expected_positions=[]
    for slot in range(6):
        phase=slot*47%300;gap=110000-phase*450 if slot<3 else -24550+phase*450
        expected_positions.append((player+gap)%model.lap)
    assert struct.unpack('<6I',row)==tuple(expected_positions)
    lanes=struct.pack('<6i',*metadata['fixed_display_lanes'])
    runtime.store(4,0,row);runtime.store(5,0,lanes)
    assert runtime.invoke('Render30')==0
    final=snapshot(runtime);root=bytes.fromhex(final['1'])
    assert struct.unpack_from('<I',root,20)[0]==8
    assert struct.unpack_from('<I',root,296)[0]==3
    assert struct.unpack_from('<I',root,136)[0]==4
    assert struct.unpack_from('<I',root,198)[0]==3248240
    assert struct.unpack_from('<H',root,304)[0]==240
    assert runtime.invoke('StopRace')==runtime.invoke(operation=3)==0
    runtime.canaries();assert not runtime.live and runtime.grants==runtime.releases
    result=dict(passed=True,mode=mode,frames=1,physics_ticks=4,warm_frames=2,final_buffers=final,
        independent_each_tick=True,accepted_motion_independently_checked=True,
        final_player=player,final_scripted_positions=expected_positions,
        source_checked_sha256=sha(package/'checked.c'),host_library_sha256=sha(WORK/('reference-'+mode+'.so')),
        peak_leases=runtime.peak,leases_balanced=True,canaries=True,performance_measurement=False)
    write(HERE/('HOST-'+mode+'.json'),(json.dumps(result,indent=2)+'\n').encode())
    print('PASS startup/first-frame native reference:',mode,flush=True)

def prepare():
    WORK.mkdir(parents=True,exist_ok=True)
    build=json.loads((HUD/'BUILD.json').read_text())
    for path,h in build['preserved_control_inputs'].items():assert sha(path)==h,path
    # Freeze current HUD implementation; this task must not alter its code.
    hud_inputs={str(p):sha(p) for p in [ROOT/'rally-game/src/main.cpp',ROOT/'rally-game/include/hud_format.hpp',HUD/'guest/probe.bin']}
    write(HERE/'HUD-UNCHANGED.json',(json.dumps(hud_inputs,indent=2)+'\n').encode())
    package=CONTROL/'.work/package'
    for p in (CONTROL/'source/helper').iterdir():assert sha(p)==sha(package/'helper'/p.name),p
    assert sha(package/'checked.c')==sha(CONTROL/'source/checked.c')
    wrapper=WORK/'reference.c'
    wrapper.write_text('#include "'+str(package/'checked.c')+'"\nvoid host_actor(unsigned slot,int32_t*out){memcpy(out,slot<6?&renderer.cars[slot]:&renderer.signs[slot-6],28);}\n')
    for mode,flags in [('ordinary',[]),('sanitized',['-fsanitize=address,undefined','-fno-omit-frame-pointer'])]:
        command=['cc','-shared','-fPIC','-O1','-fno-builtin','-ffp-contract=off',*flags,
            '-I'+str(CUSTOM/'paced-road/control/sdk/include'),'-I'+str(package),str(wrapper),'-o',str(WORK/('reference-'+mode+'.so'))]
        subprocess.run(command,check=True)
        environment=dict(os.environ)
        if mode=='sanitized':environment.update(LD_PRELOAD=subprocess.check_output(['cc','-print-file-name=libasan.so'],text=True).strip(),ASAN_OPTIONS='detect_leaks=0:halt_on_error=1',UBSAN_OPTIONS='halt_on_error=1')
        subprocess.run([sys.executable,__file__,'--worker',mode],env=environment,check=True)
    ordinary=json.loads((HERE/'HOST-ordinary.json').read_text());sanitized=json.loads((HERE/'HOST-sanitized.json').read_text())
    assert ordinary['final_buffers']==sanitized['final_buffers']
    write(HERE/'EXPECTED-FINAL-1.json',(json.dumps(ordinary['final_buffers'],indent=2)+'\n').encode())
    source=HUD/'fixtures-smoke60/control';dest=HERE/'fixture'
    for p in source.iterdir():
        if p.name=='expected.json':continue
        data=p.read_bytes()
        if p.name=='config.bin':
            data=bytearray(data);struct.pack_into('<H',data,6,1);data=bytes(data)
        write(dest/p.name,data)
    assert sha(dest/'probe.bin')=='685f4b4c6bd6959aac330a5c6c361b8e86b4967656bfb049df777b5a74ae3d1d'
    metadata=json.loads((source/'expected.json').read_text())
    metadata.update(frames=1,physics_ticks=4,candidate='startup-firstframe',timing_excluded=True,
        startup_probe=True,player_final_station=3248240,final_scripted_positions=ordinary['final_scripted_positions'],
        expected_native_world_ticks=4,expected_native_generation=8,expected_render_requests=3)
    metadata['files']={p.name:sha(p) for p in dest.iterdir() if p.name!='expected.json'}
    write(dest/'expected.json',(json.dumps(metadata,indent=2)+'\n').encode())
    differences=[p.name for p in source.iterdir() if sha(p)!=sha(dest/p.name)]
    assert set(differences)=={'config.bin','expected.json'},differences
    config_differences=[i for i,(a,b) in enumerate(zip((source/'config.bin').read_bytes(),(dest/'config.bin').read_bytes())) if a!=b]
    assert config_differences==[6]
    # Keep the original verifier frozen. This distinct startup verifier permits
    # score zero after four ticks, insists on exactly one frame, and labels timing.
    verifier=(HUD/'verify.py').read_text()
    assert verifier.count("    frames = meta['frames']")==1
    verifier=verifier.replace("    frames = meta['frames']","    frames = meta['frames']\n    assert frames == 1 and meta['timing_excluded'] and meta['startup_probe']")
    assert verifier.count("int(p['score']) > 0")==1
    verifier=verifier.replace("int(p['score']) > 0","int(p['score']) == 0")
    write(HERE/'verify.py',verifier.encode())
    report=dict(passed=True,scope='Original startup + two warm pages + exactly one frame/four ticks; no performance claim',
        guest_unchanged=True,guest_sha256=sha(dest/'probe.bin'),fixture_differences=differences,
        source_fixture=str(source),config_changed_byte_offsets=config_differences,
        files={p.name:sha(p) for p in dest.iterdir()},oracle_modes_agree=True,
        runtime_selection_pending=True,target_run=False,hud_code_unchanged=hud_inputs)
    write(HERE/'PREPARATION.json',(json.dumps(report,indent=2)+'\n').encode())
    print(json.dumps({k:v for k,v in report.items() if k not in ('files','hud_code_unchanged')},indent=2))

if __name__=='__main__':
    parser=argparse.ArgumentParser();parser.add_argument('--worker');args=parser.parse_args()
    worker(args.worker) if args.worker else prepare()
