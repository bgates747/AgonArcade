"""Small actor-only native diagnostic, independent of the full phase wrapper."""
import argparse
import json
from pathlib import Path
import shutil
import struct
import subprocess
import sys
import statistics

from phase_test import HERE,THROUGHPUT,CONTROL,sha,save,once,fixture_build


def decode(data,frames=128):
    assert frames==128 and len(data)==16+frames*12
    magic,schema,row,capacity,count,core=struct.unpack_from('<4s4HI',data)
    assert (magic,schema,row,capacity,count)==(b'P28A',1,12,frames,frames)
    rows=[]
    for i in range(frames):
        frame,prepare,draw=struct.unpack_from('<3I',data,16+i*12)
        assert frame==i+1 and 0<prepare<0x80000000 and 0<draw<0x80000000
        rows.append(dict(frame=frame,actors_build_cycles=prepare,
            actors_dispatch_draw_and_flush=draw,actors_preparation_and_execution=prepare+draw))
    summaries={name:dict(mean=statistics.mean(r[name] for r in rows),
        median=statistics.median(r[name] for r in rows),min=min(r[name] for r in rows),
        max=max(r[name] for r in rows)) for name in rows[0] if name!='frame'}
    return dict(phase_lite=True,frames=frames,cpu_prid=core,rows=rows,summaries=summaries,
        raw_unit='Uncalibrated per-core CCOUNT delta; actor-only diagnostic',
        limitations=['Preparation includes actor list construction and separate native sampling.',
            'Draw includes resident native-marker dispatch, actor execution and stock CA flush.',
            'Stage/core/count/progress checks are enforced by the module, but no counter Hz is assumed.',
            'This diagnostic is separate from uninstrumented900-frame throughput.'])


def tail_check(meta,tape):
    from phase_test import tape_encoder,records,quiet_marker
    tail=bytes.fromhex(meta['phase_tail_hex']);patches=meta['phase_handle_patch_offsets']
    assert len(patches)==2
    a,b=(offset-11 for offset in patches)
    assert tail[a:a+17]==quiet_marker(60000,9) and tail[b:b+17]==quiet_marker(60001,9)
    flush=b'\x17\0\xca'
    assert tail[:a].startswith(b'\x1a\x1f\0\0RALLY / GOLEM NATIVE DEMO')
    assert tail[:a].endswith(tape_encoder.call(50301)+flush)
    assert tail[a+17:b]==tape_encoder.call(50302)+flush
    assert tail[b+17:]==tape_encoder.call(50303)+b'\x17\0\xc3'+flush+tape_encoder.command(65535,7)
    parsed=records(tape)
    sites=[i for i,r in enumerate(parsed) if r['loop'] and r['opcode']==1 and
        tape[r['payload_offset']:r['payload_offset']+r['payload_bytes']]==tape_encoder.call(50306)]
    assert len(sites)==1
    ack,stamp=parsed[sites[0]+1:sites[0]+3]
    assert ack['opcode']==2 and ack['flags']==20 and stamp['opcode']==5
    return dict(actor_only_two_resident_markers=True,no_uart_replies_inside_tail=True,
        road_and_prior_drawing_drained_before_actor_begin=True,
        actor_call_and_CA_flush_exact_between_markers=True,
        player_and_completed_swap_follow_actor_end=True,
        committed_row_acknowledged_before_foreground_clock=True)


def verify(directory,standard_result,expected_final):
    directory=Path(directory)
    if isinstance(standard_result,(str,Path)):
        standard_result=json.loads(Path(standard_result).read_text())
    if 'result' in standard_result:standard_result=standard_result['result']
    if isinstance(expected_final,(str,Path)):
        expected_final=json.loads(Path(expected_final).read_text())
    if 'final_buffers' in expected_final:expected_final=expected_final['final_buffers']
    meta=json.loads((directory/'expected.json').read_text())
    assert meta['phase_lite'] and standard_result['frames']==128
    assert standard_result['physics_ticks']==512
    assert standard_result['final_buffers']==expected_final
    words={int(r['label'].split(':')[1]):r['value'] for r in standard_result['observations']
           if r['label'].startswith('phase:')}
    assert sorted(words)==list(range(0,1552,2))
    result=decode(b''.join(struct.pack('<H',words[offset]) for offset in sorted(words)))
    result.update(candidate=meta['phase_candidate'],full_final_state_matches_host=True,
        elapsed_mos_units=standard_result['elapsed_mos_ticks'],
        nominal_mos_seconds=standard_result['elapsed_seconds'],
        nominal_prt_seconds=standard_result['prt']['nominal_seconds_at_18432000_hz'],
        separate_from_headline_throughput=True)
    save(directory/'phase-verified.json',result)
    return result


