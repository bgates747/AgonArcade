#pragma once
#include <stdint.h>
#include <string.h>
namespace rally::game {
struct Record {uint32_t score=0,lap=0;};
struct Records {
    static constexpr unsigned Count=288,Bytes=16+Count*8;
    Record entries[Count]{};
    static unsigned key(bool fuji,bool arcade,unsigned step,int maximumGrip) {
        return (((unsigned(fuji)*2+unsigned(arcade))*2+step-1)*36)+unsigned((maximumGrip-25)/5);
    }
    static void put32(uint8_t *p,uint32_t v) {
        for(unsigned i=0;i<4;++i) {p[i]=uint8_t(v);v>>=8;}
    }
    static uint32_t get32(const uint8_t *p) {
        uint32_t v=0;for(unsigned i=0;i<4;++i)v|=uint32_t(p[i])<<(i*8);return v;
    }
    static uint32_t hash(const uint8_t *p,unsigned bytes) {
        uint32_t h=2166136261UL;for(unsigned i=0;i<bytes;++i)h=(h^p[i])*16777619UL;return h;
    }
    bool update(unsigned index,uint32_t score,uint32_t lap) {
        if(index>=Count || score>9999999 || lap>30*60*120UL)return false;
        auto &r=entries[index];bool changed=false;
        if(score>r.score) {r.score=score;changed=true;}
        if(lap && (!r.lap || lap<r.lap)) {r.lap=lap;changed=true;}
        return changed;
    }
    void encode(uint8_t *out) const {
        memcpy(out,"ARALLY01",8);put32(out+8,Count);
        for(unsigned i=0;i<Count;++i) {put32(out+16+i*8,entries[i].score);put32(out+20+i*8,entries[i].lap);}
        put32(out+12,hash(out+16,Bytes-16));
    }
    bool decode(const uint8_t *in,unsigned bytes) {
        if(bytes!=Bytes || memcmp(in,"ARALLY01",8) || get32(in+8)!=Count ||
           get32(in+12)!=hash(in+16,Bytes-16))return false;
        for(unsigned i=0;i<Count;++i)if(get32(in+16+i*8)>9999999 || get32(in+20+i*8)>30*60*120UL)return false;
        for(unsigned i=0;i<Count;++i)entries[i]={get32(in+16+i*8),get32(in+20+i*8)};
        return true;
    }
};
}
