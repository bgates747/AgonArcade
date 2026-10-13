"""Record code/data/import/stack checks without claiming native execution."""
import argparse,json,re,subprocess
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('--compiler',required=True);a=p.parse_args()
prefix=str(Path(a.compiler).expanduser()).removesuffix('gcc')
rows=[]
for v in ('a','b'):
    d=Path('.work')/f'native-{v}';m=json.loads((d/f'rally-{v}.json').read_text())['module']
    undefined=subprocess.check_output([prefix+'nm','-u',str(d/f'rally-{v}.elf')],text=True).strip()
    assert not undefined,undefined
    frames={}
    for line in (d/f'rally-{v}.su').read_text().splitlines():
        name,size,kind=line.split('\t');assert kind=='static';frames[name.rsplit(':',1)[-1]]=int(size)
    # Source call graph: inlined generator routines belong to vdplet_entry.
    # Conservatively charge all branches of the longest nested emitter chains.
    entry=frames['vdplet_entry'];assert entry<=352,frames
    expected={'u32','byte','word','command','plot','rect','viewport','affine','bitmap','centre_exact','cx','tangent','acquire','memset','memcpy','vdplet_entry'}
    assert all(k in expected or k.startswith(('bearing$','release$')) for k in frames),frames
    chains=[['bitmap','affine','word','byte'],['viewport','plot','word','byte'],['rect','plot','word','byte'],['command','word','byte'],['cx','centre_exact','u32'],['acquire'],['memcpy'],['memset']]
    worst=entry+max(sum(frames.get(n,0) for n in chain) for chain in chains)
    assert worst<=512,(worst,frames)
    rows.append({'variant':v.upper(),'text_bytes':m['resident_text_bytes'],'data_bytes':m['resident_data_bytes'],'package_bytes':m['package_bytes'],'package_sha256':m['sha256'],'relative_relocations':m['relative_relocations'],'undefined_symbols':[],'entry_stack_bytes':entry,'source_graph_module_stack_bound_bytes':worst,'stack_limitations':'Excludes runtime callback, command task, interrupt and register-window spill overhead. Physical stack watermark still required.','frames':frames})
Path('.work/native-results.json').write_text(json.dumps(rows,indent=2)+'\n');print(json.dumps(rows,indent=2))
