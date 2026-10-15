#pragma once
#include "rules.hpp"
#include "routes_data.hpp"
#include "road.hpp"
namespace full_scene {
// R27-05 centerline/pace driver only. Opponent route state belongs to VDP.
struct Player {
    unsigned record=0,remaining=rally::game::Route[0].duration;
    void tick(rally::Motion &motion,rally::game::Rules &rules){
        if(!remaining){record=(record+1)%6;remaining=rally::game::Route[record].duration;}
        motion.speed=rally::game::Route[record].speed;--remaining;
        motion.lateral=motion.lateralVelocity=motion.steering=0;
        motion.position=(motion.position+motion.speed*rally::WorldSpeedMultiplier)%(motion.track->length*100);
        motion.phase=(motion.phase+motion.speed*rally::WorldSpeedMultiplier)%(rally::Period*100);
        rules.tick(0);
    }
};
}
