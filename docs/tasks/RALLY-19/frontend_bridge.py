"""Strict frontend bridge; optionally admit the fully qualified stack-fix assets."""
import json
from pathlib import Path
from profile import TASK
from native_run import sha

FAILURE_CLEANUP='''            // R19-11: release uploads even when scene initialization fails.
            bool released=golemRenderer.unload();
            for(unsigned bitmap=0;bitmap<35;++bitmap)vdp_adv_clear_buffer(64000+bitmap);
            vdp_adv_clear_buffer(64100);vdp_adv_clear_buffer(63984);
            released=waitForVDP()&&released;
            if(!released)printf("Golem initialization cleanup did not complete.\\n");
'''

def inline_assets(base):
    """Accept only the exact two bootstraps covered by all frozen scene tests."""
    from fixtures import cases
    path=TASK/'evidence/hardware-production/inline-candidate/frozen-qualification.json'
    proof=json.loads(path.read_text());assert proof['pass']
    assert proof['qualifier_sha256']==sha(TASK/'qualify_inline_candidate.py')
    required={c['name'] for c in cases()}
    names=[r['case'] for r in proof['results']]
    assert len(names)==len(set(names))==proof['frozen_cases']==len(required)
    assert set(names)==required
    for result in proof['results']:assert result['geometry']['pass'] and result['pixels']['pass']
    for name,digest in proof['evidence'].items():
        evidence=TASK/name;assert sha(evidence)==digest,evidence
        if evidence.name=='inputs.json':
            for source,expected in json.loads(evidence.read_text())['source_hashes'].items():
                assert sha(Path(source))==expected,source
    for track in ['oval','fuji']:
        assert sha(base/(track+'.vdp'))==proof['candidate_bootstraps'][track],track
    # Recompute the integrity header, using the unchanged generator in a temporary
    # directory. No candidate or qualified fixture is edited by verification.
    import tempfile,shutil
    from asset_integrity import generate
    with tempfile.TemporaryDirectory(prefix='r19-inline-integrity-') as directory:
        check=Path(directory);(check/'include').mkdir()
        for track in ['oval','fuji']:
            for ext in ['.vdp','.clr']:shutil.copy2(base/(track+ext),check/(track+ext))
        generate(check)
        assert (check/'include/scene_assets.hpp').read_bytes()==(base/'include/scene_assets.hpp').read_bytes()
    return {'qualification':str(path),'sha256':sha(path),'frozen_cases':len(names),
            'bootstraps':proof['candidate_bootstraps'],'integrity_header_recomputed':True}

def verify(base,allow_inline=False):
    qualified=json.loads((TASK/'evidence/golem-frontend/qualification.json').read_text());assert qualified['pass']
    old=Path(qualified['build']['work']);base=Path(base);selected=json.loads((base/'manifest.json').read_text())
    for path,digest in qualified['build']['outputs'].items():assert sha(Path(path))==digest,path
    for path,digest in {**selected['source_hashes'],**selected['outputs']}.items():assert sha(Path(path))==digest,path
    original=(old/'src/main.cpp').read_text();candidate=(base/'src/main.cpp').read_text()
    assert sha(old/'src/main.cpp')==qualified['build']['source_hashes'][str(TASK/'frontend.cpp')]
    assert candidate==original or (candidate.count(FAILURE_CLEANUP)==1 and candidate.replace(FAILURE_CLEANUP,'')==original)
    assert candidate==(TASK/'frontend.cpp').read_text()
    transition=inline_assets(base) if allow_inline else None
    expected_headers={p.name for p in (old/'include').glob('*.hpp')}|{'checked_asset.hpp','scene_assets.hpp'}
    assert expected_headers=={p.name for p in (base/'include').glob('*.hpp')}
    assert (base/'include/checked_asset.hpp').read_bytes()==(TASK/'checked_asset.hpp').read_bytes()
    assert (base/'include/golem_renderer.hpp').read_bytes()==(TASK/'golem_renderer.hpp').read_bytes()
    for header in (old/'include').glob('*.hpp'):
        if header.name=='golem_renderer.hpp' or (allow_inline and header.name=='scene_assets.hpp'):continue
        assert header.read_bytes()==(base/'include'/header.name).read_bytes(),header
    before=(old/'include/golem_renderer.hpp').read_text();after=(base/'include/golem_renderer.hpp').read_text()
    def recurring(source):return source[source.index('    bool prepare('):source.index('    bool unload(')]
    assert recurring(before)==recurring(after),'Recurring state/transport changed'
    assets={}
    for track in ['oval','fuji']:
        for ext in ['.vdp','.clr','.road']:
            a=old/(track+ext);b=base/(track+ext)
            if not (allow_inline and ext=='.vdp'):assert a.read_bytes()==b.read_bytes()
            assets[track+ext]=sha(b)
    report={'accepted_frontend':qualified['build'],'selected_frontend':selected,
        'frontend_difference':'Only the explicit initialization-failure cleanup insertion is allowed.',
        'recurring_prepare_submit_exact':True,'all_simulation_projection_art_headers_exact':True,'resident_assets_exact':assets,
        'bridge_source_sha256':sha(Path(__file__))}
    if transition:
        report['qualified_inline_transition']=transition
        report['selected_resident_assets']=report.pop('resident_assets_exact')
        report['cleanup_and_road_assets_exact']=True
    return qualified,selected,report
