"""Deploy frozen R19 game/stock VDP to the explicitly identified C8 card only."""
from pathlib import Path
import argparse,datetime,hashlib,json,os,shutil,subprocess
HERE=Path(__file__).resolve().parent;INPUTS=HERE/'.work/flexe-inputs'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def deploy(mount):
    mount=mount.resolve(strict=True)
    fs=json.loads(subprocess.check_output(['findmnt','-J','-T',str(mount),'-o','TARGET,SOURCE,FSTYPE,UUID,OPTIONS'],text=True))['filesystems'][0]
    assert Path(fs['target']).resolve()==mount and fs['uuid']=='8658-1C23' and fs['fstype']=='vfat' and 'rw' in fs['options'].split(',')
    protected={n:(mount/n).read_bytes() if (mount/n).exists() else None for n in ['autoexec.txt','!boot.obey']}
    delivery=json.loads((HERE/'FLEXE-INPUTS.json').read_text())
    for n,info in delivery['production_files'].items():assert sha(INPUTS/n)==info['sha256']
    assert sha(INPUTS/'firmware.bin')=='b807beef35823b13a0a056f11b7464cd1b1c6356dce0e4098b78ebe059ded35f'
    dest=mount/'test/rally-19';assert dest.resolve().is_relative_to(mount)
    stamp=datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');backup=HERE/'.work'/('c8-before-'+stamp);backup.mkdir(parents=True,exist_ok=False)
    for n,data in protected.items():
        if data is not None:(backup/(n.replace('!','')+'.before.bin')).write_bytes(data)
    if dest.exists():
        assert dest.is_dir() and not dest.is_symlink();shutil.copytree(dest,backup/'rally-19');shutil.rmtree(dest)
    dest.mkdir(parents=True)
    for n in delivery['production_files']:shutil.copyfile(INPUTS/n,dest/n)
    shutil.copyfile(INPUTS/'firmware.bin',dest/'vdp_rally.bin')
    for track in ['fuji','oval']:(dest/('run-'+track+'.txt')).write_bytes(('CD /test/rally-19\r\nLOAD rally.bin\r\nRUN . '+track+' demo\r\n').encode())
    readme='''RALLY-19 FINAL GOLEM DRIVING PROTOTYPE / CONSOLE8

Exact final production: 95822 bytes, SHA256
64c8b0734bcd253112d162173fc38f343eafbc96894dc1d09b4793766ed59129
Both tracks' original .vdp bootstrap and .clr cleanup files are included.
These game .vdp files are NOT firmware images.

REQUIRED VDP: official stock AgonPlatform VDP 2.16.0.
The application image is included as vdp_rally.bin, 1077840 bytes, SHA256
b807beef35823b13a0a056f11b7464cd1b1c6356dce0e4098b78ebe059ded35f
Install it using the normal Console8 VDP update procedure if another VDP
is currently installed. This deployment did not flash any firmware.
No MOS, startup, bootloader, partition or other game files were changed.

From the Console8 MOS CLI:
EXEC /test/rally-19/run-fuji.txt

For oval instead:
EXEC /test/rally-19/run-oval.txt

Equivalent manual commands:
CD /test/rally-19
LOAD rally.bin
RUN . fuji demo

Demo starts automatically. Press a key to take over; arrows drive,
minus/equal adjust grip; Escape exits. Preserve the game files on SD.
This is the final R19 Golem BUFFERED-COMMAND experiment, not a native Xtensa
VDPlet and not the later R22 title/qualifying/race game. Earlier physical
performance was slow. No fix for the Author's R18 lower-left defect is assumed.
This preserved production intentionally has no benchmark/file telemetry.
'''
    (dest/'readme.txt').write_bytes(readme.replace('\n','\r\n').encode('ascii'))
    (dest/'manifest.json').write_text(json.dumps(delivery,indent=2)+'\n')
    for q in dest.iterdir():
        with q.open('rb') as f:os.fsync(f.fileno())
    os.sync()
    files={q.name:sha(q) for q in dest.iterdir()}
    for n,info in delivery['production_files'].items():assert files[n]==info['sha256']
    assert files['vdp_rally.bin']==sha(INPUTS/'firmware.bin')
    for n,data in protected.items():assert ((mount/n).read_bytes() if (mount/n).exists() else None)==data
    receipt=dict(status='deployed-verified-not-invoked-not-flashed',utc=stamp,filesystem=fs,card_path='/test/rally-19',files=files,track_default='fuji demo',protected_startup_sha256={n:hashlib.sha256(data).hexdigest() if data is not None else None for n,data in protected.items()},startup_unchanged=True,writes_flushed=True,backup=str(backup),mounted=True)
    (HERE/'C8-DEPLOYMENT.json').write_text(json.dumps(receipt,indent=2)+'\n');(HERE/'C8-README.txt').write_bytes((dest/'readme.txt').read_bytes());print(json.dumps(receipt,indent=2))
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--mount',required=True,type=Path);deploy(p.parse_args().mount)
