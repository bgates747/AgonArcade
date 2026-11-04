"""Original exact guest verification, explicitly excluding smoke from performance."""
from pathlib import Path
import importlib.util
import json

HERE = Path(__file__).resolve().parent


def verify(directory):
    spec = importlib.util.spec_from_file_location('original_hud_verification', HERE.parent.parent/'verify.py')
    original = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(original)
    original.HERE = HERE
    result = original.verify(directory)
    assert result['frames'] == 60 and result['physics_ticks'] == 240
    result.update(timing_excluded=True, smoke_functional_only=True)
    (Path(directory)/'verified.json').write_text(json.dumps(result, indent=2)+'\n')
    return result
