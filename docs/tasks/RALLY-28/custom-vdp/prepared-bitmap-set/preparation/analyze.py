"""Offline coverage/error/RAM alternatives; never installs or runs a game."""
from pathlib import Path
import collections,csv,hashlib,json,struct
HERE=Path(__file__).resolve().parent
sha=lambda b:hashlib.sha256(b).hexdigest()

def solve(domain,cost,errors,limit,generator):
    """Minimum pixel+metadata budget contiguous, monotone partitions.

    Representative belongs to its interval, so no size-order reversal is
    possible between adjacent intervals. No visual threshold is adopted.
    """
    n=len(domain);dp=[None]*(n+1);dp[0]=(0,0,[])
    for end in range(1,n+1):
        for begin in range(end-1,-1,-1):
            if domain[end-1]-domain[begin]>12:break
            for chosen in range(begin,end):
                q=domain[chosen]
                group=[errors[(d,q)] for d in domain[begin:end]]
                if any(e['edge_error']>limit or e[generator+'_mask_error']>limit for e in group):continue
                if dp[begin] is None:continue
                # Object overhead is deliberately not invented in the selector;
                # separately report sensitivity at 0/128/256 bytes per object.
                value=(dp[begin][0]+cost[q],dp[begin][1]+sum(abs(d-q) for d in domain[begin:end]),
                    dp[begin][2]+[(begin,end,chosen)])
                if dp[end] is None or value[:2]<dp[end][:2]:dp[end]=value
    if dp[-1] is None:return None
    table={};selected=[]
    for begin,end,chosen in dp[-1][2]:
        q=domain[chosen];selected.append(q)
        for d in domain[begin:end]:table[d]=q
    assert list(table)==domain and all(a<=b for a,b in zip(table.values(),list(table.values())[1:]))
    return selected,table

