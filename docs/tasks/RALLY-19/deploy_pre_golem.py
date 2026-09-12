"""Replace Rally on the mounted AGON card with the stripped pre-Golem game."""
import json,os,shutil,subprocess
from pathlib import Path
from profile import TASK
from native_run import sha
from deploy_production import atomic

def main():
    card=Path('/media/smith/AGON')
    assert card.is_mount() and not card.is_symlink()
    assert subprocess.check_output(['findmnt','-n','-o','LABEL','--target',str(card)],text=True).strip()=='AGON'
    work=TASK/'.work/production/pre-golem-oval'
    manifest=json.loads((work/'manifest.json').read_text())
    assert manifest['base_commit']=='949f6186853ab99f257906e95786593a7a2e098f'
    assert manifest['headers_exact'] and manifest['controls_and_art_extracted_exact']
    assert not any(manifest[k] for k in ['fencing','logging','performance_counters'])
    for p,digest in {**manifest['source_hashes'],**manifest['outputs']}.items():assert sha(Path(p))==digest,p
    evidence=TASK/'evidence/hardware-production/pre-golem-oval'
    assert not (evidence/'deployment.json').exists()
    assert (evidence/'stock-vdp-verify.log').read_text().count('verify OK (digest matched)')==3
    capture=json.loads((evidence/'capture/manifest.json').read_text())
    assert capture['returncode']==0 and not capture['timed_out'] and capture['runtime_inputs_unchanged']
    backup=TASK/'.work/hardware-backup/pre-golem-oval';backup.mkdir(parents=True,exist_ok=False)
    target=card/'mystuff/arcade/rally'
    assert target.is_dir() and target.resolve()==target
    auto=card/'autoexec.txt';assert auto.is_file() and not auto.is_symlink()
    before=auto.read_bytes()
    assert before.count(b'#EMOS KEYINPUT extender\r\n')==1
    assert b'\\r' not in before and b'\\n' not in before
    after=before.replace(b'#EMOS KEYINPUT extender\r\n',b'EMOS KEYINPUT extender\r\n')
    assert b'cd /mystuff/arcade/rally\r\nload rally.bin\r\nrun . oval demo\r\n' in after
    (backup/'autoexec.txt').write_bytes(before)
    (evidence/'autoexec-before.txt').write_bytes(before)
    deployed={}
    for source in [work/'bin/rally.bin',work/'oval.road',work/'fuji.road']:
        dest=target/source.name;assert not dest.is_symlink()
        if dest.exists():shutil.copy2(dest,backup/dest.name)
        atomic(dest,source.read_bytes())
        deployed[source.name]={'sha256':sha(source),'bytes':source.stat().st_size}
    atomic(auto,after);os.sync()
    (evidence/'autoexec-after.txt').write_bytes(after)
    shutil.copy2(work/'manifest.json',evidence/'build.json')
    shutil.copy2(work/'src/main.cpp',evidence/'production.cpp')
    report={'authorization':'Author requested latest pre-Golem eZ80 renderer replacing existing game, oval/demo without diagnostics, stock VDP and enabled extender keyboard.',
        'destination':str(target),'deployed':deployed,'backup':str(backup),'synced':True,
        'autoexec_only_change':'Uncomment EMOS KEYINPUT extender; all other bytes and CRLF preserved.',
        'autoexec_sha256':sha(auto),'firmware':'Official stock VDP2.16.0; all3 segments independently verified without rewriting flash.',
        'physical_game_validation':'Pending Author test; onboard USB keyboard circuit damaged, extender keyboard is required.',
        'unused_golem_data':'Existing VDP/CLR files retained but not loaded by this program.'}
    (evidence/'deployment.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report,indent=2))
if __name__=='__main__':main()
