"""Compile pinned peer exports; independently qualify Rally's generated state fixture."""
import copy,hashlib,json,os,re,struct,subprocess,sys,time
from pathlib import Path
from adapter import Interface,Rejected,TYPES
from delivery import HERE,ROOT,WORK,SDK,verify as verify_deliveries,sha
from host import Runtime
from oracle import expected
REFERENCE=HERE.parent/'reference'
def dump(name,data):(HERE/name).write_text(json.dumps(data,indent=2)+'\n')
def write_word(p,off,n,fmt='H'):struct.pack_into('<'+fmt,p,off,n)

def worker(library,directory,label):
    started=time.monotonic();spec=Interface(directory);runtime=Runtime(spec,library);categories={};digest=hashlib.sha256();cases=0
    def case(entry,updates=None,category='fixture',physical=None,metadata=None,sdk_entry=None,argument_bytes=2):
        nonlocal cases
        for k,v in (updates or {}).items():runtime.put(k,v)
        if metadata:
            for off,value,n in metadata:runtime.store(runtime.root_id,off,value.to_bytes(n,'little'))
        entry_id=spec.entries[entry] if sdk_entry is None else sdk_entry
        runtime.store(runtime.root_id,28,struct.pack('<H',entry_id));before,arrays=runtime.snapshot()
        if sdk_entry is not None or argument_bytes!=2:
            wanted_root,wanted_arrays=before,arrays;wanted_rc=9 if sdk_entry is not None else 1
        elif physical:
            id,mode=physical;wanted_root=bytearray(before);wanted_arrays=arrays;wanted_rc={'missing':2,'short':3,'long':3,'busy':7}[mode]
            if id!=runtime.root_id:write_word(wanted_root,12,8)
        elif metadata:
            wanted_root=bytearray(before);wanted_arrays=arrays;wanted_rc=1
            off=metadata[0][0];status=1 if off==0 else 2 if off==2 else 4 if off==8 else 5 if off>=48 else 6 if off in (30,40,44) else 3
            write_word(wanted_root,12,status)
        else:wanted_root,wanted_arrays,wanted_rc=expected(spec,before,arrays,entry)
        runtime.fault=physical
        rc=runtime.invoke(entry,entry=entry_id,argument_bytes=argument_bytes);runtime.fault=None
        actual_root,actual_arrays=runtime.snapshot()
        assert rc==wanted_rc,(entry,category,'runtime',rc,wanted_rc)
        assert actual_root==wanted_root,(entry,category,'root',[(i,a,b) for i,(a,b) in enumerate(zip(actual_root,wanted_root)) if a!=b][:12])
        assert actual_arrays==wanted_arrays,(entry,category,'arrays')
        assert actual_root[16:20]==before[16:20],('compiler touched owner runtime_result',entry)
        digest.update(bytes(actual_root));digest.update(struct.pack('<i',rc))
        for a in spec.arrays.values():digest.update(actual_arrays[a['buffer']])
        categories[category]=categories.get(category,0)+1;cases+=1
        return rc
    # A host-owned sentinel proves the compiler never publishes transport status.
    runtime.store(runtime.root_id,16,struct.pack('<I',0x12345678))
    case('InitRace',category='lifecycle')
    for index in range(6):
        case('Render30',{'slot':index},'six-slot-read')
        for station in (0,65535,65536,3200000,3276799):
            case('StoreStation',{'slot':index,'inputStation':station,'increment':0},'six-slot-write')
        for lateral in (-38400,-14260,-1,0,1,14260,38400):
            case('StoreLateral',{'slot':index,'inputLateral':lateral,'lateralDelta':0},'six-slot-write')
        case('StoreNarrow',{'slot':index,'inputHeading':-1920+index*768,'inputActive':index%2},'six-slot-write')
        case('Render30',category='six-slot-read')
    for slot in (6,65535):
        case('Render30',{'slot':slot},'index-failure')
        case('StoreStation',{'slot':slot,'inputStation':0xffffffff,'increment':1},'index-before-overflow')
        case('StoreLateral',{'slot':slot,'inputLateral':2147483647,'lateralDelta':1},'index-before-overflow')
        case('StoreNarrow',{'slot':slot},'index-failure')
    case('StoreStation',{'slot':5,'inputStation':0xffffffff,'increment':1},'failed-store-prior-effects')
    case('StoreLateral',{'slot':0,'inputLateral':-2147483648,'lateralDelta':-1},'failed-store-prior-effects')
    for name,entry,n in [('routes','ReadRoute',24),('sine','ReadSine',257)]:
        for index in range(n):case(entry,{'tableIndex':index},'exact-table-read')
        for index in (n,65535):case(entry,{'tableIndex':index},'table-index-failure')
    for station in (0,1,65535,65536,3276799,3276800,0xffffffff):case('CheckStation',{'inputStation':station},'inclusive-bounds')
    for lateral in (-2147483648,-38401,-38400,-1,0,38400,38401,2147483647):case('CheckLateral',{'inputLateral':lateral},'inclusive-bounds')
    vectors=json.loads((REFERENCE/'numeric-vectors.json').read_text());arithmetic=conversions=deferred_conversions=0
    for v in vectors['checked_arithmetic']:
        if v['operation'] not in ('add','sub'):continue
        signed=v['type']=='sint32';entry=('Add' if v['operation']=='add' else 'Subtract')+('Signed' if signed else 'Unsigned')
        before_value=runtime.spec.get(runtime.data(runtime.root_id),'sr' if signed else 'ur')
        code=case(entry,{('sa' if signed else 'ua'):v['left'],('sb' if signed else 'ub'):v['right']},'published-arithmetic')
        value=runtime.spec.get(runtime.data(runtime.root_id),'sr' if signed else 'ur')
        assert (code!=0 and value==before_value) if 'error' in v else (code==0 and value==v['result'])
        arithmetic+=1
    for v in vectors['checked_conversions']:
        value=v['value'];type_=v['destination_type']
        if not -(1<<31)<=value<(1<<32):deferred_conversions+=1;continue
        # Negative numeric values arrive in sint32; nonnegative values in uint32.
        signed=value<0
        mapping={('sint16',True):('NarrowSigned','sa','sn'),('sint16',False):('UnsignedToNarrowSigned','ua','sn'),
                 ('uint16',True):('SignedToNarrowUnsigned','sa','un'),('uint16',False):('NarrowUnsigned','ua','un'),
                 ('sint32',False):('UnsignedToSigned','ua','sr'),('uint32',True):('SignedToUnsigned','sa','ur')}
        if (type_,signed) not in mapping:
            # Same-width representable identity: test the explicit opposite-signed cast,
            # whose destination accepts this same published value.
            mapping[(type_,signed)]=('UnsignedToSigned','ua','sr') if type_=='sint32' else ('SignedToUnsigned','sa','ur')
        entry,source,dest=mapping[(type_,signed)]
        # Same-type explicit casts exercise numeric identity at the full source width.
        if type_=='uint32' and not signed:
            entry,source,dest='IdentityUnsigned','ua','ur';updates={'ua':value}
        elif type_=='sint32' and signed:
            entry,source,dest='IdentitySigned','sa','sr';updates={'sa':value}
        else:updates={source:value}
        prior=spec.get(runtime.data(runtime.root_id),dest);code=case(entry,updates,'published-conversion' if 'Identity' not in entry else 'published-identity')
        actual=spec.get(runtime.data(runtime.root_id),dest)
        assert (code!=0 and actual==prior) if 'error' in v else (code==0 and actual==v['result'])
        conversions+=1
    for un in (0,65534,65535):
        case('WidenBefore',{'un':un},'widening-order');case('WidenAfter',{'un':un},'widening-order')
    for suffix,a,b in [('Unsigned','ua','ub'),('Signed','sa','sb')]:
        values=[0,1,65535,65536,2147483647,2147483648,4294967295] if suffix=='Unsigned' else [-2147483648,-38400,-1,0,1,38400,2147483647]
        pairs=[(v,v) for v in values]+[(values[i],values[-1-i]) for i in range(len(values))]
        for x,y in pairs:
            for op in ('Equal','NotEqual','Less','Greater','LessEqual','GreaterEqual'):
                case('Compare'+op+suffix,{a:x,b:y},'comparison')
    # Persistent updates across actual invocations; no array reinstallation.
    for _ in range(64):case('Tick120',category='persistent-tick')
    before=runtime.snapshot()
    for kind in ('native','buffered'):
        assert runtime.invoke(operation=3)==0;runtime.cleanup(kind);assert runtime.invoke(operation=1)==0
        assert runtime.snapshot()==before
        case('Render30',{'slot':5},'private-cleanup-persistence');before=runtime.snapshot()
    case('StopRace',category='lifecycle')
    case('ResetRace',{'inputStation':3276799,'inputLateral':-38400,'inputHeading':1920,'inputActive':1},'lifecycle')
    for slot in range(6):case('Render30',{'slot':slot},'reset-persistence')
    runtime.store(runtime.root_id,20,struct.pack('<I',0xffffffff));case('Tick120',category='root-generation-wrap')
    runtime.put('worldTick',0xffffffff);case('Tick120',category='tick-overflow')
    # Physical shape failures precede source effects and preserve old language status.
    runtime.store(runtime.root_id,14,struct.pack('<H',32))
    for a in spec.arrays.values():
        for mode in ('missing','short','long','busy'):case('StoreStation',{'slot':0},'physical-array',physical=(a['buffer'],mode))
    for id in spec.bindings:case('Tick120',category='physical-bound-role',physical=(id,'missing'))
    case('Tick120',category='physical-root',physical=(runtime.root_id,'short'))
    case('Tick120',category='pre-entry-rejection',sdk_entry=65535)
    case('Tick120',category='pre-entry-rejection',argument_bytes=1)
    # Each independent corrupted metadata case starts from a valid installed root.
    saved=runtime.data(runtime.root_id)
    for off,value,n in [(0,0,2),(2,2,2),(4,110,2),(6,len(saved)-2,2),(8,0,4),(26,3,2),(30,1,2),(36,len(spec.entries)+1,2),(38,len(saved)-111,2),(40,1,4),(44,0,4),(50,1,2)]:
        runtime.store(runtime.root_id,0,saved);case('Tick120',category='metadata-rejection',metadata=[(off,value,n)])
    runtime.store(runtime.root_id,0,saved)
    assert runtime.invoke(operation=3)==0
    result=dict(label=label,cases=cases,categories=categories,published_arithmetic_vectors=arithmetic,published_conversion_identity_vectors=conversions,
        deferred_outside_source_domain_conversion_inputs=deferred_conversions,peak_mock_views=runtime.peak,
        acquire_attempts=runtime.acquires,granted_leases=runtime.grants,releases=runtime.releases,leaks=0,asan_ubsan=label=='sanitized',
        full_root_array_result_sha256=digest.hexdigest(),duration_host_seconds=round(time.monotonic()-started,3))
    assert runtime.grants==runtime.releases
    return result

