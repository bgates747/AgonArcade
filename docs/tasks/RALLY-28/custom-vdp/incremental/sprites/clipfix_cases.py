"""Preserve first attempts; register corrected clipping with equal early LOAD."""
import json
from pathlib import Path
import shutil
import sys

HERE=Path(__file__).resolve().parent
sys.path.insert(0,str(HERE.parent))
import clear_test as clear


def prepare():
    registry=json.loads((HERE/'FIXTURES.json').read_text())
    for name,source in [('clipfix-affine',HERE/registry['early-affine']['directory']),
                        ('clipfix-additive',HERE/'.work/candidate-clipfix/fixture')]:
        assert name not in registry
        dest=HERE/'.work/fixtures'/name
        shutil.copytree(source,dest)
        meta=json.loads((dest/'expected.json').read_text())
        for n,h in meta['files'].items():assert clear.sha(dest/n)==h
        if name=='clipfix-additive':
            tape=(dest/'script.bin').read_bytes();rows=clear.raw_records(tape)
            assert [r['opcode'] for r,_ in rows[:4]]==[6,6,1,2]
            changed=b''.join(rows[i][1] for i in [2,3,0,1]+list(range(4,len(rows))))
            assert [v for r,v in rows if r['loop']]==[v for r,v in clear.raw_records(changed) if r['loop']]
            (dest/'script.bin').write_bytes(changed)
            meta.update(early_module_load=True,canvas_clip_activated_by_plot_move=True)
            meta['files']['script.bin']=clear.sha(dest/'script.bin')
            (dest/'expected.json').write_text(json.dumps(meta,indent=2)+'\n')
        registry[name]=dict(directory=str(dest.relative_to(HERE)),
                            files={p.name:clear.sha(p) for p in dest.iterdir() if p.is_file()},
                            module_sha256=meta['module_sha256'],diagnostic=False,foreground_paced=False)
    (HERE/'FIXTURES.json').write_text(json.dumps(registry,indent=2)+'\n')
    print('Registered corrected clip activation; all previous attempts preserved')


if __name__=='__main__':prepare()
