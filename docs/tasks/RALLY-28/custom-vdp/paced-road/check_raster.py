"""Sample actual stock scanline raster coverage and material overdraw on host."""
from pathlib import Path
import json
import struct
import subprocess
from qualify_candidates import HERE, decode


def check():
    work=HERE/'.work/stock-path'
    assert (work/'stock_functions.inc').exists(),'Run inspect_stock.py first'
    scaffold=(HERE/'path_probe.cpp').read_text().split('int main(){')[0]
    scaffold=scaffold.replace('#include <algorithm>','#include <algorithm>\n#include <array>\n#include <iostream>')
    scaffold=scaffold.replace('struct RGB888 {};','struct RGB888 {uint8_t value;};')
    scaffold=scaffold.replace('std::set<std::pair<int,int>> pixels;',
        'std::array<uint8_t,320*240> pixels;\n'
        '    std::array<uint16_t,320*240> coverage{};\n'
        '    uint32_t writes=0,overdraw=0;\n'
        '    BitmappedDisplayController(){pixels.fill(255);state.absClippingRect=Rect(0,24,319,223);}')
    scaffold=scaffold.replace('void fillRow(int y,int x1,int x2,const RGB888&){\n        for(int x=x1;x<=x2;++x) pixels.emplace(x,y);',
        'void fillRow(int y,int x1,int x2,const RGB888& colour){\n'
        '        assert(y>=24&&y<=223&&x1>=0&&x2<320);\n'
        '        for(int x=x1;x<=x2;++x){int at=y*320+x;overdraw+=coverage[at]>0;++coverage[at];++writes;pixels[at]=colour.value;}')
    # Drop the unrelated sampled probe helpers; retain original stock functions.
    scaffold=scaffold[:scaffold.index('static auto raster(')]
    main=r'''
static int32_t number(){int32_t x;std::cin.read((char*)&x,4);assert(std::cin);return x;}
static void rectangle(BitmappedDisplayController& d,const std::array<int,5>& r){
    for(int y=std::max(24,r[2]);y<=std::min(223,r[4]);++y)
        for(int x=std::max(0,r[1]);x<=std::min(319,r[3]);++x)d.pixels[y*320+x]=r[0];
}
int main(){
    int n=number();
    for(int sample=0;sample<n;++sample){
        BitmappedDisplayController d;int ns=number(),nr=number();
        std::vector<std::array<int,8>> shapes(ns);
        for(auto& s:shapes)for(auto& x:s)x=number();
        std::vector<std::array<int,5>> rectangles(nr);
        for(auto& r:rectangles)for(auto& x:r)x=number();
        if(nr)rectangle(d,rectangles[0]);
        for(auto& s:shapes){
            Point tl(s[3],s[1]),tr(s[4],s[1]),bl(s[5],s[2]),br(s[6],s[2]);Rect update;
            if(s[7]==221){Point p[]={tl,tr,br,bl};d.fillPath({p,4,false},RGB888{uint8_t(s[0])},update);}
            else{Point p[]={tl,tr,bl};d.fillPath({p,3,false},RGB888{uint8_t(s[0])},update);
                 Point q[]={tr,bl,br};d.fillPath({q,3,false},RGB888{uint8_t(s[0])},update);}
        }
        for(int i=1;i<nr;++i)rectangle(d,rectangles[i]);
        std::cout.write((char*)&d.writes,4);std::cout.write((char*)&d.overdraw,4);
        std::cout.write((char*)d.pixels.data(),d.pixels.size());
    }
}
'''
    (work/'sample_raster.cpp').write_text(scaffold+main)
    subprocess.run(['c++','-std=gnu++17','-O2','-I'+str(work),str(work/'sample_raster.cpp'),'-o',str(work/'sample_raster')],check=True)
    samples=json.loads((HERE/'.work/render-samples.json').read_text());payload=bytearray();index=[]
    count=sum(len(x) for x in samples.values());payload+=struct.pack('<i',count)
    for name,rows in samples.items():
        for r in rows:
            shapes,rects=decode(bytes.fromhex(r['road_hex']));index.append((name,r['frame']))
            payload+=struct.pack('<ii',len(shapes),len(rects))
            for s in shapes:payload+=struct.pack('<8i',*s)
            for colour,plots in rects:payload+=struct.pack('<5i',colour,*plots[0][1:],*plots[1][1:])
    raw=subprocess.check_output([str(work/'sample_raster')],input=payload)
    (HERE/'.work/sample-raster.bin').write_bytes(raw)
    assert len(raw)==count*(8+320*240)
    control={};result={}
    for i,(name,frame) in enumerate(index):
        at=i*(8+320*240);writes,overdraw=struct.unpack_from('<II',raw,at);mask=raw[at+8:at+8+320*240]
        if name=='control':control[frame]=mask
        mismatches=sum(a!=b for a,b in zip(mask,control[frame]))
        result.setdefault(name,[]).append(dict(frame=frame,material_pixel_writes=writes,material_overwrites=overdraw,
                                               differing_frame_pixels=mismatches,frame_pixels=320*240))
    summary={name:dict(samples=len(rows),mean_material_pixel_writes=sum(r['material_pixel_writes'] for r in rows)/len(rows),
        mean_material_overwrites=sum(r['material_overwrites'] for r in rows)/len(rows),
        maximum_differing_frame_pixels=max(r['differing_frame_pixels'] for r in rows),rows=rows) for name,rows in result.items()}
    (HERE/'RASTER-SAMPLES.json').write_text(json.dumps(summary,indent=2)+'\n')
    print(json.dumps({name:{k:v for k,v in r.items() if k!='rows'} for name,r in summary.items()},indent=2))


if __name__=='__main__':check()
