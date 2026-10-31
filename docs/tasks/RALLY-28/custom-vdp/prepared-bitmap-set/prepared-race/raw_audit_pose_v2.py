"""Frozen independent functional request schedule; no producer/verifier imports."""
from pathlib import Path
import csv
import hashlib
import json
import struct

HERE=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()


class Oracle:
    def __init__(self,evidence):
        self.e=Path(evidence);self.tx=(self.e/'mos-to-vdp.bin').read_bytes()
        raw=(self.e/'vdp-to-mos.bin').read_bytes();at=0;self.replies=[];self.packets=0;self.at=0;self.cursor=0
        while at<len(raw):
            assert at+2<=len(raw);channel,n=raw[at:at+2];assert channel>=128
            data=raw[at+2:at+2+n];assert len(data)==n
            if data.startswith(b'VDPL'):assert channel==129 and n==10;self.replies.append(data)
            at+=2+n;self.packets+=1
        assert (self.e/'replies.bin').read_bytes()==b''.join(self.replies)
        self.rx_bytes=len(raw);self.memory=[];self.pixels=[]
    def add(self,op,fields,kind=4,value=None):
        token=self.at+1;body=struct.pack('<BBHBB',1,op,token,1,0)+fields
        request=b'\x17\0\xd8'+struct.pack('<H',len(body))+body
        pos=self.tx.find(request,self.cursor);assert pos>=0,(token,op,fields.hex())
        assert self.tx.find(request,pos+1)<0,('ambiguous',token)
        data=self.replies[self.at]
        magic,version,actual_kind,actual_token,actual_value=struct.unpack('<4sBBHH',data)
        assert (magic,version,actual_kind,actual_token)==(b'VDPL',1,kind,token)
        assert value is None or actual_value==value,(token,actual_value,value)
        self.cursor=pos+len(request);self.at+=1;self.last_request=pos
        return actual_value
    def word(self,id,offset,value=None,kind=4):return self.add(5,struct.pack('<HI',id,offset),kind,value)
    def info(self,n,value=None):return self.add(4,struct.pack('<H',n),4,value)
    def invoke(self,handle,entry):return self.add(2,struct.pack('<HHH',handle,entry,9),3,0)
    def missing(self,id):return self.word(id,0,2,5)
    def length(self,id,n,last=None):self.word(id,n-2,last);self.word(id,n-1,3,5)
    def snapshot(self,values):
        for id in ('1','2','3','4','5','6'):
            data=bytes.fromhex(values[id])
            for off in range(0,len(data),2):self.word(int(id),off,struct.unpack_from('<H',data,off)[0])
    def mem(self,label):
        low=self.info(13);high=self.info(14);largest=self.info(15);largest|=self.info(16)<<16
        for retry in range(4):
            hi=self.word(51997,0);first=self.last_request
            lo=self.word(51997,2);hi2=self.word(51997,4);count=self.word(51997,6)
            prefix=b''.join(b'\x17\0\xa0'+struct.pack('<HBBHH',51997,48,128,offset,var)
                for offset,var in ((0,0x211),(2,0x210),(4,0x211),(6,0x212)))
            assert self.tx[first-len(prefix):first]==prefix
            if hi==hi2:break
        else:raise AssertionError('Unstable PSRAM sampler did not complete')
        self.memory.append((label,low|high<<16,largest,lo|hi<<16,count))
    def pixel(self,x,y,value,bitmap=None):
        self.word(51997,8,value)
        prefix=b'\x17\0\x84'+struct.pack('<HH',x,y)+b'\x17\0\xa0'+struct.pack('<HBBHH',51997,48,128,8,0x514)
        start=self.last_request-len(prefix);assert self.tx[start:self.last_request]==prefix
        if bitmap is not None:
            plot=b'\x17\0\x96\0\xff\xff'+b'\x17\x1b\x20'+struct.pack('<H',bitmap)+b'\x17\x1b\3\x0a\0\x0a\0'
            assert self.tx[start-len(plot):start]==plot
        self.pixels.append((x,y,value,bitmap))
    def probe(self,e):
        points=[e['probe']]+(e['detailed_probes'][1:] if e['detailed'] else [])
        for x,y,value in points:self.pixel(10+x,10+y,value,e['id'])


