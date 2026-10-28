"""Independent stock-raster, clipping, ownership and actual generated-world checks.

Ordinary and ASan/UBSan host runs only; no emulator or upstream mutation.
"""
from pathlib import Path
import argparse
import ctypes as C
import hashlib
import importlib.util
import json
import os
import random
import re
import shutil
import struct
import subprocess
import sys
from span_build import HERE,PACED,CONTROL,WORK,BUFFER,WIDTH,HEIGHT,TOP,BYTES,sha

sys.path.insert(0,str(PACED))
from qualify_candidates import NativeRuntime,specification,decode,asset_image,BASE,Traffic,contact
from host import View

CONTROL_WORK=HERE/'.work/span-control'
STOCK_WORK=HERE/'.work/span-stock'
PALETTE=Path('/Agon/mystuff/agon-vdplet/build/firmware/firmware-src/video/agon_palette.h')
GRAPHICS=Path('/Agon/mystuff/agon-vdplet/build/firmware/firmware-src/video/context/graphics.h')
RGB={2:0xc8,8:0xd5,9:0xc3,11:0xcf,15:0xff}

class SpanRuntime(NativeRuntime):
    """Same bounded host service model, actual runtime's four lease slots."""
    def __init__(self,spec,library):
        super().__init__(spec,library)
        self.install(BUFFER,bytes(BYTES))
    def acquire(self,context,id,access,offset,n,out):
        self.acquires+=1
        if id not in self.buffers:return 2
        if access not in (1,2) or access&~self.permissions[id]:return 1
        size=self.sizes[id]
        if offset>size:return 3
        if n==0xffffffff:n=size-offset
        if n>size-offset:return 3
        if len(self.live)>=4:return 13
        p=self.pointer(id)+offset
        if any(p<other+length and other<p+n and ((access|mode)&2) for other,length,mode in self.live.values()):return 7
        self.next+=1;self.grants+=1;self.live[self.next]=(p,n,access);self.peak=max(self.peak,len(self.live))
        out.contents.lease=self.next;out.contents.data=C.cast(p,C.POINTER(C.c_uint8));out.contents.bytes=n;out.contents.access=access
        return 0

