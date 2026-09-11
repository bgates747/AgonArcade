"""Reproducible research calculations and diagrams; not a game implementation.
Run from AgonArcade: .venv/bin/python docs/research/pole-position/calculations.py
"""
from pathlib import Path
import csv
import math

ROOT = Path(__file__).resolve().parent
OUT = ROOT / 'figures'
OUT.mkdir(exist_ok=True)
# Illustrative design parameters, not measurements from the original game's ROMs.
FOCAL = 160
HEIGHT = 100
HALF_WIDTH = 90
HORIZON = 96
BOTTOM = 223
BAUD = 1_152_000
WIRE_BYTES = BAUD / 10  # 8N1 framing

rows = []
for y in range(HORIZON + 1, BOTTOM + 1):
    q = y - HORIZON
    z = FOCAL * HEIGHT / q
    scale = FOCAL / z
    half = HALF_WIDTH * scale
    shift = -25 * scale
    rows.append((y, q, z, scale, half, 160 - half, 160 + half, shift))
assert all(rows[i][2] > rows[i+1][2] for i in range(len(rows)-1))
assert all(rows[i][4] < rows[i+1][4] for i in range(len(rows)-1))
assert all(math.isclose(FOCAL*HEIGHT/r[2], r[1]) for r in rows)
assert math.isclose(rows[-1][4], 114.3)
with (ROOT/'projection.csv').open('w', newline='') as f:
    w=csv.writer(f, lineterminator="\n")
    w.writerow(['screen_y','rows_below_horizon','depth_world_units','pixels_per_world_unit',
                'road_half_width_px','left_edge_px','right_edge_px','camera_right_25_shift_px'])
    w.writerows(rows)

# Count every command byte, using 3-byte GCOL and 6-byte PLOT.
# 27-byte quad: GCOL, MOVE UL, MOVE UR, TRI LL, TRI LR.
# 39-byte quad: GCOL and two ordinary three-point triangle helpers.
cases = [
    ('128 rows, 4 spans each',128*4*15),
    ('64 bands, 4 rectangles each',64*4*15),
    ('32 bands, 4 rectangles each',32*4*15),
    ('24 bands, 4 packed quads each',24*4*27),
    ('32 bands, 4 packed quads each',32*4*27),
    ('24 bands, 4 helper quads each',24*4*39),
    ('320x240 RGBA2222 upload',320*240),
    ('320x128 RGBA2222 upload',320*128),
]
with (ROOT/'wire-budget.csv').open('w',newline='') as f:
    w=csv.writer(f, lineterminator="\n")
    w.writerow(['case','road_or_image_bytes','example_other_bytes','total_bytes',
                'wire_min_ms','wire_only_max_fps','utilization_at_25fps','utilization_at_30fps'])
    for name,n in cases:
        overhead=300 if 'upload' not in name else 0
        total=n+overhead
        w.writerow([name,n,overhead,total,1000*total/WIRE_BYTES,WIRE_BYTES/total,
                    total*25/WIRE_BYTES,total*30/WIRE_BYTES])

# Analytical figure: equal world distances versus equal screen distances.
svg=['<svg xmlns="http://www.w3.org/2000/svg" width="960" height="500" viewBox="0 0 960 500">',
     '<rect width="960" height="500" fill="white"/>',
     '<style>text{font-family:Arial,sans-serif;fill:#222;font-size:15px}.title{font-size:21px;font-weight:bold}.small{font-size:13px}</style>',
     '<text x="30" y="34" class="title">Flat-road perspective: why distance needs a reciprocal table</text>',
     '<text x="30" y="63">Original analytical illustration; these parameters are not extracted from Pole Position.</text>']
# A magnified 320x240 view, drawn as a geometry diagram rather than a game scene.
ox,oy,m=35,80,1.55
sx=lambda x:ox+x*m
sy=lambda y:oy+y*m
svg += [f'<rect x="{sx(0)}" y="{sy(0)}" width="{320*m}" height="{240*m}" fill="#fafafa" stroke="#bbb"/>',
        f'<path d="M{sx(160)},{sy(96)} L{sx(45.7)},{sy(223)} L{sx(274.3)},{sy(223)} Z" fill="#dedede" stroke="#333"/>',
        f'<line x1="{sx(0)}" y1="{sy(96)}" x2="{sx(320)}" y2="{sy(96)}" stroke="#777" stroke-dasharray="5 5"/>',
        f'<text x="{sx(5)}" y="{sy(90)}" class="small">Horizon y = 96</text>']
for z in [150,200,250,300,400,600,1000,2000]:
    q=FOCAL*HEIGHT/z; y=HORIZON+q; half=HALF_WIDTH*q/HEIGHT
    svg.append(f'<line x1="{sx(160-half)}" y1="{sy(y)}" x2="{sx(160+half)}" y2="{sy(y)}" stroke="#28728a"/>')
    if z in [150,250,400,1000]:
        svg.append(f'<text x="{sx(163+half)}" y="{sy(y)+4}" class="small">z={z}</text>')
svg += ['<text x="570" y="128" class="title">Flat-ground equations</text>',
        '<text x="570" y="170">q = screen_y − horizon</text>',
        '<text x="570" y="204">depth z = focal_length × height / q</text>',
        '<text x="570" y="238">scale = q / height</text>',
        '<text x="570" y="272">half_width = road_half_width × scale</text>',
        '<text x="570" y="326">Equal steps in world distance compress</text>',
        '<text x="570" y="350">toward the horizon. Equal screen steps</text>',
        '<text x="570" y="374">do not represent equal travel distances.</text>',
        '<text x="30" y="478" class="small">f=160 px; camera height=100 units; road half-width=90 units. Supporting values: projection.csv.</text>',
        '</svg>']
(OUT/'flat-projection.svg').write_text('\n'.join(svg)+'\n')
print('Validated 127 projection rows; wrote projection.csv, wire-budget.csv, and figures/flat-projection.svg.')
