"""Reproduce the bounded host C integration model; never run published verifiers."""
import ctypes as C
import hashlib
import importlib.util
import json
import struct
import subprocess
import sys
import time
from pathlib import Path

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[3]
WORK=HERE.parent/'.work/integration-harness'
PACKAGE=HERE/'fuji'
HELPER=HERE.parent/'renderer-helper'
PREP=HERE.parent/'renderer-prep'
def sha(data): return hashlib.sha256(data).hexdigest()
def load_helper():
    spec=importlib.util.spec_from_file_location('r25_helper_fixture',HELPER/'verify.py')
    m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m);return m

def mappings(asset):
    """Explicit test data, deliberately not a generated D2 manifest format."""
    result=[]
    for base,entries,resources in [(1000,[0,1,2,3,4],[0,5,120,63970,63984,63930]),
                                   (53000,[4,2,0,5,1],[40,50,100,60010,60100,60001])]:
        def r(delta,access,offset,size):return dict(buffer=base+delta,access=access,offset=offset,bytes=size)
        result.append(dict(label='default-fixture' if base==1000 else 'relocated-permuted-fixture',
            root=r(0,3,4,128),argument=r(1,1,3,2),completion=r(2,2,5,48),
            bindings=dict(struct_bytes=76,schema=1,session=7,asset=r(3,1,3,len(asset)),
                output=[r(4+i,2,9,cap) for i,cap in enumerate([20480,2048,256])],
                track_identity=struct.unpack_from('<I',asset,12)[0],asset_checksum=struct.unpack_from('<I',asset,24)[0],
                resources=resources),entries=entries,entry_count=6,globals_bytes=16,
            descriptors=[dict(role=i+1,**r(7+i,3 if i==1 else 1,i,8)) for i in range(4)]))
    return result

