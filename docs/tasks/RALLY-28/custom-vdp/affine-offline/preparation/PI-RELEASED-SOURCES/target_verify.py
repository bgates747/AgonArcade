"""Independent target-probe UART/guest-log audit; never launches an emulator.

Reconstruct every application command byte, including resident operation/batch
bodies, rather than searching for opcodes within opaque bitmap uploads. Check
all response packets in sequence, retained files, identities and clean MOS exit.
Direction captures do not supply cross-direction timestamps: the captured
request schedule, response order and pinned guest waits establish the fence.
"""
from pathlib import Path
import argparse
import csv
import hashlib
import json
import struct

HERE=Path(__file__).resolve().parent
APP=Path('sdcard/test/arcade/rally28/affine')
METHODS=('ordinary-sized','cached-affine','rebuilt-affine','transform40-plot','matrix-only','empty')


def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def save(path,value):
    data=(json.dumps(value,indent=2)+'\n').encode()
    path.parent.mkdir(parents=True,exist_ok=True)
    if path.exists():assert path.read_bytes()==data,('Preserve prior audit',str(path))
    else:path.write_bytes(data)
def word(value):return struct.pack('<H',value&65535)
def command(key,operation):return b'\x17\0\xa0'+word(key)+bytes([operation])
def affine(key):return b'\x17\0\x96\1'+word(key)
def select(key):return b'\x17\x1b\x20'+word(key)
def plot(x,y):return b'\x17\x1b\3'+word(x)+word(y)
def viewport(clip):
    left,top,right,bottom=clip
    return b'\x18'+b''.join(word(n) for n in (left,bottom,right,top))+b'\x19\4'+word(left)+word(top)
def rect(left,top,right,bottom,colour):
    return b'\x12\0'+bytes([colour])+b'\x19\4'+word(left)+word(top)+b'\x19\x65'+word(right)+word(bottom)
def matrix(index,case):
    key=55000+index
    return command(key,32)+b'\0'+command(key,32)+b'\x0b\xc8'+b''.join(word(n) for n in case['matrix_q8'])
def transform(index,case,destination):return command(destination,40)+b'\5'+word(55000+index)+word(case['actual_bitmap_key'])
def store(key,data):return command(key,2)+command(key,0)+word(len(data))+data

def packets(data):
    result=[];at=0
    while at<len(data):
        assert at+2<=len(data) and data[at]&128,('VDP packet framing',at,data[at:at+10].hex())
        n=data[at+1]
        assert at+2+n<=len(data),('Truncated VDP packet',at,n)
        result.append((data[at]&127,data[at+2:at+2+n]))
        at+=2+n
    return result


