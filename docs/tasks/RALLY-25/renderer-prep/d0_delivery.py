"""Consume the immutable peer manifest without editing published Rally refs."""
import json,struct,subprocess,shutil,copy,re
from pathlib import Path
from common import HERE,ROOT,sha,dump
from root_adapter import Interface,Binding,metadata_status,read

BUNDLE=ROOT.parent/'golem/docs/tasks/GOLEM-034/delivery/b7a6be65ce06789e'
BUNDLE_HASH='b7a6be65ce06789e837c986a1af4968aa83e0cc43a5e5a0a976338241be3b08f'
FIELDS=dict(magic=0,schema=2,header_bytes=4,root_bytes=6,session=8,interface_status=12,language_status=14,runtime_result=16,
            last_success_generation=20,last_success_entry=24,descriptor_count=26,requested_entry=28,last_success_session=32,
            entry_count=36,globals_bytes=38,contract_tag=44,descriptors=48)

def parse(m):
    r=m['root'];i=m['interface'];b=m['backends']
    assert m['family']==r['family']=='R25-G0/root-v1' and m['schema']==r['schema']==i['schema']==1
    assert r['header_bytes']==112 and r['byte_order']=='little' and r['argument_bytes']==2 and r['fields']==FIELDS
    assert r['root_bytes']==i['state_bytes']==b['state_bytes'] and r['globals_bytes']==r['root_bytes']-112
    assert i['state_buffer']==b['shared_state'] and i['state_owner']=='application_shared' and 0<i['state_buffer']<65536
    assert i['error']['offset']==b['error_offset']==14
    entries={e['name']:e['logical_id'] for e in i['entries']};assert len(entries)==len(i['entries'])
    for e in i['entries']:assert e['parameter_bytes']==e['result_bytes']==0
    bindings=tuple(Binding(x['role'],x['buffer'],x['offset'],x['bytes'],x['access']) for x in r['bindings'])
    spec=Interface(r['root_bytes'],entries,bindings);spec.validate()
    for x in r['bindings']:assert x['installed_min_bytes']>=x['offset']+x['bytes']
    for key in ['buffered_entries','native_wrappers']:
        assert len(b[key])==len(entries) and len(set(b[key]))==len(entries)
    assert b['root_schema']==1 and b['root_header_bytes']==112
    retained={i['state_buffer']}|{x.buffer for x in bindings if x.buffer}
    assert not retained&set(b['buffered_owned']) and not retained&set(b['native_owned'])
    occupied=set()
    for g in i['globals']:
        assert g['bytes'] in (2,4) and 112<=g['offset'] and g['offset']+g['bytes']<=spec.root_bytes
        cells=set(range(g['offset'],g['offset']+g['bytes']));assert not occupied&cells;occupied|=cells
    assert len(occupied)==r['globals_bytes']
    return spec

def named_call(m,name,backend):
    """Generate the actual six-byte CALL from delivered wrapper mapping only."""
    spec=parse(m);assert name in spec.entries and backend in ('native','buffered')
    index=next(i for i,e in enumerate(m['interface']['entries']) if e['name']==name)
    key='native_wrappers' if backend=='native' else 'buffered_entries'
    wrapper=m['backends'][key][index]
    assert wrapper in m['backends'][backend+'_owned'] and 0<wrapper<65535
    return struct.pack('<BBBHB',23,0,160,wrapper,1)

