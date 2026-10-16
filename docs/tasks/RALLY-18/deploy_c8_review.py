"""Copy exact preserved R18 game/data/stock VDP to its dedicated C8 subtree."""
from pathlib import Path
import argparse,datetime,hashlib,json,os,shutil,subprocess
HERE=Path(__file__).resolve().parent;INPUTS=HERE/'.work/flexe-inputs'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def deploy(mount):
    mount=mount.resolve(strict=True);fs=json.loads(subprocess.check_output(['findmnt','-J','-T',str(mount),'-o','TARGET,SOURCE,FSTYPE,UUID,OPTIONS'],text=True))['filesystems'][0]
    assert Path(fs['target']).resolve()==mount and fs['uuid']=='8658-1C23' and fs['fstype']=='vfat' and 'rw' in fs['options'].split(',')
    protected={n:(mount/n).read_bytes() if (mount/n).exists() else None for n in ['autoexec.txt','!boot.obey']}
    expected={'rally.bin':'20622e05c82431b58552be533a749779e30a7e2cfdb7b3352e582896fdf2ab70'}
    expected.update({n:d['sha256'] for n,d in json.loads((HERE/'data/manifest.json').read_text())['files'].items()})
    for n,h in expected.items():assert sha(INPUTS/n)==h
    stock='b807beef35823b13a0a056f11b7464cd1b1c6356dce0e4098b78ebe059ded35f';assert sha(INPUTS/'firmware.bin')==stock
    assert sha(mount/'test/rally-19/vdp_rally.bin')==stock
    # Preserve the entire previous R19 deployment identity during this update.
    r19={q.name:sha(q) for q in (mount/'test/rally-19').iterdir() if q.is_file()}
    dest=mount/'test/rally-18';assert dest.resolve().is_relative_to(mount)
    stamp=datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');backup=HERE/'.work'/('c8-before-'+stamp);backup.mkdir(parents=True,exist_ok=False)
    for n,data in protected.items():
        if data is not None:(backup/(n.replace('!','')+'.before.bin')).write_bytes(data)
    if dest.exists():
        assert dest.is_dir() and not dest.is_symlink();shutil.copytree(dest,backup/'rally-18');shutil.rmtree(dest)
    dest.mkdir(parents=True)
    for n in expected:shutil.copyfile(INPUTS/n,dest/n)
    shutil.copyfile(INPUTS/'firmware.bin',dest/'vdp_rally.bin')
    for track in ['fuji','oval']:(dest/('run-'+track+'.txt')).write_bytes(('CD /test/rally-18\r\nLOAD rally.bin\r\nRUN . '+track+' demo\r\n').encode())
    readme='''RALLY-18 PRESERVED REVIEW / CONSOLE8

Exact historical unfenced review binary: 142838 bytes, SHA256
20622e05c82431b58552be533a749779e30a7e2cfdb7b3352e582896fdf2ab70
Original Fuji/oval road files included. Artwork is embedded in the binary.

REQUIRED VDP: official stock AgonPlatform VDP 2.16.0.
Included application image: vdp_rally.bin, 1077840 bytes, SHA256
b807beef35823b13a0a056f11b7464cd1b1c6356dce0e4098b78ebe059ded35f
This is EXACTLY THE SAME VDP IMAGE as /test/rally-19/vdp_rally.bin.
One correct stock VDP installation serves both versions.
No firmware flashed, startup edited or other game changed by this deployment.

From the Console8 MOS CLI:
EXEC /test/rally-18/run-fuji.txt

For oval instead:
EXEC /test/rally-18/run-oval.txt

Equivalent manual commands:
CD /test/rally-18
LOAD rally.bin
RUN . fuji demo

Demo starts automatically. Press a key to take over; arrows drive,
minus/equal adjust grip; Escape exits. Original four-tick pacing retained.
This is a driving prototype with stock buffered-section rendering, not the
R19 Golem experiment or the R22 complete title/qualifying/race game.
Author reported a lower-left rendering defect under Flexe; it is preserved
for this exact-version comparison. No new hardware FPS/visual claim.
This review binary creates play-ready.viz and play-result.csv/exit.viz on exit;
these are old review hooks, not a qualified new performance fixture.
'''
    (dest/'readme.txt').write_bytes(readme.replace('\n','\r\n').encode('ascii'))
    (dest/'manifest.json').write_text(json.dumps({'source':'exact historical RALLY-18 review','files':expected,'firmware_sha256':stock},indent=2)+'\n')
    for q in dest.iterdir():
        with q.open('rb') as f:os.fsync(f.fileno())
    os.sync();files={q.name:sha(q) for q in dest.iterdir()}
    for n,h in expected.items():assert files[n]==h
    assert files['vdp_rally.bin']==stock and sha(mount/'test/rally-19/vdp_rally.bin')==stock
    assert r19=={q.name:sha(q) for q in (mount/'test/rally-19').iterdir() if q.is_file()}
    for n,data in protected.items():assert ((mount/n).read_bytes() if (mount/n).exists() else None)==data
    receipt=dict(status='deployed-verified-not-invoked-not-flashed',utc=stamp,filesystem=fs,card_path='/test/rally-18',files=files,identical_r19_vdp=True,r19_files_unchanged=True,protected_startup_sha256={n:hashlib.sha256(d).hexdigest() if d is not None else None for n,d in protected.items()},startup_unchanged=True,writes_flushed=True,backup=str(backup),mounted=True)
    (HERE/'C8-DEPLOYMENT.json').write_text(json.dumps(receipt,indent=2)+'\n');(HERE/'C8-README.txt').write_bytes((dest/'readme.txt').read_bytes());print(json.dumps(receipt,indent=2))
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--mount',required=True,type=Path);deploy(p.parse_args().mount)
