"""Resident scenery-first scene, using qualified heading/history and clip/scroll.

Original panorama100 is bootstrapped by the host once. Per-frame state remains
the existing80-byte ABI. The host must swap once after each accepted scene call.
"""
from build_scenery_history import build as history

def build(track,root):
    source=history(track,root);s=source.read_text()
    s+='''
Buffer sgConstants(1750,12);
Field sgZero(sgConstants,0,s16,0,0);
Field sgRight(sgConstants,2,s16,319,319); Set(sgRight,319);
Field sgSkyBottom(sgConstants,4,s16,103,103); Set(sgSkyBottom,103);
Field sgRepairTop(sgConstants,6,s16,88,88); Set(sgRepairTop,88);
Field sgScreenBottom(sgConstants,8,s16,239,239); Set(sgScreenBottom,239);
Field sgBitmap(sgConstants,10,u16,100,100); Set(sgBitmap,100);
Buffer sgWords(1751,8);
Field sgWrapWord(sgWords,0,u16,1,1024); Set(sgWrapWord,1);
Field sgLeftWord(sgWords,2,u16,0,319); Field sgRightWord(sgWords,4,u16,0,319);
Field sgScreenRightWord(sgWords,6,u16,319,319); Set(sgScreenRightWord,319);
Program sgDrawLeft(3040) { DrawBitmap(sgBitmap,shBitmapX,sgZero); };
Program sgDrawRight(3041) { DrawBitmap(sgBitmap,shWrapX,sgZero); };
Program sgScroll(3042) {
    GraphicsViewport(sgZero,sgZero,sgRight,sgSkyBottom);
    ScrollGraphics(shDirection,shAmount);
};
Program sgRepaint(3043) {
    GraphicsViewport(shLeft,sgZero,shRight,sgSkyBottom);
    CallIf(sgDrawLeft,sgWrapWord,gt,sgLeftWord);
    CallIf(sgDrawRight,sgWrapWord,le,sgRightWord);
};
Program sgRepair(3044) {
    GraphicsViewport(sgZero,sgRepairTop,sgRight,sgSkyBottom);
    Call(sgDrawLeft); CallIf(sgDrawRight,sgWrapWord,le,sgScreenRightWord);
};
Program sgDrawScenery(3045) {
    MatLoad(vpM0,shWrapX); StoreU16Floor(sgWrapWord,vpM0);
    MatLoad(vpM0,shLeft); StoreU16Floor(sgLeftWord,vpM0);
    MatLoad(vpM0,shRight); StoreU16Floor(sgRightWord,vpM0);
    CallIf(sgScroll,shAmount,gt,vehicleZero);
    CallIf(sgRepaint,shRepaint,eq,vehicleOne);
    CallIf(sgRepair,shRepaint,eq,vehicleZero);
    CallIf(sgRepair,shAmount,gt,vehicleZero);
    GraphicsViewport(sgZero,sgZero,sgRight,sgScreenBottom);
};
'''
    old='    Call(road_prepareProjection); Set(road_topRow,104);';assert s.count(old)==1
    s=s.replace(old,'    Set(road_topRow,104);')
    old='''    Call(road_fullRoad);
    Call(vpProjectAll);
    Call(vdDrawAll);
    Call(scHeading);
    Call(shHistory); Call(shAdvance);'''
    new='''    Call(road_prepareProjection);
    Call(scHeading); Call(shHistory); Call(sgDrawScenery);
    Call(road_fullRoad); Call(vpProjectAll); Call(vdDrawAll);
    Call(shAdvance);'''
    assert s.count(old)==1;s=s.replace(old,new)
    # Stock ESP32 VDP processLoop has a 4096-byte task stack. Collapse selected
    # immutable wrappers, retaining buffer storage and all conditional guards.
    # Hardware reset evidence and temporary stack diagnostic: HARDWARE-DEBUG.md.
    s += '\nInlineCalls(renderProof, road_projectRow, road_drawSection, vpProcess, vehicleComputeDistance, vpComputeHeading, road_fullRoad, vpProjectAll, vdDrawAll);\n'
    target=root/(track+'-scenery-draw.golem');target.write_text(s);return target
