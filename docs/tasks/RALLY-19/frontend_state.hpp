#pragma once
// Raw simulation-to-wire mapping. No scene projection, sorting or bearings.
#include "road.hpp"
#include "traffic.hpp"
#include "scene_protocol.hpp"
namespace rally { namespace r19 {
inline bool stateFromMotion(const Motion&motion,const Traffic&traffic,uint16_t sequence,
                            bool demo,bool autosteer,State&out){
    State state;
    if(motion.track!=&TriOval && motion.track!=&Fuji)return false;
    if(motion.phase<0 || motion.phase>7999 || motion.speed<0 || motion.speed>300 ||
       motion.grip<25 || motion.grip>200 || motion.lateral< -38400 || motion.lateral>38400)return false;
    state.sequence=sequence;state.track=motion.track==&Fuji?1:0;
    state.position=motion.position;state.phase=uint16_t(motion.phase);
    state.steering=motion.steering;state.lateral=motion.lateral;state.speed=uint16_t(motion.speed);
    state.surface=uint16_t(motion.surface());state.grip=uint16_t(motion.grip);
    state.flags=(demo?1:0)|(autosteer?2:0);
    for(unsigned i=0;i<6;++i){
        if(traffic.cars[i].lane< -90 || traffic.cars[i].lane>90)return false;
        state.cars[i].position=traffic.cars[i].position;state.cars[i].lane=int16_t(traffic.cars[i].lane);
    }
    if(!valid(state))return false;
    out=state;return true;
}
}}