def main():
    records=[{k:int(v) if k not in ('stock_rgba_error',) else float(v) for k,v in r.items()}
             for r in csv.DictReader((HERE/'IMAGES.csv').open())]
    pairs=collections.defaultdict(dict)
    for r in csv.DictReader((HERE/'ERROR-PAIRS.csv').open()):
        r={k:float(v) if 'rgba' in k or 'iou' in k else int(v) for k,v in r.items()}
        pairs[r['family']][r['request_q'],r['prepared_q']]=r
    images=(HERE/'.work/exact-images.bin').read_bytes();stock=(HERE/'.work/stock-images.bin').read_bytes()
    assert len(images)==len(stock)==sum(r['bytes'] for r in records)
    byfamily=collections.defaultdict(list)
    for r in records:byfamily[r['family']].append(r)
    policies={}
    for label,generator,epsilon in [('exact-reference','exact',0),('one-pixel-reference','exact',1),
            ('two-pixel-reference','exact',2),('one-pixel-stock-model','stock',1),('two-pixel-stock-model','stock',2),
            ('near-one-far-two-stock-model','stock',2)]:
        chosen_records=[];maps={};errors=[];worst=[];failed=[]
        for family,items in sorted(byfamily.items()):
            domain=sorted({r['q'] for r in items});cost={q:sum(r['bytes']+8 for r in items if r['q']==q) for q in domain}
            if label=='exact-reference':selected,table=domain,{q:q for q in domain}
            else:
                pair=pairs[family]
                if label.startswith('near-one'):
                    pair={k:{**v,**({'edge_error':3,generator+'_mask_error':3} if k[0]>=64 and (v['edge_error']>1 or v[generator+'_mask_error']>1) else {})} for k,v in pair.items()}
                result=solve(domain,cost,pair,epsilon,generator)
                if result is None:failed.append(family);continue
                selected,table=result
            maps[str(family)]={str(q):v for q,v in table.items()}
            chosen_records.extend(r for r in items if r['q'] in selected)
            for q,choice in table.items():
                e=pairs[family][q,choice];errors.append(e)
                worst.append(dict(family=family,request_q=q,prepared_q=choice,
                    edge_error=e['edge_error'],mask_error=e[generator+'_mask_error'],
                    rgba_error=e[generator+'_rgba_error'],silhouette_iou=e[generator+'_iou']))
        if failed:
            policies[label]=dict(covered=False,uncovered_families=failed);continue
        counts=collections.Counter('traffic' if r['source']<120 else 'sign' for r in chosen_records)
        # Exact content deduplication is verified byte-for-byte, not by relying
        # on a short hash. ID accounting retains the simple one-record layout.
        blob=images if generator=='exact' else stock;unique={}
        for r in chosen_records:
            data=blob[r['offset']:r['offset']+r['bytes']]
            unique[(r['width'],r['height'],data)]=len(data)
        payload=sum(r['bytes'] for r in chosen_records)
        lookup=64+68*16+18*126+8*len(chosen_records)
        upper=lookup+payload+256*len(chosen_records)
        sorted_worst=sorted(worst,key=lambda r:(r['mask_error'],r['edge_error'],r['rgba_error']),reverse=True)
        entry_count=len(chosen_records);largest=max(r['bytes'] for r in chosen_records)
        policies[label]=dict(covered=True,generator=generator,error_alternative=epsilon,
            counts=dict(counts),entries=entry_count,unique_pixel_images=len(unique),
            retained_pixel_bytes=payload,deduplicated_pixel_bytes=sum(unique.values()),
            natural_size_pixel_bytes=sum(r['natural_bytes'] for r in chosen_records),
            packed_lookup_bytes=lookup,maximum_image_bytes=largest,
            maximum_edge_error=max(e['edge_error'] for e in errors),
            maximum_silhouette_distance=max(e[generator+'_mask_error'] for e in errors),
            maximum_opaque_rgba_disagreement=max(e[generator+'_rgba_error'] for e in errors),
            minimum_silhouette_iou=min(e[generator+'_iou'] for e in errors),
            q_maps=maps,worst_cases=sorted_worst[:12],
            overhead_sensitivity={str(per):payload+lookup+per*entry_count for per in (0,128,256)},
            conservative_setup_addition_model_bytes=upper+largest+4096,
            peak_model='Retained pixel+packed table+256B/object scenario, plus one largest image and4096B setup scratch; allocator overhead/capacity unmeasured, not a guaranteed bound',
            size_step_max_q=max(max((b-a for a,b in zip(sorted(set(m.values())),sorted(set(m.values()))[1:])),default=0) for m in ({int(q):v for q,v in table.items()} for table in maps.values())))
    # Map every actually observed actor key separately from full-domain coverage.
    draws=[json.loads(s) for s in (HERE.parents[1]/'affine-offline/OBSERVED-DRAWS.jsonl').read_text().splitlines()]
    observed=[r for r in draws if r['phase']=='measured' and r['kind']!='player']
    for label,result in policies.items():
        if not result['covered']:continue
        misses=[]
        for r in observed:
            b=r['bitmap_id'];mirror=r['matrix_q8'][0]<0
            family=2*((b-5)%5)+mirror if b<120 else 10+b-120
            if str(r['scale_q8']//2) not in result['q_maps'][str(family)]:misses.append(r)
        assert not misses,(label,len(misses))
        result['observed_actor_draws_covered']=len(observed)
    source_comparison=dict(images=len(records),stock_model_same_size_nonidentical_images=sum(r['stock_rgba_error']>0 for r in records),
        worst_stock_rgba_disagreement=max(r['stock_rgba_error'] for r in records),maximum_stock_silhouette_distance=max(r['stock_mask_error'] for r in records),
        stock_inverse_is_host_analytic_model=True,not_a_firmware_pixel_or_timing_qualification=True)
    summary=dict(host_only=True,policies=policies,source_generation_comparison=source_comparison,
        exact_current_compact_control_preserved=True,new_fps_measured=False,
        approximate_policy_accepted=False,live_ram_measured=False,
        source_sha256={n:sha((HERE/n).read_bytes()) for n in ('domain.c','images.cpp','analyze.py','DOMAIN-WITNESSES.csv','INPUT.tsv','IMAGES.csv','ERROR-PAIRS.csv')})
    (HERE/'FINDINGS.json').write_text(json.dumps(summary,indent=2)+'\n')
    print(json.dumps({k:{x:v.get(x) for x in ('covered','entries','retained_pixel_bytes','packed_lookup_bytes','maximum_edge_error','maximum_silhouette_distance','maximum_opaque_rgba_disagreement','overhead_sensitivity')} for k,v in policies.items()},indent=2))

if __name__=='__main__':main()
