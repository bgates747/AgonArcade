"""Copy unchanged stock function text into private host-only include fragments.

Source reads use the qualified VDP/vdp-gl commits. No external file is changed.
The ANSI DSP function is a separately identified local official source snapshot;
the unavailable old firmware Mat implementation is not replaced by a claimed pin.
"""
from pathlib import Path
import hashlib
import json
import subprocess

HERE=Path(__file__).resolve().parent
STOCK=HERE/'stock'
VDP=Path('/Agon/mystuff/agon-vdplet/build/firmware/upstream.git')
VDP_PIN='1056ee38ec1cc68ed327bd32ee47d04b1c30597c'
GL=Path('/Agon/mystuff/agon-vdplet/build/firmware/firmware-src/.pio/libdeps/esp32dev/vdp-gl')
GL_PIN='ac2dd5986daf496c43ae8e7fe41836274aec54a0'
DSP=Path('/Agon/mystuff/agon-extender/vdp/managed_components/espressif__esp-dsp')
SDK=Path('/home/smith/.platformio/packages/framework-arduinoespressif32/tools/sdk/esp32')
sha=lambda data:hashlib.sha256(data).hexdigest()


def committed(repo,pin,name):
    return subprocess.check_output(['git','-C',str(repo),'show',pin+':'+name])


def closing(text,begin):
    level=0;i=begin;quote=None
    while i<len(text):
        if quote:
            if text[i]=='\\':i+=2;continue
            if text[i]==quote:quote=None
        elif text.startswith('//',i):
            end=text.find('\n',i);i=len(text) if end<0 else end;continue
        elif text.startswith('/*',i):
            i=text.index('*/',i+2)+2;continue
        elif text[i] in ('"',"'"):quote=text[i]
        elif text[i]=='{':level+=1
        elif text[i]=='}':
            level-=1
            if not level:return i+1
        i+=1
    raise AssertionError('Unbalanced function')


def function(text,signature,template=False):
    assert text.count(signature)==1,signature
    at=text.index(signature)
    start=text.rfind('\n',0,at)+1
    if template:
        start=text.rfind('  template <',0,start)
        assert start>=0
    brace=text.index('{',at)
    return text[start:closing(text,brace)]+'\n'


