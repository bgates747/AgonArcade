#pragma once
// Compiles the actual normal game's input()/tick(), including rules, recovery,
// route/contact/passing/rank and view preparation. No assisted-driver macros.
#define main preserved_product_main
#include "physics_product.cpp"
#undef main
namespace capacity {
constexpr unsigned Scenarios=4, Block=1024;
unsigned activeScenario=0;
void setup(unsigned which) {
    activeScenario=which;selected=&rally::Fuji; rules=Rules{};rules.settings=FujiRules;
    rules.policy=which==1?Policy::Arcade:Policy::Circuit;
    rules.phase=which==2?Phase::Qualify:Phase::Race;
    rules.lapLength=selected->length*100;rules.remaining=FujiRules.raceSeconds*Hz;
    rules.grid=7;rules.maxGrip=200;shownRevision=rules.revision;
    resetMotion();motion.grip=200;motion.speed=which==0?300:which==1?160:which==2?150:220;
    motion.position=(which*700000UL+500000UL)%(selected->length*100);
    motion.lateral=which==1?96*256L:which==2?140*256L:0;
    if(which==0)motion.position=100000;
    if(which==3)motion.lateral=-14260;
    motion.cornerAssist=false;motion.demoCurveSteering=0;
    memset(heldKeys,0,sizeof heldKeys);memset(previousKeys,0,sizeof previousKeys);
    inputArmed=true;quit=false;muted=true;engine.active=false;
    if(which==0) {
        auto &c=raceTraffic.cars[0];c.position=motion.position+6800+5000;c.progress=5000;
    }
    if(which==3) { // Explicit recovery branch coverage, not a naturally observed collision.
        auto &c=raceTraffic.cars[0];c.position=wrap(motion.position+6800,selected->length*100);
        c.lateral=motion.lateral;c.progress=0;
    }
}
void step(unsigned i) {
    // Replay original frame-rate control semantics at four physics ticks/frame.
    // These are numerical 120-unit ticks with original /100 integrators, not a
    // newly chosen real-time cadence. No live keyboard/MOS or sound in loop.
    if((i&3)==0) {
        memcpy(previousKeys,heldKeys,sizeof heldKeys);memset(heldKeys,0,sizeof heldKeys);
        const unsigned t=i&255;
        const int codes[]={t<208?58:42,activeScenario==0?0:t<64?26:t<128?122:0};
        for(int c:codes)if(c)heldKeys[(c-1)/8]|=1<<((c-1)%8);
        input();
    }
    tick();
}
// Explicit values avoid target/host struct padding, pointer and int-width differences.
template<class Emit> void snapshot(unsigned which,Emit emit) {
    unsigned field=0;auto put=[&](uint32_t x){emit(which,field++,x);};
    put(motion.phase);put(motion.position);put(motion.speed);put(motion.lateral);put(motion.lateralVelocity);
    put(motion.steering);put(motion.grip);put(crash.remaining);put(crash.invulnerable);
    put(unsigned(rules.phase));put(rules.phaseTicks);put(rules.elapsed);put(rules.remaining);
    put(rules.progress);put(rules.score);put(rules.distanceRemainder);put(rules.rank);put(rules.laps);
    put(rules.lapBegin);put(rules.lapTime);put(rules.bestLap);put(rules.revision);
    put(raceTraffic.nextSpawn);put(raceTraffic.pace.record);put(raceTraffic.pace.remaining);
    put(raceTraffic.pace.heading);put(raceTraffic.pace.lateral);
    for(unsigned i=0;i<6;++i) {
        const auto &c=raceTraffic.cars[i];put(c.active);put(c.generation);put(c.gridOrder);
        put(c.progress);put(c.position);put(c.lateral);put(c.finish);
        put(c.cursor.record);put(c.cursor.remaining);put(c.cursor.heading);put(c.cursor.lateral);
        put(traffic.cars[i].position);put(traffic.cars[i].lane);
    }
}
}
