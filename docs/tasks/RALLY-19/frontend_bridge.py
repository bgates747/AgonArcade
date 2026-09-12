"""Strict bridge from R19-09 rendering to loader/failure-path hardening only."""
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

def verify(base):
    qualified=json.loads((TASK/'evidence/golem-frontend/qualification.json').read_text());assert qualified['pass']
    old=Path(qualified['build']['work']);base=Path(base);selected=json.loads((base/'manifest.json').read_text())
    for path,digest in qualified['build']['outputs'].items():assert sha(Path(path))==digest,path
    for path,digest in {**selected['source_hashes'],**selected['outputs']}.items():assert sha(Path(path))==digest,path
    original=(old/'src/main.cpp').read_text();candidate=(base/'src/main.cpp').read_text()
    assert sha(old/'src/main.cpp')==qualified['build']['source_hashes'][str(TASK/'frontend.cpp')]
    assert candidate==original or (candidate.count(FAILURE_CLEANUP)==1 and candidate.replace(FAILURE_CLEANUP,'')==original)
    assert candidate==(TASK/'frontend.cpp').read_text()
    for header in (old/'include').glob('*.hpp'):
        if header.name!='golem_renderer.hpp':assert header.read_bytes()==(base/'include'/header.name).read_bytes(),header
    before=(old/'include/golem_renderer.hpp').read_text();after=(base/'include/golem_renderer.hpp').read_text()
    def recurring(source):return source[source.index('    bool prepare('):source.index('    bool unload(')]
    assert recurring(before)==recurring(after),'Recurring state/transport changed'
    assets={}
    for track in ['oval','fuji']:
        for ext in ['.vdp','.clr','.road']:
            a=old/(track+ext);b=base/(track+ext);assert a.read_bytes()==b.read_bytes();assets[track+ext]=sha(b)
    report={'accepted_frontend':qualified['build'],'selected_frontend':selected,
        'frontend_difference':'Only the explicit initialization-failure cleanup insertion is allowed.',
        'recurring_prepare_submit_exact':True,'all_simulation_projection_art_headers_exact':True,'resident_assets_exact':assets,
        'bridge_source_sha256':sha(Path(__file__))}
    return qualified,selected,report
