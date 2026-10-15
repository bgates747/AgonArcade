"""Generate resident road assets and per-scanline plotting commands, no game edits."""
from pathlib import Path
import json,struct,hashlib
HERE=Path(__file__).resolve().parent
P=55000;DRAW=55001;RUN=55002;BITMAP=55100;MATRIX=55200
word=lambda x:struct.pack('<H',x&65535)
prefix=lambda i,op:bytes([23,0,160])+word(i)+bytes([op])
BASE_WIDTH=32
WIDTH=BASE_WIDTH+3
# RGB2222, opaque. Thin markings quantized to at least one source pixel.
colours={8:0xd5,9:0xc3,11:0xcf,15:0xff}
assets=[]
for painted in (False,True):
 pixels=[9 if painted else 15]*WIDTH
 for i in range(3,32):pixels[i]=8
 for i in (4,30):pixels[i]=11 if painted else 15
 if painted:pixels[17]=11
 assets.append(bytes(colours[c] for c in pixels))
setup=bytearray()
def upload(i,b):setup.extend(prefix(i,2)+prefix(i,0)+word(len(b))+b)
for i,b in enumerate(assets):
 upload(BITMAP+i,b)
 setup.extend(bytes([23,27,32])+word(BITMAP+i)+bytes([23,27,33])+word(WIDTH)+word(1)+bytes([1]))
upload(P,bytes(720))
draw=bytearray();run=bytearray();rows=[]
for i,y in enumerate(range(104,224)):
 half=(y-96)*106//50;scale=2*half/BASE_WIDTH
 # Keep source-pixel scale; centre the symmetric odd-width canvas at pixel17.
 # Direct full matrix operation11, signed16 Q6.
 matrix=[round(scale*64),0,-round(WIDTH*scale*32),0,64,0]
 setup.extend(prefix(MATRIX+i,32)+bytes([0])+prefix(MATRIX+i,32)+bytes([11,0xc6])+b''.join(word(v) for v in matrix))
 start=len(draw)
 draw.extend(bytes([23,27,32])+word(BITMAP)+bytes([23,0,150,1])+word(MATRIX+i)+bytes([25,237])+word(160)+word(y))
 for dest,src in ((start+3,i*6),(start+13,i*6+2),(start+9,i*6+4)):
  run.extend(prefix(DRAW,5)+bytes([0xe2])+word(dest)+word(2)+word(P)+word(src))
 rows.append({'y':y,'half_width':half,'matrix_id':MATRIX+i})
# CALL the patched plots, then reset transform, flush and GP fence E0.
run.extend(prefix(DRAW,1)+bytes([23,0,150,1,255,255,23,0,202,23,0,128,224]))
upload(DRAW,draw);upload(RUN,run)
header='#pragma once\n#include <stdint.h>\n'
for name,data in [('Setup',setup)]:header+='static const uint8_t '+name+'[]={'+','.join(map(str,data))+'};\n'
(HERE/'src/generated.hpp').write_text(header)
cases=[]
for phase in (0,4000):
 bands=[];prev=None
 for y in range(104,224):
  paint=y>=116 and ((800000//(y-96)+phase)%8000)<4000
  if paint!=prev:bands.append({'top':y,'painted':paint});prev=paint
 for i,b in enumerate(bands):b['bottom']=bands[i+1]['top']-1 if i+1<len(bands) else 223
 cases.append({'phase':phase,'bands':bands})
(HERE/'DESIGN.json').write_text(json.dumps({'source_width':WIDTH,'source_height':1,'scale_reference_width':BASE_WIDTH,'kerb_source_pixels_each_side':3,'shoulder_source_pixels':1,'centre_dash_source_pixels':1,'bitmap_rgba2222_hex':[b.hex() for b in assets],'parameter_bytes':720,'patch_header_bytes':11,'call_bytes':6,'per_view_road_wire_bytes':737,'completion_fence_bytes':7,'resident_draw_bytes':len(draw),'resident_run_bytes':len(run),'setup_command_bytes':len(setup),'rows':rows,'stripe_cases':cases,'notes':'frame-independent static scales, one row per scanline; source markings quantized'},indent=2)+'\n')
print('setup',len(setup),'draw',len(draw),'run',len(run))
