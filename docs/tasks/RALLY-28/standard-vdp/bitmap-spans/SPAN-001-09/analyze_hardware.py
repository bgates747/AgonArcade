"""Verify immutable returned-card evidence and derive separately labelled timings."""
from pathlib import Path
import csv
import hashlib
import json
import math
import statistics
from verify_results import verify

HERE = Path(__file__).resolve().parent
RETURN = HERE / 'evidence/hardware01'


def dist(values):
    ordered = sorted(values)
    return dict(mean=statistics.mean(values), median=statistics.median(values),
                p95=ordered[math.ceil(len(ordered)*.95)-1], minimum=min(values), maximum=max(values))


def analyze():
    package = json.loads((HERE/'PACKAGE.json').read_text())
    deployed = json.loads((HERE/'HARDWARE-DEPLOYMENT.json').read_text())
    returned = json.loads((RETURN/'RETURN-MANIFEST.json').read_text())
    for name, data in returned['files'].items():
        p = RETURN/name
        assert hashlib.sha256(p.read_bytes()).hexdigest() == data['sha256'], name
        assert p.stat().st_size == data['bytes']
    for name, expected in deployed['files'].items():
        assert returned['files'][name]['sha256'] == expected, name
    assert returned['autoexec_sha256'] == deployed['autoexec_after_sha256']
    results = {}
    for job in package['jobs']:
        directory = RETURN/job['id']
        verify(directory, job)
        summary = dict(line.split('=',1) for line in (directory/'summary.txt').read_text().splitlines() if '=' in line)
        for name, expected in job['inputs'].items():
            assert hashlib.sha256((directory/name).read_bytes()).hexdigest() == expected
        prt = int(summary['prt_ticks'])
        mos = int(summary['mos_units'])
        item = dict(summary=summary, input_hashes_match=True, verification_pass=True,
                    nominal_prt_seconds=prt/1000, nominal_mos_seconds=mos/120,
                    nominal_clock_difference_percent=100*((mos/120)/(prt/1000)-1))
        if job['kind'] == 'physics':
            state = list(csv.reader((directory/'state.csv').open()))
            assert len(state)==420 and len({(r[0],r[1]) for r in state})==420
            item.update(independent_state_fields=420, ticks=8192,
                        nominal_prt_ticks_per_second=8192000/prt,
                        nominal_mos_ticks_per_second=8192/(mos/120))
        else:
            rows = [{k:int(v) for k,v in row.items()} for row in csv.DictReader((directory/'frames.csv').open())]
            n=len(rows)
            sums={k:sum(r[k] for r in rows) for k in rows[0]}
            stages=['geometry','packing','submission','wait']
            spans=[sum(r[k] for k in stages) for r in rows]
            assert all(v>0 for v in spans)
            if job['diagnostic']:
                assert all(r['vdp_complete_us']>0 and r['vdp_submit_us']>0 for r in rows)
                assert int(summary['explicit_bytes'])-sums['bytes']==135*(2+3*n)
            item.update(frames=n, raw_sums=sums, frame_span_prt_ms=dist(spans),
                        stage_prt_ms={k:dist([r[k] for r in rows]) for k in stages},
                        nominal_prt_frame_span_fps=n*1000/sum(spans),
                        nominal_prt_whole_window_fps=n*1000/prt,
                        nominal_mos_whole_window_fps=n/(mos/120),
                        nominal_prt_outside_frame_span_ms=prt-sum(spans),
                        vdp_us={k:dist([r[k] for r in rows]) for k in ['vdp_submit_us','vdp_complete_us','vdp_drain_us']},
                        explicit_bytes_outside_frame_spans=int(summary['explicit_bytes'])-sums['bytes'])
        results[job['id']]=item
    report=dict(status='10-of-10-returned-cases-pass', platform='physical Olimex Agon Light 2',
                results=results, preserved_deployed_files=len(deployed['files']),
                startup_unchanged=True, firmware_file_sha256=package['firmware_sha256'],
                firmware_install_receipt='MAINBOARD-FLASH.json', card_writes=False,
                limits=['PRT1000 and MOS120 scales nominal; no independent physical host-wall calibration.',
                        'Whole diagnostic windows include stopped-record readout; frame-span sums exclude it.',
                        'VDP-local elapsed includes parser/buffer/transform/normal-worker scheduling and completion, not exclusive raster or scanout.',
                        'Road-only workload; actual physics isolated. No full-game FPS/integrated pacing claim.',
                        'No qualified full-track Flexe completion comparison: prior identical long cases failed.'])
    (HERE/'HARDWARE-RESULTS.json').write_text(json.dumps(report,indent=2)+'\n')
    for name,item in results.items():
        if name=='physics':print(name,'ticks/s',item['nominal_prt_ticks_per_second'],'fields',item['independent_state_fields'])
        else:print(name,'window_s',item['nominal_prt_seconds'],'frame_fps',item['nominal_prt_frame_span_fps'],'whole_fps',item['nominal_prt_whole_window_fps'],'VDP_ms',item['vdp_us']['vdp_complete_us']['mean']/1000)
    print('All43deployed files/startup unchanged;10case verification passes; returned files independently hashed.')


if __name__=='__main__':
    analyze()