def compile_hosts(candidate_only=False):
    package=CONTROL_WORK/'package';package.parent.mkdir(parents=True,exist_ok=True)
    shutil.copytree(CONTROL/'package',package,dirs_exist_ok=True)
    core=(package/'helper/render_core.inc').read_text();start=core.index('static void section(');end=core.index('static int ahead(',start)
    core=core[:start]+'#define R28_INTEGER 0\n#define R28_QUAD 1\n#define R28_STRIPS 0\n'+(PACED/'road_candidate.inc').read_text()+'\n'+core[end:]
    (package/'helper/render_core.inc').write_text(core)
    # Extract exact stock raster to our own workspace, never rerun old producers.
    source=json.loads((PACED/'STOCK-PATH.json').read_text())
    vdp_source=next(Path(n) for n in source['files'] if n.endswith('/displaycontroller.cpp'))
    assert sha(vdp_source)==source['files'][str(vdp_source)]
    raw=vdp_source.read_text();start=raw.index('void IRAM_ATTR BitmappedDisplayController::fillPath(')
    end=raw.index('\n\nvoid ',start+1)
    STOCK_WORK.mkdir(parents=True,exist_ok=True)
    (STOCK_WORK/'fill_path.inc').write_text(raw[start:end])
    scaffold=r'''
#include <algorithm>
#include <array>
#include <cassert>
#include <climits>
#include <cstdint>
#define IRAM_ATTR
struct Point {int16_t X,Y;};
struct Rect {int X1,Y1,X2,Y2;Rect(int a=0,int b=104,int c=319,int d=223):X1(a),Y1(b),X2(c),Y2(d){} Rect merge(const Rect&r)const{return *this;}};
template<class T>T tmin(T a,T b){return std::min(a,b);}template<class T>T tmax(T a,T b){return std::max(a,b);}template<class T>void tswap(T&a,T&b){std::swap(a,b);}
struct RGB888 {uint8_t value;};struct Path{const Point*points;int pointsCount;bool freePoints;};
struct State{Rect absClippingRect;Point origin={0,0};};
struct BitmappedDisplayController{State state;uint8_t*pixels;struct Pool{void free(void*){assert(false);}}m_primDynMemPool;State&paintState(){return state;}void hideSprites(Rect&){}
void fillRow(int y,int x1,int x2,const RGB888&c){assert(y>=104&&y<=223&&x1>=0&&x2<320);for(int x=x1;x<=x2;++x)pixels[(y-104)*320+x]=c.value;}
void fillPath(const Path&,const RGB888&,Rect&);};
#include "fill_path.inc"
extern "C" void span_stock_raster(const int*shapes,int n,uint8_t*pixels){
  BitmappedDisplayController d;d.pixels=pixels;
  for(int i=0;i<38400;++i)pixels[i]=0xc8;
  for(int i=0;i<n;++i){const int*s=shapes+i*8;assert(s[7]==221);Point p[]={{(int16_t)s[3],(int16_t)s[1]},{(int16_t)s[4],(int16_t)s[1]},{(int16_t)s[6],(int16_t)s[2]},{(int16_t)s[5],(int16_t)s[2]}};
    int c=s[0];uint8_t rgba=c==2?0xc8:c==8?0xd5:c==9?0xc3:c==11?0xcf:0xff;Rect update;d.fillPath({p,4,false},RGB888{rgba},update);
  }
}
'''
    (STOCK_WORK/'raster.cpp').write_text(scaffold)
    for mode,flags in [('ordinary',[]),('sanitized',['-fsanitize=address,undefined','-fno-omit-frame-pointer'])]:
        for work,extra in [(CONTROL_WORK,[]),(WORK,['-DR28_SPAN_TEST'])]:
            if candidate_only and work==CONTROL_WORK:
                assert (work/('host-'+mode+'.so')).exists();continue
            subprocess.run(['cc','-shared','-fPIC','-O1','-fno-builtin','-ffp-contract=off',*flags,*extra,
                '-I'+str(CONTROL/'sdk/include'),'-I'+str(work/'package'),str(HERE/'span-host.c'),'-o',str(work/('host-'+mode+'.so'))],check=True)
        if candidate_only:assert (STOCK_WORK/('host-'+mode+'.so')).exists()
        else:subprocess.run(['c++','-std=c++17','-shared','-fPIC','-O1',*flags,str(STOCK_WORK/'raster.cpp'),'-o',str(STOCK_WORK/('host-'+mode+'.so'))],check=True)

def rasterizer(mode):
    lib=C.CDLL(str(STOCK_WORK/('host-'+mode+'.so')))
    lib.span_stock_raster.argtypes=[C.POINTER(C.c_int),C.c_int,C.POINTER(C.c_uint8)]
    def raster(shapes):
        data=(C.c_int*(8*len(shapes)))(*(x for row in shapes for x in row));pixels=(C.c_uint8*BYTES)()
        lib.span_stock_raster(data,len(shapes),pixels);return bytes(pixels)
    return raster

def palette_check(lib):
    text=PALETTE.read_text();part=text.split('defaultPalette40[0x40] = {',1)[1].split('};',1)[0]
    part=re.sub(r'//[^\n]*','',part);entries=[int(x,16) for x in re.findall(r'0x([0-9a-fA-F]+)',part)]
    assert len(entries)==64
    for logical in RGB:
        index=entries[logical];rgba=0xc0|((index>>4)&3)|(index&12)|((index&3)<<4)
        assert rgba==RGB[logical]==lib.span_test_colour(logical),(logical,rgba)
    graphics=GRAPHICS.read_text();assert 'bitmapTransform = 65535;' in graphics
    # Main normal affine selector stores the exact supplied id, including65535.
    setter=graphics.split('void Context::setAffineTransform(',1)[1].split('//',1)[0]
    assert 'bitmapTransform = bufferId;' in setter
    pins=json.loads((PACED/'STOCK-PATH.json').read_text())['files'];assert sha(GRAPHICS)==pins[str(GRAPHICS)]
    return dict(logical_to_rgba={str(k):v for k,v in RGB.items()},palette_source_sha256=sha(PALETTE),
        graphics_source_sha256=sha(GRAPHICS),affine_65535_disable_verified=True)

