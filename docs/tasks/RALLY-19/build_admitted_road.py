"""Link the qualified80-byte admission program to the resident full-road job.

Existing C++ Golem resolves all names/IDs and emits the buffered operations.
This assembly of readable source preserves the staging/active ABI and moves
diagnostic geometry out of its namespace; no projected values come from eZ80.
"""
import argparse,re
from profile import TASK
from build_road_kernel import build as road

def build(track,root,trace=True):
    path=road(track,root,trace=trace);s=path.read_text()
    s,n=re.subn(r'Buffer input\(1000,80\);','',s);assert n==1
    s,n=re.subn(r'Field position\(input,0,s32,0,\d+\);','',s);assert n==1
    s,n=re.subn(r'Field phase\(input,4,u16,0,7999\);','',s);assert n==1
    names=set(re.findall(r'\b(?:Buffer|Field|Matrix|Program|Asset|Table)\s+(\w+)\(',s))
    mapping={name:'road_'+name for name in names};mapping.update(position='activeposition',phase='activephase')
    # Keep quoted asset filenames literal while renaming only language identifiers.
    s=re.sub(r'"[^"\n]*"|\b[A-Za-z_]\w*\b',lambda m:mapping.get(m[0],m[0]),s)
    def relocate(match):
        kind,name,id_=match.groups();id_=int(id_)
        if kind=='Program':id_+=400
        elif kind=='Matrix':id_+=100
        elif kind=='Buffer' and 1001<=id_<=1004:id_+=19
        return f'{kind} {name}({id_}'
    s=re.sub(r'\b(Buffer|Matrix|Program)\s+(\w+)\((\d+)',relocate,s)
    admission=(TASK/'admission.golem').read_text().replace('Set(loadedTrack,0);',f'Set(loadedTrack,{int(track=="fuji")});')
    if track=='oval':admission=admission.replace('s32,0,3276799','s32,0,575999')
    needle='    MatScale(proofResult,inputPosition,2);';assert admission.count(needle)==1
    admission=admission.replace(needle,needle+'\n    Call(road_fullRoad);')
    path=root/(track+'-admitted-road.golem');path.write_text(admission+'\n'+s);return path

if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('track',choices=['oval','fuji']);p.add_argument('--no-trace',action='store_true');a=p.parse_args()
    print(build(a.track,TASK/'.work/admitted-road-source',trace=not a.no_trace))
