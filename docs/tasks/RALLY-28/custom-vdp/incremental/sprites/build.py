"""Isolated sprite-sampling candidate; frozen span control and SDK, no emulator."""
import hashlib
import argparse
import json
from pathlib import Path
import shutil
import struct
import subprocess
import sys

HERE=Path(__file__).resolve().parent
INC=HERE.parent
THROUGHPUT=INC.parent/'throughput'
PACED=INC.parent/'paced-road'
CONTROL=PACED/'control'
WORK=HERE/'.work/candidate'
sys.path.insert(0,str(PACED))
from freeze_control import records

sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()


def once(text,old,new):
    assert text.count(old)==1,(old,text.count(old))
    return text.replace(old,new,1)


def setup():
    data=bytearray()
    for slot in range(8):
        key=50710+slot;w,h=(99,75) if slot<6 else (62,62)
        cmd=b'\x17\0\xa0'+struct.pack('<H',key)
        data+=cmd+b'\2'+cmd+b'\0'+struct.pack('<H',w*h)+bytes(w*h)
        data+=b'\x17\x1b\x20'+struct.pack('<H',key)+b'\x17\x1b\x21'+struct.pack('<HHB',w,h,1)
    return bytes(data)


def cleanup():
    return b''.join(b'\x17\0\xa0'+struct.pack('<H',50710+i)+b'\2' for i in range(8))


