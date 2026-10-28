"""Run finite silent R28 profiles sequentially, preserving their own evidence."""
from pathlib import Path
import argparse
import hashlib
import json
import os
import shutil
import sys
from stage_profiles import ROOT,HERE


def campaign(suffix):
    boost=Path('/sys/devices/system/cpu/cpufreq/boost')
    if boost.exists() and boost.read_text().strip()!='0':
        raise RuntimeError('CPU boost is enabled; unattended campaign rejected before launch. Disable boost before retrying.')
    os.environ.update(SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy')
    sys.path.insert(0,str(HERE/'.work/runner'))
    from run_headless import run
    profiles=json.loads((HERE/('PROFILES-'+suffix+'.json')).read_text())
    expected_final=json.loads((HERE/'CONTROL-FINAL.json').read_text())
    evidence=HERE/'evidence'/suffix
    evidence.mkdir(parents=True,exist_ok=False)
    summary={}
    for name,item in profiles.items():
        p=Path(item['profile']);app=p/'sdcard/rally25'
        assert not (p/'last-run').exists(),'Do not replay a profile in this campaign'
        print('Running',name,'headless; video=dummy audio=dummy boost=0',flush=True)
        receipt=run(p,180)
        result=receipt['result']
        assert result['frames']==900 and result['physics_ticks']==3600 and result['validated_reply_records']==2913
        assert result['final_buffers']==expected_final['final_buffers'],'Final state differs from qualified control'
        dst=evidence/name;dst.mkdir()
        for n in ('replies','ticks','prt','clock'):
            shutil.copyfile(app/(n+'.log'),dst/(n+'.bin'))
        for n in ('stats.json','final.ppm','mos-to-vdp.bin','vdp-to-mos.bin','vdp-to-mos-delivered.bin'):
            if (p/'last-run'/n).exists():shutil.copyfile(p/'last-run'/n,dst/n)
        (dst/'verified.json').write_text(json.dumps(result,indent=2)+'\n')
        (dst/'run.json').write_text(json.dumps(receipt,indent=2)+'\n')
        summary[name]=dict(fps=result['observed_fps'],elapsed_mos_units=result['elapsed_mos_ticks'],
            nominal_mos_seconds=result['elapsed_seconds'],prt=result['prt']['nominal_seconds_at_18432000_hz'],
            host_seconds_including_startup=receipt['host_seconds'],backend_stats=receipt['backend_stats'],
            reply_sha256=result['reply_sha256'],final_buffers=result['final_buffers'],
            stack_observations=[x for x in result['observations'] if x['label'].startswith('stack ')],
            boost_after=boost.read_text().strip() if boost.exists() else None,profile=str(p))
        assert all(hashlib.sha256((p/n).read_bytes()).hexdigest()==h for n,h in item['input_sha256'].items())
        if boost.exists():assert boost.read_text().strip()=='0','Boost changed; stop campaign'
        (HERE/('CAMPAIGN-'+suffix+'.json')).write_text(json.dumps(summary,indent=2)+'\n')
        print(name,'PASS',round(result['observed_fps'],3),'nominal MOS FPS',flush=True)


if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--suffix',required=True);a=p.parse_args();campaign(a.suffix)
