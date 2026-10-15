"""Check actual timed physics state and independent host time, without a MOS-rate assumption."""
from pathlib import Path
import importlib.util,json
from verify import HERE,sha,read

def verify(directory):
    r=json.loads((directory/'runtime/result.json').read_text());s=r['summary']
    assert r['reason']=='guest-files' and r['exit']==0 and r['identities_unchanged']
    assert r['forced_sdl']=={'video':'dummy','audio':'dummy'} and s['vector_restored']=='1'
    assert s['steps']=='8192' and s['rounds']=='2' and r['host_cpu_boost']=='0' and abs(r['host_suspend_seconds'])<.1
    seconds=r['host_window_seconds'];assert seconds>=10 and r['host_window_source']=='uart-markers'
    assert sha(directory/'capacity.bin')=='12fa08e3217db0f03cafefeae3743d260d380a6cd5696d26e8658c53799e40c6'
    for name,digest in r['outputs'].items():assert sha(directory/name)==digest
    wire=read(directory/'runtime/mos-to-vdp.bin');begin=wire.index(b'CAP_BEGIN')+9;end=wire.index(b'CAP_END',begin);assert wire[begin:end]==b''
    spec=importlib.util.spec_from_file_location('physics_reference',HERE.parent/'capacity/reference.py');ref=importlib.util.module_from_spec(spec);spec.loader.exec_module(ref);coverage=ref.verify(directory/'state.csv')
    stats=r['backend_stats'];assert not stats['failed'] and all(stats[k]==0 for k in ('unhandled','unregistered','unmapped'))
    prt=int(s['prt_ticks'])/1000
    result={'verified':True,'unchanged_baseline_binary':True,'steps':8192,'host_window_seconds':seconds,'host_steps_per_second':8192/seconds,'host_ms_per_step':seconds*1000/8192,'nominal_prt_seconds':prt,'host_prt_difference_pct':100*(prt/seconds-1),'raw_mos_units':int(s['mos_units']),'mos_units_per_host_second':int(s['mos_units'])/seconds,'state_fields_checked':420,'application_wire_bytes_inside_window':0,'coverage_per_round':coverage,'timing_limits':{'host_poll_seconds':.05,'adapter_trace_nominal_flush_seconds':.25,'unsubtracted_instrumentation':True},'qualifies_integrated_120_hz':False}
    (directory/'verified.json').write_text(json.dumps(result,indent=2)+'\n');return result
if __name__=='__main__':print(json.dumps(verify(HERE/'evidence/physics-wall-boostoff'),indent=2))
