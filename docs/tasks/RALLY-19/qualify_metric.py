"""Adversarial qualification on the real native oracle corpus, not only toys."""
from pathlib import Path
import json
from PIL import Image
from scene_masks import game_image
from visual_metric import compare,calibrate,road_geometry
from fixtures import cases
TASK=Path(__file__).resolve().parent
results={'synthetic':calibrate(),'native':[]}
for root in sorted((TASK/'evidence/oracle').iterdir()):
    if not root.is_dir() or not (root/'verified.json').exists():continue
    image=game_image(root/'frame-000010.png');mask=Image.open(root/'semantic-mask.png').convert('L')
    labels=list(mask.get_flattened_data());checks=[]
    for label in sorted(set(labels)&{3,4,5,16,17,18,19,20,21,22}):
        bad=image.copy()
        for i,value in enumerate(labels):
            if value==label:bad.putpixel((i%320,i//320),(85,85,85))
        # Keep candidate mask unchanged deliberately: claimed presence cannot
        # conceal pixels missing from the actual image.
        result=compare(image,bad,mask,mask)
        assert not result['pass'],(root.name,label)
        checks.append(label)
    results['native'].append({'case':root.name,'erased_materials_or_cars_rejected':checks})
assert len(results['native'])==len(cases())
(TASK/'evidence/metric-adversarial.json').write_text(json.dumps(results,indent=2)+'\n')
print('All',len(cases()),'native cases reject erased visible cars/markings even with unchanged claimed masks.')
