"""Analyze real returned short native diagnostics, retaining raw counter units.

API: analyze(evidence_root, output=None) -> JSON-serializable result. A phase
receipt requires its sibling successful run.json; host/synthetic logs are never
searched. With no qualified phase returns this reports status without writing an
analysis artifact. No emulator, remote access or input files are changed.
"""
from pathlib import Path
import argparse
import hashlib
import json
import math
import statistics

HERE=Path(__file__).resolve().parent
MASK=0xffffffff
HALF=0x80000000
COUNTERS=('clear_begin','road_begin','road_end','actors_end','player_end','swap_begin','swap_end')
SPANS=(('clear_title_dispatch_draw_flush','clear_begin','road_begin'),
       ('road_dispatch_draw_flush','road_begin','road_end'),
       ('actors_dispatch_draw_flush','road_end','actors_end'),
       ('player_dispatch_draw_flush','actors_end','player_end'),
       ('empty_marker_control','player_end','swap_begin'),
       ('swap_dispatch_and_flush','swap_begin','swap_end'))
WORK=('physics4_call_cycles','prepare_call_cycles',*(s[0] for s in SPANS))
BUILD=('road_build_cycles','actors_build_cycles','player_build_cycles')
LIMITS=[
    'Short diagnostic workload only: 128 renders / 512 simulation ticks, distinct from 900-frame headline comparisons.',
    'Raw per-core CCOUNT values are uncalibrated; no assumed ESP32 MHz or conversion into milliseconds.',
    'Native intervals include interrupt/scheduler time. Drawing intervals include resident dispatch, flush and marker overhead; they are not exclusive raster time.',
    'The measured-work denominator omits time between separate native-call brackets and other unmeasured transport/foreground intervals; shares are not complete-frame budget shares.',
    'Road/actor/player list construction is nested inside prepare and is counted only once in measured-work totals.',
    'Swap interval ends after the ordered controller-swap/drain fence, not completion of physical monitor scanout.',
    'Broad CCOUNT progress is an ordering/continuity check, with the first frame simulation/preparation outside its first clear timestamp; it is not used as the measured-work denominator.',
    'MOS/PRT and host durations remain separate clocks; host duration includes startup/teardown.'
]


def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()


def integer(value):
    assert isinstance(value,int) and not isinstance(value,bool) and 0<=value<=MASK,value
    return value


def delta(start,end,positive=True):
    value=(integer(end)-integer(start))&MASK
    assert (value>0 if positive else value>=0) and value<HALF,('Counter discontinuity',start,end)
    return value


def distribution(values):
    assert values
    ordered=sorted(values)
    return dict(total=sum(values),min=ordered[0],median=statistics.median(ordered),
        mean=statistics.mean(ordered),p95_nearest_rank=ordered[math.ceil(len(ordered)*.95)-1],max=ordered[-1])


def runtime_identity(receipt):
    manifest=receipt.get('runtime_identities','')
    identities={}
    for line in manifest.splitlines():
        if '  ' not in line:continue
        digest,name=line.split('  ',1)
        if not name.startswith('sdcard/') or name=='sdcard/rally25/probe.bin':identities[name]=digest
    fingerprint=hashlib.sha256(json.dumps(identities,sort_keys=True).encode()).hexdigest() if identities else None
    return fingerprint,identities