def main():
    (HERE/'D0-RECEIPT.json').unlink(missing_ok=True)
    raw=(BUNDLE/'bundle.json').read_bytes();assert sha(raw)==BUNDLE_HASH
    bundle=json.loads(raw)
    for name,meta in bundle['files'].items():
        p=(BUNDLE/name).resolve();assert p.is_relative_to(BUNDLE.resolve())
        data=p.read_bytes();assert len(data)==meta['bytes'] and sha(data)==meta['sha256'],name
    results=[];tool_matches={};cases=0
    for name in ('default','relocated'):
        p=BUNDLE/'packages'/name;m=json.loads((p/'delivery-manifest.json').read_text());spec=parse(m)
        baseline=m['inputs']['baseline'];assert baseline['compiler_commit']==bundle['compiler_baseline']=='25901e52eb80a4d66847c11fbc70d1bac68ee633'
        assert baseline['sdk_commit']=='33a554c82377b10d428f0d2ec258d1b48f27ed22'
        for path,h in baseline['sdk_files'].items():assert sha((ROOT.parent/'agon-vdplet'/path).read_bytes())==h,path
        for f in baseline['files']:
            data=(BUNDLE/'source/docs/tasks/GOLEM-034/baseline'/f['path']).read_bytes()
            assert sha(data)==f['sha256'] and len(data)==f['bytes']
            assert data==subprocess.check_output(['git','-C',str(ROOT.parent/'golem'),'show',baseline['compiler_commit']+':'+f['path']])
        for artifact,meta in m['artifacts'].items():
            data=(p/artifact).read_bytes();assert len(data)==meta['bytes'] and sha(data)==meta['sha256']
        state=(p/'state.bin').read_bytes();assert len(state)==spec.root_bytes and metadata_status(state,spec)==0
        expected=spec.initial(read(state,8,'I'));assert expected[:112]==state[:112]
        assert sha((p/'probe.vdpl').read_bytes())==m['native_module']['sha256']
        assert len((p/'probe.upload.elf').read_bytes())==m['native_module']['elf_bytes']
        calls={}
        for backend in ('buffered','native'):
            for entry in spec.entries:
                data=named_call(m,entry,backend)
                literal=re.search('golem_'+backend+'_'+entry+r'_call: db ([0-9,]+)',(p/'calls.inc').read_text())[1]
                assert data==bytes(map(int,literal.split(',')))
                calls[backend+':'+entry]=data.hex()
        for tool,h in m['inputs']['tool_executable_sha256'].items():
            location=shutil.which(tool)
            if location is None:
                candidate=Path.home()/'.platformio/packages/toolchain-xtensa-esp32/bin'/tool
                if candidate.exists():location=str(candidate)
            tool_matches[tool]=dict(recorded=h,local_matches=sha(Path(location).read_bytes())==h if location else None)
        rejects=0
        for mutate in [lambda x:x['root'].update(schema=2),lambda x:x['root']['fields'].update(language_status=12),
                       lambda x:x['root'].update(root_bytes=125),lambda x:x['interface']['entries'][1].update(logical_id=0),
                       lambda x:x['root']['bindings'][0].update(access=3),lambda x:x['interface']['globals'][0].update(offset=0),
                       lambda x:x['backends'].update(native_wrappers=[])]:
            bad=copy.deepcopy(m);mutate(bad)
            try:parse(bad)
            except (AssertionError,ValueError):rejects+=1
            else:raise AssertionError('Malformed delivered metadata accepted')
        cases+=rejects+1
        results.append(dict(package=name,manifest_sha256=sha((p/'delivery-manifest.json').read_bytes()),root_buffer=m['interface']['state_buffer'],root_bytes=spec.root_bytes,
                            entries=spec.entries,bindings=m['root']['bindings'],native_handle_patch=m['backends']['native_handle_offset'],rejections=rejects,
                            artifacts_verified=len(m['artifacts']),native_package_sha256=m['native_module']['sha256'],named_calls=calls,resources=m['resources']))
    dump('D0-RECEIPT.json',dict(scope='independent bundle/source/manifest/initialization/artifact host checks; peer target receipts retained, no new target execution',bundle_sha256=BUNDLE_HASH,
        bundle_files_verified=len(bundle['files']),packages=results,host_admission_cases=cases,toolchain_receipts=tool_matches,
        named_call_exports_verified=20,human_acceptance='owner reports accepted visual/keyboard review and publication through 1a1f303; no independent human review here',arrays_wide_renderer_scheduler_delivered=False))
    print('D0 bundle: verified',len(bundle['files']),'files; two generated mappings; fourteen malformed manifests rejected')
if __name__=='__main__':main()
