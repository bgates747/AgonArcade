"""Analyze preserved captures and model matrix arithmetic; no emulator runs."""
import collections,ctypes,json,struct
from common import HERE,ROOT,sha,dump
FLEXE=ROOT/'docs/tasks/RALLY-24/flexe'
EVIDENCE=FLEXE/'.work/evidence'
def f32(x):return struct.unpack('<f',struct.pack('<f',x))[0]
libm=ctypes.CDLL('libm.so.6')
fma=libm.fmaf;fma.argtypes=[ctypes.c_float]*3;fma.restype=ctypes.c_float
CO=[0,0,f32(1/50),0,f32(-96/50),-1,1,0,0,0,0,0,f32(-1/50),f32(1/50),0,1,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,0,0,0,0,0,0,0,1,0,0]
EDGES=[[-106,106],[-90,90],[-86,-84],[84,86],[-2,2]]
def matrix_x(row,fused):
    p=list(map(float,row['params']))+[1.0];m=[]
    def add(a,b,acc):return fma(a,b,acc) if fused else f32(acc+f32(a*b))
    for i in range(8):
        acc=0.0
        for k in range(5):acc=add(CO[i*5+k],p[k],acc)
        m.append(acc)
    v=row['vertex']//2;u=EDGES[row['strip']][row['vertex']%2];p2=[u,v,u*v,1];acc=0.0
    for k in range(4):acc=add(m[k],p2[k],acc)
    return acc
def ppm(p):
    data=p.read_bytes();magic,shape,depth,rgb=data.split(b'\n',3)
    assert magic==b'P6' and shape==b'320 240' and depth==b'255' and len(rgb)==320*240*3
    return rgb
def main():
    provenance=json.loads((FLEXE/'PROVENANCE.json').read_text());pins={};comparisons=[]
    for engine in ('jit','interp'):
        for track in ('fuji','oval'):
            runs={}
            for variant in ('replay','a','b'):
                name=f'{track}-{variant}-{engine}';p=EVIDENCE/name
                for artifact in ['final.ppm','expected.json','replies.log','result.json','mos-to-vdp.bin']:
                    data=(p/artifact).read_bytes();h=sha(data)
                    assert h==provenance['runs'][name]['artifacts'][artifact],(name,artifact)
                    pins[str((p/artifact).relative_to(ROOT))]=h
                runs[variant]=ppm(p/'final.ppm')
            for variant in ('a','b'):
                points=[];colors=collections.Counter();row_counts=collections.Counter()
                for y in range(24,240):
                    for x in range(320):
                        i=(y*320+x)*3;a=runs['replay'][i:i+3];b=runs[variant][i:i+3]
                        if a!=b:points.append((x,y));row_counts[y]+=1;colors[a.hex()+'->'+b.hex()]+=1
                comparisons.append(dict(track=track,engine=engine,variant=variant,different_pixels=len(points),
                    bounds=[min(x for x,y in points),min(y for x,y in points),max(x for x,y in points),max(y for x,y in points)] if points else None,
                    rows=dict(sorted(row_counts.items())),color_changes=dict(colors),all_inside_road=all(104<=y<=223 for x,y in points)))
    raw=(FLEXE/'MATRIX.json').read_bytes();pins[str((FLEXE/'MATRIX.json').relative_to(ROOT))]=sha(raw);rows=json.loads(raw)['rows']
    for engine in ('jit','interp'):
        p=EVIDENCE/('matrix-'+engine)
        for name in ['replies.log','expected.json','mos-to-vdp.bin']:
            data=(p/name).read_bytes();h=sha(data);assert h==provenance['runs']['matrix-'+engine]['artifacts'][name]
            pins[str((p/name).relative_to(ROOT))]=h
        expected=json.loads((p/'expected.json').read_text());data=(p/'replies.log').read_bytes();assert len(data)==len(rows)*10
        for i,r in enumerate(rows):
            magic,version,kind,token,value=struct.unpack_from('<4sBBHH',data,i*10);e=expected['checks'][i]
            assert (magic,version,kind,token)==(b'VDPL',1,e['kind'],e['token'])
            assert (value-65536 if value>=32768 else value)==r['actual_signed_x']
    counts=collections.Counter();examples=[]
    for row in rows:
        separate=matrix_x(row,False);fused=matrix_x(row,True)
        assert int(separate)==row['native_signed_x']
        # Observed emulation behavior for negative conversion, not portable C++.
        convert=lambda value:-1 if int(value)<0 else int(value)
        counts['coordinates']+=1
        counts['separate_signed_mismatches']+=int(int(separate)!=row['actual_signed_x'])
        counts['separate_observed_unsigned_mismatches']+=int(convert(separate)!=row['actual_signed_x'])
        counts['fused_observed_unsigned_mismatches']+=int(convert(fused)!=row['actual_signed_x'])
        if int(separate)!=row['actual_signed_x']:
            cause='negative-conversion' if int(separate)<0 else 'fused-rounding'
            counts[cause]+=1
            examples.append(dict(**row,separate_f32=separate,fused_f32=fused,modeled_actual=convert(fused),classification=cause))
    assert counts['separate_signed_mismatches']==53 and counts['fused_observed_unsigned_mismatches']==0
    assert [r['different_pixels'] for r in comparisons]==[0,442,0,63,0,442,0,63]
    for comparison in comparisons:
        intervals={(r['params'][2],r['params'][3]) for r in examples if r['track']==comparison['track']}
        comparison['differing_rows_inside_affected_band_y_ranges']=all(any(top<=int(y)<=bottom for top,bottom in intervals) for y in comparison['rows'])
    dump('PARITY-RECEIPT.json',dict(schema=1,scope='preserved emulator captures plus host binary32/fmaf hypothesis; no new target/pixel raster run or physical qualification',
         source_sha256=sha((HERE/'parity.py').read_bytes()),evidence_sha256=pins,pixel_comparisons=comparisons,matrix_counts=dict(counts),matrix_examples=examples,
         conclusion='fused binary32 accumulation plus observed negative conversion reproduces all 460 saved matrix words; this is not a complete raster/physical proof'))
    print(json.dumps(dict(matrix_counts=dict(counts),captures=[dict(track=r['track'],engine=r['engine'],variant=r['variant'],pixels=r['different_pixels'],bounds=r['bounds'],affected_rows=r['differing_rows_inside_affected_band_y_ranges']) for r in comparisons]),indent=2))
if __name__=='__main__':main()
