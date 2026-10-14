"""Reproduce actual Rally kernels with accepted exported compiler and host replay."""
import ast,hashlib,json,os,struct,subprocess,sys,time
from pathlib import Path
from delivery import HERE,ROOT,WORK,SDK,sha,verify as verify_dependencies
from adapter import Interface
from compose import source

def dump(name,value):(HERE/name).write_text(json.dumps(value,indent=2)+'\n')
def main():
    started=time.monotonic();WORK.mkdir(parents=True,exist_ok=True)
    for name in ('DEPENDENCY-RECEIPT.json','ordinary-results.json','sanitized-results.json','RESULTS.json'):(HERE/name).unlink(missing_ok=True)
    closure,dependency=verify_dependencies();compiler=WORK/'compiler'
    subprocess.run(['g++','-std=c++17','-O2','-Wall','-Wextra','-Werror',str(closure/'docs/tasks/GOLEM-036/right-shift/compiler.cpp'),'-o',str(compiler)],check=True)
    text=source();full=HERE/'kernels.golem'
    if full.exists():assert full.read_text()==text,'Regenerate kernels.golem with compose.py after editing fragments'
    else:full.write_text(text)
    tables=json.loads((HERE.parent/'reference/tables.json').read_text())
    data={'routes':struct.pack('<24h',*[v for row in tables['records'] for v in row]),'sine':struct.pack('<257h',*tables['sine'])}
    for name,value in data.items():
        p=HERE/(name+'.bin')
        if p.exists():assert p.read_bytes()==value
        else:p.write_bytes(value)
    bindings=json.loads((HERE.parent/'generated-state/bindings.json').read_text());artifacts={};maps={}
    for name in ('default','relocated'):
        directory=WORK/name;directory.mkdir(exist_ok=True);mapping=bindings[name]
        command=[str(compiler),str(full),str(directory),str(mapping['prefix'])]
        for row in mapping['bindings']:command+=['--bind',*map(str,row)]
        for array in data:command+=['--array-data',array+'='+str(HERE/(array+'.bin'))]
        subprocess.run(command,check=True,capture_output=True);spec=Interface(directory)
        assert set(spec.arrays)=={'active','progress','position','lateral','contacts','routes','sine'}
        for field,type_,count in [('active','uint16',6),('progress','sint32',6),('position','uint32',6),('lateral','sint32',6),('contacts','uint16',6),('routes','sint16',24),('sine','sint16',257)]:
            a=spec.arrays[field];assert a['type']==type_ and a['lower']==0 and a['upper']==count-1 and a['access']==(1 if field in data else 3)
        for field in data:assert spec.images[spec.arrays[field]['buffer']]==data[field]
        artifacts[name]={p.name:dict(bytes=p.stat().st_size,sha256=sha(p.read_bytes())) for p in sorted(directory.iterdir()) if p.is_file() and p.suffix in ('.json','.bin','.inc','.c')}
        repeat=WORK/('repeat-'+name);repeat.mkdir(exist_ok=True);again=command.copy();again[2]=str(repeat);subprocess.run(again,check=True,capture_output=True)
        for filename,meta in artifacts[name].items():assert sha((repeat/filename).read_bytes())==meta['sha256']
        maps[name]=dict(root_bytes=spec.root['root_bytes'],array_bytes=sum(a['bytes'] for a in spec.arrays.values()),entries=spec.entries,root_id=spec.interface['state_buffer'],array_ids={k:v['buffer'] for k,v in spec.arrays.items()})
    # Frontend domain rejection on the exact compiler, using Rally-owned scratch outputs.
    rejected=0
    for literal in ('32','65535'):
        bad=WORK/('bad-shift-'+literal+'.golem');bad.write_text(text+'Sub InvalidConstant\n signedShift = sa >> '+literal+'\nEndSub\n')
        command=[str(compiler),str(bad),str(WORK/('bad-shift-'+literal)),'0']
        for array in data:command+=['--array-data',array+'='+str(HERE/(array+'.bin'))]
        run=subprocess.run(command,text=True,capture_output=True);assert run.returncode and 'shift' in run.stderr.lower(),run.stderr;rejected+=1
    results={}
    for label,flags in [('ordinary',[]),('sanitized',['-g','-fsanitize=address,undefined','-fno-omit-frame-pointer'])]:
        rows=[]
        for name in ('default','relocated'):
            directory=WORK/name;library=directory/(label+'.so')
            command=['cc','-std=c11','-O2','-Wall','-Wextra','-Werror','-ffp-contract=off','-shared','-fPIC',*flags,'-I'+str(SDK/'include'),str(directory/'native.c'),'-o',str(library)]
            subprocess.run(command,check=True);env=os.environ.copy()
            if flags:
                env['LD_PRELOAD']=subprocess.check_output(['cc','-print-file-name=libasan.so'],text=True).strip();env['ASAN_OPTIONS']='detect_leaks=0';env['UBSAN_OPTIONS']='halt_on_error=1:print_stacktrace=1'
            print('running',label,name,flush=True)
            run=subprocess.run([str(ROOT/'.venv/bin/python'),str(HERE/'verify.py'),'--worker',str(library),str(directory),label],env=env,text=True,capture_output=True)
            if run.returncode:print(run.stdout+run.stderr,file=sys.stderr);run.check_returncode()
            assert not run.stderr,run.stderr
            row=json.loads(run.stdout);row.update(mapping=name,library_sha256=sha(library.read_bytes()),compile_command=command);rows.append(row)
            print('passed',label,name,row['total_calls'],'calls',round(row['host_seconds'],2),'host seconds',flush=True)
        results[label]=rows;dump(label+'-results.json',dict(rows=rows))
    for i in range(2):assert [g['complete_output_sha256'] for g in results['ordinary'][i]['groups']]==[g['complete_output_sha256'] for g in results['sanitized'][i]['groups']]
    own=[p for p in HERE.iterdir() if p.suffix in ('.py','.golem','.goleminc','.bin')]
    dependencies=[HERE.parent/'generated-state'/n for n in ('adapter.py','host.py','bindings.json')]+[HERE.parent/'reference'/n for n in ('model.py','tables.json','vectors.json','numeric-vectors.json')]+[SDK/'include/vdplet.h']
    result=dict(schema=1,scope='Rally-owned route/contact/motion kernels; actual generated C host qualification; no complete traffic lifecycle, renderer, scheduler, stock/Xtensa or physical qualification',checkpoint='a31c2ce',
        compiler_bundle_sha256='f78de85c7decc6a056d9450dd7ea2b3aca47733b9919c121bb0c47cfd720f600',published_compiler_commit='b32c596',compiler_executable_sha256=sha(compiler.read_bytes()),
        compiler_source_sha256=sha((closure/'docs/tasks/GOLEM-036/right-shift/compiler.cpp').read_bytes()),host_compiler=subprocess.check_output(['cc','--version'],text=True).splitlines()[0],
        repeated_generation_identical=True,invalid_constant_shift_rejections=rejected,mappings=maps,generated_artifacts=artifacts,results=results,
        source_sha256={p.name:sha(p.read_bytes()) for p in own},dependency_sha256={str(p.relative_to(ROOT)) if p.is_relative_to(ROOT) else str(p):sha(p.read_bytes()) for p in dependencies},
        dependency_receipt_sha256=sha((HERE/'DEPENDENCY-RECEIPT.json').read_bytes()),total_setup_execution_host_seconds=round(time.monotonic()-started,3))
    dump('RESULTS.json',result)
if __name__=='__main__':
    if len(sys.argv)==5 and sys.argv[1]=='--worker':
        from checks import worker
        print(json.dumps(worker(Path(sys.argv[2]),Path(sys.argv[3]),sys.argv[4])))
    else:main()
