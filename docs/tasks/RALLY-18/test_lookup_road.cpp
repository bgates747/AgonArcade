#include "lookup_road.hpp"
#include <algorithm>
#include <array>
#include <cassert>
#include <cmath>
#include <cstdio>
#include <fstream>
#include <set>
#include <string>
#include <vector>
using namespace rally;

namespace {
struct Interval { uint8_t top,bottom; };
struct Coverage {
    uint64_t positions=0,rowQueries=0,sectionRows=0,combinations=0;
    double pointError=0,edgeError=0;
    int32_t pointPosition=0,edgePosition=0;
    int pointRow=0,edgeRow=0,edgeTop=0,edgeBottom=0;
    unsigned maxSections=0,maxBytes=0;
    int minCentre=999999,maxCentre=-999999;
};

std::vector<int> phaseClasses() {
    std::vector<int> result;
    for(int p=0;p<8000;++p) {
        const int half=p%4000;
        if(!half || section_phase::PhaseIndex[half]!=section_phase::PhaseIndex[half-1])
            result.push_back(p);
    }
    assert(result.size()==202);
    return result;
}

std::vector<std::vector<Interval>> allSections(LookupRoad &lookup,Coverage &stats) {
    const TrackDef &track=*lookup.track;
    SectionRoad road;road.track=&track;
    Road material;material.init();
    const auto phases=phaseClasses();
    std::vector<std::vector<Interval>> result(track.length/BandBinWorld);
    Stream stream;
    for(unsigned bin=0;bin<result.size();++bin) {
        std::set<std::pair<unsigned,unsigned>> unique;
        for(int phase:phases) {
            road.project(bin*BandBinWorld*100,phase,0);
            lookup.project(bin*BandBinWorld*100,phase,0);
            assert(lookup.boundaryCount==road.boundaryCount && lookup.bands==road.bands);
            for(unsigned i=0;i<road.boundaryCount;++i)assert(lookup.rows[i]==road.rows[i]);
            for(unsigned i=0;i<road.bands;++i)assert(lookup.materials[i]==road.materials[i]);
            lookup.emit(stream,false);
            assert(!stream.overflow);
            assert(stream.size==30+25*road.bands);
            stats.maxSections=std::max(stats.maxSections,road.bands);
            stats.maxBytes=std::max(stats.maxBytes,stream.size);
            ++stats.combinations;
            for(unsigned i=0;i<road.bands;++i) {
                assert(road.rows[i]<road.rows[i+1]);
                unique.insert({road.rows[i],road.rows[i+1]});
                for(int y=road.rows[i];y<road.rows[i+1];++y)
                    assert(road.materials[i]==(y>=116 && material.painted(y,phase)));
            }
        }
        for(const auto &pair:unique) result[bin].push_back({uint8_t(pair.first),uint8_t(pair.second)});
    }
    return result;
}

void verifyFailures(const std::string &data,const std::string &scratch) {
    LookupRoad road;road.track=&Fuji;
    assert(!road.load((data+"/absent.road").c_str()));
    assert(!road.load((data+"/oval.road").c_str()));
    std::ifstream input(data+"/fuji.road",std::ios::binary);
    std::vector<char> original((std::istreambuf_iterator<char>(input)),{});
    assert(original.size()==116800);
    for(unsigned mode=0;mode<5;++mode) {
        auto bytes=original;
        if(mode==0)bytes[8]=99; // Unsupported version.
        if(mode==1)bytes[bytes.size()/2]^=1; // Payload checksum mismatch.
        if(mode==2)bytes.pop_back(); // Truncation.
        if(mode==3)bytes.push_back(0); // Trailing garbage.
        if(mode==4)bytes[32]^=1; // Wrong allocation size.
        const std::string path=scratch+"/lookup-invalid.road";
        std::ofstream out(path,std::ios::binary);out.write(bytes.data(),bytes.size());out.close();
        assert(!road.load(path.c_str()));assert(!road.loaded());
        road.project(0,0);assert(road.bands==0);
        std::remove(path.c_str());
    }
    assert(road.load((data+"/fuji.road").c_str()));
    road.track=&TriOval;assert(!road.loaded());
    assert(road.load((data+"/oval.road").c_str()));
    assert(road.payloadBytes()==20520);
}

// Independent reference uses the exact existing integer sampling/rounding.
// It includes y=103 directly, avoiding the old Road array's uninitialized row.
void exactCentres(const TrackDef &track,int32_t position,std::array<int32_t,122> &out) {
    const int32_t p=(position/100)*256+(position%100)*256/100;
    const Sample a=trackSample(p,track);
    for(int y=103;y<=224;++y) {
        const int q=y-Horizon;
        const Sample b=trackSample(p+2048000L/q,track);
        const int64_t lateral=(-int64_t(b.x-a.x)*a.ty+int64_t(b.y-a.y)*a.tx)/4096;
        out[y-103]=int32_t(160*256+lateral*q/CameraHeight);
    }
}

void verifyPosition(LookupRoad &road,int32_t p,const std::vector<Interval> &intervals,Coverage &stats) {
    const int phase=int((p*13+397)%8000);
    road.project(p,phase,0);
    std::array<int32_t,122> exact;
    std::array<int,122> drawn;
    exactCentres(*road.track,p,exact);
    for(int y=103;y<=224;++y) {
        const int32_t value=road.centerQ8At(y);
        const double error=std::abs(value-exact[y-103])/256.;
        if(error>stats.pointError) {stats.pointError=error;stats.pointPosition=p;stats.pointRow=y;}
        assert(error<0.25);
        drawn[y-103]=sectionCentrePixel(value);
        stats.minCentre=std::min(stats.minCentre,drawn[y-103]);
        stats.maxCentre=std::max(stats.maxCentre,drawn[y-103]);
        ++stats.rowQueries;
    }
    // Every distinct segment produced by all 202 material phase classes is
    // checked at this position. Thus phase is independent of lap progress;
    // this is stronger than testing one phase per position.
    for(const auto &interval:intervals) {
        const int top=interval.top,bottom=interval.bottom,height=bottom-top;
        const int a=drawn[top-103],b=drawn[bottom-103];
        for(int y=top;y<bottom;++y) {
            const int64_t numerator=int64_t(a*256-exact[y-103])*height+
                int64_t((b-a)*256)*(y-top);
            const double error=double(std::abs(numerator))/(256*height);
            if(error>stats.edgeError) {
                stats.edgeError=error;stats.edgePosition=p;stats.edgeRow=y;
                stats.edgeTop=top;stats.edgeBottom=bottom;
            }
            if(std::abs(numerator)>int64_t(256)*height) {
                std::fprintf(stderr,"edge tolerance failed %s p=%d y=%d interval=%d..%d %.9f px\n",
                             road.track->name,p,y,top,bottom,error);std::abort();
            }
            ++stats.sectionRows;
        }
    }
    ++stats.positions;
}

void sanity(LookupRoad &road) {
    SectionRoad live;live.track=road.track;
    Stream a,b;
    for(int32_t p:{0,1,6399,6400,6401,int32_t(road.track->length*100-1)}) {
        road.project(p,7911,0);live.project(p,7911,0);
        assert(road.bands==live.bands);
        assert(road.boundaryCount==live.boundaryCount);
        for(unsigned i=0;i<road.boundaryCount;++i)assert(road.rows[i]==live.rows[i]);
        for(unsigned i=0;i<road.bands;++i)assert(road.materials[i]==live.materials[i]);
        road.emit(a,false);assert(a.size==30+25*road.bands);
        road.project(p,7911,150*256);road.emit(b,false);
        assert(a.size==b.size && std::memcmp(a.data,b.data,a.size)==0);
        road.project(p,7911,-150*256);road.emit(b,false);
        assert(a.size==b.size && std::memcmp(a.data,b.data,a.size)==0);
    }
    road.project(0,0);road.emit(a,false);
    road.project(road.track->length*100,8000);road.emit(b,false);
    assert(a.size==b.size && std::memcmp(a.data,b.data,a.size)==0);
    road.project(-1,-1);road.emit(a,false);
    road.project(road.track->length*100-1,7999);road.emit(b,false);
    assert(a.size==b.size && std::memcmp(a.data,b.data,a.size)==0);
}
}

