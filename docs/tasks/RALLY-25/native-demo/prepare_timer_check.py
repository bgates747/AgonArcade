"""Build the driver-only static-screen PRT progression fixture; no launch."""
from pathlib import Path
import json,shutil
from build import HERE,WORK,Tape,assets,write,word

def prepare():
    assets();out=WORK/'prt-smoke';out.mkdir(exist_ok=True)
    t=Tape();t.send(bytes([22,8,12])+b'RALLY PRT CLOCK CHECK - NO GAME MODULE\r\n');t.send(write(50304,word(1)))
    t.mark();t.repeat(3)
    t.tx(4,word(17),4,None,'stack information');t.read(50304,0,1,'buffer read',4)
    t.data+=bytes([12])+word(10);t.mark();t.endrepeat();t.mark();t.data.append(0)
    (out/'script.bin').write_bytes(t.data);shutil.copyfile(WORK/'probe.bin',out/'probe.bin')
    (out/'expected.json').write_text(json.dumps(dict(schema=1,frames=3,physics_ticks=0,reply_bytes=30,tick_samples=5,checks=t.checks,
        prt_instrumented=True,require_prt_progress=True,minimum_prt_interval=10),indent=2)+'\n')
    print('Prepared PRT progression fixture:',out)
    return out
if __name__=='__main__':prepare()
