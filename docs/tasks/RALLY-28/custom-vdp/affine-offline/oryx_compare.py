"""Read-only independent cross-host affine audit; writes only new audit outputs.

Never starts an emulator, compiles, contacts another host, rewrites fixtures or
pools host CPU time with emulated target clocks. Existing Pi reports stay intact.
"""
from pathlib import Path
import argparse
import csv
import hashlib
import json
import math
import statistics
import struct
from target_verify import HERE,APP,sha,packets,expected_schedule,runtime_identity


def read(path):return json.loads(Path(path).read_text())
def csv_rows(path):
    with Path(path).open(newline='') as handle:return list(csv.DictReader(handle))
def same_float(first,second):return math.isclose(first,second,rel_tol=1e-9,abs_tol=1e-8)
def unchanged_write(path,data):
    if path.exists():assert path.read_bytes()==data,('Preserve existing cross-host audit',str(path))
    else:path.write_bytes(data)


def host_audit(path):
    report=read(path);name=report['name'];base=Path(path).parent
    assert report['passed'] and report['checksums_observed'] and not report['emulator_launched']
    assert report['clock_cpu']=='CLOCK_THREAD_CPUTIME_ID' and report['clock_wall']=='CLOCK_MONOTONIC_RAW'
    for filename,value in report['output_sha256'].items():assert sha(base/filename)==value,('Host output hash',filename)
    source_hashes=report['source_sha256']
    for filename,value in source_hashes.items():assert sha(HERE/filename)==value,('Host source changed',filename)
    assert report['case_manifest_sha256']==sha(HERE/'HOST-CASES.json')
    cases=read(HERE/'HOST-CASES.json')
    assert cases['workload_sha256']==sha(HERE/'WORKLOAD.json')
    for case in cases['timed_cases']:assert sha(HERE/case['asset'])==case['asset_sha256']
    rows=csv_rows(base/('HOST-'+name+'.csv'))
    checks=csv_rows(base/('HOST-'+name+'-checks.csv'))
    ncases=len(cases['timed_cases']);trials=report['trials']
    assert len(rows)==report['samples']==ncases*trials*8
    assert len(checks)==ncases and len({c['case'] for c in checks})==ncases
    grouped={};row_checksums={};summary=[]
    for row in rows:
        key=row['case'],row['operation']
        trial=int(row['trial']);iterations=int(row['iterations']);cpu=int(row['cpu_ns']);wall=int(row['wall_ns'])
        assert 0<=trial<trials and iterations>0 and cpu>0 and wall>0
        assert math.isclose(float(row['cpu_ns_per_operation']),cpu/iterations,rel_tol=1e-7,abs_tol=1e-5)
        assert math.isclose(float(row['wall_ns_per_operation']),wall/iterations,rel_tol=1e-7,abs_tol=1e-5)
        assert (*key,trial) not in row_checksums
        row_checksums[*key,trial]=row['checksum']
        grouped.setdefault(key,[]).append(row)
    stored={(r['case'],r['operation']):r for r in report['summaries']}
    assert len(grouped)==len(stored)==ncases*8
    for key,values in grouped.items():
        assert len(values)==trials and {int(r['trial']) for r in values}==set(range(trials))
        assert len({r['checksum'] for r in values})==1,('Host checksum depends on trial',key)
        cpu=statistics.median(float(r['cpu_ns_per_operation']) for r in values)/1000
        wall=statistics.median(float(r['wall_ns_per_operation']) for r in values)/1000
        assert same_float(cpu,stored[key]['median_cpu_us']) and same_float(wall,stored[key]['median_wall_us'])
        summary.append(dict(case=key[0],operation=key[1],median_cpu_us=cpu,median_wall_us=wall,
            raw_cpu_ns=[int(r['cpu_ns']) for r in values],raw_wall_ns=[int(r['wall_ns']) for r in values],
            iterations=[int(r['iterations']) for r in values],checksum=values[0]['checksum']))
    geometry={}
    for row in checks:
        case=row['case'];assert case not in geometry
        assert row['cached_checksum']==grouped[case,'cached_affine'][0]['checksum']
        assert row['cached_checksum']==grouped[case,'rebuilt_affine_host_model'][0]['checksum']
        assert row['buffer_plot_checksum']==grouped[case,'transform_then_plot'][0]['checksum']
        assert row['buffer_plot_checksum']==grouped[case,'ordinary_pretransformed'][0]['checksum']
        geometry[case]=row
    return dict(name=name,architecture=report['host_before']['uname']['machine'],compiler=report['compiler'],
        trials=trials,minimum_ms=report['minimum_calibration_cpu_ms'],cases=ncases,samples=len(rows),
        groups=grouped,row_checksums=row_checksums,geometry=geometry,summary=summary,source_hashes=source_hashes,
        case_manifest_sha256=report['case_manifest_sha256'],elapsed_host_seconds=report['elapsed_host_seconds'])


