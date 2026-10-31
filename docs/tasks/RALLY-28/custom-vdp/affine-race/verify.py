from pathlib import Path
import importlib.util
p=Path(__file__).resolve().parent.parent/'full-race/verify.py'
s=importlib.util.spec_from_file_location('aff02_original_verify',p)
m=importlib.util.module_from_spec(s);s.loader.exec_module(m)
verify=m.verify
