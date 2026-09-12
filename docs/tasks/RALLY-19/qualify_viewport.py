"""Audit valid viewport/scroll captures, including actual in-region drawing."""
from pathlib import Path
import json,shutil
from profile import TASK
from native_run import GOLEM,sha
from scene_masks import game_image

def main():
    root=TASK/'evidence/golem-viewport';target=root/'qualification.json';assert not target.exists()
    runs=[];cases=[]
    for index in range(4):
        d=root/('valid-'+str(index));r=json.loads((d/'results.json').read_text());assert r['pass']
        inputs=json.loads((d/'inputs.json').read_text())
        assert inputs['offset']==8*index
        for p,digest in inputs['source_hashes'].items():assert sha(Path(p))==digest,p
        for variant in ['oracle','candidate']:
            manifest=json.loads((d/variant/'manifest.json').read_text())
            assert not manifest['timed_out']
            assert all(manifest['runtime_after'].get(k)==v for k,v in manifest['runtime_before'].items())
            assert (d/variant/'guest-exit.viz').read_text().strip()=='0'
        support=[]
        for i,item in enumerate(r['results']):
            assert item['pass'] and item['different_pixels']==0 and item['outside_unchanged'] and item['marker_present']
            case=item['case'];left,top,right,bottom,direction,amount=case
            assert amount<=((right-left+1) if direction<2 else (bottom-top+1))
            image=game_image(d/'candidate'/f'frame-{30+120*i:06d}.png')
            count=sum(image.getpixel((x,y))!=(85,85,85) for y in range(top,bottom+1) for x in range(left,right+1)
                      if not (180<=x<188 and 180<=y<188))
            assert count>0,(case,'empty viewport rendering')
            support.append(count);cases.append(case)
        runs.append({'name':d.name,'cases':len(r['results']),'region_nonbackground_pixels':support,
                     'results_sha256':sha(d/'results.json'),'inputs_sha256':sha(d/'inputs.json')})
    assert len(cases)==30
    shutil.copy2(GOLEM/'build/hosted-tests.json',root/'host-tests.json')
    host=json.loads((root/'host-tests.json').read_text())
    for p,digest in host['source_hashes'].items():assert sha(GOLEM/p)==digest,p
    report={'scope':__doc__,'pass':True,'cases':30,'runs':runs,'host_suite':'host-tests.json',
            'source_hashes':{str(p):sha(p) for p in [Path(__file__),GOLEM/'src/hosted.hpp',GOLEM/'examples/native_quantization/viewport.golem']},
            'limitations':'Caller must use valid pixel viewport and movement no larger than its axis. No full-scene/history/timing acceptance.',
            'retained_failures':'initial native crash for unsupported oversize vertical move; smoke missing affine feature; feature-smoke lacked Canvas clip synchronization'}
    target.write_text(json.dumps(report,indent=2)+'\n');print('Viewport/scroll qualified:',len(cases),'exact native image pairs')

if __name__=='__main__':main()
