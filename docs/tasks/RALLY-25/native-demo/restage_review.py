"""Fresh visible-review copy of the accepted native R25 demo; no launch."""
from pathlib import Path
import argparse,hashlib,importlib.util,json,shutil,subprocess
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def stage(name):
    assert Path(name).name==name and name.startswith('rally25-native-review')
    source=ROOT/'.emulator/rally25-native-demo';dest=ROOT/'.emulator'/name;assert not dest.exists()
    pins={n:h for h,n in (line.split('  ',1) for line in (source/'.runtime.sha256').read_text().splitlines())}
    assert all(sha(source/n)==h for n,h in pins.items()),'Accepted source profile changed'
    assert pins['esp32-firmware.bin']=='8da2ebfdfa3b5b00f4a1929ad4885c838845b160f570259792ef370b69d4f473'
    dest.mkdir(parents=True)
    # Materialize all pinned runtime links as files. Preserve old logs/profile;
    # the fresh SD contains only immutable inputs, no inherited success outputs.
    for n in pins:
        q=dest/n;q.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(source/n,q)
    for n in ['.mos-release','.mos-release.sha256','.bespoke-vdp-profile']:shutil.copyfile(source/n,dest/n)
    launcher=dest/'flexe-agon-emulator';body=launcher.read_text()
    body=body.replace('set -euo pipefail','set -euo pipefail\nexport SDL_AUDIODRIVER=dummy',1)
    launcher.write_text(body);launcher.chmod(0o755);(dest/'flexe-agon-emulator.bin').chmod(0o755)
    spec=importlib.util.spec_from_file_location('canonical_flexe',HERE/'.work/flexe_profile.py');namer=importlib.util.module_from_spec(spec);spec.loader.exec_module(namer);namer.name_flexe_profile(dest)
    actual={n:sha(dest/n) for n in pins};assert all(actual[n]==h for n,h in pins.items() if n!='flexe-agon-emulator')
    assert not (dest/'fab-agon-emulator').exists()
    (dest/'.runtime.sha256').write_text(''.join(h+'  '+n+'\n' for n,h in actual.items()))
    subprocess.run(['bash','-n',str(launcher)],check=True)
    receipt=dict(status='fresh-stopped-not-launched',profile=str(dest),source_profile=str(source),
                 source_files=pins,review_files=actual,only_changed_input='launcher: forced silent audio; human launch permits enabled boost',
                 workload='visually accepted Fuji native demo;900frames/3600ticks;flat background',
                 audio='dummy',headless_runs_this_preparation=0,physical_changes=False)
    (dest/'identity.json').write_text(json.dumps(receipt,indent=2)+'\n');(HERE/'RESTAGED-REVIEW.json').write_text(json.dumps(receipt,indent=2)+'\n');print(json.dumps({'status':receipt['status'],'profile':str(dest),'immutable_input_files':len(pins)-1,'audio':'dummy'},indent=2))
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--name',required=True);stage(p.parse_args().name)
