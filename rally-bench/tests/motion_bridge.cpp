// Host test boundary around the unchanged production physics and wire encoder.
#include "telemetry.hpp"
#include "engine.hpp"
#include "traffic_policy.hpp"
#include "controls.hpp"
#include <cassert>
#include <vector>
static rally::Motion motion;
static rally::Traffic traffic;
static rally::bench::TrafficObservation observation;
static uint32_t clockTicks,frame;
static unsigned steeringStep=3;
extern "C" {
void begin(unsigned fuji,int lateral){
    motion=rally::Motion{};motion.track=fuji?&rally::Fuji:&rally::TriOval;
    motion.cornerAssist=false;motion.lateral=lateral*256;clockTicks=frame=0;
    traffic.init(motion.position,motion.track->length*100);observation={};
}
void set_grip(int grip){motion.grip=grip;}
void set_step(unsigned step){assert(step>=1&&step<=3);steeringStep=step;}
void set_car(unsigned i,int distance,int lane,int speed){
    assert(i<6);traffic.cars[i]={int32_t((motion.position+(distance+68)*100+
        motion.track->length*100)%(motion.track->length*100)),speed,lane};
}
void advance(unsigned keys,unsigned elapsed,uint8_t *out){
    rally::bench::steerFrame(motion,keys&1,keys&2,steeringStep);
    for(unsigned i=0;i<elapsed;++i){
        motion.tick(keys&4,keys&8);traffic.tick(motion.track->length*100);
        observation.tick(motion,traffic);
    }
    clockTicks+=elapsed;++frame;
    rally::bench::snapshot(out,motion,42,frame,clockTicks,clockTicks,elapsed,false,false,keys,traffic,observation,steeringStep);
}
void audio_check(){
    rally::bench::Engine engine;std::vector<uint8_t> bytes;
    auto send=[&](const uint8_t *p,unsigned n){bytes.insert(bytes.end(),p,p+n);};
    engine.update(100,send);engine.stop(send);assert(bytes.empty());
    engine.start(send);assert(engine.active&&engine.frequency==80);
    const auto start=bytes.size();engine.update(0,send);assert(bytes.size()==start);
    for(int speed=0;speed<=300;++speed){
        const auto old=engine.frequency;engine.update(speed,send);assert(engine.frequency>=old);
    }
    assert(engine.frequency==680);engine.stop(send);assert(!engine.active);
    assert(bytes[bytes.size()-2]==2&&bytes.back()==0);
}
void contacts_check(){
    rally::Motion m;m.track=&rally::TriOval;
    rally::Traffic t;t.init(100000,m.track->length*100);
    rally::bench::TrafficObservation o;
    t.cars[0]={6800,0,0};o.tick(m,t);assert(o.contacts==1&&o.mask==1);
    o.tick(m,t);assert(o.contacts==1); // One entry, not one per overlapping tick.
    m.lateral=25*256;o.tick(m,t);assert(o.mask==0&&o.contacts==1);
    m.lateral=0;o.tick(m,t);assert(o.contacts==2);
    m.position=m.track->length*100-100;t.cars[0].position=6700;
    assert(rally::bench::relativePosition(m,t.cars[0])==0); // Lap boundary.
    m.position=0;t.cars[0].position=m.track->length*100-100;
    assert(rally::bench::relativePosition(m,t.cars[0])==-6900);
    rally::Traffic original,adapted;const int32_t lap=m.track->length*100;
    original.init(0,lap);
    assert(rally::bench::CirculatingTraffic::initialise(adapted,0,lap));
    for(unsigned tick=0;tick<12000;++tick){
        original.tick(lap);rally::bench::CirculatingTraffic::tick(adapted,lap);
        for(unsigned i=0;i<6;++i){
            assert(original.cars[i].position==adapted.cars[i].position);
            assert(original.cars[i].speed==adapted.cars[i].speed);
            assert(original.cars[i].lane==adapted.cars[i].lane);
        }
    }
    auto copy=adapted;
    assert(!rally::bench::TriggeredTraffic::available);
    assert(!rally::bench::TriggeredTraffic::initialise(adapted,0,lap));
    assert(!rally::bench::TriggeredTraffic::spawn(adapted,{0,0,100,0}));
    assert(!rally::bench::TriggeredTraffic::despawn(adapted,0));
    rally::bench::TriggeredTraffic::tick(adapted,lap);
    for(unsigned i=0;i<6;++i)assert(copy.cars[i].position==adapted.cars[i].position);
}
}
