"""Summarize completed R19-06 evidence without changing its raw reports."""
from pathlib import Path
import hashlib,json,statistics
from profile import TASK

def main():
    roots=['quantized-oval','quantized-fuji-a','quantized-fuji-b'];cases=[];sources=[]
    def read(path):
        sources.append({'path':str(path.relative_to(TASK)),'sha256':hashlib.sha256(path.read_bytes()).hexdigest()})
        return json.loads(path.read_text())
    for name in roots:
        root=TASK/'evidence/golem-section-visual'/name;report=read(root/'results.json')
        assert report['pass'];cases.extend(report['results'])
        for variant in ['oracle','candidate']:
            manifest=read(root/variant/'manifest.json')
            assert manifest['headless'] and manifest['runtime_inputs_unchanged'] and not manifest['timed_out']
            assert (root/variant/'guest-exit.viz').read_text().strip()=='0'
            for item in manifest['captures']:
                path=root/variant/item['file'];assert hashlib.sha256(path.read_bytes()).hexdigest()==item['sha256']
    assert len(cases)==74 and all(r['pass'] for r in cases)
    error=max(abs(r['expected_geometry'][i]-r['actual_geometry'][i]) for r in cases for i in range(2))
    regions={key:min(r['pixels']['regions'][key]['one_pixel_fraction'] for r in cases if key in r['pixels']['regions']) for key in ['asphalt','kerb','shoulder','centreline']}
    assert error<=1 and min(regions.values())>=.95
    native=read(TASK/'evidence/golem-rounding/signed-boundaries/results.json');assert native['pass']
    regression=read(TASK/'evidence/golem-section/arithmetic-bytecode-regression.json');assert regression['exact_bytecode_identity']
    read(TASK/'evidence/golem-section/host-tests-quantization.json')
    timing={};resources={}
    for track,visual in [('oval','quantized-oval'),('fuji','quantized-fuji-a')]:
        count=read(TASK/'evidence/golem-section-repeat'/('counted-'+track)/'results.json');assert count['pass']
        result=read(TASK/'evidence/golem-section-timing'/('groups256-'+track)/'results.json')
        runs=result['runs'];assert [r['variant'] for r in runs]==['shared','repeated','repeated','shared']
        assert all(len(r['group_ticks'])==128 and all(r['group_ticks']) for r in runs)
        shared=statistics.mean(runs[i]['mean_ms_per_call'] for i in [0,3]);repeated=statistics.mean(runs[i]['mean_ms_per_call'] for i in [1,2])
        timing[track]={'shared_mean_ms':shared,'repeated_mean_ms':repeated,'shared_reduction_fraction':1-shared/repeated,'group_median_ms_per_call':[r['median_ms_per_call'] for r in runs]}
        assert shared<repeated
        resources[track]={line.split()[0]:int(line.split()[1]) for line in (TASK/'evidence/golem-section-visual'/visual/'program.map').read_text().splitlines() if line.split()[0] in ['bootstrap_bytes','resident_payload_bytes','owned_ids','asset_payload_bytes','program_payload_bytes','scratch_payload_bytes','resident_plus_bootstrap_payload_bytes']}
    report={'milestone':'R19-06','pass':True,'scope':'One complete accepted band containing diagnostic row160, both tracks; no full-scene/hardware/performance-goal completion claim. Raw game-state/table inputs only. Frozen production admission ABI unchanged.','compiler_commit':'f54651a9ed3df87fc3d1e4240264cf44888cc951','visual_cases':len(cases),'max_centre_error_pixels':error,'minimum_material_one_pixel_agreement':regions,'timing':timing,'timing_scope':'Normal guest clock/UART, stock VDP, no observer; serial ABBA, 256 resident invocations/group,64 warm groups,128 measured groups/run. GP parser echo, not raster completion. Native timer advances in two-tick steps; grouped median ties reflect that granularity. Counted separate probes verify1024 invocations/track.','choice':'Share interval lookup and fraction preparation across both endpoints; evaluate each row from its resident coefficients and preserve oracle truncation.','resources':resources,'remaining':'Full-road enumeration, production admission integration, cars/background/frontend, matched full-scene timing and10-minute stability remain R19-07 onward. Current Fuji877 IDs leaves147; naively adding the earlier306-ID admission kernel would exceed1024, so integrate/pack before full scene.','evidence':sources}
    destination=TASK/'evidence/golem-section/qualification.json';assert not destination.exists()
    destination.write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:report[k] for k in ['pass','visual_cases','max_centre_error_pixels','timing','resources']},indent=2))
if __name__=='__main__':main()
