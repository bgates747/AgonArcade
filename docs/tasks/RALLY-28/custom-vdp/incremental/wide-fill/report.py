"""Reconstruct paired whole-frame fill timings and exact UART identities."""
from pathlib import Path
import hashlib,json,struct
HERE=Path(__file__).resolve().parent
sha=lambda b:hashlib.sha256(b).hexdigest()

def ticks(path):
    b=path.read_bytes();assert len(b)==902*3
    return [int.from_bytes(b[i:i+3],'little') for i in range(0,len(b),3)]

def report():
    fixtures=json.loads((HERE/'FIXTURES.json').read_text())
    directory=HERE/fixtures['byte']['directory'];motion=(directory/'motion.bin').read_bytes()
    expected=json.loads((directory/'expected.json').read_text())
    mh=bytes([23,0,160,4,0,5,194,0,0,24,0]);lh=bytes([23,0,160,5,0,5,194,0,0,24,0])
    lane=struct.pack('<6i',*expected['fixed_display_lanes'])
    reference=json.loads((HERE/'CONTROL-FINAL.json').read_text())
    rows=[];streams=[];runtime=[]
    for campaign in ('wideab01','wideba01'):
        runs=json.loads((HERE/('CAMPAIGN-'+campaign+'.json')).read_text())
        profiles=json.loads((HERE/('PROFILES-'+campaign+'.json')).read_text())
        for name,r in runs.items():
            assert r['passed'] and r['full_final_state_exact'] and r['input_hashes_preserved']
            assert (r['frames'],r['physics_ticks'],r['retained_replies'])==(900,3600,2913)
            at=HERE/'evidence'/campaign/name
            receipt=json.loads((at/'run.json').read_text())
            assert receipt['result']['final_buffers']==reference
            mos=ticks(at/'ticks.bin');prt=ticks(at/'prt.bin')
            mt=(mos[900]-mos[0])&0xffffff;pt=(prt[900]-prt[0])&0xffffff
            assert abs(900*120/mt-r['nominal_mos_fps'])<1e-10
            assert abs(900*1000/pt-r['prt']['nominal_fps_at_18432000_hz'])<1e-10
            wire=(at/'mos-to-vdp.bin').read_bytes();start=wire.index(mh+motion[:24]+lh+lane)-24
            frames=wire[start:start+900*347];assert len(frames)==312300
            for i in range(900):assert frames[347*i+24:347*i+94]==mh+motion[24*i:24*i+24]+lh+lane
            streams.append(frames)
            runtime.append({n:h for n,h in profiles[name]['input_sha256'].items()
                if n not in ('sdcard/rally25/script.bin','sdcard/rally25/expected.json')})
            rows.append(dict(campaign=campaign,case=name,frames=900,physics_ticks=3600,
                nominal_mos_units=mt,nominal_mos_seconds=mt/120,nominal_mos_fps=900*120/mt,
                nominal_prt_ticks=pt,nominal_prt_seconds=pt/1000,nominal_prt_fps=900*1000/pt,
                host_seconds_including_startup=r['host_seconds_including_startup'],
                timed_uart_sha256=sha(frames),all900motion_packets_exact=True,
                final_state_exact=True,clean_mos_return=r['clean_mos_return']))
    assert all(b==streams[0] for b in streams)
    assert sha(streams[0])=='370d42da5e5f05c6824e65862e5f1d5cec531e8f473deaa15cbb0014d8a88f45'
    assert all(p==runtime[0] for p in runtime)
    pooled={}
    for name in ('byte','word'):
        rs=[r for r in rows if r['case']==name];assert len(rs)==2
        ms=sum(r['nominal_mos_seconds'] for r in rs);ps=sum(r['nominal_prt_seconds'] for r in rs)
        pooled[name]=dict(frames=1800,nominal_mos_seconds=ms,nominal_mos_fps=1800/ms,
            nominal_mos_ms_per_frame=ms/1.8,nominal_prt_seconds=ps,nominal_prt_fps=1800/ps)
    pairs=[]
    for name in ('wideab01','wideba01'):
        p={r['case']:r for r in rows if r['campaign']==name}
        pairs.append(dict(campaign=name,nominal_mos_gain_percent=(p['word']['nominal_mos_fps']/p['byte']['nominal_mos_fps']-1)*100,
            nominal_prt_gain_percent=(p['word']['nominal_prt_fps']/p['byte']['nominal_prt_fps']-1)*100))
    session=json.loads((HERE/'SESSION-widesession01.json').read_text())
    assert session['error'] is None and session['boost_restored'] and not session['owned_emulator_processes_after']
    audit=json.loads((HERE/'FULL-FRAME-AUDIT.json').read_text())
    phase_audit=json.loads((HERE/'phase/TARGET-AUDIT.json').read_text())
    phase=json.loads((HERE/'phase/CAMPAIGN-fillphase01.json').read_text())
    phase_session=json.loads((HERE/'phase/SESSION-fillphasesession01.json').read_text())
    assert audit['passed'] and phase_audit['passed'] and phase['passed']
    assert phase_session['error'] is None and phase_session['boost_restored']
    assert not phase_session['owned_emulator_processes_after']
    byte=pooled['byte'];word=pooled['word']
    result=dict(task='INC-001-03',checkpoint='84fa64d',rows=rows,pooled=pooled,pairs=pairs,
        nominal_mos_gain_percent=(word['nominal_mos_fps']/byte['nominal_mos_fps']-1)*100,
        nominal_prt_gain_percent=(word['nominal_prt_fps']/byte['nominal_prt_fps']-1)*100,
        nominal_mos_ms_saved_per_frame=byte['nominal_mos_ms_per_frame']-word['nominal_mos_ms_per_frame'],
        entire_timed_uart_identical=True,bytes_per_frame=347,timed_uart_sha256=sha(streams[0]),
        all_full_final_worlds_exact_to_accepted_control=True,actor_player_road_command_and_runtime_unchanged=True,
        clocks='MOS nominal120units/s; PRT nominal18.432MHz emulated instruction clock; host durations include startup/teardown. Not physical FPS or isolated phase measurements.',
        session={k:session[k] for k in ('host_boot_id','original_boost','final_boost','boost_restored','max_temperature_celsius','elapsed_host_seconds')},
        modules={n:x['module_sha256'] for n,x in fixtures.items()},
        isolated_phase=dict(raw_emulated_counter_only=True,quiet_host_qualification=False,
            physics_ticks=0,sample_windows=phase['result']['sample_windows'],
            **phase['result']['summaries'],
            competing_host_jobs=True,max_temperature_celsius=phase_session['max_temperature_celsius'],
            boost_restored=True,owned_emulators_stopped=True),
        independent_audits={n:sha((HERE/n).read_bytes()) for n in ('FULL-FRAME-AUDIT.json','phase/TARGET-AUDIT.json')},
        disposition='No demonstrated whole-frame gain; retain accepted additive sampler with byte fills. Preserve wider fills as an unadopted experiment.',
        candidate_promoted=False,hardware_tested=False,human_visual_review_performed=False,
        results_review_pending=True)
    (HERE/'RESULTS.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2));return result

if __name__=='__main__':report()
