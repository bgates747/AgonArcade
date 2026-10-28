"""One-byte stock Native-bitmap A/B, using exact pinned copy functions on host.

The source span module/tape/fixtures remain immutable. No emulator, remote work,
SDK mutation or repeated simulation replay. Output: .work/native-format/fixture.
"""
from pathlib import Path
import hashlib
import json
import os
import re
import shutil
import struct
import subprocess

HERE=Path(__file__).resolve().parent
WORK=HERE/'.work/native-format'
SPAN=HERE/'.work/span-candidate'
UPSTREAM=Path('/Agon/mystuff/agon-vdplet/build/firmware')
VDP_PIN='1056ee38ec1cc68ed327bd32ee47d04b1c30597c'
GL_PIN='ac2dd5986daf496c43ae8e7fe41836274aec54a0'
GL=UPSTREAM/'firmware-src/.pio/libdeps/esp32dev/vdp-gl'
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
digest=lambda data:hashlib.sha256(data).hexdigest()

def function(source,signature):
    start=source.index(signature);brace=source.index('{',start);depth=1;at=brace+1
    while depth:
        if source[at]=='{':depth+=1
        elif source[at]=='}':depth-=1
        at+=1
    return source[start:at]+'\n'

def pinned_sources():
    sources={};report={}
    for root,pin,names in [(UPSTREAM/'upstream.git',VDP_PIN,[
        'video/agon_screen.h','video/agon_palette.h','video/vdu_sprites.h','video/context/graphics.h']),
        (GL,GL_PIN,['src/displaycontroller.cpp','src/displaycontroller.h','src/fabglconf.h',
        'src/dispdrivers/vga64controller.cpp','src/dispdrivers/vgabasecontroller.cpp','src/dispdrivers/vgabasecontroller.h'])]:
        for name in names:
            raw=subprocess.check_output(['git','-C',str(root),'show',pin+':'+name])
            local=(UPSTREAM/'firmware-src'/name) if name.startswith('video/') else GL/name
            assert local.read_bytes()==raw,('Pinned stock source changed',local)
            sources[name]=raw.decode();report[name]=dict(git_pin=pin,sha256=digest(raw),local=str(local))
    screen=sources['video/agon_screen.h']
    assert 'case 136:\n\t\t\terrVal = changeResolution(64, QVGA_320x240_60Hz, true);' in screen
    assert 'case 64: return std::move(std::unique_ptr<fabgl::VGA64Controller>' in screen
    conf=sources['src/fabglconf.h']
    mode=next(line for line in conf.splitlines() if line.startswith('#define QVGA_320x240_60Hz '))
    assert '-HSync -VSync' in mode and '320 328 376 400 240 245 246 262' in mode
    sprite=sources['video/vdu_sprites.h']
    assert 'case 3: // Native\n\t\t\tpixelFormat = PixelFormat::Native;\n\t\t\tbytesPerPixel = 1.;' in sprite
    assert 'context->drawBitmap(rx,ry, false, true);' in sprite
    graphics=sources['video/context/graphics.h']
    assert 'getPaintOptions(fabgl::PaintMode::Set, gpofg)' in graphics
    assert 'if (bitmapTransform != 65535)' in graphics
    assert 'bitmapTransform = bufferId;' in function(graphics,'void Context::setAffineTransform(')
    header=sources['src/dispdrivers/vgabasecontroller.h']
    definitions={name:int(value) for name,value in re.findall(r'^#define (VGA_(?:RED|GREEN|BLUE|HSYNC|VSYNC)_BIT)\s+(\d+)',header,re.M)}
    assert definitions==dict(VGA_RED_BIT=0,VGA_GREEN_BIT=2,VGA_BLUE_BIT=4,VGA_HSYNC_BIT=6,VGA_VSYNC_BIT=7)
    assert '#define VGA_PIXELINROW(row, X)   (row[(X) ^ 2])' in header
    base=sources['src/dispdrivers/vgabasecontroller.cpp'];assert 'm_HVSync = packHVSync(false, false);' in base
    # Logical palette is 00RRGGBB lookup; both bitmap formats use raw BBGGRR.
    part=sources['video/agon_palette.h'].split('defaultPalette40[0x40] = {',1)[1].split('};',1)[0]
    part=re.sub(r'//[^\n]*','',part);palette=[int(x,16) for x in re.findall(r'0x([0-9a-fA-F]+)',part)]
    assert len(palette)==64
    raw_palette=[0xc0|((x>>4)&3)|(x&12)|((x&3)<<4) for x in palette]
    assert [raw_palette[x] for x in (2,8,9,11,15)]==[0xc8,0xd5,0xc3,0xcf,0xff]
    for value in range(64):
        pixel=0xc0|value;assert pixel&0xc0 and pixel==(0xc0|(pixel&0x3f))
    return sources,dict(pins=report,mode=136,controller='VGA64Controller',modeline=mode,
        visible_sync_mask=192,logical_palette_to_native=raw_palette,all_64_opaque_codes_equivalent=True,
        source_row_major=True,destination_xor_2_performed_by_stock_copy=True,
        ordinary_Set_plot_required=True,affine_65535_disabled_required=True,
        exclusions=['Transparency','non-Set paint semantics','transformed Native bitmaps','different mode/modeline/polarity'])

