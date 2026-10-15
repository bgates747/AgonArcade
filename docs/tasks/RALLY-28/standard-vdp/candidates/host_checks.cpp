#include "shared_scene.hpp"
#include "buffered.hpp"
#include <algorithm>
#include <cassert>
#include <cstdio>
#include <map>
#include <string>
#include <vector>
using namespace rally;
// Independent small interpreter for the exact buffer operations used by this
// prototype. The real stock firmware is separately exercised on Oryx.
struct Machine {
    std::map<unsigned,std::vector<uint8_t>> buffers;std::vector<uint8_t> output;
    static unsigned word(const std::vector<uint8_t>&b,size_t &at){assert(at+2<=b.size());unsigned n=b[at]|unsigned(b[at+1])<<8;at+=2;return n;}
    void execute(const std::vector<uint8_t> bytes,unsigned depth=0) {
        assert(depth<8);size_t at=0;
        while(at<bytes.size()) {
            if(bytes[at]==18 || bytes[at]==25) {const unsigned n=bytes[at]==18?3:6;assert(at+n<=bytes.size());output.insert(output.end(),bytes.begin()+at,bytes.begin()+at+n);at+=n;continue;}
            assert(at+6<=bytes.size() && bytes[at]==23 && bytes[at+1]==0 && bytes[at+2]==160);at+=3;
            const unsigned id=word(bytes,at),op=bytes[at++];
            if(op==2){buffers.erase(id);continue;}
            if(op==0){const unsigned n=word(bytes,at);assert(at+n<=bytes.size());buffers[id].insert(buffers[id].end(),bytes.begin()+at,bytes.begin()+at+n);at+=n;continue;}
            if(op==1){assert(buffers.count(id));execute(buffers[id],depth+1);continue;}
            assert(op==5);const unsigned mode=bytes[at++],dest=word(bytes,at),n=word(bytes,at);assert(mode==0xc2||mode==0xe2);
            std::vector<uint8_t> source;
            if(mode==0xe2){const unsigned src=word(bytes,at),off=word(bytes,at);assert(off+n<=buffers.at(src).size());source.assign(buffers[src].begin()+off,buffers[src].begin()+off+n);}
            else {assert(at+n<=bytes.size());source.assign(bytes.begin()+at,bytes.begin()+at+n);at+=n;}
            assert(dest+n<=buffers.at(id).size());std::copy(source.begin(),source.end(),buffers[id].begin()+dest);
        }
    }
};
int main(int argc,char**argv) {
    assert(argc==2);unsigned poses=0,objects=0;int minimum=0,maximum=0,maxCoarseError=0;
    for(const auto *track:{&Fuji,&TriOval}) {
        const std::string name=track==&Fuji?"fuji":"oval";r28::SharedRoad road;road.track=track;road.init();assert(road.load((std::string(argv[1])+"/"+name+".road").c_str()));
        LookupRoad legacy;legacy.track=track;legacy.init();assert(legacy.load((std::string(argv[1])+"/"+name+".road").c_str()));
        const int32_t lap=track->length*100;
        for(int32_t position=0;position<lap;position+=3200) {
            const auto a=r28::tangentAt(position,*track);const auto b=trackSample(position/100*256+(position%100)*256/100,*track);
            assert(a.tx==b.tx&&a.ty==b.ty);
            for(int phase:{0,3999,4000,7999})for(bool coarse:{false,true}) {
                road.coarse=coarse;road.project(position,phase);legacy.project(position,phase);
                assert(road.rows[0]==104&&road.rows[road.bands]==224);
                for(unsigned i=0;i<road.bands;++i)assert(road.rows[i]<road.rows[i+1]);
                for(int y=103;y<=224;++y) {
                    const int center=road.centerAt(y);minimum=std::min(minimum,center);maximum=std::max(maximum,center);
                    assert(center>-32000&&center<32000);
                    for(unsigned e=0;e<10;++e)assert(road.edgeAt(y,e)==center+r28::EdgeOffset[y-103][e]);
                    if(!coarse)assert(center==sectionCentrePixel(legacy.centerQ8At(y)));
                    else maxCoarseError=std::max(maxCoarseError,std::abs(center-sectionCentrePixel(legacy.centerQ8At(y))));
                }
                Stream direct,buffered;std::vector<uint8_t> expected,packed;
                road.emitTo(direct,[&](const uint8_t*p,unsigned n){expected.insert(expected.end(),p,p+n);});
                Machine m;std::vector<uint8_t> setup;
                r28::templates([&](const uint8_t*p,unsigned n){setup.insert(setup.end(),p,p+n);});m.execute(setup);assert(m.output.empty());
                r28::emitBuffered(road,buffered,[&](const uint8_t*p,unsigned n){packed.insert(packed.end(),p,p+n);});m.execute(packed);assert(m.output==expected);
                assert(!direct.overflow&&!buffered.overflow);
                // All stripes retained; coarse changes geometry, not material cadence.
                for(int y=104;y<224;++y) {
                    unsigned i=0,j=0;while(road.rows[i+1]<=y)++i;while(legacy.rows[j+1]<=y)++j;
                    assert(road.materials[i]==legacy.materials[j]);
                }
                Motion motion;motion.track=track;motion.position=position;motion.phase=phase;motion.lateral=(poses&1)?38400:-38400;
                Traffic traffic;game::RaceTraffic routes;routes.reset(game::Policy::Circuit,lap,7,2);routes.view(traffic,position);
                SceneryHistory history;volatile r18::SceneState scene{};r28::prepareScene(motion,traffic,routes,road,history,scene,false);
                assert(scene.playerCentre==road.centerAt(214)+int(motion.lateral)*118/12800);
                r28::SharedSigns signs;signs.prepare(motion,road);
                for(unsigned i=0;i<signs.total;++i)assert(signs.station[i]==game::wrap(int32_t(i)*lap/int32_t(signs.total)+24000,lap));
                objects+=scene.cars+signs.count;++poses;
            }
        }
    }
    for(int z=64;z<=1100;++z)assert(r28::SharedRoad::depthRow(z)==96+8000/z);
    // Finish-line incremental subdivisions equal the original quotient rule.
    for(int y=104;y<=223;++y){const int span=2*r28::EdgeOffset[y-103][3],step=span/12,rem=span-step*12;int edge=0,credit=0;
        for(int i=1;i<=12;++i){edge+=step;credit+=rem;if(credit>=12){++edge;credit-=12;}assert(edge==span*i/12);}}
    printf("{\"poses\":%u,\"object_cases\":%u,\"min_centre\":%d,\"max_centre\":%d,\"max_coarse_centre_difference_px\":%d,\"depth_values\":1037,\"buffered_streams_equal_direct\":true}\n",poses,objects,minimum,maximum,maxCoarseError);
}