def units(mode,lib,raster):
    lib.span_test_colour.argtypes=[C.c_int];lib.span_test_colour.restype=C.c_int
    lib.span_test_edge.argtypes=[C.c_int,C.c_int,C.c_int,C.POINTER(C.c_int),C.c_uint]
    lib.span_test_section.argtypes=[C.POINTER(C.c_uint8),C.c_uint,*([C.c_int]*5)]
    palette=palette_check(lib)
    cases=0;rng=random.Random(0x52385331)
    # Independently use Python floor division for mathematical ceil(a/b).
    for height in (1,2,3,7,31,119,120):
        for top,bottom in [(-32768,32767),(32767,-32768),(-9,-10),(-9,10),(0,0),(1,-1)]+[(rng.randint(-3200,3200),rng.randint(-3200,3200)) for _ in range(64)]:
            values=(C.c_int*height)();assert lib.span_test_edge(top,bottom,height,values,height)==1
            assert list(values)==[top-(-(bottom-top)*step//height) for step in range(1,height+1)]
            cases+=1
    ctl=C.CDLL(str(CONTROL_WORK/('host-'+mode+'.so')))
    ctl.span_control_section.argtypes=[C.POINTER(C.c_uint8),C.c_uint,*([C.c_int]*5)];ctl.span_control_section.restype=C.c_uint
    sections=[]
    for yt,yb in ((104,105),(104,224),(105,106),(104,116),(116,117),(200,223),(223,224)):
        for ct,cb in ((160,160),(-3183,-3183),(3183,3183),(-200,500),(500,-200),(0,320),(319,-20)):
            for marked in (0,1):sections.append((ct,cb,yt,yb,marked))
    for _ in range(500):
        yt=rng.randrange(104,224);yb=rng.randrange(yt+1,225)
        sections.append((rng.randrange(-3183,3184),rng.randrange(-3183,3184),yt,yb,rng.randrange(2)))
    for ct,cb,yt,yb,marked in sections:
        guarded=(C.c_uint8*(BYTES+32))(*([0xcc]*(BYTES+32)));pointer=C.cast(C.addressof(guarded)+16,C.POINTER(C.c_uint8));C.memset(pointer,0xc8,BYTES)
        assert lib.span_test_section(pointer,BYTES,ct,cb,yt,yb,marked)==1
        command=(C.c_uint8*256)();n=ctl.span_control_section(command,len(command),ct,cb,yt,yb,marked)
        shapes,_=decode(bytes(command[:n]));expected=raster(shapes);actual=bytes(guarded)[16:-16]
        assert actual==expected,(ct,cb,yt,yb,marked,'stock quad coverage mismatch')
        assert bytes(guarded)[:16]==bytes(guarded)[-16:]==b'\xcc'*16
    bad=0
    guarded=(C.c_uint8*BYTES)();original=bytes(guarded)
    for ct,cb,yt,yb,marked,n in [(160,160,103,120,0,BYTES),(160,160,120,120,0,BYTES),(160,160,223,225,0,BYTES),(160,160,104,120,2,BYTES),(3184,0,104,120,0,BYTES),(0,0,104,120,0,BYTES-1)]:
        assert lib.span_test_section(guarded,n,ct,cb,yt,yb,marked)==0 and bytes(guarded)==original;bad+=1
    return dict(edge_cases=cases,section_stock_raster_cases=len(sections),invalid_untouched_cases=bad,
        clipping_and_one_row_cases=True,top_104_grass_and_224_exclusion=True,guard_bytes_unchanged=True,palette=palette)

def replay(mode,raster):
    control_spec=specification(CONTROL_WORK/'package');candidate_spec=specification(WORK/'package')
    ctl=NativeRuntime(control_spec,CONTROL_WORK/('host-'+mode+'.so'))
    new=SpanRuntime(candidate_spec,WORK/('host-'+mode+'.so'))
    assert ctl.invoke('InitRace')==new.invoke('InitRace')==0
    tables=json.loads((BASE/'reference/tables.json').read_text());model=Traffic(tables,'circuit',3276800,1,99);player=3246800
    for car,gap in zip(model.cars,[0,3199,3200,6400,18000,80000]):
        car.active=1;car.progress=player+gap;car.position=car.progress%model.lap;car.lateral=0
    world=hashlib.sha256();pixels_digest=hashlib.sha256();bands_total=road_total=maximum_road=0
    pixel_byte_values=set()
    for tick in range(1,3601):
        speed=tables['records'][(model.pace.record+1)%6 if model.pace.remaining==0 else model.pace.record][1]
        player+=speed*2;model.advance(player,tick)
        assert ctl.invoke('Tick120')==new.invoke('Tick120')==0
        root,arrays=new.snapshot();old_root,old_arrays=ctl.snapshot();assert root==old_root and arrays==old_arrays
        expected=dict(worldTick=tick,playerStation=player%model.lap,playerUnwrapped=player,renderPhase=player%8000,
            routeRecord=model.pace.record,routeRemaining=model.pace.remaining,routeHeading=model.pace.heading,routeLateral=model.pace.lateral)
        for field,value in expected.items():assert candidate_spec.get(root,field)==value,(tick,field)
        hits=[]
        for i,car in enumerate(model.cars):
            hit=int(contact(car.position,car.lateral,player%model.lap,0,model.lap));hits.append(hit)
            for field,value in [('active',car.active),('position',car.position),('progress',car.progress),('lateral',car.lateral),('contacts',hit)]:
                assert candidate_spec.array_get(arrays,field,i)==value,(tick,field,i)
        assert candidate_spec.get(root,'contactAny')==bool(any(hits))
        if tick%4:continue
        frame=tick//4;assert ctl.invoke('Render30')==new.invoke('Render30')==0
        root,arrays=new.snapshot();old_root,old_arrays=ctl.snapshot();assert root==old_root and arrays==old_arrays
        done=new.data(50304);old_done=ctl.data(50304)
        assert struct.unpack_from('<HHiiIII',done)==(48,1,0,0,7,frame,tick)
        assert struct.unpack_from('<H',done,44)[0]==1
        assert done[:24]==old_done[:24] and done[28:]==old_done[28:]
        lengths=struct.unpack_from('<III',done,24);old_lengths=struct.unpack_from('<III',old_done,24)
        old_outputs=[ctl.data(key)[:n] for key,n in zip((50301,50302,50303),old_lengths)]
        outputs=[new.data(key)[:n] for key,n in zip((50301,50302,50303),lengths)]
        assert outputs[1:]==old_outputs[1:],'Actor/player commands changed'
        prefix=b'\x17\0\x96\1\xff\xff\x17\x1b\x20'+struct.pack('<H',BUFFER)+b'\x17\x1b\3'+struct.pack('<hh',0,TOP)
        assert len(prefix)==18 and outputs[0].startswith(prefix)
        shapes,old_rects=decode(old_outputs[0]);no_shapes,new_rects=decode(outputs[0][18:])
        assert not no_shapes and new_rects==old_rects[1:],'HUD/finish commands changed'
        bitmap=new.data(BUFFER);assert bitmap==raster(shapes),(frame,'Road raster changed')
        pixel_byte_values.update(bitmap);pixels_digest.update(bitmap)
        state=bytes(root)+b''.join(bytes(arrays[k]) for k in sorted(arrays));world.update(state)
        bands_total+=struct.unpack_from('<H',done,36)[0];road_total+=lengths[0];maximum_road=max(maximum_road,lengths[0])
    final=json.loads((BASE/'native-demo/SOURCE-RESULTS.json').read_text())
    for a in candidate_spec.arrays.values():
        if a['access']==3:assert bytes(arrays[a['buffer']]).hex()==final['final_arrays'][a['name']]
    for r in (ctl,new):
        assert r.invoke('StopRace')==0 and r.invoke(operation=3)==0
        assert not r.live and r.grants==r.releases;r.canaries()
    assert new.peak==4 and ctl.peak==3
    return dict(frames=900,ticks=3600,independent_world_model_pass=True,final_arrays_exact=True,
        world_digest=world.hexdigest(),road_pixel_digest=pixels_digest.hexdigest(),stock_quad_rasters_equal=900,
        unchanged_actor_player_commands=True,unchanged_HUD_finish_commands=True,average_bands=bands_total/900,
        average_road_list_bytes=road_total/900,maximum_road_list_bytes=maximum_road,
        opaque_pixel_values=sorted(pixel_byte_values),balanced_leases=True,peak_leases=new.peak,
        authoritative_state_matches_float_quad_control=True)

def failures(mode,lib):
    spec=importlib.util.spec_from_file_location('span_helper_cases',BASE/'renderer-helper/verify.py')
    old=importlib.util.module_from_spec(spec);spec.loader.exec_module(old)
    original=old.Harness
    class Harness(original):
        def __init__(self,*args,**kwargs):
            super().__init__(*args,**kwargs);self.limit=4
            self.set(BUFFER,b'\xcc'*(BYTES+16));self.pixel_fault=None;self.pixel_calls=0;self.pixel_fault_at=None
        def acquire(self,context,id,access,offset,n,out):
            if id==BUFFER:
                self.pixel_calls+=1
                fault=self.pixel_fault if self.pixel_fault_at in (None,self.pixel_calls) else None
                if fault in ('missing','busy'):return 2 if fault=='missing' else 7
                rc=super().acquire(context,id,access,offset,n,out)
                if not rc and fault:
                    if fault=='short-view':out.contents.bytes-=1
                    elif fault=='null-view':out.contents.data=C.POINTER(C.c_uint8)()
                    elif fault=='read-view':out.contents.access=1
                    elif fault=='partial-error':return 2
                return rc
            return super().acquire(context,id,access,offset,n,out)
        def canaries(self):
            super().canaries();assert bytes(self.buffers[BUFFER])[-16:]==b'\xcc'*16
    old.Harness=Harness
    lib.rally_render_bind_v1.argtypes=[C.POINTER(old.Host),C.POINTER(old.Context),C.POINTER(old.Bindings),C.POINTER(old.Completion)]
    lib.rally_render_prepare_v1.argtypes=[C.POINTER(old.Host),C.POINTER(old.Context),C.POINTER(old.State),C.POINTER(old.Completion)]
    lib.rally_render_stop_v1.argtypes=[C.POINTER(old.Context),C.POINTER(old.Completion)]
    for name in ('bind','prepare','stop'):getattr(lib,'rally_render_'+name+'_v1').restype=C.c_int32
    cases=json.loads((BASE/'renderer-prep/scene-cases.json').read_text())['cases']
    sample=next(x for x in cases if x['track']=='fuji' and x['label'].startswith('boundary:') and x['counts'][1]>=2)
    raw=bytes.fromhex(sample['state_hex']);state=old.convert(raw)
    inherited=old.failures(lib,raw);additional=0
    for phase in ('bind','prepare','actual'):
        for fault in ('missing','busy','short-view','null-view','read-view','partial-error'):
            h=Harness(lib)
            if phase!='bind':assert h.bind()==0
            h.pixel_fault=fault;h.c.ready=1
            if phase=='actual':h.pixel_fault_at=h.pixel_calls+2
            assert (h.bind() if phase=='bind' else h.prepare(state))!=0 and not h.c.ready
            h.clean();h.canaries();additional+=1
        h=Harness(lib)
        if phase!='bind':assert h.bind()==0
        h.set(BUFFER,b'\xcc'*(BYTES-1));assert (h.bind() if phase=='bind' else h.prepare(state))!=0
        assert not h.c.ready;h.clean();additional+=1
    for source in ('asset','output','context','state','completion','host','bindings'):
        h=Harness(lib)
        if source=='state':assert h.bind()==0
        if source=='asset':p=C.addressof(h.buffers[h.b.asset.buffer])
        elif source=='output':p=C.addressof(h.buffers[h.b.output[0].buffer])
        else:p=C.addressof({'context':h.ctx,'state':state,'completion':h.c,'host':h.host,'bindings':h.b}[source])
        h.buffers[BUFFER]=(C.c_uint8*BYTES).from_address(p)
        assert (h.prepare(state) if source=='state' else h.bind())!=0 and not h.c.ready
        if source!='state':assert not h.ctx.bound
        h.clean();additional+=1
    # Exercise every new actual-prepare service position, including pixel release.
    for fault in ('acquire','release'):
        h=Harness(lib);assert h.bind()==0;h.reset_faults();assert h.prepare(state)==0
        count=h.acquires if fault=='acquire' else h.releases
        for index in range(1,count+1):
            h=Harness(lib);assert h.bind()==0;h.reset_faults();setattr(h,'fail_'+fault,index)
            assert h.prepare(state)!=0 and not h.c.ready,(fault,index)
            if fault=='release':assert not h.ctx.bound,(fault,index,h.c.reason)
            h.clean();h.canaries();additional+=1
    # Simultaneous short list and failed actual pixel release must retain release
    # reason/unbind instead of overwriting it with the later output-capacity error.
    h=Harness(lib);h.b.output[0].bytes=1;assert h.bind()==0;h.reset_faults();h.fail_release=5
    assert h.prepare(state)!=0 and not h.c.ready and not h.ctx.bound and h.c.reason==7
    h.clean();h.canaries();additional+=1
    return dict(inherited_helper_failure_cases=inherited,additional_pixel_lifetime_alias_cases=additional,
        failed_or_malformed_grants_released=True,failed_release_unbinds=True)

def worker(mode):
    lib=C.CDLL(str(WORK/('host-'+mode+'.so')));raster=rasterizer(mode)
    unit=units(mode,lib,raster);print(mode,'unit cases pass',flush=True)
    failure=failures(mode,lib);print(mode,'failure cases pass',flush=True)
    result=dict(scope='Host actual generated C plus native helper; no target runtime or performance claim',mode=mode,
        units=unit,failures=failure,replay=replay(mode,raster),
        source_files={p.name:sha(p) for p in (HERE/'span.inc',HERE/'span_build.py',HERE/'span-host.c',HERE/'span_check.py')},
        host_library_sha256=sha(WORK/('host-'+mode+'.so')))
    (HERE/('span-HOST-'+mode+'.json')).write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2),flush=True)

def main(candidate_only=False):
    compile_hosts(candidate_only)
    for mode in ('ordinary','sanitized'):
        env=os.environ.copy()
        if mode=='sanitized':
            env['LD_PRELOAD']=subprocess.check_output(['cc','-print-file-name=libasan.so'],text=True).strip()
            env['ASAN_OPTIONS']='detect_leaks=0:halt_on_error=1';env['UBSAN_OPTIONS']='halt_on_error=1:print_stacktrace=1'
        subprocess.run([sys.executable,__file__,'--worker',mode],env=env,check=True)

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--worker',choices=['ordinary','sanitized']);p.add_argument('--candidate-only',action='store_true');a=p.parse_args()
    worker(a.worker) if a.worker else main(a.candidate_only)
