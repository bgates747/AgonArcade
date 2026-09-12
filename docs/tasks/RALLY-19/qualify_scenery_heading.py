"""Audit numeric heading evidence; does not qualify scenery rendering or timing."""
import hashlib,json,subprocess
from pathlib import Path
from profile import TASK
from native_run import GOLEM,sha
from probe_scenery_heading import fixtures

def main():
    root=TASK/'evidence/golem-scenery-heading';destination=root/'qualification.json'
    assert not destination.exists()
    covered={'oval':[],'fuji':[]};runs=[]
    for name in ['intervals-oval','intervals-fuji-a','intervals-fuji-b']:
        d=root/name;r=json.loads((d/'results.json').read_text());assert r['pass']
        rows=r['results'];raw=(d/'guest-results.dat').read_bytes();assert len(raw)==183*len(rows)
        for i,row in enumerate(rows):
            assert row['pass'] and raw[i*183:(i+1)*183].hex()==row['expected_hex']==row['actual_hex']
        covered[r['track']].extend(row['case'] for row in rows)
        identities=json.loads((d/'identity.json').read_text())
        for path,digest in identities.items():
            if path=='case_bytes':continue
            assert sha(Path(path))==digest,path
        manifest=json.loads((d/'manifest.json').read_text())
        # The post-run inventory also contains newly generated guest outputs.
        assert all(manifest['runtime_after'].get(k)==v for k,v in manifest['runtime_before'].items())
        lines=(d/'program.map').read_text().splitlines()
        ledger={k:int(next(l.split()[1] for l in lines if l.startswith(k+' '))) for k in
                ['owned_ids','resident_payload_bytes','bootstrap_bytes','program_payload_bytes','scratch_payload_bytes']}
        assert ledger['owned_ids']<=1024
        runs.append({'name':name,'track':r['track'],'cases':len(rows),'ledger':ledger,
                     'results_sha256':sha(d/'results.json'),'readback_sha256':sha(d/'guest-results.dat'),
                     'identity_sha256':sha(d/'identity.json')})
    for track,names in covered.items():assert names==[c['name'] for c in fixtures(track)]
    source_paths=[Path(__file__),TASK/'probe_scenery_heading.py',TASK/'host_scenery_heading.cpp',
                  TASK/'build_scenery_heading.py',TASK/'evidence/golem-scenery-proof/fraction-and-direct/results.json']
    report={'scope':__doc__,'pass':True,'cases':sum(len(v) for v in covered.values()),'runs':runs,
            'compiler_commit':subprocess.check_output(['git','-C',str(GOLEM),'rev-parse','HEAD']).decode().strip(),
            'source_hashes':{str(p):sha(p) for p in source_paths},
            'remaining':'History, viewport/scroll, full-scene images, frontend, timing and stability are not qualified.'}
    destination.write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))

if __name__=='__main__':main()
