from pathlib import Path
import json
p=Path('/home/smith/Agon/mystuff/AgonArcade/.emulator/rally28-hz60-rhp01-cached')
assert p.parent.is_dir();assert not p.exists() and not p.is_symlink(), 'Preserve any existing profile'
p.mkdir()
print(json.dumps(dict(created=str(p),file_only=True,emulator_executed=False,custody_acquired=False),indent=2))
