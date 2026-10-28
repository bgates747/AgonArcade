"""Build the Rally-owned mutable-road bitmap through the frozen native ABI.

No emulator, remote machine or upstream SDK mutation. Output: .work/span-candidate.
"""
from pathlib import Path
import argparse
import hashlib
import json
import shutil
import struct
import subprocess
import sys

HERE = Path(__file__).resolve().parent
PACED = HERE.parent/'paced-road'
CONTROL = PACED/'control'
WORK = HERE/'.work/span-candidate'
BUFFER = 50700
WIDTH, HEIGHT, TOP = 320, 120, 104
BYTES = WIDTH*HEIGHT
sys.path.insert(0, str(PACED))
from freeze_control import records
from build_candidates import patch_tape

def sha(path): return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def command(op): return b'\x17\0\xa0'+struct.pack('<H',BUFFER)+bytes([op])
def setup_bytes():
    # One allocation/block; the bitmap references this storage until clear below.
    return command(2)+command(0)+struct.pack('<H',BYTES)+bytes(BYTES)+b'\x17\x1b\x20'+struct.pack('<H',BUFFER)+b'\x17\x1b\x21'+struct.pack('<HHB',WIDTH,HEIGHT,1)
def cleanup_bytes(): return command(2)  # Stock clear removes bitmap users first.

def collision_check():
    interface=json.loads((CONTROL/'package/interface.json').read_text())
    backends=json.loads((CONTROL/'package/backends.json').read_text())
    bindings=json.loads((CONTROL/'package/native-bindings.json').read_text())
    ranges=list(interface['external_reservations'])
    ids={interface['state_buffer'],*backends['native_owned']}
    ids.update(a['buffer'] for a in interface['arrays'])
    ids.update(x['buffer'] for x in [bindings['bindings']['asset'],*bindings['bindings']['outputs'],bindings['completion']])
    resources=bindings['bindings']['resources']
    for base,count in [('player_bitmap_base',5),('traffic_bitmap_base',30),('sign_bitmap_base',8)]:
        ids.update(64000+resources[base]+i for i in range(count))
    for base,count in [('traffic_matrix_base',6),('player_mirror_matrix',1),('sign_matrix',1)]:
        ids.update(resources[base]+i for i in range(count))
    assert BUFFER not in ids and not any(x['first']<=BUFFER<=x['last'] for x in ranges)
    return dict(buffer=BUFFER,known_ids=sorted(ids),external_reservations=ranges,collision_free=True,
                ownership='Rally-only fixture setup/teardown; not an adopted Golem resource contract')

def replace_once(text, old, new):
    assert text.count(old)==1,(old,text.count(old))
    return text.replace(old,new)

def augment(package):
    core=(CONTROL/'package/helper/render_core.inc').read_text()
    core=replace_once(core,'const uint8_t *coeff;','const uint8_t *coeff;\n    uint8_t *span_pixels;')
    begin=core.index('static void section('); end=core.index('static int ahead(',begin)
    core=core[:begin]+(HERE/'span.inc').read_text()+'\n'+core[end:]
    core=replace_once(core,'rect(o, 0, 104, 319, 223, 2);',
        'memset(a->span_pixels, r28_span_colour(2), R28_SPAN_WIDTH);\n    r28_span_bitmap(o);')
    core=replace_once(core,'section(o, ct, cb, y, yy, marked);',
        'if (!r28_span_section(a->span_pixels, ct, cb, y, yy, marked)) { o->error = 1; break; }')
    (package/'helper/render_core.inc').write_text(core)
    helper=(CONTROL/'package/helper/rally_render.c').read_text()
    begin=helper.index('static int32_t preflight('); end=helper.index('static int state_ok(',begin)
    preflight=helper[begin:end]
    preflight=replace_once(preflight,'uintptr_t starts[3];unsigned lengths[3];','uintptr_t starts[4];unsigned lengths[4];')
    preflight=replace_once(preflight,'for(unsigned i=0;i<3;++i){','for(unsigned i=0;i<4;++i){\n        const RallyRenderRangeV1 *range=i<3?&b->output[i]:&r28_span_range;')
    preflight=preflight.replace('&b->output[i]','range')
    # The declaration itself needs the original output operand, not itself.
    preflight=preflight.replace('const RallyRenderRangeV1 *range=i<3?range:', 'const RallyRenderRangeV1 *range=i<3?&b->output[i]:')
    helper=helper[:begin]+preflight+helper[end:]
    helper=replace_once(helper,'if(i==0)c->bands=(uint16_t)road(&out,&a);',
        '''if(i==0){
                    vdplet_view_v1 pixels;int32_t pr=acquire(h,&r28_span_range,&pixels);
                    if(pr)rc=fail(c,RALLY_RENDER_REASON_ACQUIRE,pr,pr);
                    else if(!view_ok(&pixels,&r28_span_range))rc=fail(c,RALLY_RENDER_REASON_CAPACITY,VDPL_E_BOUNDS,0);
                    else{a.span_pixels=pixels.data;c->bands=(uint16_t)road(&out,&a);}
                    int32_t rr=release(h,&pixels);if(rr)rc=fail(c,RALLY_RENDER_REASON_RELEASE,rr,rr);
                }''')
    # A pixel acquire failure must never publish a successful output length.
    helper=replace_once(helper,'else c->output_bytes[i]=out.n;', 'else if(!rc)c->output_bytes[i]=out.n;')
    helper=replace_once(helper,'if(out.error)rc=fail(c,RALLY_RENDER_REASON_CAPACITY,VDPL_E_BOUNDS,0);',
        'if(out.error && c->reason!=RALLY_RENDER_REASON_RELEASE)rc=fail(c,RALLY_RENDER_REASON_CAPACITY,VDPL_E_BOUNDS,0);')
    (package/'helper/rally_render.c').write_text(helper)
    assert sha(package/'native.c')==sha(CONTROL/'package/native.c')
    assert sha(package/'helper/rally_render.h')==sha(CONTROL/'package/helper/rally_render.h')

