"""Expand Rally-owned source fragments into finite entries, without compiler changes.

Fragments keep one authored formula when the same body is needed in a standalone
conformance entry and combined Tick120; they are build text, not Golem intrinsics.
"""
from pathlib import Path
HERE=Path(__file__).resolve().parent
def source():
    sine=(HERE/'sine.goleminc').read_text()
    contact=(HERE/'contact.goleminc').read_text()
    route=(HERE/'route.goleminc').read_text().replace('@SINE@',sine.rstrip())
    motion=(HERE/'motion.goleminc').read_text().replace('@CONTACT@',contact.rstrip())
    result=(HERE/'state.golem').read_text()
    for name,body in [('Sine',sine),('RouteTick',route),('Contact',contact),('Tick120',route+motion)]:result+='Sub '+name+'\n'+body+'EndSub\n'
    result+=(HERE/'probes.golem').read_text()
    assert '@' not in result
    return result

if __name__=='__main__':(HERE/'kernels.golem').write_text(source())
