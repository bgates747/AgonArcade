from pathlib import Path
import importlib.util
HERE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('runner',HERE.parent/'SPAN-001-07/run.py');r=importlib.util.module_from_spec(spec);spec.loader.exec_module(r)
# Common runner preserves all raw outputs regardless of its road-only pass predicate.
r.run('rally28-road-physics-lifecycle02',180)
profile=HERE.parents[5]/'.emulator/rally28-road-physics-lifecycle02';app=profile/'sdcard/test/arcade/rally28/road'
from verify_results import verify
verify(app,{'kind':'physics'});print('All420actual physics fields and mode/timer cleanup verified')
