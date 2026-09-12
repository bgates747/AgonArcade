"""Reference semantic support from frozen scene geometry and original alpha assets.

No candidate score may use the oracle mask as its own geometry: candidate masks
must be produced independently from its draw output. IDs survive occlusion.
"""
from pathlib import Path
import csv,math,json
from PIL import Image,ImageDraw
TASK=Path(__file__).resolve().parent;REPO=TASK.parents[2]
def game_image(path):
    image=Image.open(path).convert('RGB')
    if image.size==(640,480):image=image.resize((320,240),Image.Resampling.NEAREST)
    if image.size!=(320,240):raise ValueError('Unexpected scanout size')
    return image

def masks(scene_path,image_path):
    rows=list(csv.reader(Path(scene_path).read_text().splitlines()))
    header=list(map(int,rows[0]));cars=[list(map(int,r[1:])) for r in rows if r[0]=='C']
    rgb=game_image(image_path);label=Image.new('L',(320,240),1)
    # Material regions are selected from native road pixels below RoadTop;
    # exact object alpha later overwrites car pixels, excluding them from road.
    # The native fixed palette is read here, not inferred from an RGB gradient.
    for y in range(104,224):
        for x in range(320):
            c=rgb.getpixel((x,y))
            label.putpixel((x,y),2 if c==(85,85,85) else 1)
    # Road marking roles have shared colours. Classify by distance to centreline
    # interpolated between emitted boundaries, keeping observed coloured pixels.
    roads=[list(map(int,r[1:])) for r in rows if r[0]=='R']
    index=0
    for y in range(104,224):
        while index+1<len(roads)-1 and y>roads[index+1][0]:index+=1
        a,b=roads[index:index+2];t=(y-a[0])/(b[0]-a[0]);center=(a[1]+(b[1]-a[1])*t)/256
        q=y-96
        for x in range(320):
            c=rgb.getpixel((x,y));world=abs(x-center)*50/q
            if c not in ((255,255,255),(255,255,0),(255,0,0)):continue
            kind=5 if world<8 else 4 if world<90 else 3
            label.putpixel((x,y),kind)
    # Match stock startup's integer nearest-neighbour enlargement, then stock
    # affine inverse sampling/truncation. Opaque labels overwrite far to near.
    paths=[REPO/'rally/assets/car'/f'car-{i:02d}.png' for i in range(5)]
    sprites=[Image.open(p).convert('RGBA') for p in paths]
    def car(bitmap,scale,mirrored,x,y,translation,ident):
        sprite=sprites[bitmap%5];factor=scale/256
        # Original transformed corners use width/height (not width-1).
        lo=int(-factor if mirrored else 0);hi=int(101*factor if mirrored else 102*factor)
        for ly in range(0,int(77*factor)):
            yy=y+ly
            if yy<0 or yy>=224:continue
            sy=ly/factor
            for lx in range(lo,hi):
                xx=x+lx
                if xx<0 or xx>=320:continue
                sx=(101-lx/factor) if mirrored else lx/factor
                if not (0<=sx<102 and 0<=sy<77):continue
                if sprite.getpixel((int(sx)*64//102,int(sy)*48//77))[3]:label.putpixel((xx,yy),ident)
    for bitmap,scale,mirror,x,y,translation in cars:car(bitmap,scale,mirror,x,y,translation,16+bitmap//5-1)
    car(header[5],256,header[6],header[7],154,101*256 if header[6] else 0,22)
    ImageDraw.Draw(label).rectangle((0,224,319,239),fill=0)
    return label
if __name__=='__main__':
    from visual_metric import compare,calibrate
    summary={'calibration':calibrate(),'scenes':[],'mask_scope':'Reference alpha/material support; boundary pixels use documented one-pixel tolerance. Candidate masks must be independent.'}
    for root in sorted((TASK/'evidence/oracle').iterdir()):
        if not root.is_dir() or not (root/'verified.json').exists():continue
        mask=masks(root/'guest-scene.csv',root/'frame-000010.png');mask.save(root/'semantic-mask.png')
        image=game_image(root/'frame-000010.png')
        check=compare(image,image,mask,mask);assert check['pass']
        summary['scenes'].append({'case':root.name,'regions':check['regions']})
    (TASK/'evidence/metric-calibration.json').write_text(json.dumps(summary,indent=2)+'\n')
    print('Metric calibrated; masks for',len(summary['scenes']),'scenes')
