#include "section_road.hpp"
#include <algorithm>
#include <cassert>
#include <cmath>
#include <cstdio>
#include <cstring>
#include <vector>
using namespace rally;

namespace {
double maximumError=0;
unsigned heldOutViews=0;

int signedWord(const uint8_t *p) {
    unsigned value=p[0]+256u*p[1];
    return value>=32768 ? int(value)-65536 : int(value);
}

void verifyStream(const SectionRoad &road,const Stream &stream,bool sky=false) {
    assert(!stream.overflow);
    assert(stream.size==(sky?45u:30u)+25*road.bands);
    unsigned start=sky?30:15;
    for(unsigned i=0;i<road.bands;++i) {
        const uint8_t *p=stream.data+start+25*i;
        assert(p[0]==23 && p[1]==0 && p[2]==160 && p[5]==5);
        assert(p[6]==194 && signedWord(p+7)==0 && signedWord(p+9)==8);
        assert(signedWord(p+11)==road.centersQ8[i]/256);
        assert(signedWord(p+13)==road.centersQ8[i+1]/256);
        assert(signedWord(p+15)==road.rows[i]);
        assert(signedWord(p+17)==road.rows[i+1]);
        assert(p[19]==23 && p[20]==0 && p[21]==160 && p[24]==1);
        assert(signedWord(p+22)==(road.materials[i]?30008:30009));
        if(i) {
            const uint8_t *previous=p-25;
            assert(signedWord(previous+13)==signedWord(p+11));
            assert(signedWord(previous+17)==signedWord(p+15));
        }
    }
}

void verifyGeometry(const SectionRoad &road,const Road &reference) {
    assert(road.bands>=1 && road.bands<=SectionRoad::MaxSections);
    assert(road.boundaryCount==road.bands+1);
    assert(road.rows[0]==RoadTop && road.rows[road.bands]==Bottom+1);
    for(unsigned i=0;i<road.bands;++i) {
        int top=road.rows[i],bottom=road.rows[i+1];
        assert(top>=RoadTop && bottom>top && bottom<=Bottom+1);
        assert(road.centersQ8[i]==reference.centers[top]);
        assert(road.centersQ8[i+1]==reference.centers[bottom]);
        assert(road.centerAt(top)==reference.centers[top]/256);
        for(int y=top;y<bottom;++y) {
            assert(road.materials[i]==reference.paint[y]);
            int64_t error=int64_t(road.centersQ8[i]-reference.centers[y])*(bottom-top)
                +int64_t(road.centersQ8[i+1]-road.centersQ8[i])*(y-top);
            maximumError=std::max(maximumError,double(std::abs(error))/(256*(bottom-top)));
            assert(std::abs(error)<=int64_t(256)*(bottom-top));
            // Continuous cross-section edges share the same centre error.
            // Clipping those edges to the viewport must not enlarge it.
            double exact=reference.centers[y]/256.;
            double line=exact+double(error)/(256*(bottom-top));
            for(int width:{-KerbOuterWidth,-RoadHalfWidth,RoadHalfWidth,KerbOuterWidth}) {
                double half=double((y-Horizon)*width)/CameraHeight;
                double a=std::clamp(exact+half,0.,320.);
                double b=std::clamp(line+half,0.,320.);
                assert(std::abs(a-b)<=1.00000001);
            }
        }
    }
}

// Independent wider intermediate arithmetic checks the explicit traffic row
// outside Road::project's array domain. No row 103 reference array is read.
int referenceTrafficCentre(const TrackDef &track,int32_t position,int32_t offset,int y) {
    int32_t p=(position/100)*256+(position%100)*256/100;
    Sample a=trackSample(p,track);
    Sample b=trackSample(p+int32_t(2048000L/(y-Horizon)),track);
    int64_t lateral=(-int64_t(b.x-a.x)*a.ty+int64_t(b.y-a.y)*a.tx)/4096;
    return int((160*256+(lateral-offset)*(y-Horizon)/CameraHeight)/256);
}
}

