"""Audit R19-08 native vehicle geometry, original artwork and per-object pixels.

Scenery/frontend, full-scene performance and long stability remain later tasks.
Diagnostic trace/GP reads do not establish rendering-completion timing.
"""
from pathlib import Path
import csv,hashlib,json,re
from PIL import Image
from profile import TASK
from native_run import GOLEM
from vehicle_reference import cases
from fixtures import cases as frozen_cases
from scene_masks import game_image,masks
from visual_metric import compare,calibrate,road_geometry
from visual_vehicles import foreground

RUNS=[('oval','complete-oval',0,26),('fuji','complete-fuji-a',0,22),
      ('fuji','complete-fuji-b',22,22),('oval','player-views-oval',37,21),
      ('fuji','player-views-fuji',55,21)]
RESOURCE_KEYS={'bootstrap_bytes','resident_payload_bytes','owned_ids','asset_payload_bytes',
               'program_payload_bytes','scratch_payload_bytes','resident_plus_bootstrap_payload_bytes','cleanup_bytes'}
def digest(path):return hashlib.sha256(path.read_bytes()).hexdigest()

def main():
    evidence={};outputs=[];kernels={};resources={};seen=set();views=set();traffic_views=set();liveries=set()
    def record(path):evidence[str(path.relative_to(TASK))]=digest(path);return path
    def read(path):return json.loads(record(path).read_text())
    assert all(calibrate().values())
    art_header=record(TASK/'.work/oracle/include/car.hpp').read_text()
    values=list(map(int,re.findall(r'\d+',art_header.split('static const uint8_t CarPixels[5][3072] = {',1)[1].split('};',1)[0])))
    assert len(values)==5*3072;art={}
    for i in range(5):
        path=TASK.parents[2]/'rally/assets/car'/f'car-{i:02d}.png'
        image=Image.open(path).convert('RGBA');assert image.size==(64,48)
        pixels=list(image.get_flattened_data());assert all(a in [0,255] and all(c%85==0 for c in [r,g,b]) for r,g,b,a in pixels)
        packed=bytes(0 if a==0 else 192+r//85+4*(g//85)+16*(b//85) for r,g,b,a in pixels)
        assert packed==bytes(values[i*3072:(i+1)*3072])
        assert packed==path.with_suffix('.rgba2222').read_bytes()
        art[str(path)]={'png_sha256':digest(path),'rgba2222_sha256':digest(path.with_suffix('.rgba2222'))}
    reference=read(TASK/'evidence/golem-cars/reference.json');reference={r['name']:r for r in reference['results']}
    numeric=read(TASK/'evidence/golem-vehicle-projection/qualification.json');assert numeric['pass'] and numeric['cases']==156
    primitive=read(TASK/'evidence/golem-bitmap/qualification.json');assert primitive['pass'] and primitive['cases']==24
    host=read(TASK/'evidence/golem-bitmap/host-tests.json')
    assert all(digest(GOLEM/p)==sha for p,sha in host['source_hashes'].items())
    assert 'bitmap' in host and 'checked_copy' in host and 'shared_scratch' in host
    for track,name,offset,count in RUNS:
        root=TASK/'evidence/golem-vehicle-visual'/name
        inputs=read(root/'inputs.json');selected=[c for c in cases() if c['track']==track][offset:offset+count]
        assert inputs['cases']==selected and inputs['track']==track
        for path,sha in inputs['source_hashes'].items():assert digest(Path(path))==sha,path
        saved=read(root/'results.json');assert saved['pass'] and saved['cases']==count
        bridge=read(root/'oracle-bridge.json');assert bridge['pass']
        kernel=digest(record(root/'kernel.golem'));assert kernels.setdefault(track,kernel)==kernel
        ledger={r.split()[0]:int(r.split()[1]) for r in record(root/'program.map').read_text().splitlines() if r.split()[0] in RESOURCE_KEYS}
        assert resources.setdefault(track,ledger)==ledger
        assert ledger['owned_ids']<=1024 and ledger['asset_payload_bytes']<=512*1024
        assert ledger['program_payload_bytes']<=128*1024 and ledger['scratch_payload_bytes']<=64*1024
        assert ledger['resident_plus_bootstrap_payload_bytes']<=1024*1024
        variants={}
        for variant in ['oracle','candidate']:
            manifest=read(root/variant/'manifest.json')
            assert manifest['headless'] and manifest['runtime_inputs_unchanged'] and not manifest['timed_out']
            assert record(root/variant/'guest-exit.viz').read_text().strip()=='0'
            assert len(manifest['captures'])==count;values=[]
            for i,capture in enumerate(manifest['captures']):
                image_path=record(root/variant/capture['file']);assert digest(image_path)==capture['sha256']
                scene_path=record(root/variant/f'guest-scene-{i:02d}.csv')
                image=game_image(image_path);mask=foreground(masks(scene_path,image_path))
                rows=list(csv.reader(scene_path.read_text().splitlines()));values.append((image,mask,rows))
            variants[variant]=values
        for case,old,(ei,em,er),(ai,am,ar) in zip(selected,saved['results'],variants['oracle'],variants['candidate']):
            name=case['name'];assert name not in seen;seen.add(name);ref=reference[name]
            cars=lambda rows:[list(map(int,r[1:])) for r in rows if r[0]=='C']
            expected_cars=[[c[k] for k in ['bitmap','scale','mirror','x','y','translation']] for c in ref['traffic_ordered']]
            assert cars(er)==cars(ar)==expected_cars
            expected_player=[ref['player']['bitmap'],ref['player']['mirror'],ref['player']['x'],len(expected_cars)]
            assert list(map(int,er[0][5:]))==list(map(int,ar[0][5:]))==expected_player
            if 22 in set(em.get_flattened_data()):views.add(tuple(expected_player[:2]))
            for c in expected_cars:traffic_views.add((c[0]%5,c[2]));liveries.add(c[0]//5)
            roads=lambda rows:[list(map(int,r[1:])) for r in rows if r[0]=='R']
            # Separate original Q8 diagnostic now matches exactly; rounded raster
            # boundary proof remains the already-qualified road trace/metric.
            eroad,aroad=roads(er),roads(ar)
            assert [r[:2] for r in eroad]==[r[:2] for r in aroad]
            # The terminal endpoint has no following material. Trace1600 keeps
            # its previous paint bit; oracle CSV prints0. R19-07 also compares
            # materials only on real bands, excluding that unused final word.
            assert [r[2] for r in eroad[:-1]]==[r[2] for r in aroad[:-1]]
            geometry=road_geometry([r[:2] for r in roads(er)],[r[:2] for r in roads(ar)])
            pixels=compare(ei,ai,em,am)
            assert old['case']==name and old['pixels']==pixels and old['geometry']==geometry
            assert old['car_geometry_pass'] and old['player_geometry_pass'] and pixels['pass'] and geometry['pass']
            if ref['native_oracle_verified']:
                frozen=TASK/'evidence/oracle'/name
                frozen_image=record(frozen/'frame-000010.png');frozen_scene=record(frozen/'guest-scene.csv')
                agreement=compare(game_image(frozen_image),ei,foreground(masks(frozen_scene,frozen_image)),em)
                assert agreement['pass']
                assert next(r for r in bridge['results'] if r['case']==name)=={'case':name,**agreement}
            outputs.append({'case':name,'track':track,'pixels':pixels,'geometry':geometry})
    frozen={c['name'] for c in frozen_cases()};assert frozen<=seen and len(frozen)==66 and len(seen)==112
    assert views=={(v,m) for v in range(5) for m in [0,1]}
    assert traffic_views==views and liveries==set(range(1,7))
    assert {t+'-'+n for t in ['oval','fuji'] for n in ['depth-edges','nonstable-ties']}<=seen
    labels=sorted({name for r in outputs for name in r['pixels']['regions']})
    minima={name:min(r['pixels']['regions'][name]['one_pixel_fraction'] for r in outputs if name in r['pixels']['regions']) for name in labels}
    exact={name:min(r['pixels']['regions'][name]['exact_fraction'] for r in outputs if name in r['pixels']['regions']) for name in labels if name=='player' or name.startswith('car-')}
    report={'milestone':'R19-08','pass':True,'scope':__doc__,'audit_sha256':digest(Path(__file__)),
            'golem_commit':'7065d0fc311164ef554ab3db86b1425a879297ca','visual_cases':len(seen),'frozen_poses':66,
            'numeric_cases':156,'bitmap_primitive_cases':24,'player_views':sorted(views),'traffic_views':sorted(traffic_views),
            'liveries':sorted(liveries),'minimum_regional_one_pixel_agreement':minima,'resources_traced':resources,
            'minimum_vehicle_exact_agreement':exact,
            'original_art_exact':art,
            'recurring_scene_uart':{'raw_state':80,'update':11,'call':6,'swap':3,'total':100,'excluded':'Diagnostic GP/trace reads, HUD and future scenery integration.'},
            'failures_retained':['golem-vehicle-projection/resource-failure','golem-vehicle-visual/initial-oval',
                                 'golem-vehicle-visual/raw-trace-oval'],
            'remaining':'R19-09 full scenery/frontend, R19-10 performance, R19-11 stability/review, R19-12 delivery.',
            'evidence':evidence}
    path=TASK/'evidence/golem-cars/qualification.json';assert not path.exists();path.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({k:v for k,v in report.items() if k not in ['evidence','scope']},indent=2))

if __name__=='__main__':main()
