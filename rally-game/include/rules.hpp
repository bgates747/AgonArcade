#pragma once
#include <stdint.h>
namespace rally::game {
constexpr uint32_t Hz=120;
enum class Phase : uint8_t { Attract, Select, QualifyReady, Qualify, Qualified,
    RaceReady, Race, Finished, TimeUp, NotQualified };
enum class Policy : uint8_t { Circuit, Arcade };
struct Settings {
    uint16_t qualifySeconds, poleSeconds, raceSeconds, extensionSeconds;
    uint8_t laps;
};
constexpr Settings OvalRules{20,11,20,16,6}, FujiRules{90,60,85,75,2};
inline bool driving(Phase p) { return p==Phase::Qualify || p==Phase::Race; }
inline bool result(Phase p) {
    return p==Phase::Finished || p==Phase::TimeUp || p==Phase::NotQualified;
}
// Pure tick-based rules. Distances are hundredths of a world unit and clocks
// are raw 120Hz MOS ticks, including catch-up ticks. No renderer or device API.
struct Rules {
    Settings settings=OvalRules;
    Policy policy=Policy::Circuit;
    Phase phase=Phase::Attract;
    uint32_t phaseTicks=0, elapsed=0, remaining=0, lapBegin=0;
    uint32_t lapTime=0, bestLap=0, qualifyingTime=0, score=0, progress=0;
    uint32_t lapLength=0, distanceRemainder=0;
    uint16_t revision=0, extensionNotice=0;
    uint8_t laps=0, grid=7, rank=7;
    int maxGrip=60;
    void enter(Phase p) { phase=p;phaseTicks=0;++revision; }
    void addScore(uint32_t n) {
        score=n>9999999UL-score?9999999UL:score+n;
    }
    void resetRaceDistance() {
        progress=0;elapsed=0;lapBegin=0;laps=0;distanceRemainder=0;
        extensionNotice=0;
    }
    void attempt(uint32_t length,Settings balance,int grip) {
        settings=balance;lapLength=length;score=0;bestLap=0;lapTime=0;
        qualifyingTime=0;grid=rank=7;maxGrip=grip;
        resetRaceDistance();remaining=uint32_t(settings.qualifySeconds)*Hz;
        enter(Phase::QualifyReady);
    }
    void raceReady() {
        resetRaceDistance();remaining=uint32_t(settings.raceSeconds)*Hz;
        rank=grid;enter(Phase::RaceReady);
    }
    uint8_t qualifyingGrid(uint32_t ticks) const {
        const uint32_t pole=uint32_t(settings.poleSeconds)*Hz;
        const uint32_t limit=uint32_t(settings.qualifySeconds)*Hz;
        if(ticks<=pole)return 1;
        // Seven slots; inclusive maximum maps to seventh, monotonic throughout.
        return uint8_t(1+((ticks-pole)*6+(limit-pole)-1)/(limit-pole));
    }
    void tick(uint32_t advance=0) {
        ++phaseTicks;
        if(extensionNotice)--extensionNotice;
        if(phase==Phase::QualifyReady || phase==Phase::RaceReady) {
            if(phaseTicks==3*Hz)enter(phase==Phase::QualifyReady?Phase::Qualify:Phase::Race);
            return;
        }
        if(phase==Phase::Qualified) {
            if(phaseTicks==4*Hz)raceReady();
            return;
        }
        if(result(phase)) { if(phaseTicks==12*Hz)enter(Phase::Attract);return; }
        if(!driving(phase))return;
        ++elapsed;
        if(remaining)--remaining;
        progress+=advance;
        distanceRemainder+=advance;
        addScore(distanceRemainder/1600);distanceRemainder%=1600;
        // Crossing is evaluated before timeout, so exactly-on-deadline succeeds.
        if(progress>=uint32_t(laps+1)*lapLength) {
            ++laps;lapTime=elapsed-lapBegin;lapBegin=elapsed;
            if(!bestLap || lapTime<bestLap)bestLap=lapTime;
            addScore(1000);
            if(phase==Phase::Qualify) {
                qualifyingTime=elapsed;grid=qualifyingGrid(elapsed);rank=grid;
                addScore(uint32_t(8-grid)*500);enter(Phase::Qualified);return;
            }
            if(laps==settings.laps) {
                addScore(remaining/Hz*100);enter(Phase::Finished);return;
            }
            remaining+=uint32_t(settings.extensionSeconds)*Hz;
            extensionNotice=2*Hz;
        }
        if(!remaining)enter(phase==Phase::Qualify?Phase::NotQualified:Phase::TimeUp);
    }
};
}
