"""Save reproducible fixture/module bytes after host and target qualification."""
from pathlib import Path
import hashlib
import json
import zipfile
from build_candidates import HERE,WORK,CONTROL


if __name__=='__main__':
    builds=json.loads((HERE/'CANDIDATE-BUILD.json').read_text())
    tested=json.loads((HERE/'CAMPAIGN-qualified.json').read_text())
    assert set(tested)==set(builds),'Do not package an incomplete campaign'
    files={'firmware/vdp_rally.bin':CONTROL/'fixture/vdp_rally.bin'}
    for name,item in builds.items():
        assert tested[name]['final_buffers']==tested['control']['final_buffers']
        for n,h in item['fixture_files'].items():
            p=WORK/name/'fixture'/n;assert hashlib.sha256(p.read_bytes()).hexdigest()==h
            files['fixtures/'+name+'/'+n]=p
        files['modules/'+name+'/rally-render.vdpl']=WORK/name/'target/rally-render.vdpl'
        files['modules/'+name+'/render_core.inc']=WORK/name/'package/helper/render_core.inc'
    files['CANDIDATE-BUILD.json']=HERE/'CANDIDATE-BUILD.json'
    with zipfile.ZipFile(HERE/'CANDIDATES.zip','w',compression=zipfile.ZIP_DEFLATED,compresslevel=9) as z:
        for name,p in sorted(files.items()):
            info=zipfile.ZipInfo(name,(2026,10,16,0,0,0));info.compress_type=zipfile.ZIP_DEFLATED
            info.external_attr=0o644<<16;z.writestr(info,p.read_bytes())
    receipt=dict(sha256=hashlib.sha256((HERE/'CANDIDATES.zip').read_bytes()).hexdigest(),files=len(files),
        member_sha256={name:hashlib.sha256(p.read_bytes()).hexdigest() for name,p in sorted(files.items())},
        physical_deployment=False,firmware_changed=False)
    (HERE/'CANDIDATES-PACKAGE.json').write_text(json.dumps(receipt,indent=2)+'\n')
    print(receipt['files'],'files',receipt['sha256'])
