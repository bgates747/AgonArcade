"""Readable Golem for the complete oracle band containing diagnostic row160.

Constants are repacked from accepted band/phase tables. Per-frame band selection,
projection, material choice and all screen-coordinate arithmetic remain on VDP.
"""
from pathlib import Path
import argparse,re,struct
from profile import TASK
from build_projection_kernel import build as projection

def array(path,name):
    text=path.read_text();match=re.search(r'\b'+name+r'\[\]\s*=\s*\{([^}]+)\}',text,re.S)
    assert match,name
    return [int(v) for v in re.findall(r'-?\d+',match[1])]
def bracket(boundaries):
    return next((a,b) for a,b in zip(boundaries,boundaries[1:]) if a<=160<b)
def build(track,root):
    path=projection(track,root);s=path.read_text();count=90 if track=='oval' else 512
    # Preserve every accepted integer truncation. The deferred-truncation
    # experiment passed centre tolerance but failed a thin shoulder's pixels.
    s+='\nMatrix truncated(1180,1,1); Field truncatedValue(truncated,0,f32);\n'
    for target in ['bTerm','dTerm','eTerm','scaledSlope']:
        import re
        pattern=r'(    Mat(?:Mul|Scale)\('+target+r',[^;]+;\n)'
        s=re.sub(pattern,r'\1    MatTrunc(truncated,'+target+'); MatLoad('+target+',truncatedValue);\n',s)
    s=s.replace('MatAdd(roundedCentre,pixelCentre,half);','MatRoundAway(roundedCentre,pixelCentre);')
    base=TASK/'.work/oracle/include'
    offsets=array(base/'band_table.hpp','BandOffsets');ends=array(base/'band_table.hpp','BandEnds')
    phaseIndex=array(base/'section_phase.hpp','PhaseIndex');phaseOffsets=array(base/'section_phase.hpp','Offsets');phaseRows=array(base/'section_phase.hpp','Rows')
    curves=[]
    for i in range(count*4):
        bin_=i+(360 if track=='fuji' else 0)
        begin=offsets[bin_];end=offsets[bin_+1] if bin_+1<len(offsets) else len(ends)
        curves.append(bracket([104]+[y+1 for y in ends[begin:end]]))
    patterns=[]
    for i,begin in enumerate(phaseOffsets):
        end=phaseOffsets[i+1] if i+1<len(phaseOffsets) else len(phaseRows)
        lo,hi=bracket(phaseRows[begin:end]);representative=phaseIndex.index(i)
        patterns.append((lo,hi,int((800000//64+representative)%8000<4000)))
    assets=[('phaseIndices',5000,'phase-index.dat',bytes(phaseIndex),1,[('v',0,'u8',0,100)]),('phasePatterns',5001,'phase-patterns.dat',b''.join(struct.pack('<HHH',*p) for p in patterns),6,[('lo',0,'u16',116,223),('hi',2,'u16',117,224),('paint',4,'u16',0,1)]),('curveBands',5002,track+'-bands.dat',b''.join(struct.pack('<HH',*c) for c in curves),4,[('lo',0,'u16',104,223),('hi',2,'u16',105,224)])]
    declarations=''
    for name,id_,filename,data,stride,fields in assets:
        (root/filename).write_bytes(data);declarations+=f'Asset {name}({id_},"{filename}",{len(data)});\n'
        for i in range(len(data)//stride):
            for field,off,kind,lo,hi in fields:declarations+=f'Field {name}{i}{field}({name},{i*stride+off},{kind},{lo},{hi});\n'
    declarations+='''Field phase(input,4,u16,0,7999);
Buffer queryRow(1512,2); Field row(queryRow,0,s16,103,224);
Field topCentre(output,28,s16,-4096,4095);
Field bottomCentre(output,30,s16,-4096,4095);
Field topRow(output,32,u16,104,223);
Field bottomRow(output,34,u16,105,224);
Field phaseHalf(output,36,u16,0,1);
Field phaseLocal(output,38,u16,0,3999);
Field patternIndex(output,42,u16,0,100);
'''
    declarations+=f'Field bandIndex(output,44,u16,0,{count*4-1}); Field bandLocal(output,46,u16,0,1599);\n'
    declarations+='''Field leftTop(output,48,s16);
Field rightTop(output,50,s16);
Field leftBottom(output,52,s16);
Field rightBottom(output,54,s16);
Field painted(output,56,u16,0,1);
Field phaseOK(status,6,u16,0,1); Field bandOK(status,8,u16,0,1);
Buffer phaseWideBuffer(1513,4); Field phaseWide(phaseWideBuffer,0,s32,0,7999);
Buffer phaseSelection(1521,1); Field phasePattern(phaseSelection,0,u8,0,100);
Buffer selectedPattern(1522,6);
Field stripeStart(selectedPattern,0,u16,116,223); Field stripeEnd(selectedPattern,2,u16,117,224); Field basePaint(selectedPattern,4,u16,0,1);
Buffer selectedBand(1523,4);
Field curveStart(selectedBand,0,u16,104,223); Field curveEnd(selectedBand,2,u16,105,224);
Buffer geometry(1514,16);
Field cxTop(geometry,0,f32,-4096,4095); Field cxBottom(geometry,4,f32,-4096,4095);
Field widthTop(geometry,8,f32,0.15,2.57); Field widthBottom(geometry,12,f32,0.15,2.57);
Buffer drawRows(1515,4); Field yTop(drawRows,0,s16,104,223); Field yBottom(drawRows,2,s16,105,224);
Buffer drawConstants(1004,4); Field zero(drawConstants,0,u16,0,0); Field one(drawConstants,2,u16,1,1); Set(one,1);
Matrix cxTopMatrix(1170,1,1); Matrix cxBottomMatrix(1171,1,1);
Matrix widthTopMatrix(1172,1,1); Matrix widthBottomMatrix(1173,1,1);
Matrix rowTopMatrix(1174,1,1); Matrix rowBottomMatrix(1175,1,1);
Matrix qTopMatrix(1176,1,1); Matrix qBottomMatrix(1177,1,1);
Matrix offsetMatrix(1178,1,1); Matrix xMatrix(1179,1,1);
Field readCxTop(cxTopMatrix,0,f32); Field readCxBottom(cxBottomMatrix,0,f32);
Field readWidthTop(widthTopMatrix,0,f32); Field readWidthBottom(widthBottomMatrix,0,f32);
'''
    s=s.replace('Field row(input,4,s16,103,224);','').replace('Field centrePixel(output,12,s16);','Field centrePixel(output,12,s16,-4096,4095);')
    s=s.replace('Program compute(2000) {','Program prepareProjection(2005) {')
    split='    MatLoad(rowFloat,row);'
    s=s.replace(split,'};\nProgram projectRow(2006) {\n'+split)
    programs='''Program section(2000) {
    WidenUnsigned(phaseWide,phase);
    DivModPositive(phaseHalf,phaseLocal,phaseWide,4000);
    LoadElement(phaseSelection,phaseIndices,phaseLocal,phaseOK);
    WidenUnsigned(patternIndex,phasePattern);
    LoadElement(selectedPattern,phasePatterns,patternIndex,phaseOK);
    DivModPositive(bandIndex,bandLocal,position,1600);
    LoadElement(selectedBand,curveBands,bandIndex,bandOK);
    Copy(topRow,curveStart,2); Copy(bottomRow,curveEnd,2);
    CallIf(useStripeStart,stripeStart,gt,curveStart);
    CallIf(useStripeEnd,stripeEnd,lt,curveEnd);
    Set(painted,0); CallIf(setPainted,basePaint,ne,phaseHalf);
    Call(prepareProjection);
    WidenUnsigned(row,topRow); Call(projectRow); Copy(topCentre,centrePixel,2);
    WidenUnsigned(row,bottomRow); Call(projectRow); Copy(bottomCentre,centrePixel,2);
    WidenUnsigned(yTop,topRow); WidenUnsigned(yBottom,bottomRow);
    MatLoad(cxTopMatrix,topCentre); MatLoad(cxBottomMatrix,bottomCentre);
    Copy(cxTop,readCxTop,4); Copy(cxBottom,readCxBottom,4);
    MatLoad(rowTopMatrix,yTop); MatLoad(rowBottomMatrix,yBottom);
    MatSub(qTopMatrix,rowTopMatrix,minus96);
    MatSub(qBottomMatrix,rowBottomMatrix,minus96);
    MatScale(widthTopMatrix,qTopMatrix,0.02); MatScale(widthBottomMatrix,qBottomMatrix,0.02);
    Copy(widthTop,readWidthTop,4); Copy(widthBottom,readWidthBottom,4);
    CallIf(drawPainted,painted,eq,one); CallIf(drawWhite,painted,eq,zero);
};
Program useStripeStart(2007) { Copy(topRow,stripeStart,2); };
Program useStripeEnd(2008) { Copy(bottomRow,stripeEnd,2); };
Program setPainted(2009) { Set(painted,1); };
'''
    # minus96 is a negative constant; q = row + (-96), not row - (-96).
    programs=programs.replace('MatSub(qTopMatrix,rowTopMatrix,minus96)','MatAdd(qTopMatrix,rowTopMatrix,minus96)').replace('MatSub(qBottomMatrix,rowBottomMatrix,minus96)','MatAdd(qBottomMatrix,rowBottomMatrix,minus96)')
    names=['kerb','road','leftShoulder','rightShoulder','centreline']
    for i,(name,left,right) in enumerate(zip(names,[-106,-90,-86,84,-2],[106,90,-84,86,2])):
        programs+=f'Program {name}Geometry({2020+i}) {{\n'
        programs+='    MatLoad(cxTopMatrix,cxTop); MatLoad(cxBottomMatrix,cxBottom); MatLoad(widthTopMatrix,widthTop); MatLoad(widthBottomMatrix,widthBottom);\n'
        for target,u,width,cx in [('leftTop',left,'widthTopMatrix','cxTopMatrix'),('rightTop',right,'widthTopMatrix','cxTopMatrix'),('leftBottom',left,'widthBottomMatrix','cxBottomMatrix'),('rightBottom',right,'widthBottomMatrix','cxBottomMatrix')]:
            programs+=f'    MatScale(offsetMatrix,{width},{u}); MatAdd(xMatrix,{cx},offsetMatrix); StoreI16Floor({target},xMatrix);\n'
        programs+='};\n'
    for name,colour,id_ in [('redQuad',9,2030),('whiteQuad',15,2031),('greyQuad',8,2032),('yellowQuad',11,2033)]:
        programs+=f'Program {name}({id_}) {{ PlotQuad({colour},leftTop,yTop,rightTop,yTop,leftBottom,yBottom,rightBottom,yBottom); }};\n'
    programs+='''Program drawPainted(2040) {
    Call(kerbGeometry); Call(redQuad); Call(roadGeometry); Call(greyQuad);
    Call(leftShoulderGeometry); Call(yellowQuad); Call(rightShoulderGeometry); Call(yellowQuad);
    Call(centrelineGeometry); Call(yellowQuad);
};
Program drawWhite(2041) {
    Call(kerbGeometry); Call(whiteQuad); Call(roadGeometry); Call(greyQuad);
    Call(leftShoulderGeometry); Call(whiteQuad); Call(rightShoulderGeometry); Call(whiteQuad);
};
'''
    # Callees need only the values computed once by prepareProjection. Persist
    # those matrix results in typed ordinary fields across the call boundary.
    declarations+='''Buffer projectionValues(1516,12);
Field storedFraction14(projectionValues,0,f32,0,16381);
Field storedFractionUnit(projectionValues,4,f32,0,1);
Field storedSquareUnit(projectionValues,8,f32,0,1);
Field readFraction14(fraction14Float,0,f32);
Field readFractionUnit(fractionUnit,0,f32);
Field readSquareUnit(squareUnit,0,f32);
'''
    marker='};\nProgram projectRow(2006) {\n'
    s=s.replace(marker,'    Copy(storedFraction14,readFraction14,4); Copy(storedFractionUnit,readFractionUnit,4); Copy(storedSquareUnit,readSquareUnit,4);\n'+marker+'    MatLoad(fraction14Float,storedFraction14); MatLoad(fractionUnit,storedFractionUnit); MatLoad(squareUnit,storedSquareUnit);\n')
    path=root/(track+'-section.golem');path.write_text(s+'\n'+declarations+'\n'+programs);return path
if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('track',choices=['oval','fuji']);a=p.parse_args();print(build(a.track,TASK/'.work/section-source'))
