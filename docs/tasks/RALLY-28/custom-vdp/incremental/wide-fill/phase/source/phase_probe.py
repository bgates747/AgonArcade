"""Build/verify the separate INC-001-03 fill microprobe; never launches emulators."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import statistics
import struct
import subprocess
import sys
import zlib

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[5]
CUSTOM=HERE.parents[1]
SDK=CUSTOM/'paced-road/control/sdk'
THROUGHPUT=CUSTOM/'throughput'
FROZEN=HERE.parent/'sprites/.work/candidate-clipfix/package'
SOURCE_FIXTURE=HERE.parent/'sprites/motion-comparison/fixtures/additive'
sys.path.insert(0,str(THROUGHPUT))
import phase_tape as tape

HEADER,ROW,REPEATS,SCRATCH,PIXELS=32,56,8,38432,38400
INPUT,BYTE,WIDE,LOG,ARGS,STAGING=50900,50901,50902,50903,50904,50905
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
def save(path,data):Path(path).write_text(json.dumps(data,indent=2)+'\n')

def make_input(binary,metadata):
    records=binary.read_bytes();meta=json.loads(metadata.read_text())
    assert len(records)%8==0 and len(records)//8<=16000
    frames=meta['frames'];assert 1<=len(frames)<=10
    descriptors=bytearray();details=[]
    for entry in frames:
        first,count=entry['first_record'],entry['count']
        assert 0<=first and 0<count and (first+count)*8<=len(records)
        spans=records[first*8:(first+count)*8]
        assert hashlib.sha256(spans).hexdigest()==entry['sha256']
        parsed=list(struct.iter_unpack('<HHHBB',spans));written=0
        for row,left,right,colour,reserved in parsed:
            assert row<PIXELS and row%320==0 and 0<=left<=right<=320 and not reserved
            written+=right-left
        crcs=[]
        for shift in range(4):
            scratch=bytearray([0xa5])*SCRATCH
            for row,left,right,colour,_ in parsed:
                start=8+shift+row;scratch[start+left:start+right]=bytes([colour])*(right-left)
            crcs.append(zlib.crc32(scratch))
        descriptors+=struct.pack('<8I',entry['frame'],first,count,written,*crcs)
        details.append(dict(frame=entry['frame'],first_record=first,count=count,bytes_per_replay=written,
                            expected_scratch_crc32=crcs,input_span_sha256=entry['sha256']))
    header=struct.pack('<8I',0x53383250,1,8,len(frames),len(records)//8,PIXELS,REPEATS,0)
    return header+descriptors+records,details

def decode(raw,meta,target=True):
    magic,schema,row_bytes,capacity,count,core,input_crc,repeats=struct.unpack_from('<8I',raw)
    expected=meta['phase_details'];rows_expected=len(expected)*8
    assert (magic,schema,row_bytes,capacity,count,repeats)==(0x46383250,1,ROW,rows_expected,rows_expected,REPEATS)
    assert len(raw)==HEADER+ROW*count and input_crc==meta['phase_input_crc32']
    rows=[]
    for i in range(count):
        frame,shift,order,spans,written,repeats,byte,wide,empty,crc_byte,crc_wide,mismatches,guards,cpu=struct.unpack_from('<14I',raw,HEADER+i*ROW)
        want=expected[i//8]
        assert (frame,shift,order,spans,written,repeats,cpu)==(want['frame'],(i//2)%4,i%2,want['count'],want['bytes_per_replay'],REPEATS,core)
        assert 0<byte<0x80000000 and 0<wide<0x80000000 and 0<empty<0x80000000
        assert not mismatches and not guards and crc_byte==crc_wide==want['expected_scratch_crc32'][shift]
        rows.append(dict(frame=frame,base_shift=shift,order='wide-byte' if order else 'byte-wide',
                         calls_per_replay=spans,bytes_per_replay=written,repeats=repeats,
                         byte_raw_ccount=byte,wide_raw_ccount=wide,empty_dispatch_raw_ccount=empty,
                         reduction_percent=100*(byte-wide)/byte,byte_crc32=f'{crc_byte:08x}',wide_crc32=f'{crc_wide:08x}',
                         mismatched_bytes=mismatches,guard_failures=guards,cpu_prid=cpu))
    b=sum(r['byte_raw_ccount'] for r in rows);w=sum(r['wide_raw_ccount'] for r in rows)
    return dict(passed=True,target_raw_counter_result=target,sample_windows=count,physics_ticks=0,
                cpu_prid=core,repeats_per_window=REPEATS,rows=rows,
                summaries=dict(byte_total=b,wide_total=w,raw_ccount_reduction_percent=100*(b-w)/b,
                    median_window_reduction_percent=statistics.median(r['reduction_percent'] for r in rows),
                    maximum_window_raw_ccount=max(max(r['byte_raw_ccount'],r['wide_raw_ccount'],r['empty_dispatch_raw_ccount']) for r in rows),
                    empty_dispatch_total=sum(r['empty_dispatch_raw_ccount'] for r in rows)),
                exact_scratch_and_guards=True,expected_host_crc32=True,
                limits=['Raw per-core CCOUNT deltas, never physical cycles or calibrated milliseconds.',
                    'Same noinline indirect fill dispatch and span replay loop are included in both intervals.',
                    'Empty dispatch is disclosed without subtraction; interrupts/cache effects remain.',
                    'Leases, reset, validation, full byte comparison and CRC are outside timed intervals.',
                    'Selected actual calls exclude the separate first grass-row memset.',
                    'This is a separate no-drawing/no-physics microprobe, not the900-frame completion-fenced throughput result.'])

def verify(directory):
    directory=Path(directory);meta=json.loads((directory/'expected.json').read_text())
    sys.path.insert(0,str(THROUGHPUT/'support'))
    from verify_run import verify as standard_verify
    common=standard_verify(directory)
    words={int(r['label'].split(':')[1]):r['value'] for r in common['observations'] if r['label'].startswith('fillphase:')}
    assert sorted(words)==list(range(0,HEADER+ROW*meta['frames'],2))
    result=decode(b''.join(struct.pack('<H',words[i]) for i in sorted(words)),meta)
    assert common['physics_ticks']==0 and common['prt']['previous_vector_restored']
    result.update(validated_reply_records=common['validated_reply_records'],prt_previous_vector_restored=True,
                  bytecode_driver_sha256=meta['files']['probe.bin'],motion_input_sha256=meta['files']['motion.bin'])
    save(directory/'phase_verified.json',result)
    return result

def build(work_name):
    assert work_name.startswith('phase') and Path(work_name).name==work_name
    work=HERE/'.work'/work_name;assert not work.exists(),'Preserve earlier probe builds'
    package=work/'package';package.mkdir(parents=True)
    frozen_fill='''static void r28_span_fill(uint8_t *row, int left, int right, uint8_t colour) {
    if (left < right) memset(row + left, colour, (unsigned)(right - left));
}'''
    frozen_memset='void*memset(void*d,int v,size_t n){uint8_t*a=d;for(size_t i=0;i<n;++i)a[i]=(uint8_t)v;return d;}'
    assert frozen_fill in (FROZEN/'helper/render_core.inc').read_text()
    assert frozen_memset in (FROZEN/'native.c').read_text()
    for name in ('phase_probe.c','phase_host.c'):shutil.copyfile(HERE/name,package/name)
    wide=(HERE/'wide_fill.inc').read_text()
    assert wide.count('static void r28_span_fill(')==1
    (package/'phase_wide.inc').write_text(wide.replace('static void r28_span_fill(',
        'static __attribute__((noinline)) void r28_span_fill(',1))
    command=[sys.executable,str(SDK/'tools/build_module.py'),str(package/'phase_probe.c'),
        '--name','fill-phase','--build-id','0x52324631','--output',str(work/'target'),
        '--text-limit','8192','--data-limit','1024','--stack-limit','512','--image-limit','16384']
    completed=subprocess.run(command,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True)
    (work/'target-build.txt').write_text(completed.stdout)
    if completed.returncode:raise RuntimeError(completed.stdout)
    module=json.loads((work/'target/fill-phase.json').read_text())
    assembly=(work/'target/fill-phase.disassembly.txt').read_text()
    functions={}
    for name in ('memset','phase_byte','phase_wide','phase_replay','phase_empty'):
        match=re.search(r'^[0-9a-f]+ <'+name+r'>:\n(.*?)(?=\n\n|\Z)',assembly,re.M|re.S)
        assert match,('missing isolated function',name)
        functions[name]=match[0]
    assert 's8i' in functions['memset'] and 's32i' not in functions['memset']
    assert 's32i' in functions['phase_wide'] and 's8i' in functions['phase_wide']
    assert not re.search(r'\bcall(?:x)?[04812]*\b',functions['phase_wide'])
    assert 'callx' in functions['phase_replay']
    (work/'target/fill-phase.inspected.txt').write_text('\n\n'.join(functions.values())+'\n')
    binary,details=make_input(HERE/'span-inputs.bin',HERE/'span-inputs.json')
    (work/'phase_input.bin').write_bytes(binary)
    rows=len(details)*8
    meta=dict(schema=1,frames=rows,physics_ticks=0,phase_isolated_fill=True,
        sample_unit='paired fill sample window; generic observed_fps has no gameplay meaning',
        phase_details=details,phase_input_crc32=zlib.crc32(binary),
        phase_input_sha256=hashlib.sha256(binary).hexdigest(),prt_instrumented=True,mos_tick_hz=120,
        timing_scope='Standalone fill sample windows; use raw per-core CCOUNT rows only, no gameplay FPS claim')
    host_results={}
    for case,flags in [('ordinary',[]),('sanitized',['-fsanitize=address,undefined','-fno-omit-frame-pointer'])]:
        exe=work/('phase-host-'+case)
        subprocess.run(['cc','-std=c11','-O2','-fno-builtin','-I'+str(SDK/'include'),*flags,str(package/'phase_host.c'),'-o',str(exe)],check=True)
        environment=os.environ.copy()
        if case=='sanitized':environment['ASAN_OPTIONS']='detect_leaks=0'
        completed=subprocess.run([str(exe),str(work/'phase_input.bin'),str(work/('phase-host-'+case+'.bin'))],env=environment,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True)
        (work/('phase-host-'+case+'.txt')).write_text(completed.stdout)
        if completed.returncode:raise RuntimeError(completed.stdout)
        host_results[case]=decode((work/('phase-host-'+case+'.bin')).read_bytes(),meta,False)
    save(work/'phase_HOST.json',host_results)
    fixture=work/'fixture';fixture.mkdir()
    for name in ('probe.bin','motion.bin'):shutil.copyfile(SOURCE_FIXTURE/name,fixture/name)
    t=tape.Tape()
    t.send(bytes([22,8,12])+b'RALLY-28 isolated fill replay\r\n')
    image=(work/'target/fill-phase.vdpl').read_bytes()
    t.send(tape.write(STAGING,image));t.tx(1,struct.pack('<HIH',STAGING,len(image),0),2,None,'LOAD',capture=True)
    t.external('phase_spans.vdu',tape.write(INPUT,binary),fixture)
    for key,size in ((BYTE,SCRATCH),(WIDE,SCRATCH),(LOG,HEADER+rows*ROW),(ARGS,2)):t.send(tape.write(key,bytes(size)))
    t.tx(4,struct.pack('<H',17),4,None,'stack before')
    t.mark();t.repeat(rows)
    t.tx(2,struct.pack('<HHH',0,1,ARGS),3,0,'isolated fill sample',handle=True)
    t.read(LOG,16,0,'fill row committed = sample',16|4)
    t.mark();t.endrepeat()
    t.tx(4,struct.pack('<H',17),4,None,'stack after');t.mark()
    for offset in range(0,HEADER+rows*ROW,2):t.read(LOG,offset,None,'fillphase:'+str(offset))
    t.tx(3,b'\0\0',3,0,'UNLOAD',handle=True)
    t.send(b''.join(tape.command(key,2) for key in (INPUT,BYTE,WIDE,LOG,ARGS,STAGING)))
    t.send(bytes([22,8,23,0,192,0,23,1,1,26,12,31,0,0]))
    t.data+=b'\0'
    assert len(t.data)<=0x30000 and t.marks==rows+2
    (fixture/'script.bin').write_bytes(t.data);(fixture/'run.txt').write_bytes(b'load probe.bin\r\nrun .\r\n')
    meta.update(checks=t.checks,reply_bytes=sum(c['repeats']*10 for c in t.checks if not c['flags']&4),tick_samples=t.marks,
        files={p.name:sha(p) for p in fixture.iterdir() if p.is_file()})
    assert meta['reply_bytes']<=50000
    save(fixture/'expected.json',meta)
    report=dict(module=module,fixture=str(fixture),fixture_files={p.name:sha(p) for p in fixture.iterdir() if p.is_file()},
        exact_frozen_byte_bodies_verified=True,both_fill_functions_noinline=True,indirect_dispatch_shared=True,
        target_byte_memset_has_only_byte_stores=True,target_wide_has_aligned_word_stores_and_no_helper_calls=True,
        source_files={name:sha(HERE/name) for name in ('phase_probe.c','phase_host.c','phase_probe.py','wide_fill.inc','span-inputs.bin','span-inputs.json')},
        frozen_byte_render_core_sha256=sha(FROZEN/'helper/render_core.inc'),frozen_byte_native_sha256=sha(FROZEN/'native.c'),
        sample_windows=rows,physics_ticks=0,retained_reply_bytes=meta['reply_bytes'],target_stack_usage=(work/'target/fill-phase.su').read_text(),
        firmware_changed=False,sdk_changed=False,host_ordinary_and_sanitized_passed=True,
        host_sanitizers='AddressSanitizer and UndefinedBehaviorSanitizer; LeakSanitizer disabled because ptraced sandbox rejects it',emulator_launched=False)
    save(work/'phase_BUILD.json',report)
    print(json.dumps(dict(fixture=str(fixture),module=module['module'],sample_windows=rows,retained_reply_bytes=meta['reply_bytes']),indent=2))
    return report

if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('action',choices=['build','verify']);parser.add_argument('name')
    args=parser.parse_args()
    if args.action=='build':build(args.name)
    else:
        r=verify(args.name);print(json.dumps({k:v for k,v in r.items() if k not in ('rows',)},indent=2))
