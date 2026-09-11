"""Original pixel art, encoded as RGBA2222 for the stock Agon VDP."""
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
COLORS={'.':0,'w':255,'c':252,'b':240,'g':204,'y':207,'o':199,'r':195,'p':243}
ship=[
'.....cc.............',
'....ccwcc...........',
'...ccwwwwwc.........',
'ccccwwwwwwwwcccc....',
'wwwwwwwwwwwwwwwwwwww',
'ccccwwwwwwwwcccc....',
'...ccwwwwwc.........',
'....ccwcc...........',
'.....cc.............',
]
lander=['...gg....gg...','..gggg..gggg..','.ggwwggggwwgg.','gggggggggggggg','..gggggggggg..','...gggggggg...','..gg..gg..gg..','.gg........gg.']
mutant=['p..........p','.pp......pp.','..pprrrrpp..','...rwwwwr...','..rrrrrrrr..','.rrr.pp.rrr.','pp........pp']
human=['..yy..','..yy..','...y..','.yyyy.','y.yy.y','..yy..','..yy..','.y..y.','y....y']
flame=['....ooy','ooyywww','....ooy']
images=[ship,[s[::-1] for s in ship],lander,mutant,human,['c'*18],['.r.','rwr','.r.'],flame,[s[::-1] for s in flame]]
for c in ['c','y','o','p']:images.append([c*2]*2)
lines=['#pragma once','#include <stdint.h>','namespace assets {','struct Bitmap {int w,h;const uint8_t* data;};']
for i,rows in enumerate(images):
 w=max(map(len,rows));values=[COLORS[c] for r in rows for c in r.ljust(w,'.')]
 lines.append(f'const uint8_t image{i}[]={{'+','.join(map(str,values))+'};')
lines.append('const Bitmap bitmaps[]={'+','.join('{%d,%d,image%d}'%(max(map(len,r)),len(r),i) for i,r in enumerate(images))+'};\n}')
(ROOT/'include/assets.hpp').write_text('\n'.join(lines)+'\n')
print(f'Generated {len(images)} original sprite bitmaps')
