"""Resident car projection/yaw from admitted state, using the accepted road math.

Only immutable TrackPoint tangent records and readable Golem source are emitted
offline. No host-projected coordinates, scales, views or draw order enter a frame.
"""
import argparse,re,struct
from profile import TASK
from build_vehicle_sort import build as sorted_road

def build(track,root):
    source=sorted_road(track,root);s=source.read_text();count=90 if track=='oval' else 512;lap=count*6400
    name='TriOvalPoints' if track=='oval' else 'FujiPoints'
    text=(TASK/'.work/oracle/include/track.hpp').read_text()
    match=re.search(r'\b'+name+r'\[\d+\]\s*=\s*\{(.*?)\n\};',text,re.S);assert match
    points=[tuple(map(int,re.findall(r'-?\d+',r))) for r in re.findall(r'\{([^}]+)\}',match[1])]
    assert len(points)==count and all(len(p)==4 for p in points)
    records=[(a[2],a[3],b[2]-a[2],b[3]-a[3]) for a,b in zip(points,points[1:]+points[:1])]
    ranges=[(min(r[i] for r in records),max(r[i] for r in records)) for i in range(4)]
    filename=track+'-headings.dat';(root/filename).write_bytes(b''.join(struct.pack('<4h',*r) for r in records))
    s+=f'\nAsset vpHeadings(1900,"{filename}",{count*8}); Buffer vpHeading(1901,8);\n'
    for i in range(count):
        for j,(lo,hi) in enumerate(ranges):s+=f'Field vpHeading{i}c{j}(vpHeadings,{i*8+j*2},s16,{lo},{hi});\n'
    for j,(n,(lo,hi)) in enumerate(zip(['TX','TY','DX','DY'],ranges)):
        s+=f'Field vpSource{n}(vpHeading,{j*2},s16,{lo},{hi});\n'
    s+=f'''
Buffer vpWork(1710,46);
Field vpZ(vpWork,0,u16,0,{count*64-1}); Field vpZRem(vpWork,2,u16,0,99);
Field vpWorld(vpWork,4,u16,0,{count*64-1}); Field vpWorldRem(vpWork,6,u16,0,99);
Field vpHeadingIndex(vpWork,8,u16,0,{count-1}); Field vpLocal(vpWork,10,u16,0,63);
Field vpPosition(vpWork,12,s32,0,{lap-1}); Field vpWorldWide(vpWork,16,s32,0,{count*64-1});
Field vpLocalWide(vpWork,20,s32,0,63);
Field vpTX(vpWork,24,s16,-8191,8191); Field vpTY(vpWork,26,s16,-8191,8191);
Field vpCameraTX(vpWork,28,s16,-8191,8191); Field vpCameraTY(vpWork,30,s16,-8191,8191);
Field vpIndex(vpWork,32,u16,0,5); Field vpQ(vpWork,34,u16,7,125);
Field vpQSigned(vpWork,36,s16,7,125); Field vpRow(vpWork,38,s16,103,221);
Field vpDepthSigned(vpWork,40,s16,64,1100);
Field vpIDWide(vpWork,42,s16,0,5); Field vpViewWide(vpWork,44,s16,0,4);
Buffer vpFlags(1711,8);
Field vpSelectedOK(vpFlags,0,u16,0,1); Field vpHeadingOK(vpFlags,2,u16,0,1);
Field vpVisible(vpFlags,4,u16,0,1); Field vpCount(vpFlags,6,u16);
Buffer vpClipped(1712,2); Field vpDepth(vpClipped,0,u16,64,1100); Set(vpDepth,64);
Buffer vpCar(1713,12);
Field vpCarPosition(vpCar,0,s32,0,{lap-1}); Field vpCarDistance(vpCar,4,s32,0,{lap-1});
Field vpCarLane(vpCar,8,s16,-90,90); Field vpCarID(vpCar,10,u16,0,5);
Buffer vpOutput(1714,96); Buffer vpCurrent(1715,16);
Buffer vpPlayer(1716,12);
Field vpPlayerBitmap(vpPlayer,0,u16,0,4); Field vpPlayerMirror(vpPlayer,2,u16,0,1);
Field vpPlayerX(vpPlayer,4,s16,-5000,5000); Field vpPlayerY(vpPlayer,6,s16,154,154); Set(vpPlayerY,154);
Field vpPlayerCentre(vpPlayer,8,s16,-4450,4449); Field vpPlayerReserved(vpPlayer,10,u16,0,0);
Buffer vpRoadCentre(1717,4); Field vpRoadPixel(vpRoadCentre,0,f32,-4096,4095);
Field vpRoadMatrixPixel(road_pixelCentre,0,f32);
Buffer vpIntegers(1718,20);
Field vpRoadInteger(vpIntegers,0,s16,-4096,4095); Field vpLaneInteger(vpIntegers,2,s16,-225,225);
Field vpCross(vpIntegers,4,s16,-32767,32767); Field vpMagnitude(vpIntegers,6,u16,0,32767);
Field vpView(vpIntegers,8,u16,0,4); Field vpMirror(vpIntegers,10,u16,0,1);
Field vpScaleSigned(vpIntegers,12,s16,14,250); Field vpAnchorX(vpIntegers,14,s16,0,51);
Field vpAnchorY(vpIntegers,16,s16,0,70); Field vpLateralInteger(vpIntegers,18,s16,-354,354);
Buffer vpThresholds(1719,8);
Field vpT0(vpThresholds,0,u16,264,264); Set(vpT0,264);
Field vpT1(vpThresholds,2,u16,787,787); Set(vpT1,787);
Field vpT2(vpThresholds,4,u16,1297,1297); Set(vpT2,1297);
Field vpT3(vpThresholds,6,u16,1785,1785); Set(vpT3,1785);
Buffer vpConstants(1720,2); Field vpSignedZero(vpConstants,0,s16,0,0);
Matrix vpInverse(1890,3,3); Matrix vpFive(1891,1,1); MatValues(vpFive,5);
Matrix vpTen(1892,1,1); MatValues(vpTen,10); Matrix vpHorizon(1893,1,1); MatValues(vpHorizon,96);
'''
    for i in range(10):s+=f'Matrix vpM{i}({1810+i},1,1);\n'
    fields=[('Visible',0,'u16',0,1),('ID',2,'u16',0,5),('Bitmap',4,'u16',0,34),
            ('Scale',6,'u16',14,250),('Mirror',8,'u16',0,1),('X',10,'s16',-5000,5000),
            ('Y',12,'s16',0,239),('Translation',14,'u16',0,25250)]
    for i in range(7):
        prefix='vpCurrent' if i==6 else 'vpOut'+str(i)
        owner='vpCurrent' if i==6 else 'vpOutput';base=0 if i==6 else 16*i
        for n,offset,t,lo,hi in fields:s+=f'Field {prefix}{n}({owner},{base+offset},{t},{lo},{hi});\n'
    # Export before returning from the row evaluator: mutable matrix bounds
    # cannot be assumed across Call, and vehicle placement truncates this value.
    anchor='    MatScale(road_pixelCentre,road_centreQ8,0.00390625);';assert s.count(anchor)==1
    s=s.replace(anchor,anchor+'\n    Copy(vpRoadPixel,vpRoadMatrixPixel,4);')
    s+='''
Program vpComputeHeading(2850) {
    DivModPositive(vpWorld,vpWorldRem,vpPosition,100); WidenUnsigned(vpWorldWide,vpWorld);
    DivModPositive(vpHeadingIndex,vpLocal,vpWorldWide,64); WidenUnsigned(vpLocalWide,vpLocal);
    LoadElement(vpHeading,vpHeadings,vpHeadingIndex,vpHeadingOK);
    MatLoad(vpM0,vpLocalWide);
    MatLoad(vpM1,vpSourceDX); MatMul(vpM2,vpM1,vpM0); MatScale(vpM3,vpM2,0.015625);
    MatLoad(vpM4,vpSourceTX); MatAdd(vpM5,vpM4,vpM3); StoreI16Floor(vpTX,vpM5);
    MatLoad(vpM1,vpSourceDY); MatMul(vpM2,vpM1,vpM0); MatScale(vpM3,vpM2,0.015625);
    MatLoad(vpM4,vpSourceTY); MatAdd(vpM5,vpM4,vpM3); StoreI16Floor(vpTY,vpM5);
};
Program vpView0(2851) { Set(vpView,0); };
Program vpView1(2852) { Set(vpView,1); };
Program vpView2(2853) { Set(vpView,2); };
Program vpView3(2854) { Set(vpView,3); };
Program vpTranslation(2855) {
    MatLoad(vpM0,vpScaleSigned); MatScale(vpM1,vpM0,101); StoreU16Floor(vpCurrentTranslation,vpM1);
};
Program vpProjectVisible(2856) {
    WidenUnsigned(vpDepthSigned,vpDepth);
    Identity(vpInverse); Scale(vpInverse,vpDepthSigned,1); InvertAffine(vpInverse);
    MatExtract(vpM0,vpInverse,0,0); MatScale(vpM1,vpM0,8000); StoreU16Floor(vpQ,vpM1);
    WidenUnsigned(vpQSigned,vpQ); MatLoad(vpM0,vpQSigned); MatAdd(vpM1,vpM0,vpHorizon);
    StoreI16Floor(vpRow,vpM1); Copy(road_row,vpRow,2); Call(road_projectRow);
    MatLoad(vpM0,vpRoadPixel); MatTrunc(vpM1,vpM0); StoreI16Floor(vpRoadInteger,vpM1);
    MatLoad(vpM0,vpCarLane); MatLoad(vpM1,vpQSigned); MatMul(vpM2,vpM0,vpM1);
    MatScale(vpM3,vpM2,0.02); MatTrunc(vpM4,vpM3); StoreI16Floor(vpLaneInteger,vpM4);
    MatLoad(vpM0,vpQSigned); MatScale(vpM1,vpM0,2); StoreU16Floor(vpCurrentScale,vpM1);
    WidenUnsigned(vpScaleSigned,vpCurrentScale); MatLoad(vpM0,vpScaleSigned);
    MatScale(vpM1,vpM0,0.19921875); StoreI16Floor(vpAnchorX,vpM1);
    MatScale(vpM1,vpM0,0.2734375); StoreI16Floor(vpAnchorY,vpM1);
    MatLoad(vpM0,vpRoadInteger); MatLoad(vpM1,vpLaneInteger); MatAdd(vpM2,vpM0,vpM1);
    MatLoad(vpM3,vpAnchorX); MatSub(vpM4,vpM2,vpM3); StoreI16Floor(vpCurrentX,vpM4);
    MatLoad(vpM0,vpRow); MatLoad(vpM1,vpAnchorY); MatSub(vpM2,vpM0,vpM1); StoreI16Floor(vpCurrentY,vpM2);
    Copy(vpPosition,vpCarPosition,4); Call(vpComputeHeading);
    MatLoad(vpM0,vpCameraTX); MatLoad(vpM1,vpTY); MatMul(vpM2,vpM0,vpM1);
    MatLoad(vpM3,vpCameraTY); MatLoad(vpM4,vpTX); MatMul(vpM5,vpM3,vpM4);
    MatSub(vpM6,vpM2,vpM5); MatScale(vpM7,vpM6,0.000244140625);
    MatTrunc(vpM8,vpM7); StoreI16Floor(vpCross,vpM8);
    MatAbs(vpM1,vpM8); StoreU16Floor(vpMagnitude,vpM1);
    LessThan(vpMirror,vpSignedZero,vpCross); Set(vpView,4);
    CallIf(vpView3,vpMagnitude,lt,vpT3); CallIf(vpView2,vpMagnitude,lt,vpT2);
    CallIf(vpView1,vpMagnitude,lt,vpT1); CallIf(vpView0,vpMagnitude,lt,vpT0);
    WidenUnsigned(vpIDWide,vpCarID); WidenUnsigned(vpViewWide,vpView);
    MatLoad(vpM0,vpIDWide); MatScale(vpM1,vpM0,5); MatLoad(vpM2,vpViewWide);
    MatAdd(vpM3,vpM1,vpM2); MatAdd(vpM4,vpM3,vpFive); StoreU16Floor(vpCurrentBitmap,vpM4);
    Copy(vpCurrentMirror,vpMirror,2); CallIf(vpTranslation,vpMirror,eq,vehicleOne);
    AddU16(vpCount,1);
};
Program vpClip(2857) {
    DivModPositive(vpZ,vpZRem,vpCarDistance,100); CopyChecked(vpDepth,vpZ,vpVisible);
    Copy(vpCurrentVisible,vpVisible,2); CallIf(vpProjectVisible,vpVisible,eq,vehicleOne);
};
Program vpProcess(2858) {
    Set(vpCurrentVisible,0); Set(vpCurrentBitmap,0); Set(vpCurrentScale,14); Set(vpCurrentMirror,0);
    Set(vpCurrentX,0); Set(vpCurrentY,0); Set(vpCurrentTranslation,0); Set(vpVisible,0);
    LoadElement(vpCar,vehicleOrder,vpIndex,vpSelectedOK); Copy(vpCurrentID,vpCarID,2);
    CallIf(vpClip,vpSelectedOK,eq,vehicleOne);
};
Program vpPlayerAnchor(2859) { Set(vpAnchorX,50); };
Program vpProjectPlayer(2861) {
    Set(road_row,214); Call(road_projectRow);
    MatLoad(vpM0,vpRoadPixel); MatTrunc(vpM1,vpM0); StoreI16Floor(vpRoadInteger,vpM1);
    MatLoad(vpM0,activelateral); MatScale(vpM1,vpM0,118); MatScale(vpM2,vpM1,0.000078125);
    MatTrunc(vpM3,vpM2); StoreI16Floor(vpLateralInteger,vpM3);
    MatLoad(vpM0,vpRoadInteger); MatLoad(vpM1,vpLateralInteger); MatAdd(vpM2,vpM0,vpM1);
    StoreI16Floor(vpPlayerCentre,vpM2);
    MatLoad(vpM0,activesteering); MatAbs(vpM1,vpM0); MatScale(vpM2,vpM1,4);
    MatAdd(vpM3,vpM2,vpTen); MatScale(vpM4,vpM3,0.047619047619047619);
    StoreU16Floor(vpPlayerBitmap,vpM4); LessThan(vpPlayerMirror,vpSignedZero,activesteering);
    Set(vpAnchorX,51); CallIf(vpPlayerAnchor,vpPlayerMirror,eq,vehicleOne);
    MatLoad(vpM0,vpPlayerCentre); MatLoad(vpM1,vpAnchorX); MatSub(vpM2,vpM0,vpM1); StoreI16Floor(vpPlayerX,vpM2);
};
Program vpProjectAll(2860) {
    Call(vehicleSort); Set(vpCount,0);
    Copy(vpPosition,activeposition,4); Call(vpComputeHeading);
    Copy(vpCameraTX,vpTX,2); Copy(vpCameraTY,vpTY,2);
'''
    for i in range(6):
        s+=f'    Set(vpIndex,{i}); Call(vpProcess);\n'
        for n,_,_,_,_ in fields:s+=f'    Copy(vpOut{i}{n},vpCurrent{n},2);\n'
    s+='    Call(vpProjectPlayer);\n};\n'
    anchor='    Call(vehicleSort);';assert s.count(anchor)==2
    s=s.replace(anchor,'    Call(vpProjectAll);',1)
    target=root/(track+'-vehicle-projection.golem');target.write_text('SharedWordScratch();\n'+s);return target

if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('track',choices=['oval','fuji']);a=p.parse_args()
    print(build(a.track,TASK/'.work/vehicle-projection-source'))