def target_audit(run_path,evidence,manifest_path):
    run=read(run_path);evidence=Path(evidence);runtime=evidence/'runtime';verified=read(runtime/'verified.json')
    manifest=read(manifest_path);summary=read(evidence/'summary.json');rows=csv_rows(evidence/'timings.csv')
    fixture=read(HERE/'target/fixtures/full/expected.json');plan=read(HERE/'TARGET-FIXTURES.json')['full']
    assert run['passed'] and run['process_exit']==run['exit']==0 and run['reason']=='guest-files'
    assert run['identities_unchanged'] and run['input_identities_unchanged']
    assert run['forced_sdl']==dict(video='dummy',audio='dummy')
    assert verified['passed'] and verified['fixture']=='full' and verified['completed_batches']==124
    assert summary==run['summary']==verified['summary'] and summary['valid'] and summary['failure']=='none'
    assert summary['completed_batches']==summary['planned_batches']==len(rows)==124
    assert summary['mode']==136 and summary['timed_swaps']==0 and summary['callback_restored'] and summary['prt_restored']
    assert not summary['fallback_used'] and (evidence/'done.txt').read_text().strip()=='PASS'
    for filename,value in run['outputs'].items():assert sha(evidence/filename)==value
    for filename,value in verified['output_sha256'].items():assert sha(evidence/filename)==value
    assert verified['guest_sha256']==fixture['guest_sha256'] and verified['fixture_sha256']==sha(HERE/'target/fixtures/full/expected.json')
    assert verified['workload_sha256']==sha(HERE/'WORKLOAD.json') and verified['build_sha256']==sha(HERE/'TARGET-BUILD.json')
    assert manifest['passed'] and manifest['source_changes'] is False
    identity=run['identity'];assert identity['platform']['architecture']==manifest['architecture']
    assert identity['runtime_build_sha256']==sha(manifest_path)
    for name,value in plan['files'].items():assert identity['files'][str(APP/name)]==value
    assert identity['files']['flexe-agon-emulator.bin']==manifest['files']['flexe-agon-emulator']
    assert identity['files']['flexe-vdp.so']==manifest['files']['flexe-vdp.so']
    profile=Path(identity['profile'])
    if profile.exists():runtime_proof=runtime_identity(profile,identity,manifest_path)
    else:
        runtime_proof=verified['runtime_build']
        assert runtime_proof['sha256']==sha(manifest_path) and runtime_proof['architecture']==manifest['architecture']
        assert runtime_proof['actual_elf_architecture_verified'] is True
    tx=(runtime/'mos-to-vdp.bin').read_bytes();rx=(runtime/'vdp-to-mos.bin').read_bytes()
    assert rx==(runtime/'vdp-to-mos-delivered.bin').read_bytes()
    assert hashlib.sha256(tx).hexdigest()==verified['raw_tx_sha256']
    assert hashlib.sha256(rx).hexdigest()==verified['raw_rx_sha256']
    expected_tx,expected_rx,expected_rows,intervals,_,_=expected_schedule(fixture,(HERE/'target/fixtures/full/artwork.vdu').read_bytes())
    assert tx.count(expected_tx)==1,'Complete identical foreground command schedule missing'
    begin=tx.index(expected_tx);end=begin+len(expected_tx)
    assert b'RALLY AFFINE PASS:' in tx[end:] and b'/test/arcade/rally28/affine *' in tx[end:]
    assert verified['application_tx_bytes']==len(expected_tx)==110240
    assert len(intervals)==124 and all(row['bytes']==6 for row in intervals)
    wire=packets(rx)
    def optional_mode(payload):
        if len(payload)!=8:return False
        w,h,columns,textrows,colours,mode=struct.unpack('<HHBBBB',payload)
        return (w,h,columns,colours,mode)==(320,240,40,64,136) and 1<=textrows<=30
    def matches(at):
        start=at
        for op,payload in expected_rx:
            while at<len(wire) and wire[at][0]==6 and optional_mode(wire[at][1]):at+=1
            if at>=len(wire):return None
            expected_payload=b'\0\0\xff\x0c' if payload is None else payload
            if wire[at]!=(op,expected_payload):return None
            at+=1
        return start,at
    candidates=[matches(i) for i,p in enumerate(wire) if p==expected_rx[0]]
    candidates=[r for r in candidates if r is not None]
    assert len(candidates)==1
    first,last=candidates[0]
    assert not any(op in (0,1,4) for op,payload in wire[last:])
    assert sum(op==1 for op,payload in wire[first:last])==summary['keyboard_packets']==124
    assert len(expected_rx)==497
    stats=read(runtime/'stats.json')
    assert stats==run['backend_stats']==verified['backend_stats']
    assert not any(stats[key] for key in ('failed','unhandled','unregistered','unmapped'))
    assert (stats['uart_rx'],stats['uart_tx'],stats['uart_delivered'])==(len(tx),len(rx),len(rx))
    groups={}
    for row,want in zip(rows,expected_rows,strict=True):
        got={k:v if k in ('case','method') else int(v) for k,v in row.items()}
        for key,value in want.items():assert got[key]==value,('Target row plan',key,got,value)
        assert (got['submit_prt_ticks']+got['wait_prt_ticks'])&0xffffff==got['prt_ticks']
        assert got['prt_ticks']>=0 and got['mos_ticks']>=0
        groups.setdefault((got['case'],got['method']),[]).append(got)
    summaries=[]
    for key,values in groups.items():
        assert len(values)==4 and {r['sample'] for r in values}==set(range(4))
        n=values[0]['operations'];assert all(r['operations']==n for r in values)
        prt=[r['prt_ticks'] for r in values];mos=[r['mos_ticks'] for r in values]
        summaries.append(dict(case=key[0],method=key[1],operations=n,samples=4,raw_prt_ticks=prt,raw_mos_units=mos,
            raw_submit_prt_ticks=[r['submit_prt_ticks'] for r in values],raw_wait_prt_ticks=[r['wait_prt_ticks'] for r in values],
            median_prt_ticks_per_operation=statistics.median(prt)/n,
            median_mos_units_per_operation=statistics.median(mos)/n))
    total_prt=sum(int(r['prt_ticks']) for r in rows);total_mos=sum(int(r['mos_ticks']) for r in rows)
    assert total_mos>0
    return dict(architecture=manifest['architecture'],runtime_build=runtime_proof,
        frontend_commit=manifest['frontend_commit'],core_commit=manifest['core_commit'],
        fixture_inputs=plan['files'],firmware=identity['files']['esp32-firmware.bin'],mos=identity['files']['mos_platform.bin'],
        mode=136,swaps=0,batches=124,application_tx_bytes=len(expected_tx),application_tx_sha256=hashlib.sha256(expected_tx).hexdigest(),
        exact_completion_packet_count=497,raw_prt_ticks_total=total_prt,raw_mos_units_total=total_mos,
        nominal_prt_seconds=total_prt/1000,nominal_mos_seconds=total_mos/120,
        nominal_prt_to_mos_ratio=(total_prt/1000)/(total_mos/120),
        zero_mos_rows=sum(int(r['mos_ticks'])==0 for r in rows),summaries=summaries,
        elapsed_host_seconds=run['elapsed_host_seconds'],backend_stats=stats)


