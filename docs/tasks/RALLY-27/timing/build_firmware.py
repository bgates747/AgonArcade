"""Task-owned diagnostic export; never modify donor sources or flash hardware."""
from pathlib import Path
import argparse, hashlib, json, shutil, subprocess
HERE=Path(__file__).resolve().parent

def patch(path, old, new):
    s=path.read_text();assert s.count(old)==1,(path,old);path.write_text(s.replace(old,new))

def prepare(donor,out):
    assert not out.exists(), 'Choose a new export directory; preserve previous builds'
    shutil.copytree(donor,out,ignore=shutil.ignore_patterns('build','__pycache__'))
    # Includes dependency sources, but not the donor's compiled objects.
    screen=out/'video/agon_screen.h'
    patch(screen,'void switchBuffer() {','''// Task diagnostic only: immediate double-buffer handoff, no vblank wait.
bool rally_unpaced = false;
uint32_t rally_completed = 0;
void switchBuffer() {
    if (rally_unpaced && isDoubleBuffered()) {
        canvas->waitCompletion(false);
        _VGAController->rallySwapBuffers();
        ++rally_completed;
        return;
    }''')
    gl=out/'.pio/libdeps/esp32dev/vdp-gl/src/dispdrivers'
    patch(gl/'vgabasecontroller.h','public:',
          'public:\n  bool rallySkipVblank = false;\n  void rallySwapBuffers() { rallySkipVblank=true; swapBuffers(); rallySkipVblank=false; }')
    # Native Fab exports carry an extra host-side wait in this method.
    # Apply only in the copied graphics tree, preserving normal swap behavior.
    cpp=gl/'vgabasecontroller.cpp'
    if '  waitVblank();' in cpp.read_text():
        patch(cpp,'  waitVblank();','  if (!rallySkipVblank) waitVblank();')
    sys=out/'video/vdu_sys.h' 
    # Private task protocol R27T v1, VDU 23,0,DA,op,token. 10-byte payload.
    patch(sys,'case VDP_GP:', '''case 0xDA: {
            auto op=readByte_t(); auto token=readByte_t();
            if(op<0 || token<0) break;
            static uint64_t begin_us=0;
            uint32_t value=0;
            if(op==1) { // enable and fence initialization, report protocol v1
                canvas->waitCompletion(false);
                rally_unpaced=true; rally_completed=0; value=0x010027;
            } else if(op==2) { // ordered elapsed-time marker
                canvas->waitCompletion(false); begin_us=esp_timer_get_time();
            } else if(op==3) {
                canvas->waitCompletion(false);
                value=uint32_t(esp_timer_get_time()-begin_us);
            } else if(op==4) {
                canvas->waitCompletion(false); value=rally_completed;
            } else if(op==5) {
                canvas->waitCompletion(false); rally_completed=0;
            } else if(op==0) {
                canvas->waitCompletion(false); rally_unpaced=false;
            } else break;
            uint8_t reply[10]={'R','2','7','T',uint8_t(op),uint8_t(token),
                uint8_t(value),uint8_t(value>>8),uint8_t(value>>16),uint8_t(value>>24)};
            send_packet(PACKET_KEYCODE,sizeof(reply),reply);
        } break;
        case VDP_GP:''')
    files=[screen,sys,out/'platformio.ini',gl/'vgabasecontroller.h',cpp]
    (out.parent/'source.json').write_text(json.dumps({'schema':1,'donor':str(donor),
        'builder_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
        'files':{str(p.relative_to(out)):hashlib.sha256(p.read_bytes()).hexdigest() for p in files}},indent=2)+'\n')

if __name__=='__main__':
    a=argparse.ArgumentParser();a.add_argument('--donor',type=Path,required=True);a.add_argument('--output',type=Path,required=True);a.add_argument('--prepare-only',action='store_true');args=a.parse_args()
    prepare(args.donor,args.output)
    if not args.prepare_only:
        subprocess.run([str(Path(__import__('sys').executable)),'-m','platformio','run','-d',str(args.output),'-j','4'],check=True)
