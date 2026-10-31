"""Offline enlarged artwork comparisons; these are not game screenshots."""
from pathlib import Path
import base64,csv,json,struct,zlib
HERE=Path(__file__).resolve().parent

def png(w,h,rgb):
    def block(t,b):return struct.pack('>I',len(b))+t+b+struct.pack('>I',zlib.crc32(t+b))
    data=b''.join(b'\0'+rgb[y*w*3:(y+1)*w*3] for y in range(h))
    return b'\x89PNG\r\n\x1a\n'+block(b'IHDR',struct.pack('>IIBBBBB',w,h,8,2,0,0,0))+block(b'IDAT',zlib.compress(data))+block(b'IEND',b'')

def main():
    records=[{k:float(v) if k=='stock_rgba_error' else int(v) for k,v in r.items()} for r in csv.DictReader((HERE/'IMAGES.csv').open())]
    bykey={(r['source'],r['mirror'],r['q']):r for r in records}
    findings=json.loads((HERE/'FINDINGS.json').read_text())
    exact=(HERE/'.work/exact-images.bin').read_bytes();stock=(HERE/'.work/stock-images.bin').read_bytes()
    dest=HERE/'previews';dest.mkdir(exist_ok=True)
    cases=[('Distant front view',5,0,8),('Middle reflected view',8,1,40),('Near reflected view',9,1,125),('Large sign',120,0,74)]
    svg=['<svg xmlns="http://www.w3.org/2000/svg" width="990" height="1150" viewBox="0 0 990 1150">',
         '<rect width="990" height="1150" fill="#f4f4f4"/>',
         '<g font-family="sans-serif" fill="#222"><text x="20" y="25" font-size="18">Offline prepared-image alternatives (enlarged 2x)</text>',
         '<text x="20" y="47" font-size="13">Same integer world anchor. Host stock-generation model; no runtime policy or visual acceptance.</text>']
    for row,(label,source,mirror,q) in enumerate(cases):
        family=2*((source-5)%5)+mirror if source<120 else 10+source-120
        for col,policy in enumerate((None,'one-pixel-stock-model','two-pixel-stock-model')):
            chosen=q if policy is None else findings['policies'][policy]['q_maps'][str(family)][str(q)]
            r=bykey[source,mirror,chosen];blob=exact if policy is None else stock
            data=blob[r['offset']:r['offset']+r['bytes']]
            w,h=128,96;rgb=bytearray()
            for y in range(h):
                for x in range(w):
                    sx=x-64+r['anchor_x'];sy=y-80+r['anchor_y'];v=data[sy*r['width']+sx] if 0<=sx<r['width'] and 0<=sy<r['height'] else 0
                    if v>>6:rgb+=bytes(((v&3)*85,((v>>2)&3)*85,((v>>4)&3)*85))
                    else:
                        grey=56 if ((x//4+y//4)&1) else 72;rgb+=bytes((grey,grey,grey))
            b=png(w,h,rgb);(dest/f'{row}-{col}.png').write_bytes(b)
            x=20+col*325;y=93+row*260
            title='Requested' if policy is None else ('One-pixel bound' if col==1 else 'Two-pixel bound')
            svg+= [f'<text x="{x}" y="{y-23}" font-size="14">{label if col==0 else title}</text>',
                   f'<text x="{x}" y="{y-5}" font-size="12">{title}: q {q} -&gt; {chosen}, {r["width"]} x {r["height"]}</text>',
                   f'<image x="{x}" y="{y}" width="256" height="192" style="image-rendering:pixelated" href="data:image/png;base64,{base64.b64encode(b).decode()}"/>']
    svg+=['</g></svg>'];(dest/'CONTACT.svg').write_text('\n'.join(svg)+'\n')
    print('Saved four offline requested/one-/two-pixel image comparisons.')

if __name__=='__main__':main()