def compare(args):
    pi_host=Path(args.pi_host);oryx_host=Path(args.oryx_host)
    pi_run=Path(args.pi_run);oryx_run=Path(args.oryx_run)
    pi_evidence=Path(args.pi_evidence);oryx_evidence=Path(args.oryx_evidence)
    pi_manifest=Path(args.pi_runtime);oryx_manifest=Path(args.oryx_runtime)
    inputs=[pi_host,oryx_host,pi_run,oryx_run,pi_manifest,oryx_manifest,HERE/'HOST-CASES.json',HERE/'WORKLOAD.json',
        HERE/'TARGET-FIXTURES.json',HERE/'TARGET-BUILD.json',Path(__file__),HERE/'target_verify.py']
    for path in (pi_host,oryx_host):
        prefix=path.with_suffix('')
        inputs.extend([prefix.with_suffix('.csv'),prefix.parent/(prefix.name+'-checks.csv')])
    for directory in (pi_evidence,oryx_evidence):
        inputs.extend(directory/name for name in ('summary.json','timings.csv','done.txt','runtime/verified.json','runtime/stats.json',
            'runtime/mos-to-vdp.bin','runtime/vdp-to-mos.bin','runtime/vdp-to-mos-delivered.bin'))
    pins={str(path):sha(path) for path in inputs}
    ph,oh=host_audit(pi_host),host_audit(oryx_host)
    assert ph['architecture']=='aarch64' and oh['architecture']=='x86_64'
    assert ph['source_hashes']==oh['source_hashes'] and ph['case_manifest_sha256']==oh['case_manifest_sha256']
    assert ph['trials']==oh['trials']==5 and ph['minimum_ms']==oh['minimum_ms']==40
    assert ph['cases']==oh['cases']==16 and ph['samples']==oh['samples']==640
    assert ph['geometry']==oh['geometry'],'Cross-host bitmap check differs'
    assert ph['row_checksums']==oh['row_checksums'],'Cross-host operation/trial checksum differs'
    assert set(ph['groups'])==set(oh['groups']) and len(ph['groups'])==128
    pi_index={(r['case'],r['operation']):r for r in ph['summary']}
    host_comparison=[]
    for row in oh['summary']:
        previous=pi_index[row['case'],row['operation']]
        host_comparison.append(dict(case=row['case'],operation=row['operation'],checksum=row['checksum'],
            pi_median_cpu_us=previous['median_cpu_us'],oryx_median_cpu_us=row['median_cpu_us'],
            oryx_to_pi_cpu_ratio=row['median_cpu_us']/previous['median_cpu_us'],
            pi_median_wall_us=previous['median_wall_us'],oryx_median_wall_us=row['median_wall_us']))
    pt,ot=target_audit(pi_run,pi_evidence,pi_manifest),target_audit(oryx_run,oryx_evidence,oryx_manifest)
    assert pt['architecture']=='aarch64' and ot['architecture']=='x86_64'
    for key in ('frontend_commit','core_commit','fixture_inputs','firmware','mos','mode','swaps','batches',
                'application_tx_bytes','application_tx_sha256','exact_completion_packet_count'):
        assert pt[key]==ot[key],('Cross-host target identity mismatch',key)
    target_index={(r['case'],r['method']):r for r in pt['summaries']};target_comparison=[]
    for row in ot['summaries']:
        previous=target_index[row['case'],row['method']]
        assert row['operations']==previous['operations'] and row['samples']==previous['samples']==4
        target_comparison.append(dict(case=row['case'],method=row['method'],operations=row['operations'],pi=previous,oryx=row,
            oryx_to_pi_raw_prt_ratio=row['median_prt_ticks_per_operation']/previous['median_prt_ticks_per_operation']
            if previous['median_prt_ticks_per_operation'] else None))
    assert len(target_comparison)==31
    data=dict(schema=1,passed=True,scope='Independent matching-input Pi5/Oryx host-kernel and Flexe target comparison',
        host_architectures=[ph['architecture'],oh['architecture']],host_compilers=[ph['compiler'],oh['compiler']],
        host_samples_per_machine=640,host_checked_case_operation_groups=128,host_checked_case_operation_trial_rows=640,
        host_checked_geometry_cases=16,host_pixel_and_operation_checksums_identical=True,host_cpu_comparison=host_comparison,
        frontend_commit=pt['frontend_commit'],core_commit=pt['core_commit'],target_inputs_identical=True,
        target_application_tx_bytes=pt['application_tx_bytes'],target_application_tx_sha256=pt['application_tx_sha256'],
        pi_target=pt,oryx_target=ot,target_raw_count_comparison=target_comparison,
        physical_time_qualified=False,game_fps_claim=False,emulator_launched=False,
        limitations=['Host CPU timings measure different native CPUs/compilers; they are not ESP32 timings.',
            'PRT and MOS clocks advance through separate emulator scheduling paths; raw count ratios are observations, not a universal clock correction.',
            'Total host elapsed includes startup, loading, untimed warming/readback and cleanup, so it is not isolated draw time.',
            'No physical hardware execution, pixel-cache adoption, firmware modification or game optimization is inferred.'],
        input_sha256=pins)
    assert all(sha(path)==value for path,value in pins.items()),'Inputs changed during audit'
    output=HERE/'ORYX-COMPARISON-AUDIT.json'
    unchanged_write(output,(json.dumps(data,indent=2)+'\n').encode())
    text=['# Independent Pi5 and Oryx affine comparison','','Identical source and artwork pass cross-architecture pixel/checksum checks. All128 case/operation groups,640 trial rows and16 geometry checks agree. The isolated target fixtures also use identical guest inputs and identical110,240-byte application command streams; each passes124 batches and497 ordered completion/readback events.','',
        '| Target measurement | Pi5 Flexe | Oryx Flexe |','| --- | ---: | ---: |',
        f'| Raw PRT count total | {pt["raw_prt_ticks_total"]:,} | {ot["raw_prt_ticks_total"]:,} |',
        f'| Raw MOS units total | {pt["raw_mos_units_total"]:,} | {ot["raw_mos_units_total"]:,} |',
        f'| Nominal PRT/MOS ratio | {pt["nominal_prt_to_mos_ratio"]:.5f} | {ot["nominal_prt_to_mos_ratio"]:.5f} |',
        f'| Zero-MOS-delta batches | {pt["zero_mos_rows"]} | {ot["zero_mos_rows"]} |',
        f'| Whole-run host seconds | {pt["elapsed_host_seconds"]:.3f} | {ot["elapsed_host_seconds"]:.3f} |','',
        'The two emulator clocks remain separately reported. These count comparisons establish no physical VDP milliseconds or game FPS. Whole-run host seconds include startup/loading/warm operations/readback/file output/cleanup. Detailed raw per-method counts and native host CPU times remain separate in ORYX-COMPARISON-AUDIT.json.','',
        '| Host case | Pi cached affine µs | Oryx cached affine µs | Oryx/Pi CPU time |','| --- | ---: | ---: | ---: |']
    for row in host_comparison:
        if row['operation']=='cached_affine':text.append(f'| {row["case"]} | {row["pi_median_cpu_us"]:.4f} | {row["oryx_median_cpu_us"]:.4f} | {row["oryx_to_pi_cpu_ratio"]:.4f} |')
    text+=['','Host times execute the same extracted code on two different processors. Compiler versions and all raw samples are preserved. This audit neither changes old Pi results nor adopts a new renderer. No emulator, compiler or network action is performed by this comparison tool.']
    unchanged_write(HERE/'ORYX-COMPARISON-AUDIT.md',('\n'.join(text)+'\n').encode())
    print(json.dumps(dict(passed=True,host_groups=128,host_trial_rows=640,target_batches_each=124,
        identical_application_bytes=110240,pi_nominal_clock_ratio=pt['nominal_prt_to_mos_ratio'],
        oryx_nominal_clock_ratio=ot['nominal_prt_to_mos_ratio']),indent=2))


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    for flag,default in [('pi-host','HOST-pi01.json'),('oryx-host','HOST-oryx01.json'),
        ('pi-run','TARGET-RUN-full01.json'),('oryx-run','ORYX-RUN-full01.json'),
        ('pi-evidence','evidence/full01'),('oryx-evidence','evidence/oryx/full01'),
        ('pi-runtime','PI-RUNTIME-BUILD.json'),('oryx-runtime','ORYX-RUNTIME-BUILD.json')]:
        parser.add_argument('--'+flag,type=Path,default=HERE/default)
    compare(parser.parse_args())
