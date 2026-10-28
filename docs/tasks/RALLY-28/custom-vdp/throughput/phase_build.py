"""Build bounded existing-ABI native phase diagnostics; never launch an emulator."""
from pathlib import Path
import argparse
import hashlib
import json
import shutil
import struct
import subprocess
import sys

from phase_shared import HERE,ROOT,PACED,CONTROL,WORK,LOG,TAIL,HEADER,ROW,PRIVATE
import phase_tape as demo
sys.path.insert(0,str(PACED))
from freeze_control import records
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()


def native_source(package):
    native=(package/'native.c').read_text()
    assert native.count('#include "helper/rally_render.c"')==1
    native=native.replace('#include "helper/rally_render.c"',
        '#include "phase_clock.inc"\n#include "helper/rally_render.c"')
    native=native.replace('__attribute__((visibility("default")))\nint32_t vdplet_entry(',
        'static int32_t phase_original_entry(',1)
    assert 'phase_original_entry(' in native
    native+='''
/* Private fixture entries use the existing INVOKE wire/ABI; no SDK change. */
__attribute__((visibility("default")))
int32_t vdplet_entry(const vdplet_host_v1 *h,const vdplet_request_v1 *r) {
    if(!h || !r || h->struct_bytes<sizeof(*h) || r->struct_bytes<sizeof(*r) ||
       h->abi_major!=1 || !(h->capabilities&VDPL_CAP_BUFFERS) ||
       !h->buffer_acquire || !h->buffer_release)return VDPL_E_ABI;
    if(r->operation==VDPL_INIT){phase_enabled=0;phase_error=0;}
    if(r->operation==VDPL_RUN && r->entry_id>=PHASE_FIRST_ENTRY) {
        if(r->argument_bytes!=2 || r->reserved)return VDPL_E_ARGUMENT;
        return phase_private(h,r->entry_id);
    }
    if(r->operation!=VDPL_RUN || !phase_enabled)
        return phase_original_entry(h,r);
    if(phase_error)return phase_error;
    if(phase_cpu()!=phase_core)return phase_bad(VDPL_E_UNSUPPORTED);
    unsigned id=r->entry_id;uint32_t begin=phase_clock();
    int32_t rc=phase_original_entry(h,r);
    uint32_t elapsed=phase_clock()-begin;
    if(phase_cpu()!=phase_core)return phase_bad(VDPL_E_UNSUPPORTED);
    if(rc)return rc;
    if(id==3){if(phase_stage || phase_rendered || phase_ticks>=4)
        return phase_bad(VDPL_E_ARGUMENT);++phase_ticks;phase_values[1]+=elapsed;}
    else if(id==15){if(phase_stage || phase_ticks!=4 || phase_rendered)
        return phase_bad(VDPL_E_ARGUMENT);phase_rendered=1;phase_values[2]=elapsed;}
    return rc;
}
'''
    (package/'native.c').write_text(native)
    shutil.copyfile(HERE/'phase_clock.inc',package/'phase_clock.inc')
    helper=package/'helper/rally_render.c';source=helper.read_text()
    old='''if(i==0)c->bands=(uint16_t)road(&out,&a);
                else if(i==1){unsigned n=0;c->cars=(uint16_t)actors(&out,&a,&n);c->signs=(uint16_t)n;}
                else player(&out,&a);'''
    new='''uint32_t phase_start=phase_clock();
                if(i==0)c->bands=(uint16_t)road(&out,&a);
                else if(i==1){unsigned n=0;c->cars=(uint16_t)actors(&out,&a,&n);c->signs=(uint16_t)n;}
                else player(&out,&a);
                phase_values[3+i]+=phase_clock()-phase_start;'''
    assert source.count(old)==1
    helper.write_text(source.replace(old,new))


def quiet_marker(entry,arguments):
    body=struct.pack('<BBHBBHHH',1,2,0,0,0,0,entry,arguments)
    assert len(body)==12
    return b'\x17\0\xd8'+struct.pack('<H',12)+body


