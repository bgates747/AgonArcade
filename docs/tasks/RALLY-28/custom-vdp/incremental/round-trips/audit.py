"""Independent raw frame/reply/state audit and fresh paired FPS calculation."""
from pathlib import Path
import csv,hashlib,importlib.util,json,struct
HERE=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('roundtrip_raw',HERE/'raw_audit.py')
raw=importlib.util.module_from_spec(s);s.loader.exec_module(raw)

def canonical(tx,frames,module_bytes,reference):
    packets,_=raw.native_packets((tx.parent/'vdp-to-mos.bin').read_bytes())
    handle=struct.unpack('<4sBBHH',packets[0])[-1]
    wire=tx.read_bytes();schedule=raw.specs(frames,module_bytes,handle,reference)
    loc=raw.raw_requests(wire,schedule)
    before=next(r for r in loc if r['label']=='initial stack INFO17')
    start=before['stop'];out=bytearray();reads=runs=fences=0
    for row in (r for r in loc if r['phase']=='main'):
        out+=wire[start:row['start']]
        if row['label'] in ('published ready','published request','published physics tick','generated state'):
            reads+=1
        else:
            b=bytearray(row['wire']);b[7:9]=b'\0\0';out+=b
            runs+=row['operation']==2
            fences+=row['label']=='post-swap generation fence'
        start=row['stop']
    assert runs==fences==frames
    assert reads==(0 if raw.COMPACT else 4*frames)
    # Count all multiplexed return traffic between the initial INFO response
    # and the final timed fence response, including unsolicited MOS packets.
    rx=(tx.parent/'vdp-to-mos.bin').read_bytes();at=0;begin=end=None
    last_token=next(r['token'] for r in reversed(loc) if r['phase']=='main')
    while at<len(rx):
        stop=at+2+rx[at+1];payload=rx[at+2:stop]
        if payload.startswith(b'VDPL'):
            token=struct.unpack_from('<H',payload,6)[0]
            if token==18:begin=stop
            if token==last_token:end=stop
        at=stop
    assert begin is not None and end is not None and begin<end
    return bytes(out),dict(intermediate_reads=reads,run_replies=runs,final_fence_replies=fences,
        complete_multiplexed_return_bytes=end-begin,
        return_window='After initial INFO17 reply through final timed swap-fence reply, inclusive')

def main():
    guard=raw.session('rlyrtsession01');rows=[];normalized=[];timed={};runtimes=[];smokes=[]
    for campaign in ('rlyrtsmoke01','rlyrtab01','rlyrtba01'):
        smoke=campaign=='rlyrtsmoke01'
        registry=json.loads((HERE/('SMOKE-FIXTURES.json' if smoke else 'FIXTURES.json')).read_text())
        profiles=json.loads((HERE/f'PROFILES-{campaign}.json').read_text())
        receipts=json.loads((HERE/f'CAMPAIGN-{campaign}.json').read_text())
        for case,profile in profiles.items():
            assert receipts[case]['passed']
            row,wire,frames,runtime=raw.completed_run(campaign,case,registry[case],profile)
            directory=HERE/row['evidence_directory'];meta=json.loads((HERE/registry[case]['directory']/'expected.json').read_text())
            reference=json.loads((HERE/f"EXPECTED-FINAL-{row['frames']}.json").read_text())
            normal,counts=canonical(directory/'mos-to-vdp.bin',row['frames'],meta['module_bytes'],reference)
            stage=list(csv.DictReader((directory/'stages.csv').read_text().splitlines()))[0]
            row.update(transaction_counts=counts,reply_wait_nominal_prt_ms=int(stage['reply_wait_prt_ms']),
                submission_nominal_prt_ms=int(stage['submission_prt_ms']),normalized_timed_sha256=hashlib.sha256(normal).hexdigest(),
                timed_native_reply_bytes=12*(counts['run_replies']+counts['final_fence_replies']+counts['intermediate_reads']))
            runtimes.append(runtime)
            if smoke:smokes.append(row)
            else:
                rows.append(row);normalized.append(normal)
                timed.setdefault(case,[]).append(wire)
    assert len(rows)==4 and len(smokes)==2
    assert len(set(normalized))==1,'Nonquery command bytes/order differ'
    assert all(x==runtimes[0] for x in runtimes)
    for name,streams in timed.items():assert len(streams)==2 and streams[0]==streams[1],name
    assert len(timed['diagnostic'][0])-len(timed['compact'][0])==68*900
    pooled={}
    for name in ('diagnostic','compact'):
        part=[r for r in rows if r['case']==name];frames=sum(r['frames'] for r in part)
        mos=sum(r['nominal_mos_units'] for r in part);prt=sum(r['nominal_prt_ticks'] for r in part)
        pooled[name]=dict(frames=frames,nominal_mos_seconds=mos/120,nominal_mos_fps=frames*120/mos,
            nominal_prt_seconds=prt/1000,nominal_prt_fps=frames*1000/prt,
            timed_outgoing_bytes_per_run=len(timed[name][0]),timed_incoming_native_bytes_per_run=part[0]['timed_native_reply_bytes'],
            multiplexed_return_bytes_per_run=[r['transaction_counts']['complete_multiplexed_return_bytes'] for r in part],
            timed_native_replies_per_run=900*(6 if name=='diagnostic' else 2),
            mean_reply_wait_nominal_prt_ms=sum(r['reply_wait_nominal_prt_ms'] for r in part)/len(part))
    gain={clock:100*(pooled['compact'][clock]/pooled['diagnostic'][clock]-1) for clock in ('nominal_mos_fps','nominal_prt_fps')}
    result=dict(passed=True,pooled=pooled,gain_percent=gain,rows=rows,smokes=smokes,session=guard,
        exact_final_world_and_all_output_commands=True,normalized_nondiagnostic_timed_streams_identical=True,
        raw_outgoing_saving_per_frame=68,raw_incoming_native_saving_per_frame=48,
        same_module_and_guest_both_cases=True,runtime=runtimes[0],raw_file_sha256=raw.SEEN,
        independent_auditor_sha256=hashlib.sha256((HERE/'raw_audit.py').read_bytes()).hexdigest(),
        timing_limit='Separate nominal emulator MOS/PRT clocks; aggregate completed race frames, not physical scanout/hardware speed or independent physics pacing.')
    (HERE/'RAW-AUDIT.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({'passed':True,'pooled':pooled,'gain_percent':gain},indent=2))

if __name__=='__main__':main()