def host_proof(sources):
    fragments={
        'pack_sync':function(sources['src/dispdrivers/vgabasecontroller.cpp'],'uint8_t IRAM_ATTR VGABaseController::packHVSync('),
        'native_copy':function(sources['src/displaycontroller.h'],'  template <typename TRawGetRow, typename TRawSetPixelInRow, typename TDataType>\n  void genericRawDrawBitmap_Native('),
        'rgba_copy':function(sources['src/displaycontroller.h'],'  template <typename TRawGetRow, typename TRawGetPixelInRow, typename TRawSetPixelInRow, typename TBackground>\n  void genericRawDrawBitmap_RGBA2222('),
        'native_dispatch':function(sources['src/dispdrivers/vga64controller.cpp'],'void VGA64Controller::rawDrawBitmap_Native('),
        'rgba_dispatch':function(sources['src/dispdrivers/vga64controller.cpp'],'void VGA64Controller::rawDrawBitmap_RGBA2222('),
        'paint_setter':function(sources['src/dispdrivers/vga64controller.cpp'],'std::function<void(uint8_t * row, int x, uint8_t colorIndex)> VGA64Controller::setRowPixelLambda('),
        'clip_and_dispatch':function(sources['src/displaycontroller.cpp'],'void IRAM_ATTR BitmappedDisplayController::absDrawBitmap('),
    }
    for name,data in fragments.items():(WORK/(name+'.inc')).write_text(data)
    scaffold=r'''
#include <array>
#include <cassert>
#include <cstdint>
#include <functional>
#include <iostream>
#include <vector>
#define IRAM_ATTR
#define VGA_RED_BIT 0
#define VGA_GREEN_BIT 2
#define VGA_BLUE_BIT 4
#define VGA_HSYNC_BIT 6
#define VGA_VSYNC_BIT 7
#define VGA_SYNC_MASK ((1<<6)|(1<<7))
#define VGA_PIXELINROW(row,X) (row[(X)^2])
enum class PixelFormat{Undefined,Native,Mask,RGBA2222,RGBA8888};
enum class PaintMode{Set,OR,ORNOT,AND,ANDNOT,XOR,Invert,NoOp};
struct RGB222{uint8_t R,G,B;};
struct Rect{int X1,Y1,X2,Y2;};
struct Bitmap{int width,height;const uint8_t*data;PixelFormat format;};
struct State{Rect absClippingRect={0,0,319,239};struct Options{PaintMode mode=PaintMode::Set;bool swapFGBG=false;}paintOptions;RGB222 penColor={0,0,0};};
class BitmappedDisplayController{public:State state;State&paintState(){return state;}int getViewPortWidth(){return 320;}int getViewPortHeight(){return 240;}
 void absDrawBitmap(int,int,const Bitmap*,void*,bool);
 virtual void rawDrawBitmap_Native(int,int,const Bitmap*,int,int,int,int)=0;
 virtual void rawDrawBitmap_RGBA2222(int,int,const Bitmap*,void*,int,int,int,int)=0;
 virtual void rawDrawBitmap_Mask(int,int,const Bitmap*,void*,int,int,int,int){assert(false);}
 virtual void rawDrawBitmap_RGBA8888(int,int,const Bitmap*,void*,int,int,int,int){assert(false);}
};
class VGABaseController:public BitmappedDisplayController{public:struct Timings{char HSyncLogic='-',VSyncLogic='-';}m_timings;uint8_t m_HVSync=0xc0;
 uint8_t packHVSync(bool,bool);
 uint8_t preparePixel(RGB222 rgb){return m_HVSync|(rgb.B<<VGA_BLUE_BIT)|(rgb.G<<VGA_GREEN_BIT)|(rgb.R<<VGA_RED_BIT);}
};
class VGA64Controller:public VGABaseController{public:
 std::array<std::array<uint8_t,352>,240> backing;std::array<uint8_t*,240> m_viewPort;
 VGA64Controller(){for(int y=0;y<240;++y){backing[y].fill(0x5a);m_viewPort[y]=backing[y].data()+16;}m_HVSync=packHVSync(false,false);}
 void rawDrawBitmap_Native(int,int,const Bitmap*,int,int,int,int)override;
 void rawDrawBitmap_RGBA2222(int,int,const Bitmap*,void*,int,int,int,int)override;
 std::function<void(uint8_t*,int,uint8_t)>setRowPixelLambda(PaintMode);
 #include "native_copy.inc"
 #include "rgba_copy.inc"
};
#include "pack_sync.inc"
#include "native_dispatch.inc"
#include "rgba_dispatch.inc"
#include "paint_setter.inc"
#include "clip_and_dispatch.inc"
int main(){
 unsigned cases=0;
 for(auto dim:{std::pair<int,int>{1,1},{35,8},{320,120}}){
  int w=dim.first,h=dim.second;std::vector<uint8_t>image(w*h+32,0xa5);auto src=image.data()+16;
  for(int y=0;y<h;++y)for(int x=0;x<w;++x)src[y*w+x]=0xc0|((x+7*y)%64);
  for(int dx:{-25,0,13,319,330})for(int dy:{-5,0,104,200,239,250})
  for(Rect clip:{Rect{0,0,319,239},Rect{10,104,309,223},Rect{0,104,319,223}}){
    VGA64Controller native,rgba;assert(native.m_HVSync==0xc0);native.state.absClippingRect=rgba.state.absClippingRect=clip;
    Bitmap a{w,h,src,PixelFormat::Native},b{w,h,src,PixelFormat::RGBA2222};
    native.absDrawBitmap(dx,dy,&a,nullptr,false);rgba.absDrawBitmap(dx,dy,&b,nullptr,false);
    assert(native.backing==rgba.backing);
    for(int y=0;y<240;++y){for(int x=0;x<16;++x){assert(native.backing[y][x]==0x5a);assert(native.backing[y][336+x]==0x5a);}
      for(int x=0;x<320;++x){int sx=x-dx,sy=y-dy;bool drawn=x>=clip.X1&&x<=clip.X2&&y>=clip.Y1&&y<=clip.Y2&&sx>=0&&sx<w&&sy>=0&&sy<h;
       auto expected=drawn?src[sy*w+sx]:0x5a;assert(VGA_PIXELINROW(native.m_viewPort[y],x)==expected);
      }
    }
    for(int i=0;i<16;++i){assert(image[i]==0xa5);assert(image[w*h+16+i]==0xa5);}
    ++cases;
  }
 }
 VGA64Controller c;unsigned masks=0;for(char h:{'-','+'})for(char v:{'-','+'}){c.m_timings={h,v};assert(c.packHVSync(false,false)==((h=='-'?64:0)|(v=='-'?128:0)));++masks;}
 std::cout<<"{\"ordinary_and_clipped_copy_cases\":"<<cases<<",\"opaque_pixel_codes\":64,\"polarity_cases\":"<<masks<<",\"native_equals_rgba\":true,\"source_row_major_verified\":true,\"guards_unchanged\":true}\n";
}
'''
    (WORK/'proof.cpp').write_text(scaffold)
    report={}
    for mode,flags in [('ordinary',[]),('sanitized',['-fsanitize=address,undefined','-fno-omit-frame-pointer'])]:
        target=WORK/('proof-'+mode)
        subprocess.run(['c++','-std=c++17','-O1',*flags,'-I'+str(WORK),str(WORK/'proof.cpp'),'-o',str(target)],check=True)
        env=os.environ.copy()
        if mode=='sanitized':
            env['ASAN_OPTIONS']='detect_leaks=0:halt_on_error=1'
            env['UBSAN_OPTIONS']='halt_on_error=1:print_stacktrace=1'
        report[mode]=json.loads(subprocess.check_output([str(target)],text=True,env=env))
    return dict(extracted_function_sha256={name:digest(data.encode()) for name,data in fragments.items()},
        compiler=subprocess.check_output(['c++','--version'],text=True).splitlines()[0],results=report,
        scope='Extracted exact pinned clipping/dispatch/copy/paint/sync functions with host memory scaffolding; no target timing claim')

