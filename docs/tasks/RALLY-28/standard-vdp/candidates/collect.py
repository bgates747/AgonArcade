"""Retrieve an already-stopped owned profile, preserving its exact app/runtime receipt."""
from pathlib import Path
import argparse,subprocess
HERE=Path(__file__).resolve().parent
REMOTE='/home/smith/Agon/mystuff/AgonArcade/.emulator/'
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('profile');p.add_argument('variant');p.add_argument('kind');a=p.parse_args()
    assert a.profile.startswith('rally28-') and Path(a.profile).name==a.profile
    assert a.variant in ('dense','lookup','lookup-buffer','coarse','coarse-buffer') and Path(a.kind).name==a.kind
    dest=HERE/'evidence'/a.variant/a.kind;dest.mkdir(parents=True,exist_ok=True)
    subprocess.run(['rsync','-a','oryx-linuxlite:'+REMOTE+a.profile+'/sdcard/test/arcade/rally28/candidate/',str(dest)+'/'],check=True)
    (dest/'runtime').mkdir(exist_ok=True)
    subprocess.run(['rsync','-a','oryx-linuxlite:'+REMOTE+a.profile+'/last-run/',str(dest/'runtime')+'/'],check=True)
    subprocess.run(['rsync','-a','oryx-linuxlite:'+REMOTE+a.profile+'/identity.json',str(dest/'runtime/profile-identity.json')],check=True)
