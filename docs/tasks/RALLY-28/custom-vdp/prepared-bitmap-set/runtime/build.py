"""Build the isolated prepared consumer under unchanged native SDK limits."""
from pathlib import Path
import hashlib
import json
import shutil
import subprocess
import sys

HERE=Path(__file__).resolve().parent
CUSTOM=HERE.parents[1]
CONTROL=CUSTOM/'incremental/round-trips'
CAPACITY=HERE.parent/'capacity-02'
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()


def replace(text,old,new):
    assert text.count(old)==1,old[:100]
    return text.replace(old,new)


def build():
    assert json.loads((CAPACITY/'RAW-AUDIT.json').read_text())['cases']['full']['full_set_registered']==901
    package=HERE/'source'
    shutil.copytree(CONTROL/'source',package,dirs_exist_ok=True)
    for n in ('prepared.inc','prepared_io.inc'):shutil.copyfile(HERE/n,package/'helper'/n)
    header=(CAPACITY/'index.bin').read_bytes()[:64]
    (package/'helper/prepared_pins.inc').write_text('static const uint8_t r28_prepared_header[64]={'+','.join(str(v) for v in header)+'};\n')
    p=package/'helper/render_core.inc';s=p.read_text()
    s=replace(s,'    uint8_t *span_pixels;','    uint8_t *span_pixels;\n    const uint8_t *prepared;')
    s=replace(s,'#include "sprite.inc"','#include "prepared.inc"')
    s=replace(s,'r28_sprite_emit(o,r,sign,','r28_sprite_emit(o,a,r,sign,');p.write_text(s)
    p=package/'helper/rally_render.c';s=p.read_text()
    s=replace(s,'#include "sprite_io.inc"','#include "prepared_io.inc"')
    s=replace(s,'if(!rc){ctx->bindings=b;ctx->bound=1;}',
        'if(!rc){rc=r28_prepared_admit(h,b.session);if(rc)fail(c,RALLY_RENDER_REASON_ASSET,rc,rc);}\n    if(!rc){ctx->bindings=b;ctx->bound=1;}')
    s=replace(s,'                else if(i==1){unsigned n=0;c->cars=(uint16_t)actors(&out,&a,&n);c->signs=(uint16_t)n;}',
        '''                else if(i==1){
                    vdplet_view_v1 lookup;rc=acquire(h,&r28_prepared_range,&lookup);
                    if(rc)fail(c,RALLY_RENDER_REASON_ACQUIRE,rc,rc);
                    else if(!view_ok(&lookup,&r28_prepared_range) || r28_prepared_session!=b->session)
                        rc=fail(c,RALLY_RENDER_REASON_ASSET,VDPL_E_FORMAT,0);
                    else {a.prepared=lookup.data;unsigned n=0;c->cars=(uint16_t)actors(&out,&a,&n);c->signs=(uint16_t)n;a.prepared=0;}
                    int32_t rr=release(h,&lookup);if(rr)rc=fail(c,RALLY_RENDER_REASON_RELEASE,rr,rr);
                }''')
    start=s.index('            if(i==1 && !rc){')
    end=s.index('\n        }\n    }\n    int32_t rr=release',start)
    s=s[:start]+s[end:];p.write_text(s)
    p=package/'checked.c';s=p.read_text()
    s=replace(s,'else if(op==3)rc=rally_render_stop_v1(&renderer,&done);',
        'else if(op==3){rc=r28_prepared_publish(h);if(!rc)rc=rally_render_stop_v1(&renderer,&done);}')
    p.write_text(s)
    # Unchanged generated simulation, publication validator and all other
    # resources are retained. Only this source is compiled as the opt-in image.
    run=subprocess.run([sys.executable,str(CUSTOM/'paced-road/control/sdk/tools/build_module.py'),str(p),
        '--name','rally-prepared','--build-id','0x52385032','--output',str(HERE/'target'),
        '--text-limit','32768','--data-limit','4096','--stack-limit','2048','--image-limit','65536'],
        text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
    (HERE/'BUILD.txt').write_text(run.stdout)
    result=dict(schema='rally.aff03.prepared-build.v1',accepted_capacity_audit_sha256=sha(CAPACITY/'RAW-AUDIT.json'),
        recipe_freeze_sha256=sha(CAPACITY/'RECIPE-FREEZE.json'),passed=run.returncode==0,
        declared_limits=dict(text=32768,data=4096,stack=2048,image=65536),
        source_sha256={str(p.relative_to(package)):sha(p) for p in package.rglob('*') if p.is_file()},
        no_emulator_launched=True)
    if not run.returncode:result['module']=json.loads(run.stdout)['module']
    (HERE/'BUILD.json').write_text(json.dumps(result,indent=2)+'\n')
    print(run.stdout)
    if run.returncode:raise SystemExit(run.returncode)


if __name__=='__main__':build()
