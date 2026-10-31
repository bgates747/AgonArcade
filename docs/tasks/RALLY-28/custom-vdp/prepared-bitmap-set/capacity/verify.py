"""Check returned setup evidence; an actual capacity failure remains a result."""
from pathlib import Path
import csv
import hashlib
import json
import struct

HERE=Path(__file__).resolve().parent


def verify(app):
    app=Path(app)
    expected=json.loads((app/'expected.json').read_text())
    for n,h in expected['files'].items():assert hashlib.sha256((app/n).read_bytes()).hexdigest()==h,n
    r=json.loads((app/'result.json').read_text())
    assert r['kind']=='prepared_capacity' and r['requested']==expected['requested']
    assert 0<=r['registered']<=r['generated']<=r['attempted']<=r['requested']
    assert r['cleaned'] and r['cleanup_absent']==901
    assert r['timer_restored'] and r['unloaded']
    assert r['cleanup_buffers']==r['baseline_buffers'], 'Owned buffer count did not return'
    memory=list(csv.DictReader((app/'memory.csv').open()))
    pixels=list(csv.DictReader((app/'pixels.csv').open()))
    assert memory[0]['stage']=='baseline' and memory[-1]['stage']=='cleanup'
    assert r['pixel_checks']==len(pixels)
    assert all(int(row['expected'])==int(row['actual']) for row in pixels) or not r['valid']
    # Identity and order of the per-image rows prove complete-domain admission;
    # probes on just one favourite traffic size cannot satisfy the full case.
    installed=[int(row['id']) for row in memory if row['stage']=='image']
    if r['valid']:
        assert r['pixel_page'] in (1,2)
        assert r['registered']==r['requested'] and len(installed)==r['requested']
        if r['requested']==901:
            assert installed==list(range(52000,52901)) and r['full_set_fits']
        else:
            assert not r['full_set_fits']
        registrations=[int(row['id']) for row in pixels if row['kind']=='registration']
        assert registrations==installed
        assert (app/'state-before.bin').read_bytes()==(app/'state-after.bin').read_bytes()
        assert len((app/'state-before.bin').read_bytes())==406
        assert r['elapsed_mos_ticks']>0 and r['elapsed_prt']>0
    else:
        assert not r['full_set_fits'] and r['failure']!='none'
    raw=(app/'replies.bin').read_bytes();assert len(raw)%10==0
    for i in range(0,len(raw),10):assert raw[i:i+5]==b'VDPL\1'
    r['retained_psram_delta']=r['baseline_psram']-r['retained_psram']
    r['observed_setup_psram_delta']=r['baseline_psram']-r['minimum_psram']
    r['cleanup_psram_residual']=r['baseline_psram']-r['cleanup_psram']
    r['peak_is_stage_boundary_observation']=True
    r['fps_measured']=False
    (app/'verified.json').write_text(json.dumps(r,indent=2)+'\n')
    return r
