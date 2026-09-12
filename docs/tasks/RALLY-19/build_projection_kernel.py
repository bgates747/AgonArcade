"""Pack unchanged road coefficients and generate readable hosted Golem source.

Only offline constants/layout are generated. Existing C++ Golem emits all VDU
commands; the VDP selects records and computes geometry from raw position/row.
"""
from pathlib import Path
import argparse,hashlib,struct
from profile import TASK
HASHES={'oval':'a433e692f75e086bc0b20f80442cb55f5dda2b445a291fd3537bf951e02cf625','fuji':'72f835b888a79f3130e2d8c73c9ab8a80e3dcdc04991ea223038e43ce0d4269e'}
def build(track,root):
    root.mkdir(parents=True,exist_ok=True)
    raw=(TASK.parent/'RALLY-18/data'/(track+'.road')).read_bytes()
    assert hashlib.sha256(raw).hexdigest()==HASHES[track]
    count=90 if track=='oval' else 512;lap=count*6400
    records=list(struct.iter_unpack('<hhihh',raw[64:]));assert len(records)==count*19
    ranges=[(min(r[i] for r in records),max(r[i] for r in records)) for i in range(5)]
    (root/(track+'.coeff')).write_bytes(raw[64:])
    fields=list(zip('abcde',[0,2,4,8,10],['s16','s16','s32','s16','s16'],ranges))
    s=f'''// Real {track} coefficients; diagnostic position/row input, no host projection.
Table trackData(4000,228,{count},"{track}.coeff");
Buffer input(1000,80);
Field position(input,0,s32,0,{lap-1});
Field row(input,4,s16,103,224);
Buffer output(1001,80);
Field interval(output,0,u16,0,{count-1});
Field local(output,2,u16,0,6399);
Field fraction14(output,4,u16,0,16381);
Field fraction12(output,6,u16,0,4095);
Field square12(output,8,u16,0,4094);
Field aheadIndex(output,10,u16,0,18);
Field centrePixel(output,12,s16);
Field rowIndex(output,14,u16,0,121);
Buffer status(1002,10);
Field intervalOK(status,0,u16,0,1);
Field depthOK(status,2,u16,0,1);
Field coefficientOK(status,4,u16,0,1);
Buffer untouched(1003,2);
Buffer intervalData(1500,228);
'''
    for i in range(19):
        for name,off,kind,(lo,hi) in fields:s+=f'Field rec{i}{name}(intervalData,{i*12+off},{kind},{lo},{hi});\n'
    s+='Buffer coefficient(1502,12);\n'
    for name,off,kind,(lo,hi) in fields:
        s+=f'Field {name}(coefficient,{off},{kind},{lo},{hi});\n'
        s+=f'Field out{name}(output,{16+off},{kind},{lo},{hi});\n'
    s+='Buffer depths(1510,488);\n'
    depthBytes=b''.join(struct.pack('<i',2048000//q) for q in range(7,129))
    s+='Bytes(depths,'+','.join(map(str,depthBytes))+');\n'
    for i in range(122):s+=f'Field depth{i}(depths,{i*4},s32,16000,292571);\n'
    s+='Buffer selectedDepth(1511,4); Field depth(selectedDepth,0,s32,16000,292571);\n'
    s+='Buffer wide(1501,16);\n'
    for name,off,hi in [('localWide',0,6399),('fraction14Wide',4,16381),('fraction12Wide',8,4095),('squareWide',12,4094)]:s+=f'Field {name}(wide,{off},s32,0,{hi});\n'
    matrices=['localFloat','fractionFloat','fraction14Float','fraction12Float','squareFloat','squareDivided','fractionUnit','squareUnit','rowFloat','rowMinus103','qFloat','depthFloat','aheadFloat','aheadScaled','aFloat','bFloat','cFloat','dFloat','eFloat','bTerm','dTerm','eTerm','aTerm','lineA','lineBPart','lineB','rowSlope','scaledSlope','centreQ8','roundedCentre']
    for i,name in enumerate(matrices):s+=f'Matrix {name}({1120+i},1,1);\n'
    s+='Matrix pixelCentre(1102,1,1);\n'
    s+='''Program compute(2000) {
    DivModPositive(interval,local,position,6400);
    LoadIndexed(intervalData,trackData,interval,intervalOK);
    WidenUnsigned(localWide,local);
    MatLoad(localFloat,localWide);
    MatScale(fractionFloat,localFloat,2.56);
    StoreU16Floor(fraction14,fractionFloat);
    WidenUnsigned(fraction14Wide,fraction14);
    MatLoad(fraction14Float,fraction14Wide);
    MatScale(fractionFloat,fraction14Float,0.25);
    StoreU16Floor(fraction12,fractionFloat);
    WidenUnsigned(fraction12Wide,fraction12);
    MatLoad(fraction12Float,fraction12Wide);
    MatMul(squareFloat,fraction12Float,fraction12Float);
    MatScale(squareDivided,squareFloat,0.000244140625);
    StoreU16Floor(square12,squareDivided);
    WidenUnsigned(squareWide,square12);
    MatLoad(squareFloat,squareWide);
    MatScale(fractionUnit,fraction12Float,0.000244140625);
    MatScale(squareUnit,squareFloat,0.000244140625);
    MatLoad(rowFloat,row);
    MatValues(rowMinus103,-103);
    MatAdd(rowMinus103,rowFloat,rowMinus103);
    StoreU16Floor(rowIndex,rowMinus103);
    LoadElement(selectedDepth,depths,rowIndex,depthOK);
    MatLoad(depthFloat,depth);
    MatAdd(aheadFloat,fraction14Float,depthFloat);
    MatScale(aheadScaled,aheadFloat,0.00006103515625);
    StoreU16Floor(aheadIndex,aheadScaled);
    LoadElement(coefficient,intervalData,aheadIndex,coefficientOK);
    Copy(outa,a,2); Copy(outb,b,2); Copy(outc,c,4); Copy(outd,d,2); Copy(oute,e,2);
    MatLoad(aFloat,a); MatLoad(bFloat,b); MatLoad(cFloat,c); MatLoad(dFloat,d); MatLoad(eFloat,e);
    MatMul(bTerm,bFloat,fractionUnit);
    MatMul(dTerm,dFloat,fractionUnit);
    MatMul(eTerm,eFloat,squareUnit);
    MatScale(aTerm,aFloat,4);
    MatAdd(lineA,aTerm,bTerm);
    MatAdd(lineBPart,cFloat,dTerm);
    MatAdd(lineB,lineBPart,eTerm);
    MatValues(qFloat,-96);
    MatAdd(qFloat,rowFloat,qFloat);
    MatMul(rowSlope,lineB,qFloat);
    MatScale(scaledSlope,rowSlope,0.0625);
    MatAdd(centreQ8,lineA,scaledSlope);
    MatScale(pixelCentre,centreQ8,0.00390625);
    MatValues(roundedCentre,0.5);
    MatAdd(roundedCentre,pixelCentre,roundedCentre);
    StoreI16Floor(centrePixel,roundedCentre);
};
'''
    # The compiler requires distinct matrix destinations; use explicit constants
    # rather than silently depending on a stock alias implementation detail.
    s=s.replace('Matrix pixelCentre(1102,1,1);','Matrix pixelCentre(1102,1,1);\nMatrix minus103(1160,1,1); Matrix minus96(1161,1,1); Matrix half(1162,1,1);\nMatValues(minus103,-103); MatValues(minus96,-96); MatValues(half,0.5);')
    s=s.replace('    MatValues(rowMinus103,-103);\n    MatAdd(rowMinus103,rowFloat,rowMinus103);','    MatAdd(rowMinus103,rowFloat,minus103);').replace('    MatValues(qFloat,-96);\n    MatAdd(qFloat,rowFloat,qFloat);','    MatAdd(qFloat,rowFloat,minus96);').replace('    MatValues(roundedCentre,0.5);\n    MatAdd(roundedCentre,pixelCentre,roundedCentre);','    MatAdd(roundedCentre,pixelCentre,half);')
    path=root/(track+'.golem');path.write_text(s);return path
if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('track',choices=['oval','fuji']);a=p.parse_args();print(build(a.track,TASK/'.work/projection-source'))
