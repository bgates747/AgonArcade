"""Audit full raw setup UART independently of the producer and result verifier."""
from pathlib import Path
import csv
import hashlib
import json
import struct

HERE=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()


def packets(raw):
    at=0;native=[];all_packets=[]
    while at<len(raw):
        assert at+2<=len(raw)
        channel,size=raw[at:at+2];assert channel>=128
        data=raw[at+2:at+2+size];assert len(data)==size
        all_packets.append((channel,data))
        if data.startswith(b'VDPL'):
            assert channel==129 and size==10 and data[4]==1
            native.append(data)
        at+=2+size
    return native,all_packets


def audit_case(case):
    e=HERE/'evidence/capacity02'/case
    tx=(e/'mos-to-vdp.bin').read_bytes();rx=(e/'vdp-to-mos.bin').read_bytes()
    replies,all_packets=packets(rx);candidates={};cursor=0
    while True:
        cursor=tx.find(b'\x17\0\xd8',cursor)
        if cursor<0:break
        if cursor+11<=len(tx):
            length=struct.unpack_from('<H',tx,cursor+3)[0]
            version,op,token,flags,reserved=struct.unpack_from('<BBHBB',tx,cursor+5)
            if version==1 and flags==1 and not reserved and op in (1,2,3,4,5) and length=={1:14,2:12,3:8,4:8,5:12}[op]:
                candidates.setdefault(token,[]).append((cursor,op,tx[cursor+11:cursor+5+length]))
        cursor+=1
    requests=[]
    for token,reply in enumerate(replies,1):
        assert struct.unpack_from('<H',reply,6)[0]==token and len(candidates[token])==1
        offset,op,fields=candidates[token][0]
        if requests:assert offset>requests[-1]['offset']
        requests.append(dict(offset=offset,operation=op,fields=fields,kind=reply[5],value=struct.unpack_from('<H',reply,8)[0]))
    assert (e/'replies.bin').read_bytes()==b''.join(replies)
    result=json.loads((e/'result.json').read_text());assert result['valid']
    recipe=json.loads((HERE/'recipe.json').read_text());images=recipe['entries']
    selected=[next(r for r in images if r['id']==recipe['small_probe_id'])] if case=='small' else images
    assert result['registered']==result['generated']==result['attempted']==len(selected)
    assert result['full_set_fits']==(case=='full') and result['pixel_page']==1
    expected_errors={}
    def negative(id,off,status):
        key=(struct.pack('<HI',id,off),status);expected_errors[key]=expected_errors.get(key,0)+1
    negative(51999,10627,3)
    small=next(r for r in images if r['id']==recipe['small_probe_id'])
    negative(small['id'],small['bytes']-1,3);negative(small['id'],0,2)
    for r in selected:negative(r['id'],r['bytes']-1,3)
    for id in range(52000,52901):negative(id,0,2)
    negative(51999,0,2);negative(51998,0,2)
    actual_errors={}
    for r in requests:
        if r['kind']==5:
            assert r['operation']==5
            key=(r['fields'],r['value']);actual_errors[key]=actual_errors.get(key,0)+1
        else:
            assert r['kind']=={1:2,2:3,3:3,4:4,5:4}[r['operation']]
            if r['kind']==3:assert r['value']==0
    assert expected_errors==actual_errors
    assert [struct.unpack_from('<H',r['fields'],2)[0] for r in requests if r['operation']==2]==[13,15,15,16]
    assert requests[-1]['operation']==3 and requests[-1]['value']==0
    table=(HERE/'index.bin').read_bytes()
    index_reads=[r for r in requests if r['operation']==5 and r['kind']==4 and r['fields'][:2]==struct.pack('<H',51999)]
    assert len(index_reads)==1+len(table)//2
    assert index_reads[0]['fields']==struct.pack('<HI',51999,len(table)-2)
    for off,r in enumerate(index_reads[1:]):
        assert r['fields']==struct.pack('<HI',51999,off*2)
        assert r['value']==struct.unpack_from('<H',table,off*2)[0]
    # Check the exact generation recipes actually sent, including the initial
    # one-image page probe. IDs are private; generation bytes cannot be baseline.
    gen=(HERE/'generation.vdu').read_bytes()
    for i,image in enumerate(images):
        expected=(1 if image in selected else 0)+(1 if image['id']==small['id'] else 0)
        assert tx.count(gen[48*i:48*i+48])==expected,(image['id'],expected)
    pixels=list(csv.DictReader((e/'pixels.csv').open()))
    pixel_replies=[r['value'] for r in requests if r['operation']==5 and r['kind']==4 and r['fields']==struct.pack('<HI',51997,8)]
    assert pixel_replies==[63]+[int(r['actual']) for r in pixels]
    assert len(pixels)==result['pixel_checks']
    assert all(int(r['actual'])==int(r['expected']) for r in pixels)
    assert [int(r['id']) for r in pixels if r['kind']=='registration']==[r['id'] for r in selected]
    allowed={r['id']:{tuple(r['probe']),*(tuple(p) for p in r['detailed_probes'])} for r in images}
    assert all((int(r['x']),int(r['y']),int(r['expected'])) in allowed[int(r['id'])] for r in pixels)
    memory=list(csv.DictReader((e/'memory.csv').open()));samples=[]
    for i,r in enumerate(requests):
        if r['operation']==4 and r['fields']==struct.pack('<H',13):
            group=requests[i:i+8];assert len(group)==8
            for j,info in enumerate((13,14,15,16)):assert group[j]['operation']==4 and group[j]['fields']==struct.pack('<H',info)
            for j,off in enumerate((0,2,4,6)):assert group[j+4]['operation']==5 and group[j+4]['fields']==struct.pack('<HI',51997,off)
            values=[v['value'] for v in group];assert values[4]==values[6]
            samples.append((values[0]|values[1]<<16,values[2]|values[3]<<16,values[5]|values[4]<<16,values[7]))
    assert len(samples)==len(memory)==len(selected)+5
    for row,sample in zip(memory,samples):assert tuple(int(row[k]) for k in ('internal','largest_internal','free_psram','buffers'))==sample
    assert [int(r['id']) for r in memory if r['stage']=='image']==[r['id'] for r in selected]
    assert samples[0]==(61100,29684,3442911,89)
    assert samples[-1][3]==samples[0][3] and result['cleanup_absent']==901 and result['cleaned']
    for col,key in ((0,'internal'),(1,'largest_internal'),(2,'psram')):
        assert min(r[col] for r in samples)==result['minimum_'+key]
    state_specs=[(1,310),(2,12),(3,24),(4,24),(5,24),(6,12)]
    expected_words=[struct.pack('<HI',id,off) for id,n in state_specs for off in range(0,n,2)]
    snapshots=[]
    for i,r in enumerate(requests):
        if r['operation']==5 and r['fields']==expected_words[0] and r['kind']==4:
            group=requests[i:i+203]
            assert [v['fields'] for v in group]==expected_words and all(v['kind']==4 for v in group)
            snapshots.append(b''.join(struct.pack('<H',v['value']) for v in group))
    assert len(snapshots)==2 and snapshots[0]==snapshots[1]
    assert snapshots[0]==(e/'state-before.bin').read_bytes()==(e/'state-after.bin').read_bytes()
    assert struct.unpack_from('<I',snapshots[0],20)[0]==3 and struct.unpack_from('<I',snapshots[0],136)[0]==0
    assert struct.unpack_from('<I',snapshots[0],296)[0]==2
    finished=tx.rfind(b'RALLY CAPACITY DONE');assert finished>=0 and tx.find(b'/rally25 *',finished)>finished
    stats=json.loads((e/'stats.json').read_text())
    assert not any(stats[k] for k in ('failed','unhandled','unregistered','unmapped'))
    assert stats['uart_delivered']==stats['uart_tx']==len(rx)
    profiles=json.loads((HERE/'PROFILES-capacity02.json').read_text())
    run=json.loads((e/'run.json').read_text());assert run['process_exit']==0 and not run['error']
    pins={name:digest for digest,name in (line.split('  ',1) for line in run['runtime_identities'].splitlines())}
    assert pins==profiles[case]['input_sha256']
    for n,h in profiles[case]['input_sha256'].items():
        if n.startswith('sdcard/rally25/'):assert sha(HERE/'fixtures'/case/n.split('/')[-1])==h
    return dict(passed=True,native_replies=len(replies),multiplexed_packets=len(all_packets),
        expected_negative_replies=sum(actual_errors.values()),pixels_checked=len(pixels),
        cached_images_generated=len(selected)+1,full_set_registered=len(selected),
        actual_table_admission_words=len(table)//2,raw_memory_samples=len(samples),
        drawing_page_readback=True,full_state_exact=True,exact_generation_wire=True,
        cleanup_count_and_901_absence_checks_pass=True,clean_mos_exit=True,backend_errors_zero=True,
        nominal_mos_setup_seconds=result['elapsed_mos_ticks']/120,
        separate_prt_setup_seconds=result['elapsed_prt']/1000,
        baseline_internal=samples[0][0],retained_internal=result['retained_internal'],
        largest_internal=result['retained_largest_internal'],baseline_psram=samples[0][2],
        retained_psram=result['retained_psram'],actual_retained_psram_delta=samples[0][2]-result['retained_psram'],
        observed_psram_minimum=min(s[2] for s in samples),cleanup_psram=samples[-1][2],
        cleanup_psram_residual=samples[0][2]-samples[-1][2],cleanup_internal_residual=samples[0][0]-samples[-1][0],
        no_fps_measured=True,evidence_sha256={str(p.relative_to(HERE)):sha(p) for p in e.iterdir() if p.is_file()})


