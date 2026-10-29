"""Reconstruct paired moving-traffic timings and transmitted frame identities."""
from pathlib import Path
import hashlib,json,struct,zipfile
HERE=Path(__file__).resolve().parent
sha=lambda b:hashlib.sha256(b).hexdigest()

def samples(path):
    b=path.read_bytes();assert len(b)==902*3
    return [int.from_bytes(b[i:i+3],'little') for i in range(0,len(b),3)]

def report():
    registry=json.loads((HERE/'FIXTURES.json').read_text())
    scene=HERE/registry['additive']['directory'];motion=(scene/'motion.bin').read_bytes()
    meta=json.loads((scene/'expected.json').read_text())
    mh=bytes([23,0,160,4,0,5,194,0,0,24,0]);lh=bytes([23,0,160,5,0,5,194,0,0,24,0])
    lane=struct.pack('<6i',*meta['fixed_display_lanes'])
    rows=[];frame_streams=[];runtime=[]
    reference=json.loads((HERE/'CONTROL-FINAL.json').read_text())
    for campaign in ('motionab02','motionba02'):
        runs=json.loads((HERE/('CAMPAIGN-'+campaign+'.json')).read_text())
        profiles=json.loads((HERE/('PROFILES-'+campaign+'.json')).read_text())
        for name,run in runs.items():
            assert run['passed'] and run['input_hashes_preserved'] and run['full_final_state_exact']
            assert run['frames']==900 and run['physics_ticks']==3600 and run['retained_replies']==2913
            folder=HERE/'evidence'/campaign/name
            raw=json.loads((folder/'run.json').read_text())
            assert raw['result']['final_buffers']==reference
            mos=samples(folder/'ticks.bin');prt=samples(folder/'prt.bin')
            mt=(mos[900]-mos[0])&0xffffff;pt=(prt[900]-prt[0])&0xffffff
            mf=900*120/mt;pf=900*1000/pt
            assert abs(mf-run['nominal_mos_fps'])<1e-10
            assert abs(pf-run['prt']['nominal_fps_at_18432000_hz'])<1e-10
            wire=(folder/'mos-to-vdp.bin').read_bytes()
            first=mh+motion[:24]+lh+lane;start=wire.index(first)-24
            frames=wire[start:start+900*347];assert len(frames)==900*347
            for i in range(900):assert frames[i*347+24:i*347+94]==mh+motion[i*24:(i+1)*24]+lh+lane
            frame_streams.append(frames)
            runtime.append({n:h for n,h in profiles[name]['input_sha256'].items()
                if n not in ('sdcard/rally25/script.bin','sdcard/rally25/native.vdu','sdcard/rally25/expected.json')})
            rows.append(dict(campaign=campaign,case=name,frames=900,physics_ticks=3600,
                nominal_mos_units=mt,nominal_mos_seconds=mt/120,nominal_mos_fps=mf,
                nominal_prt_ticks=pt,nominal_prt_seconds=pt/1000,nominal_prt_fps=pf,
                host_seconds_including_startup=run['host_seconds_including_startup'],
                completed_frame_uart_sha256=sha(frames),all_900_motion_packets_exact=True,
                final_state_exact=True,clean_mos_return=run['clean_mos_return']))
    assert all(b==frame_streams[0] for b in frame_streams)
    assert all(r==runtime[0] for r in runtime)
    pooled={}
    for name in ('affine','additive'):
        rs=[r for r in rows if r['case']==name];assert len(rs)==2
        frames=sum(r['frames'] for r in rs);mos=sum(r['nominal_mos_seconds'] for r in rs);prt=sum(r['nominal_prt_seconds'] for r in rs)
        pooled[name]=dict(frames=frames,nominal_mos_seconds=mos,nominal_mos_fps=frames/mos,
            nominal_mos_ms_per_frame=mos/frames*1000,nominal_prt_seconds=prt,nominal_prt_fps=frames/prt)
    base=pooled['affine'];candidate=pooled['additive']
    session=json.loads((HERE/'SESSION-motioncmpsession03.json').read_text())
    assert session['error'] is None and session['boost_restored'] and not session['owned_emulator_processes_after']
    result=dict(task='INC-001-02-CMP01–03',rows=rows,pooled=pooled,
        nominal_mos_gain_percent=(candidate['nominal_mos_fps']/base['nominal_mos_fps']-1)*100,
        nominal_prt_gain_percent=(candidate['nominal_prt_fps']/base['nominal_prt_fps']-1)*100,
        nominal_mos_ms_saved_per_frame=base['nominal_mos_ms_per_frame']-candidate['nominal_mos_ms_per_frame'],
        identical_complete_frame_uart_stream=True,completed_frame_uart_bytes_per_run=900*347,
        identical_motion_table_driver_assets_and_runtime=True,full_final_worlds_equal=True,
        clocks='MOS nominal120units/s; PRT nominal18.432MHz/18432clocks per interrupt; host time includes startup/teardown. Emulator estimates, not physical timing.',
        snapshot_limit='Final captures are the MOS prompt, not a per-frame rendering parity proof; Author accepted moving sampler visuals.',
        session={k:session[k] for k in ('host_boot_id','original_boost','final_boost','boost_restored','max_temperature_celsius','elapsed_host_seconds')},
        modules={n:e['module_sha256'] for n,e in registry.items()},hardware_tested=False,
        excluded_attempt='motionab01 incomplete pair: affine passed, additive startup stalled before timed frames; guarded abort preserved. Session02 thermal abort95C before launching. Identical-byte fresh02profiles reserved for qualified pairs in session03.')
    (HERE/'RESULTS.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))
    return result

if __name__=='__main__':report()
