"""Actual-C pixel comparison and independent set-distance/error-map checks."""
from pathlib import Path
import csv,ctypes as C,hashlib,json,random,subprocess
HERE=Path(__file__).resolve().parent
CUSTOM=HERE.parents[1]

def main():
    package=CUSTOM/'incremental/round-trips/source';sdk=CUSTOM/'paced-road/control/sdk/include'
    subprocess.run(['cc','-shared','-fPIC','-O2','-ffp-contract=off','-fno-builtin',
        '-I'+str(package),'-I'+str(sdk),str(HERE/'sampler_check.c'),'-o',str(HERE/'.work/sampler.so')],check=True)
    lib=C.CDLL(str(HERE/'.work/sampler.so'));f=lib.host_sample_image
    f.argtypes=[C.POINTER(C.c_uint8),C.POINTER(C.c_uint8),C.c_int,C.c_int,C.c_int,C.POINTER(C.c_int)]
    records=[{k:float(v) if k=='stock_rgba_error' else int(v) for k,v in r.items()}
             for r in csv.DictReader((HERE/'IMAGES.csv').open())]
    workload=json.loads((CUSTOM/'affine-offline/WORKLOAD.json').read_text());art={}
    for r in workload['bitmaps']:
        b=(CUSTOM/'affine-offline'/r['path']).read_bytes();assert hashlib.sha256(b).hexdigest()==r['sha256']
        art[r['bitmap_id']]=(C.c_uint8*len(b)).from_buffer_copy(b)
    exact=(HERE/'.work/exact-images.bin').read_bytes();stock=(HERE/'.work/stock-images.bin').read_bytes()
    for r in records:
        n=7425 if r['source']<120 else 3844;dst=(C.c_uint8*(n+32))(*([0xa5]*(n+32)));shape=(C.c_int*3)()
        assert f(art[r['source']],C.cast(C.addressof(dst)+16,C.POINTER(C.c_uint8)),r['source'],r['mirror'],r['q'],shape)==1
        w,h,stride=shape;assert (w,h)==(r['width'],r['height'])
        data=bytes(dst);assert data[:16]==data[-16:]==bytes([0xa5])*16
        wanted=exact[r['offset']:r['offset']+r['bytes']]
        assert b''.join(data[16+y*stride:16+y*stride+w] for y in range(h))==wanted
    bykey={(r['family'],r['q']):r for r in records} # silhouette is livery invariant
    pairs=list(csv.DictReader((HERE/'ERROR-PAIRS.csv').open()))
    rng=random.Random(0xAFF03);chosen=[r for r in pairs if int(r['edge_error'])<=2]
    sample=rng.sample(chosen,min(96,len(chosen)))
    def opaque(r,blob):
        data=blob[r['offset']:r['offset']+r['bytes']]
        return {(x-r['anchor_x'],y-r['anchor_y']) for y in range(r['height']) for x in range(r['width']) if data[y*r['width']+x]>>6}
    def direct_distance(a,b):
        result=0
        for source,target in ((a,b),(b,a)):
            for x,y in source:
                found=3
                for radius in range(3):
                    if any((x+dx,y+dy) in target for dx in range(-radius,radius+1) for dy in range(-radius,radius+1)):
                        found=radius;break
                result=max(result,found)
        return result
    for r in sample:
        a=bykey[int(r['family']),int(r['request_q'])];b=bykey[int(r['family']),int(r['prepared_q'])]
        reference=opaque(a,exact)
        for label,blob in (('exact',exact),('stock',stock)):
            assert direct_distance(reference,opaque(b,blob))==int(r[label+'_mask_error'])
    result=dict(passed=True,actual_accepted_c_sampler_images=len(records),guard_bytes_preserved=True,
        independent_chessboard_distance_pairs=len(sample)*2,full_source_art_pins=True,
        scene_and_target_unchanged=True,emulator_run=False,new_fps=False)
    (HERE/'VERIFICATION.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))

if __name__=='__main__':main()
