// RALLY-21 interface intake only. No new opponent motion in this demo.
#pragma once
#include "traffic.hpp"
namespace rally::bench {
enum class TrafficMode { CirculatingRace, TriggeredArcade };
struct TrafficSpawn {
    unsigned slot;
    int32_t position;
    int speed,lane;
};
// Compile-time selection keeps the current circulating loop exactly as before.
// A future selectable mode must check available/initialise, never silently
// substitute the circulating implementation for an unimplemented arcade mode.
template<TrafficMode Mode> struct TrafficPolicy {
    static constexpr bool available=Mode==TrafficMode::CirculatingRace;
    static bool initialise(Traffic &traffic,int32_t start,int32_t lap){
        if constexpr(available){traffic.init(start,lap);return true;}
        return false;
    }
    static void tick(Traffic &traffic,int32_t lap){
        if constexpr(available)traffic.tick(lap);
    }
    // Circulating cars keep their identity/population. The arcade policy's
    // spawn/despawn implementation and occupancy rules are explicitly pending.
    static bool spawn(Traffic &,const TrafficSpawn &){return false;}
    static bool despawn(Traffic &,unsigned){return false;}
};
using CirculatingTraffic=TrafficPolicy<TrafficMode::CirculatingRace>;
using TriggeredTraffic=TrafficPolicy<TrafficMode::TriggeredArcade>;
}
