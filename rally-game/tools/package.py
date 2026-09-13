"""Package the exact normal build with runtime files at root and source in project_files."""
import argparse,hashlib,json,subprocess,zipfile
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
p=argparse.ArgumentParser(description=__doc__);p.add_argument('output',type=Path);args=p.parse_args()
output=args.output.resolve()
assert output.is_relative_to(ROOT/'.research-cache/rally22'),'Local candidate packages belong in ignored RALLY-22 storage'
assert not output.exists(),'Preserve previous packages; choose a new name'
manifest=json.loads((ROOT/'rally-game/bin/build.json').read_text())
assert not manifest['flags'],'Package only the normal build, with no development/fixture definitions'
sha=lambda data:hashlib.sha256(data).hexdigest()
for path,digest in manifest['inputs'].items():assert sha((ROOT/path).read_bytes())==digest, 'Stale source: '+path
binary=(ROOT/'rally-game/bin/rally.bin').read_bytes();assert sha(binary)==manifest['sha256']
base=subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT,text=True).strip()
files={'rally.bin':binary,**{name:(ROOT/'rally-production'/name).read_bytes() for name in ('oval.road','fuji.road')}}
for pattern in ('rally-game/src/*','rally-game/include/*','rally-game/tests/*','rally-game/tools/*',
                'rally-game/assets/**/*','rally-game/Makefile','rally-game/README.md',
                'rally-production/include/*','rally-production/*.road','rally/assets/**/*',
                'rally/tools/build_car.py','rally/tools/export_car.py','rally/tools/generate_track.py',
                'rally/tools/generate_scenery.py','docs/specifications/*.md'):
 for path in ROOT.glob(pattern):
  if path.is_file() and '__pycache__' not in path.parts:
   files['project_files/'+str(path.relative_to(ROOT))]=path.read_bytes()
files['project_files/COMMIT.txt']=(f'Base commit: {base}\nThis is an UNCOMMITTED RALLY-22 candidate built on that commit.\nExact packaged source and runtime identities are in manifest.json.\n').encode()
files['project_files/build.json']=json.dumps(manifest,indent=2).encode()+b'\n'
files['project_files/README.md']=b'''# Agon Rally candidate source

This package contains an uncommitted full-game candidate for Author review.
The base Git revision is in COMMIT.txt; manifest.json identifies every file.
The runtime and player instructions are one directory above this one.

Install agondev and put agondev-config on PATH. From this project_files directory:

```sh
python3 -m venv .venv
.venv/bin/python -m pip install -r rally-game/tools/requirements.txt
make -C rally-game
make -C rally-game test
make -C rally-game assets
```

The rebuilt executable is rally-game/bin/rally.bin. Copy it to the runtime
folder with both .road files. The accepted renderer headers/road data live in
rally-production; generated inputs are supplied, so Blender is not needed to
build the game. Older editable car, track and scenery sources/tools are under
rally/ for reference; the complete repository documents their regeneration.
New original font, traffic and sign inputs/generators are under rally-game.
Read rally-game/README.md and assets/CREDITS.md there for controls, architecture,
assets and test details. Native capture scripts need the full checkout, shared
agon-dev-env setup, and a separately installed official Fab runtime.

Source and assets are included for review. Third-party marks retain their
respective rights. This candidate has not been approved for publication.
'''
files['readme.txt']=b'''AGON RALLY - full-game review candidate

Copy rally.bin, oval.road and fuji.road together to a directory on your Agon SD
card. At MOS, CD to that directory, then:
  LOAD rally.bin
  RUN . oval

Starts in title/demo mode. Press any key for race selection. Left/right choose
oval or Fuji; up/down choose circuit race or arcade traffic. Space/Return starts.
Complete a qualifying lap, then six oval race laps or two Fuji race laps.
Crossing each unfinished race lap adds time. Contact with traffic causes a crash.

While driving: arrows left/right steer, up accelerates, down brakes. Minus and
equals adjust grip. M toggles engine sound. Escape returns to the title; release
and press Escape again to exit to MOS. Space/Return retries after a result.

Optional RUN arguments (all optional, space-separated):
  oval / fuji       Track; default oval.
  circuit / arcade  Stable race opponents / triggered traffic; default circuit.
  steer1 / steer2   Held steering increments per frame; default two.
  mute              Start with sound disabled.
  demo              Compatibility alias for the default title/demo launch.
Last track, traffic-mode or steering choice wins. Default grip is 60%; adjustable
25-200%. Best scores/laps are separated by track, mode, steering step and highest
grip used. Optional rally.sav holds records; rally.bak preserves a previous copy.
Missing saves or save errors do not stop play.

Requires stock-compatible MOS 3.0.2 / VDP 2.16.0 graphics, mode 136 (320x240).
No custom firmware is required. This normal build contains no test or diagnostic
options. New gameplay/graphics and balance still require Author review.

Runtime files are at archive root; project_files contains all source/build
materials. project_files/COMMIT.txt records the base Git revision (this candidate
includes uncommitted changes); manifest.json contains exact file hashes.
'''
identity={'base_commit':base,'status':'uncommitted review candidate; not approved for publication',
          'binary_sha256':manifest['sha256'],'files':{name:sha(data) for name,data in sorted(files.items())}}
files['manifest.json']=json.dumps(identity,indent=2).encode()+b'\n'
output.parent.mkdir(parents=True,exist_ok=True)
with zipfile.ZipFile(output,'x',compression=zipfile.ZIP_DEFLATED) as archive:
 for name,data in sorted(files.items()):archive.writestr(name,data)
with zipfile.ZipFile(output) as archive:
 assert archive.testzip() is None
 for name,digest in identity['files'].items():assert sha(archive.read(name))==digest
print(f'{output}: {len(files)} files, SHA256 {sha(output.read_bytes())}')
