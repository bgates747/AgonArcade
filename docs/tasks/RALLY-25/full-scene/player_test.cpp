#include "player.hpp"
#include "race_traffic.hpp"
#include <cassert>
#include <cstdio>
int main(){
    rally::Motion player;player.track=&rally::Fuji;player.position=player.track->length*100-6800;player.phase=0;
    rally::game::Rules rules;full_scene::Player driver;
    rally::game::RaceTraffic traffic;traffic.reset(rally::game::Policy::Circuit,player.track->length*100,7,2);
    int32_t reference=player.position,phase=0;
    for(unsigned tick=1;tick<=3600;++tick){
        const auto &pace=traffic.pace;
        unsigned record=pace.remaining?pace.record:(pace.record+1)%6;
        int speed=rally::game::Route[record].speed;
        reference=(reference+speed*rally::WorldSpeedMultiplier)%(player.track->length*100);
        phase=(phase+speed*rally::WorldSpeedMultiplier)%(rally::Period*100);
        traffic.tick(tick*360,tick);driver.tick(player,rules);
        assert(player.position==reference&&player.phase==phase&&player.speed==speed);
        assert(player.lateral==0&&player.lateralVelocity==0&&player.steering==0&&rules.phaseTicks==tick);
        assert(driver.record==traffic.pace.record&&driver.remaining==traffic.pace.remaining);
    }
    std::printf("3600 full-scene player steps match R27 pace/position/phase/rule ticks.\n");
}
