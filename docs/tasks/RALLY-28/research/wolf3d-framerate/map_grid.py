from pathlib import Path
import hashlib,json,struct
root=Path('/Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/research/wolf3d-framerate')
src=root/'.work/payload/app/level_00/state_medium.w3l'
b=src.read_bytes();assert b[:4]==b'W3L1' and b[-4:]==b'E3L1'
off=[struct.unpack_from('<H',b,26+2*i)[0] for i in range(7)]
tiles=b[off[6]:off[6]+4096];areas=b[off[4]:off[4]+4096];block=b[off[3]:off[3]+512]
assert len(tiles)==len(areas)==4096
cell=20;ox=65;oy=90;width=1410;height=1450
s=[f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}">',
'<rect width="100%" height="100%" fill="#ffffff"/>',
'<g font-family="DejaVu Sans,sans-serif" fill="#17202a">',
'<text x="65" y="28" font-size="22" font-weight="bold">Wolf3D E1L1 — tile coordinates (x, y)</text>',
'<text x="65" y="53" font-size="14">X increases right; Y increases downward. Zero-based cells 0–63. S = previous benchmark (29,57).</text>',
'<text x="65" y="73" font-size="13">Light = floor; gray = wall; amber = door; red × = blocking decoration; dark = outside map.</text>']
for y in range(64):
 for x in range(64):
  i=y*64+x;t=tiles[i]
  color='#e5ae42' if t&128 else '#48515c' if t else '#f4f1e8' if areas[i]!=255 else '#151c26'
  s.append(f'<rect x="{ox+x*cell}" y="{oy+y*cell}" width="20" height="20" fill="{color}"/>')
  if block[i//8]&(1<<(i%8)):
   px=ox+x*cell;py=oy+y*cell
   s.append(f'<path d="M{px+6},{py+6}l8,8m0,-8l-8,8" stroke="#b41f27" stroke-width="1.7"/>')
for n in range(65):
 c='#66717e' if n%8==0 else '#aeb5bd';w='1' if n%8==0 else '.45'
 s.append(f'<path d="M{ox+n*cell},{oy}v1280M{ox},{oy+n*cell}h1280" stroke="{c}" stroke-width="{w}"/>')
for n in range(64):
 s.append(f'<text x="{ox+n*cell+10}" y="{oy-7}" font-size="10" text-anchor="middle">{n}</text>')
 s.append(f'<text x="{ox-9}" y="{oy+n*cell+14}" font-size="11" text-anchor="end">{n}</text>')
 s.append(f'<text x="{ox+n*cell+10}" y="{oy+1298}" font-size="10" text-anchor="middle">{n}</text>')
 s.append(f'<text x="{ox+1289}" y="{oy+n*cell+14}" font-size="11">{n}</text>')
x=ox+29*cell+10;y=oy+57*cell+10
s.append(f'<circle cx="{x}" cy="{y}" r="8" fill="#1261bc"/><text x="{x}" y="{y+4}" text-anchor="middle" fill="white" font-size="11" font-weight="bold">S</text>')
s.append('<text x="65" y="1428" font-size="14">Choose a floor cell and report (x,y). Initial enemies and nonblocking decorations are omitted.</text></g></svg>')
(root/'E1L1-GRID.svg').write_text('\n'.join(s)+'\n')
(root/'E1L1-GRID.json').write_text(json.dumps(dict(source=str(src),source_sha256=hashlib.sha256(b).hexdigest(),dimensions=[64,64],coordinates='zero-based x right, y down',previous_benchmark=[29,57],tilemap_sha256=hashlib.sha256(tiles).hexdigest()),indent=2)+'\n')
print(root/'E1L1-GRID.svg')
