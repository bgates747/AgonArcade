"""Supplemental strict <=1px native outer-road edge check for road-only images.

The frozen centre/semantic metrics remain unchanged. This additionally measures
the actual kerb/road outline per row, preventing width errors from hiding within
regional percentage tolerances. No vehicle/scenery pixels belong in these inputs.
"""
from PIL import Image,ImageDraw
COLOURS={(85,85,85),(255,0,0),(255,255,0),(255,255,255)}

def compare(expected,actual):
    assert expected.size==actual.size==(320,240)
    results=[]
    for y in range(104,224):
        bounds=[]
        for image in [expected,actual]:
            xs=[x for x in range(320) if image.getpixel((x,y)) in COLOURS]
            bounds.append((xs[0],xs[-1]) if xs else None)
        e,a=bounds
        if e is None and a is None:error=0
        elif e is None or a is None:
            # One-column entry/exit at a clipped screen border can be a1px
            # outline shift. Any interior appearance/disappearance is a failure.
            visible=e or a;error=1 if visible in [(0,0),(319,319)] else None
        else:error=max(abs(e[0]-a[0]),abs(e[1]-a[1]))
        results.append({'row':y,'expected':e,'actual':a,'error':error,'pass':error is not None and error<=1})
    maximum=None if any(r['error'] is None for r in results) else max(r['error'] for r in results)
    return {'pass':all(r['pass'] for r in results),'max_edge_error_pixels':maximum,'failed_rows':[r for r in results if not r['pass']],'scope':__doc__}

def calibrate():
    def road(left,right):
        image=Image.new('RGB',(320,240),(0,170,0));ImageDraw.Draw(image).rectangle((left,104,right,223),fill=(85,85,85));return image
    e=road(20,300);missing=e.copy();ImageDraw.Draw(missing).line((0,160,319,160),fill=(0,170,0))
    tests={'identity':compare(e,e)['pass'],'one_pixel_translation':compare(e,road(21,301))['pass'],'two_pixel_translation_rejected':not compare(e,road(22,302))['pass'],'two_pixel_width_growth_rejected':not compare(e,road(18,302))['pass'],'missing_interior_row_rejected':not compare(e,missing)['pass'],'one_border_column_allowed':compare(road(320,350),road(319,350))['pass'],'two_border_columns_rejected':not compare(road(320,350),road(318,350))['pass']}
    assert all(tests.values()),tests;return tests

if __name__=='__main__':
    import json
    print(json.dumps(calibrate(),indent=2))
