"""Join qualified returns without replacing the preserved failed startup."""
import json
from build_candidates import HERE

if __name__=='__main__':
    builds=json.loads((HERE/'CANDIDATE-BUILD.json').read_text())
    combined={}
    for suffix in ('auto01','finish01','aligned01'):
        campaign=json.loads((HERE/('CAMPAIGN-'+suffix+'.json')).read_text())
        profiles=json.loads((HERE/('PROFILES-'+suffix+'.json')).read_text())
        for name,row in campaign.items():
            assert name not in combined and row['boost_after']=='0'
            assert row['backend_stats']['engine']=='jit'
            assert not any(row['backend_stats'][k] for k in ('failed','unhandled','unregistered','unmapped'))
            for file,digest in builds[name]['fixture_files'].items():
                if file!='run.txt':assert profiles[name]['input_sha256']['sdcard/rally25/'+file]==digest
            row['campaign_suffix']=suffix;combined[name]=row
    assert set(combined)==set(builds)
    combined={name:combined[name] for name in builds}
    for row in combined.values():assert row['final_buffers']==combined['control']['final_buffers']
    (HERE/'CAMPAIGN-qualified.json').write_text(json.dumps(combined,indent=2)+'\n')
    print('Qualified',len(combined),'variants; startup failure retained separately')
