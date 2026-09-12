#include "scene_protocol.hpp"
#include <cassert>
#include <cstring>
#include <cstdio>
#include <initializer_list>
using namespace rally::r19;
int main(){
    uint8_t bytes[StateBytes],again[StateBytes],wire[PacketBytes];State s,copy;
    s.track=1;s.sequence=65534;s.position=3276799;s.phase=7999;s.lateral=-38400;s.steering=-21;
    s.speed=300;s.grip=200;s.surface=2;s.flags=7;
    for(unsigned i=0;i<6;++i)s.cars[i]={int32_t(i*65536+65535),int16_t(i%2?90:-90)};
    assert(encode(s,bytes,sizeof(bytes)) && decode(bytes,sizeof(bytes),copy));
    assert(copy.lateral==-38400 && copy.steering==-21 && copy.position==3276799);
    assert(encode(copy,again,sizeof(again)) && memcmp(bytes,again,sizeof(bytes))==0);
    assert(bytes[14]==235 && bytes[15]==255 && bytes[16]==0 && bytes[17]==106 && bytes[18]==255 && bytes[19]==255);
    assert(nextSequence(65534)==0 && nextSequence(0)==1);
    assert(packet(s,wire,sizeof(wire)) && memcmp(wire+11,bytes,80)==0);
    assert(word(wire+3)==StagingBuffer && wire[5]==5 && wire[6]==0xc2 && word(wire+9)==80);
    assert(word(wire+94)==SubmitProgram && wire[96]==1);
    // Every short packet rejects without mutating the previously accepted state.
    for(unsigned size=0;size<StateBytes;++size){copy.sequence=123;assert(!decode(bytes,size,copy) && copy.sequence==123);}
    uint8_t large[StateBytes+1];memcpy(large,bytes,StateBytes);large[StateBytes]=0;
    assert(!decode(large,sizeof(large),copy));
    for(unsigned offset:{0u,2u,6u,30u,38u,46u,54u,62u,70u,76u,78u}){
        memcpy(again,bytes,sizeof(bytes));again[offset]^=0x80;copy.sequence=123;
        assert(!decode(again,sizeof(again),copy) && copy.sequence==123);
    }
    const auto bad=[&](State invalid){memset(wire,0x55,sizeof(wire));assert(!packet(invalid,wire,sizeof(wire)));for(auto byte:wire)assert(byte==0x55);};
    State invalid=s;invalid.sequence=65535;bad(invalid);
    invalid=s;invalid.position=-1;bad(invalid);invalid=s;invalid.position=3276800;bad(invalid);
    invalid=s;invalid.track=0;bad(invalid);invalid=s;invalid.phase=8000;bad(invalid);
    invalid=s;invalid.lateral=38401;bad(invalid);invalid=s;invalid.steering=22;bad(invalid);
    invalid=s;invalid.speed=301;bad(invalid);invalid=s;invalid.grip=24;bad(invalid);
    invalid=s;invalid.surface=3;bad(invalid);invalid=s;invalid.flags=8;bad(invalid);
    for(unsigned i=0;i<6;++i){invalid=s;invalid.cars[i].lane=-91;bad(invalid);invalid=s;invalid.cars[i].position=3276800;bad(invalid);}
    assert(signed16(0x8000)==-32768 && signed16(0xffff)==-1 && signed32(0x80000000)==INT32_MIN && signed32(0xffffffff)==-1);
    puts("R19-03: 80-byte explicit LE state / 97-byte packet, signed bounds, round trip, malformed lengths/fields, non-mutating rejection, sequence wrap pass.");
}
