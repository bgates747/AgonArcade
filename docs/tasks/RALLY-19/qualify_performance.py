"""Audit R19-10 normal-clock offload, construction work and completed-frame budgets.

Native viewport swaps describe emulator frames, not physical ESP32 performance.
CPU work means scene/command construction; real driver waits are measured separately.
"""
import csv,io,json,math,re,statistics
from pathlib import Path
from profile import TASK
from native_run import sha

def distribution(values):
    values=sorted(values);assert values
    return {'samples':len(values),'minimum':values[0],'mean':statistics.mean(values),'median':statistics.median(values),
            'p95':values[math.ceil(.95*len(values))-1],'maximum':values[-1]}

def main():
    root=TASK/'evidence/golem-performance';root.mkdir(exist_ok=True)
    destination=root/'qualification.json';assert not destination.exists()
    evidence={};checks={}
    def record(path):evidence[str(path.relative_to(TASK))]=sha(path);return path
    def read(path):return json.loads(record(path).read_text())
    def integers(path):return [{k:int(v) for k,v in row.items()} for row in csv.DictReader(io.StringIO(record(path).read_text().split('# complete')[0]))]
    checked_includes={}
    def includes(build):
        work=Path(build['work'])
        if str(work) in checked_includes:return
        values={}
        for path in (work/'include').glob('*.hpp'):
            authoritative=TASK/path.name
            if not authoritative.exists():authoritative=TASK/'.work/oracle/include'/path.name
            assert sha(path)==sha(authoritative),path
            values[path.name]={'sha256':sha(path),'authoritative':str(authoritative)}
        checked_includes[str(work)]=values
    scene=read(TASK/'evidence/golem-scenery-visual/qualification.json');assert scene['pass'] and scene['visual_cases']==186
    front=read(TASK/'evidence/golem-frontend/qualification.json');assert front['pass'] and front['native_runs']==12
    observer=read(TASK/'evidence/golem-swap-overhead/initial/results.json');assert observer['pass']
    assert observer['observer_source_sha256']==sha(TASK/'swap_probe_linux.cpp')
    assert all(abs(r['observer_change_percent'])<=5 for r in observer['summary'])
    accounting=read(TASK/'evidence/baseline/byte-accounting.json')
    baseline=read(TASK/'evidence/baseline/manifest.json')
    track_reports={};bridge_report={};run_details=[]
    for phase in ['bridge','abba']:
        directory=TASK/'evidence/golem-render-work'/('qualified-'+phase)
        saved=read(directory/'results.json');assert saved['pass'] and saved['phase']==phase and len(saved['runs'])==8
        includes(saved['build'])
        for path,digest in {**saved['build']['source_hashes'],**saved['build']['outputs']}.items():assert sha(Path(path))==digest,path
        for track in ['oval','fuji']:
            assert sha(Path(saved['build']['work'])/(track+'.vdp'))==scene['frontend_bootstrap_sha256'][track]
            wanted=next(r['data'] for r in baseline['runs'] if r['track']==track and r['mode']=='submit')
            variants=['stock','oracle','oracle','stock'] if phase=='bridge' else ['stock','golem','golem','stock']
            subset=[r for r in saved['runs'] if r['track']==track]
            assert [(r['index'],r['variant']) for r in subset]==list(enumerate(variants))
            final_scenes=[]
            for i,variant in enumerate(variants):
                name=f'{track}-{i}-{variant}';path=directory/name;old=subset[i];manifest=read(path/'manifest.json')
                assert manifest['completed'] and manifest['headless'] and old['runtime_inputs_unchanged']
                assert manifest['runner_sha256']==sha(TASK/'measure_render_work.py')
                assert manifest['observer_sha256']==observer['library_sha256']
                actual=manifest['actual_command'];assert not any(t in actual for t in ['-u','--unlimited_cpu','--unlimited-cpu'])
                assert actual[-2:]==['--renderer','sw']
                for filename,digest in scene['runtime'].items():
                    values=[v['sha256'] for k,v in manifest['runtime_before'].items() if k.endswith('/'+filename)]
                    assert values==[digest],filename
                data=integers(path/('measurement.csv' if variant=='stock' else 'render-summary.csv'))[0]
                assert old['data']==data and data['frames']==64
                if variant=='stock':
                    assert data['pose_hash']==wanted['pose_hash'] and data['cars']==384 and data['road_bytes']==wanted['road_bytes'] and data['completed']==1
                else:
                    rows=integers(path/'render-rows.csv');assert [r['pose'] for r in rows]==list(range(64))
                    assert data['hash']==wanted['pose_hash'] and rows[-1]['hash']==data['hash']
                    raw_intervals=[rows[n+1]['start_ticks']-r['start_ticks'] if n<63 else data['batch_ticks']-r['start_ticks'] for n,r in enumerate(rows)]
                    assert old['guest_frame_ticks']==raw_intervals
                    if variant=='oracle':assert sum(r['road_bytes'] for r in rows)==wanted['road_bytes']
                    else:
                        assert [data[k] for k in ['valid','wrap','count','last','error','expected']]==[1,1,66,65,0,66]
                        assert data['host_scene_bytes']==6208 and all(r['road_bytes']==0 for r in rows)
                events=integers(path/'swaps.csv');assert len(events)==136
                kinds={k:[r for r in events if r['kind']==k] for k in [0,1]}
                for records in kinds.values():
                    assert [r['ordinal'] for r in records]==list(range(68))
                    assert all(x['end_ns']<=y['begin_ns'] for x,y in zip(records,records[1:]))
                for c,v in zip(kinds[0],kinds[1]):assert c['begin_ns']<=v['begin_ns']<=v['end_ns']<=c['end_ns']
                visible=[(kinds[1][n]['end_ns']-kinds[1][n-1]['end_ns'])/1e6 for n in range(5,68)]
                canvas=[(kinds[0][n]['end_ns']-kinds[0][n-1]['end_ns'])/1e6 for n in range(5,68)]
                assert visible==old['visible_intervals_ms'] and canvas==old['canvas_intervals_ms']
                if phase=='bridge':final_scenes.append(record(path/'scene.csv').read_bytes())
                run_details.append({'phase':phase,'track':track,'variant':variant,'index':i,
                                    'visible_intervals_ms':distribution(visible),'canvas_intervals_ms':distribution(canvas),
                                    'guest_frame_ms':distribution([n*1000/120 for n in old['guest_frame_ticks']]) if variant!='stock' else None,
                                    'batch_submission_mean_ms':old['batch_ticks']*1000/120/64,
                                    'application_ready_ms':data['ready_ticks']*1000/120 if variant!='stock' else None,
                                    'VDP_mode_swap_to_warmup_return_ms':(kinds[0][3]['end_ns']-kinds[0][0]['begin_ns'])/1e6,
                                    'process_memory':{k:manifest[k] for k in ['warmed_process_memory','submitted_process_memory','finished_process_memory']}})
            left=[v for r in subset if r['variant']=='stock' for v in r['visible_intervals_ms']]
            right=[v for r in subset if r['variant']!='stock' for v in r['visible_intervals_ms']]
            change=100*(statistics.median(right)/statistics.median(left)-1)
            if phase=='bridge':
                assert all(s==final_scenes[0] for s in final_scenes)
                checks[track+'_oracle_bridge']=abs(change)<=5
                bridge_report[track]={'final_geometry_exact':True,'stock_ms':distribution(left),'instrumented_ms':distribution(right),'median_change_percent':change}
            else:
                checks[track+'_median']=statistics.median(right)<=33.33
                checks[track+'_p95']=distribution(right)['p95']<=50
                checks[track+'_regression']=change<=5
                track_reports[track]={'stock_visible_frame_ms':distribution(left),'golem_visible_frame_ms':distribution(right),'median_change_percent':change}
    calibration=read(TASK/'evidence/golem-cpu-calibration/initial/results.json')
    assert calibration['pass'] and calibration['cases']==32 and calibration['identical_wrapper_and_marker_object_instructions']
    for path,digest in calibration['source_hashes'].items():assert sha(Path(path))==digest,path
    cal_rows=integers(TASK/'evidence/golem-cpu-calibration/initial/cpu-calibration.csv')
    cal_log=record(TASK/'evidence/golem-cpu-calibration/initial/emulator.log').read_text()
    cal_breaks=[int(v) for v in re.findall(r'Cycles since last break: (\d+)',cal_log)];assert len(cal_breaks)==64
    assert [r['cycles'] for r in calibration['rows']]==cal_breaks[1::2] and len(cal_rows)==32
    for i,row in enumerate(cal_rows):
        kind=i//4;seed=[0,250,65530,0xfffffff0][i%4];size=[0,1,1,3,9,14,97,2048][kind];count=64 if kind else 0
        assert row=={'kind':kind,'seed':seed,'bytes':(seed+count*size)%(2**32),'calls':(seed+count)%(2**32)}
    fragments=read(TASK/'evidence/golem-cpu-calibration/initial/identical-wrappers.json')
    for variant in ['measured','calibration']:
        listing=record(TASK/'evidence/golem-cpu-calibration/initial'/(variant+'-object.txt')).read_text()
        for symbol,expected in fragments.items():
            match=re.search(r'^[0-9a-f]+ <'+re.escape(symbol)+r'>:\n(.*?)(?=\n[0-9a-f]+ <|\Z)',listing,re.M|re.S)
            assert match and re.sub(r'^\s*[0-9a-f]+:',':',match[1],flags=re.M).strip()==expected
    empty=calibration['empty_upper_cycles'];call=calibration['call_loop_upper_cycles']
    assert empty==max(cal_breaks[1::2][:4]) and call==max(math.ceil(n/64) for n in cal_breaks[1::2][4:])
    for track in ['oval','fuji']:
        cpu={'oracle':[],'golem':[]};adjusted=[];byte_rows=integers(TASK/'evidence/baseline'/(track+'-bytes.csv'));pose_hashes=None
        for index,variant in enumerate(['oracle','golem','golem','oracle']):
            path=TASK/'evidence/golem-cpu-work'/f'abba-{track}-{index}-{variant}'
            saved=read(path/'results.json');manifest=read(path/'manifest.json')
            assert saved['pass'] and saved['poses']==64 and manifest['completed'] and manifest['headless'] and manifest['debugger']
            includes(manifest['build'])
            for filename,digest in {**manifest['build']['source_hashes'],**manifest['build']['outputs']}.items():assert sha(Path(filename))==digest,filename
            rows=integers(path/'cpu-work.csv');assert rows==saved['per_pose']
            if pose_hashes is None:pose_hashes=[r['hash'] for r in rows]
            assert [r['hash'] for r in rows]==pose_hashes
            log=record(path/'emulator.log').read_text();breaks=[int(v) for v in re.findall(r'Cycles since last break: (\d+)',log)]
            assert len(breaks)==128 and breaks[1::2]==saved['cycles']
            for row,cycles,byte_row in zip(rows,saved['cycles'],byte_rows):
                assert row['bytes']==(byte_row['total_bytes'] if variant=='oracle' else 117)
                cpu[variant].append(cycles)
                if variant=='oracle':
                    lower=cycles-empty-row['calls']*call;assert lower>0;adjusted.append(lower)
        reduction=100*(1-statistics.mean(cpu['golem'])/statistics.mean(adjusted))
        checks[track+'_CPU_work']=reduction>=50
        total=accounting['tracks'][track]['batch_bytes']['total_bytes']/64
        scene_bytes=total-17;wire_reduction=100*(1-100/scene_bytes)
        checks[track+'_scene_bytes']=100<=128 and wire_reduction>=75
        track_reports[track].update(CPU_construction_cycles={'oracle_raw':distribution(cpu['oracle']),'oracle_conservative_lower':distribution(adjusted),
                                                           'golem_raw_upper':distribution(cpu['golem']),'conservative_reduction_percent':reduction},
                                    UART={'oracle_mean_scene_including_swap':scene_bytes,'golem_scene_including_swap':100,'scene_reduction_percent':wire_reduction,
                                          'fixture_HUD_bytes':17,'oracle_mean_total':total,'golem_total':117})
    report={'milestone':'R19-10','scope':__doc__,'pass':all(checks.values()),'checks':checks,'tracks':track_reports,
            'oracle_bridge':bridge_report,'runs':run_details,'resources':scene['resources'],'overhead':{'sink_empty_cycles':empty,'sink_call_upper_cycles':call,'observer':observer['summary']},
            'sampling':'Per-track serial ABBA, two64-pose batches/variant.128 guest intervals and126 steady native intervals; mode/startup/two warmups excluded. '
                       'First measured native transition contains host marker handshake and is excluded. Median is conventional; p95 is nearest rank.',
            'limits':'Emulator only. CPU figures measure command construction, excluding MOS driver/transmission waits; actual normal UART waits remain in real-rendering runs. '
                     'Process RSS includes emulator/host overhead, not physical VDP heap. Ready time is program entry through warmup, excluding MOS binary load/firmware boot. '
                     'Stock original lacks that counter; its native warm-stage span is separately reported. GP readback is post-batch admission proof, not frame timing.',
            'audit_sha256':sha(Path(__file__)),'evidence':evidence,'checked_includes':checked_includes,
            'remaining':'R19-11 long stability, memory/lifecycle/malformed replay and independent review; R19-12 delivery. No hardware acceptance.'}
    destination.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({k:report[k] for k in ['pass','checks','tracks']},indent=2));assert report['pass'],'Frozen performance criteria did not all pass'

if __name__=='__main__':main()
