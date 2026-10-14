"""Build independent oracle and actual-source/helper host scene integration."""
import ast,hashlib,json,os,shutil,struct,subprocess,sys,time
from pathlib import Path
HERE=Path(__file__).resolve().parent;BASE=HERE.parent;ROOT=HERE.parents[3];WORK=BASE/'.work/scene-replay';SDK=ROOT.parent/'agon-vdplet'
sys.path.insert(0,str(BASE/'generated-state'))
from adapter import Interface
from pipeline import H

def sha(data):return hashlib.sha256(data).hexdigest()
def dump(name,data):(HERE/name).write_text(json.dumps(data,indent=2)+'\n')
def decode(data):
    at=0;frames=[]
    while at<len(data):
        assert at+24<=len(data);header=struct.unpack_from('<6I',data,at);at+=24;lists=[]
        for n in header[:3]:assert n<=20480 and at+n<=len(data);lists.append(data[at:at+n]);at+=n
        frames.append((header,lists))
    assert at==len(data);return frames

def prepare():
    WORK.mkdir(parents=True,exist_ok=True)
    manifests={}
    for relative in ['reference/handoff-manifest-v2.json','renderer-prep/MANIFEST.json','renderer-helper/MANIFEST.json','integration-harness/MANIFEST.json','generated-state/MANIFEST.json','route-kernels/MANIFEST.json']:
        p=BASE/relative;raw=p.read_bytes();m=json.loads(raw)
        for row in m['files']:
            data=(ROOT/row['path']).read_bytes();assert len(data)==row['bytes'] and sha(data)==row['sha256'],row['path']
        manifests[relative]=sha(raw)
    pin=ROOT.parent/'golem/docs/tasks/GOLEM-036/right-shift/delivery/f78de85c7decc6a0';assert sha((pin/'bundle.json').read_bytes())=='f78de85c7decc6a056d9450dd7ea2b3aca47733b9919c121bb0c47cfd720f600'
    closure=WORK/'compiler-source'
    for filename,meta in json.loads((pin/'bundle.json').read_text())['files'].items():
        data=(pin/filename).read_bytes();assert sha(data)==meta['sha256'] and len(data)==meta['bytes']
        if filename.startswith('source/'):
            dest=closure/filename.removeprefix('source/');dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes(data)
    compiler=WORK/'compiler';subprocess.run(['g++','-std=c++17','-O2','-Wall','-Wextra','-Werror',str(closure/'docs/tasks/GOLEM-036/right-shift/compiler.cpp'),'-o',str(compiler)],check=True)
    bindings=json.loads((BASE/'generated-state/bindings.json').read_text());packages={};fieldmaps={}
    for name in ('default','relocated'):
        directory=WORK/name;directory.mkdir(exist_ok=True);mapping=bindings[name];command=[str(compiler),str(BASE/'route-kernels/kernels.golem'),str(directory),str(mapping['prefix'])]
        for row in mapping['bindings']:command+=['--bind',*map(str,row)]
        for array in ('routes','sine'):command+=['--array-data',array+'='+str(BASE/'route-kernels'/(array+'.bin'))]
        subprocess.run(command,check=True,capture_output=True);spec=Interface(directory)
        old=json.loads((BASE/'route-kernels/RESULTS.json').read_text())['generated_artifacts'][name]
        for filename,meta in old.items():assert sha((directory/filename).read_bytes())==meta['sha256']
        from pipeline import layout
        l=layout(spec)
        fieldmaps[name]=dict(scope='actual compiler source metadata to host SceneLayout; modeled render wrapper remains separate',source_root=spec.interface['state_buffer'],root_bytes=spec.root['root_bytes'],tick_entry=spec.entries['Tick120'],
            globals={k:spec.globals[k] for k in ('worldTick','routeHeading','playerStation','playerLateral')},arrays={k:spec.arrays[k] for k in ('active','position','lateral')},host_layout_le_hex=bytes(l).hex())
        packages[name]=dict(native_c_sha256=sha((directory/'native.c').read_bytes()),interface_sha256=sha((directory/'interface.json').read_bytes()))
    dump('FIELD-MAPS.json',dict(schema=1,heading='same shared routeHeading per active slot; renderer applies alternating sign',inactive='all four renderer opponent fields zero',mappings=fieldmaps))
    # Freeze/export only reference inputs, without running published result writers.
    sys.path.insert(0,str(BASE/'reference'));from freeze import prepare as frozen_inputs
    frozen,_=frozen_inputs();oracle_source=subprocess.check_output(['git','-C',str(ROOT),'show','d250f43:docs/tasks/RALLY-24/experiment/oracle.cpp'])
    (WORK/'oracle.cpp').write_bytes(oracle_source);oracle=WORK/'oracle'
    subprocess.run(['c++','-std=c++17','-O1','-g','-ffp-contract=off','-fsanitize=address,undefined','-fno-omit-frame-pointer',str(WORK/'oracle.cpp'),'-I'+str(frozen/'rally-game/include'),'-I'+str(frozen/'rally-production/include'),'-o',str(oracle)],check=True)
    return oracle,frozen,dict(manifests=manifests,compiler_sha256=sha(compiler.read_bytes()),compiler_source_sha256=sha((closure/'docs/tasks/GOLEM-036/right-shift/compiler.cpp').read_bytes()),packages=packages,oracle_source_sha256=sha(oracle_source))

