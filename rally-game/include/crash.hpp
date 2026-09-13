#pragma once
#include "race_traffic.hpp"
namespace rally::game {
struct Crash {
    uint16_t remaining=0,invulnerable=0;
    void begin(Motion &car) {remaining=150;car.speed=0;car.lateralVelocity=0;}
    // Returns true while control is suspended. Recovery waits for a clear lane.
    bool tick(Motion &car,const RaceTraffic &traffic,uint32_t player) {
        if(!remaining) {if(invulnerable)--invulnerable;return false;}
        car.speed=0;car.lateralVelocity=0;
        if(remaining>1) {--remaining;return true;}
        const int lanes[]={0,-36,36,-65,65};
        for(int lane:lanes)if(!traffic.contact(player,lane*256L)) {
            car.lateral=lane*256L;car.steering=0;remaining=0;invulnerable=120;return true;
        }
        return true;
    }
};
}