def audit():
    freeze=json.loads((HERE/'READINESS-FREEZE.json').read_text())
    for n,h in freeze['files'].items():assert sha(HERE/n)==h,n
    cases={case:audit_case(case) for case in ('small','full')}
    session=json.loads((HERE/'SESSION-capsession02.json').read_text())
    assert session['error'] is None and session['boost_restored'] and session['original_boost']==session['final_boost']=='1'
    assert session['completed']==['campaign:capacity02'] and not session['owned_emulator_processes_after']
    assert session['thermal_stop_celsius']==95 and session['max_temperature_celsius']==56
    assert session['video_driver']==session['audio_driver']=='dummy'
    assert not json.loads((HERE/'ORYX-IDLE-AFTER.json').read_text())['emulators']
    assert (HERE/'LEASE-RELEASE.json').exists()
    result=dict(schema='rally.aff03.capacity-raw-audit.v1',passed=True,cases=cases,
        maximum_temperature=56,original_boost_restored=True,session_host_seconds=session['elapsed_host_seconds'],
        lease_released_before_analysis=True,exact_frozen_inputs=True,no_physical_capacity_or_fps_claim=True)
    (HERE/'RAW-AUDIT.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:{n:v for n,v in r.items() if n!='evidence_sha256'} for k,r in cases.items()},indent=2))


if __name__=='__main__':audit()
