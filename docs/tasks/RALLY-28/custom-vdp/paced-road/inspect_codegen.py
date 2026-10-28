"""Emit annotated Xtensa section assembly; count static operations, not cycles."""
from pathlib import Path
import json
import re
import subprocess
from build_candidates import HERE, WORK


def inspect():
    builds=json.loads((HERE/'CANDIDATE-BUILD.json').read_text())
    compiler=Path.home()/'.platformio/packages/toolchain-xtensa-esp32/bin/xtensa-esp32-elf-gcc'
    destination=HERE/'assembly';destination.mkdir(exist_ok=True);report={}
    for name in builds:
        d=WORK/name;source=d/'inspection.c'
        source.write_text('#include "package/helper/rally_render.c"\n'
            'unsigned section_probe(uint8_t *p,unsigned cap,int ct,int cb,int yt,int yb,int marked)'
            '{Out o={p,0,cap,0};section(&o,ct,cb,yt,yb,marked);return o.n;}\n')
        out=d/'section.s'
        subprocess.run([str(compiler),'-Os','-fPIC','-mlongcalls','-mtext-section-literals',
            '-fno-builtin','-ffp-contract=off','-fverbose-asm','-I'+str(HERE/'control/sdk/include'),
            '-S',str(source),'-o',str(out)],check=True)
        text=out.read_text();body=''
        for function in ('road_edge','road_shape','section'):
            match=re.search('^'+function+':$',text,re.M)
            if not match:continue
            end=text.index('\n\t.size\t'+function+',',match.start())
            body+=text[match.start():end]+'\n'
        assert '\n' in body
        (destination/(name+'.s')).write_text(body)
        instructions=[l.split('#')[0].strip() for l in body.splitlines()
                      if re.match(r'^\s+[a-z][a-z0-9_.]*\s',l)]
        floating=[l for l in instructions if re.match(r'^(float|trunc|add|sub|mul|madd|msub|mov)\.s\s',l)]
        divides=[l for l in instructions if re.match(r'^(quos|quou|rems|remu)\s',l)]
        report[name]=dict(section_float_instructions=len(floating),float_operations=floating,integer_divides=divides,
            scope='Static operations in isolated compiled section/edge/shape functions; loops/call overhead mean these are not executed counts or cycle measurements')
    assert report['control']['section_float_instructions']>0
    for name,item in builds.items():
        if item['flags'] and item['flags'][0]:assert report[name]['section_float_instructions']==0
    (HERE/'SECTION-CODEGEN.json').write_text(json.dumps(report,indent=2)+'\n')
    print({name:r['section_float_instructions'] for name,r in report.items()})


if __name__=='__main__':inspect()
