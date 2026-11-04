"""One separately prepared runtime cohort; no implicit deployment or execution."""
from pathlib import Path
import hashlib
import importlib.util
import json

HERE = Path(__file__).resolve().parent
FULL = HERE.parent / 'full-comparison'
HUD = HERE.parent.parent
CUSTOM = HUD.parents[1]
ROOT = CUSTOM.parents[3]
NAME = 'maint08601'
PROFILE_NAME = 'rally28-hz60-maint08601-cached'
BACKEND = '0866265bd6f3d73ad572f31dc1bb954f308ed9a5d857efa9414d37e1ade13374'
FRONTEND = '7e7d0e1bc89af72bde7ffbd6c06446aaefda4d1803f89eb1faf3167307ee1e01'
sha = lambda p: hashlib.sha256(Path(p).read_bytes()).hexdigest()


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def profile():
    return json.loads((HERE / 'PROFILE.json').read_text())


def check_profile(path, pins, require_stopped=True):
    path = Path(path)
    for name, expected in pins.items():
        assert (path / name).is_file() and sha(path / name) == expected, name
    manifest = ''.join(h + '  ' + n + '\n' for n, h in pins.items())
    assert (path / '.runtime.sha256').read_text() == manifest
    if require_stopped:
        assert not (path / 'last-run').exists(), 'Preserve previous output'
        assert not (path / '.last-run').exists()
        assert {str(p.relative_to(path)) for p in path.rglob('*') if p.is_file()} == set(pins) | {'.runtime.sha256'}


def frozen_inputs():
    frozen = json.loads((HERE / 'READINESS-FREEZE.json').read_text())
    for base, items in [(HERE, frozen['files']), (ROOT, frozen['project_dependencies'])]:
        for name, expected in items.items():
            assert sha(base / name) == expected, name
    return frozen
