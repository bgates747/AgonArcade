"""Verify independent state/UART isolation and summarize the whole-scene census."""
from pathlib import Path
import csv,hashlib,json,shutil
from reference import verify
HERE=Path(__file__).resolve().parent;WORK=HERE/'.work';EVIDENCE=HERE/'evidence'
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
def physics(directory):
    r=json.loads((directory/'runtime/result.json').read_text());s=r['summary']
    assert r['reason']=='guest-files' and r['exit']==0 and r['identities_unchanged']
    assert r['forced_sdl']=={'video':'dummy','audio':'dummy'}
    assert s['vector_restored']=='1' and int(s['steps'])==8192 and int(s['rounds'])==2
    assert int(s['mos_units'])>=1200
    stats=r['backend_stats'];assert not stats['failed'] and all(stats[x]==0 for x in ('unhandled','unregistered','unmapped'))
    wire=(directory/'runtime/mos-to-vdp.bin').read_bytes();a=wire.index(b'CAP_BEGIN')+9;b=wire.index(b'CAP_END',a)
    assert wire[a:b]==b'', 'No application wire traffic inside physics timing window'
    coverage=verify(directory/'state.csv')
    for name,digest in r['outputs'].items():assert sha(directory/name)==digest
    assert sha(directory/'capacity.bin')==r['identity']['files']['sdcard/test/arcade/rally28/capacity/capacity.bin']
    mos_seconds=int(s['mos_units'])/120;prt_seconds=int(s['prt_ticks'])/1000
    scenarios=[]
    for which,p,m in csv.reader((directory/'phases.csv').open()):
        scenarios.append({'scenario':int(which),'steps':2048,'mos_units':int(m),'prt_ticks':int(p),
            'mos_ms_per_step':int(m)/120*1000/2048,'prt_nominal_ms_per_step':int(p)/2048})
    return {'verified':True,'steps':8192,'mos_seconds':mos_seconds,'prt_nominal_seconds':prt_seconds,
        'mos_steps_per_second':8192/mos_seconds,'prt_nominal_steps_per_second':8192/prt_seconds,
        'clock_difference_pct':100*(prt_seconds/mos_seconds-1),'scenarios':scenarios,'coverage_per_round':coverage,
        'state_fields_checked':420,'application_wire_bytes_inside_window':0,'host_total_seconds':r['host_seconds']}
def cpu(directory,wire):
    r=json.loads((directory/'runtime/result.json').read_text());s=r['summary']
    assert r['reason']=='guest-files' and r['exit']==0 and r['identities_unchanged']
    assert r['forced_sdl']=={'video':'dummy','audio':'dummy'}
    assert s['vector_restored']=='1' and s['frames']=='900'
    assert int(s['bytes'])==wire['total'] and s['position']=='1202800' and s['phase']=='1600'
    assert sha(directory/'capacity.bin')==r['identity']['files']['sdcard/test/arcade/rally28/wirecpu/capacity.bin']
    stats=r['backend_stats'];assert not stats['failed'] and all(stats[x]==0 for x in ('unhandled','unregistered','unmapped'))
    for name,digest in r['outputs'].items():assert sha(directory/name)==digest
    stages={k:int(s[k])/900 for k in ('advance_prt','geometry_prt','emission_prt')}
    return {'verified':True,'frames':900,'bytes':int(s['bytes']),'mos_seconds':int(s['mos_units'])/120,
        'prt_nominal_seconds':int(s['prt_ticks'])/1000,'mos_mean_ms_per_frame':int(s['mos_units'])/120*1000/900,
        'prt_nominal_mean_ms_per_frame':int(s['prt_ticks'])/900,'stage_nominal_prt_ms_per_frame':stages,
        'host_total_seconds':r['host_seconds'],'limitations':['This is CPU construction with a separate opaque sink, not rendered FPS.','No live UART transfer, CTS stall or VDP raster/swap/completion cost.','Advance uses the preserved simplified centerline wire workload, not actual-player physics.']}

def census():
    a,b=WORK/'wire-final-ordinary',WORK/'wire-final-sanitized'
    assert (a/'frames.csv').read_bytes()==(b/'frames.csv').read_bytes()
    for p in a.glob('*.bin'):assert sha(p)==sha(b/p.name),p
    rows=[{k:int(v) for k,v in r.items()} for r in csv.DictReader((a/'frames.csv').open())];assert len(rows)==900
    names=['road','traffic_signs','player','scenery','hud','panel','bottom','viewport','swap','audio']
    totals={k:sum(r[k] for r in rows) for k in names}
    for name in names:assert (a/('wire-'+name+'.bin')).stat().st_size==totals[name]
    wire=(a/'wire-road.bin').read_bytes();at=quads=rectangles=0
    while at<len(wire):
        assert wire[at]==18 and wire[at+1]==0;at+=3
        assert wire[at:at+2]==bytes([25,4]);at+=6
        if wire[at:at+2]==bytes([25,4]):
            at+=6;assert wire[at:at+2]==bytes([25,85]);at+=6
            assert wire[at:at+2]==bytes([25,85]);at+=6;quads+=1
        else:assert wire[at:at+2]==bytes([25,101]);at+=6;rectangles+=1
    assert quads*27+rectangles*15==totals['road']
    bands=sum(r['bands'] for r in rows);painted=quads-4*bands;assert 0<=painted<=bands
    # Resident templates copy final pixel coordinates from one compact plane.
    # 4-layer band:16 x-coordinates + two y words=36B. 5-layer:44B.
    # Per-band upstream patch11B + payload36/44B + CALL6B; colours static
    # in two variants. No projection or width arithmetic on VDP.
    road_candidate=(bands-painted)*53+painted*61+rectangles*15
    frames=[sum(r[k] for k in names) for r in rows];total=sum(totals.values())
    return {'verified':True,'frames':900,'bytes':totals,'total':total,'mean_bytes_per_frame':total/900,
        'min_bytes_per_frame':min(frames),'max_bytes_per_frame':max(frames),
        'shares_pct':{k:100*v/total for k,v in totals.items()},'setup_bytes':(a/'setup.bin').stat().st_size,
        'bands':bands,'painted_bands':painted,'quads':quads,'rectangles_including_finish':rectangles,
        'mean_road_bytes':totals['road']/900,'mean_road_template_model_bytes':road_candidate/900,
        'road_template_model_saving_pct':100*(1-road_candidate/totals['road']),
        'mean_link_floor_ms_at_1152000_8N1':total/900*10/1152000*1000,
        'scroll_frames':sum(r['scroll'] for r in rows),'repaint_frames':sum(r['repaint'] for r in rows),
        'visible_cars':sum(r['cars'] for r in rows),'visible_signs':sum(r['signs'] for r in rows),
        'existing_frame_completion_requests':0,'proposed_completion_upstream_bytes_per_frame':7,
        'proposed_keyboard_reply_downstream_bytes_per_frame':6,'host_sdk_wire_identity':{p.name:sha(p) for p in sorted(a.glob('*.bin'))},
        'limitations':['Stock buffered template figures are a complete upstream byte model, not a tested speedup.','Setup excludes mode/keyboard/MOS boot handshakes; includes assets/fonts/mirror/audio setup.','No real UART/CTS blocking or VDP completed-drawing timing in the CPU sink benchmark.']}
if __name__=='__main__':
    wire=census()
    report={'physics':physics(EVIDENCE/'physics02'),'wire':wire,'cpu':cpu(EVIDENCE/'wirecpu02',wire)}
    (EVIDENCE/'verification.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
