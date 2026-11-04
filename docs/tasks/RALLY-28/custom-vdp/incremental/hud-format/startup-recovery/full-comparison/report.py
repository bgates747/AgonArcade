"""FPS-first offline accounting. Run after retrieval/release, never during prep."""
from pathlib import Path
import argparse
import json

HERE=Path(__file__).resolve().parent
ORDER=('control1','cached1','cached2','control2')


def pooled(rows,clock):
    frames=sum(row['frames'] for row in rows)
    seconds=sum(row[clock+'_seconds'] for row in rows)
    assert frames>0 and seconds>0
    key='nominal_mos_units' if clock=='nominal_mos' else 'prt_ticks'
    return dict(frames=frames,elapsed_units=sum(row[key] for row in rows),elapsed_seconds=seconds,fps=frames/seconds)


def paired(control,cached,clock):
    a=control[clock+'_fps'];b=cached[clock+'_fps']
    return dict(control_fps=a,cached_fps=b,change_percent=(b/a-1)*100,
                saved_ms_per_frame=(1000/a-1000/b))


def report(directory):
    directory=Path(directory);target=directory/'REPORT.json'
    assert not target.exists(),'Preserve the original report'
    campaign=json.loads((directory/'CAMPAIGN-hud900abba01.json').read_text());cases={}
    for case in ORDER:
        if case not in campaign:
            cases[case]=dict(status='UNRUN');continue
        if not campaign[case]['passed']:
            cases[case]=dict(status='FAILED',error=campaign[case].get('error'));continue
        audit=json.loads((directory/'evidence/hud900abba01'/case/'full-audit.json').read_text())
        assert audit['passed'] and audit['frames']==900
        cases[case]={k:audit[k] for k in ('frames','physics_ticks','nominal_mos_units','nominal_mos_seconds',
            'nominal_mos_fps','prt_ticks','nominal_prt_seconds','nominal_prt_fps','host_process_seconds',
            'wire_phases','timed_wire_sha256','whole_wire_sha256','MOS_image','observer','runtime_INFO_values')}
        cases[case]['status']='PASS'
    complete=all(cases[case]['status']=='PASS' for case in ORDER)
    result=dict(primary_clock='Nominal MOS120units/s completed-frame interval',cases=cases,
                complete_four_run_ABBA=complete,old_runtime_pooled=False,
                host_clock_boundary='Before process launch through stopped child including setup/teardown; not aligned race FPS',
                physical_or_isolated_renderer_claim=False,race_pixel_or_Author_visual_claim=False)
    if complete:
        result['comparisons']={}
        for clock in ('nominal_mos','nominal_prt'):
            control=[cases['control1'],cases['control2']];cached=[cases['cached1'],cases['cached2']]
            pairs=[paired(cases['control1'],cases['cached1'],clock),paired(cases['control2'],cases['cached2'],clock)]
            variation={role:(max(row[clock+'_fps'] for row in rows)/min(row[clock+'_fps'] for row in rows)-1)*100
                       for role,rows in [('control',control),('cached',cached)]}
            a=pooled(control,clock);b=pooled(cached,clock)
            result['comparisons'][clock]=dict(control=a,cached=b,pooled_change_percent=(b['fps']/a['fps']-1)*100,
                forward_pair=pairs[0],reverse_order_pair=pairs[1],within_role_range_percent=variation,
                opposite_sign_pair_changes=pairs[0]['change_percent']*pairs[1]['change_percent']<0,
                interpretation='Report both pairs and variation; four runs alone do not establish statistical significance')
    else:
        result['balanced_gain_claim']=False
    target.write_text(json.dumps(result,indent=2)+'\n')
    return result


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('directory',nargs='?',default=str(HERE))
    print(json.dumps(report(parser.parse_args().directory),indent=2))
