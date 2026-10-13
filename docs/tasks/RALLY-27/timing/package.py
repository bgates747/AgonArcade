"""Portable guest fixture plus exact build/runtime provenance, no flashing."""
from pathlib import Path
import argparse,hashlib,json,zipfile
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[3]
if __name__=='__main__':
    a=argparse.ArgumentParser();a.add_argument('--game',type=Path,required=True);a.add_argument('--firmware',type=Path,required=True);a.add_argument('--output',type=Path,required=True);args=a.parse_args()
    assert not args.output.exists(),'Preserve earlier bundles'
    files={'guest/rally.bin':args.game/'rally.bin','guest/build.json':args.game/'build.json',
           'firmware/firmware.bin':args.firmware/'firmware-src/.pio/build/esp32dev/firmware.bin',
           'firmware/firmware.elf':args.firmware/'firmware-src/.pio/build/esp32dev/firmware.elf',
           'firmware/source.json':args.firmware/'source.json','README.md':HERE/'README.md'}
    files.update({'tools/'+p.name:p for p in HERE.glob('*.py')})
    firmware_source=args.firmware/'firmware-src'
    for name in ['video/agon_screen.h','video/vdu_sys.h','video/vdplet.h',
                 'video/vdplet_image.h','video/vdplet_runtime.h','platformio.ini',
                 '.pio/libdeps/esp32dev/vdp-gl/src/dispdrivers/vgabasecontroller.h']:
        files['firmware-source/'+name]=firmware_source/name
    build=json.loads((args.game/'build.json').read_text())
    for name,expected in build['inputs'].items():
        p=ROOT/name
        if hashlib.sha256(p.read_bytes()).hexdigest()!=expected:
            raise ValueError('Source changed since fixture build: '+name)
        files['source/'+name]=p
    hashes={n:hashlib.sha256(p.read_bytes()).hexdigest() for n,p in files.items()}
    with zipfile.ZipFile(args.output,'x',zipfile.ZIP_DEFLATED) as z:
        for n,p in files.items():z.write(p,n)
        z.writestr('manifest.json',json.dumps(hashes,indent=2)+'\n')
    print(args.output,hashlib.sha256(args.output.read_bytes()).hexdigest())
