"""Preserve qualified targets and all registered comparison/diagnostic inputs.

Packaging/readback only: no compilation, emulator, SSH, deployment or Git action.
Existing raw evidence is read for hashes and remains outside both archives.
"""
import hashlib
import json
from pathlib import Path
import shutil
import struct
import sys
import tempfile
import zipfile

HERE=Path(__file__).resolve().parent
THROUGHPUT=HERE.parents[1]/'throughput'
PACED=THROUGHPUT.parent/'paced-road'
sys.path.insert(0,str(PACED))
from freeze_control import records

FINAL=('clipfix-affine','clipfix-additive')
QUALIFIED_TARGETS={'control':THROUGHPUT/'.work/span-candidate/target',
                   'candidate':HERE/'.work/candidate-clipfix/target'}
FINAL_CANDIDATE='310779643769adde8413b93ea282115990dfebfe873e3395ac5545ac9d506702'


def digest(data):return hashlib.sha256(data).hexdigest()
def sha(path):return digest(Path(path).read_bytes())
def save(path,value):Path(path).write_text(json.dumps(value,indent=2)+'\n')


def evidence_hashes():
    return {str(p.relative_to(HERE)):sha(p) for p in sorted((HERE/'evidence').rglob('*')) if p.is_file()}


def tree(members,path,prefix):
    """Include source/target artifacts, excluding host libraries and caches."""
    assert path.is_dir(),path
    count=0
    for file in sorted(path.rglob('*')):
        if not file.is_file():continue
        relative=file.relative_to(path)
        if any(part in ('__pycache__','.cache','.pytest_cache') for part in relative.parts):continue
        if file.suffix in ('.so','.pyc','.pyo') or '.so.' in file.name:continue
        key=str(Path(prefix)/relative)
        assert not key.startswith('/') and '..' not in Path(key).parts
        members[key]=file.read_bytes();count+=1
    assert count,path


def fixture_module(fixture,meta):
    data=(fixture/'script.bin').read_bytes()
    staging=meta['resources']['staging']
    command=b'\x17\0\xa0'+struct.pack('<H',staging)
    prefix=command+b'\2'+command+b'\0'
    matches=[]
    for record in records(data):
        if record['opcode']!=1 or record['loop']:continue
        at=record['payload_offset'];body=data[at:at+record['payload_bytes']]
        if body.startswith(prefix):
            n=struct.unpack_from('<H',body,len(prefix))[0]
            image=body[len(prefix)+2:]
            # Diagnostics reuse staging for their zeroed log AFTER successful
            # LOAD; those writes intentionally share the same command prefix.
            if not image.startswith(b'VDPL'):continue
            assert len(image)==n
            matches.append(image)
    assert len(matches)==1,fixture
    return matches[0]


def validate_inputs(registry):
    result={}
    for name,entry in registry.items():
        fixture=HERE/entry['directory']
        assert all(sha(fixture/path)==value for path,value in entry['files'].items()),name
        meta=json.loads((fixture/'expected.json').read_text())
        module=fixture_module(fixture,meta)
        assert digest(module)==entry['module_sha256']==meta['module_sha256'],name
        if 'host_expected' in entry:
            assert sha(HERE/entry['host_expected'])==entry['host_expected_sha256'],name
        result[name]=dict(files=len(entry['files']),fixture_hashes_verified=True,
            embedded_module_sha256=digest(module),host_expected_pin_verified='host_expected' in entry)
    return result


MAIN_README='''# Qualified sprite comparison inputs and targets

The completed comparison uses fixtures/clipfix-affine and
fixtures/clipfix-additive. Their embedded modules are identical to
target/control/rally-render.vdpl and target/candidate/rally-render.vdpl,
respectively. The candidate module SHA256 is
310779643769adde8413b93ea282115990dfebfe873e3395ac5545ac9d506702.

Use the artifacts under target/ for the qualified compiler outputs, ELF files,
disassembly, stack reports and module manifests. Files named rally-render.*
under source/control/ or source/candidate/ were inherited from an earlier
compiler-delivery package and are preserved as provenance. In particular, their
48eac7... .vdpl/ELF artifacts are not the compiled span/sprite candidates.
The source/helper files alongside them describe the later renderer changes;
the qualified builds are explicitly separated under target/ to remove ambiguity.

firmware/vdp_rally.bin is the unchanged firmware used for these fixtures.
Compilation tooling/runtime dependencies remain pinned in the repository;
this archive does not replace that build environment. Hardware deployment and
human visual acceptance are separate from preserving these exact bytes.

SHA256SUMS covers every other member. The external PACKAGE.json also hashes
SHA256SUMS and records archive/readback validation. Earlier registered variants
and diagnostic builds are preserved separately in DIAGNOSTICS.zip. Raw emulator
evidence remains in the repository evidence/ directories and is not repackaged.
'''

