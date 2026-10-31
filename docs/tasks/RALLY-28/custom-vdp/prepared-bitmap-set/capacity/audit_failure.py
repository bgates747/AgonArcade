"""Read-only audit of the first failed small case; does not import its verifier."""
from pathlib import Path
import hashlib
import json
import struct

HERE=Path(__file__).resolve().parent
EVIDENCE=HERE/'evidence/capacity01/small'
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()


def audit():
    tx=(EVIDENCE/'mos-to-vdp.bin').read_bytes()
    rx=(EVIDENCE/'vdp-to-mos.bin').read_bytes()
    at=0;replies=[];packets=0
    while at<len(rx):
        assert at+2<=len(rx)
        channel,size=rx[at:at+2];assert channel>=128
        payload=rx[at+2:at+2+size];assert len(payload)==size
        if payload.startswith(b'VDPL'):
            assert channel==129 and size==10 and payload[4]==1
            replies.append(payload)
        at+=2+size;packets+=1
    assert len(replies)==240
    requests=[]
    for token,reply in enumerate(replies,1):
        assert struct.unpack_from('<H',reply,6)[0]==token
        matches=[]
        for op,count in ((1,8),(2,6),(3,2),(4,2),(5,6)):
            head=b'\x17\0\xd8'+struct.pack('<HBBHBB',6+count,1,op,token,1,0)
            start=tx.find(head)
            if start>=0:
                assert tx.find(head,start+1)<0
                matches.append((start,op,tx[start+11:start+11+count]))
        assert len(matches)==1,(token,matches)
        start,op,fields=matches[0]
        if requests:assert start>requests[-1]['offset']
        requests.append(dict(token=token,offset=start,operation=op,fields_hex=fields.hex(),
            reply_kind=reply[5],value=struct.unpack_from('<H',reply,8)[0]))
    errors=[r for r in requests if r['reply_kind']==5]
    assert [(r['token'],r['operation'],r['fields_hex'],r['value']) for r in errors]==[
        (227,5,struct.pack('<HI',51999,10627).hex(),3),
        (238,5,struct.pack('<HI',52000,0).hex(),2)]
    assert [r['token'] for r in requests if r['operation']==3]==[240]
    assert requests[-2]['operation']==2 and requests[-2]['fields_hex'][4:8]=='1000' and requests[-2]['value']==0
    assert requests[-1]['reply_kind']==3 and requests[-1]['value']==0
    retained=(EVIDENCE/'replies.bin').read_bytes()
    assert retained==b''.join(r for r in replies if r[5]!=5)
    # The complete cleanup stream was emitted before its first absent-buffer
    # confirmation failed. It does not prove the remaining resources absent.
    clears=b''.join(b'\x17\0\xa0'+struct.pack('<HB',n,2) for n in range(52000,52901))
    clear_start=tx.find(clears);assert clear_start>requests[235]['offset']
    assert tx.find(b'\x17\0\xa0'+struct.pack('<HB',51999,2),clear_start+len(clears))>=0
    generation=(HERE/'generation.vdu').read_bytes()
    assert not any(generation[i:i+48] in tx for i in range(0,len(generation),48))
    failed=tx.rfind(b'RALLY CAPACITY FAILED');assert failed>=0 and tx.find(b'/rally25 *',failed)>failed
    session=json.loads((HERE/'SESSION-capsession01.json').read_text())
    assert session['boost_restored'] and session['original_boost']==session['final_boost']=='1'
    assert not session['owned_emulator_processes_after'] and session['thermal_stop_celsius']==95
    assert not json.loads((HERE/'ORYX-IDLE-AFTER.json').read_text())['emulators']
    stats=json.loads((EVIDENCE/'stats.json').read_text())
    assert not any(stats[k] for k in ('failed','unhandled','unregistered','unmapped'))
    assert stats['uart_tx']==stats['uart_delivered']==len(rx)
    result=json.loads((EVIDENCE/'result.json').read_text())
    assert result['baseline_internal']==61100 and result['baseline_largest_internal']==29684
    assert result['baseline_psram']==3442911 and result['baseline_buffers']==89
    assert not result['valid'] and result['registered']==result['generated']==result['pixel_checks']==0
    output=dict(schema='rally.aff03.capacity-failure-audit.v1',passed=True,
        native_replies=len(replies),all_multiplexed_packets=packets,exact_requests_matched=True,
        expected_bounds_reply_kind=5,harness_wrong_expected_kind=3,
        failure_request=errors[0],cleanup_confirmation_failure=errors[1],
        no_cached_image_generated=True,no_pixel_or_page_probe_reached=True,
        full_case_not_started=True,cleanup_commands_sent_but_absence_unqualified=True,
        aggregate_cleanup_and_minimum_memory_fields_invalid=True,
        baseline_internal=61100,baseline_largest_internal=29684,baseline_psram=3442911,
        installed_table_psram_delta=10760,capacity_fit_not_tested=True,no_fps_measured=True,
        clean_mos_exit=True,native_stop_and_unload_zero=True,backend_errors_zero=True,
        session_seconds=session['elapsed_host_seconds'],maximum_temperature=session['max_temperature_celsius'],
        original_boost_restored=True,lease_released=True,
        evidence_sha256={str(p.relative_to(HERE)):sha(p) for p in EVIDENCE.iterdir() if p.is_file()})
    (HERE/'FAILURE-AUDIT.json').write_text(json.dumps(output,indent=2)+'\n')
    print(json.dumps({k:v for k,v in output.items() if k!='evidence_sha256'},indent=2))


if __name__=='__main__':audit()