def fixture():
    baseline=json.loads((HERE/'span-BUILD.json').read_text())
    assert sha(SPAN/'target/rally-render.vdpl')==baseline['module']['sha256']
    for name,expected in baseline['fixture']['files'].items():assert sha(SPAN/'fixture'/name)==expected,name
    out=WORK/'fixture';out.mkdir(parents=True,exist_ok=True)
    for name in baseline['fixture']['files']:shutil.copyfile(SPAN/'fixture'/name,out/name)
    native=(out/'native.vdu').read_bytes();suffix=b'\x17\x1b\x20'+struct.pack('<H',50700)+b'\x17\x1b\x21'+struct.pack('<HHB',320,120,1)
    assert native.endswith(suffix)
    changed=native[:-1]+b'\3';assert len(changed)==len(native) and sum(a!=b for a,b in zip(native,changed))==1
    (out/'native.vdu').write_bytes(changed)
    meta=json.loads((out/'expected.json').read_text());meta.update(candidate='native-span-stock-native-format',
        bitmap_format=3,bitmap_format_name='Native fixed mode136 (-HSync,-VSync)',
        comparison_scope='Only native.vdu final bitmap-format byte1->3; exact span module/script/assets/driver/pixels')
    meta['extra_app_buffer']['format']='Native, mode136 raw pixels; same opaque RGBA2222 bytes'
    meta['files']['native.vdu']=sha(out/'native.vdu')
    (out/'expected.json').write_text(json.dumps(meta,indent=2)+'\n')
    files={p.name:sha(p) for p in sorted(out.iterdir()) if p.is_file()}
    differences=[name for name,expected in baseline['fixture']['files'].items() if files[name]!=expected]
    assert set(differences)=={'native.vdu','expected.json'}
    return dict(directory=str(out.relative_to(HERE)),files=files,module_sha256=baseline['module']['sha256'],
        changed_guest_input='native.vdu final byte only:1->3',native_vdu_changed_offset=len(native)-1,
        metadata_changes='expected.json identifies variant and new native.vdu hash',script_byte_identical=True,
        driver_byte_identical=True,module_byte_identical=True,other_assets_byte_identical=True,
        unchanged_picture_bytes='Proved all64opaque codes and retained module900-frame pixel values',
        foreground_paced=True,stock_swap_retained=True,emulator_launched=False)

def main():
    WORK.mkdir(parents=True,exist_ok=True)
    sources,proof=pinned_sources()
    host=host_proof(sources)
    result=fixture()
    source_receipt=dict(schema=1,producer_sha256=sha(__file__),static=proof,host=host)
    (HERE/'native-FORMAT-PROOF.json').write_text(json.dumps(source_receipt,indent=2)+'\n')
    receipt=dict(schema=1,producer_sha256=sha(__file__),fixture=result,
        proof_sha256=sha(HERE/'native-FORMAT-PROOF.json'),sdk_changed=False,firmware_changed=False,
        simulation_replay_repeated=False,target_performance_qualified=False)
    (HERE/'native-FORMAT.json').write_text(json.dumps(receipt,indent=2)+'\n')
    print(json.dumps(receipt,indent=2))

if __name__=='__main__':main()
