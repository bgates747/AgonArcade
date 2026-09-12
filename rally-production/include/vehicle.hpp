#pragma once
#include <stdint.h>
#include "bearing_table.hpp"

namespace rally { namespace r18 {

// The bitmap is the existing 102x77 nearest-neighbour enlargement. In view0,
// the rear tyres occupy x23..35 and67..79, ending on local row59. Their pixel
// centre is x=51. Reflection x'=101-x moves that centre to x=50.
constexpr int PlayerDrawY=154;
constexpr int PlayerContactY=214;
constexpr int PlayerAnchorY=60;
constexpr int PlayerAnchorX=51;
constexpr int PlayerMirrorAnchorX=50;
constexpr int PlayerProjectionQ=PlayerContactY-96;

struct Pose {
    uint8_t view;
    bool mirrored;
};

// Motion-like input only needs its existing signed Q8 lateral state. All
// callers should supply the projected road centre at PlayerContactY. The
// default is the straight-road centre, useful for isolated placement tests.
template<class MotionType>
inline int playerCenterX(const MotionType &motion,int roadCenterX=160) {
    return roadCenterX+int(motion.lateral*PlayerProjectionQ/(50L*256));
}

template<class MotionType>
inline int playerDrawX(const MotionType &motion,int roadCenterX=160,bool mirrored=false) {
    return playerCenterX(motion,roadCenterX)-(mirrored?PlayerMirrorAnchorX:PlayerAnchorX);
}

// Angles are signed fractions of a 65536-unit turn. Valid rendered opponents
// can intersect the 320px view only within roughly 211px of its centre; 512px
// additionally covers the player's usual off-screen positions. Beyond that
// range use the extreme table entry, since no vehicle pixels are visible.
inline int16_t viewingBearing(int centerX) {
    int offset=centerX-160;
    bool negative=offset<0;
    unsigned magnitude=unsigned(negative?-offset:offset);
    if(magnitude>512) magnitude=512;
    unsigned index=magnitude>>1;
    int value=BearingAngles[index];
    if(magnitude&1) value+=(BearingAngles[index+1]-value+1)/2;
    return int16_t(negative?-value:value);
}

// The existing traffic cross product is a sine proxy, not a full atan2
// heading. Preserve its signed -90..90-degree branch; do not add new physics.
// Dense samples near |cross|=4096 avoid arcsine's steep endpoint error.
inline int16_t headingFromCross(int32_t cross) {
    bool negative=cross<0;
    if(cross>4096) cross=4096;
    if(cross< -4096) cross= -4096;
    unsigned magnitude=unsigned(negative?-cross:cross);
    unsigned index,fraction,shift;
    if(magnitude<=3584) {
        index=magnitude>>5; fraction=magnitude&31; shift=5;
    } else if(magnitude<=3968) {
        unsigned local=magnitude-3584;
        index=112+(local>>3); fraction=local&7; shift=3;
    } else return int16_t(negative?-HeadingAngles[160+magnitude-3968]:HeadingAngles[160+magnitude-3968]);
    int value=HeadingAngles[index];
    if(fraction) value+=((HeadingAngles[index+1]-value)*int(fraction))>>shift;
    return int16_t(negative?-value:value);
}

inline Pose quantizeYaw(int angle) {
    bool mirrored=angle>0;
    unsigned magnitude=unsigned(angle<0?-angle:angle);
    // Source views are separated by 21/1024 turn: 1344 of these angle units.
    unsigned view=(magnitude+672)/1344;
    if(view>4) view=4;
    return {uint8_t(view),mirrored};
}

inline Pose playerPose(int steering,int centerX,bool perspective) {
    if(!perspective) {
        unsigned magnitude=unsigned(steering<0?-steering:steering);
        unsigned view=(magnitude*4+10)/21;
        if(view>4) view=4;
        return {uint8_t(view),steering>0};
    }
    return quantizeYaw(steering*256-int(viewingBearing(centerX)));
}

inline Pose trafficPose(int32_t cross,int centerX,bool perspective) {
    if(!perspective) {
        int32_t magnitude=cross<0?-cross:cross;
        unsigned view=magnitude<264?0:magnitude<787?1:magnitude<1297?2:magnitude<1785?3:4;
        return {uint8_t(view),cross>0};
    }
    return quantizeYaw(int(headingFromCross(cross))-int(viewingBearing(centerX)));
}

} }
