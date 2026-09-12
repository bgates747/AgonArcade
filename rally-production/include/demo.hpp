#pragma once
#include "road.hpp"
namespace rally {
struct DemoDriver {
    int targetSpeed=224;
    void frame(Motion &car) {
        // Reserve grip for correction; look far enough ahead to brake for bends.
        int32_t p=car.position/100*256;
        auto here=trackSample(p,*car.track),next=trackSample(p+64L*256,*car.track);
        int32_t localBend=(here.tx*next.ty-here.ty*next.tx)/4096;
        // Approximate road-following wheel angle (42-unit wheelbase). The road
        // frame already turns automatically, so only residual steering drives
        // lateral motion. Actual steering, including this baseline, selects art.
        car.demoCurveSteering=car.speed>10?int(localBend*27/4096):0;
        int32_t bendMax=0;
        for(int ahead=0;ahead<=512;ahead+=64) {
            auto a=trackSample(p+ahead*256L,*car.track);
            auto b=trackSample(p+(ahead+64)*256L,*car.track);
            int32_t bend=(a.tx*b.ty-a.ty*b.tx)/4096;
            if(bend<0) bend=-bend;
            if(bend>bendMax) bendMax=bend;
        }
        int32_t budget=int32_t(car.grip)*180*256/100*60/100;
        if(car.offroad()) budget/=2;
        targetSpeed=224;
        while(targetSpeed>40 && int32_t(targetSpeed)*targetSpeed*bendMax/1024>budget)
            targetSpeed-=4;
        // Track-relative lateral velocity target, with damping. Never move the
        // car directly or bypass the normal grip and surface physics.
        int32_t wanted=-car.lateral*2-car.lateralVelocity/2;
        int angle=car.speed>10?int(wanted*63/(int32_t(car.speed)*512)):0;
        angle+=car.demoCurveSteering;
        if(angle>21) angle=21;
        if(angle< -21) angle=-21;
        int difference=angle-car.steering;
        if(difference>3) difference=3;
        if(difference< -3) difference=-3;
        car.steering+=difference;
    }
    void tick(Motion &car) const {
        car.tick(car.speed<targetSpeed,car.speed>targetSpeed+2);
    }
};
}
