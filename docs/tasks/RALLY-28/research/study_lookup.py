"""Reproduce preserved lookup tables and bounded standard-VDP feasibility checks.

No emulator, product rebuild or deployment. Outputs remain under RALLY-28.
"""
import hashlib
import importlib.util
import json
from pathlib import Path
import re
import subprocess
import time

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[3]
AREA=HERE.parent/'standard-vdp'
WORK=AREA/'.work/lookup-study'
SDK=Path('/Agon/agondev/release')
COMMANDS=[]


def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()


def run(argv,cwd=ROOT):
    argv=list(map(str,argv));start=time.monotonic()
    result=subprocess.run(argv,cwd=cwd,capture_output=True,text=True)
    record=dict(argv=argv,cwd=str(cwd),returncode=result.returncode,
                host_seconds=time.monotonic()-start,stdout=result.stdout,stderr=result.stderr)
    COMMANDS.append(record)
    if result.returncode:
        raise RuntimeError(json.dumps(record,indent=2))
    return result.stdout


def main():
    WORK.mkdir(parents=True,exist_ok=True);data=WORK/'data';data.mkdir(exist_ok=True)
    inputs=run(['git','ls-files','rally','rally-game','rally-production','rally-bench',
                'docs/tasks/RALLY-16','docs/tasks/RALLY-18']).splitlines()
    inputs += [str(p.relative_to(ROOT)) for p in (ROOT/'rally-game/bin').glob('rally*')]
    inputs += [str(p.relative_to(ROOT)) for p in (ROOT/'rally-game/obj').glob('*.o')]
    before={name:sha(ROOT/name) for name in sorted(set(inputs)) if (ROOT/name).is_file()}
    historical=ROOT/'docs/tasks/RALLY-18'
    manifest=json.loads((historical/'data/manifest.json').read_text())
    for name,identity in manifest['files'].items():
        assert sha(historical/'data'/name)==identity['sha256']
        assert (historical/'data'/name).read_bytes()==(ROOT/'rally-production'/name).read_bytes()
    headers=('lookup_road.hpp','lookup_format.hpp','section_road.hpp','section_protocol.hpp','section_phase.hpp')
    for name in headers:
        assert (historical/name).read_bytes()==(ROOT/'rally-production/include'/name).read_bytes()
    # The saved generator was compiled on another host. Default ARM GCC FP
    # contraction changes a few oval coefficients at rounding ties; explicitly
    # retain expression order to reproduce the validated table bytes.
    generator=['c++','-O3','-std=c++17','-Wall','-Wextra','-Werror','-I',ROOT/'rally/include',
               '-I',historical,historical/'generate_road.cpp']
    default_data=WORK/'default-data';default_data.mkdir(exist_ok=True)
    run([*generator,'-o',WORK/'generate-default']);run([WORK/'generate-default',default_data])
    default_differences={}
    for name in manifest['files']:
        saved=(historical/'data'/name).read_bytes();regenerated=(default_data/name).read_bytes()
        assert len(saved)==len(regenerated)
        different=[i for i,(a,b) in enumerate(zip(saved,regenerated)) if a!=b]
        default_differences[name]=dict(different_bytes=len(different),
            different_payload_bytes=sum(i>=64 for i in different),sha256=sha(default_data/name))
    run([*generator,'-ffp-contract=off','-o',WORK/'generate-strict'])
    run([WORK/'generate-strict',data])
    for name,identity in manifest['files'].items():assert sha(data/name)==identity['sha256']
    include=['-I',AREA,'-I',ROOT/'rally-game/include','-I',ROOT/'rally-production/include']
    host_results={}
    for label,options in [('ordinary',['-O2']),('sanitized',['-O1','-g','-fsanitize=address,undefined','-fno-omit-frame-pointer'])]:
        binary=WORK/label
        run(['c++','-std=c++17','-Wall','-Wextra','-Werror',*options,*include,
             AREA/'lookup_study.cpp','-o',binary])
        output=run([binary,data]);(WORK/(label+'.jsonl')).write_text(output)
        host_results[label]=[json.loads(line) for line in output.splitlines()]
    assert host_results['ordinary']==host_results['sanitized']
    spec=importlib.util.spec_from_file_location('r28_audit',HERE/'audit_hot_loop.py')
    audit=importlib.util.module_from_spec(spec);spec.loader.exec_module(audit)
    base=[SDK/'bin/ez80-none-elf-clang',*audit.flags(),*audit.cpp_flags(),*include,AREA/'lookup_probe.cpp']
    for suffix,options in [('s',['-S']),('ll',['-S','-emit-llvm']),('o',['-c'])]:
        run([*base,*options,'-o',WORK/('lookup.'+suffix)],cwd=AREA)
    functions=audit.assembly_inventory(WORK/'lookup.s')
    operations=audit.ir_inventory(WORK/'lookup.ll')
    for f in functions:f['llvm_operations']=operations.get(f['symbol'][1:],{})
    targets={t['target'] for f in functions for t in f['transfers']}
    assert not any('bandEnd' in t or '7section4draw' in t for t in targets)
    for f in functions:
        if 'LookupRoad' in f['name']:
            assert not any('trackSample' in t['target'] for t in f['transfers'])
    llvm=(WORK/'lookup.ll').read_text()
    assert not re.search(r'\b(fadd|fsub|fmul|fdiv|fptosi|sitofp)\b',llvm)
    layout_line=next(line for line in llvm.splitlines() if line.startswith('@r28_layout ='))
    layout=list(map(int,re.findall(r'i24 (\d+)',layout_line)))
    assert len(layout)==9,layout_line
    after={name:sha(ROOT/name) for name in before};assert after==before
    result=dict(schema=1,task='LOOKUP-001-01',date='2026-10-14',
        checkpoint=run(['git','rev-parse','HEAD']).strip(),
        kind='source/codegen and host feasibility; no eZ80 timing or FPS measurement',
        host_compiler=run(['c++','--version']),host_results=host_results,
        default_fp_contraction_regeneration=default_differences,
        matching_regeneration_flag='-ffp-contract=off',
        generated_tables={name:dict(sha256=sha(data/name),bytes=(data/name).stat().st_size)
                          for name in manifest['files']},
        historical_headers_identical=list(headers),
        target_layout=dict(zip(('LookupRoad','DirectRoad','BandOffsets','BandEnds','PhaseIndex',
                                'PhaseOffsets','PhaseRows','DepthQ8','SectionRoad'),layout)),
        target_functions=functions,target_artifacts={suffix:sha(WORK/('lookup.'+suffix)) for suffix in ('s','ll','o')},
        study_sources={str(p.relative_to(ROOT)):sha(p) for p in [Path(__file__),
            AREA/'lookup_direct.hpp',AREA/'lookup_probe.cpp',AREA/'lookup_study.cpp']},
        protected_files_unchanged=True,protected_files=before,
        host_durations_are_not_target_performance=True,commands=COMMANDS)
    (HERE/'LOOKUP-STUDY.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(dict(host_results=host_results['ordinary'],target_layout=result['target_layout'],
                         preserved_files=len(before),receipt=str(HERE/'LOOKUP-STUDY.json')),indent=2))


if __name__=='__main__':
    main()
