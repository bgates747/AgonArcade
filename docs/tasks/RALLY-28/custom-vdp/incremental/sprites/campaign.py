"""Fresh silent Oryx sprite A/B; reuse the pinned runner and boost supervisor."""
import argparse
import json
from pathlib import Path
import shutil
import sys

HERE=Path(__file__).resolve().parent
sys.path.insert(0,str(HERE.parent))
import clear_test as clear


def prepare():
    assert not (HERE/'FIXTURES.json').exists()
    earlier=json.loads((HERE.parent/'FIXTURES.json').read_text())['clear-split']
    control=HERE.parent/earlier['directory']
    candidate=HERE/'.work/candidate/fixture'
    result={}
    for name,source in [('sprite-affine',control),('sprite-additive',candidate)]:
        meta=json.loads((source/'expected.json').read_text())
        for n,h in meta['files'].items():assert clear.sha(source/n)==h,(name,n)
        destination=HERE/'.work/fixtures'/name
        destination.mkdir(parents=True,exist_ok=False)
        for n in earlier['files']:shutil.copyfile(source/n,destination/n)
        result[name]=dict(directory=str(destination.relative_to(HERE)),
                         files={p.name:clear.sha(p) for p in destination.iterdir() if p.is_file()},
                         module_sha256=meta['module_sha256'],diagnostic=False,foreground_paced=False)
    # Exact tape equality in the timed loop; only the setup module changes.
    a=(control/'script.bin').read_bytes();b=(candidate/'script.bin').read_bytes()
    assert [v for r,v in clear.raw_records(a) if r['loop']]==[v for r,v in clear.raw_records(b) if r['loop']]
    (HERE/'FIXTURES.json').write_text(json.dumps(result,indent=2)+'\n')
    print('Prepared two exact-timed-loop sprite cases')


def stage(name,cases):
    clear.HERE=HERE
    clear.stage(name,cases)


def session(name,campaigns):
    clear.HERE=HERE
    clear.session(name,campaigns)


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    sub=parser.add_subparsers(dest='action',required=True)
    sub.add_parser('prepare')
    p=sub.add_parser('stage');p.add_argument('campaign');p.add_argument('cases',nargs='+')
    p=sub.add_parser('session');p.add_argument('name');p.add_argument('campaigns',nargs='+')
    args=parser.parse_args()
    if args.action=='prepare':prepare()
    elif args.action=='stage':stage(args.campaign,args.cases)
    else:session(args.name,args.campaigns)
