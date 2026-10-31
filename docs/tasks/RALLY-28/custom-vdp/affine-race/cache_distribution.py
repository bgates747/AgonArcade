"""Cold last-image-cache distribution from actual frozen actor plans."""
from pathlib import Path
import json
HERE=Path(__file__).resolve().parent

def main():
    rows=[json.loads(x) for x in (HERE.parent/'affine-offline/OBSERVED-DRAWS.jsonl').read_text().splitlines()]
    cache={};lastframe=None;signslot=0
    stats={k:dict(draws=0,natural_pixels=0,large_draws=0,large_pixels=0) for k in ['hit','miss']}
    for r in rows:
        if r['phase']!='measured' or r['kind']=='player':continue
        if r['frame']!=lastframe:lastframe=r['frame'];signslot=0
        if r['kind']=='sign':slot=6+signslot;signslot+=1
        else:slot=r['matrix_id']-63970
        key=(r['bitmap_id'],tuple(r['matrix_q8']))
        status='hit' if cache.get(slot)==key else 'miss';cache[slot]=key
        a,b,tx,c,d,ty=r['matrix_q8']
        xs=[int(tx/256),int((tx+a*r['source_width'])/256)]
        ys=[int(ty/256),int((ty+d*r['source_height'])/256)]
        pixels=(max(xs)-min(xs)+1)*(max(ys)-min(ys)+1)
        s=stats[status];s['draws']+=1;s['natural_pixels']+=pixels
        if r['scale_q8']>=128:s['large_draws']+=1;s['large_pixels']+=pixels
    assert stats['hit']['draws']==3000 and stats['miss']['draws']==1867
    assert stats['miss']['natural_pixels']==1717661
    result=dict(scope='Independent cold-cache distribution from observed complete-race actor plans',stats=stats,
        hit_draw_percent=stats['hit']['draws']/4867*100,
        hit_natural_pixels_percent=stats['hit']['natural_pixels']/sum(s['natural_pixels'] for s in stats.values())*100,
        not_target_timing=True)
    data=json.dumps(result,indent=2)+'\n'
    target=HERE/'CACHE-DISTRIBUTION.json'
    if target.exists():assert target.read_text()==data
    else:target.write_text(data)

if __name__=='__main__':main()