def analyze_return(path):
    path=Path(path);phase=json.loads(path.read_text())
    assert path.name=='phase-verified.json'
    run_path=path.parent/'run.json'
    assert run_path.is_file(),'Missing successful target run.json provenance'
    receipt=json.loads(run_path.read_text())
    assert receipt.get('error') is None and receipt.get('process_exit')==0,'Target run failed'
    standard=receipt['result'];backend=receipt['backend_stats']
    assert backend.get('engine') in ('jit','interpreter') and backend.get('cycles',0)>0,'Missing actual Flexe backend evidence'
    assert not any(backend.get(key) for key in ('failed','unhandled','unregistered','unmapped')),'Backend faults'
    assert phase['frames']==standard['frames']==128
    assert standard['physics_ticks']==512
    assert phase.get('full_final_state_matches_host') is True,'Final state was not independently qualified'
    assert phase.get('candidate') in ('control','float-quad-layered')
    for key in ('synthetic_only','host_stub','synthetic'):
        assert not phase.get(key) and not receipt.get(key),'Synthetic data is not timing evidence'
    calibration=phase['back_to_back_read_delta']
    assert 0<integer(calibration['min'])<=integer(calibration['max'])<HALF
    prid=integer(phase['cpu_prid'])
    rows=phase['rows'];assert len(rows)==128
    samples={key:[] for key in WORK+BUILD+('prepare_other_cycles','tail_cycles','measured_work_cycles')}
    row_checks=[];all_observed=[];starts=[];gaps=[];tail_sum=0
    previous_end=None
    for index,row in enumerate(rows,1):
        assert row['frame']==index,'Stale/missing record'
        values={key:integer(row[key]) for key in WORK[:2]+BUILD}
        assert all(0<value<HALF for value in values.values())
        assert values['prepare_call_cycles']>=sum(values[key] for key in BUILD),'Nested preparation exceeds parent'
        values['prepare_other_cycles']=values['prepare_call_cycles']-sum(values[key] for key in BUILD)
        for key,start,end in SPANS:values[key]=delta(row[start],row[end])
        tail=delta(row['clear_begin'],row['swap_end'])
        assert sum(values[key] for key,_,_ in SPANS)==tail,'Tail intervals do not telescope'
        values['tail_cycles']=tail
        values['measured_work_cycles']=values['physics4_call_cycles']+values['prepare_call_cycles']+tail
        for key in samples:samples[key].append(values[key])
        if previous_end is not None:gaps.append(delta(previous_end,row['clear_begin'],positive=False))
        previous_end=row['swap_end'];starts.append(row['clear_begin'])
        all_observed.extend(integer(row[k]) for k in COUNTERS)
        tail_sum+=tail
        row_checks.append(dict(frame=index,tail_cycles=tail,measured_work_cycles=values['measured_work_cycles']))
    progress=[delta(a,b,positive=False) for a,b in zip(all_observed,all_observed[1:])]
    broad=sum(progress)
    assert broad==tail_sum+sum(gaps),'Cross-frame progress does not telescope'
    wraps=sum(b<a for a,b in zip(all_observed,all_observed[1:]))
    stages={key:distribution(samples[key]) for key in WORK}
    measured=sum(samples['measured_work_cycles'])
    assert sum(row['total'] for row in stages.values())==measured
    for row in stages.values():row['percent_of_measured_work']=row['total']*100/measured
    prepare=sum(samples['prepare_call_cycles'])
    builders={key:distribution(samples[key]) for key in BUILD+('prepare_other_cycles',)}
    for row in builders.values():row['percent_of_prepare']=row['total']*100/prepare
    assert sum(row['total'] for row in builders.values())==prepare
    fingerprint,identities=runtime_identity(receipt)
    prt=standard.get('prt',{})
    prt_usable=bool(prt.get('timer_borrowed') and prt.get('previous_vector_restored') and prt.get('elapsed_ticks',0)>0)
    return dict(path=str(path),phase_sha256=sha(path),run_sha256=sha(run_path),
        candidate=phase['candidate'],frames=128,physics_ticks=512,
        unit='raw per-core CCOUNT delta modulo2^32; no Hz calibration',cpu_prid=prid,
        calibration=dict(calibration),complete_records=128,all_row_telescope_checks_pass=True,
        runtime_fingerprint=fingerprint,runtime_identities=identities,backend_engine=backend['engine'],
        stages=stages,nested_prepare=builders,measured_work=distribution(samples['measured_work_cycles']),
        broad_counter_progress=dict(first_clear=all_observed[0],last_swap_end=all_observed[-1],
            observed_wraps=wraps,unwrapped_delta=broad,tail_total=tail_sum,between_tail_total=sum(gaps),
            start_to_start=distribution([delta(a,b) for a,b in zip(starts,starts[1:])]),
            nondecreasing_modulo_half_range=True,telescoping_pass=True),
        separate_clocks=dict(nominal_mos_seconds=standard['elapsed_seconds'],mos_units=standard['elapsed_mos_ticks'],
            nominal_prt_seconds=prt.get('nominal_seconds_at_18432000_hz') if prt_usable else None,
            prt_timing_usable=prt_usable,host_seconds_including_startup=receipt.get('host_seconds')),
        row_checks=row_checks)


def comparisons(runs):
    groups={}
    for run in runs:
        if run['runtime_fingerprint'] is None:continue
        key=(run['runtime_fingerprint'],run['cpu_prid'],run['backend_engine'])
        groups.setdefault(key,{}).setdefault(run['candidate'],[]).append(run)
    result=[]
    for (runtime,prid,engine),candidates in groups.items():
        if not {'control','float-quad-layered'}<=set(candidates):continue
        pooled={}
        for name,trials in candidates.items():
            count=sum(r['frames'] for r in trials)
            pooled[name]=dict(runs=len(trials),frames=count,
                raw_measured_work_per_frame=sum(r['measured_work']['total'] for r in trials)/count,
                raw_stage_per_frame={key:sum(r['stages'][key]['total'] for r in trials)/count for key in WORK})
        control=pooled['control'];quad=pooled['float-quad-layered']
        result.append(dict(runtime_fingerprint=runtime,cpu_prid=prid,backend_engine=engine,pooled=pooled,
            raw_measured_work_reduction_percent=100*(1-quad['raw_measured_work_per_frame']/control['raw_measured_work_per_frame']),
            raw_stage_reduction_percent={key:100*(1-quad['raw_stage_per_frame'][key]/control['raw_stage_per_frame'][key]) for key in WORK},
            scope='Short instrumented measured-work counters only; not a 900-frame throughput improvement or hardware prediction'))
    return result


def analyze(evidence_root=None,output=None):
    evidence_root=Path(evidence_root) if evidence_root is not None else HERE/'evidence'
    paths=sorted(evidence_root.rglob('phase-verified.json')) if evidence_root.exists() else []
    if not paths:return dict(status='no_phase_artifacts_yet',evidence_root=str(evidence_root),output_written=False)
    runs=[];rejected=[]
    for path in paths:
        try:runs.append(analyze_return(path))
        except (AssertionError,KeyError,TypeError,ValueError,OSError) as exc:
            rejected.append(dict(path=str(path),reason=str(exc) or type(exc).__name__))
    if not runs:return dict(status='no_qualified_phase_artifacts',rejected=rejected,output_written=False)
    result=dict(status='qualified_returned_phase_data',runs=runs,comparisons=comparisons(runs),
        rejected=rejected,limits=LIMITS,headline_throughput_included=False,hardware_prediction=False)
    output=Path(output) if output is not None else HERE/'phase_ANALYSIS.json'
    result['output_written']=str(output)
    output.write_text(json.dumps(result,indent=2)+'\n')
    return result


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--evidence-root',type=Path)
    parser.add_argument('--output',type=Path)
    args=parser.parse_args();result=analyze(args.evidence_root,args.output)
    print(json.dumps({key:value for key,value in result.items() if key not in ('runs','limits','comparisons')},indent=2))
