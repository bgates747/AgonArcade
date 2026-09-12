"""Audit the completed R19-07 road evidence against the frozen metrics.

R19-08 onward remain separate: no traffic, scenery, full-scene performance or
hardware acceptance follows from this road-only qualification.
"""
from pathlib import Path
import hashlib,json,struct
from profile import TASK
from native_run import GOLEM
from scene_masks import game_image
from visual_metric import compare,road_geometry
from visual_road import poses,mask
from road_outline_metric import compare as outline,calibrate
from road_bounds import proof

VISUALS=[('oval','covered-clear-oval',0,30),
         ('fuji','covered-clear-fuji-a',0,30),
         ('fuji','covered-clear-fuji-b',30,21)]
RESOURCE_KEYS={'bootstrap_bytes','resident_payload_bytes','owned_ids',
               'asset_payload_bytes','program_payload_bytes','scratch_payload_bytes',
               'resident_plus_bootstrap_payload_bytes','cleanup_bytes'}

def digest(path):return hashlib.sha256(path.read_bytes()).hexdigest()

def main():
    evidence={};all_cases=[];kernels={};resources={};seen={t:[] for t in ['oval','fuji']}
    def record(path):
        evidence[str(path.relative_to(TASK))]=digest(path)
        return path
    def read(path):return json.loads(record(path).read_text())
    frozen=read(TASK/'evidence/golem-road/outline-calibration.json')
    assert frozen['source_sha256']==digest(TASK/'road_outline_metric.py')
    assert all(calibrate().values()) and all(frozen['calibration'].values())
    bounds=read(TASK/'evidence/golem-road-bounds.json');assert bounds==proof()
    for track,name,start,count in VISUALS:
        root=TASK/'evidence/golem-road-visual'/name
        inputs=read(root/'inputs.json');expected_poses=[list(p) for p in poses(track)[start:start+count]]
        assert inputs['admitted'] and inputs['track']==track and inputs['cases']==expected_poses
        for filename,sha in inputs['source_hashes'].items():assert digest(Path(filename))==sha,filename
        seen[track].extend(expected_poses)
        report=read(root/'results.json');edges=read(root/'outline-results.json')
        assert report['pass'] and edges['pass'] and report['cases']==edges['cases']==count
        assert edges['source_sha256']==frozen['source_sha256']
        kernel=digest(record(root/'kernel.golem'))
        assert kernels.setdefault(track,kernel)==kernel
        ledger={line.split()[0]:int(line.split()[1]) for line in record(root/'program.map').read_text().splitlines() if line.split()[0] in RESOURCE_KEYS}
        assert resources.setdefault(track,ledger)==ledger
        assert ledger['owned_ids']<=1024 and ledger['asset_payload_bytes']<=512*1024
        assert ledger['program_payload_bytes']<=128*1024 and ledger['scratch_payload_bytes']<=64*1024
        assert ledger['resident_plus_bootstrap_payload_bytes']<=1024*1024
        images=[];native_geometry=[];files=[]
        for variant in ['oracle','candidate']:
            manifest=read(root/variant/'manifest.json')
            assert manifest['headless'] and manifest['runtime_inputs_unchanged'] and not manifest['timed_out']
            assert record(root/variant/'guest-exit.viz').read_text().strip()=='0'
            raw=record(root/variant/'guest-geometry.dat').read_bytes();offset=0;geometry=[]
            for _ in range(count):
                bands=struct.unpack_from('<H',raw,offset)[0];offset+=2;assert 0<bands<=32
                rows=[list(struct.unpack_from('<HhH',raw,offset+6*i)) for i in range(bands+1)]
                offset+=6*(bands+1);geometry.append(rows)
            assert offset==len(raw);native_geometry.append(geometry)
            captures=manifest['captures'];assert len(captures)==count
            files.append([item['file'] for item in captures]);images.append([])
            for item in captures:
                path=record(root/variant/item['file']);assert digest(path)==item['sha256']
                images[-1].append(game_image(path))
        assert files[0]==files[1]
        for i,(case,saved,edge) in enumerate(zip(expected_poses,report['results'],edges['results'])):
            eg,ag=[g[i] for g in native_geometry];ei,ai=[v[i] for v in images]
            assert saved['pose']==case and saved['expected_geometry']==eg and saved['actual_geometry']==ag
            assert [r[0] for r in eg]==[r[0] for r in ag]
            assert [r[2] for r in eg[:-1]]==[r[2] for r in ag[:-1]]
            geometry=road_geometry([[r[0],r[1]*256] for r in eg],[[r[0],r[1]*256] for r in ag])
            pixels=compare(ei,ai,mask(ei,eg),mask(ai,ag));boundary=outline(ei,ai)
            assert geometry==saved['geometry'] and pixels==saved['pixels']
            assert boundary=={k:v for k,v in edge.items() if k!='file'} and edge['file']==files[0][i]
            assert geometry['pass'] and pixels['pass'] and boundary['pass']
            # Explicitly cover the other half-open clear edge outside road masks.
            assert all(ai.getpixel((x,104))==(0,170,0) for x in range(320))
            assert all(ai.getpixel((x,y))==(0,0,0) for y in range(224,240) for x in range(320))
            all_cases.append({'track':track,'pose':case,'geometry':geometry,'pixels':pixels,'outline':boundary})
    assert all(seen[t]==[list(p) for p in poses(t)] for t in seen)
    assert len(all_cases)==81
    admission={}
    for track in ['oval','fuji']:
        root=TASK/'evidence/golem-admitted-road'/('covered-clear-'+track)
        result=read(root/'results.json');identity=read(root/'identity.json');manifest=read(root/'manifest.json')
        assert manifest['command']==['./fab-agon-emulator','--renderer','sw']
        assert all(manifest['runtime_after'].get(k)==v for k,v in manifest['runtime_before'].items())
        assert result['pass'] and result['track']==track and result['cases']==210 and result['accepted']==27
        assert all(r['pass'] for r in result['results'])
        assert digest(record(root/'kernel.golem'))==kernels[track]
        assert any(Path(k).suffix=='.golem' and v==kernels[track] for k,v in identity.items())
        assert identity[str(GOLEM/'src/hosted.hpp')]==digest(GOLEM/'src/hosted.hpp')
        assert identity[str(GOLEM/'src/golemc.cpp')]==digest(GOLEM/'src/golemc.cpp')
        assert record(root/'guest-exit.txt').read_text().strip()=='0'
        raw=record(root/'guest-results.dat').read_bytes();events=read(root/'cases.json')
        assert len(raw)==len(events)*384 and len(events)==210
        last=bytes(288)
        for i,(event,row) in enumerate(zip(events,result['results'])):
            value=raw[i*384:(i+1)*384];assert value[:96]==bytes.fromhex(event['expected'])
            assert row['accepted']==event['accepted'] and row['name']==event['name']
            if event['kind']==1:last=bytes(288)
            if event['accepted']:
                n,active=struct.unpack_from('<HH',value,156);flags=struct.unpack_from('<5H',value,176)
                assert 0<n<=32 and active==0 and flags==(1,1,1,1,1)
                entries=[list(struct.unpack_from('<HhH',value,186+6*j)) for j in range(n+1)]
                assert entries==row['actual'] and row['max_centre_error']<=1
                want=row['oracle'];assert len(entries)==len(want)
                assert [r[0] for r in entries]==[r[0] for r in want]
                assert [r[2] for r in entries[:-1]]==[r[2] for r in want[:-1]]
                assert max(abs(a[1]-b[1]) for a,b in zip(entries,want))==row['max_centre_error']
                last=value[96:]
            else:assert value[96:]==last
        admission[track]={'events':210,'accepted':27,'nonaccepted_events':183,
                          'explicit_reload_resets_road':1,'other_nonaccepted_events_preserve_road':182}
    regions={key:min(r['pixels']['regions'][key]['one_pixel_fraction'] for r in all_cases if key in r['pixels']['regions']) for key in ['asphalt','kerb','shoulder','centreline']}
    report={'milestone':'R19-07','pass':True,'scope':__doc__,
            'audit_source_sha256':digest(Path(__file__)),
            'visual_cases':81,'frozen_poses':66,'supplemental_seam_and_bound_poses':15,
            'maximum_centre_error_pixels':max(r['geometry']['max_centerline_error_pixels'] for r in all_cases),
            'maximum_outer_edge_error_pixels':max(r['outline']['max_edge_error_pixels'] for r in all_cases),
            'minimum_material_one_pixel_agreement':regions,'admission':admission,
            'resources_traced_admitted_road':resources,
            'recurring_scene_uart':{'state_payload':80,'update_header':11,'call':6,'swap':3,'total':100,
                'exclusions':'Diagnostic GP, trace readback and harness sequencing; HUD/scenery/vehicles integrate in later milestones.'},
            'compiler_source_sha256':{str(GOLEM/'src'/name):digest(GOLEM/'src'/name) for name in ['golemc.cpp','hosted.hpp']},
            'finite_band_limits':{t:bounds['tracks'][t]['max_sections'] for t in bounds['tracks']},
            'failed_attempts_retained':['golem-road-visual/admitted-oval/outline-results.json','golem-road-visual/admitted-fuji-a/outline-results.json','golem-road-visual/clipped-clear-oval/clear-coverage-failure.json'],
            'fix':'Resident triangle clears use right extent320 and top103/223 to cover physical rows104/224. Old319 extent left stale right-column pixels; old104/224 top coordinates excluded the first row. Frozen road metrics unchanged; complete clear-row invariants additionally checked.',
            'evidence':evidence}
    destination=TASK/'evidence/golem-road/qualification.json';assert not destination.exists()
    destination.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({k:v for k,v in report.items() if k not in ['evidence','scope']},indent=2))

if __name__=='__main__':main()