def instrument(package):
    path=package/'native.c';native=path.read_text()
    native=once(native,'#include "helper/rally_render.c"',
                '#define R28_PHASE_LITE 1\n#include "phase_lite.inc"\n#include "helper/rally_render.c"')
    native=once(native,'if(r->operation==VDPL_INIT)return identity==0x474c3332u?0:VDPL_E_INIT;',
                'if(r->operation==VDPL_INIT){memset(&lite,0,sizeof(lite));return identity==0x474c3332u?0:VDPL_E_INIT;}')
    native=once(native,'if(r->operation!=VDPL_RUN||r->entry_id>=17)return VDPL_E_UNSUPPORTED;',
        '''if(r->operation==VDPL_RUN && r->entry_id>=60000){
if(r->argument_bytes!=2 || r->reserved)return VDPL_E_ARGUMENT;
return lite_marker(h,r->entry_id-60000);}
if(r->operation!=VDPL_RUN||r->entry_id>=17)return VDPL_E_UNSUPPORTED;''')
    path.write_text(native)
    shutil.copyfile(HERE/'phase_lite.inc',package/'phase_lite.inc')
    path=package/'helper/rally_render.c';helper=path.read_text()
    helper=once(helper,'Out out={v.data,0,v.bytes,0};',
        '''Out out={v.data,0,v.bytes,0};
                uint32_t lite_started=i==1?lite_clock():0;''')
    helper=once(helper,'if(out.error && c->reason!=RALLY_RENDER_REASON_RELEASE)',
        '''if(i==1){
                    if(lite.stage)lite.error=VDPL_E_ARGUMENT;
                    if(!lite.count)lite.core=lite_cpu();
                    else if(lite_cpu()!=lite.core)lite.error=VDPL_E_UNSUPPORTED;
                    lite.prepare=lite_clock()-lite_started;lite.stage=1;
                }
                if(out.error && c->reason!=RALLY_RENDER_REASON_RELEASE)''')
    if 'r28_sample_actors(h,&a,c->cars,c->signs,c);' in helper:
        helper=once(helper,'rc=r28_sample_actors(h,&a,c->cars,c->signs,c);',
                    '''uint32_t lite_sample_begin=lite_clock();
                rc=r28_sample_actors(h,&a,c->cars,c->signs,c);
                lite.prepare+=lite_clock()-lite_sample_begin;''')
    path.write_text(helper)


def build(case,package,fixture):
    work=HERE/'.work'/('phase-'+case)
    assert not work.exists(),'Preserve previous diagnostics'
    work.mkdir(parents=True)
    package,fixture=Path(package).resolve(),Path(fixture).resolve()
    copied=work/'package';shutil.copytree(package,copied)
    instrument(copied)
    command=[sys.executable,str(CONTROL/'sdk/tools/build_module.py'),str(copied/'native.c'),
        '--name','phase-render','--build-id','0x52324131','--output',str(work/'target'),
        '--text-limit','65536','--data-limit','4096','--stack-limit','2048','--image-limit','65536']
    result=subprocess.run(command,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True)
    (work/'build-output.txt').write_text(result.stdout)
    if result.returncode:raise RuntimeError(result.stdout)
    module=json.loads((work/'target/phase-render.json').read_text())
    report=dict(case=case,phase_lite=True,frames=128,module=module,
        source_package=str(package),source_fixture=str(fixture),package=str(copied),
        firmware_changed=False,sdk_changed=False,headline_changed=False,
        source_files={p.name:sha(p) for p in (HERE/'phase_lite.py',HERE/'phase_lite.inc')})
    meta=fixture_build(case,copied,fixture,work/'target/phase-render.vdpl',work/'fixture',128,True)
    report.update(fixture=str(work/'fixture'),phase_retained_reply_bytes=meta['reply_bytes'],
        fixture_files={p.name:sha(p) for p in (work/'fixture').iterdir()},
        early_module_load=meta['early_module_load'])
    save(work/'BUILD.json',report)
    print(json.dumps(dict(case=case,module=module['module']),indent=2))
    return report


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action',choices=('build',))
    parser.add_argument('--case',required=True)
    parser.add_argument('--package',type=Path,required=True)
    parser.add_argument('--fixture',type=Path,required=True)
    args=parser.parse_args()
    build(args.case,args.package,args.fixture)
