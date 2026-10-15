"""Documentation-only enlarged conceptual road patterns; no VDP assets."""
from pathlib import Path
import struct,zlib,binascii,json,hashlib
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[4]
COLOURS={0:(0,0,0),2:(0,170,0),8:(85,85,85),9:(255,0,0),11:(255,255,0),15:(255,255,255)}
def colour(x,paint,finish=None):
    c=2
    if -106<=x<106:c=9 if paint else 15
    if -90<=x<90:c=8
    if -86<=x<-84 or 84<=x<86:c=11 if paint else 15
    if paint and -2<=x<2:c=11
    if finish is not None and -90<=x<90:c=15 if (int((x+90)*12/180)+finish)&1 else 0
    return c
def write(name,paint,finish=None,overlay=False):
    # Green margins contextualize the road; original lateral proportions retained.
    width,height=200,8
    row=b''.join(bytes(COLOURS[colour(-126+(i+.5)*252/width,paint,finish)]) for i in range(width))
    if overlay:
        row=b''.join(bytes(COLOURS[15 if (int(i*12/width)+finish)&1 else 0]) for i in range(width))
    raw=(b'\0'+row)*height
    def chunk(t,d):return struct.pack('>I',len(d))+t+d+struct.pack('>I',binascii.crc32(t+d)&0xffffffff)
    data=b'\x89PNG\r\n\x1a\n'+chunk(b'IHDR',struct.pack('>IIBBBBB',width,height,8,2,0,0,0))+chunk(b'IDAT',zlib.compress(raw))+chunk(b'IEND',b'')
    (HERE/'patterns'/name).write_bytes(data)
(HERE/'patterns').mkdir(exist_ok=True)
for paint in (False,True):
    label='painted' if paint else 'unpainted'
    write(label+'.png',paint)
    for phase in (0,1):write(label+'-finish-'+str(phase)+'.png',paint,phase)
for phase in (0,1):write('finish-'+str(phase)+'.png',False,phase,True)
sources=['rally-game/include/direct_road.hpp','rally-production/include/road.hpp','rally-production/include/lookup_road.hpp','rally-game/src/main.cpp','docs/tasks/RALLY-28/standard-vdp/candidates/projection.hpp','docs/tasks/RALLY-28/standard-vdp/candidates/buffered.hpp']
(HERE/'patterns/catalogue.json').write_text(json.dumps({'base_patterns':2,'finish_overlay_patterns':2,'flattened_cross_product':4,'flattened_cross_product_status':'possible representation choices, not four independently required base assets','preview_size':[200,8],'preview_palette':'illustrative standard logical colours, not an emulator screenshot','sources_sha256':{s:hashlib.sha256((ROOT/s).read_bytes()).hexdigest() for s in sources}},indent=2)+'\n')