def build():
    WORK.mkdir(parents=True,exist_ok=False)
    source=THROUGHPUT/'.work/span-candidate/package'
    pins=json.loads((THROUGHPUT/'span-BUILD.json').read_text())
    assert all(sha(source/n)==h for n,h in pins['helper_files'].items())
    assert sha(source/'native.c')==sha(CONTROL/'package/native.c')
    package=WORK/'package';shutil.copytree(source,package)
    core=(package/'helper/render_core.inc').read_text()
    core=once(core,'typedef RallyRenderActorScratchV1 Car;',
              'typedef RallyRenderActorScratchV1 Car;\n#include "sprite.inc"')
    start=core.index('        if (sign)\n            viewport(o, 104);')
    end=core.index('\n    }',start)
    assert 'matrix(o, r->matrix' in core[start:end]
    core=core[:start]+'''        r28_sprite_emit(o,r,sign,flags&2?88:24,
                        sign?6+(unsigned)(r-signs):(unsigned)(r-cars));'''+core[end:]
    (package/'helper/render_core.inc').write_text(core)
    shutil.copyfile(HERE/'sprite.inc',package/'helper/sprite.inc')
    shutil.copyfile(HERE/'sprite_io.inc',package/'helper/sprite_io.inc')
    helper=(package/'helper/rally_render.c').read_text()
    helper=once(helper,'static int asset_ok(', '#include "sprite_io.inc"\nstatic int asset_ok(')
    helper=once(helper,'uintptr_t starts[4];unsigned lengths[4];',
                'uintptr_t starts[12];unsigned lengths[12];')
    helper=once(helper,'for(unsigned i=0;i<4;++i){\n        const RallyRenderRangeV1 *range=i<3?&b->output[i]:&r28_span_range;',
                '''for(unsigned i=0;i<12;++i){
        RallyRenderRangeV1 sr={(uint16_t)(R28_SPRITE_FIRST+i-4),VDPL_WRITE,0,i<4?1:r28_sprite_bytes(i-4)};
        const RallyRenderRangeV1 *range=i<3?&b->output[i]:i==3?&r28_span_range:&sr;''')
    # This splice is in prepare(), after output release, while asset stays live.
    tail='''            int32_t rr=release(h,&v);if(rr)rc=fail(c,RALLY_RENDER_REASON_RELEASE,rr,rr);
        }
    }
    int32_t rr=release(h,&asset);'''
    assert helper.count(tail)==1
    helper=helper.replace(tail,'''            int32_t rr=release(h,&v);if(rr)rc=fail(c,RALLY_RENDER_REASON_RELEASE,rr,rr);
            if(i==1 && !rc){
#ifdef R28_PHASE
                uint32_t phase_sampler_begin=phase_clock();
#endif
                rc=r28_sample_actors(h,&a,c->cars,c->signs,c);
#ifdef R28_PHASE
                phase_values[4]+=phase_clock()-phase_sampler_begin;
#endif
            }
        }
    }
    int32_t rr=release(h,&asset);''',1)
    (package/'helper/rally_render.c').write_text(helper)
    # Enlarged declarations below remain within the already accepted SDK/runtime
    # capacity policy. No policy or firmware source is modified.
    command=[sys.executable,str(CONTROL/'sdk/tools/build_module.py'),str(package/'native.c'),
             '--name','rally-render','--build-id','0x52385332','--output',str(WORK/'target'),
             '--text-limit','32768','--data-limit','4096','--stack-limit','2048','--image-limit','65536']
    result=subprocess.run(command,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True)
    if result.returncode:
        (HERE/'BUILD-FAILED.txt').write_text(result.stdout)
        raise RuntimeError(result.stdout)
    target=json.loads(result.stdout)
    module=(WORK/'target/rally-render.vdpl').read_bytes()
    registry=json.loads((INC/'FIXTURES.json').read_text())
    original=registry['clear-split'];base=INC/original['directory']
    assert all(sha(base/n)==h for n,h in original['files'].items())
    fixture=WORK/'fixture';shutil.copytree(base,fixture)
    # Patch the actual embedded module with the existing exact tape relocation.
    # The frozen builder patches only module upload and associated length fields.
    sys.path.insert(0,str(PACED))
    from build_candidates import patch_tape
    from fixtures import completion_fence,unpace
    # Start from our control tape, replace its module upload payload directly.
    tape=(base/'script.bin').read_bytes();parsed=records(tape);out=bytearray();module_changes=0
    for i,r in enumerate(parsed):
        stop=parsed[i+1]['offset'] if i+1<len(parsed) else len(tape)
        chunk=tape[r['offset']:stop]
        if not r['loop'] and r['opcode']==1 and r.get('payload_bytes',0)>30000:
            body=tape[r['payload_offset']:r['payload_offset']+r['payload_bytes']]
            marker=b'\x17\0\xa0'+struct.pack('<H',50200)
            # Staging ID is supplied in expected resources rather than guessed.
            meta=json.loads((base/'expected.json').read_text());staging=meta['resources']['staging']
            marker=b'\x17\0\xa0'+struct.pack('<H',staging)
            if body.startswith(marker+b'\2'+marker+b'\0'):
                wire=marker+b'\2'+marker+b'\0'+struct.pack('<H',len(module))+module
                chunk=b'\1'+struct.pack('<H',len(wire))+wire;module_changes+=1
        if r['opcode']==2 and not r['loop'] and r.get('operation')==1:
            pass
        out+=chunk
    assert module_changes==1
    # LOAD carries the image length. Locate the command structurally and update it.
    tape=bytearray(out);parsed=records(tape);load_changes=0
    for r in parsed:
        if r['opcode']==2:
            off=r['payload_offset'];wire=tape[off:off+r['payload_bytes']]
            if wire[:3]==b'\x17\0\xd8' and wire[6]==1:
                tape[off+13:off+17]=struct.pack('<I',len(module));load_changes+=1
    assert load_changes==1
    native=(base/'native.vdu').read_bytes()+setup()
    (fixture/'native.vdu').write_bytes(native)
    parsed=records(tape)
    for r in parsed:
        if r['opcode']==6 and r['filename']=='native.vdu':
            tape[r['offset']+1:r['offset']+4]=len(native).to_bytes(3,'little')
    assert tape[-1]==0
    clean=cleanup();tape[-1:]=b'\1'+struct.pack('<H',len(clean))+clean+b'\0'
    (fixture/'script.bin').write_bytes(tape)
    meta=json.loads((base/'expected.json').read_text())
    meta.update(candidate='INC-001-02 additive sprites; split-clear Native road unchanged',
                module_sha256=hashlib.sha256(module).hexdigest(),package=str(package))
    meta['files'].update({n:sha(fixture/n) for n in ('script.bin','native.vdu')})
    (fixture/'expected.json').write_text(json.dumps(meta,indent=2)+'\n')
    # Timed tape is unchanged: all scaling happens within Render30, resident.
    timed=lambda t:[chunk for r,chunk in __import__('clear_test').raw_records(t) if r['loop']]
    assert timed(tape)==timed((base/'script.bin').read_bytes())
    report=dict(module=target['module'],compiler=target['compiler'],source_package=str(source),
                package=str(package),fixture=str(fixture),firmware_changed=False,sdk_changed=False,
                per_frame_uart_unchanged=True,extra_vdp_pixel_bytes=6*99*75+2*62*62,
                max_service_leases=4,files={p.name:sha(p) for p in fixture.iterdir() if p.is_file()},
                helper_files={str(p.relative_to(package)):sha(p) for p in (package/'helper').iterdir() if p.is_file()})
    (HERE/('BUILD-'+WORK.name+'.json')).write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report['module'],indent=2))
    return report


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--tag',default='candidate')
    args=parser.parse_args()
    assert args.tag.replace('-','').isalnum()
    WORK=HERE/'.work'/args.tag
    sys.path.insert(0,str(INC));sys.path.insert(0,str(THROUGHPUT));build()