int main(int argc,char **argv) {
    if(argc<3 || argc>4) {std::fprintf(stderr,"usage: test_lookup_road DATA_DIRECTORY SCRATCH_DIRECTORY [POSITION_STEP_HUNDREDTHS]\n");return 2;}
    const int step=argc==4?std::atoi(argv[3]):1;
    if(step<1)return 2;
    verifyFailures(argv[1],argv[2]);
    for(const TrackDef *track:{&TriOval,&Fuji}) {
        LookupRoad road;road.track=track;
        const std::string name=track==&Fuji?"fuji":"oval";
        assert(road.load((std::string(argv[1])+"/"+name+".road").c_str()));
        sanity(road);
        Coverage stats;
        const auto intervals=allSections(road,stats);
        for(int32_t p=0;p<track->length*100;p+=step) {
            verifyPosition(road,p,intervals[p/(BandBinWorld*100)],stats);
            if(p && p%640000==0) {std::printf("%s: verified %d hundredths\n",name.c_str(),p);std::fflush(stdout);}
        }
        // Explicit both sides of every 64-unit stored-track seam and lap seam,
        // even when a quick sampled run uses a step that misses them.
        for(int32_t p=6400;p<track->length*100;p+=6400)
            for(int delta:{-1,0,1})verifyPosition(road,p+delta,intervals[(p+delta)/(BandBinWorld*100)],stats);
        verifyPosition(road,track->length*100-1,intervals.back(),stats);
        std::printf("%s result: positions=%llu row_queries=%llu all_phase_section_rows=%llu combinations=%llu "
                    "point_error=%.9f at=%d/%d edge_error=%.9f at=%d/%d/%d..%d "
                    "max_sections=%u max_road_bytes=%u centre_range=%d..%d payload=%u\n",
                    name.c_str(),(unsigned long long)stats.positions,(unsigned long long)stats.rowQueries,
                    (unsigned long long)stats.sectionRows,(unsigned long long)stats.combinations,
                    stats.pointError,stats.pointPosition,stats.pointRow,stats.edgeError,stats.edgePosition,
                    stats.edgeRow,stats.edgeTop,stats.edgeBottom,stats.maxSections,stats.maxBytes,
                    stats.minCentre,stats.maxCentre,road.payloadBytes());std::fflush(stdout);
    }
    std::printf("Lookup validation passed; position step=%d hundredths; native sizeof(LookupRoad)=%zu.\n",step,sizeof(LookupRoad));
}
