#pragma once
#include "road.hpp"
namespace rally::game {
// Held keys are sampled once per rendered update. The step changes the
// response rate, not the +/-21 range or the five mirrored artwork views.
inline void steerFrame(Motion &car,bool left,bool right,unsigned step) {
    if(left==right)return;
    car.steering+=right?int(step):-int(step);
    if(car.steering>21)car.steering=21;
    if(car.steering< -21)car.steering= -21;
}
}