def make_package():
    """Only used to create a new package; normal replay verifies its pinned contents."""
    PACKAGE.mkdir(exist_ok=True);WORK.mkdir(parents=True,exist_ok=True)
    sys.path.insert(0,str(HERE.parent/'reference'));from freeze import prepare
    frozen,_=prepare()
    exporter=subprocess.check_output(['git','-C',str(ROOT),'show','d250f43:docs/tasks/RALLY-24/experiment/assets.cpp'])
    assert sha(exporter)=='2c817ada698d5c06fe29a7ea0dfd819e89e19d6b8caf747b7f6fc705ab70ef99'
    (WORK/'assets.cpp').write_bytes(exporter)
    subprocess.run(['c++','-std=c++17','-O2','-I'+str(frozen/'rally-production/include'),'-I'+str(frozen/'rally-game/include'),str(WORK/'assets.cpp'),'-o',str(WORK/'assets')],check=True)
    subprocess.run([str(WORK/'assets'),str(frozen/'rally-production'),str(WORK)],check=True)
    asset=(WORK/'fuji.r24').read_bytes()
    receipt=json.loads((PREP/'FIXTURE-RECEIPT.json').read_text())
    assert sha(asset)==next(r['asset_sha256'] for r in receipt['rows'] if r['track']=='fuji')
    all_cases=json.loads((PREP/'scene-cases.json').read_text())['cases'];fuji=[r for r in all_cases if r['track']=='fuji']
    # Even coverage of preserved poses, boundary combinations and sign crossings.
    selected=[]
    for prefix,n in [('preserved:',32),('boundary:',24),('sign:',16)]:
        group=[r for r in fuji if r['label'].startswith(prefix)]
        selected.extend(group[i*(len(group)-1)//(n-1)] for i in range(n))
    fixture=load_helper();rows=[]
    for row in selected:
        raw=bytes.fromhex(row['state_hex']);assert sha(raw)==row['state_sha256']
        typed=bytes(fixture.convert(raw))
        # Fixture-native typed storage is encoded explicitly as LE on this host.
        assert sys.byteorder=='little' and len(typed)==108
        rows.append(dict(label=row['label'],reference_state_hex=row['state_hex'],reference_state_sha256=row['state_sha256'],
                         helper_state_le_hex=typed.hex(),helper_state_sha256=sha(typed),
                         output_sha256=row['output_sha256'],counts=row['counts']))
    (PACKAGE/'fuji.r24').write_bytes(asset)
    (PACKAGE/'scenes.json').write_text(json.dumps(dict(schema=1,scope='72 complete supplied snapshots; host fixture encoding, not telemetry or scheduling',
        source_cases_sha256=sha((PREP/'scene-cases.json').read_bytes()),asset_sha256=sha(asset),
        reference_exporter_sha256=sha(exporter),cases=rows),indent=2)+'\n')
    (PACKAGE/'mappings.json').write_text(json.dumps(dict(schema=1,scope='host-only generated-style binding inputs; not Golem D2 JSON schema',mappings=mappings(asset)),indent=2)+'\n')

def header(package,maps):
    def r(v):return '{'+','.join(str(v[x]) for x in ['buffer','access','offset','bytes'])+'}'
    out=['#define FIXTURE_COUNT '+str(len(package['cases'])), 'static const uint8_t fixture_states[FIXTURE_COUNT][108]={']
    for row in package['cases']:out.append('{'+','.join(str(v) for v in bytes.fromhex(row['helper_state_le_hex']))+'},')
    out.append('};\nstatic const uint16_t fixture_counts[FIXTURE_COUNT][3]={')
    out.extend('{'+','.join(map(str,row['counts']))+'},' for row in package['cases'])
    out.append('};\nstatic const ModelMap fixture_maps[2]={')
    for m in maps:
        b=m['bindings'];descriptors=b''
        for d in m['descriptors']:descriptors+=struct.pack('<HHIIHH',d['role'],d['buffer'],d['offset'],d['bytes'],d['access'],0)
        out.append('{.root='+r(m['root'])+',.argument='+r(m['argument'])+',.completion='+r(m['completion'])+',')
        out.append('.bindings={76,1,7,'+r(b['asset'])+',{'+','.join(r(x) for x in b['output'])+'},'+str(b['track_identity'])+'u,'+str(b['asset_checksum'])+'u,{'+','.join(map(str,b['resources']))+'}},')
        out.append('.entries={'+','.join(map(str,m['entries']))+'},.entry_count='+str(m['entry_count'])+',.globals_bytes='+str(m['globals_bytes'])+',')
        out.append('.descriptors={'+','.join(map(str,descriptors))+'}},')
    out.append('};');return '\n'.join(out)+'\n'

def check_commands(path,package):
    data=path.read_bytes();at=0;rows=[]
    for row in package['cases']:
        output=[]
        for _ in range(3):
            assert at+4<=len(data);n=struct.unpack_from('<I',data,at)[0];at+=4
            assert n<=20480 and at+n<=len(data);output.append(data[at:at+n]);at+=n
        rows.append(output)
    assert at==len(data);return rows

def main():
    started=time.monotonic();WORK.mkdir(parents=True,exist_ok=True)
    if '--create-package' in sys.argv:make_package()
    for n in ['ordinary-results.json','sanitized-results.json','RESULTS.json']:(HERE/n).unlink(missing_ok=True)
    package=json.loads((PACKAGE/'scenes.json').read_text());maps=json.loads((PACKAGE/'mappings.json').read_text())['mappings']
    assert sha((PACKAGE/'fuji.r24').read_bytes())==package['asset_sha256']
    assert sha((PREP/'scene-cases.json').read_bytes())==package['source_cases_sha256']
    fixture=load_helper()
    reference={row['label']:row for row in json.loads((PREP/'scene-cases.json').read_text())['cases'] if row['track']=='fuji'}
    for row in package['cases']:
        original=reference[row['label']]
        assert row['reference_state_hex']==original['state_hex']
        assert row['reference_state_sha256']==original['state_sha256']
        assert row['output_sha256']==original['output_sha256'] and row['counts']==original['counts']
        raw=bytes.fromhex(row['reference_state_hex']);typed=bytes.fromhex(row['helper_state_le_hex'])
        assert sha(raw)==row['reference_state_sha256'] and sha(typed)==row['helper_state_sha256']
        assert bytes(fixture.convert(raw))==typed
    assert maps==mappings((PACKAGE/'fuji.r24').read_bytes())
    (WORK/'fixtures.h').write_text(header(package,maps))
    sources=[HERE/'integration_model.h',HERE/'integration_model.c',HERE/'host_tests.c',HERE/'verify.py',
             HELPER/'verify.py',HELPER/'rally_render.h',HELPER/'rally_render.c',HELPER/'render_core.inc',HELPER/'asset_meta.inc',ROOT.parent/'agon-vdplet/include/vdplet.h']
    results={}
    for label,flags in [('ordinary',[]),('sanitized',['-g','-fsanitize=address,undefined','-fno-omit-frame-pointer'])]:
        run_started=time.monotonic();outdir=WORK/label;outdir.mkdir(exist_ok=True);executable=outdir/'harness'
        command=['cc','-std=c11','-O2','-ffp-contract=off','-fno-builtin','-Wall','-Wextra','-Werror',*flags,
                 '-I'+str(ROOT.parent/'agon-vdplet/include'),'-I'+str(HELPER),'-I'+str(WORK),
                 str(HERE/'integration_model.c'),str(HERE/'host_tests.c'),str(HELPER/'rally_render.c'),'-o',str(executable)]
        subprocess.run(command,check=True)
        run=subprocess.run([str(executable),str(PACKAGE/'fuji.r24'),str(outdir)],text=True,capture_output=True)
        if run.returncode:print(run.stdout+run.stderr,file=sys.stderr);run.check_returncode()
        assert not run.stderr,run.stderr
        result=json.loads(run.stdout);outputs=[check_commands(outdir/f'map-{i}.commands',package) for i in range(2)]
        relocated=fixture.Resources(*maps[1]['bindings']['resources'])
        for row,original,moved in zip(package['cases'],*outputs):
            assert [sha(x) for x in original]==row['output_sha256'],row['label']
            assert moved==[fixture.remap(x,relocated) for x in original],row['label']
        result.update(label=label,scene_package_cases=len(package['cases']),command_oracle_matches=len(package['cases']),
            relocated_command_matches=len(package['cases']),asan_ubsan=bool(flags),
            compile_and_run_host_seconds=round(time.monotonic()-run_started,3),executable_sha256=sha(executable.read_bytes()),
            output_sha256=[sha((outdir/f'map-{i}.commands').read_bytes()) for i in range(2)],compile_command=command)
        (HERE/(label+'-results.json')).write_text(json.dumps(result,indent=2)+'\n');results[label]=result
        print(json.dumps(result,indent=2))
    assert results['ordinary']['output_sha256']==results['sanitized']['output_sha256']
    results.update(schema=1,scope='host C model of accepted glue/owner; no generated compiler, SDK entry, target, pixel, timing or concurrency qualification',
        total_setup_execution_host_seconds=round(time.monotonic()-started,3),compiler=subprocess.check_output(['cc','--version'],text=True).splitlines()[0],
        source_sha256={str(p.relative_to(ROOT)) if p.is_relative_to(ROOT) else str(p):sha(p.read_bytes()) for p in sources},
        package_sha256={p.name:sha(p.read_bytes()) for p in sorted(PACKAGE.iterdir()) if p.is_file()})
    (HERE/'RESULTS.json').write_text(json.dumps(results,indent=2)+'\n')
if __name__=='__main__':main()
