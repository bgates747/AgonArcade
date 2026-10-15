"""Fresh Fab profile, pin official MOS/runtime; no launch during preparation."""
from pathlib import Path
import argparse,hashlib,importlib.util,json,shutil
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[5]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def prepare(name):
 assert name.startswith('rally28-span03-') and Path(name).name==name
 p=ROOT/'.emulator'/name;assert not p.exists(),'Choose a fresh profile'
 helper=HERE.parents[1]/'completion-probe/.work/setup_emulator.py'
 if not helper.exists():helper=ROOT.parent/'agon-dev-env/scripts/setup_emulator.py'
 spec=importlib.util.spec_from_file_location('setup',helper);s=importlib.util.module_from_spec(spec);spec.loader.exec_module(s)
 runtime=ROOT.parent/'golem/.emulator/runtime/fab-1.2.5'
 p.mkdir(parents=True);app=p/'sdcard/test/arcade/rally28/spans';app.mkdir(parents=True)
 for n in ('mos_platform.bin','mos_platform.map'):shutil.copyfile(runtime/'firmware'/n,p/n)
 s.verify_latest_mos(p/'mos_platform.bin',p/'mos_platform.map');s.write_mos_identity(p)
 shutil.copyfile(runtime/'fab-agon-emulator',p/'fab-agon-emulator.bin');(p/'fab-agon-emulator.bin').chmod(0o755)
 shutil.copyfile(runtime/'firmware/vdp_platform.so',p/'vdp_platform.so');(p/'.bespoke-vdp-profile').write_text('vdp_platform.so\n')
 s.sync_shared_bin(runtime/'sdcard/bin',p/'sdcard/bin');shutil.copyfile(HERE/'.work/bin/spans.bin',app/'spans.bin')
 (p/'sdcard/autoexec.txt').write_bytes(b'SET KEYBOARD 1\r\nCD /test/arcade/rally28/spans\r\nLOAD spans.bin\r\nRUN .\r\n')
 s.write_profile_launcher(p,strict_bespoke=True)
 launch=p/'fab-agon-emulator';launch.write_text(launch.read_text().replace('set -euo pipefail','set -euo pipefail\nexport SDL_AUDIODRIVER=dummy\nif [[ -e "$(dirname "$0")/sdcard/test/arcade/rally28/spans/done.txt" ]]; then echo "Used fixture; prepare a fresh profile" >&2; exit 2; fi\nif [[ "$(cat /sys/devices/system/cpu/cpufreq/boost)" != 0 ]]; then echo "CPU boost must remain disabled" >&2; exit 2; fi',1))
 files=[launch,p/'fab-agon-emulator.bin',p/'vdp_platform.so',p/'mos_platform.bin',p/'mos_platform.map',p/'sdcard/autoexec.txt',app/'spans.bin']
 hashes={str(f.relative_to(p)):sha(f) for f in files};(p/'.runtime.sha256').write_text(''.join(h+'  '+n+'\n' for n,h in hashes.items()))
 (p/'identity.json').write_text(json.dumps({'files':hashes,'helper_sha256':sha(helper),'runtime':'preserved Fab1.2.5 stock platform module'},indent=2)+'\n');print(p)
if __name__=='__main__':
 a=argparse.ArgumentParser();a.add_argument('name');prepare(a.parse_args().name)
