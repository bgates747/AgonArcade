"""R19-07 first construction: pack interval records into immutable byte banks.

Uses the unchanged C++ Golem Asset/LoadElement/DivModPositive intrinsics. Source
bank and record offset are chosen by VDP; no complete bank is copied per frame.
"""
import argparse,struct
from profile import TASK
from build_section_kernel import build as section

def build(track,root):
    source=section(track,root);s=source.read_text();count=90 if track=='oval' else 512
    raw=(root/(track+'.coeff')).read_bytes();records=list(struct.iter_unpack('<hhihh',raw))
    ranges=[(min(r[i] for r in records),max(r[i] for r in records)) for i in range(5)]
    perBank=65535//228;assert perBank==287
    declarations='';programs='';banks=(count+perBank-1)//perBank
    for bank in range(banks):
        data=raw[bank*perBank*228:(bank+1)*perBank*228];assert len(data)%228==0
        filename=f'{track}-bank-{bank}.dat';(root/filename).write_bytes(data)
        name=f'coeffBank{bank}';declarations+=f'Asset {name}({4000+bank},"{filename}",{len(data)});\n'
        for record in range(len(data)//12):
            for field,offset,kind,(lo,hi) in zip('abcde',[0,2,4,8,10],['s16','s16','s32','s16','s16'],ranges):
                declarations+=f'Field {name}r{record}{field}({name},{12*record+offset},{kind},{lo},{hi});\n'
        programs+=f'Program loadBank{bank}({2050+bank}) {{ LoadElement(intervalData,{name},bankRecord,intervalOK); }};\n'
    s=s.replace(f'Table trackData(4000,228,{count},"{track}.coeff");',declarations)
    original='LoadIndexed(intervalData,trackData,interval,intervalOK);';assert s.count(original)==1
    if banks==1:
        s=s.replace(original,'LoadElement(intervalData,coeffBank0,interval,intervalOK);')
    else:
        s+='''\nBuffer bankSelection(1530,8);
Field bankNumber(bankSelection,0,u16,0,1); Field bankRecord(bankSelection,2,u16,0,286);
Field intervalWide(bankSelection,4,s32,0,511);
'''+programs
        s=s.replace(original,'''WidenUnsigned(intervalWide,interval);
    DivModPositive(bankNumber,bankRecord,intervalWide,287);
    CallIf(loadBank0,bankNumber,eq,zero); CallIf(loadBank1,bankNumber,eq,one);''')
    assert 'trackData' not in s
    source=root/(track+'-packed-section.golem');source.write_text(s);return source

if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('track',choices=['oval','fuji']);a=p.parse_args()
    print(build(a.track,TASK/'.work/packed-section-source'))