def extract():
    STOCK.mkdir(exist_ok=True)
    inputs={}
    def source(label,repo,pin,name):
        data=committed(repo,pin,name)
        inputs[label]=dict(repository=str(repo),commit=pin,path=name,sha256=sha(data))
        return data.decode()
    controller_h=source('displaycontroller.h',GL,GL_PIN,'src/displaycontroller.h')
    controller_cpp=source('displaycontroller.cpp',GL,GL_PIN,'src/displaycontroller.cpp')
    vga=source('vga64controller.cpp',GL,GL_PIN,'src/dispdrivers/vga64controller.cpp')
    utils=source('fabutils.cpp',GL,GL_PIN,'src/fabutils.cpp')
    buffered=source('vdu_buffered.h',VDP,VDP_PIN,'video/vdu_buffered.h')
    assert inputs['displaycontroller.cpp']['sha256']=='f3588a684647ef258c024251d17b029e2877c8363b28a570432376f353232902'
    assert inputs['vdu_buffered.h']['sha256']=='b9d9d93295ddc5fb05c802071057e32ed9755837f029ce381340072352c262f0'
    outputs={}
    def write(name,text,source_name,description):
        data=text.encode();(STOCK/name).write_bytes(data)
        outputs[name]=dict(sha256=sha(data),source=source_name,description=description,algorithm_text_unchanged=True)
    generic=''.join(function(controller_h,name,True) for name in (
        'void genericRawDrawBitmap_RGBA2222(', 'void genericRawDrawTransformedBitmap_RGBA2222('))
    write('pixel_templates.inc',generic,'displaycontroller.h','Complete unchanged ordinary and transformed RGBA2222 templates')
    methods=''.join(function(controller_cpp,name) for name in (
        'RGBA2222 Bitmap::getPixel2222(',
        'void IRAM_ATTR BitmappedDisplayController::drawBitmap(',
        'void IRAM_ATTR BitmappedDisplayController::absDrawBitmap(',
        'void IRAM_ATTR BitmappedDisplayController::drawBitmapWithTransform('))
    methods+=''.join(function(utils,name) for name in ('Rect IRAM_ATTR Rect::merge(', 'Rect IRAM_ATTR Rect::intersection('))
    write('display_methods.inc',methods,'displaycontroller.cpp + fabutils.cpp','Complete unchanged bounds, clipping, dispatch and bitmap pixel lookup')
    methods=''.join(function(vga,name) for name in (
        'std::function<void(uint8_t * row, int x, uint8_t colorIndex)> VGA64Controller::setRowPixelLambda(',
        'void VGA64Controller::rawDrawBitmap_RGBA2222(',
        'void VGA64Controller::rawDrawBitmapWithMatrix_RGBA2222('))
    write('vga_methods.inc',methods,'vga64controller.cpp','Unchanged VGA64 setter factory/std::function and ordinary/transformed dispatch')
    transform=function(buffered,'void VDUStreamProcessor::bufferTransformBitmap(')
    write('command40.reference.inc',transform,'vdu_buffered.h','Complete stock buffered0x28 implementation; reference only')
    start=transform.index('\t// iterate over our destination buffer')
    stop=transform.index('\t// save new bitmap data to target buffer',start)
    write('command40_pixels.inc',transform[start:stop],'vdu_buffered.h','Unchanged command40 pixel kernel; surrounding host allocation is a shim')
    start=transform.index('\tif (shouldResize || autoTranslate) {')
    stop=closing(transform,transform.index('{',start))
    write('command40_bounds.inc',transform[start:stop]+'\n','vdu_buffered.h','Unchanged natural command40 bounds/resize/translation block')
    dsp_path=DSP/'modules/matrix/mul/float/dspm_mult_f32_ansi.c'
    dsp_bytes=dsp_path.read_bytes();inputs['dsp_ansi']=dict(path=str(dsp_path),sha256=sha(dsp_bytes),
        component_commit='196825deaa4848b2c8e87b6126491cd7fc87e5bf',component_version='1.8.0')
    write('dsp_ansi.inc',function(dsp_bytes.decode(),'esp_err_t dspm_mult_f32_ansi('),'dsp_ansi',
        'Unchanged official ANSI multiplication function; not Xtensa optimized assembly')
    (STOCK/'LICENSE-vdp-gl.txt').write_bytes(committed(GL,GL_PIN,'LICENSE'))
    (STOCK/'LICENSE-esp-dsp.txt').write_bytes((DSP/'LICENSE').read_bytes())
    sdk_header=SDK/'include/espressif__esp-dsp/modules/matrix/include/mat.h'
    inputs['installed_sdk_mat_header']=dict(path=str(sdk_header),sha256=sha(sdk_header.read_bytes()))
    sdk_archive=SDK/'lib/libespressif__esp-dsp.a'
    inputs['installed_sdk_dsp_archive']=dict(path=str(sdk_archive),sha256=sha(sdk_archive.read_bytes()),source_available=False)
    live=Path('/Agon/mystuff/agon-vdplet/build/firmware/firmware-src/video/vdu_buffered.h').read_text()
    live_transform=function(live,'void VDUStreamProcessor::bufferTransformBitmap(')
    support={name:dict(sha256=sha((STOCK/name).read_bytes()),algorithm_text_unchanged=False)
             for name in ('stock.hpp','stock.cpp')}
    licenses={name:sha((STOCK/name).read_bytes())
              for name in ('LICENSE-vdp-gl.txt','LICENSE-esp-dsp.txt')}
    manifest=dict(schema=1,host_only=True,inputs=inputs,extracted=outputs,
        support=support,licenses=licenses,extraction_script_sha256=sha(Path(__file__).read_bytes()),
        vdp_pin=VDP_PIN,vdp_gl_pin=GL_PIN,
        qualified_firmware_reference='8da2ebfdfa3b5b00f4a1929ad4885c838845b160f570259792ef370b69d4f473',
        correspondence='Graphics functions copied from qualified source commits; this does not reproduce or byte-match a new firmware binary',
        live_command40_function_identical_to_committed=live_transform==transform,
        command40_opcode=dict(decimal=40,hex='0x28',natural_options=5),
        cached_raster_source_exact=True,std_function_pixel_dispatch_preserved=True,
        compile=dict(language='C++17',required_flags=['-ffp-contract=off'],
            translation_units=['stock/stock.cpp'],
            preserved_source_warning_policy=['-Wno-unused-parameter','-Wno-switch','-Wno-unused-but-set-variable']),
        matrix_multiply='Exact official ANSI C routine compiled for host; firmware uses target-selected DSP implementation',
        inverse='Analytic diagonal host model; old firmware Mat source unavailable locally. No firmware-faithful cold inverse timing claim.',
        shims=['IRAM placement omitted','No sprites in this fixture; hideSprites is a no-op',
               'Host vector/framebuffer allocation; no ESP PSRAM, queue or VSync',
               'VGA64 x^2 byte address macro retained; raw exposed rows are swizzled',
               'PaintMode Set with sync bits0xc0; source artwork is RGBA2222 alpha0/3',
               'Command40 surrounding buffer service/bitmap allocation is not emulated',
               'Transform-to-buffer includes host vector allocation, not target PSRAM allocation',
               'Natural command40 resize+translate has a different edge footprint from direct affine',
               'Host make_affine uses exact ANSI operation-times-identity multiplication plus an analytic diagonal inverse model'],
        source_repositories_modified=False,emulator_launched=False)
    (HERE/'SOURCE-MANIFEST.json').write_text(json.dumps(manifest,indent=2)+'\n')
    print('Extracted unchanged stock pixel/bounds/dispatch functions and exact ANSI multiplication; host inverse remains a labeled model')


if __name__=='__main__':extract()
