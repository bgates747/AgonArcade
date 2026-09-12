"""Report measured frame costs against 60 Hz; no graphical emulator launch."""
from pathlib import Path
import json
import statistics
import run_timing

ROOT=Path(__file__).resolve().parent/'results'
manifest=json.loads((ROOT/'manifest.json').read_text())
output=[]
lines=['# Headless timing', '',
       '64 fixed poses per run, six opponents, two runs per track/variant. '
       'Batch time includes the final drain. Clock: 120 raw ticks/second.', '',
       '| Track / renderer | FPS equivalent | ms/frame | 60 Hz budget | Over budget | Road bytes/frame | Sections/frame |',
       '| --- | ---: | ---: | ---: | ---: | ---: | ---: |']
stage_lines=['', '| Track / renderer | Fixture setup ms | Geometry ms | Command construction ms | Submission ms | Completion wait ms |',
             '| --- | ---: | ---: | ---: | ---: | ---: |']
for track in ('oval','fuji'):
    for variant in ('full','sections'):
        runs=[r for r in manifest['runs'] if r['track']==track and r['variant']==variant]
        assert len(runs)==2
        frames=sum(r['metadata']['submitted'] for r in runs)
        ticks=sum(r['metadata']['run_ticks']+r['metadata']['drain_ticks'] for r in runs)
        ms=ticks*1000/120/frames
        rows=[]
        for run in runs:
            metadata,part=run_timing.read_report(ROOT/(run['case']+'.csv'))
            run_timing.validate(metadata,part,True);rows.extend(part)
        item={'track':track,'variant':variant,'frames':frames,'batch_ticks':ticks,
              'fps':1000/ms,'frame_ms':ms,'budget_multiple':ms/(1000/60),'over_budget_ms':ms-1000/60,
              'road_bytes_per_frame':statistics.mean(row['road_bytes'] for row in rows),
              'sections_per_frame':statistics.mean(row['band_count'] for row in rows),
              'max_sections':max(row['band_count'] for row in rows),
              'stage_ms':{key:statistics.mean(row[key] for row in rows)*1000/120
                          for key in ('physics','geometry','bands','submit','fence')}}
        output.append(item)
        label=f'{track} / {variant}'
        lines.append(f"| {label} | {item['fps']:.2f} | {ms:.2f} | {item['budget_multiple']:.2f}× | {item['over_budget_ms']:.2f} ms | {item['road_bytes_per_frame']:.2f} | {item['sections_per_frame']:.2f} |")
        stage_lines.append('| '+label+' | '+' | '.join(f'{value:.2f}' for value in item['stage_ms'].values())+' |')
lines+=stage_lines+['',
    'The fixture excludes elapsed-time gameplay physics. Its `physics` column '
    'measures deterministic fixture setup. Submission includes scenery, road, '
    'traffic, HUD and swap calls, including any UART/VDP backpressure. Traffic '
    'centre projections occur there in the candidate. Completion wait is the '
    'stock post-swap poll; it is not an isolated measure of VDP raster time.', '',
    'The unchanged scheduler permits a submission every four raw ticks '
    '(30 Hz maximum before workload delays). Two-tick clock resolution makes '
    'individual stages coarse. Stage sums omit scheduling gaps, final draining '
    'and untimed instrumentation overhead; complete batch time is authoritative.', '']
(ROOT/'summary.json').write_text(json.dumps(output,indent=2)+'\n')
(ROOT/'table.md').write_text('\n'.join(lines))
print('\n'.join(lines))