def malformed(directory):
    spec=Interface(directory);cases=0
    mutations=[lambda s:s.root.update(schema=2),lambda s:s.root['fields'].update(language_status=12),
        lambda s:s.interface.update(state_bytes=111),lambda s:s.interface['globals'][0].update(offset=0),
        lambda s:s.interface['globals'][1].update(offset=s.interface['globals'][0]['offset']),
        lambda s:s.interface['entries'][1].update(logical_id=0),lambda s:s.root['bindings'][0].update(access=3),
        lambda s:s.interface['arrays'][0].update(type='bool'),lambda s:s.interface['arrays'][0].update(element_bytes=2),
        lambda s:s.interface['arrays'][0].update(lower=-1),lambda s:s.interface['arrays'][0].update(upper=4),
        lambda s:s.interface['arrays'][0].update(count=5),lambda s:s.interface['arrays'][0].update(bytes=23),
        lambda s:s.interface['arrays'][0].update(offset=4294967295),lambda s:s.interface['arrays'][0].update(access=2),
        lambda s:s.interface['arrays'][0].update(owner='compiler_private'),lambda s:s.interface['arrays'][0].update(buffer=s.interface['state_buffer']),
        lambda s:s.interface['arrays'][1].update(buffer=s.interface['arrays'][0]['buffer']),lambda s:s.interface['arrays'][1].update(name=s.interface['arrays'][0]['name']),
        lambda s:s.backends['native_owned'].append(s.interface['arrays'][0]['buffer'])]
    for mutate in mutations:
        bad=copy.deepcopy(spec);mutate(bad)
        try:bad.validate()
        except (Rejected,KeyError,TypeError):cases+=1
        else:raise AssertionError('malformed metadata admitted')
    return cases