def fixture(package,module,out,frames):
    out.mkdir(parents=True,exist_ok=True)
    meta=json.loads((CONTROL/'fixture/expected.json').read_text())
    resources=meta['resources'];iface=json.loads((package/'interface.json').read_text())
    backend=json.loads((package/'backends.json').read_text())
    names={e['name']:e['logical_id'] for e in iface['entries']}
    fields={g['name']:g for g in iface['globals']}
    root=iface['state_buffer'];completion=resources['completion'];outputs=resources['outputs']
    t=demo.Tape()
    for n in ('probe.bin','artwork.vdu','assets.vdu','common.vdu','native.vdu'):
        shutil.copyfile(CONTROL/'fixture'/n,out/n)
    t.external('artwork.vdu',(out/'artwork.vdu').read_bytes(),out)
    t.external('assets.vdu',(out/'assets.vdu').read_bytes(),out)
    image=module.read_bytes();t.send(demo.write(resources['staging'],image))
    t.tx(1,struct.pack('<HIH',resources['staging'],len(image),0),2,None,'LOAD',capture=True)
    t.external('common.vdu',(out/'common.vdu').read_bytes(),out)
    t.external('native.vdu',(out/'native.vdu').read_bytes(),out)
    for wrapper in backend['native_wrappers']:
        t.patch(demo.update(wrapper,backend['native_handle_offset'],b'\0\0'),11)
    t.send(demo.update(root,8,struct.pack('<I',7)))
    t.send(demo.write(completion['buffer'],bytes(completion['offset']+48)))
    for desc in outputs:t.send(demo.write(desc['buffer'],bytes(desc['bytes'])))
    def invoke(name):
        t.send(demo.update(root,28,struct.pack('<H',names[name])))
        t.send(demo.update(completion['buffer'],completion['offset']+44,b'\0\0'))
        t.tx(2,struct.pack('<HHH',0,names[name],backend['native_arguments']),3,0,name,handle=True)
    def private(op,label):
        t.tx(2,struct.pack('<HHH',0,PRIVATE+op,backend['native_arguments']),3,0,label,handle=True)
    invoke('InitRace')
    # LOAD copies the executable image; its upload buffer is no longer consumed.
    t.send(demo.write(LOG,bytes(HEADER+frames*ROW)))
    private(0,'phase reset')
    tail=bytearray();patches=[]
    def marker(op):
        patches.append(len(tail)+11)
        tail.extend(quiet_marker(PRIVATE+op,backend['native_arguments']))
    paint=bytes([26,31,0,0])+b'RALLY / GOLEM NATIVE DEMO\r\nFuji - centerline / no damage\r\n'
    paint+=bytes([18,0,16,25,4])+struct.pack('<hh',0,24)+bytes([25,101])+struct.pack('<hh',319,239)
    paint+=bytes([24])+struct.pack('<4h',0,223,319,24)+bytes([25,4])+struct.pack('<hh',0,24)
    # All marker calls are resident/silent: no UART/reply gaps inside draw spans.
    marker(1);tail.extend(paint);tail.extend(b'\x17\0\xca');marker(2)
    tail.extend(demo.call(outputs[0]['buffer']));tail.extend(b'\x17\0\xca');marker(3)
    tail.extend(demo.call(outputs[1]['buffer']));tail.extend(b'\x17\0\xca');marker(4)
    tail.extend(demo.call(outputs[2]['buffer']));tail.extend(b'\x17\0\xca');marker(5)
    marker(6);tail.extend(b'\x17\0\xc3\x17\0\xca');marker(7)
    tail.extend(b'\x17\0\xa0\xff\xff\7')
    t.send(demo.write(TAIL,tail))
    for offset in patches:t.patch(demo.update(TAIL,offset,b'\0\0'),11)
    t.tx(4,struct.pack('<H',17),4,None,'stack before');t.mark();t.repeat(frames)
    t.send(demo.call(backend['native_wrappers'][names['Tick120']])*4)
    invoke('Render30')
    t.read(completion['buffer'],completion['offset']+44,1,'completion ready',4)
    t.read(completion['buffer'],completion['offset']+16,0,'completion request = frame',16)
    t.read(completion['buffer'],completion['offset']+20,0,'completion tick = frame*4',8)
    t.read(root,20,0,'fresh root generation = frame*5+1',32|4)
    t.send(demo.call(TAIL))
    # Acknowledgement after the resident tail proves the controller swap/drain
    # and successful record commit precede the foreground timestamp.
    t.read(LOG,10,0,'phase row committed = frame',16|4)
    t.mark();t.endrepeat()
    private(8,'phase sequence complete')
    t.tx(4,struct.pack('<H',17),4,None,'stack after');t.mark()
    t.read(root,20,1+5*frames,'final generation');t.read(root,22,0,'final generation high')
    t.read(root,fields['worldTick']['offset'],frames*4,'final world tick')
    t.read(root,fields['renderRequest']['offset'],frames,'final render request')
    for key,data in [(root,(package/'state.bin').read_bytes())]+[(a['buffer'],(package/a['initial_data']).read_bytes()) for a in iface['arrays'] if a['access']==3]:
        for offset in range(0,len(data),2):t.read(key,offset,None,f'final:{key}:{offset}')
    for offset in range(0,HEADER+frames*ROW,2):t.read(LOG,offset,None,f'phase:{offset}')
    invoke('StopRace');t.tx(3,b'\0\0',3,0,'UNLOAD',handle=True)
    t.send(demo.command(TAIL,2)+demo.command(LOG,2));t.data+=b'\0'
    assert t.marks==frames+2 and t.marks*3<=3000 and len(t.data)<=0x30000
    logged=sum(c['repeats']*10 for c in t.checks if not c['flags']&4)
    assert logged<=50000,logged
    (out/'script.bin').write_bytes(t.data)
    (out/'run.txt').write_bytes(b'load probe.bin\r\nrun .\r\n')
    result=dict(schema=1,frames=frames,physics_ticks=frames*4,paced=False,review_fast=True,
        checks=t.checks,reply_bytes=logged,tick_samples=t.marks,mos_tick_hz=120,
        prt_instrumented=True,prt_cycles_per_tick=18432,package=str(package),
        module_sha256=sha(module),resources=resources,phase_log_buffer=LOG,phase_tail_buffer=TAIL,
        phase_header_bytes=HEADER,phase_row_bytes=ROW,
        timing_scope='Separate short diagnostic; MOS/PRT frame brackets include native calls, checks, drawing, flushes and completed-swap fence. Raw CCOUNT spans are VDP-local, interrupt-inclusive, uncalibrated.',
        phase_tail_hex=tail.hex(),phase_handle_patch_offsets=patches,
        files={p.name:sha(p) for p in out.iterdir() if p.name!='expected.json'})
    (out/'expected.json').write_text(json.dumps(result,indent=2)+'\n')
    return result


