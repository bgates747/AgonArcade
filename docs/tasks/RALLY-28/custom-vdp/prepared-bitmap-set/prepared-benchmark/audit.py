"""Offline full raw checks and token-only paired wire comparison; no launch."""
from pathlib import Path
import argparse
import csv
import hashlib
import importlib.util
import json
import struct

HERE=Path(__file__).resolve().parent
CONTROL=HERE.parents[1]/'incremental/round-trips'
LIMIT='Bundled retention +2px size approximation +stock-versus-additive sampling; not isolated cache benefit or identical actor images'
sha=lambda b:hashlib.sha256(b).hexdigest()


def module(name,path):
    spec=importlib.util.spec_from_file_location(name,path)
    result=importlib.util.module_from_spec(spec);spec.loader.exec_module(result)
    return result


def audit(campaign):
    old=module('compact_independent_raw',CONTROL/'raw_audit.py');old.HERE=HERE
    prepared=module('prepared_independent_raw',HERE/'raw_prepared.py')
    registry=json.loads((HERE/'FIXTURES.json').read_text())
    profiles=json.loads((HERE/('PROFILES-'+campaign+'.json')).read_text())
    rows={};streams={}
    for case,profile in profiles.items():
        e=HERE/'evidence'/campaign/case
        if case=='compact':
            row,timed,parts,runtime=old.completed_run(campaign,case,registry[case],profile)
            streams[case]=timed;rows[case]=row
            continue
        detail=prepared.audit(e)
        tx,packets,generic=old.backend(e)
        r=json.loads((e/'result.json').read_text())
        private=json.loads((e/'prepared.json').read_text())
        meta=json.loads((HERE/'fixtures/prepared/expected.json').read_text())
        assert meta['frames']==r['frames']==900 and r['physics_ticks']==3600
        assert all(r[n] for n in ['valid','timer_restored','unloaded','post_swap_fenced','clean_text_exit'])
        assert (r['request'],r['generation'],r['warm_frames'])==(902,4503,2)
        assert r['race_view'] and not r['damage_enabled']
        receipt=json.loads((e/'run.json').read_text())
        assert receipt['video_driver']==receipt['audio_driver']=='dummy'
        assert old.identities(receipt['runtime_identities'])==profile['input_sha256']
        for name,digest in registry[case]['files'].items():
            assert sha((HERE/registry[case]['directory']/name).read_bytes())==digest
            assert profile['input_sha256']['sdcard/rally25/'+name]==digest
        handle=struct.unpack('<4sBBHH',packets[0])[-1]
        prefix=old.request(4,private['timed_reply_begin'],struct.pack('<H',17))
        start=tx.find(prefix);assert start>=0 and tx.find(prefix,start+1)<0
        start+=len(prefix);cursor=start;normalized=bytearray();parts=[]
        for frame in range(1,901):
            requests=[(2,struct.pack('<HHH',handle,15,9)),(5,struct.pack('<HI',1,20))]
            patches=[]
            for index,(operation,fields) in enumerate(requests):
                token=private['timed_reply_begin']+2*(frame-1)+index+1
                wire=old.request(operation,token,fields)
                pos=tx.find(wire,cursor);assert pos>=0 and tx.find(wire,pos+1)<0
                patches.append((pos,old.request(operation,18+2*(frame-1)+index+1,fields)))
                cursor=pos+len(wire)
            part=bytearray(tx[start:cursor])
            for pos,wire in patches:part[pos-start:pos-start+len(wire)]=wire
            assert part.count(b'\x17\0\xc3')==1
            assert part.count(b'\x17\0\xa0\x0d\0\1')==4
            normalized.extend(part);parts.append(bytes(part));start=cursor
        assert len(normalized)==r['timed_wire_bytes']==291568
        clocks=[]
        for name,key,hz in [('ticks.bin','elapsed_mos_ticks',120),('prt.bin','prt_ticks',1000)]:
            data=(e/name).read_bytes();assert len(data)==3604
            values=struct.unpack('<901I',data)
            deltas=[(b-a)&0xffffff for a,b in zip(values,values[1:])]
            total=(values[-1]-values[0])&0xffffff
            assert total==sum(deltas)==r[key] and total>0
            clocks.append((total,900*hz/total))
        stages=list(csv.DictReader((e/'stages.csv').open()))
        assert len(stages)==1 and int(stages[0]['wire_bytes'])==291568
        assert int(stages[0]['loop_prt_ms'])==r['prt_ticks']
        player=list(csv.DictReader((e/'player.csv').open()))
        reference=json.loads((HERE/'EXPECTED-FINAL-900.json').read_text())
        root=bytes.fromhex(reference['1']);assert len(player)==1
        expected_player=dict(station=struct.unpack_from('<I',root,198)[0],
            phase=struct.unpack_from('<H',root,304)[0],rules_ticks=3600,remaining=6600,
            score=756,rank=6,laps=0,lateral=0,steering=0)
        assert all(int(player[0][k])==v for k,v in expected_player.items())
        predicted=json.loads((HERE/'PREDICTIONS.json').read_text())
        assert {k:r[k] for k in predicted['presentation']}==predicted['presentation']
        after_unload=tx.find(b'\x16\x08\x17\0\xc0\0\x17\1\1\x1a\x0c',cursor)
        done=tx.find(b'RALLY-28 FULL RACE DONE: logs saved.',after_unload)
        assert after_unload>=cursor and done>after_unload and tx.find(b'/rally25 *',done)>done
        assert b'VDPL UNLOAD status=0' in (e/'esp32-uart0.txt').read_bytes()
        streams[case]=bytes(normalized)
        rows[case]=dict(passed=True,frames=900,native_replies=len(packets),
            nominal_mos_units=clocks[0][0],nominal_mos_fps=clocks[0][1],
            nominal_prt_ticks=clocks[1][0],nominal_prt_fps=clocks[1][1],
            normalized_timed_uart_bytes=len(normalized),normalized_timed_uart_sha256=sha(normalized),
            independent_raw=detail,backend_zero_errors=True,mode8_MOS_prompt=True)
    assert set(streams)=={'compact','prepared'}
    assert streams['compact']==streams['prepared'],'Timed bytes differ beyond permitted native tokens'
    report=dict(passed=True,comparison_limit=LIMIT,campaign=campaign,runs=rows,
        actual_timed_bytes=291568,native_tokens_only_normalized=1800,
        timed_wire_equal=True,normalized_sha256=sha(streams['compact']))
    (HERE/('RAW-AUDIT-'+campaign+'.json')).write_text(json.dumps(report,indent=2)+'\n')
    return report


if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('campaign');args=p.parse_args()
    print(json.dumps(audit(args.campaign),indent=2))