def expected_schedule(metadata,artwork):
    """Independent exact foreground command builder from frozen fixture facts."""
    cases=metadata['target_cases'];count=len(cases)
    draws=metadata['draw_repeats'];setup=metadata['setup_repeats'];samples=metadata['samples'];mask=metadata['case_mask']
    poll=metadata['primary_completion'] in ('general-poll','poll')
    full=[0,0,319,239]
    operation={};batches={}
    tail=viewport(full)+rect(319,239,319,239,12)+b'\x17\0\xca\x17\0'+(b'\x80\xd1' if poll else b'\x99\0')
    output=bytearray(b'\x16\x88\x17\0\xc0\0\x17\1\0\x1a\x0c\x17\0\xf8\1\0\1\0'+artwork)
    for index,case in enumerate(cases):
        output+=matrix(index,case)+transform(index,case,56100+index)
        ordinary=affine(65535)+select(56100+index)+plot(*case['natural_command40_plot'])
        cached=affine(55000+index)+select(case['actual_bitmap_key'])+plot(case['x'],case['y'])
        operation[index,0]=ordinary
        operation[index,1]=cached
        operation[index,2]=matrix(index,case)+cached
        operation[index,3]=transform(index,case,56000+index)+affine(65535)+select(56000+index)+plot(*case['natural_command40_plot'])
        operation[index,4]=matrix(index,case)
        for method in range(5):
            output+=store(53000+index*5+method,operation[index,method])
            n=setup if method==4 else draws
            batches[index,method]=viewport(case['clip'])+command(53000+index*5+method,1)*n+tail
            output+=store(54000+index*5+method,batches[index,method])
    output+=store(53099,b'\0')+store(54099,command(53099,1)*draws+tail)
    token=1
    def fence():
        nonlocal token
        token+=1
        if token>=128:token=1
        return b'\x17\0\xca\x17\0\x80'+bytes([token])
    output+=fence()
    expected_rx=[(0,bytes([token]))]
    rows=[]
    intervals=[]
    for sample in range(samples):
        selected=[(count,5)]+[(index,method) for index in range(count) if mask&(1<<index) for method in range(5)]
        for index,method in selected:
            output+=affine(65535)+viewport(full)+rect(0,0,319,239,16)
            if index<count:output+=viewport(cases[index]['clip'])+command(53000+index*5+method,1)
            output+=fence()
            warm_token=token
            expected_rx.append((0,bytes([warm_token])))
            start=len(output)
            timed=command(54000+index*5+method if index<count else 54099,1)
            assert len(timed)==6
            output+=timed
            intervals.append(dict(row=len(rows),offset=start,bytes=6,hex=timed.hex(),case_index=index,method=METHODS[method]))
            expected_rx.append((0,b'\xd1') if poll else (1,b'\0\0\0\0'))
            output+=b'\x17\0\x84\x3f\1\xef\0'+fence()
            expected_rx.append((4,None))
            expected_rx.append((0,bytes([token])))
            rows.append(dict(case_index=index,case=cases[index]['name'] if index<count else 'empty',method=METHODS[method],
                sample=sample,operations=setup if method==4 else draws,callback_hits=0 if poll else 1,
                gp=209 if poll else warm_token,marker_pixel=12,valid=1))
    output+=affine(65535)
    for index,case in enumerate(cases):
        for method in range(5):output+=command(53000+index*5+method,2)+command(54000+index*5+method,2)
        for key in (55000+index,56000+index,56100+index,case['actual_bitmap_key']):output+=command(key,2)
    output+=command(53099,2)+command(54099,2)+b'\x16\x08\x17\0\xc0\0\x17\1\1\x1a\x0c'
    return bytes(output),expected_rx,rows,intervals,operation,batches


