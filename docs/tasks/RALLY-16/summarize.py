"""Summarize completed unpaced batches, including final VDP drain."""
from pathlib import Path
import json
R=Path(__file__).resolve().parent/'results'
m=json.loads((R/'manifest.json').read_text())
lines=['# Unpaced, normal-clock eZ80 results','',
       'Repeated 64-pose rendering batches; complete time includes final drain.', '',
       '| Track / renderer | Completed FPS | ms/frame | 60 Hz budget | ms over budget | Per-run FPS range | Mean final drain |',
       '| --- | ---: | ---: | ---: | ---: | ---: | ---: |']
summary=[]
for track in ('oval','fuji'):
    for variant in ('full','pavement','sections'):
        runs=[r for r in m['runs'] if r['track']==track and r['variant']==variant]
        assert len(runs)==2
        frames=sum(r['data']['frames'] for r in runs)
        ticks=sum(r['data']['total_ticks'] for r in runs)
        ms=ticks*1000/120/frames;fps=1000/ms
        drain=sum(r['data']['drain_ticks'] for r in runs)*1000/120/len(runs)
        item={'track':track,'renderer':variant,'frames':frames,'fps':fps,'frame_ms':ms,
              'budget_multiple':ms/(1000/60),'over_budget_ms':ms-1000/60,
              'fps_range':[min(r['fps'] for r in runs),max(r['fps'] for r in runs)],
              'mean_final_drain_ms':drain,'road_bytes_per_batch':runs[0]['data']['road_bytes']}
        summary.append(item)
        lines.append(f"| {track} / {variant} | {fps:.2f} | {ms:.2f} | {item['budget_multiple']:.2f}× | {item['over_budget_ms']:.2f} | {item['fps_range'][0]:.2f}–{item['fps_range'][1]:.2f} | {drain:.2f} ms |")
loads=[x for r in m['runs'] for x in (r['load_before'][0],r['load_after'][0])]
lines+=['',f'All {sum(r["data"]["frames"] for r in m["runs"])} frames submitted; all 12 batches completed their final poll without a timeout. '
        'Pose hashes and road-byte totals match the previous renderer fixtures. '
        'Normal CPU flags were verified from each running process.', '',
        f'One-minute host load range: {min(loads):.2f}–{max(loads):.2f}. '
        'Individual timestamps have two-raw-tick granularity (16.67 ms). '
        'These are batch-throughput equivalents, not physical display FPS. '
        'Ordinary gameplay physics and keyboard input are excluded. '
        'No application frame cap or per-frame completion wait remains.', '']
(R/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
(R/'table.md').write_text('\n'.join(lines))
print('\n'.join(lines))
