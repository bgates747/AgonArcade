#pragma once
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "section_road.hpp"
#include "lookup_format.hpp"

namespace rally {
// RALLY-18 only. A selected track is loaded once. Missing/corrupt/mismatched
// data fails closed; there is no live-projection fallback and no frame I/O.
struct LookupRoad {
    static constexpr unsigned MaxSections=SectionRoad::MaxSections;
    const TrackDef *track=&Fuji;
    bool fixedBands=true;
    unsigned bands=0,boundaryCount=0;
    uint8_t rows[MaxSections+1];
    int32_t centersQ8[MaxSections+1];
    bool materials[MaxSections];

    LookupRoad()=default;
    LookupRoad(const LookupRoad&)=delete;
    LookupRoad& operator=(const LookupRoad&)=delete;
    ~LookupRoad() { free(table); }
    void init() { bands=boundaryCount=0; }
    bool loaded() const { return table && loadedTrack==track; }
    const char *error() const { return problem; }
    uint32_t payloadBytes() const { return loaded()?payloadSize:0; }
    uint32_t checksum() const { return loaded()?payloadChecksum:0; }

    bool load(const char *filename) {
        free(table);table=nullptr;loadedTrack=nullptr;payloadSize=0;
        problem="road lookup: open failed";
        FILE *f=fopen(filename,"rb");if(!f) return false;
        uint8_t h[lookup_format::HeaderSize];
        bool ok=fread(h,1,sizeof(h),f)==sizeof(h);
        using namespace lookup_format;
        if(!ok || memcmp(h,"R18ROAD\0",8) || read16(h+8)!=Version ||
           read16(h+10)!=HeaderSize || read32(h+12)!=trackIdentity(*track) ||
           read32(h+16)!=uint32_t(track->length) || read16(h+20)!=track->count ||
           read16(h+22)!=IntervalWorld || read16(h+24)!=Lookahead ||
           read16(h+26)!=RecordSize || h[28]!=FirstRow || h[29]!=LastRow ||
           h[30]!=Horizon || h[31]!=CameraHeight || read32(h+40)!=1 ||
           read32(h+44)!=64 || read32(h+48)!=256 || read32(h+52)!=4096 ||
           read32(h+56)!=0 || read32(h+60)!=0) {
            problem="road lookup: incompatible header";fclose(f);return false;
        }
        const uint32_t bytes=read32(h+32);
        if(bytes!=uint32_t(track->count)*Lookahead*RecordSize || bytes>MaximumPayload) {
            problem="road lookup: invalid size";fclose(f);return false;
        }
        table=static_cast<Coefficients*>(malloc(bytes));
        if(!table) {problem="road lookup: out of memory";fclose(f);return false;}
        ok=fread(table,1,bytes,f)==bytes && fgetc(f)==EOF;
        fclose(f);
        uint32_t hash=UINT32_C(2166136261);
        if(ok) {
            const uint8_t *p=reinterpret_cast<const uint8_t*>(table);
            for(uint32_t i=0;i<bytes;++i) hash=hashByte(hash,p[i]);
            ok=hash==read32(h+36);
        }
        if(!ok) {free(table);table=nullptr;problem="road lookup: size/checksum failed";return false;}
        payloadSize=bytes;payloadChecksum=hash;loadedTrack=track;problem="";
        return true;
    }

    // Cache each preprojected screen line on its first query in a frame. The
    // final row calculation is lineIntercept + rowDistance*lineSlope. Divisions
    // by powers of two deliberately retain C++ truncation toward zero, matching
    // the validated fixed-point evaluator on the eZ80 and host.
    int32_t centerQ8At(int y) const {
        if(!loaded() || y<int(lookup_format::FirstRow) || y>int(lookup_format::LastRow))
            return 160L*256;
        const int q=y-Horizon;
        const unsigned k=unsigned((fractionQ14+section_phase::DepthQ8[q])>>14);
        if(!lineReady[k]) {
            const lookup_format::Coefficients &z=frameTable[k];
            lineA[k]=int32_t(z.a)*4+int32_t(z.b)*fractionQ12/4096;
            lineB[k]=z.c+int32_t(z.d)*fractionQ12/4096+int32_t(z.e)*squareQ12/4096;
            lineReady[k]=true;
        }
        return lineA[k]+lineB[k]*q/16;
    }
    int centerAt(int y) const { return int(centerQ8At(y)/256); }

    void project(int32_t position,int32_t phase,int32_t cameraOffset=0) {
        (void)cameraOffset; // Lateral movement never displaces this camera.
        if(!loaded()) {bands=boundaryCount=0;return;}
        const int32_t lap=track->length*100;
        if(position<0 || position>=lap) {position%=lap;if(position<0)position+=lap;}
        if(phase<0 || phase>=Period*100) {phase%=Period*100;if(phase<0)phase+=Period*100;}
        const unsigned interval=unsigned(position/6400);
        const int32_t local=position%6400;
        fractionQ14=(local/100)*256+(local%100)*256/100;
        fractionQ12=fractionQ14/4;
        squareQ12=fractionQ12*fractionQ12/4096;
        frameTable=table+interval*lookup_format::Lookahead;
        memset(lineReady,0,sizeof(lineReady));

        const bool firstMaterial=phase<int32_t(section_phase::HalfPeriod);
        const unsigned half=unsigned(firstMaterial?phase:phase-section_phase::HalfPeriod);
        const uint8_t *stripe=section_phase::Rows+section_phase::Offsets[section_phase::PhaseIndex[half]];
        unsigned bin=unsigned(position/(BandBinWorld*100L));
        if(track==&Fuji) bin+=BandFujiOffset;
        const uint8_t *curve=BandEnds+BandOffsets[bin];
        rows[0]=RoadTop;centersQ8[0]=centerQ8At(RoadTop);boundaryCount=1;
        bool material=false;int y=RoadTop;
        while(y<=Bottom) {
            const int curveY=int(*curve)+1,stripeY=*stripe;
            y=curveY<stripeY?curveY:stripeY;
            materials[boundaryCount-1]=material;
            rows[boundaryCount]=uint8_t(y);
            centersQ8[boundaryCount]=centerQ8At(y);++boundaryCount;
            if(y==curveY)++curve;
            if(y==stripeY) {material=y==int(section_phase::MarkedTop)?firstMaterial:!material;++stripe;}
        }
        bands=boundaryCount-1;
    }

    void emit(Stream &s,bool fillSky=true) const {
        s.size=0;s.overflow=false;
        if(fillSky)s.rect(0,0,319,RoadTop-1,4);
        s.rect(0,RoadTop,319,Bottom,2);
        for(unsigned i=0;i<bands;++i)
            section::draw(s,sectionCentrePixel(centersQ8[i]),sectionCentrePixel(centersQ8[i+1]),
                          rows[i],rows[i+1],materials[i]);
        s.rect(0,Bottom+1,319,239,0);
    }
    void render(Stream &s,int32_t phase,int32_t position=0,int32_t cameraOffset=0,bool fillSky=true) {
        project(position,phase,cameraOffset);emit(s,fillSky);
    }
private:
    lookup_format::Coefficients *table=nullptr;
    const lookup_format::Coefficients *frameTable=nullptr;
    const TrackDef *loadedTrack=nullptr;
    uint32_t payloadSize=0,payloadChecksum=0;
    const char *problem="road lookup: not loaded";
    int32_t fractionQ14=0,fractionQ12=0,squareQ12=0;
    mutable int32_t lineA[lookup_format::Lookahead],lineB[lookup_format::Lookahead];
    mutable bool lineReady[lookup_format::Lookahead];
};
}
