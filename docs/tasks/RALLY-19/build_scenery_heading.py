"""Resident scenery bearing from admitted position; road/cars remain active.

Static proof gates the cheaper direct product/floor and one-sided quotient
correction for these frozen tracks. No host-computed bearing enters a frame.
"""
import argparse,hashlib,json,re
from pathlib import Path
from profile import TASK
from build_vehicle_draw import build as vehicles

def build(track,root):
    proof=json.loads((TASK/'evidence/golem-scenery-proof/fraction-and-direct/results.json').read_text())
    assert proof['pass']
    for p,digest in proof['source_hashes'].items():assert hashlib.sha256(Path(p).read_bytes()).hexdigest()==digest,p
    row=next(r for r in proof['tracks'] if r['track']==track)
    assert row['native_fraction_matches'] and row['naive_product_mismatches']==0 and row['estimate_too_high']==0
    assert row['minimum_major']>=2048
    source=vehicles(track,root);s=source.read_text()
    assert s.startswith('SharedWordScratch();')
    s=s.replace('SharedWordScratch();','SharedScalarScratch();',1)
    text=(TASK/'.work/oracle/include/scenery_data.hpp').read_text()
    match=re.search(r'HeadingAtan\[257\]\s*=\s*\{([^}]+)\}',text,re.S);assert match
    atan=list(map(int,re.findall(r'\d+',match[1])));assert len(atan)==257 and min(atan)==0 and max(atan)==128
    (root/'scenery-atan.dat').write_bytes(bytes(atan));s+='\nAsset scAtan(1902,"scenery-atan.dat",257);\n'
    for i in range(257):s+=f'Field scAtan{i}(scAtan,{i},u8,0,128);\n'
    s+='''
Buffer scWork(1730,64);
Field scBase(scWork,0,s16,-4096,4096); Field scDelta(scWork,2,s16,-1005,1215);
Field scRawTangent(scWork,4,s16,-5101,5311);
Field scAbsX(scWork,6,u16,0,4096); Field scAbsY(scWork,8,u16,0,4096);
Field scMinor(scWork,10,u16,0,4096); Field scMajor(scWork,12,u16,0,4096);
Field scSwapped(scWork,14,u16,0,1); Field scEstimate(scWork,16,u16,0,512);
Field scEstimateSigned(scWork,18,s16,0,512); Field scCorrected(scWork,20,s16,0,513);
Field scIndex(scWork,22,u16,0,256); Field scMinorSigned(scWork,24,s16,0,4096);
Field scMajorSigned(scWork,26,s16,2048,4096); Set(scMajorSigned,2048);
Field scSmall(scWork,28,s16,0,128); Field scBaseAngle(scWork,30,s16,0,256);
Field scAngleX(scWork,32,s16,0,512); Field scFinalAngle(scWork,34,s16,0,1024);
Field scUnsignedAngle(scWork,36,u16,0,1024); Field scOffset(scWork,38,u16,0,1023);
Field scNumerator(scWork,40,s32,0,1048576); Field scNextProduct(scWork,44,s32,0,2101248);
Field scNextEstimate(scWork,48,s16,1,513); Set(scNextEstimate,1);
Field scNextAbove(scWork,50,u16,0,1); Field scXNegative(scWork,52,u16,0,1);
Field scYNegative(scWork,54,u16,0,1); Field scIncremented(scWork,56,u16,0,1);
Buffer scTangents(1731,4); Field scTX(scTangents,0,s16,-4096,4096); Field scTY(scTangents,2,s16,-4096,4096);
Buffer scFlags(1732,14);
Field scRecordOK(scFlags,0,u16,0,1); Field scTXOK(scFlags,2,u16,0,1); Field scTYOK(scFlags,4,u16,0,1);
Field scMajorOK(scFlags,6,u16,0,1); Field scIndexOK(scFlags,8,u16,0,1);
Field scAngleOK(scFlags,10,u16,0,1); Field scAtanOK(scFlags,12,u16,0,1);
Buffer scClippedMajor(1733,2); Field scMajorClipped(scClippedMajor,0,u16,2048,4096); Set(scMajorClipped,2048);
Buffer scClippedIndex(1734,2); Field scIndexSigned(scClippedIndex,0,s16,0,256);
Buffer scAtanValue(1735,1); Field scAtanByte(scAtanValue,0,u8,0,128);
Buffer scConstants(1736,2); Field scWrapValue(scConstants,0,u16,1024,1024); Set(scWrapValue,1024);
Program scInterpolate(3000) {
    MatLoad(vpM0,scDelta); MatLoad(vpM1,road_fraction14Wide);
    MatMul(vpM2,vpM0,vpM1); MatScale(vpM3,vpM2,0.00006103515625); MatFloor(vpM4,vpM3);
    MatLoad(vpM5,scBase); MatAdd(vpM6,vpM5,vpM4); StoreI16Floor(scRawTangent,vpM6);
};
Program scSwapMajor(3001) {
    Copy(scMinor,scAbsX,2); Copy(scMajor,scAbsY,2); Set(scSwapped,1);
};
Program scIncrement(3002) {
    MatLoad(vpM0,scEstimateSigned); MatValues(vpM1,1); MatAdd(vpM2,vpM0,vpM1);
    StoreI16Floor(scCorrected,vpM2); Set(scIncremented,1);
};
Program scSwapAngle(3003) {
    MatLoad(vpM0,scSmall); MatValues(vpM1,256); MatSub(vpM2,vpM1,vpM0); StoreI16Floor(scBaseAngle,vpM2);
};
Program scFlipX(3004) {
    MatLoad(vpM0,scBaseAngle); MatValues(vpM1,512); MatSub(vpM2,vpM1,vpM0); StoreI16Floor(scAngleX,vpM2);
};
Program scFlipY(3005) {
    MatLoad(vpM0,scAngleX); MatValues(vpM1,1024); MatSub(vpM2,vpM1,vpM0); StoreI16Floor(scFinalAngle,vpM2);
};
Program scWrap(3006) { Set(scUnsignedAngle,0); };
Program scRatio(3007) {
    WidenUnsigned(scMajorSigned,scMajorClipped); WidenUnsigned(scMinorSigned,scMinor);
    Identity(vpInverse); Scale(vpInverse,scMajorSigned,1); InvertAffine(vpInverse); MatExtract(vpM0,vpInverse,0,0);
    MatLoad(vpM1,scMinorSigned); MatScale(vpM2,vpM1,256); StorePositive32Floor(scNumerator,vpM2);
    MatMul(vpM3,vpM2,vpM0); StoreU16Floor(scEstimate,vpM3);
    WidenUnsigned(scEstimateSigned,scEstimate); WidenUnsigned(scCorrected,scEstimate);
    MatLoad(vpM0,scEstimateSigned); MatValues(vpM1,1); MatAdd(vpM2,vpM0,vpM1); StoreI16Floor(scNextEstimate,vpM2);
    MatLoad(vpM0,scNextEstimate); MatLoad(vpM1,scMajorSigned); MatMul(vpM2,vpM0,vpM1); StorePositive32Floor(scNextProduct,vpM2);
    LessThan(scNextAbove,scNumerator,scNextProduct); CallIf(scIncrement,scNextAbove,eq,vehicleZero);
    CopyChecked(scIndexSigned,scCorrected,scIndexOK); MatLoad(vpM0,scIndexSigned); StoreU16Floor(scIndex,vpM0);
    LoadElement(scAtanValue,scAtan,scIndex,scAtanOK); WidenUnsigned(scSmall,scAtanByte); WidenUnsigned(scBaseAngle,scAtanByte);
    CallIf(scSwapAngle,scSwapped,eq,vehicleOne);
    Copy(scAngleX,scBaseAngle,2); CallIf(scFlipX,scXNegative,eq,vehicleOne);
    Copy(scFinalAngle,scAngleX,2); CallIf(scFlipY,scYNegative,eq,vehicleOne);
    MatLoad(vpM0,scFinalAngle); StoreU16Floor(scUnsignedAngle,vpM0);
    CallIf(scWrap,scUnsignedAngle,eq,scWrapValue); CopyChecked(scOffset,scUnsignedAngle,scAngleOK);
};
Program scHeading(3008) {
    Set(scOffset,0); Set(scIncremented,0);
    LoadElement(vpHeading,vpHeadings,road_interval,scRecordOK);
    Copy(scBase,vpSourceTX,2); Copy(scDelta,vpSourceDX,2); Call(scInterpolate); CopyChecked(scTX,scRawTangent,scTXOK);
    Copy(scBase,vpSourceTY,2); Copy(scDelta,vpSourceDY,2); Call(scInterpolate); CopyChecked(scTY,scRawTangent,scTYOK);
    MatLoad(vpM0,scTX); MatAbs(vpM1,vpM0); StoreU16Floor(scAbsX,vpM1);
    MatLoad(vpM0,scTY); MatAbs(vpM1,vpM0); StoreU16Floor(scAbsY,vpM1);
    LessThan(scXNegative,scTX,vpSignedZero); LessThan(scYNegative,scTY,vpSignedZero);
    Copy(scMinor,scAbsY,2); Copy(scMajor,scAbsX,2); Set(scSwapped,0);
    CallIf(scSwapMajor,scAbsX,lt,scAbsY); CopyChecked(scMajorClipped,scMajor,scMajorOK);
    CallIf(scRatio,scMajorOK,eq,vehicleOne);
};
'''
    anchor='    Call(vdDrawAll);';assert s.count(anchor)==1
    s=s.replace(anchor,anchor+'\n    Call(scHeading);')
    target=root/(track+'-scenery-heading.golem');target.write_text(s);return target

if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('track',choices=['oval','fuji']);a=p.parse_args()
    print(build(a.track,TASK/'.work/scenery-heading-source'))
