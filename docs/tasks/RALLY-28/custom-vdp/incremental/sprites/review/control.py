"""Stage and check the separate review fixture, only silently and headlessly."""
from pathlib import Path
import argparse,hashlib,json,shutil,sys
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[6]  # Oryx is a deployment tree, without .git.
THROUGHPUT=ROOT/'docs/tasks/RALLY-28/custom-vdp/throughput'
sys.path.insert(0,str(THROUGHPUT))

def stage(campaign):
    import stage as tool
    tool.HERE=HERE
    tool.stage(campaign,['motion'])

def run_campaign(campaign):
    pins=json.loads((THROUGHPUT/'RUNNER-PINS.json').read_text())
    assert all(hashlib.sha256((THROUGHPUT/'support'/n).read_bytes()).hexdigest()==h for n,h in pins.items())
    sys.path.insert(0,str(THROUGHPUT/'support'))
    from run_headless import run
    profile=Path(json.loads((HERE/('PROFILES-'+campaign+'.json')).read_text())['motion']['profile'])
    assert not (profile/'last-run').exists()
    result=run(profile,120)
    guest=result['result'];meta=json.loads((profile/'sdcard/rally25/expected.json').read_text())
    assert guest['frames']==900 and guest['physics_ticks']==3600
    assert guest['prt']['previous_vector_restored']
    import struct
    assert list(struct.unpack('<6I',bytes.fromhex(guest['final_buffers']['4'])))==meta['final_scripted_positions']
    assert list(struct.unpack('<6i',bytes.fromhex(guest['final_buffers']['5'])))==meta['fixed_display_lanes']
    root=bytes.fromhex(guest['final_buffers']['1'])
    assert int.from_bytes(root[198:202],'little')==meta['player_final_station']
    dest=HERE/'evidence'/campaign;dest.mkdir(parents=True,exist_ok=False)
    for p in (profile/'last-run').iterdir():
        if p.is_file():shutil.copyfile(p,dest/p.name)
    for name in ('replies','ticks','prt','clock'):
        shutil.copyfile(profile/'sdcard/rally25'/f'{name}.log',dest/f'{name}.bin')
    pins=json.loads((HERE/('PROFILES-'+campaign+'.json')).read_text())['motion']['input_sha256']
    assert all(hashlib.sha256((profile/name).read_bytes()).hexdigest()==digest for name,digest in pins.items())
    (HERE/('CAMPAIGN-'+campaign+'.json')).write_text(json.dumps(dict(passed=True,
        frames=900,physics_ticks=3600,retained_replies=guest['validated_reply_records'],
        scripted_positions_and_lanes_exact=True,independent_player_station_exact=True,
        prt_restored=True,inputs_unchanged=True,result=result,
        timing_disposition='Visual-review derivative only; do not pool with unchanged benchmark'),indent=2)+'\n')

def session(name,campaign):
    import oryx_session as tool
    tool.HERE=HERE;tool.run_campaign=run_campaign
    tool.session(name,[campaign],[])

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('action',choices=['stage','session']);p.add_argument('name');p.add_argument('campaign',nargs='?');a=p.parse_args()
    if a.action=='stage':stage(a.name)
    else:session(a.name,a.campaign)