int main() {
    SectionRoad road;road.init();
    Road reference;reference.init();reference.fixedBands=true;
    Stream stream;

    // Exhaust every legal hundredth-unit phase against the old material rule.
    // The two 40-unit halves must share endpoints and exchange colours.
    std::vector<int> phases;
    for(int phase=0;phase<8000;++phase) {
        unsigned local=unsigned(phase%4000);
        unsigned id=section_phase::PhaseIndex[local];
        assert(id<section_phase::PatternCount);
        const uint8_t *rows=section_phase::Rows+section_phase::Offsets[id];
        assert(*rows++==116);
        bool material=phase<4000;
        for(int y=116;y<=Bottom;++y) {
            if(y==*rows) {++rows;material=!material;}
            assert(material==reference.painted(y,phase));
        }
        assert(*rows==Bottom+1);
        if(phase==0 || phase==4000 || section_phase::PhaseIndex[local]!=section_phase::PhaseIndex[local-1])
            phases.push_back(phase);
    }
    assert(phases.size()==202);

    // Every table x every distinct phase class: exhaustive section capacity
    // and colour classification for the finite lookup combinations.
    unsigned allMaximum=0,allBytes=0;
    for(const TrackDef *track:{&TriOval,&Fuji}) {
        road.track=reference.track=track;
        unsigned samples=0,maximum=0,minimum=999;
        uint64_t total=0;
        for(int32_t p=0;p<track->length*100;p+=BandBinWorld*100) {
            reference.project(p,0);
            for(int phase:phases) {
                road.project(p,phase);
                road.emit(stream,false);
                verifyStream(road,stream);
                for(unsigned i=0;i<road.bands;++i)
                    for(int y=road.rows[i];y<road.rows[i+1];++y)
                        assert(road.materials[i]==(y>=116 && reference.painted(y,phase)));
                maximum=std::max(maximum,road.bands);
                minimum=std::min(minimum,road.bands);
                total+=road.bands;++samples;
                allBytes=std::max(allBytes,stream.size);
            }
        }
        allMaximum=std::max(allMaximum,maximum);
        std::printf("%s: all %u table/material combinations, sections min %u max %u unweighted mean %.4f.\n",
                    track->name,samples,minimum,maximum,double(total)/samples);

        // Held-out positions (1.37 world units), both sides of each table seam,
        // both lap endpoints, and all driving camera limits. Independent phase
        // deliberately differs from position modulo 80 units.
        std::vector<int32_t> positions;
        for(int32_t p=0;p<track->length*100;p+=137) positions.push_back(p);
        for(int32_t p=BandBinWorld*100;p<track->length*100;p+=BandBinWorld*100) {
            positions.push_back(p-1);positions.push_back(p);positions.push_back(p+1);
        }
        positions.push_back(track->length*100-1);
        for(int32_t p:positions) for(int offset:{-100*256,0,100*256}) {
            int phase=int((p*13+397)%8000);
            reference.project(p,phase,offset);
            road.project(p,phase,offset);
            verifyGeometry(road,reference);++heldOutViews;
            assert(road.centerAt(103)==referenceTrafficCentre(*track,p,offset,103));
            for(int y:{104,109,116,150,223,224}) assert(road.centerAt(y)==reference.centers[y]/256);
        }

        // Independent phase changes must not change exact cross-section math.
        // Cover all 64 fixture poses with 16 phases, rather than just one
        // position/phase correlation or the generator's quarter-unit samples.
        uint64_t fixtureTotal=0;unsigned fixtureMaximum=0;
        for(unsigned pose=0;pose<64;++pose) {
            int32_t p=int32_t(int64_t(pose)*track->length*100/64);
            for(int phase=0;phase<8000;phase+=500) {
                road.project(p,phase);
                reference.project(p,phase);
                verifyGeometry(road,reference);
            }
            road.project(p,p%8000);
            fixtureTotal+=road.bands;fixtureMaximum=std::max(fixtureMaximum,road.bands);
        }
        std::printf("%s: deterministic fixture %llu sections / 64 frames, max %u, %.4f mean, %llu road UART bytes.\n",
                    track->name,(unsigned long long)fixtureTotal,fixtureMaximum,double(fixtureTotal)/64,
                    (unsigned long long)(64*30+25*fixtureTotal));

        // Explicit wrap and negative inputs are normalized once, not per row.
        road.project(track->length*100,8000);
        reference.project(0,0);
        verifyGeometry(road,reference);
        road.project(-1,-1);
        reference.project(track->length*100-1,7999);
        verifyGeometry(road,reference);
    }

    // Signed off-screen endpoints must reach the VDP unchanged for clipping.
    road.track=&Fuji;
    road.render(stream,0,0,1000*256,false);
    verifyStream(road,stream);
    bool negative=false;
    for(unsigned i=0;i<road.boundaryCount;++i) negative|=road.centersQ8[i]<0;
    assert(negative);
    Stream withSky;
    road.emit(withSky,true);verifyStream(road,withSky,true);
    assert(std::memcmp(withSky.data+15,stream.data,stream.size)==0);

    // Capacity also holds for the structural worst case: one section per row.
    static_assert(45+25*SectionRoad::MaxSections<=sizeof(Stream::data));
    std::printf("Sections: %u held-out views, %.6f px maximum sampled geometry error; "
                "all phases/tables max %u sections, %u bytes. Tables: %u material + %zu depth = %u new bytes.\n",
                heldOutViews,maximumError,allMaximum,allBytes,section_phase::MaterialBytes,
                sizeof(section_phase::DepthQ8),section_phase::TableBytes);
}
