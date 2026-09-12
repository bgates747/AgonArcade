"""Readable full-road Golem: finite curve/stripe merge and VDP projection/drawing.

Python repacks immutable oracle tables and names static diagnostic trace fields.
Every frame's indexing, boundaries, parity and screen arithmetic execute on VDP.
"""
import argparse,re,struct
from profile import TASK
from build_packed_section import build as packed
from build_section_kernel import array
from road_bounds import proof

def build(track,root,trace=True):
    assert proof()['finite_repeat_limit']==32
    source=packed(track,root);s=source.read_text();count=90 if track=='oval' else 512
    match=re.search(r'Program section\(2000\) \{(.*?)\n\};',s,re.S);assert match
    draw=match[1][match[1].index('    WidenUnsigned(yTop'):]
    s=s[:match.start()]+s[match.end():]
    for name,id_ in [('useStripeStart',2007),('useStripeEnd',2008)]:
        s=re.sub(r'Program '+name+r'\('+str(id_)+r'\) \{[^}]*\};','',s)
    # The anchor-only descriptors are replaced by complete boundary arrays.
    s='\n'.join(line for line in s.splitlines() if not any(line.startswith(prefix+name) for name in ['phasePatterns','curveBands'] for prefix in ['Asset ','Field ']))+'\n'
    s=s.replace('Field topRow(output,32,u16,104,223);','Field topRow(output,32,u16,104,224);').replace('Field yTop(drawRows,0,s16,104,223);','Field yTop(drawRows,0,s16,104,224);')
    base=TASK/'.work/oracle/include'
    offsets=array(base/'band_table.hpp','BandOffsets');ends=array(base/'band_table.hpp','BandEnds')
    first=360 if track=='fuji' else 0;last=first+count*4
    start=offsets[first];stop=offsets[last] if last<len(offsets) else len(ends)
    curveOffsets=[v-start for v in offsets[first:last]];curveRows=[y+1 for y in ends[start:stop]]
    phaseOffsets=array(base/'section_phase.hpp','Offsets');phaseRows=array(base/'section_phase.hpp','Rows')
    for name,id_,values in [('allPhaseOffsets',5010,phaseOffsets),('allPhaseRows',5011,phaseRows),('allCurveOffsets',5012,curveOffsets),('allCurveRows',5013,curveRows)]:
        filename=track+'-'+name+'.dat';(root/filename).write_bytes(struct.pack('<'+'H'*len(values),*values))
        s+=f'Asset {name}({id_},"{filename}",{2*len(values)});\n'
        lo,hi=min(values),max(values)
        for i in range(len(values)):s+=f'Field {name}{i}({name},{2*i},u16,{lo},{hi});\n'
    s+='''
Buffer curveCursorStorage(1540,2); Field curveCursor(curveCursorStorage,0,u16);
Buffer phaseCursorStorage(1541,2); Field phaseCursor(phaseCursorStorage,0,u16);
Buffer nextCurveStorage(1542,2); Field nextCurve(nextCurveStorage,0,u16,105,224);
Buffer nextStripeStorage(1543,2); Field nextStripe(nextStripeStorage,0,u16,116,224);
Buffer roadConstants(1544,6); Field terminal(roadConstants,0,u16,224,224);
Field markedTop(roadConstants,2,u16,116,116); Field toggle(roadConstants,4,u16,0,1);
Set(terminal,224); Set(markedTop,116);
Buffer clearCoordinates(1545,12);
Field clearLeft(clearCoordinates,0,s16,0,0); Field clearRight(clearCoordinates,2,s16,320,320);
Field clearRoadTop(clearCoordinates,4,s16,103,103); Field clearRoadBottom(clearCoordinates,6,s16,224,224);
Field clearFooterTop(clearCoordinates,8,s16,223,223); Field clearFooterBottom(clearCoordinates,10,s16,240,240);
Set(clearRight,320); Set(clearRoadTop,103); Set(clearRoadBottom,224); Set(clearFooterTop,223); Set(clearFooterBottom,240);
Program clearRoad(2310) { PlotQuad(2,clearLeft,clearRoadTop,clearRight,clearRoadTop,clearLeft,clearRoadBottom,clearRight,clearRoadBottom); };
Program clearFooter(2311) { PlotQuad(0,clearLeft,clearFooterTop,clearRight,clearFooterTop,clearLeft,clearFooterBottom,clearRight,clearFooterBottom); };
Field bandCount(output,60,u16); Field active(output,62,u16,0,1);
Program drawSection(2302) {
'''+draw+'''
};
Program useNextStripe(2303) { Copy(bottomRow,nextStripe,2); };
Program finishRoad(2304) { Set(active,0); };
Program advanceCurve(2305) {
    AddU16(curveCursor,1); LoadElement(nextCurveStorage,allCurveRows,curveCursor,bandOK);
};
Program toggleOn(2306) { Set(toggle,1); };
Program firstStripe(2307) { Set(painted,0); CallIf(setPainted,phaseHalf,eq,zero); };
Program advanceStripe(2308) {
    AddU16(phaseCursor,1); LoadElement(nextStripeStorage,allPhaseRows,phaseCursor,phaseOK);
    Set(toggle,0); CallIf(toggleOn,painted,eq,zero); Copy(painted,toggle,2);
    CallIf(firstStripe,topRow,eq,markedTop);
};
Program advanceCursors(2309) {
    CallIf(advanceCurve,topRow,eq,nextCurve); CallIf(advanceStripe,topRow,eq,nextStripe);
};
Program drawNextBand(2301) {
    Copy(bottomRow,nextCurve,2); CallIf(useNextStripe,nextStripe,lt,nextCurve);
    WidenUnsigned(row,bottomRow); Call(projectRow); Copy(bottomCentre,centrePixel,2);
    Call(drawSection); AddU16(bandCount,1);
    Copy(topRow,bottomRow,2); Copy(topCentre,bottomCentre,2);
    CallIf(finishRoad,topRow,eq,terminal); CallIf(advanceCursors,active,eq,one);
};
'''
    if trace:
        s+='Buffer roadTrace(1600,198);\n'
        for i in range(33):
            s+=f'Field traceRow{i}(roadTrace,{i*6},u16,104,224); Field traceCentre{i}(roadTrace,{i*6+2},s16,-4096,4095); Field tracePaint{i}(roadTrace,{i*6+4},u16,0,1);\n'
    s+='''Program fullRoad(2000) {
    Call(clearRoad);
    Set(painted,0); Set(bandCount,0); Set(active,1);
    WidenUnsigned(phaseWide,phase); DivModPositive(phaseHalf,phaseLocal,phaseWide,4000);
    LoadElement(phaseSelection,phaseIndices,phaseLocal,phaseOK); WidenUnsigned(patternIndex,phasePattern);
    LoadElement(phaseCursorStorage,allPhaseOffsets,patternIndex,phaseOK);
    LoadElement(nextStripeStorage,allPhaseRows,phaseCursor,phaseOK);
    DivModPositive(bandIndex,bandLocal,position,1600);
    LoadElement(curveCursorStorage,allCurveOffsets,bandIndex,bandOK);
    LoadElement(nextCurveStorage,allCurveRows,curveCursor,bandOK);
    Call(prepareProjection); Set(topRow,104); WidenUnsigned(row,topRow);
    Call(projectRow); Copy(topCentre,centrePixel,2);
'''
    if trace:
        for i in range(33):
            if i:s+='    CallIf(drawNextBand,active,eq,one);\n'
            s+=f'    Copy(traceRow{i},topRow,2); Copy(traceCentre{i},topCentre,2); Copy(tracePaint{i},painted,2);\n'
    else:s+='    Repeat(32) { CallIf(drawNextBand,active,eq,one); };\n'
    s+='    Call(clearFooter);\n};\n'
    source=root/(track+'-road.golem');source.write_text(s);return source

if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('track',choices=['oval','fuji']);p.add_argument('--no-trace',action='store_true');a=p.parse_args()
    print(build(a.track,TASK/'.work/road-source',trace=not a.no_trace))
