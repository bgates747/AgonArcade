"""Append numeric retained-page history to the qualified scene/heading kernel.

This proof construction advances a logical page per admitted call; actual swap
and final scenery-first draw ordering belong to subsequent image integration.
"""
from build_scenery_heading import build as heading

def build(track,root):
    source=heading(track,root);s=source.read_text()
    s+='''
Buffer shState(1740,58);
Field shSlot(shState,0,u16,0,1);
Field shOffset0(shState,2,u16,0,1023); Field shValid0(shState,4,u16,0,1);
Field shOffset1(shState,6,u16,0,1023); Field shValid1(shState,8,u16,0,1);
Field shOldOffset(shState,10,u16,0,1023); Field shOldValid(shState,12,u16,0,1);
Field shRaw(shState,14,u16,513,2559); Set(shRaw,513);
Field shQuotient(shState,16,u16,0,2); Field shRawRemainder(shState,18,s16,-2048,2559);
Field shRemainder(shState,20,s16,0,1023); Field shRemainderWord(shState,22,u16,0,1023);
Field shDelta(shState,24,s16,-512,511); Field shFull(shState,26,u16,0,1);
Field shLeftRaw(shState,28,s16,-191,832); Field shRightRaw(shState,30,s16,-512,511);
Field shLeft(shState,32,s16,0,319); Field shRight(shState,34,s16,0,319);
Field shRepaint(shState,36,u16,0,1); Field shSignedOffset(shState,38,s16,0,1023);
Field shBitmapX(shState,40,s16,-1023,0); Field shWrapX(shState,42,s16,1,1024); Set(shWrapX,1);
Field shDirection(shState,44,u16,0,1); Field shAmount(shState,46,u16,0,255);
Field shUnclippedAmount(shState,48,u16,0,512);
Field shOldSigned(shState,50,s16,0,1023); Field shRawSigned(shState,52,s16,513,2559); Set(shRawSigned,513);
Field shQuotientSigned(shState,54,s16,0,2); Field shSlotSigned(shState,56,s16,0,1);
Buffer shFlags(1741,8);
Field shRemainderOK(shFlags,0,u16,0,1); Field shLeftOK(shFlags,2,u16,0,1);
Field shRightOK(shFlags,4,u16,0,1); Field shAmountOK(shFlags,6,u16,0,1);
Buffer shConstants(1742,6);
Field shLower(shConstants,0,u16,257,257); Set(shLower,257);
Field shUpper(shConstants,2,u16,767,767); Set(shUpper,767);
Field shMiddle(shConstants,4,u16,512,512); Set(shMiddle,512);
Program shReadOne(3020) { Copy(shOldOffset,shOffset1,2); Copy(shOldValid,shValid1,2); };
Program shStoreZero(3021) { Copy(shOffset0,scOffset,2); Set(shValid0,1); };
Program shStoreOne(3022) { Copy(shOffset1,scOffset,2); Set(shValid1,1); };
Program shRequireFull(3023) { Set(shFull,1); };
Program shFullUpdate(3024) { Set(shDelta,0); Set(shLeft,0); Set(shRight,319); Set(shRepaint,1); };
Program shPositive(3025) {
    MatLoad(vpM0,shDelta); MatValues(vpM1,320); MatSub(vpM2,vpM1,vpM0);
    StoreI16Floor(shLeftRaw,vpM2); CopyChecked(shLeft,shLeftRaw,shLeftOK);
    Set(shRight,319); Set(shRepaint,1); Set(shDirection,1);
};
Program shNegative(3026) {
    MatLoad(vpM0,shDelta); MatValues(vpM1,-1); MatSub(vpM2,vpM1,vpM0);
    StoreI16Floor(shRightRaw,vpM2); CopyChecked(shRight,shRightRaw,shRightOK);
    Set(shLeft,0); Set(shRepaint,1); Set(shDirection,0);
};
Program shPartialUpdate(3027) {
    CallIf(shPositive,shRemainderWord,gt,shMiddle);
    CallIf(shNegative,shRemainderWord,lt,shMiddle);
};
Program shHistory(3028) {
    Copy(shOldOffset,shOffset0,2); Copy(shOldValid,shValid0,2);
    CallIf(shReadOne,shSlot,eq,vehicleOne);
    WidenUnsigned(shSignedOffset,scOffset);
    WidenUnsigned(shOldSigned,shOldOffset);
    MatLoad(vpM0,shSignedOffset); MatLoad(vpM1,shOldSigned);
    MatSub(vpM2,vpM0,vpM1); MatValues(vpM3,1536); MatAdd(vpM4,vpM2,vpM3);
    StoreU16Floor(shRaw,vpM4); MatScale(vpM5,vpM4,0.0009765625); StoreU16Floor(shQuotient,vpM5);
    WidenUnsigned(shQuotientSigned,shQuotient); WidenUnsigned(shRawSigned,shRaw);
    MatLoad(vpM0,shQuotientSigned); MatScale(vpM1,vpM0,1024); MatLoad(vpM2,shRawSigned); MatSub(vpM3,vpM2,vpM1);
    StoreI16Floor(shRawRemainder,vpM3); CopyChecked(shRemainder,shRawRemainder,shRemainderOK);
    MatLoad(vpM0,shRemainder); StoreU16Floor(shRemainderWord,vpM0);
    MatValues(vpM1,512); MatSub(vpM2,vpM0,vpM1); StoreI16Floor(shDelta,vpM2);
    Set(shFull,0); Set(shLeft,0); Set(shRight,0); Set(shRepaint,0); Set(shDirection,0);
    Set(shLeftOK,1); Set(shRightOK,1);
    CallIf(shRequireFull,shOldValid,eq,vehicleZero);
    CallIf(shRequireFull,shRemainderWord,lt,shLower);
    CallIf(shRequireFull,shRemainderWord,gt,shUpper);
    CallIf(shPartialUpdate,shFull,eq,vehicleZero); CallIf(shFullUpdate,shFull,eq,vehicleOne);
    MatLoad(vpM0,shDelta); MatAbs(vpM1,vpM0); StoreU16Floor(shUnclippedAmount,vpM1);
    CopyChecked(shAmount,shUnclippedAmount,shAmountOK);
    MatLoad(vpM0,shSignedOffset); MatScale(vpM1,vpM0,-1); StoreI16Floor(shBitmapX,vpM1);
    MatValues(vpM1,1024); MatSub(vpM2,vpM1,vpM0); StoreI16Floor(shWrapX,vpM2);
    CallIf(shStoreZero,shSlot,eq,vehicleZero); CallIf(shStoreOne,shSlot,eq,vehicleOne);
};
Program shAdvance(3029) {
    WidenUnsigned(shSlotSigned,shSlot);
    MatLoad(vpM0,shSlotSigned); MatValues(vpM1,1); MatSub(vpM2,vpM1,vpM0); StoreU16Floor(shSlot,vpM2);
};
'''
    anchor='    Call(scHeading);';assert s.count(anchor)==1
    s=s.replace(anchor,anchor+'\n    Call(shHistory); Call(shAdvance);')
    target=root/(track+'-scenery-history.golem');target.write_text(s);return target
