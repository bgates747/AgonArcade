"""Compare saved VGA captures and summarize portable diagnostic measurements."""
from pathlib import Path
import argparse,hashlib,json

def ppm(path):
    b=Path(path).read_bytes();magic,shape,depth,pixels=b.split(b'\n',3)
    assert magic==b'P6' and depth==b'255'
    w,h=map(int,shape.split());assert len(pixels)==w*h*3
    return w,h,pixels

def image_check(path):
    w,h,pixels=ppm(path);assert (w,h)==(320,240)
    road=pixels[104*w*3:224*w*3]
    colours=set(road[i:i+3] for i in range(0,len(road),3))
    nonblack=sum(road[i:i+3]!=b'\0\0\0' for i in range(0,len(road),3))
    assert len(colours)>=10 and nonblack>4096,('blank or incomplete road',len(colours),nonblack)
    return dict(colours=len(colours),nonblack_pixels=nonblack,visible_scene_sha256=hashlib.sha256(pixels[24*w*3:]).hexdigest())

def report(directory):
    p=Path(directory);rows=[];pairs=[]
    for engine in ('jit','interp'):
      for track in ('fuji','oval'):
        reference=p/f'{track}-replay-{engine}'/'final.ppm';w,h,rgb=ppm(reference)
        for variant in ('replay','a','b'):
            run=p/f'{track}-{variant}-{engine}';r=json.loads((run/'result.json').read_text());assert r['error'] is None,r
            im=image_check(run/'final.ppm');other=ppm(run/'final.ppm')[2]
            # Only first24 HUD/status rows excluded. Compare all scene pixels.
            different=sum(rgb[i:i+3]!=other[i:i+3] for i in range(24*w*3,len(rgb),3))
            pairs.append(dict(track=track,engine=engine,variant=variant,different_scene_pixels=different,**im))
            rows.append(dict(engine=engine,variant=variant,host_elapsed_seconds=r['host_elapsed_seconds'],**r['timings']))
    result=dict(rows=rows,pixel_comparisons=pairs,all_scene_pixels_equal=all(x['different_scene_pixels']==0 for x in pairs),scope='final scene on each track; not every displayed pose')
    (p.parent/'SUMMARY.json').write_text(json.dumps(result,indent=2)+'\n');return result
if __name__=='__main__':
    a=argparse.ArgumentParser(description=__doc__);a.add_argument('evidence',type=Path);args=a.parse_args();r=report(args.evidence)
    print(json.dumps(r['pixel_comparisons'],indent=2))
    for row in r['rows']:
        print(row['track'],row['engine'],row['variant'],'generate',row['generation_nominal_ms']['median'],'swap',row['generation_to_swap_return_nominal_ms']['median'],'batch',row['diagnostic_batch_frames_per_nominal_second'])
