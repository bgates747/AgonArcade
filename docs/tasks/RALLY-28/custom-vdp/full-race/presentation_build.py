"""Build one real AgonDev race presenter and the maintained original artwork.

Frozen renderer modules and their buffers are supplied by build.py. This build
never rewrites a historical fixture or shared game source.
"""
from pathlib import Path
import hashlib
import json
import os
import re
import shutil
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[4]
WORK = HERE / '.work/presentation'
OUTPUT = HERE / 'presentation'


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def function(text, name):
    begin = text.index('void ' + name + '(')
    at = text.index('{', begin)
    level, end = 1, at + 1
    while level:
        if text[end] == '{':
            level += 1
        elif text[end] == '}':
            level -= 1
        end += 1
    return text[begin:end] + '\n'


def build_assets(source):
    """Execute maintained loaders with exact stock-API byte-emitting shims."""
    functions = ''.join(function(source, n) for n in ('font', 'fontCreate', 'loadFont', 'loadScenery', 'loadSigns', 'loadCars'))
    # loadCars invokes loadScenery in the game. Split only the asset streams;
    # the exact panorama loader is called in the presentation stream below.
    functions = functions.replace('    loadScenery();', '')
    shim = r'''
#include "car.hpp"
#include "scenery.hpp"
#include "signs.hpp"
#include "signs_data.hpp"
#include "font_data.hpp"
#include <cstdio>
#include <cstring>
#include <cstdint>
using namespace rally::game;
constexpr unsigned CarWidth=102,CarHeight=77,Font=63940,LargeFont=63941;
uint8_t carUpload[CarWidth*CarHeight];rally::Stream stream;
void send(const uint8_t *p,unsigned n){if(n&&fwrite(p,1,n,stdout)!=n)std::abort();}
void flush(){send(stream.data,stream.size);stream.size=0;stream.overflow=false;}
void put(unsigned n){putchar(uint8_t(n));}
void word(unsigned n){put(n);put(n>>8);}
void command(unsigned id,unsigned op){put(23);put(0);put(160);word(id);put(op);}
void vdp_adv_clear_buffer(int id){command(id,2);}
void vdp_adv_write_block_data(int id,int n,char *p){command(id,0);word(n);send((uint8_t*)p,n);}
void vdp_select_bitmap(int id){put(23);put(27);put(0);put(id);}
void vdp_adv_bitmap_from_buffer(int w,int h,int format){put(23);put(27);put(33);word(w);word(h);put(format);}
void vdp_set_text_colour(int ink){put(17);put(ink);}
void vdp_set_text_bg_colour(int paper){put(17);put(128+paper);}
void mos_puts(char *p,unsigned n,int){send((uint8_t*)p,n);}
'''
    shim = shim.replace('#include <cstdint>', '#include <cstdint>\n#include <cstdlib>')
    text = shim + functions + r'''
int main(int argc,char **argv){if(argc!=2)return 2;
if(!strcmp(argv[1],"artwork")){loadCars();loadSigns();}
else if(!strcmp(argv[1],"presentation")){loadScenery();loadFont();}
else {return 2;}
return ferror(stdout)?1:0;}
'''
    cpp = WORK / 'artwork.cpp'
    cpp.write_text(text)
    executable = WORK / 'artwork'
    subprocess.run(['c++', '-std=c++17', '-O2', '-Wall', '-Wextra', '-Werror',
                    '-I' + str(ROOT / 'rally-game/include'), '-I' + str(ROOT / 'rally-production/include'),
                    str(cpp), '-o', str(executable)], check=True)
    for name in ('artwork', 'presentation'):
        data = subprocess.check_output([str(executable), name])
        (OUTPUT / (name + '.vdu')).write_bytes(data)
    return cpp