def audit(directory):
    e=Path(directory);o=Oracle(e)
    result=json.loads((e/'result.json').read_text());setup=json.loads((e/'setup.json').read_text());private=json.loads((e/'prepared.json').read_text())
    meta=json.loads((HERE/'fixtures/prepared/expected.json').read_text())
    host=json.loads((HERE/'HOST-FIXTURE.json').read_text());recipe=json.loads((HERE.parent/'capacity-02/recipe.json').read_text())
    initial=json.loads((HERE/'INITIAL-UPLOAD-STATE.json').read_text())
    final=json.loads((HERE/'EXPECTED-FINAL-60.json').read_text())
    table=(HERE/'fixtures/prepared/index.bin').read_bytes()
    handle=o.add(1,struct.pack('<HIH',50305,35216,0),2);assert handle
    o.info(17,setup['loaded_stack'])
    lo=o.info(13);hi=o.info(14);assert lo|hi<<16==setup['loaded_internal']
    lo=o.info(15);hi=o.info(16);assert lo|hi<<16==setup['loaded_largest_internal']
    o.snapshot(initial);o.mem('baseline')
    o.length(51999,10628,struct.unpack_from('<H',table,10626)[0])
    for off in range(0,10628,2):o.word(51999,off,struct.unpack_from('<H',table,off)[0])
    o.mem('index')
    small=next(r for r in recipe['entries'] if r['id']==recipe['small_probe_id'])
    o.length(small['id'],small['bytes']);o.word(1,20,0);o.pixel(1,1,63)
    o.probe(small);o.word(1,20,0);o.probe(small)
    o.word(1,20,0);o.word(1,20,0);o.missing(small['id']);o.mem('small_probe')
    for image in recipe['entries']:
        o.word(1,20,0);o.length(image['id'],image['bytes']);o.probe(image);o.mem('image')
    o.snapshot(initial);o.word(1,20,0);o.word(1,20,0);o.mem('installed');o.info(17,setup['installed_stack'])
    assert o.at==private['setup_reply_end']==setup['install_reply_end']
    o.invoke(handle,13)
    o.word(1,198,3246800&65535)
    o.word(1,200,3246800>>16)
    o.word(1,304,6800)
    for request in (1,2):
        o.invoke(handle,15);o.word(50304,44,1);o.word(50304,16,request);o.word(50304,20,0)
        o.word(1,20,request+1);o.word(1,20,request+1)
    o.mem('race_ready');o.info(17,result['stack_before'])
    assert o.at==private['timed_reply_begin']
    for frame in range(1,61):o.invoke(handle,15);o.word(1,20,5*frame+3)
    assert o.at==private['timed_reply_end']
    o.info(17,result['stack_after']);o.mem('race_end');o.snapshot(final)
    o.invoke(handle,16);o.add(3,struct.pack('<H',handle),3,0)
    for i,value in enumerate(host['expected_counters']):o.word(51996,4*i,value&65535);o.word(51996,4*i+2,value>>16)
    generation=host['expected_stop_generation']
    o.word(1,20,generation);o.mem('retained');o.word(1,20,generation)
    for id in range(52000,52901):o.missing(id)
    o.missing(51999);o.missing(51998);o.mem('cleanup');o.word(1,20,generation)
    o.word(1,20,generation);o.missing(51996);o.missing(51997);o.info(17,private['cleanup_stack'])
    assert o.at==len(o.replies)==result['retained_replies']
    memory=list(csv.DictReader((e/'setup-memory.csv').open()));assert len(memory)==len(o.memory)==909
    for row,(label,internal,largest,psram,count) in zip(memory,o.memory):
        assert row['stage']==label
        assert tuple(int(row[k]) for k in ('internal','largest_internal','free_psram','buffers'))==(internal,largest,psram,count)
    pixels=list(csv.DictReader((e/'setup-pixels.csv').open()));assert len(pixels)==len(o.pixels)-1==963
    for row,(x,y,value,id) in zip(pixels,o.pixels[1:]):
        assert tuple(int(row[k]) for k in ('x','y','expected','actual','id'))==(x-10,y-10,value,value,id)
    assert (e/'setup-state-before.bin').read_bytes()==(e/'setup-state-after.bin').read_bytes()==b''.join(bytes.fromhex(initial[id]) for id in ('1','2','3','4','5','6'))
    assert (e/'state.bin').read_bytes()==b''.join(bytes.fromhex(final[id]) for id in ('1','2','3','4','5','6'))
    generations=(HERE/'fixtures/prepared/generation.vdu').read_bytes()
    for i,image in enumerate(recipe['entries']):assert o.tx.count(generations[48*i:48*i+48])==1+(image['id']==small['id'])
    # Exact immutable runtime/input pins are independently checked again.
    profiles=json.loads((HERE/'PROFILES-prace01.json').read_text())['prepared']
    run=json.loads((e/'run.json').read_text());assert run['process_exit']==0 and not run['error']
    actual={name:digest for digest,name in (line.split('  ',1) for line in run['runtime_identities'].splitlines())}
    assert actual==profiles['input_sha256']
    stats=json.loads((e/'stats.json').read_text());assert not any(stats[k] for k in ('failed','unhandled','unregistered','unmapped'))
    assert stats['uart_tx']==stats['uart_delivered']==o.rx_bytes
    done=o.tx.rfind(b'FULL RACE DONE');assert done>=0 and o.tx.find(b'/rally25 *',done)>done
    report=dict(passed=True,native_replies=o.at,multiplexed_packets=o.packets,
        all_requests_tokens_status_values_matched=True,all_memory_samples=len(memory),all_pixel_witnesses=len(pixels),
        setup_before_init=True,final_independent_state=True,all_private_cleanup_queries_matched=True,
        expected_counters=host['expected_counters'],task_watermarks_bytes=[setup['loaded_stack'],setup['installed_stack'],result['stack_before'],result['stack_after'],private['cleanup_stack']],
        functional_only=True,no_fps_or_whole_stack_estimate_claim=True,
        evidence_sha256={str(p.relative_to(e)):sha(p) for p in e.iterdir() if p.is_file()})
    (HERE/'RAW-FUNCTIONAL-AUDIT.json').write_text(json.dumps(report,indent=2)+'\n')
    return report


if __name__=='__main__':
    import argparse
    parser=argparse.ArgumentParser();parser.add_argument('directory');args=parser.parse_args()
    print(json.dumps(audit(args.directory),indent=2))
