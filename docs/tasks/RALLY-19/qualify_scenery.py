"""Recompute full-scene correctness from native images and diagnostic geometry.

This is R19-09 image evidence, not a timing, frontend or stability qualification.
The frozen regional metric is unchanged; each image uses its own support mask.
"""
from pathlib import Path
import csv,json,subprocess
from profile import TASK
from native_run import GOLEM,sha
from fixtures import cases as frozen_cases
from vehicle_reference import cases
from visual_scenery import history_cases
from visual_metric import compare,calibrate,road_geometry
from scene_masks import game_image,masks
from qualify_vehicles import RESOURCE_KEYS

def main():
    destination=TASK/'evidence/golem-scenery-visual/qualification.json'
    assert not destination.exists(), 'Never overwrite qualification evidence'
    evidence={};outputs=[];seen=set();kernels={};resources={};runtime={}
    def record(path):
        evidence[str(path.relative_to(TASK))]=sha(path)
        return path
    def read(path):return json.loads(record(path).read_text())
    assert all(calibrate().values())
    numeric=read(TASK/'evidence/golem-scenery-history/qualification.json')
    assert numeric['pass'] and numeric['cases']==444
    frontend=read(TASK/'evidence/golem-frontend/qualification.json')
    assert frontend['pass'] and frontend['native_runs']==12
    bootstraps={track:sha(Path(frontend['build']['work'])/(track+'.vdp')) for track in ['oval','fuji']}
    host=read(TASK/'evidence/golem-shared-literals/host-tests.json')
    for path,digest in host['source_hashes'].items():assert sha(GOLEM/path)==digest,path
    for track in ['oval','fuji']:
        for history in [False,True]:
            selected=history_cases(track) if history else [c for c in frozen_cases() if c['track']==track]
            full_reference={c['name']:c for c in cases()}
            for offset in range(0,len(selected),8):
                batch=selected[offset:offset+8]
                name=f'{"history" if history else "frozen"}-{track}-{offset}'
                root=TASK/'evidence/golem-scenery-visual'/name
                inputs=read(root/'inputs.json');saved=read(root/'results.json');bridge=read(root/'oracle-bridge.json')
                expected=batch if history else [full_reference[c['name']] for c in batch]
                assert inputs['cases']==expected and inputs['track']==track
                assert inputs['frames_per_pose']==(1 if history else 2)
                assert saved['pass'] and saved['cases']==len(batch) and bridge['pass']
                for path,digest in inputs['source_hashes'].items():assert sha(Path(path))==digest,path
                kernel=sha(record(root/'kernel.golem'));assert kernels.setdefault(track,kernel)==kernel
                ledger={r.split()[0]:int(r.split()[1]) for r in record(root/'program.map').read_text().splitlines()
                        if r.split()[0] in RESOURCE_KEYS}
                assert resources.setdefault(track,ledger)==ledger
                assert ledger['owned_ids']<=1024 and ledger['asset_payload_bytes']<=512*1024
                assert ledger['program_payload_bytes']<=128*1024 and ledger['scratch_payload_bytes']<=64*1024
                assert ledger['resident_plus_bootstrap_payload_bytes']<=1024*1024
                variants={}
                for variant in ['oracle','candidate']:
                    manifest=read(root/variant/'manifest.json')
                    assert manifest['headless'] and manifest['runtime_inputs_unchanged'] and not manifest['timed_out']
                    assert record(root/variant/'guest-exit.viz').read_text().strip()=='0'
                    assert len(manifest['captures'])==len(batch)
                    for path,identity in manifest['runtime_before'].items():
                        if variant=='candidate' and path.endswith('/program.bin'):
                            assert identity['sha256']==bootstraps[track], 'Frontend must use image-qualified bootstrap'
                        if any(path.endswith('/'+suffix) for suffix in ['fab-agon-emulator.bin','mos_platform.bin','firmware/vdp_platform.so']):
                            key=Path(path).name
                            assert runtime.setdefault(key,identity['sha256'])==identity['sha256']
                    frames=[]
                    for i,capture in enumerate(manifest['captures']):
                        image_path=record(root/variant/capture['file']);assert sha(image_path)==capture['sha256']
                        scene_path=record(root/variant/f'guest-scene-{i:02d}.csv')
                        # Recompute masks and comparisons instead of trusting stored pass flags.
                        frames.append((game_image(image_path),masks(scene_path,image_path),
                                       list(csv.reader(scene_path.read_text().splitlines()))))
                    variants[variant]=frames
                for case,old,(ei,em,er),(ai,am,ar) in zip(batch,saved['results'],variants['oracle'],variants['candidate']):
                    name=case['name'];assert name not in seen;seen.add(name)
                    assert er[0]==ar[0],(name,'scenery/player header')
                    rows=lambda data,kind:[list(map(int,r[1:])) for r in data if r[0]==kind]
                    assert rows(er,'C')==rows(ar,'C'),(name,'car draw order/geometry')
                    eroad,aroad=rows(er,'R'),rows(ar,'R')
                    assert [r[:2] for r in eroad]==[r[:2] for r in aroad]
                    assert [r[2] for r in eroad[:-1]]==[r[2] for r in aroad[:-1]]
                    geometry=road_geometry([r[:2] for r in eroad],[r[:2] for r in aroad])
                    pixels=compare(ei,ai,em,am)
                    assert old['case']==name and old['pixels']==pixels and old['geometry']==geometry
                    assert old['scenery_state_pass'] and old['car_geometry_pass'] and old['player_geometry_pass']
                    assert geometry['pass'] and pixels['pass'] and 'background' in pixels['regions']
                    if not history:
                        frozen=TASK/'evidence/oracle'/name
                        frozen_image=record(frozen/'frame-000010.png');frozen_scene=record(frozen/'guest-scene.csv')
                        agreement=compare(game_image(frozen_image),ei,masks(frozen_scene,frozen_image),em)
                        assert agreement['pass']
                        assert next(r for r in bridge['results'] if r['case']==name)=={'case':name,**agreement}
                    outputs.append({'case':name,'track':track,'history':history,'pixels':pixels,'geometry':geometry})
    frozen={c['name'] for c in frozen_cases()}
    assert frozen<=seen and len(frozen)==66 and len(seen)==186
    labels={label for r in outputs for label in r['pixels']['regions']}
    minima={label:min(r['pixels']['regions'][label]['one_pixel_fraction'] for r in outputs
                     if label in r['pixels']['regions']) for label in sorted(labels)}
    exact={label:min(r['pixels']['regions'][label]['exact_fraction'] for r in outputs
                    if label in r['pixels']['regions']) for label in sorted(labels)}
    compiler_commit=subprocess.check_output(['git','rev-parse','HEAD'],cwd=GOLEM,text=True).strip()
    report={'scope':__doc__,'pass':True,'frozen_poses':66,'history_poses':120,'visual_cases':186,
            'numeric_history_records':444,'compiler_commit':compiler_commit,'audit_sha256':sha(Path(__file__)),
            'minimum_regional_one_pixel_agreement':minima,'minimum_regional_exact_agreement':exact,
            'resources':resources,'runtime':runtime,'kernel_sha256':kernels,
            'frontend_bootstrap_sha256':bootstraps,
            'recurring_scene_bytes':{'state':80,'update':11,'call':6,'swap':3,'total':100,'HUD':'separate'},
            'history_scope':'One actual swap per accepted call; two retained pages within each fresh batch of up to eight poses.',
            'remaining':'Frontend qualification, R19-10 performance, R19-11 malformed/lifecycle/long stability, R19-12 delivery.',
            'results':outputs,'evidence':evidence}
    destination.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({k:v for k,v in report.items() if k not in ['results','evidence']},indent=2))

if __name__=='__main__':main()
