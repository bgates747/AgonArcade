"""Copy an exact task-local bundle to Oryx; never launch or touch physical hardware."""
from pathlib import Path
import argparse,hashlib,json,subprocess,tarfile
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[3];WORK=HERE/'.work'
def stage(host):
    files={p.relative_to(HERE).as_posix():p for p in HERE.glob('*.py')}
    files.update({p.relative_to(HERE).as_posix():p for p in (WORK/'fixtures').rglob('*') if p.is_file()})
    files['.work/setup_emulator.py']=ROOT.parent/'agon-dev-env/scripts/setup_emulator.py'
    fw=ROOT.parent/'agon-vdplet/build/firmware/firmware-src/.pio/build/esp32dev'
    files.update({'.work/firmware.'+ext:fw/('firmware.'+ext) for ext in ('bin','elf')})
    manifest={n:hashlib.sha256(p.read_bytes()).hexdigest() for n,p in files.items()}
    (WORK/'bundle-manifest.json').write_text(json.dumps(manifest,indent=2)+'\n');files['.work/bundle-manifest.json']=WORK/'bundle-manifest.json'
    archive=WORK/'bundle.tar.gz'
    with tarfile.open(archive,'w:gz') as t:
        for n,p in files.items():t.add(p,arcname=n,recursive=False)
    dest='Agon/mystuff/AgonDefender/docs/tasks/RALLY-24/flexe'
    subprocess.run(['ssh','-o','BatchMode=yes',host,'mkdir','-p',dest],check=True)
    subprocess.run(['scp','-o','BatchMode=yes',str(archive),host+':'+dest+'/bundle.tar.gz'],check=True)
    # No shell interpolation of filesystem paths supplied by a user.
    verify='''import hashlib,json,tarfile,subprocess,sys
from pathlib import Path
p=Path.home()/'Agon/mystuff/AgonDefender/docs/tasks/RALLY-24/flexe'
with tarfile.open(p/'bundle.tar.gz') as t:t.extractall(p,filter='data')
for n,h in json.loads((p/'.work/bundle-manifest.json').read_text()).items():
 assert hashlib.sha256((p/n).read_bytes()).hexdigest()==h,n
subprocess.run([sys.executable,'-m','venv','--without-pip',str(p.parents[3]/'.venv')],check=True)
print('Bundle verified; project Python environment ready')
'''
    subprocess.run(['ssh','-o','BatchMode=yes',host,'python3','-'],input=verify,text=True,check=True)
if __name__=='__main__':
    a=argparse.ArgumentParser();a.add_argument('--host',required=True);stage(a.parse_args().host)