def build(frames=128):
    assert frames in (64,128)
    pins=json.loads((PACED/'CONTROL.json').read_text())
    for name,h in pins['immutable_files'].items():assert sha(PACED/name)==h,name
    report={}
    for name in ('control','float-quad-layered'):
        package=WORK/name/'package';shutil.copytree(CONTROL/'package',package,dirs_exist_ok=True)
        if name!='control':
            # Exactly the already-qualified quad section; other helpers unchanged.
            p=package/'helper/render_core.inc';core=p.read_text();a=core.index('static void section(');b=core.index('static int ahead(',a)
            core=core[:a]+'#define R28_INTEGER 0\n#define R28_QUAD 1\n#define R28_STRIPS 0\n'+(PACED/'road_candidate.inc').read_text()+'\n'+core[b:]
            p.write_text(core)
        native_source(package)
        target=WORK/name/'target'
        command=[sys.executable,str(CONTROL/'sdk/tools/build_module.py'),str(package/'native.c'),
            '--name','phase-render','--build-id','0x52323850','--output',str(target),
            '--text-limit','32768','--data-limit','4096','--stack-limit','2048','--image-limit','65536']
        subprocess.run(command,check=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True)
        module=json.loads((target/'phase-render.json').read_text())
        metadata=fixture(package,target/'phase-render.vdpl',WORK/name/'fixture',frames)
        metadata['phase_candidate']=name
        (WORK/name/'fixture/expected.json').write_text(json.dumps(metadata,indent=2)+'\n')
        report[name]=dict(module=module['module'],fixture=str(WORK/name/'fixture'),
            fixture_files={p.name:sha(p) for p in (WORK/name/'fixture').iterdir()},
            frames=frames,marks=metadata['tick_samples'],reply_bytes=metadata['reply_bytes'],
            driver_unchanged=sha(WORK/name/'fixture/probe.bin')==pins['runtime_files']['sdcard/rally25/probe.bin'])
        assert report[name]['driver_unchanged']
        print(name,'phase module/fixture built',frames,'frames',metadata['reply_bytes'],'retained bytes')
    (HERE/'phase_BUILD.json').write_text(json.dumps(report,indent=2)+'\n')


if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--frames',type=int,choices=(64,128),default=128);a=p.parse_args();build(a.frames)