def build():
    WORK.mkdir(parents=True, exist_ok=True)
    OUTPUT.mkdir(exist_ok=True)
    (WORK / 'src').mkdir(exist_ok=True)
    (WORK / 'include').mkdir(exist_ok=True)
    source_path = ROOT / 'rally-game/src/main.cpp'
    source = source_path.read_text()
    functions = ''.join(function(source, n) for n in ('drawScenery', 'clockText', 'drawHud', 'bottom', 'drawPlayer'))
    functions = functions.replace('if(scene.skyDelta) {', 'if(scene.skyDelta) {++fs::scrollCalls;')
    functions = functions.replace('if(scene.skyRepaint) {', 'if(scene.skyRepaint) {++fs::repaintCalls;')
    functions = functions.replace('if(!scene.skyRepaint || scene.skyDelta) {', 'if(!scene.skyRepaint || scene.skyDelta) {++fs::skyRepairCalls;')
    inc = WORK / 'include/presentation-functions.inc'
    inc.write_text(functions)
    for name in ('main.cpp', 'callback.asm', 'timing_prt.asm'):
        src = HERE / 'guest' / name
        if name == 'callback.asm':
            shutil.copyfile(ROOT / 'docs/tasks/RALLY-25/full-scene/callback.asm', src)
        elif name == 'timing_prt.asm':
            shutil.copyfile(ROOT / 'rally-game/src/timing_prt.asm', src)
        shutil.copyfile(src, WORK / 'src' / name)
    shutil.copyfile(HERE / 'guest/native.hpp', WORK / 'include/native.hpp')
    shutil.copyfile(HERE / 'bindings.hpp', WORK / 'include/bindings.hpp')
    make = '''NAME=probe
LDHAS_ARG_PROCESSING=0
LDHAS_EXIT_HANDLER=0
include /Agon/agondev/release/config/makefile.inc
CFLAGS += -I{game} -I{production}
CXXFLAGS += -std=c++17 -fno-exceptions -fno-rtti -Wall -Wextra -Werror -Wno-unused-function -Wno-unused-variable -Wno-misleading-indentation
'''.format(game=ROOT / 'rally-game/include', production=ROOT / 'rally-production/include')
    (WORK / 'Makefile').write_text(make)
    env = dict(os.environ, PATH='/Agon/agondev/release/bin:' + os.environ['PATH'])
    result = subprocess.run(['make', '-C', str(WORK)], env=env, check=True, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    (HERE / 'GUEST-BUILD-OUTPUT.txt').write_text(result.stdout)
    mapping = (WORK / 'bin/probe.map').read_text()
    sections = {}
    for name in ('init_array', 'ctors', 'dtors', 'fini_array'):
        match = re.search(r'^\.' + name + r'\s+0x[0-9a-f]+\s+(0x[0-9a-f]+)', mapping, re.M)
        assert match and int(match[1], 16) == 0, name
    # Every linked load/data/BSS section must fit in the application's RAM;
    # reserve a generous 64KiB stack below MOS's 0xB0000 upper boundary.
    for match in re.finditer(r'^\.(text|rodata|data|bss)\s+(0x[0-9a-f]+)\s+(0x[0-9a-f]+)', mapping, re.M):
        name, start, length = match[1], int(match[2], 16), int(match[3], 16)
        sections[name] = dict(start=start, bytes=length, end=start + length)
        assert 0x40000 <= start and start + length <= 0xA0000, (name, start, length)
    assert 'text' in sections and 'bss' in sections
    shutil.copyfile(WORK / 'bin/probe.bin', OUTPUT / 'probe.bin')
    shutil.copyfile(WORK / 'bin/probe.map', OUTPUT / 'probe.map')
    (OUTPUT / 'run.txt').write_bytes(b'load probe.bin\r\nrun .\r\n')
    asset_source = build_assets(source)
    protected = [source_path, ROOT / 'rally-game/include/hud.hpp', ROOT / 'rally-game/include/rules.hpp',
                 ROOT / 'rally-game/include/engine.hpp', ROOT / 'rally-game/include/crash.hpp',
                 ROOT / 'rally-game/include/routes_data.hpp', ROOT / 'rally-production/include/scenery.hpp',
                 ROOT / 'rally-production/include/scenery_data.hpp', ROOT / 'rally-production/include/road.hpp',
                 ROOT / 'rally-production/include/track.hpp']
    meta = dict(schema=1, actual_ez80_per_frame_presentation=True,
                producer='AgonDev C++17, actual maintained race presentation functions',
                native_module_shared_binary=True, diagnostic_title=False, attract_panel=False,
                race_phase='Race', panorama_bitmap=100, hud_pixels=[0, 23], sky_pixels=[24, 103],
                road_pixels=[104, 223], footer_pixels=[224, 239], warm_frames=2, frames=900, physics_ticks=3600,
                native_initial_player_station=3246800, native_initial_phase=6800,
                render_requests=902, generation_before_stop=4503,
                config_contract='16B R28F; u16schema1@4/u16frames900@6/u32modulebytes@8/u16flags0@12/u16reserved0@14',
                capture_contract='Optional capture.req 4B LE u16stage/u16frame. Stage0 completed main frame1..configured count; stage1 coverage rendered index0..271. After post-swap fence writes capture.ready then holds without display/VDP traffic for24000MOS units. Captures excluded from throughput.',
                retained_reply_capacity_bytes=100000, memory_sections=sections,
                reserved_stack_bytes_below_mos=65536,
                old_sources={str(p.relative_to(ROOT)):sha(p) for p in protected},
                extracted_functions_sha256=sha(inc), generated_asset_source_sha256=sha(asset_source),
                files={p.name:sha(p) for p in OUTPUT.iterdir() if p.is_file() and p.name != 'guest-build.json'})
    (OUTPUT / 'guest-build.json').write_text(json.dumps(meta, indent=2) + '\n')
    (HERE / 'GUEST-BUILD.json').write_text(json.dumps(meta, indent=2) + '\n')
    print(json.dumps(dict(output=str(OUTPUT), files=meta['files'], memory_sections=sections), indent=2))


if __name__ == '__main__':
    build()
