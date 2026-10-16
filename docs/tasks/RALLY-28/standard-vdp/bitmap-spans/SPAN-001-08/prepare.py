"""Isolated diagnostic export; no peer edits, reset, flash or deployment."""
from pathlib import Path
import shutil,json,hashlib
HERE=Path(__file__).resolve().parent;DONOR=HERE.parents[5].parent/'agon-extender/agents/scroll001/mainboard-r02';OUT=HERE/'.work/diagnostic';assert not OUT.exists()
assert hashlib.sha256((DONOR/'firmware.bin').read_bytes()).hexdigest()=='61bdfedea437199565646b07e91589eea67a3a8bd70a7c5b68be933ec2e0fb4a'
shutil.copytree(DONOR/'source',OUT,ignore=shutil.ignore_patterns('.pio','.git','examples','docs','test','tests'))
header='''#pragma once
#include <stdint.h>
namespace rally_mailbox { inline uint8_t data[16]={}; }
'''
(OUT/'video/rally_mailbox.hpp').write_text(header)
p=OUT/'video/vdu_sys.h';s=p.read_text();s='#include "rally_mailbox.hpp"\n'+s
needle='\tswitch (mode) {';at=s.index(needle,s.index('void VDUStreamProcessor::vdu_sys_video()'))
s=s[:at]+s[at:].replace(needle,needle+'''
// Rally read-only snapshot transport: low/high nibble of last QTG record.
// Uses ordinary GP packets, admitted by official MOS and Legacy EMOS.
case 0xEB: {
  int index=readByte_t();
  if(index<0)break;
  uint8_t value=index==32?7:index<32?
      ((rally_mailbox::data[index/2]>>(index%2?4:0))&15):15;
  send_packet(0,1,&value);
} break;
''',1);p.write_text(s)
p=OUT/'video/extender/diagnostics/graphics_command.inc';s=p.read_text();needle='        send_packet(0x0C,sizeof packet,packet);';assert s.count(needle)==1;s=s.replace(needle,'        memcpy(rally_mailbox::data,packet,sizeof packet);\n'+needle);p.write_text(s)
# Preserve existing firmware ID lineage and add explicit task diagnostic identity.
p=OUT/'video/version.h';p.write_text(p.read_text().replace('scroll-mainboard-timing-r01','rally28-frame-timing-r01'))
inputs={str(p.relative_to(OUT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in OUT.rglob('*') if p.is_file()}
(HERE/'SOURCE.json').write_text(json.dumps({'base_image_sha256':'61bdfedea437199565646b07e91589eea67a3a8bd70a7c5b68be933ec2e0fb4a','base_manifest':json.loads((DONOR/'sources.json').read_text()),'change':'read-only nibble mailbox over standard GP; no scheduling/fence changes','files':inputs},indent=2)+'\n');print(OUT)
