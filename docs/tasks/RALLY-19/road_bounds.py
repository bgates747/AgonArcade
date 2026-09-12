"""Prove the finite full-road merge limit over all accepted curve/phase tables."""
import hashlib,json
from build_section_kernel import array
from profile import TASK

def proof():
    base=TASK/'.work/oracle/include';band=base/'band_table.hpp';phase=base/'section_phase.hpp'
    offsets=array(band,'BandOffsets');ends=array(band,'BandEnds')
    phaseOffsets=array(phase,'Offsets');phaseRows=array(phase,'Rows');phaseIndex=array(phase,'PhaseIndex')
    assert len(offsets)==2408 and len(phaseOffsets)==101 and len(phaseIndex)==4000
    patterns=[]
    for i,start in enumerate(phaseOffsets):
        rows=phaseRows[start:phaseOffsets[i+1] if i+1<len(phaseOffsets) else len(phaseRows)]
        assert rows[0]==116 and rows[-1]==224 and all(a<b for a,b in zip(rows,rows[1:]))
        patterns.append(set(rows))
    report={}
    for track,start,stop in [('oval',0,360),('fuji',360,len(offsets))]:
        maximum=0;witness=None
        for bin_ in range(start,stop):
            curve=[y+1 for y in ends[offsets[bin_]:offsets[bin_+1] if bin_+1<len(offsets) else len(ends)]]
            assert 104<curve[0] and curve[-1]==224 and all(a<b for a,b in zip(curve,curve[1:]))
            for pattern,stripe in enumerate(patterns):
                rows=sorted(set(curve)|stripe|{104});count=len(rows)-1
                if count>maximum:
                    maximum=count;witness={'position':(bin_-start)*1600,'phase':phaseIndex.index(pattern),'bin':bin_-start,'phase_pattern':pattern,'rows':rows}
        report[track]={'max_sections':maximum,'combinations_checked':(stop-start)*len(patterns),'witness':witness}
    assert report['oval']['max_sections']==29 and report['fuji']['max_sections']==32
    return {'scope':__doc__,'table_source_sha256':{str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in [band,phase]},'tracks':report,'finite_repeat_limit':32,'note':'The other phase half flips materials without changing boundaries. This proves a merge-size limit, not a completed full-road renderer.'}

if __name__=='__main__':
    report=proof();destination=TASK/'evidence/golem-road-bounds.json';assert not destination.exists()
    destination.write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report['tracks'],indent=2))
