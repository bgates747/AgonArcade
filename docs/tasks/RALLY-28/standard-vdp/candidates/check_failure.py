"""Describe exact failed submission/reply prefixes without inventing partial-run FPS."""
from pathlib import Path
import argparse,bisect,csv,json
from verify import EVIDENCE,NAMES,expected,read,sha,shadow

def check(variant,kind):
    directory=EVIDENCE/variant/kind
    report=json.loads((directory/'runtime/result.json').read_text())
    assert report['forced_sdl']=={'video':'dummy','audio':'dummy'} and report['identities_unchanged']
    summary=report.get('summary',{});mode=report['identity']['mode'];assert mode
    assert summary.get('frames')!='900' or summary.get('failure')!='none' or report['reason']!='guest-files'
    for name in ('candidate.bin','mode.txt'):
        assert sha(directory/name)==report['identity']['files']['sdcard/test/arcade/rally28/candidate/'+name]
    setup,stream,rows=expected(variant,mode);sent=read(directory/'runtime/mos-to-vdp.bin')
    at=sent.find(setup[:64]);prefix=0;data=b'';setup_ok=False
    if at>=0:
        tail=sent[at:];n=min(len(tail),len(setup));assert tail[:n]==setup[:n]
        setup_ok=n==len(setup)
        if setup_ok:
            fence=bytes([23,0,202,23,0,128,93]);n=min(len(tail)-len(setup),7)
            assert tail[len(setup):len(setup)+n]==fence[:n]
            data=tail[len(setup)+7:]
            prefix=next((i for i,(a,b) in enumerate(zip(data,stream)) if a!=b),min(len(data),len(stream)))
    if summary:
        assert setup_ok and prefix>=int(summary['bytes']),('target differs from exact host prefix',prefix,summary['bytes'])
        prefix=int(summary['bytes'])
    ends=[];total=0
    for row in rows:
        total+=sum(int(row[k]) for k in NAMES)+7;ends.append(total)
    submitted=bisect.bisect_right(ends,prefix)
    rx=read(directory/'runtime/vdp-to-mos.bin');delivered=read(directory/'runtime/vdp-to-mos-delivered.bin')
    packets=[];pos=0
    while pos+2<=len(rx):
        assert rx[pos]&128
        n=rx[pos+1]
        if pos+2+n>len(rx):break
        packets.append((rx[pos]&127,rx[pos+2:pos+2+n]));pos+=2+n
    fence_at=next((i for i,p in enumerate(packets) if p==(0,bytes([93]))),None)
    markers=[] if fence_at is None else [p for op,p in packets[fence_at+1:] if op==1 and len(p)==4 and p[2]==0]
    if summary:assert len(markers)==int(summary['frames'])
    result={'qualified_complete_run':False,'variant':variant,'mode':mode,'runner_reason':report['reason'],'guest_failure':summary.get('failure'),
        'guest_completed_frames':int(summary['frames']) if summary else None,'submitted_complete_frame_requests':submitted,'received_frame_markers':len(markers),
        'exact_setup_verified':setup_ok,'exact_expected_submission_prefix_bytes':prefix,'bytes_into_next_frame':prefix-(ends[submitted-1] if submitted else 0),'captured_frame_bytes':len(data),'unmatched_or_post_failure_suffix_bytes':len(data)-prefix,
        'return_bytes_unchanged':rx==delivered,'incomplete_return_packet_bytes':len(rx)-pos,'host_window_includes_failure_seconds':report.get('host_window_seconds'),
        'backend_stats':report.get('backend_stats'),'root_cause_established':False}
    if mode==2 and summary and int(summary.get('shadow_calls','0')):
        result['shadow_reference']=shadow(summary,directory)
        result['shadow_calls']=int(summary['shadow_calls'])
        result['shadow_debt_mos_units']=int(summary['shadow_debt'])
        result['max_shadow_debt_mos_units']=int(summary['max_shadow_debt'])
        frame_rows=list(csv.DictReader((directory/'frames.csv').open()))
        result['physics_calls_during_completed_render_waits']=sum(int(r['physics_while_pending']) for r in frame_rows)
        window=report.get('host_window_seconds')
        result['physics_steps_per_host_second_including_failed_wait']=int(summary['shadow_calls'])/window if window and abs(report.get('host_suspend_seconds',100))<.1 else None
    (directory/'FAILURE-CHECK.json').write_text(json.dumps(result,indent=2)+'\n');return result
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('variant');p.add_argument('kind');a=p.parse_args();print(json.dumps(check(a.variant,a.kind),indent=2))