def patch_fixture(image, out):
    out.mkdir(parents=True,exist_ok=True)
    for name in ('probe.bin','artwork.vdu','assets.vdu','common.vdu'):
        shutil.copyfile(CONTROL/'fixture'/name,out/name)
    native=(CONTROL/'fixture/native.vdu').read_bytes()+setup_bytes()
    (out/'native.vdu').write_bytes(native)
    tape=bytearray(patch_tape(image))
    parsed=records(tape);changed=0
    for r in parsed:
        if r['opcode']==6 and r['filename']=='native.vdu':
            assert r['payload_bytes']==(CONTROL/'fixture/native.vdu').stat().st_size
            tape[r['offset']+1:r['offset']+4]=len(native).to_bytes(3,'little');changed+=1
    assert changed==1
    # Keep every timed record identical. Cleanup follows successful UNLOAD and
    # all final checks, outside the benchmark interval and before END.
    assert tape[-1]==0
    clean=cleanup_bytes();tape[-1:]=b'\1'+struct.pack('<H',len(clean))+clean+b'\0'
    old=(CONTROL/'fixture/script.bin').read_bytes();before=records(old);after=records(tape)
    timed=lambda data,rs:[data[r['offset']:rs[i+1]['offset']] for i,r in enumerate(rs[:-1]) if r['loop']]
    assert timed(old,before)==timed(tape,after)
    (out/'script.bin').write_bytes(tape)
    meta=json.loads((CONTROL/'fixture/expected.json').read_text())
    meta.update(candidate='native-span-rgba2222',module_sha256=hashlib.sha256(image).hexdigest(),package=str(WORK/'package'),
        extra_app_buffer=dict(buffer=BUFFER,bytes=BYTES,width=WIDTH,height=HEIGHT,y=TOP,format='RGBA2222'),
        comparison_scope='Mutable native span bitmap; frozen float endpoints, legacy bands, physics, actors/player, pacer and swap')
    meta['files']={n:sha(out/n) for n in ('probe.bin','script.bin','artwork.vdu','assets.vdu','common.vdu','native.vdu')}
    (out/'expected.json').write_text(json.dumps(meta,indent=2)+'\n')
    (out/'run.txt').write_bytes(b'load probe.bin\r\nrun .\r\n')
    return dict(files={p.name:sha(p) for p in sorted(out.iterdir()) if p.is_file()},
        timed_tape_records_byte_identical=True,unchanged_driver=True,
        setup_added_bytes=len(setup_bytes()),cleanup_bytes=len(clean),per_frame_uart_pixels=0,
        modifications=['setup module/image length','native.vdu extra buffer/bitmap setup and external length','post-UNLOAD buffer clear','expected metadata'])

def build():
    control=json.loads((PACED/'CONTROL.json').read_text())
    for name,digest in control['immutable_files'].items(): assert sha(PACED/name)==digest,name
    collision=collision_check()
    package=WORK/'package';package.parent.mkdir(parents=True,exist_ok=True)
    shutil.copytree(CONTROL/'package',package,dirs_exist_ok=True)
    augment(package)
    result=subprocess.run([sys.executable,str(CONTROL/'sdk/tools/build_module.py'),str(package/'native.c'),
        '--name','rally-render','--build-id','0x52385331','--output',str(WORK/'target'),
        '--text-limit','32768','--data-limit','4096','--stack-limit','2048','--image-limit','65536'],
        check=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True)
    build=json.loads(result.stdout);module=build['module']
    fixture=patch_fixture((WORK/'target/rally-render.vdpl').read_bytes(),WORK/'fixture')
    report=dict(schema=1,module=module,compiler=build['compiler'],abi_header_sha256=build['abi_header_sha256'],
        resource=collision,fixture=fixture,package=str(package),
        source_files={str(p.relative_to(HERE)):sha(p) for p in (HERE/'span.inc',HERE/'span_build.py')},
        helper_files={str(p.relative_to(package)):sha(p) for p in sorted((package/'helper').iterdir()) if p.is_file()},
        generated_native_c_byte_identical=True,public_helper_abi_byte_identical=True,
        firmware_changed=False,sdk_changed=False,emulator_run=False)
    (HERE/'span-BUILD.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(dict(module=module,fixture=fixture),indent=2))
    return report

if __name__=='__main__': build()
