// Bounded host checks and operation census. Host elapsed time is not a benchmark.
#include "lookup_direct.hpp"
#include "direct_road.hpp"
#include "game_scene.hpp"
#include "signs.hpp"
#include <algorithm>
#include <cassert>
#include <cstdio>
#include <cstdlib>
#include <set>
#include <string>
#include <vector>
using namespace rally;
using namespace rally::game;

struct ObservedLookup : r28::DirectLookup {
    mutable std::vector<int> queries;
    void project(int32_t position,int32_t phase,int32_t offset=0) {
        LookupRoad::project(position,phase,offset);queries.assign(rows,rows+boundaryCount);
    }
    int centerAt(int y) const {queries.push_back(y);return LookupRoad::centerAt(y);}
};

struct Counts {
    unsigned poses=0,maxBands=0,maxBytes=0,maxChunks=0,maxPointErrorQ8=0,maxPixelDifference=0;
    uint64_t bands=0,roadBytes=0,liveBytes=0,queries=0,lines=0,wideLookupMultiplies=0;
};

// Independently serialize the specified direct geometry without Stream helpers.
template<class R> static std::vector<uint8_t> expected(const R &road,bool sky) {
    std::vector<uint8_t> out;
    auto byte=[&](int n){out.push_back(uint8_t(n));};
    auto word=[&](int n){byte(n);byte(uint16_t(n)>>8);};
    auto color=[&](int n){byte(18);byte(0);byte(n);};
    auto plot=[&](int mode,int x,int y){byte(25);byte(mode);word(x);word(y);};
    auto rect=[&](int y,int yy,int ink){color(ink);plot(4,0,y);plot(101,319,yy);};
    auto nearest=[](int32_t n){return int((n+(n<0?-128:128))/256);};
    if(sky)rect(0,103,4);
    rect(104,223,2);
    const int edges[][2]={{-106,106},{-90,90},{-86,-84},{84,86},{-2,2}};
    for(unsigned i=0;i<road.bands;++i) {
        const int top=nearest(road.centersQ8[i]),bottom=nearest(road.centersQ8[i+1]);
        const int y=road.rows[i],yy=road.rows[i+1];const bool mark=road.materials[i];
        for(unsigned layer=0;layer<(mark?5u:4u);++layer) {
            color(layer==0?(mark?9:15):layer==1?8:(mark?11:15));
            const int left=edges[layer][0],right=edges[layer][1];
            plot(4,top+(y-96)*left/50,y);plot(4,top+(y-96)*right/50,y);
            plot(85,bottom+(yy-96)*left/50,yy);plot(85,bottom+(yy-96)*right/50,yy);
        }
    }
    rect(224,239,0);return out;
}

static void check(ObservedLookup &lookup,DirectRoad &live,int32_t position,int32_t phase,
                  RaceTraffic &routes,Motion &motion,Counts &counts) {
    motion.position=position;motion.phase=phase;
    Traffic traffic;routes.view(traffic,position);
    SceneryHistory history;volatile r18::SceneState scene{};
    prepareGameScene(motion,traffic,routes,lookup,history,scene,false);
    Billboards signs;signs.prepare(motion,lookup);
    // Count only road boundaries plus actual scene/sign queries, before
    // validation requests warm any additional lines in the lookup's cache.
    int32_t local=position%6400;
    const int32_t f=(local/100)*256+(local%100)*256/100;
    std::set<unsigned> used;
    for(int y:lookup.queries) {
        assert(y>=103&&y<=224);
        const unsigned k=unsigned((f+section_phase::DepthQ8[y-96])>>14);
        assert(k<lookup_format::Lookahead);used.insert(k);
    }
    counts.queries+=lookup.queries.size();counts.lines+=used.size();
    counts.wideLookupMultiplies+=3*used.size()+lookup.queries.size();
    live.project(position,phase,0);
    r28::DirectLiveSections sparse;sparse.track=lookup.track;sparse.init();sparse.project(position,phase,0);
    assert(sparse.bands==lookup.bands&&sparse.boundaryCount==lookup.boundaryCount);
    for(unsigned i=0;i<sparse.boundaryCount;++i) {
        assert(sparse.rows[i]==lookup.rows[i]);
        assert(sparse.centersQ8[i]==live.centers[sparse.rows[i]]);
        if(i<sparse.bands)assert(sparse.materials[i]==lookup.materials[i]);
    }
    for(int y=104;y<=224;++y) {
        const unsigned error=unsigned(std::abs(lookup.centerQ8At(y)-live.centers[y]));
        counts.maxPointErrorQ8=std::max(counts.maxPointErrorQ8,error);
        // Bounded feasibility tolerance, not a new exhaustive parity gate.
        assert(error<=256);
    }
    for(int y=103;y<=224;++y) {
        unsigned error=unsigned(std::abs(lookup.LookupRoad::centerAt(y)-live.centerAt(y)));
        counts.maxPixelDifference=std::max(counts.maxPixelDifference,error);assert(error<=1);
    }
    assert(lookup.rows[0]==104&&lookup.rows[lookup.bands]==224);
    for(unsigned i=0;i<lookup.bands;++i) {
        assert(lookup.rows[i]<lookup.rows[i+1]);
        for(int y=lookup.rows[i];y<lookup.rows[i+1];++y)
            assert(lookup.materials[i]==(y>=116&&live.painted(y,phase)));
    }
    Stream stream;std::vector<uint8_t> bytes;unsigned chunks=0;
    auto send=[&](const uint8_t *p,unsigned n){assert(n&&n<=4096);++chunks;bytes.insert(bytes.end(),p,p+n);};
    lookup.emitTo(stream,send);assert(!stream.overflow&&stream.size==0);
    assert(bytes==expected(lookup,false));
    std::vector<uint8_t> sparseBytes;
    sparse.emitTo(stream,[&](const uint8_t *p,unsigned n){assert(n&&n<=4096);sparseBytes.insert(sparseBytes.end(),p,p+n);});
    assert(!stream.overflow&&sparseBytes==expected(sparse,false)&&sparseBytes.size()==bytes.size());
    for(size_t i=0;i<bytes.size();) {
        const unsigned opcode=bytes[i];assert(opcode==18||opcode==25);
        i+=opcode==18?3:6;assert(i<=bytes.size());
    }
    unsigned liveBytes=0;live.emitTo(stream,[&](const uint8_t*,unsigned n){liveBytes+=n;});
    assert(!stream.overflow);
    ++counts.poses;counts.bands+=lookup.bands;counts.roadBytes+=bytes.size();counts.liveBytes+=liveBytes;
    counts.maxBands=std::max(counts.maxBands,lookup.bands);
    counts.maxBytes=std::max(counts.maxBytes,unsigned(bytes.size()));counts.maxChunks=std::max(counts.maxChunks,chunks);
    if(counts.poses==1) {
        bytes.clear();lookup.emitTo(stream,send,true);assert(bytes==expected(lookup,true));
    }
}

