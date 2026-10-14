"""Deploy only the Rally hardware fixture to the explicitly selected mounted card."""
from pathlib import Path
import argparse,datetime,hashlib,json,os,shutil,subprocess
HERE=Path(__file__).resolve().parent
FILES=('probe.bin','script.bin','artwork.vdu','assets.vdu','common.vdu','native.vdu','run.txt','expected.json','readme.txt','vdp_rally.bin')
LOGS=('replies.log','ticks.log','prt.log','clock.log','failure.log','verified.json')
FIRMWARE='8da2ebfdfa3b5b00f4a1929ad4885c838845b160f570259792ef370b69d4f473'

def deploy(source,mount,uuid):
    source=Path(source).resolve();mount=Path(mount).resolve()
    state=json.loads(subprocess.check_output(['findmnt','--json','-T',str(mount),'-o','SOURCE,TARGET,FSTYPE,UUID'],text=True))['filesystems']
    assert len(state)==1;fs=state[0]
    assert Path(fs['target']).resolve()==mount and fs['fstype']=='vfat' and fs['uuid']==uuid,fs
    assert hashlib.sha256((source/'vdp_rally.bin').read_bytes()).hexdigest()==FIRMWARE
    assert all((source/n).is_file() and not (source/n).is_symlink() for n in FILES)
    expected=json.loads((source/'expected.json').read_text());assert not expected['paced'] and expected['frames']==900
    target=mount/'test/arcade/rally'
    # Do not follow a preexisting target symlink outside this card/subdirectory.
    assert target.resolve()==target and target.is_relative_to(mount)
    if target.exists():
        saved=HERE/'.work/card-backups'/datetime.datetime.now().strftime('%Y%m%d-%H%M%S')
        saved.mkdir(parents=True)
        for p in target.iterdir():
            assert not p.is_symlink(),p
            if p.is_file():shutil.copy2(p,saved/p.name)
    target.mkdir(parents=True,exist_ok=True)
    for name in FILES:
        # Copy through a same-directory temporary file, then replace only ours.
        temp=target/(name+'.tmp');shutil.copyfile(source/name,temp);os.replace(temp,target/name)
    for name in LOGS:(target/name).unlink(missing_ok=True)
    hashes={n:hashlib.sha256((source/n).read_bytes()).hexdigest() for n in FILES}
    # Normal successful copies are recorded without a redundant full reread.
    assert all((target/n).stat().st_size==(source/n).stat().st_size for n in FILES)
    receipt=dict(schema=1,platform='Console8',mount=fs,card_path='/test/arcade/rally',target=str(target),
                 source_files=hashes,firmware_sha256=FIRMWARE,mode='unpaced900frames/3600physics steps',
                 firmware_flashing='Author manual; not performed',hardware_run='not performed',stale_logs_removed=list(LOGS))
    (target/'deployment.json').write_text(json.dumps(receipt,indent=2)+'\n')
    (HERE/'HARDWARE-DEPLOYMENT.json').write_text(json.dumps(receipt,indent=2)+'\n')
    os.sync();print(json.dumps({'target':str(target),'firmware':str(target/'vdp_rally.bin'),'files':len(FILES),'flashed':False}))
    return receipt
if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--source',required=True);p.add_argument('--mount',required=True);p.add_argument('--uuid',required=True);a=p.parse_args();deploy(a.source,a.mount,a.uuid)
