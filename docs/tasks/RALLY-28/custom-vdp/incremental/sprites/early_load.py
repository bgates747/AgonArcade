"""Move LOAD before mode/artwork setup on both sides; retain timed bytes."""
import json
from pathlib import Path
import shutil
import sys

HERE=Path(__file__).resolve().parent
sys.path.insert(0,str(HERE.parent))
import clear_test as clear


def prepare():
    registry=json.loads((HERE/'FIXTURES.json').read_text())
    report={}
    for old,new in [('sprite-affine','early-affine'),('sprite-additive','early-additive')]:
        assert new not in registry
        original=registry[old];source=HERE/original['directory']
        assert all(clear.sha(source/n)==h for n,h in original['files'].items())
        out=HERE/'.work/fixtures'/new;shutil.copytree(source,out)
        tape=(source/'script.bin').read_bytes();rows=clear.raw_records(tape)
        assert [r['opcode'] for r,_ in rows[:4]]==[6,6,1,2]
        assert [r['filename'] for r,_ in rows[:2]]==['artwork.vdu','assets.vdu']
        assert rows[3][0]['token']==1 and rows[3][0]['kind']==2
        order=[2,3,0,1]+list(range(4,len(rows)))
        changed=b''.join(rows[i][1] for i in order)
        assert [v for r,v in rows if r['loop']]==[v for r,v in clear.raw_records(changed) if r['loop']]
        (out/'script.bin').write_bytes(changed)
        meta=json.loads((out/'expected.json').read_text())
        meta.update(early_module_load=True,
                    startup_scope='LOAD/INIT before entire mode136 artwork external stream; frame loop unchanged')
        meta['files']['script.bin']=clear.sha(out/'script.bin')
        (out/'expected.json').write_text(json.dumps(meta,indent=2)+'\n')
        registry[new]={**original,'directory':str(out.relative_to(HERE)),
                       'files':{n:clear.sha(out/n) for n in original['files']}}
        report[new]=dict(original=old,record_order=order[:4],all_record_bytes_exact=True,
                         timed_loop_exact=True,module_unchanged=True,
                         firmware_unchanged=True,files=registry[new]['files'])
    (HERE/'FIXTURES.json').write_text(json.dumps(registry,indent=2)+'\n')
    (HERE/'EARLY-LOAD.json').write_text(json.dumps(report,indent=2)+'\n')
    print('Prepared equal early-LOAD startup on both fixtures; timed loops exact')


if __name__=='__main__':prepare()
