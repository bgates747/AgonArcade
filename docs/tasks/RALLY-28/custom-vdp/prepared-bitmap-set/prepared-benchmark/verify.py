"""Use qualified functional checks; derive FPS without claiming a raw audit."""
from pathlib import Path
import importlib.util
import json
import sys

HERE = Path(__file__).resolve().parent
PRIOR = HERE.parent/'prepared-race'
sys.path.insert(0,str(PRIOR))
spec=importlib.util.spec_from_file_location('prepared_benchmark_functional',PRIOR/'verify.py')
functional=importlib.util.module_from_spec(spec)
spec.loader.exec_module(functional)
functional.HERE=HERE
functional.check_prepared.__globals__['HERE']=HERE


def verify(directory):
    result=functional.verify(directory)
    assert result['frames']==900 and result['physics_ticks']==3600
    assert result['timed_wire_bytes']==291568
    predicted=json.loads((HERE/'PREDICTIONS.json').read_text())
    assert result['presentation_counters']==predicted['presentation']
    wanted=predicted['prepared_native_replies' if result['prepared_set'] else 'compact_native_replies']
    assert result['retained_replies']>=wanted if result['prepared_set'] else result['retained_replies']==wanted
    result.update(functional_only=False,timing_excluded=False,
        nominal_mos_fps=900*120/result['nominal_mos_ticks'],
        nominal_prt_fps=900*1000/result['nominal_prt_ticks'],
        performance_qualified=False,independent_raw_audit_pending=True,
        comparison_limit='Bundled retention +2px size approximation +stock-versus-additive sampling; not isolated cache benefit or identical actor images')
    (Path(directory)/'verified.json').write_text(json.dumps(result,indent=2)+'\n')
    return result
