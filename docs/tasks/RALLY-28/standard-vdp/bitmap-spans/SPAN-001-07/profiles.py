"""Fresh owned emulator only; no physical deployment or startup changes."""
from pathlib import Path
import argparse,shutil,json,hashlib,importlib.util
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[5];sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def prepare(name,variant,live,diag,frames,backend,binary=None):
 assert name.startswith('rally28-road-') and Path(name).name==name
 p=ROOT/'.emulator'/name;assert not p.exists();shutil.copytree(ROOT/'.emulator/rally28-span03-single-write-review',p,symlinks=True)
 (p/'.runtime.sha256').unlink() # Copied template pins are replaced after customization.
 old=p/'sdcard/test/arcade/rally28/spans';app=old.with_name('road');old.rename(app)
 # Discard copied review outputs only inside this newly created owned profile.
 for f in app.iterdir():
  assert f.is_file();f.unlink()
 shutil.copyfile(binary or HERE/'.work/bin/roadbench.bin',app/'roadbench.bin');shutil.copyfile(HERE.parents[1]/'candidates/evidence/data/fuji.road',app/'fuji.road')
 (app/'config.txt').write_text(f'{variant} {live} {diag} {frames}\n');(p/'sdcard/autoexec.txt').write_bytes(b'SET KEYBOARD 1\r\nCD /test/arcade/rally28/road\r\nLOAD roadbench.bin\r\nRUN .\r\n')
 helper=ROOT/'docs/tasks/RALLY-28/standard-vdp/completion-probe/.work/setup_emulator.py';spec=importlib.util.spec_from_file_location('setup',helper);s=importlib.util.module_from_spec(spec);spec.loader.exec_module(s)
 (p/'fab-agon-emulator').unlink();s.write_profile_launcher(p,strict_bespoke=True)
 launch=p/'fab-agon-emulator'
 if backend=='flexe':
  frozen=ROOT/'.emulator/rally28-lookup-buffer-cpu08';(p/'fab-agon-emulator.bin').unlink();shutil.copyfile(frozen/'flexe-agon-emulator.bin',p/'flexe-agon-emulator.bin');shutil.copyfile(frozen/'flexe-vdp.so',p/'flexe-vdp.so');(p/'flexe-agon-emulator.bin').chmod(0o755)
  shutil.copyfile(HERE.parent/'SPAN-001-08/firmware.bin',p/'esp32-firmware.bin');(p/'.bespoke-vdp-profile').write_text('flexe-vdp.so\n')
  text=launch.read_text().replace('fab-agon-emulator','flexe-agon-emulator').replace('fab_bin','flexe_bin')
  text=text.replace('\nvdp_name=', '\nexport AGON_FLEXE_FIRMWARE="$profile_dir/esp32-firmware.bin"\nexport AGON_FLEXE_ENGINE=interp\nexport AGON_FLEXE_ARTIFACTS="$profile_dir/last-run"\nmkdir -p "$AGON_FLEXE_ARTIFACTS"\nunset AGON_FLEXE_ELF\nvdp_name=',1)
  launch.unlink();launch=p/'flexe-agon-emulator';launch.write_text(text);launch.chmod(0o755)
 text=launch.read_text().replace('set -euo pipefail','set -euo pipefail\nexport SDL_AUDIODRIVER=dummy\nif [[ "$(cat /sys/devices/system/cpu/cpufreq/boost)" != 0 ]]; then exit 2; fi',1)
 launch.write_text(text)
 if backend=='flexe':
  spec=importlib.util.spec_from_file_location('canonical_flexe',HERE/'.work/flexe_profile.py');namer=importlib.util.module_from_spec(spec);spec.loader.exec_module(namer);namer.name_flexe_profile(p)
 names=[str(f.relative_to(p)) for f in [launch,p/(backend+'-agon-emulator.bin'),p/('flexe-vdp.so' if backend=='flexe' else 'vdp_platform.so'),p/'mos_platform.bin',p/'mos_platform.map',p/'sdcard/autoexec.txt',*app.iterdir()]]
 if backend=='flexe':names.append('esp32-firmware.bin')
 hashes={n:sha(p/n) for n in names};(p/'.runtime.sha256').write_text(''.join(h+'  '+n+'\n' for n,h in hashes.items()));(p/'identity.json').write_text(json.dumps({'backend':backend,'variant':variant,'live':live,'diagnostic':diag,'frames':frames,'files':hashes},indent=2)+'\n');return p
if __name__=='__main__':
 a=argparse.ArgumentParser();a.add_argument('name');a.add_argument('variant',type=int);a.add_argument('live',type=int);a.add_argument('diag',type=int);a.add_argument('frames',type=int);a.add_argument('backend',choices=['fab','flexe']);x=a.parse_args();print(prepare(x.name,x.variant,x.live,x.diag,x.frames,x.backend))