DIAGNOSTIC_README='''# Registered variant and diagnostic preservation

This archive preserves every FIXTURES.json case outside the final clipfix pair,
including registered diagnostics that were never run. Registration and archive
validation are not assertions that a target run passed. Consult the repository's
RESULTS.md, campaign receipts and unchanged raw evidence for each actual outcome.
Some preserved additive variants contain the superseded clipping behavior, and
some larger diagnostic modules failed LOAD on the pinned runtime. Those inputs
are retained deliberately and must not be promoted to the final candidate.

fixtures/ contains the exact registered input files. diagnostics/ contains each
instrumented package, its actual target outputs, BUILD.json and independently
qualified HOST-EXPECTED.json. Host fake-clock qualification establishes state,
format and protocol checks; it supplies no target timing evidence.

preclip/package and preclip/target retain the earlier uncorrected sprite
candidate. The package directories also contain inherited rally-render.* files
from the earlier 48eac7... delivery. Those inherited binaries are provenance;
the corresponding target/ directory contains the actual module and compiler
artifacts for that diagnostic or earlier candidate. The final corrected target
31077964... is under target/candidate/ in PORTABLE.zip, not in preclip/.

registry/FIXTURES.json is an exact registry snapshot. CASES.json labels these as
registered inputs with no run-pass claim. SHA256SUMS covers every other member;
the external DIAGNOSTICS.json also hashes SHA256SUMS and records validation.
Raw emulator logs/screenshots/receipts remain outside this archive, unchanged.
Host .so libraries and Python/cache files are excluded.
'''


def write_archive(path,members):
    members=dict(members)
    members.pop('SHA256SUMS',None)
    sums={name:digest(data) for name,data in sorted(members.items())}
    members['SHA256SUMS']=''.join(value+'  '+name+'\n' for name,value in sums.items()).encode()
    hashes={name:digest(data) for name,data in sorted(members.items())}
    with tempfile.TemporaryDirectory(prefix='rally-sprite-preserve-',dir='/tmp') as temporary:
        archive=Path(temporary)/path.name
        with zipfile.ZipFile(archive,'w',compression=zipfile.ZIP_DEFLATED,compresslevel=9) as output:
            for name,data in sorted(members.items()):
                info=zipfile.ZipInfo(name,date_time=(1980,1,1,0,0,0))
                info.compress_type=zipfile.ZIP_DEFLATED
                info.external_attr=0o100644<<16
                output.writestr(info,data)
        with zipfile.ZipFile(archive) as check:
            assert check.testzip() is None
            assert len(check.namelist())==len(set(check.namelist()))==len(hashes)
            assert {name:digest(check.read(name)) for name in check.namelist()}==hashes
        shutil.copyfile(archive,path)
    with zipfile.ZipFile(path) as check:
        assert {name:digest(check.read(name)) for name in check.namelist()}==hashes
    return dict(archive=path.name,sha256=sha(path),bytes=path.stat().st_size,members=hashes,
        member_readbacks_verified=True,zip_crc_verified=True,embedded_SHA256SUMS_verified=True)


