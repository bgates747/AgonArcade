"""Fresh matched Oryx runs, with the pinned silent runner and thermal supervisor."""
from pathlib import Path
import argparse,hashlib,json,shutil,struct,sys
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[6]
THROUGHPUT=ROOT/'docs/tasks/RALLY-28/custom-vdp/throughput'
sys.path.insert(0,str(THROUGHPUT))
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()

def stage(campaign,cases):
    import stage as tool
    tool.HERE=HERE;tool.stage(campaign,cases)

def run_campaign(campaign):
    pins=json.loads((THROUGHPUT/'RUNNER-PINS.json').read_text())
    assert all(sha(THROUGHPUT/'support'/n)==h for n,h in pins.items())
    sys.path.insert(0,str(THROUGHPUT/'support'))
    from run_headless import run
    profiles=json.loads((HERE/('PROFILES-'+campaign+'.json')).read_text())
    summary={};reference_path=HERE/'CONTROL-FINAL.json'
    for name,info in profiles.items():
        profile=Path(info['profile']);app=profile/'sdcard/rally25'
        assert not (profile/'last-run').exists(),'Preserve previous runs'
        assert all(sha(profile/n)==h for n,h in info['input_sha256'].items())
        print('Running',campaign,name,'video=dummy audio=dummy boost=0',flush=True)
        dest=HERE/'evidence'/campaign/name;dest.mkdir(parents=True,exist_ok=False)
        try:
            receipt=run(profile,180);guest=receipt['result']
            meta=json.loads((app/'expected.json').read_text())
            assert guest['frames']==900 and guest['physics_ticks']==3600
            assert guest['validated_reply_records']==2913
            assert guest['prt']['previous_vector_restored']
            final=guest['final_buffers']
            assert list(struct.unpack('<6I',bytes.fromhex(final['4'])))==meta['final_scripted_positions']
            assert list(struct.unpack('<6i',bytes.fromhex(final['5'])))==meta['fixed_display_lanes']
            root=bytes.fromhex(final['1'])
            assert int.from_bytes(root[198:202],'little')==meta['player_final_station']
            if not reference_path.exists():
                assert name=='affine'
                reference_path.write_text(json.dumps(final,indent=2)+'\n')
            assert final==json.loads(reference_path.read_text()),'Full final state differs'
            wire=(profile/'last-run/mos-to-vdp.bin').read_bytes()
            done=wire.rfind(b'RALLY-25 DONE: logs saved.');prompt=wire.find(b'/rally25 *',done)
            assert done>=0 and prompt>done
            assert wire[done-5:done]==bytes([26,12,31,0,0])
            summary[name]=dict(passed=True,frames=900,physics_ticks=3600,retained_replies=2913,
                nominal_mos_seconds=guest['elapsed_seconds'],nominal_mos_fps=guest['observed_fps'],
                prt=guest['prt'],host_seconds_including_startup=receipt['host_seconds'],
                full_final_state_exact=True,scripted_positions_lanes_and_independent_player_exact=True,
                clean_mos_return=True,process_exit=receipt['process_exit'],backend_stats=receipt['backend_stats'],
                input_hashes_preserved=all(sha(profile/n)==h for n,h in info['input_sha256'].items()))
            assert summary[name]['input_hashes_preserved']
            print(name,'PASS',round(guest['observed_fps'],3),'nominal MOS FPS',flush=True)
        except BaseException as exc:
            summary[name]=dict(passed=False,error=repr(exc));raise
        finally:
            for p in (profile/'last-run').iterdir():
                if p.is_file():shutil.copyfile(p,dest/(p.with_suffix('.txt').name if p.suffix=='.log' else p.name))
            for name_log in ('replies','ticks','prt','clock','failure'):
                p=app/(name_log+'.log')
                if p.exists():shutil.copyfile(p,dest/(name_log+'.bin'))
            (HERE/('CAMPAIGN-'+campaign+'.json')).write_text(json.dumps(summary,indent=2)+'\n')

def session(name,campaigns):
    import oryx_session as tool
    tool.HERE=HERE;tool.run_campaign=run_campaign
    tool.session(name,campaigns,[])

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('action',choices=['stage','session']);p.add_argument('name');p.add_argument('items',nargs='+');a=p.parse_args()
    if a.action=='stage':stage(a.name,a.items)
    else:session(a.name,a.items)
