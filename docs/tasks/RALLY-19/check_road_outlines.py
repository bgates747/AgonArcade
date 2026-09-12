"""Apply the separately frozen strict outline check to completed native captures."""
import argparse,json,hashlib
from profile import TASK
from scene_masks import game_image
import road_outline_metric as metric

def check(root):
    frozen=json.loads((TASK/'evidence/golem-road/outline-calibration.json').read_text())
    source=TASK/'road_outline_metric.py';digest=hashlib.sha256(source.read_bytes()).hexdigest()
    assert frozen['source_sha256']==digest and all(frozen['calibration'].values())
    manifests=[json.loads((root/variant/'manifest.json').read_text()) for variant in ['oracle','candidate']]
    files=[[x['file'] for x in m['captures']] for m in manifests];assert files[0]==files[1]
    results=[]
    for filename in files[0]:
        result=metric.compare(game_image(root/'oracle'/filename),game_image(root/'candidate'/filename))
        results.append({'file':filename,**result})
    report={'pass':all(r['pass'] for r in results),'source_sha256':digest,'cases':len(results),'results':results}
    destination=root/'outline-results.json';assert not destination.exists()
    destination.write_text(json.dumps(report,indent=2)+'\n')
    assert report['pass'],[r for r in results if not r['pass']][:3]
    print('Strict native road outlines pass:',len(results),'cases; max error',max(r['max_edge_error_pixels'] for r in results))

if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');a=p.parse_args()
    check(TASK/'evidence/golem-road-visual'/a.name)
