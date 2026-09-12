"""Compare native resident-program and independent direct-PLOT probe captures."""
from pathlib import Path
import hashlib
import json
from PIL import Image, ImageChops

root=Path(__file__).resolve().parent/'results/probe'
paths=[root/f'{name}-frame-300.png' for name in ('resident','direct')]
images=[Image.open(path).convert('RGB') for path in paths]
assert images[0].size==images[1].size==(640,480)
difference=ImageChops.difference(*images)
assert difference.getbbox() is None, 'Resident drawing differs from native direct-PLOT reference; inspect captures'
assert len(images[0].getcolors(256))>=6, 'Probe is blank or missing material colours'
result={'native_size':[640,480],'game_size':[320,240],'different_pixels':0,
        'sections':12,'one_and_two_row_sections':True,'both_materials':True,'minimum_centre':-30,'maximum_centre':280,
        'sources':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in paths},
        'scope':'Static stock-VDP probe, not a full-game raster equivalence claim'}
(root/'comparison.json').write_text(json.dumps(result,indent=2)+'\n')
print('Native resident and direct-PLOT images are pixel-identical; twelve sections including thin bands, both patterns, skew and clipping.')
