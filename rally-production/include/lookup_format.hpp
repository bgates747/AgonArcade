#pragma once
#include <stdint.h>
#include "road.hpp"

namespace rally { namespace lookup_format {
constexpr unsigned Version=1, HeaderSize=64, Lookahead=19, RecordSize=12;
constexpr unsigned FirstRow=103, LastRow=224, IntervalWorld=64;
constexpr uint32_t MaximumPayload=512UL*Lookahead*RecordSize;
// Screen centre = a/64 + (b/256)*t + q*(c+d*t+e*t*t)/4096.
// t is progress through one 64-world-unit interval, q is row-horizon.
// These are projected screen-line coefficients, computed offline. No map
// coordinates or camera directions are present in the loaded representation.
struct Coefficients { int16_t a,b; int32_t c; int16_t d,e; };
static_assert(sizeof(Coefficients)==RecordSize,"unexpected lookup record padding");
inline uint32_t read32(const uint8_t *p) {
    return uint32_t(p[0])|(uint32_t(p[1])<<8)|(uint32_t(p[2])<<16)|(uint32_t(p[3])<<24);
}
inline uint16_t read16(const uint8_t *p) { return uint16_t(p[0])|(uint16_t(p[1])<<8); }
inline uint32_t hashByte(uint32_t h,uint8_t b) { return (h^b)*UINT32_C(16777619); }
inline uint32_t trackIdentity(const TrackDef &track) {
    uint32_t h=UINT32_C(2166136261);
    for(unsigned i=0;i<track.count;++i) {
        const TrackPoint &p=track.points[i];
        const int16_t fields[4]={p.x,p.y,p.tx,p.ty};
        for(unsigned j=0;j<4;++j) {
            h=hashByte(h,uint8_t(fields[j]));
            h=hashByte(h,uint8_t(uint16_t(fields[j])>>8));
        }
    }
    return h;
}
}}
