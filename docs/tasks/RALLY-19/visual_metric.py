"""Regional semantic/pixel metric; masks must come from each renderer's own geometry.

Frozen before candidate development. Labels: 1 background, 2 asphalt, 3 kerb,
4 shoulder, 5 centreline, 16..21 opponents, 22 player; 0 excludes HUD/outside.
A whole-screen score is deliberately not an acceptance criterion.
"""
from PIL import Image
import json
LABELS={1:'background',2:'asphalt',3:'kerb',4:'shoulder',5:'centreline',**{16+i:f'car-{i}' for i in range(6)},22:'player'}
def pixels(image):
    if image.size!=(320,240):raise ValueError('Metric operates on game pixels, 320x240')
    return list(image.get_flattened_data())
def compare(expected,actual,expected_mask,actual_mask):
    e,a=pixels(expected.convert('RGB')),pixels(actual.convert('RGB'))
    em,am=pixels(expected_mask.convert('L')),pixels(actual_mask.convert('L'))
    if set(em+am)-set(LABELS)-{0}:raise ValueError('Unknown semantic label')
    result={};passed=True
    for label,name in LABELS.items():
        support=[i for i,(x,y) in enumerate(zip(em,am)) if x==label or y==label]
        ec=em.count(label);ac=am.count(label)
        if not support:continue
        exact=good=0
        for i in support:
            if em[i]==am[i]==label and e[i]==a[i]:exact+=1;good+=1;continue
            # Symmetric radius-one same-object/color check. No cross-object
            # matching, no credit from unchanged empty sky around a car.
            def near(source,mask,target,color):
                x,y=target%320,target//320
                return any(mask[yy*320+xx]==label and source[yy*320+xx]==color
                    for yy in range(max(0,y-1),min(240,y+2))
                    for xx in range(max(0,x-1),min(320,x+2)))
            if (em[i]!=label or near(a,am,i,e[i])) and (am[i]!=label or near(e,em,i,a[i])):good+=1
        fraction=good/len(support)
        ok=bool(ec and ac) and fraction>=.95
        result[name]={'expected_pixels':ec,'actual_pixels':ac,'union_pixels':len(support),'exact_fraction':exact/len(support),'one_pixel_fraction':fraction,'pass':ok}
        passed &= ok
    return {'pass':bool(passed),'regions':result,'metric':'symmetric same-semantic-label RGB agreement within one game pixel; >=95% per region; nonzero support on both sides'}

def road_geometry(expected_rows,actual_rows):
    def validate(rows):
        if len(rows)<2 or rows[0][0]!=104 or rows[-1][0]!=224:
            raise ValueError('Missing road endpoint')
        if any(b[0]<=a[0] for a,b in zip(rows,rows[1:])):raise ValueError('Unordered road boundaries')
    validate(expected_rows);validate(actual_rows)
    def at(rows,y):
        for a,b in zip(rows,rows[1:]):
            if a[0]<=y<=b[0]:return (a[1]+(b[1]-a[1])*(y-a[0])/(b[0]-a[0]))/256
        raise ValueError('Road has a gap')
    # Piecewise-linear difference extrema occur at the union of breakpoints.
    positions=sorted({p[0] for p in expected_rows+actual_rows})
    error=max(abs(at(expected_rows,y)-at(actual_rows,y)) for y in positions)
    return {'max_centerline_error_pixels':error,'pass':error<=1.0}

def calibrate():
    from PIL import ImageDraw,ImageChops
    image=Image.new('RGB',(320,240),(0,85,255));mask=Image.new('L',image.size,1)
    d=ImageDraw.Draw(image);m=ImageDraw.Draw(mask)
    for box,color,label in [((20,104,300,223),(85,85,85),2),((25,110,30,215),(255,255,255),4),((160,115,162,215),(255,255,0),5),((100,160,120,180),(255,0,0),22),((180,130,188,138),(0,255,255),16)]:d.rectangle(box,fill=color);m.rectangle(box,fill=label)
    tests={'identity':compare(image,image,mask,mask)['pass'],
           'one_pixel_geometry':road_geometry([[104,40960],[224,40960]],[[104,41216],[224,41216]])['pass'],
           'two_pixel_geometry_rejected':not road_geometry([[104,40960],[224,40960]],[[104,41472],[224,41472]])['pass']}
    shifted=ImageChops.offset(image,1,0);shiftmask=ImageChops.offset(mask,1,0)
    tests['one_pixel_translation']=compare(image,shifted,mask,shiftmask)['pass']
    for name,label in [('missing_player',22),('missing_far_car',16),('missing_shoulder',4),('missing_centreline',5)]:
        bad=image.copy();bm=mask.copy()
        for i,value in enumerate(pixels(mask)):
            if value==label:bad.putpixel((i%320,i//320),(85,85,85));bm.putpixel((i%320,i//320),2)
        tests[name]=not compare(image,bad,mask,bm)['pass']
    bad=image.copy();ImageDraw.Draw(bad).rectangle((100,160,120,180),fill=(0,255,0))
    tests['wrong_player_livery']=not compare(image,bad,mask,mask)['pass']
    # Opaque cars overlap: reversing order changes both colour and ownership.
    overlap=image.copy();om=mask.copy()
    ImageDraw.Draw(overlap).rectangle((110,160,130,180),fill=(0,255,255))
    ImageDraw.Draw(om).rectangle((110,160,130,180),fill=16)
    reversed_image=overlap.copy();rm=om.copy()
    ImageDraw.Draw(reversed_image).rectangle((100,160,120,180),fill=(255,0,0))
    ImageDraw.Draw(rm).rectangle((100,160,120,180),fill=22)
    tests['reversed_occlusion']=not compare(overlap,reversed_image,om,rm)['pass']
    assert all(tests.values()),tests
    return tests
if __name__=='__main__':print(json.dumps(calibrate(),indent=2))
