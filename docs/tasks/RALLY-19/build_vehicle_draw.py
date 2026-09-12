"""Draw VDP-projected cars with the original bitmap indices and affine matrices."""
import argparse
from profile import TASK
from build_vehicle_projection import build as projection

def build(track,root):
    source=projection(track,root);s=source.read_text()
    # scene_masks consumes the original unrounded Q8 road-centre diagnostic.
    # Keep the qualified rounded endpoint trace1600 for raster edge checks,
    # and separately export each evaluator result before it is overwritten.
    s+='\nBuffer vdRoadPixels(1724,132);\n'
    for i in range(33):
        s+=f'Field vdRoadPixel{i}(vdRoadPixels,{4*i},f32,-4096,4095);\n'
        anchor=f'Copy(road_tracePaint{i},road_painted,2);';assert s.count(anchor)==1
        s=s.replace(anchor,anchor+f' Copy(vdRoadPixel{i},vpRoadPixel,4);')
    s+='''
Buffer vdCar(1721,16);
Field vdVisible(vdCar,0,u16,0,1); Field vdID(vdCar,2,u16,0,5);
Field vdBitmap(vdCar,4,u16,0,34); Field vdScale(vdCar,6,u16,14,250);
Field vdMirror(vdCar,8,u16,0,1); Field vdX(vdCar,10,s16,-5000,5000);
Field vdY(vdCar,12,s16,0,239); Field vdTranslation(vdCar,14,u16,0,25250);
Buffer vdWork(1722,8);
Field vdIndex(vdWork,0,u16,0,5);
Field vdScaleSigned(vdWork,4,s16,14,250); Field vdTranslationSigned(vdWork,6,s16,0,25250);
Buffer vdStatus(1723,2); Field vdOK(vdStatus,0,u16,0,1);
Matrix vdMatrix(1894,3,3); Matrix vdSource(1895,1,1);
Matrix vdScaleValue(1896,1,1); Matrix vdTranslationValue(1897,1,1);
Field vdScaleFloat(vdScaleValue,0,f32); Field vdTranslationFloat(vdTranslationValue,0,f32);
Program vdStraight(2961) {
    WidenUnsigned(vdScaleSigned,vdScale); MatLoad(vdSource,vdScaleSigned);
    MatScale(vdScaleValue,vdSource,0.00390625);
    Identity(vdMatrix); Scale(vdMatrix,vdScaleFloat,vdScaleFloat);
    DrawBitmap(vdBitmap,vdX,vdY,vdMatrix);
};
Program vdReflected(2962) {
    WidenUnsigned(vdScaleSigned,vdScale); MatLoad(vdSource,vdScaleSigned);
    MatScale(vdScaleValue,vdSource,0.00390625);
    WidenUnsigned(vdTranslationSigned,vdTranslation); MatLoad(vdSource,vdTranslationSigned);
    MatScale(vdTranslationValue,vdSource,0.00390625);
    Identity(vdMatrix); Scale(vdMatrix,-1,1); Scale(vdMatrix,vdScaleFloat,vdScaleFloat);
    Translate(vdMatrix,vdTranslationFloat,0); DrawBitmap(vdBitmap,vdX,vdY,vdMatrix);
};
Program vdDrawSelected(2963) {
    CallIf(vdStraight,vdMirror,eq,vehicleZero); CallIf(vdReflected,vdMirror,eq,vehicleOne);
};
Program vdPlayerStraight(2964) { DrawBitmap(vpPlayerBitmap,vpPlayerX,vpPlayerY); };
Program vdPlayerReflected(2965) {
    Identity(vdMatrix); Scale(vdMatrix,-1,1); Translate(vdMatrix,101,0);
    DrawBitmap(vpPlayerBitmap,vpPlayerX,vpPlayerY,vdMatrix);
};
Program vdDrawAll(2960) {
'''
    for i in range(6):
        s+=f'    Set(vdIndex,{i}); LoadElement(vdCar,vpOutput,vdIndex,vdOK);\n'
        s+='    CallIf(vdDrawSelected,vdVisible,eq,vehicleOne);\n'
    s+='''    CallIf(vdPlayerStraight,vpPlayerMirror,eq,vehicleZero);
    CallIf(vdPlayerReflected,vpPlayerMirror,eq,vehicleOne);
};
'''
    anchor='    Call(vpProjectAll);';assert s.count(anchor)==1
    s=s.replace(anchor,anchor+'\n    Call(vdDrawAll);')
    target=root/(track+'-vehicle-draw.golem');target.write_text(s);return target

if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('track',choices=['oval','fuji']);a=p.parse_args()
    print(build(a.track,TASK/'.work/vehicle-draw-source'))
