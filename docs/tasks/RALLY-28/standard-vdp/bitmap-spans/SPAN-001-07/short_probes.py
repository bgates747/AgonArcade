"""One bounded timing-mechanism probe/variant, not sustained-FPS qualification."""
import profiles,run,json
from pathlib import Path
HERE=Path(__file__).resolve().parent;results=[]
for variant in range(3):
 name=f'rally28-road-v{variant}-fenced-probe05';profiles.prepare(name,variant,1,1,16,'flexe')
 results.append({'name':name,'ok':run.run(name,90)})
(HERE/'evidence/SHORT-PROBES.json').write_text(json.dumps(results,indent=2)+'\n')
