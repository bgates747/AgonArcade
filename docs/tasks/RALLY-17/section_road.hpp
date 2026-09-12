#pragma once
#include "road.hpp"
#include "section_phase.hpp"
#include "section_protocol.hpp"

namespace rally {
// RALLY-15 experiment. Original Road remains the independent host reference.
// All live projection is at section boundaries or explicit traffic requests.
struct SectionRoad {
    static constexpr unsigned MaxSections=Bottom-RoadTop+1;
    const TrackDef *track=&Fuji;
    bool fixedBands=true; // Kept for existing fixture metadata/argument handling.
    unsigned bands=0, boundaryCount=0;
    uint8_t rows[MaxSections+1];
    int32_t centersQ8[MaxSections+1];
    bool materials[MaxSections];

    void init() { bands=boundaryCount=0; }

    // Exact original integer projection at a requested cross-section. Traffic
    // can request row 103, which is above the road's first rendered row.
    int32_t centerQ8At(int y) const {
        int q=y-Horizon;
        if(q<=0) return 160L*256;
        int32_t depth=q<=Bottom+1-Horizon ? section_phase::DepthQ8[q]
                                          : 2048000L/q;
        Sample ahead=trackSample(positionQ8+depth,*track);
        int32_t dx=ahead.x-camera.x, dy=ahead.y-camera.y;
        int32_t lateral=(-dx*camera.ty+dy*camera.tx)/4096;
        return 160L*256+(lateral-offsetQ8)*q/CameraHeight;
    }
    int centerAt(int y) const { return int(centerQ8At(y)/256); }

    void project(int32_t position,int32_t phase,int32_t cameraOffset=0) {
        // The game supplies normalized positions/phases; these guards also
        // make an explicit lap endpoint and a repeated phase safe to inspect.
        const int32_t lap=track->length*100;
        if(position<0 || position>=lap) {
            position%=lap;
            if(position<0) position+=lap;
        }
        if(phase<0 || phase>=Period*100) {
            phase%=Period*100;
            if(phase<0) phase+=Period*100;
        }
        const bool firstMaterial=phase<int32_t(section_phase::HalfPeriod);
        unsigned phaseInHalf=unsigned(firstMaterial ? phase : phase-section_phase::HalfPeriod);
        const uint8_t *stripe=section_phase::Rows+section_phase::Offsets[
            section_phase::PhaseIndex[phaseInHalf]];
        unsigned bin=unsigned(position/(BandBinWorld*100L));
        if(track==&Fuji) bin+=BandFujiOffset;
        const uint8_t *curve=BandEnds+BandOffsets[bin];

        positionQ8=(position/100)*256+(position%100)*256/100;
        camera=trackSample(positionQ8,*track);
        offsetQ8=cameraOffset;
        rows[0]=RoadTop;
        centersQ8[0]=centerQ8At(RoadTop);
        boundaryCount=1;
        bool material=false;
        int y=RoadTop;
        while(y<=Bottom) {
            // Curve table entries are inclusive row ends. Material entries are
            // shared endpoints, beginning with 116 and terminating with 224.
            int curveY=int(*curve)+1;
            int stripeY=*stripe;
            y=curveY<stripeY ? curveY : stripeY;
            materials[boundaryCount-1]=material;
            rows[boundaryCount]=uint8_t(y);
            centersQ8[boundaryCount]=centerQ8At(y);
            ++boundaryCount;
            if(y==curveY) ++curve;
            if(y==stripeY) {
                material=y==int(section_phase::MarkedTop) ? firstMaterial : !material;
                ++stripe;
            }
        }
        bands=boundaryCount-1;
    }

    void emit(Stream &s,bool fillSky=true) const {
        s.size=0; s.overflow=false;
        if(fillSky) s.rect(0,0,319,RoadTop-1,4);
        s.rect(0,RoadTop,319,Bottom,2);
        for(unsigned i=0;i<bands;++i)
            section::draw(s,int(centersQ8[i]/256),int(centersQ8[i+1]/256),
                          rows[i],rows[i+1],materials[i]);
        s.rect(0,Bottom+1,319,239,0);
    }

    void render(Stream &s,int32_t phase,int32_t position=0,
                int32_t cameraOffset=0,bool fillSky=true) {
        project(position,phase,cameraOffset);
        emit(s,fillSky);
    }

private:
    int32_t positionQ8=0, offsetQ8=0;
    Sample camera={0,0,4096,0};
};
}
