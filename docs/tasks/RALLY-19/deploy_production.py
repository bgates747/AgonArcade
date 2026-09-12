"""Deploy the explicitly requested oval/demo production build to physical AGON."""
import argparse,json,os,shutil,subprocess,tempfile
from pathlib import Path
from profile import TASK
from native_run import sha

def atomic(path,data):
    fd,name=tempfile.mkstemp(prefix='r19-',suffix='.tmp',dir=path.parent)
    try:
        with os.fdopen(fd,'wb') as f:f.write(data);f.flush();os.fsync(f.fileno())
        os.replace(name,path)
    finally:Path(name).unlink(missing_ok=True)

def production_files(work):
    """Validate either original production output or its stack-fix derivative."""
    if (work/'hardware-manifest.json').exists():
        manifest=json.loads((work/'hardware-manifest.json').read_text())
        parent=Path(manifest['parent'])
        parent_manifest=json.loads((parent/'manifest.json').read_text())
        assert not any(parent_manifest[k] for k in ['fencing','logging','performance_counters'])
        assert manifest['unchanged_production_source']
        assert (work/'src/main.cpp').read_bytes()==(parent/'src/main.cpp').read_bytes()
        assert (work/'Makefile').read_bytes()==(parent/'Makefile').read_bytes()
        assert {p.name for p in (work/'include').iterdir()}=={p.name for p in (parent/'include').iterdir()}
        for header in (work/'include').iterdir():
            if header.name!='scene_assets.hpp':
                assert header.read_bytes()==(parent/'include'/header.name).read_bytes(),header
        for relative,digest in manifest['sha256'].items():
            source=(work/relative).resolve();assert source.is_relative_to(work.resolve())
            assert sha(source)==digest,source
        manifest_path=work/'hardware-manifest.json'
    else:
        manifest_path=work/'manifest.json';manifest=json.loads(manifest_path.read_text())
        assert not any(manifest[k] for k in ['fencing','logging','performance_counters'])
        for path,digest in {**manifest['source_hashes'],**manifest['outputs']}.items():
            assert sha(Path(path))==digest,path
    return [work/'bin/rally.bin',work/'oval.vdp',work/'oval.clr'],manifest_path

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--build',required=True);a=p.parse_args()
    card=Path('/media/smith/AGON')
    assert card.is_mount() and not card.is_symlink()
    assert subprocess.check_output(['findmnt','-n','-o','LABEL','--target',str(card)],text=True).strip()=='AGON'
    work=TASK/'.work/production'/a.build
    files,manifest_path=production_files(work)
    root=TASK/'evidence/hardware-production'/a.name;root.mkdir(parents=True,exist_ok=False)
    backup=TASK/'.work/hardware-backup'/a.name;backup.mkdir(parents=True,exist_ok=False)
    destination=card/'mystuff/arcade/rally';assert destination.resolve()==destination
    destination.mkdir(parents=True,exist_ok=True)
    auto=card/'autoexec.txt';assert auto.is_file() and not auto.is_symlink()
    previous=auto.read_bytes();(backup/'autoexec.txt').write_bytes(previous);(root/'autoexec-before.txt').write_bytes(previous)
    # The Author now owns an accepted launch script with EMOS keyboard disabled.
    # Preserve it byte-for-byte: normalising escapes once activated an unrelated
    # EMOS command and contaminated the startup investigation.
    deployed={}
    for source in files:
        target=destination/source.name;assert not target.is_symlink()
        if target.exists():shutil.copy2(target,backup/target.name)
        atomic(target,source.read_bytes());deployed[str(target)]={'bytes':source.stat().st_size,'sha256':sha(source)}
    os.sync()
    for src,name in [(manifest_path,'build.json'),(work/'src/main.cpp','production.cpp'),(work/'include/golem_renderer.hpp','golem_renderer.hpp')]:shutil.copy2(src,root/name)
    report={'authorization':'Author explicitly requested physical-card deployment and then authorized hardware reset diagnosis and correction.',
        'deployed':deployed,'autoexec_unchanged':True,'autoexec_sha256':__import__('hashlib').sha256(previous).hexdigest(),
        'backup':str(backup),'synced':True,'hardware_validation':'Pending physical stock-stack and official-release VDP test.'}
    (root/'deployment.json').write_text(json.dumps(report,indent=2)+'\n')
    print('Deployed production oval/demo to',destination,'and synced card; autoexec preserved.')
if __name__=='__main__':main()
