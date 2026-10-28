"""Cross-check full-turn timestamps against independent raw UART captures."""
from pathlib import Path
import json
import statistics
import struct
from analyze import occurrences

HERE = Path(__file__).resolve().parent


def analyze():
    base = HERE/'positions'
    output = {}
    for name in ('center','southretry'):
        config = json.loads((base/('PROFILE-'+name+'.json')).read_text())
        run = json.loads((base/('RUN-'+name+'.json')).read_text())
        assert run['error'] is None and run['process_exit']==0
        assert run['inputs_preserved'] and run['boost_restored']
        assert run['original_boost']==run['final_boost']=='1'
        assert not any(run['backend_stats'][k] for k in ('failed','unhandled','unregistered','unmapped'))
        evidence = base/'evidence'/name
        rows=[]
        for line in (evidence/'timed.csv').read_text().splitlines():
            ns,kind,seq,x,y,angle=line.split(',')
            rows.append(dict(ns=int(ns),kind=kind,sequence=int(seq),x=int(x),y=int(y),angle=int(angle)))
        assert all(a['ns']<=b['ns'] for a,b in zip(rows,rows[1:]))
        by_kind={k:[r for r in rows if r['kind']==k] for k in 'PRDCF'}
        assert not by_kind['F']
        incoming=(evidence/'vdp-to-mos-delivered.bin').read_bytes()
        outgoing=(evidence/'mos-to-vdp.bin').read_bytes()
        raw_done=occurrences(incoming,b'\x81\x0aW3DR\x01\x01\x3d\x57',12)
        seq=[struct.unpack_from('<H',r,10)[0] for _,r in raw_done]
        assert seq==[r['sequence'] for r in by_kind['D']]==list(range(1,len(seq)+1))
        raw_pose=occurrences(outgoing,b'\x17\0\xa0\x01\0\x4a\x02',17)
        poses=[struct.unpack_from('<iiH',r,7) for _,r in raw_pose]
        assert poses==[(r['x'],r['y'],r['angle']) for r in by_kind['P']]
        assert all((x,y)==tuple(int(v*65536) for v in config['position']) for x,y,a in poses)
        gameplay=outgoing[raw_pose[0][0]:]
        assert gameplay.count(b'\x17\0\xa0\x01\0\x4a\x07')==len(by_kind['R'])
        assert gameplay.count(b'\x17\0\xc3')==len(by_kind['C'])==len(by_kind['D'])
        assert len(by_kind['D'])<=len(by_kind['R'])<=len(by_kind['D'])+1
        # The center run stops with one final request still in flight. It is
        # after the completed measured turn and contributes no timing sample.
        for index,done in enumerate(by_kind['D']):
            assert by_kind['R'][index]['ns']<done['ns']<by_kind['C'][index]['ns']
            if index+1<len(by_kind['R']):assert by_kind['C'][index]['ns']<by_kind['R'][index+1]['ns']
        turn=run['turn'];first=turn['start']['sequence'];last=turn['end']['sequence']
        assert last-first==turn['completed_frame_intervals']==120
        done=by_kind['D'][first-1:last]
        requested=by_kind['R'][first-1:last]
        headings=[r['angle'] for r in requested]
        assert len(set(headings))==120 and headings[0]==headings[-1]
        assert all((a-b)%360==3 for a,b in zip(headings,headings[1:]))
        assert turn['degrees']==360 and turn['returns_to_start_heading']
        seconds=(done[-1]['ns']-done[0]['ns'])/1e9
        assert seconds==turn['host_seconds']
        intervals=[(b['ns']-a['ns'])/1e6 for a,b in zip(done,done[1:])]
        latency=[(d['ns']-r['ns'])/1e6 for d,r in zip(done[1:],requested[1:])]
        row=dict(tile=config['tile'],position=config['position'],degrees=360,
            unique_rendered_headings=120,completed_frame_intervals=120,
            host_seconds=seconds,completed_renderer_fps=120/seconds,
            frame_interval_ms=dict(min=min(intervals),mean=statistics.mean(intervals),max=max(intervals)),
            request_to_delivered_completion_ms=dict(min=min(latency),mean=statistics.mean(latency),max=max(latency)),
            latency_scope='Host submission trace to delivered callback; includes transport/queues/drawing/readout, not isolated VDP CPU time',
            raw_and_timestamped_events_match=True,all_completions_presented=True,
            full_capture_completions=len(seq),full_capture_requests=len(by_kind['R']),
            unmeasured_shutdown_request_in_flight=len(by_kind['R'])-len(seq),
            no_translation=True,no_fizzle=True,backend_errors=0,inputs_preserved=True,
            boost_restored=True,max_sampled_temperature=max(v for s in run['samples'] for v in s['temperatures_celsius'].values()))
        output[name]=row
    a=json.loads((base/'PROFILE-center.json').read_text())['inputs_sha256']
    b=json.loads((base/'PROFILE-southretry.json').read_text())['inputs_sha256']
    assert {n for n in a if a[n]!=b[n]}=={'sdcard/wolf3d/level_00/state_medium.w3l'}
    original_south=json.loads((base/'PROFILE-south.json').read_text())
    retry=json.loads((base/'PROFILE-southretry.json').read_text())
    assert original_south['inputs_sha256']==retry['inputs_sha256']
    failed=json.loads((base/'RUN-south.json').read_text())
    assert failed['error'].startswith('TimeoutError') and failed['turn'] is None
    assert failed['boost_restored'] and failed['inputs_preserved'] and failed['process_exit']==0
    prefix=(base/'evidence/south/mos-to-vdp.bin').read_bytes()
    assert (base/'evidence/center/mos-to-vdp.bin').read_bytes().startswith(prefix)
    assert not (base/'evidence/south/timed.csv').exists()
    returned=json.loads((base/'RETURN-VERIFICATION.json').read_text())
    assert returned['profile_input_hashes_preserved'] and not returned['owned_emulators_after'] and returned['boost_restored']=='1'
    result=dict(status='PASS',positions=output,game_policy_cap_nominal_hz=30,
        same_application_firmware_assets_runtime_and_trace_shim=True,
        only_between_position_input_change='Isolated medium-state player coordinates',
        preserved_startup_failure=dict(case='south',outbound_prefix_bytes=len(prefix),
            exact_successful_control_prefix=True,before_game_rendering=True,identical_retry_passed=True),
        silent_headless=True,all_owned_emulators_stopped=True,boost_restored=True,
        limits=['One full turn per position; normal AI/combat active',
            'Extra host timestamp observer overhead included; game/wire bytes unchanged',
            'Capped actual application, not flat-out maximum renderer capacity',
            'Completion and C3 submission, not physical monitor scanout or hardware timing'])
    (base/'RESULTS.json').write_text(json.dumps(result,indent=2)+'\n')
    for name,row in output.items():print(row['tile'],row['host_seconds'],row['completed_renderer_fps'],row['request_to_delivered_completion_ms'])


if __name__=='__main__':analyze()
