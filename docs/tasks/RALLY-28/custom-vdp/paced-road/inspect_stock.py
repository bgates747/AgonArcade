"""Inspect pinned firmware and host-check its actual path/raster functions."""
from pathlib import Path
import hashlib
import json
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[4]
SDK = ROOT.parent/'agon-vdplet'
FW = SDK/'build/firmware/firmware-src'
GL = FW/'.pio/libdeps/esp32dev/vdp-gl/src'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()


def function(text, signature):
    start = text.index(signature)
    brace = text.index('{', start)
    depth = 1
    end = brace+1
    while depth:
        depth += (text[end] == '{')-(text[end] == '}')
        end += 1
    return text[start:end]+'\n'


def inspect():
    control = json.loads((HERE/'CONTROL.json').read_text())
    assert sha(FW/'.pio/build/esp32dev/firmware.bin') == control['immutable_files']['control/fixture/vdp_rally.bin']
    source_receipt = json.loads((SDK/'build/firmware/firmware-source.json').read_text())
    assert source_receipt['vdp_pin'] == '1056ee38ec1cc68ed327bd32ee47d04b1c30597c'
    assert source_receipt['graphics_pin'] == 'ac2dd5986daf496c43ae8e7fe41836274aec54a0'
    graphics = FW/'video/context/graphics.h'
    upstream = subprocess.check_output(['git','-C',str(SDK/'build/firmware/upstream.git'),
                                       'show',source_receipt['vdp_pin']+':video/context/graphics.h'])
    assert upstream == graphics.read_bytes(), 'Graphics code differs from pinned stock source'
    sources = [graphics, FW/'video/vdu.h', FW/'video/vdu_buffered.h',
               FW/'video/agon_screen.h', GL/'canvas.cpp', GL/'displaycontroller.cpp']
    work = HERE/'.work/stock-path'
    work.mkdir(parents=True,exist_ok=True)
    functions = ''.join(function(graphics.read_text(),signature) for signature in
        ('void Context::pushPoint(Point p)', 'void Context::plotTriangle()',
         'void Context::plotParallelogram()', 'void Context::plotPath(uint8_t mode, uint8_t lastMode)',
         'void Context::plotPending(int16_t peeked)'))
    functions += function((GL/'displaycontroller.cpp').read_text(),
                          'void IRAM_ATTR BitmappedDisplayController::fillPath(')
    (work/'stock_functions.inc').write_text(functions)
    reports = {}
    for mode,flags in [('ordinary',[]),('sanitized',['-fsanitize=address,undefined','-fno-omit-frame-pointer'])]:
        exe=work/mode
        subprocess.run(['c++','-std=gnu++17','-O1',*flags,'-I'+str(work),
                        str(HERE/'path_probe.cpp'),'-o',str(exe)],check=True)
        reports[mode]=json.loads(subprocess.check_output([str(exe)],text=True))
    receipt=dict(schema=1,firmware_sha256=sha(FW/'.pio/build/esp32dev/firmware.bin'),
        stock_graphics_byte_identical=True, vdp_pin=source_receipt['vdp_pin'],graphics_pin=source_receipt['graphics_pin'],
        files={str(p):sha(p) for p in sources}, extracted_functions_sha256=sha(work/'stock_functions.inc'),
        probes=reports, emulator_launched=False, firmware_modified=False,
        disposition='Use stock filled path PLOT221 for a four-corner tapered band; PLOT117 is a three-corner parallelogram',
        counts=dict(current_vdu_bytes_per_material=27,proposed_vdu_bytes_per_material=27,
                    current_fill_path_calls_per_material=2,proposed_fill_path_calls_per_material=1),
        caveat='Host probe executes extracted point-stack/path/raster functions with stubs; no firmware integration, target speed or visual acceptance claimed')
    (HERE/'STOCK-PATH.json').write_text(json.dumps(receipt,indent=2)+'\n')
    print(json.dumps(receipt,indent=2))


if __name__=='__main__':
    inspect()