def main():
    started=time.monotonic()
    for name in ('RESULTS.json','ordinary-results.json','sanitized-results.json'):(HERE/name).unlink(missing_ok=True)
    oracle,frozen,inputs=prepare();results={};canonical=None
    for label,flags in [('ordinary',[]),('sanitized',['-g','-fsanitize=address,undefined','-fno-omit-frame-pointer'])]:
        renderlib=WORK/(label+'-render.so')
        subprocess.run(['cc','-std=c11','-O2','-Wall','-Wextra','-Werror','-ffp-contract=off','-fno-builtin','-shared','-fPIC',*flags,'-I'+str(SDK/'include'),'-I'+str(BASE/'renderer-helper'),'-I'+str(BASE/'integration-harness'),str(HERE/'bridge.c'),str(BASE/'integration-harness/integration_model.c'),str(BASE/'renderer-helper/rally_render.c'),'-o',str(renderlib)],check=True)
        rows=[]
        for name in ('default','relocated'):
            directory=WORK/name;simlib=directory/(label+'-sim.so');outdir=WORK/(label+'-'+name)
            subprocess.run(['cc','-std=c11','-O2','-Wall','-Wextra','-Werror','-ffp-contract=off','-shared','-fPIC',*flags,'-I'+str(SDK/'include'),str(directory/'native.c'),'-o',str(simlib)],check=True)
            env=os.environ.copy()
            if flags:
                env['LD_PRELOAD']=subprocess.check_output(['cc','-print-file-name=libasan.so'],text=True).strip();env['ASAN_OPTIONS']='detect_leaks=0';env['UBSAN_OPTIONS']='halt_on_error=1:print_stacktrace=1'
            print('running',label,name,flush=True)
            run=subprocess.run([str(ROOT/'.venv/bin/python'),str(HERE/'verify.py'),'--worker',str(simlib),str(renderlib),str(directory),str(outdir),label,str(int(name=='relocated'))],env=env,text=True,capture_output=True)
            if run.returncode:print(run.stdout+run.stderr,file=sys.stderr);run.check_returncode()
            assert not run.stderr,run.stderr;row=json.loads(run.stdout)
            reference=(outdir/'reference.bin').read_bytes()
            if canonical is None:
                observed=subprocess.run([str(oracle),str(frozen/'rally-production'),'fuji','B'],input=reference,capture_output=True,check=True)
                assert not observed.stderr,observed.stderr
                canonical=observed.stdout;(WORK/'oracle-commands.bin').write_bytes(canonical);(HERE/'fuji-reference.bin').write_bytes(reference)
            assert reference==(HERE/'fuji-reference.bin').read_bytes()
            actual=(outdir/'commands.bin').read_bytes();expected=decode(canonical);candidate=decode(actual);assert len(expected)==len(candidate)==900
            for frame,((header,lists),(actual_header,actual_lists)) in enumerate(zip(expected,candidate),1):
                if name=='relocated':lists=[H.remap(x,H.Resources(40,50,100,60010,60100,60001)) for x in lists]
                assert header==actual_header and lists==actual_lists,(label,name,'independent command mismatch',frame)
            row.update(mapping=name,independent_command_frames=900,sim_library_sha256=sha(simlib.read_bytes()),render_library_sha256=sha(renderlib.read_bytes()),oracle_command_sha256=sha(canonical))
            rows.append(row);print('passed',label,name,'900 command frames',len(row['failures']),'failure cases',flush=True)
        results[label]=rows;dump(label+'-results.json',dict(rows=rows))
    for i in range(2):
        for filename in results['ordinary'][i]['artifacts']:
            assert results['ordinary'][i]['artifacts'][filename]['sha256']==results['sanitized'][i]['artifacts'][filename]['sha256']
    frames=json.loads((WORK/'ordinary-default/frames.json').read_text())
    dump('REPLAY.json',dict(schema=1,scope='900 supplied snapshots/four ticks per frame, 30 simulated seconds; not real-time pacing or eZ80 physics',initial_player_progress=3276800-30000,opponent_offsets=[0,3199,3200,6400,18000,80000],
        player_lateral=0,presentation='phase=unwrapped supplied player progress modulo8000, steering0, flags3, normal profile, zero legacy counters',active_mask_change_tick=1801,renderer_only_rebind_frame=451,
        reference_file='fuji-reference.bin',reference_sha256=sha((HERE/'fuji-reference.bin').read_bytes()),frames=frames))
    own=[p for p in HERE.iterdir() if p.suffix in ('.py','.c','.h')]
    deps=[BASE/'route-kernels'/n for n in ('kernels.golem','routes.bin','sine.bin','RESULTS.json')]+[BASE/'reference'/n for n in ('model.py','tables.json')]+[BASE/'generated-state'/n for n in ('adapter.py','host.py','bindings.json')]+[BASE/'renderer-helper'/n for n in ('rally_render.h','rally_render.c','render_core.inc','asset_meta.inc','verify.py')]+[BASE/'integration-harness'/n for n in ('integration_model.h','integration_model.c','fuji/fuji.r24')]+[SDK/'include/vdplet.h']
    dump('RESULTS.json',dict(schema=1,checkpoint='90919ad',scope='actual generated simulation/helper with host-only metadata marshaling/renderer wrapper/publication; no generated D2 or target/resource/cadence qualification',inputs=inputs,results=results,
        source_sha256={p.name:sha(p.read_bytes()) for p in own},dependency_sha256={str(p.relative_to(ROOT)) if p.is_relative_to(ROOT) else str(p):sha(p.read_bytes()) for p in deps},
        total_setup_execution_host_seconds=round(time.monotonic()-started,3),field_maps_sha256=sha((HERE/'FIELD-MAPS.json').read_bytes()),replay_sha256=sha((HERE/'REPLAY.json').read_bytes())))
if __name__=='__main__':
    if len(sys.argv)==9 and sys.argv[1]=='--worker':
        from replay import worker
        print(json.dumps(worker(Path(sys.argv[2]),Path(sys.argv[3]),Path(sys.argv[4]),Path(sys.argv[5]),sys.argv[6],bool(int(sys.argv[7])))))
    elif len(sys.argv)==8 and sys.argv[1]=='--worker':
        from replay import worker
        print(json.dumps(worker(Path(sys.argv[2]),Path(sys.argv[3]),Path(sys.argv[4]),Path(sys.argv[5]),sys.argv[6],bool(int(sys.argv[7])))))
    else:main()