def verify(profile,fixture,evidence=None):
    profile=Path(profile).resolve();evidence=Path(evidence).resolve() if evidence else profile/'last-run'
    registry=json.loads((HERE/'TARGET-FIXTURES.json').read_text());selected=registry[fixture]
    source=HERE/selected['directory'];metadata=json.loads((source/'expected.json').read_text())
    build=json.loads((HERE/'TARGET-BUILD.json').read_text());workload=json.loads((HERE/'WORKLOAD.json').read_text())
    assert sha(HERE/'WORKLOAD.json')==build['source_workload_sha256']==metadata['source_workload_sha256']
    for path,value in build['source_files'].items():assert sha(HERE/path)==value,('Changed target source',path)
    for name,value in selected['files'].items():
        assert sha(source/name)==value,('Changed authoritative fixture',name)
        assert sha(profile/APP/name)==value,('Changed deployed fixture',name)
    magic,schema,draws,samples,setup,mask,poll,reserved=struct.unpack('<4sHHHHHBB',(source/'config.bin').read_bytes())
    assert (magic,schema,reserved)==(b'R28A',1,0)
    assert (draws,samples,setup,mask)==tuple(metadata[n] for n in ('draw_repeats','samples','setup_repeats','case_mask'))
    assert bool(poll)==(metadata['primary_completion']=='general-poll')
    assert build['binary_sha256']==metadata['guest_sha256']==sha(source/'probe.bin')
    assert metadata['target_cases']==build['target_cases']
    wassets={a['bitmap_id']:a for a in workload['bitmaps']}
    for item in metadata['source_artwork']:
        assert sha(HERE/item['source_path'])==item['source_sha256']==wassets[item['bitmap_id']]['sha256']
    app=profile/APP
    assert not (app/'failure.txt').exists(),'Guest emitted failure.txt'
    assert (app/'done.txt').read_text().strip()=='PASS'
    summary=json.loads((app/'summary.json').read_text())
    assert summary['schema']==1 and summary['valid'] is True and summary['failure']=='none'
    assert summary['completed_batches']==summary['planned_batches']==metadata['planned_batches']==selected['planned_batches']
    assert summary['mode']==136 and summary['timed_swaps']==0
    assert summary['draw_repeats']==draws and summary['setup_repeats']==setup and summary['samples']==samples and summary['case_mask']==mask
    assert summary['primary_completion']==('poll' if poll else 'key-zero')
    assert not summary['fallback_used'] and summary['callback_restored'] and summary['prt_restored']
    assert summary['mos_hz_nominal']==120 and summary['prt_hz_nominal']==1000
    with (app/'timings.csv').open(newline='') as handle:
        actual=list(csv.DictReader(handle))
    expected_tx,expected_rx,expected_rows,intervals,operations,batches=expected_schedule(metadata,(source/'artwork.vdu').read_bytes())
    assert len(actual)==len(expected_rows)==metadata['planned_batches']
    for index,(got,want) in enumerate(zip(actual,expected_rows,strict=True)):
        assert set(got)=={'case_index','case','method','sample','operations','mos_ticks','prt_ticks','submit_prt_ticks','wait_prt_ticks','callback_hits','gp','marker_pixel','valid'}
        converted={key:value if key in ('case','method') else int(value) for key,value in got.items()}
        for key,value in want.items():assert converted[key]==value,('Guest row mismatch',index,key,converted[key],value)
        assert 0<=converted['mos_ticks']<7200 and 0<=converted['prt_ticks']<0x1000000
        assert (converted['submit_prt_ticks']+converted['wait_prt_ticks'])&0xffffff==converted['prt_ticks'],('PRT split',index)
    runtime=profile/'last-run'
    result=json.loads((runtime/'result.json').read_text())
    assert result['reason']=='guest-files' and result['exit']==0 and result['identities_unchanged'] is True
    assert result['forced_sdl']=={'video':'dummy','audio':'dummy'}
    identity=result['identity']
    runtime_build=json.loads((HERE/'PI-RUNTIME-BUILD.json').read_text())
    assert identity['files']['flexe-agon-emulator.bin']==runtime_build['files']['flexe-agon-emulator']
    assert identity['files']['flexe-vdp.so']==runtime_build['files']['flexe-vdp.so']
    assert identity['files']['esp32-firmware.bin']=='b807beef35823b13a0a056f11b7464cd1b1c6356dce0e4098b78ebe059ded35f'
    assert identity['files']['mos_platform.bin']=='d564243283972690933a4554296ad6202ca4ef54572279533a942960846bebae'
    assert identity['files']['mos_platform.map']=='d69e60bbce61a7b4b3eef318ba395f11c4e1a5b585755755113992dc94edcb86'
    assert isinstance(identity['files'],dict) and identity['files']
    for path,value in identity['files'].items():assert sha(profile/path)==value,('Runtime identity changed',path)
    stats=json.loads((runtime/'stats.json').read_text())
    if 'backend_stats' in result:assert stats==result['backend_stats']
    assert stats['failed'] is False and all(stats[key]==0 for key in ('unhandled','unregistered','unmapped'))
    tx=(runtime/'mos-to-vdp.bin').read_bytes();rx=(runtime/'vdp-to-mos.bin').read_bytes()
    delivered=(runtime/'vdp-to-mos-delivered.bin').read_bytes()
    assert rx==delivered,'VDP receive/delivery differ'
    assert tx.count(expected_tx)==1,'Exact application transmit schedule absent/ambiguous'
    tx_start=tx.index(expected_tx);tx_end=tx_start+len(expected_tx)
    assert b'RALLY AFFINE PASS:' in tx[tx_end:] and b'/test/arcade/rally28/affine *' in tx[tx_end:],'Missing clean MOS return'
    assert stats['uart_rx']==len(tx) and stats['uart_tx']==len(rx) and stats['uart_delivered']==len(delivered)
    wire=packets(rx)
    def mode_info(payload):
        if len(payload)!=8:return False
        width,height,columns,rows,colours,mode=struct.unpack('<HHBBBB',payload)
        return width==320 and height==240 and columns==40 and 1<=rows<=30 and colours==64 and mode==136
    def matches(begin):
        at=begin
        for opcode,payload in expected_rx:
            # Context/viewport operations may report current mode information.
            # Permit this documented packet only, with mode/dimensions checked;
            # completion/key/pixel events remain an exact ordered sequence.
            while at<len(wire) and wire[at][0]==6 and mode_info(wire[at][1]):at+=1
            if at>=len(wire):return None
            got_op,got_payload=wire[at]
            if got_op!=opcode:return None
            if payload is not None and got_payload!=payload:return None
            if payload is None and got_payload!=b'\0\0\xff\x0c':return None
            at+=1
        return at
    starts=[(i,matches(i)) for i in range(len(wire)) if wire[i]==expected_rx[0]]
    starts=[(i,end) for i,end in starts if end is not None]
    assert len(starts)==1,('Exact completion/readback response schedule absent/ambiguous',starts)
    rx_start,rx_end=starts[0]
    app_packets=wire[rx_start:rx_end]
    callback_count=sum(opcode==1 for opcode,payload in app_packets)
    assert summary['keyboard_packets']==callback_count==(0 if poll else len(expected_rows))
    # No extra callback/point/poll responses can hide after the validated stream.
    assert not any(op in (0,1,4) for op,payload in wire[rx_end:]),('Extra measured-class response after completion',wire[rx_end:])
    report=dict(schema=1,passed=True,fixture=fixture,profile=str(profile),mode=136,swaps=0,
        completed_batches=len(actual),source_sha256=sha(HERE/'target_verify.py'),build_sha256=sha(HERE/'TARGET-BUILD.json'),
        fixture_sha256=sha(source/'expected.json'),guest_sha256=metadata['guest_sha256'],
        workload_sha256=metadata['source_workload_sha256'],raw_tx_sha256=hashlib.sha256(tx).hexdigest(),
        raw_rx_sha256=hashlib.sha256(rx).hexdigest(),application_tx_offset=tx_start,application_tx_bytes=len(expected_tx),
        application_packet_start=rx_start,application_packet_count=len(app_packets),checked_completion_packet_count=len(expected_rx),
        auxiliary_modeinfo_packets=[dict(packet_index=rx_start+i,payload=payload.hex()) for i,(opcode,payload) in enumerate(app_packets) if opcode==6],timed_calls=intervals,
        timed_submit_bytes_each=6,all_resident_operations_and_batches_exact=True,
        full_foreground_command_schedule_exact=True,all_csv_rows_match_exact_plan=True,
        exact_primary_pixel_validation_response_order=True,zero_key_callbacks=callback_count,
        marker_indices=sorted({payload[3] for opcode,payload in app_packets if opcode==4}),
        pixel_payloads=sorted({payload.hex() for opcode,payload in app_packets if opcode==4}),
        no_timed_swap_or_pixel_upload=True,input_and_runtime_identities_unchanged=True,
        guest_callback_and_prt_restore_reports=True,clean_mos_return=True,summary=summary,backend_stats=stats,
        output_sha256={name:sha(app/name) for name in ('summary.json','timings.csv','done.txt')},
        limitations=['Direction capture files contain no cross-direction timestamps; exact request/response order is interpreted with pinned guest wait/readback source.',
                    'PRT/callback restoration is the pinned guest vector-comparison report; UART alone does not inspect MOS memory.',
                    'Synchronous hidden-page raster completion; no swap, scanout, host-window or physical ESP32 timing claim.'])
    save(evidence/'verified.json',report)
    print(json.dumps(dict(passed=True,fixture=fixture,batches=len(actual),application_tx_bytes=len(expected_tx),
        packets=len(expected_rx),zero_key_callbacks=callback_count,verified=str(evidence/'verified.json')),indent=2))
    return report


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--profile',type=Path,required=True)
    parser.add_argument('--fixture',choices=('smoke','smoke-poll','full'),required=True)
    parser.add_argument('--evidence',type=Path)
    args=parser.parse_args()
    verify(args.profile,args.fixture,args.evidence)