def main():
    started=time.monotonic();WORK.mkdir(parents=True,exist_ok=True)
    for n in ['DEPENDENCY-RECEIPT.json','RESULTS.json','ordinary-results.json','sanitized-results.json']:(HERE/n).unlink(missing_ok=True)
    closure,dependency=verify_deliveries();compiler=WORK/'foundation-compiler'
    subprocess.run(['g++','-std=c++17','-O2','-Wall','-Wextra','-Werror',str(closure/'docs/tasks/GOLEM-036/compiler.cpp'),'-o',str(compiler)],check=True)
    tables=json.loads((REFERENCE/'tables.json').read_text());data={'routes':struct.pack('<24h',*[v for row in tables['records'] for v in row]),'sine':struct.pack('<257h',*tables['sine'])}
    for name,value in data.items():
        p=HERE/(name+'.bin')
        if p.exists():assert p.read_bytes()==value
        else:p.write_bytes(value)
    maps=json.loads((HERE/'bindings.json').read_text());generated={};malformed_count=0
    for name in ('default','relocated'):
        directory=WORK/name;directory.mkdir(exist_ok=True);mapping=maps[name]
        command=[str(compiler),str(HERE/'fixture.golem'),str(directory),str(mapping['prefix'])]
        for row in mapping['bindings']:command+=['--bind',*map(str,row)]
        for array in data:command+=['--array-data',array+'='+str(HERE/(array+'.bin'))]
        subprocess.run(command,check=True,capture_output=True)
        spec=Interface(directory);assert set(spec.arrays)=={'stations','laterals','headings','active','routes','sine'}
        for array,type_,count in [('stations','uint32',6),('laterals','sint32',6),('headings','sint16',6),('active','uint16',6),('routes','sint16',24),('sine','sint16',257)]:
            a=spec.arrays[array];assert a['type']==type_ and a['lower']==0 and a['upper']==count-1 and a['access']==(1 if array in data else 3)
        for array in data:assert spec.images[spec.arrays[array]['buffer']]==data[array]
        expected_arrays={'stations':('I',[0,65535,65536,3200000,3276798,3276799]),
                         'laterals':('i',[-38400,-1,0,1,14260,38400]),
                         'headings':('h',[-1920,-1,0,1,1919,1920]),'active':('H',[1]*6)}
        for array,(fmt,values) in expected_arrays.items():
            assert spec.images[spec.arrays[array]['buffer']]==struct.pack('<'+str(len(values))+fmt,*values)
        declared=re.findall(r'^(uint16|sint16|uint32|sint32|bool) (\w+)(?: Bounds\([^\n]+\))? = (-?\d+|false|true)$',(HERE/'fixture.golem').read_text(),re.M)
        assert {name for _,name,_ in declared}==set(spec.globals)
        initial=spec.images[spec.interface['state_buffer']]
        for type_,field,value in declared:
            assert spec.globals[field]['type']==type_
            assert spec.get(initial,field)==({'false':0,'true':1}[value] if value in ('false','true') else int(value))
        assert spec.globals['boundedStation']['bounds']==[0,3276799] and spec.globals['boundedLateral']['bounds']==[-38400,38400]
        malformed_count+=malformed(directory)
        generated[name]={p.name:dict(bytes=p.stat().st_size,sha256=sha(p.read_bytes())) for p in sorted(directory.iterdir()) if p.is_file() and p.suffix in ('.json','.inc','.bin','.c')}
        repeat=WORK/('repro-'+name);repeat.mkdir(exist_ok=True);repeat_command=command.copy();repeat_command[2]=str(repeat)
        subprocess.run(repeat_command,check=True,capture_output=True)
        for filename,meta in generated[name].items():assert sha((repeat/filename).read_bytes())==meta['sha256'],('reproducibility',name,filename)
    results={}
    for label,flags in [('ordinary',[]),('sanitized',['-g','-fsanitize=address,undefined','-fno-omit-frame-pointer'])]:
        rows=[]
        for name in ('default','relocated'):
            directory=WORK/name;library=directory/(label+'.so')
            command=['cc','-std=c11','-O2','-Wall','-Wextra','-Werror','-ffp-contract=off','-shared','-fPIC',*flags,'-I'+str(SDK/'include'),str(directory/'native.c'),'-o',str(library)]
            subprocess.run(command,check=True);env=os.environ.copy()
            if flags:
                env['LD_PRELOAD']=subprocess.check_output(['cc','-print-file-name=libasan.so'],text=True).strip()
                env['ASAN_OPTIONS']='detect_leaks=0';env['UBSAN_OPTIONS']='halt_on_error=1:print_stacktrace=1'
            run=subprocess.run([str(ROOT/'.venv/bin/python'),str(HERE/'verify.py'),'--worker',str(library),str(directory),label],env=env,text=True,capture_output=True)
            if run.returncode:print(run.stdout+run.stderr,file=sys.stderr);run.check_returncode()
            assert not run.stderr,run.stderr
            row=json.loads(run.stdout);row.update(mapping=name,library_sha256=sha(library.read_bytes()),compile_command=command);rows.append(row)
        results[label]=rows;dump(label+'-results.json',dict(rows=rows));print(label,[(r['mapping'],r['cases'],r['peak_mock_views']) for r in rows],flush=True)
    for i in range(2):assert results['ordinary'][i]['full_root_array_result_sha256']==results['sanitized'][i]['full_root_array_result_sha256']
    sources=[p for p in HERE.iterdir() if p.suffix in ('.py','.golem','.bin') or p.name=='bindings.json']
    result=dict(schema=1,scope='actual pinned generated C, host SDK mocks and independent Rally expectations; no stock/Xtensa/renderer/firmware qualification',
        checkpoint='4489f58',foundation_bundle_sha256='94e72ff56649079472a59b33ae9ba1514b49dcb5c8c919ace369de6e46fb2c6a',
        compiler_executable_sha256=sha(compiler.read_bytes()),compiler_source_sha256=sha((closure/'docs/tasks/GOLEM-036/compiler.cpp').read_bytes()),
        host_compiler=subprocess.check_output(['cc','--version'],text=True).splitlines()[0],
        malformed_metadata_rejections=malformed_count,repeated_generation_identical=True,results=results,generated_artifacts=generated,
        source_sha256={p.name:sha(p.read_bytes()) for p in sources},reference_sha256={p.name:sha(p.read_bytes()) for p in [REFERENCE/'tables.json',REFERENCE/'numeric-vectors.json']},
        total_setup_execution_host_seconds=round(time.monotonic()-started,3),dependency_receipt_sha256=sha((HERE/'DEPENDENCY-RECEIPT.json').read_bytes()))
    dump('RESULTS.json',result)
if __name__=='__main__':
    if len(sys.argv)==5 and sys.argv[1]=='--worker':print(json.dumps(worker(Path(sys.argv[2]),Path(sys.argv[3]),sys.argv[4])))
    else:main()