def preserve():
    raw_before=evidence_hashes()
    registry_path=HERE/'FIXTURES.json'
    registry_bytes=registry_path.read_bytes()
    registry=json.loads(registry_bytes)
    validation=validate_inputs(registry)
    existing=json.loads((HERE/'PACKAGE.json').read_text())
    portable_path=HERE/'PORTABLE.zip'
    assert sha(portable_path)==existing['sha256']
    with zipfile.ZipFile(portable_path) as archive:
        portable={name:archive.read(name) for name in archive.namelist()}
    assert {name:digest(data) for name,data in portable.items()}==existing['members']
    before_portable={name:digest(data) for name,data in portable.items()
                     if name!='README.md' and name!='SHA256SUMS' and not name.startswith('target/')}
    targets={}
    for kind,target in QUALIFIED_TARGETS.items():
        manifest=json.loads((target/'rally-render.json').read_text())['module']
        module=target/'rally-render.vdpl'
        assert sha(module)==manifest['sha256']==registry[FINAL[0 if kind=='control' else 1]]['module_sha256']
        if kind=='candidate':assert sha(module)==FINAL_CANDIDATE
        tree(portable,target,'target/'+kind)
        targets[kind]=dict(module='target/'+kind+'/rally-render.vdpl',sha256=sha(module),
            source_directory=str(target),resident_text_bytes=manifest['resident_text_bytes'],
            resident_data_bytes=manifest['resident_data_bytes'])
    portable['README.md']=MAIN_README.encode()
    assert before_portable=={name:digest(portable[name]) for name in before_portable}
    portable_report=write_archive(portable_path,portable)
    portable_report.update({key:value for key,value in existing.items()
        if key not in ('archive','sha256','members')})
    portable_report.update(qualified_targets=targets,qualified_candidate_module_sha256=FINAL_CANDIDATE,
        previous_provenance_members_unchanged=True,fixture_validation={name:validation[name] for name in FINAL},
        source_artifact_note='source/*/rally-render.* retains inherited delivery artifacts; qualified builds are target/*.',
        preservation_tool_sha256=sha(HERE/'preserve.py'))
    diagnostics={'README.md':DIAGNOSTIC_README.encode(),'registry/FIXTURES.json':registry_bytes}
    cases={}
    instrumented=[]
    for name,entry in registry.items():
        if name in FINAL:continue
        fixture=HERE/entry['directory']
        for member in entry['files']:
            diagnostics['fixtures/'+name+'/'+member]=(fixture/member).read_bytes()
        cases[name]=dict(status='registered input preservation; no run-pass claim',
            diagnostic=entry.get('diagnostic',False),module_sha256=entry['module_sha256'],
            fixture='fixtures/'+name)
        if 'host_expected' in entry:
            work=(HERE/entry['host_expected']).parent
            tree(diagnostics,work/'package','diagnostics/'+name+'/package')
            tree(diagnostics,work/'target','diagnostics/'+name+'/target')
            for report_name in ('BUILD.json','HOST-EXPECTED.json'):
                diagnostics['diagnostics/'+name+'/'+report_name]=(work/report_name).read_bytes()
            build=json.loads((work/'BUILD.json').read_text())
            module_path=work/'target/phase-render.vdpl'
            assert sha(module_path)==build['module']['module']['sha256']==entry['module_sha256']
            instrumented.append(name)
    tree(diagnostics,HERE/'.work/candidate/package','preclip/package')
    tree(diagnostics,HERE/'.work/candidate/target','preclip/target')
    diagnostics['preclip/BUILD.json']=(HERE/'BUILD.json').read_bytes()
    old_module=HERE/'.work/candidate/target/rally-render.vdpl'
    assert sha(old_module)==registry['sprite-additive']['module_sha256']
    diagnostics['CASES.json']=(json.dumps(cases,indent=2)+'\n').encode()
    assert not any(name.startswith('evidence/') for name in diagnostics)
    assert not any(Path(name).suffix in ('.so','.pyc','.pyo') for name in diagnostics)
    diagnostic_report=write_archive(HERE/'DIAGNOSTICS.zip',diagnostics)
    assert registry_path.read_bytes()==registry_bytes,'Registry changed during preservation'
    raw_after=evidence_hashes()
    assert raw_after==raw_before,'Raw evidence changed during packaging'
    diagnostic_report.update(registered_cases=cases,instrumented_packages=sorted(instrumented),
        fixture_validation={name:value for name,value in validation.items() if name not in FINAL},
        raw_evidence_repackaged=False,raw_evidence_sha256=raw_before,raw_evidence_unchanged=True,
        preclip_module_sha256=sha(old_module),preservation_tool_sha256=sha(HERE/'preserve.py'))
    save(HERE/'PACKAGE.json',portable_report)
    save(HERE/'DIAGNOSTICS.json',diagnostic_report)
    print(json.dumps(dict(portable_members=len(portable_report['members']),
        diagnostics_members=len(diagnostic_report['members']),registered_nonfinal_cases=len(cases),
        instrumented_packages=len(instrumented),raw_evidence_files_unchanged=len(raw_before),
        qualified_candidate_module_sha256=FINAL_CANDIDATE,
        fixture_inputs_verified=len(validation),archive_readbacks_verified=True),indent=2))


if __name__=='__main__':preserve()
