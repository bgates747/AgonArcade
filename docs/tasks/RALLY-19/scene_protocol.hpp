#pragma once
// Executable R19-03 wire-layout contract; not integrated into the game yet.
// Explicit byte encoding avoids host/eZ80 struct padding and 24-bit int issues.
#include <stdint.h>
#include <stddef.h>
namespace rally { namespace r19 {
constexpr unsigned StateBytes=80,PacketBytes=97;
constexpr uint16_t Version=1,StagingBuffer=1000,SubmitProgram=2000;
constexpr uint16_t Seal=0x5a19,LastSequence=65534;
struct CarState { int32_t position=0;int16_t lane=0; };
struct State {
    uint16_t sequence=0,track=0;
    int32_t position=0,lateral=0;
    uint16_t phase=0,speed=0,surface=0,flags=0,grip=60;
    int16_t steering=0;
    CarState cars[6];
};
inline uint16_t word(const uint8_t *p){return uint16_t(p[0])|uint16_t(uint16_t(p[1])<<8);}
inline uint32_t dword(const uint8_t *p){return uint32_t(word(p))|(uint32_t(word(p+2))<<16);}
inline int32_t signed32(uint32_t value){return value<=UINT32_C(0x7fffffff)?int32_t(value):-1-int32_t(~value);}
inline int16_t signed16(uint16_t value){return value<=32767?int16_t(value):int16_t(-1-int32_t(uint16_t(~value)));}
inline void put16(uint8_t*p,uint16_t n){p[0]=uint8_t(n);p[1]=uint8_t(n>>8);}
inline void put32(uint8_t*p,uint32_t n){put16(p,uint16_t(n));put16(p+2,uint16_t(n>>16));}
inline bool valid(const State &s){
    const int32_t lap=s.track==0?576000:3276800;
    if(s.track>1 || s.sequence>LastSequence || s.position<0 || s.position>=lap ||
       s.phase>7999 || s.steering< -21 || s.steering>21 || s.lateral< -38400 ||
       s.lateral>38400 || s.speed>300 || s.surface>2 || s.flags>7 || s.grip<25 || s.grip>200)return false;
    for(const auto &c:s.cars)if(c.position<0 || c.position>=lap || c.lane< -90 || c.lane>90)return false;
    return true;
}
inline bool encode(const State &s,uint8_t *out,size_t size){
    if(size!=StateBytes || !valid(s))return false;
    for(unsigned i=0;i<StateBytes;++i)out[i]=0;
    put16(out,Version);put16(out+2,StateBytes);put16(out+4,s.sequence);put16(out+6,s.track);
    put32(out+8,uint32_t(s.position));put16(out+12,s.phase);put16(out+14,uint16_t(s.steering));
    put32(out+16,uint32_t(s.lateral));put16(out+20,s.speed);put16(out+22,s.surface);
    for(unsigned i=0;i<6;++i){put32(out+24+i*8,uint32_t(s.cars[i].position));put16(out+28+i*8,uint16_t(s.cars[i].lane));}
    put16(out+72,s.flags);put16(out+74,s.grip);put16(out+76,s.sequence);put16(out+78,Seal);
    return true;
}
inline bool decode(const uint8_t *in,size_t size,State &out){
    if(size!=StateBytes || word(in)!=Version || word(in+2)!=StateBytes ||
       word(in+4)!=word(in+76) || word(in+78)!=Seal)return false;
    State s;s.sequence=word(in+4);s.track=word(in+6);s.position=signed32(dword(in+8));
    s.phase=word(in+12);s.steering=signed16(word(in+14));s.lateral=signed32(dword(in+16));
    s.speed=word(in+20);s.surface=word(in+22);s.flags=word(in+72);s.grip=word(in+74);
    for(unsigned i=0;i<6;++i){
        if(word(in+30+i*8)!=0)return false;
        s.cars[i].position=signed32(dword(in+24+i*8));s.cars[i].lane=signed16(word(in+28+i*8));
    }
    if(!valid(s))return false;
    out=s;return true;
}
inline uint16_t nextSequence(uint16_t sequence){return sequence==LastSequence?0:uint16_t(sequence+1);}
// Caller emits this entire successful result in order, with no interleaved HUD.
inline bool packet(const State &s,uint8_t *out,size_t size){
    if(size!=PacketBytes || !valid(s))return false;
    const uint8_t header[]={23,0,160,232,3,5,194,0,0,80,0};
    for(unsigned i=0;i<sizeof(header);++i)out[i]=header[i];
    if(!encode(s,out+sizeof(header),StateBytes))return false;
    const uint8_t call[]={23,0,160,208,7,1};
    for(unsigned i=0;i<sizeof(call);++i)out[91+i]=call[i];
    return true;
}
}}