static void print(const char *track,const char *workload,const Counts &s) {
    printf("{\"track\":\"%s\",\"workload\":\"%s\",\"poses\":%u,\"bands\":%llu,\"road_bytes\":%llu,"
        "\"live_road_bytes\":%llu,\"centre_queries\":%llu,\"unique_lines\":%llu,\"row_lookup_wide_multiplies\":%llu,"
        "\"max_bands\":%u,\"max_road_bytes\":%u,\"max_chunks\":%u,\"max_point_error_q8\":%u,\"max_pixel_difference\":%u}\n",
        track,workload,s.poses,(unsigned long long)s.bands,(unsigned long long)s.roadBytes,
        (unsigned long long)s.liveBytes,(unsigned long long)s.queries,(unsigned long long)s.lines,
        (unsigned long long)s.wideLookupMultiplies,s.maxBands,s.maxBytes,s.maxChunks,s.maxPointErrorQ8,s.maxPixelDifference);
}

int main(int argc,char **argv) {
    assert(argc==2);const std::string directory=argv[1];
    for(const auto *track:{&Fuji,&TriOval}) {
        const int32_t lap=track->length*100;const char *name=track==&Fuji?"fuji":"oval";
        ObservedLookup lookup;lookup.track=track;lookup.init();
        assert(lookup.load((directory+"/"+name+".road").c_str()));
        DirectRoad live;live.track=track;live.init();Motion motion;motion.track=track;
        RaceTraffic routes;routes.reset(Policy::Circuit,lap,7,2);
        Counts seams;
        for(unsigned sample=0;sample<track->count;++sample)
            for(int delta:{-1,0,1})for(int phase:{0,63,3999,4000,7999})
                check(lookup,live,(int32_t(sample)*6400+delta+lap)%lap,phase,routes,motion,seams);
        print(name,"track_seams_five_phases",seams);
        if(track==&Fuji) {
            Counts demo;motion.position=lap-6800;motion.phase=0;uint32_t progress=0;
            for(unsigned frame=0;frame<900;++frame) {
                for(unsigned tick=0;tick<4;++tick) {
                    const auto &pace=routes.pace;const unsigned index=pace.remaining?pace.record:(pace.record+1)%6;
                    motion.speed=Route[index].speed;const int32_t advance=motion.speed*WorldSpeedMultiplier;
                    motion.position=(motion.position+advance)%lap;motion.phase=(motion.phase+advance)%8000;
                    progress+=advance;routes.tick(progress,frame*4+tick+1);
                    if(progress>=uint32_t(lap)){progress-=lap;for(auto &car:routes.cars){car.progress=car.position;car.finish=0;}}
                }
                check(lookup,live,motion.position,motion.phase,routes,motion,demo);
            }
            assert(motion.position==1202800&&motion.phase==1600);
            print(name,"900_frame_centerline_pace",demo);
        }
        // Synthetic maximal fragmentation verifies bounded multi-chunk output.
        lookup.bands=120;lookup.boundaryCount=121;
        for(unsigned i=0;i<121;++i){lookup.rows[i]=uint8_t(104+i);lookup.centersQ8[i]=(i&1)?-257:257;if(i<120)lookup.materials[i]=i&1;}
        Stream stream;std::vector<uint8_t> bytes;unsigned chunks=0;
        lookup.emitTo(stream,[&](const uint8_t *p,unsigned n){assert(n&&n<=4096);++chunks;bytes.insert(bytes.end(),p,p+n);});
        assert(chunks>1&&!stream.overflow&&bytes==expected(lookup,false));
    }
}
